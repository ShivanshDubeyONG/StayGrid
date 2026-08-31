document.addEventListener("DOMContentLoaded", () => {

    const nav = document.getElementById("site-nav");
    const button = document.getElementById(
        "mobile-menu-button"
    );
    const links = document.getElementById(
        "nav-links"
    );

    if (!nav) return;

    window.addEventListener(
        "scroll",
        () => {

            if (window.scrollY > 10) {
                nav.classList.add("scrolled");
            } else {
                nav.classList.remove("scrolled");
            }

        },
        { passive: true }
    );

    if (!button || !links) return;

    button.addEventListener("click", () => {

        const open = links.classList.toggle(
            "mobile-open"
        );

        button.setAttribute(
            "aria-expanded",
            open
        );

    });

});