/* =========================================================
   STAYGRID — SEARCH EXPERIENCE
   Destination autocomplete + dates + guests
   ========================================================= */
document.addEventListener("DOMContentLoaded", () => {

    const input = document.getElementById("search-location");

    const suggestions = document.getElementById(
        "destination-suggestions"
    );

    if (!input || !suggestions) {
        return;
    }

    // ... your autocomplete code
});

const STAYGRID_PLACES = [
    // INDIA — MAJOR CITIES
    "Agra",
    "Ahmedabad",
    "Amritsar",
    "Aurangabad",
    "Bengaluru",
    "Bhopal",
    "Bhubaneswar",
    "Chandigarh",
    "Chennai",
    "Coimbatore",
    "Dehradun",
    "Delhi",
    "Faridabad",
    "Gandhinagar",
    "Ghaziabad",
    "Goa",
    "Gurugram",
    "Guwahati",
    "Gwalior",
    "Hyderabad",
    "Indore",
    "Jaipur",
    "Jaisalmer",
    "Jalandhar",
    "Jammu",
    "Jodhpur",
    "Kanpur",
    "Kochi",
    "Kolkata",
    "Kota",
    "Lucknow",
    "Ludhiana",
    "Madurai",
    "Mangaluru",
    "Meerut",
    "Mumbai",
    "Mysuru",
    "Nagpur",
    "Nashik",
    "Noida",
    "Patna",
    "Pondicherry",
    "Prayagraj",
    "Pune",
    "Raipur",
    "Rajkot",
    "Ranchi",
    "Rishikesh",
    "Shimla",
    "Srinagar",
    "Surat",
    "Thane",
    "Thiruvananthapuram",
    "Udaipur",
    "Vadodara",
    "Varanasi",
    "Vijayawada",
    "Visakhapatnam",

    // POPULAR INDIAN DESTINATIONS
    "Alappuzha",
    "Andaman Islands",
    "Bandhavgarh",
    "Bikaner",
    "Coorg",
    "Darjeeling",
    "Dharamshala",
    "Jim Corbett",
    "Kanha",
    "Kasol",
    "Kashmir",
    "Kodaikanal",
    "Ladakh",
    "Lonavala",
    "Manali",
    "Matheran",
    "Mount Abu",
    "Mussoorie",
    "Nainital",
    "Ooty",
    "Pahalgam",
    "Pushkar",
    "Ranthambore",
    "Rishikesh",
    "Shillong",
    "Spiti Valley",
    "Tawang",
    "Thekkady",
    "Varkala",
    "Wayanad",

    // INTERNATIONAL
    "Amsterdam",
    "Athens",
    "Auckland",
    "Barcelona",
    "Bangkok",
    "Beijing",
    "Berlin",
    "Boston",
    "Brussels",
    "Budapest",
    "Cairo",
    "Cape Town",
    "Chicago",
    "Copenhagen",
    "Dubai",
    "Dublin",
    "Edinburgh",
    "Florence",
    "Hong Kong",
    "Istanbul",
    "Jakarta",
    "Lisbon",
    "London",
    "Los Angeles",
    "Madrid",
    "Melbourne",
    "Miami",
    "Milan",
    "Montreal",
    "Munich",
    "New Delhi",
    "New York",
    "Osaka",
    "Paris",
    "Prague",
    "Rome",
    "San Francisco",
    "Seoul",
    "Singapore",
    "Sydney",
    "Tokyo",
    "Toronto",
    "Vancouver",
    "Vienna",
    "Zurich"
];


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
        form.querySelector('[name="check_in"]');

    const checkOut =
        form.querySelector('[name="check_out"]');

    const guests =
        form.querySelector('[name="guests"]');


    /* =====================================================
       DESTINATION AUTOCOMPLETE
       ===================================================== */

    if (destination) {
        initDestinationAutocomplete(
            destination,
            form
        );
    }


    /* =====================================================
       DATES
       ===================================================== */

    if (checkIn && checkOut) {

        checkIn.addEventListener("change", () => {

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

        });

    }


    /* =====================================================
       GUESTS
       ===================================================== */

    if (guests) {

        guests.addEventListener("input", () => {

            let value =
                parseInt(
                    guests.value,
                    10
                );

            if (Number.isNaN(value)) {
                value = 1;
            }

            guests.value =
                Math.min(
                    Math.max(value, 1),
                    20
                );

        });

    }


    /* =====================================================
       SEARCH SUBMIT
       ===================================================== */

    form.addEventListener("submit", (event) => {

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

    });

}


/* =========================================================
   DESTINATION AUTOCOMPLETE
   ========================================================= */

