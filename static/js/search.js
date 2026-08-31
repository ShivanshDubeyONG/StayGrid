/* =========================================================
   STAYGRID — SEARCH EXPERIENCE
   ========================================================= */

document.addEventListener("DOMContentLoaded", () => {

    document
        .querySelectorAll("[data-search-form]")
        .forEach(initSearchForm);

});


function initSearchForm(form) {

    const destination =
        form.querySelector(
            '[name="location"], [name="destination"], [name="city"]'
        );

    const checkIn =
        form.querySelector(
            '[name="check_in"]'
        );

    const checkOut =
        form.querySelector(
            '[name="check_out"]'
        );

    const guests =
        form.querySelector(
            '[name="guests"]'
        );


    /* =====================================================
       DATES
       ===================================================== */

    if (checkIn && checkOut) {

        checkIn.addEventListener(
            "change",
            () => {

                if (!checkIn.value) {
                    return;
                }

                const minimum =
                    new Date(
                        `${checkIn.value}T00:00:00`
                    );

                minimum.setDate(
                    minimum.getDate() + 1
                );

                const year =
                    minimum.getFullYear();

                const month =
                    String(
                        minimum.getMonth() + 1
                    ).padStart(2, "0");

                const day =
                    String(
                        minimum.getDate()
                    ).padStart(2, "0");

                checkOut.min =
                    `${year}-${month}-${day}`;

                if (
                    checkOut.value &&
                    checkOut.value <= checkIn.value
                ) {
                    checkOut.value = "";
                }

            }
        );

    }


    /* =====================================================
       GUESTS
       ===================================================== */

    if (guests) {

        guests.addEventListener(
            "input",
            () => {

                let value =
                    parseInt(
                        guests.value,
                        10
                    );

                if (
                    Number.isNaN(value)
                ) {
                    value = 1;
                }

                guests.value =
                    Math.min(
                        Math.max(value, 1),
                        20
                    );

            }
        );

    }


    /* =====================================================
       SEARCH SUBMIT
       ===================================================== */

    form.addEventListener(
        "submit",
        (event) => {

            if (
                checkIn &&
                checkOut &&
                checkIn.value &&
                checkOut.value &&
                checkOut.value <= checkIn.value
            ) {

                event.preventDefault();

                showSearchError(
                    form,
                    "Choose a checkout date after check-in."
                );

                return;
            }


            if (
                destination &&
                !destination.value.trim()
            ) {

                event.preventDefault();

                destination.focus();

                showSearchError(
                    form,
                    "Tell us where you're going first."
                );

                return;
            }


            const submit =
                form.querySelector(
                    'button[type="submit"]'
                );

            if (submit) {

                submit.disabled = true;

                submit.dataset.originalText =
                    submit.textContent;

                submit.textContent =
                    "Searching…";

            }

        }
    );

}


function showSearchError(form, message) {

    let error =
        form.querySelector(
            ".search-error"
        );

    if (!error) {

        error =
            document.createElement("div");

        error.className =
            "search-error";

        form.appendChild(error);

    }

    error.textContent = message;

    window.setTimeout(() => {

        if (error.parentNode) {
            error.remove();
        }

    }, 3000);

}