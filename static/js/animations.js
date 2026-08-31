/* =========================================================
   STAYGRID — MOTION ENGINE
   ========================================================= */

document.addEventListener("DOMContentLoaded", () => {

    const animatedElements =
        document.querySelectorAll(
            "[data-reveal]"
        );

    if (!animatedElements.length) {
        return;
    }


    /* =====================================================
       ACCESSIBILITY
       ===================================================== */

    const reduceMotion =
        window.matchMedia(
            "(prefers-reduced-motion: reduce)"
        ).matches;

    if (reduceMotion) {

        animatedElements.forEach((element) => {
            element.classList.add("is-visible");
        });

        return;
    }


    /* =====================================================
       INTERSECTION OBSERVER
       ===================================================== */

    if (!("IntersectionObserver" in window)) {

        animatedElements.forEach((element) => {
            element.classList.add("is-visible");
        });

        return;
    }


    const observer =
        new IntersectionObserver(
            (entries, observerInstance) => {

                entries.forEach((entry) => {

                    if (!entry.isIntersecting) {
                        return;
                    }

                    const element =
                        entry.target;

                    const delay =
                        element.dataset.revealDelay;

                    if (delay) {
                        element.style.animationDelay =
                            `${delay}ms`;
                    }

                    element.classList.add(
                        "is-visible"
                    );

                    observerInstance.unobserve(
                        element
                    );

                });

            },
            {
                threshold: 0.12,
                rootMargin:
                    "0px 0px -50px 0px"
            }
        );


    animatedElements.forEach((element) => {
        observer.observe(element);
    });

});