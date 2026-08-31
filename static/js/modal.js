/* =========================================================
   STAYGRID — MODAL SYSTEM
   ========================================================= */

document.addEventListener("DOMContentLoaded", () => {

    initModalTriggers();
    initModalClosing();

});


/* =========================================================
   OPEN
   ========================================================= */

function initModalTriggers() {

    document
        .querySelectorAll("[data-modal-open]")
        .forEach((trigger) => {

            trigger.addEventListener(
                "click",
                () => {

                    const modalId =
                        trigger.dataset.modalOpen;

                    const modal =
                        document.getElementById(
                            modalId
                        );

                    if (!modal) {
                        return;
                    }

                    openModal(modal);

                }
            );

        });
}


/* =========================================================
   CLOSE
   ========================================================= */

function initModalClosing() {

    document
        .querySelectorAll(
            ".modal-backdrop"
        )
        .forEach((modal) => {

            modal.addEventListener(
                "click",
                (event) => {

                    if (
                        event.target === modal ||
                        event.target.closest(
                            "[data-modal-close]"
                        )
                    ) {

                        closeModal(modal);

                    }

                }
            );

        });


    document.addEventListener(
        "keydown",
        (event) => {

            if (event.key !== "Escape") {
                return;
            }

            document
                .querySelectorAll(
                    ".modal-backdrop.is-open"
                )
                .forEach(closeModal);

        }
    );
}


/* =========================================================
   FUNCTIONS
   ========================================================= */

function openModal(modal) {

    modal.classList.add("is-open");

    document.body.classList.add(
        "modal-open"
    );

    const focusable =
        modal.querySelector(
            "button, input, select, textarea, a"
        );

    if (focusable) {
        window.setTimeout(
            () => focusable.focus(),
            100
        );
    }
}


function closeModal(modal) {

    modal.classList.remove("is-open");

    if (
        !document.querySelector(
            ".modal-backdrop.is-open"
        )
    ) {

        document.body.classList.remove(
            "modal-open"
        );

    }
}


window.StayGridModal = {
    open: openModal,
    close: closeModal
};