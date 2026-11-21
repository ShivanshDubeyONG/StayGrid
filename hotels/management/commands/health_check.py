"""
Django management command for system health checks.
Validates database connectivity, unapplied migrations, and cache responsiveness.

Usage:
    python manage.py health_check
"""

import sys
import time
from django.conf import settings
from django.core.cache import cache
from django.core.management.base import BaseCommand
from django.db import connection
from django.db.migrations.executor import MigrationExecutor


class Command(BaseCommand):
    help = "Performs health checks on database connectivity, pending migrations, and caching."

    def add_arguments(self, parser):
        parser.add_argument(
            "--strict",
            action="store_true",
            help="Exit with non-zero exit code if any warning or check fails.",
        )

    def handle(self, *args, **options):
        strict = options.get("strict", False)
        all_passed = True

        self.stdout.write(self.style.MIGRATE_HEADING("=== StayGrid System Health Check ==="))

        # 1. Database Check
        try:
            start_time = time.perf_counter()
            with connection.cursor() as cursor:
                cursor.execute("SELECT 1;")
                cursor.fetchone()
            duration_ms = (time.perf_counter() - start_time) * 1000.0
            self.stdout.write(
                self.style.SUCCESS(f"  [✓] Database: Connected successfully ({duration_ms:.1f}ms latency)")
            )
        except Exception as e:
            all_passed = False
            self.stderr.write(self.style.ERROR(f"  [✗] Database: Connection failed ({e})"))

        # 2. Migration Status
        try:
            executor = MigrationExecutor(connection)
            targets = executor.loader.graph.leaf_nodes()
            plan = executor.migration_plan(targets)
            if plan:
                unapplied_count = len(plan)
                self.stdout.write(
                    self.style.WARNING(f"  [!] Migrations: {unapplied_count} unapplied migration(s) pending.")
                )
                if strict:
                    all_passed = False
            else:
                self.stdout.write(self.style.SUCCESS("  [✓] Migrations: All database migrations applied."))
        except Exception as e:
            all_passed = False
            self.stderr.write(self.style.ERROR(f"  [✗] Migrations: Could not inspect migration state ({e})"))

        # 3. Cache Check
        try:
            test_key = "__staygrid_health_check__"
            cache.set(test_key, "ok", timeout=10)
            result = cache.get(test_key)
            if result == "ok":
                cache.delete(test_key)
                self.stdout.write(self.style.SUCCESS("  [✓] Cache: Read/write operational."))
            else:
                self.stdout.write(self.style.WARNING("  [!] Cache: Returned unexpected value."))
        except Exception as e:
            self.stdout.write(self.style.WARNING(f"  [!] Cache: Cache check failed ({e})"))

        # Summary
        if all_passed:
            self.stdout.write(self.style.SUCCESS("\nAll critical system checks passed successfully."))
        else:
            self.stderr.write(self.style.ERROR("\nHealth check encountered one or more failures."))
            sys.exit(1)
