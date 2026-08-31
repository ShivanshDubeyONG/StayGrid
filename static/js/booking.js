document.addEventListener("DOMContentLoaded", () => {
    const form = document.querySelector("[data-booking-form]");

    if (!form) return;

    const checkIn = form.querySelector("#check_in");
    const checkOut = form.querySelector("#check_out");

    const nightsOutput =
        document.querySelector("[data-booking-nights]");

    const totalOutput =
        document.querySelector("[data-booking-total]");

    const submitButton =
        form.querySelector('button[type="submit"]');

    const price = Number(form.dataset.price || 0);


    /* =====================================================
       DATE HELPERS
       ===================================================== */

    const today = new Date();

    today.setHours(0, 0, 0, 0);

    const formatDate = (date) => {
        const year = date.getFullYear();

        const month = String(
            date.getMonth() + 1
        ).padStart(2, "0");

        const day = String(
            date.getDate()
        ).padStart(2, "0");

        return `${year}-${month}-${day}`;
    };


    /* =====================================================
       MINIMUM CHECK-IN
       ===================================================== */

    if (checkIn) {
        checkIn.min = formatDate(today);
    }


    /* =====================================================
       CALCULATE STAY
       ===================================================== */

    function updateSummary() {

        if (!checkIn?.value || !checkOut?.value) {

            if (nightsOutput) {
                nightsOutput.textContent = "Select dates";
            }

            if (totalOutput) {
                totalOutput.textContent =
                    `₹${price.toLocaleString("en-IN")}`;
            }

            return;
        }


        const start =
            new Date(`${checkIn.value}T00:00:00`);

        const end =
            new Date(`${checkOut.value}T00:00:00`);


        const milliseconds =
            end.getTime() - start.getTime();


        const nights =
            Math.ceil(
                milliseconds /
                (1000 * 60 * 60 * 24)
            );


        if (nights <= 0) {

            if (nightsOutput) {
                nightsOutput.textContent =
                    "Invalid dates";
            }

            if (totalOutput) {
                totalOutput.textContent = "—";
            }

            return;
        }


        const total = price * nights;


        if (nightsOutput) {

            nightsOutput.textContent =
                `${nights} ${
                    nights === 1 ? "night" : "nights"
                }`;

        }


        if (totalOutput) {

            totalOutput.textContent =
                `₹${total.toLocaleString("en-IN")}`;

        }
    }


    /* =====================================================
       CHECK-OUT CONSTRAINT
       ===================================================== */

    if (checkIn && checkOut) {

        checkIn.addEventListener("change", () => {

            if (checkIn.value) {

                const nextDay =
                    new Date(
                        `${checkIn.value}T00:00:00`
                    );

                nextDay.setDate(
                    nextDay.getDate() + 1
                );

                checkOut.min =
                    formatDate(nextDay);

                if (
                    checkOut.value &&
                    checkOut.value <= checkIn.value
                ) {
                    checkOut.value = "";
                }

            }

            updateSummary();
        });


        checkOut.addEventListener(
            "change",
            updateSummary
        );
    }


    /* =====================================================
       FORM PROTECTION
       ===================================================== */

    form.addEventListener("submit", (event) => {

        if (!checkIn?.value || !checkOut?.value) {

            event.preventDefault();

            return;
        }


        if (checkOut.value <= checkIn.value) {

            event.preventDefault();

            alert(
                "Your check-out date must be after check-in."
            );

            return;
        }


        if (submitButton) {

            submitButton.disabled = true;

            submitButton.textContent =
                "Confirming your stay…";

        }
    });


    updateSummary();
});