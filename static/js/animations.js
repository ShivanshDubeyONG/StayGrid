document.addEventListener("DOMContentLoaded", () => {

    const elements = document.querySelectorAll(
        "[data-animate]"
    );

    if (!elements.length) return;

    const observer = new IntersectionObserver(
        (entries, observer) => {

            entries.forEach((entry) => {

                if (!entry.isIntersecting) return;

                entry.target.classList.add(
                    "animate-in"
                );

                observer.unobserve(
                    entry.target
                );

            });

        },
        {
            threshold: 0.12,
        }
    );

    elements.forEach((element) => {
        observer.observe(element);
    });

});