function initDestinationAutocomplete(input, form) {

    const wrapper =
        document.createElement("div");

    wrapper.className =
        "destination-autocomplete";

    input.parentNode.insertBefore(
        wrapper,
        input
    );

    wrapper.appendChild(input);

    const results =
        document.createElement("div");

    results.className =
        "destination-results";

    results.setAttribute(
        "role",
        "listbox"
    );

    results.hidden = true;

    wrapper.appendChild(results);


    let activeIndex = -1;


    /* =====================================================
       INPUT
       ===================================================== */

    input.addEventListener("input", () => {

        const query =
            input.value
                .trim()
                .toLowerCase();

        activeIndex = -1;

        if (!query) {

            closeResults();

            return;
        }


        const matches =
            STAYGRID_PLACES
                .filter(place =>
                    place
                        .toLowerCase()
                        .includes(query)
                )
                .sort((a, b) => {

                    const aStarts =
                        a.toLowerCase()
                            .startsWith(query);

                    const bStarts =
                        b.toLowerCase()
                            .startsWith(query);

                    if (aStarts && !bStarts) {
                        return -1;
                    }

                    if (!aStarts && bStarts) {
                        return 1;
                    }

                    return a.localeCompare(b);

                })
                .slice(0, 6);


        renderResults(
            matches,
            query
        );

    });


    /* =====================================================
       KEYBOARD NAVIGATION
       ===================================================== */

    input.addEventListener("keydown", (event) => {

        if (results.hidden) {
            return;
        }

        const items =
            results.querySelectorAll(
                ".destination-result"
            );

        if (!items.length) {
            return;
        }


        if (event.key === "ArrowDown") {

            event.preventDefault();

            activeIndex =
                Math.min(
                    activeIndex + 1,
                    items.length - 1
                );

            updateActiveItem(items);

        }


        if (event.key === "ArrowUp") {

            event.preventDefault();

            activeIndex =
                Math.max(
                    activeIndex - 1,
                    0
                );

            updateActiveItem(items);

        }


        if (event.key === "Enter") {

            if (activeIndex >= 0) {

                event.preventDefault();

                items[
                    activeIndex
                ].click();

            }

        }


        if (event.key === "Escape") {

            closeResults();

        }

    });


    /* =====================================================
       CLICK OUTSIDE
       ===================================================== */

    document.addEventListener("click", (event) => {

        if (!wrapper.contains(event.target)) {
            closeResults();
        }

    });


    function renderResults(matches, query) {

        results.innerHTML = "";

        if (!matches.length) {

            closeResults();

            return;
        }


        matches.forEach((place, index) => {

            const item =
                document.createElement("button");

            item.type = "button";

            item.className =
                "destination-result";

            item.setAttribute(
                "role",
                "option"
            );


            item.innerHTML = `
                <span class="destination-result-icon">
                    ⌖
                </span>

                <span class="destination-result-text">
                    ${highlightMatch(place, query)}
                </span>
            `;


            item.addEventListener("click", () => {

                input.value = place;

                closeResults();

                input.dispatchEvent(
                    new Event("change", {
                        bubbles: true
                    })
                );

            });


            results.appendChild(item);

        });


        results.hidden = false;

    }


    function updateActiveItem(items) {

        items.forEach((item, index) => {

            item.classList.toggle(
                "is-active",
                index === activeIndex
            );

        });

    }


    function closeResults() {

        results.hidden = true;

        activeIndex = -1;

    }

}


/* =========================================================
   HIGHLIGHT SEARCH MATCH
   ========================================================= */

function highlightMatch(text, query) {

    const index =
        text
            .toLowerCase()
            .indexOf(query.toLowerCase());

    if (index === -1) {
        return escapeHtml(text);
    }


    const before =
        text.slice(0, index);

    const match =
        text.slice(
            index,
            index + query.length
        );

    const after =
        text.slice(
            index + query.length
        );


    return `
        ${escapeHtml(before)}
        <strong>${escapeHtml(match)}</strong>
        ${escapeHtml(after)}
    `;

}


/* =========================================================
   HTML SAFETY
   ========================================================= */

function escapeHtml(value) {

    return value
        .replaceAll("&", "&amp;")
        .replaceAll("<", "&lt;")
        .replaceAll(">", "&gt;")
        .replaceAll('"', "&quot;")
        .replaceAll("'", "&#039;");

}


/* =========================================================
   SEARCH ERROR
   ========================================================= */

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

    error.textContent =
        message;


    window.setTimeout(() => {

        if (error.parentNode) {
            error.remove();
        }

    }, 3000);

}