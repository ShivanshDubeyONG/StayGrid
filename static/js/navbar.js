/* =========================================================
   STAYGRID — NAVIGATION
   ========================================================= */

document.addEventListener("DOMContentLoaded", () => {

    const nav =
        document.querySelector(".site-nav");

    const menuButton =
        document.querySelector(
            "#mobile-menu-button"
        );

    const navLinks =
        document.querySelector("#nav-links");


    if (!nav) {
        return;
    }


    /* =====================================================
       SCROLL STATE
       ===================================================== */

    function updateNav() {

        if (window.scrollY > 15) {
            nav.classList.add("scrolled");
        } else {
            nav.classList.remove("scrolled");
        }

    }

    updateNav();

    window.addEventListener(
        "scroll",
        updateNav,
        { passive: true }
    );


    /* =====================================================
       MOBILE MENU
       ===================================================== */

    if (!menuButton || !navLinks) {
        return;
    }


    menuButton.addEventListener(
        "click",
        () => {

            const open =
                navLinks.classList.toggle(
                    "mobile-open"
                );

            menuButton.setAttribute(
                "aria-expanded",
                String(open)
            );

            menuButton.setAttribute(
                "aria-label",
                open
                    ? "Close navigation"
                    : "Open navigation"
            );

            menuButton.textContent =
                open ? "×" : "☰";

        }
    );


    /* =====================================================
       CLOSE AFTER NAVIGATION
       ===================================================== */

    navLinks
        .querySelectorAll("a")
        .forEach((link) => {

            link.addEventListener(
                "click",
                () => {

                    navLinks.classList.remove(
                        "mobile-open"
                    );

                    menuButton.setAttribute(
                        "aria-expanded",
                        "false"
                    );

                    menuButton.textContent =
                        "☰";

                }
            );

        });


    /* =====================================================
       CLICK OUTSIDE
       ===================================================== */

    document.addEventListener(
        "click",
        (event) => {

            if (
                navLinks.classList.contains(
                    "mobile-open"
                ) &&
                !nav.contains(event.target)
            ) {

                navLinks.classList.remove(
                    "mobile-open"
                );

                menuButton.setAttribute(
                    "aria-expanded",
                    "false"
                );

                menuButton.textContent =
                    "☰";

            }

        }
    );

});