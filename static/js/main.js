/* =========================================================
   STAYGRID — GLOBAL INTERACTIONS
   ========================================================= */

document.addEventListener("DOMContentLoaded", () => {
    initFlashMessages();
    initImageFallbacks();
    initSmoothScrolling();
    initCurrentYear();
    initButtonLoading();
});


/* =========================================================
   FLASH MESSAGES
   ========================================================= */

function initFlashMessages() {
    const messages = document.querySelectorAll(
        ".flash-message"
    );

    messages.forEach((message) => {

        const closeButton = message.querySelector(
            ".flash-close"
        );

        if (closeButton) {
            closeButton.addEventListener(
                "click",
                () => removeFlash(message)
            );
        }

        window.setTimeout(() => {

            if (document.body.contains(message)) {
                removeFlash(message);
            }

        }, 5000);
    });
}


function removeFlash(message) {
    message.style.opacity = "0";
    message.style.transform = "translateY(-8px)";

    window.setTimeout(() => {

        if (message.parentNode) {
            message.remove();
        }

    }, 250);
}


/* =========================================================
   IMAGE FALLBACKS
   ========================================================= */

function initImageFallbacks() {

    document.querySelectorAll("img").forEach((image) => {

        image.addEventListener("error", () => {

            image.classList.add("image-load-failed");

            const parent = image.parentElement;

            if (!parent) {
                return;
            }

            parent.classList.add(
                "has-image-fallback"
            );

        });

    });
}


/* =========================================================
   SMOOTH SCROLLING
   ========================================================= */

function initSmoothScrolling() {

    document
        .querySelectorAll('a[href^="#"]')
        .forEach((link) => {

            link.addEventListener("click", (event) => {

                const targetId =
                    link.getAttribute("href");

                if (
                    !targetId ||
                    targetId === "#"
                ) {
                    return;
                }

                const target =
                    document.querySelector(targetId);

                if (!target) {
                    return;
                }

                event.preventDefault();

                target.scrollIntoView({
                    behavior: "smooth",
                    block: "start"
                });

            });

        });
}


/* =========================================================
   CURRENT YEAR
   ========================================================= */

function initCurrentYear() {

    document
        .querySelectorAll("[data-current-year]")
        .forEach((element) => {

            element.textContent =
                new Date().getFullYear();

        });
}


/* =========================================================
   BUTTON LOADING
   ========================================================= */

function initButtonLoading() {

    document
        .querySelectorAll(
            "form[data-loading-form]"
        )
        .forEach((form) => {

            form.addEventListener(
                "submit",
                () => {

                    const button =
                        form.querySelector(
                            'button[type="submit"]'
                        );

                    if (!button) {
                        return;
                    }

                    if (
                        button.disabled
                    ) {
                        return;
                    }

                    button.dataset.originalText =
                        button.textContent;

                    button.textContent =
                        "Working…";

                    button.disabled = true;

                }
            );

        });
}


/* =========================================================
   GLOBAL UTILITIES
   ========================================================= */

window.StayGrid = {

    formatCurrency(value) {

        return new Intl.NumberFormat(
            "en-IN",
            {
                style: "currency",
                currency: "INR",
                maximumFractionDigits: 0
            }
        ).format(value);

    },


    debounce(callback, delay = 250) {

        let timeout;

        return (...args) => {

            window.clearTimeout(timeout);

            timeout = window.setTimeout(
                () => callback(...args),
                delay
            );

        };

    }

};