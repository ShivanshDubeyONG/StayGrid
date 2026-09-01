/* =========================================================
   STAYGRID — DESTINATION AUTOCOMPLETE
   ========================================================= */

const STAYGRID_PLACES = [
    // Major Indian cities
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
    "New Delhi",
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

    // Indian destinations
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
    "Shillong",
    "Spiti Valley",
    "Tawang",
    "Thekkady",
    "Varkala",
    "Wayanad",

    // International
    "Amsterdam",
    "Athens",
    "Auckland",
    "Bangkok",
    "Barcelona",
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

    const input = document.querySelector(
        '[name="location"], [name="destination"], [name="city"]'
    );

    if (!input) return;

    createDestinationAutocomplete(input);
});


function createDestinationAutocomplete(input) {

    const wrapper = document.createElement("div");

    wrapper.className = "destination-autocomplete";

    input.parentNode.insertBefore(wrapper, input);

    wrapper.appendChild(input);


    const dropdown = document.createElement("div");

    dropdown.className = "destination-dropdown";

    dropdown.setAttribute("role", "listbox");

    wrapper.appendChild(dropdown);


    let activeIndex = -1;


    input.addEventListener("input", () => {

        const query = input.value.trim().toLowerCase();

        activeIndex = -1;

        dropdown.innerHTML = "";


        if (!query) {

            dropdown.classList.remove("is-visible");

            return;
        }


        const matches = STAYGRID_PLACES
            .filter(place =>
                place.toLowerCase().includes(query)
            )
            .sort((a, b) => {

                const aStarts =
                    a.toLowerCase().startsWith(query);

                const bStarts =
                    b.toLowerCase().startsWith(query);

                if (aStarts && !bStarts) return -1;

                if (!aStarts && bStarts) return 1;

                return a.localeCompare(b);
            })
            .slice(0, 7);


        if (!matches.length) {

            dropdown.classList.remove("is-visible");

            return;
        }


        matches.forEach((place, index) => {

            const item = document.createElement("button");

            item.type = "button";

            item.className = "destination-option";

            item.setAttribute("role", "option");


            item.innerHTML = `
                <span class="destination-icon">⌖</span>

                <span class="destination-name">
                    ${highlight(place, query)}
                </span>
            `;


            item.addEventListener("click", () => {

                input.value = place;

                dropdown.classList.remove("is-visible");

                input.focus();
            });


            dropdown.appendChild(item);
        });


        dropdown.classList.add("is-visible");
    });


    input.addEventListener("keydown", event => {

        const options =
            dropdown.querySelectorAll(".destination-option");


        if (!options.length) return;


        if (event.key === "ArrowDown") {

            event.preventDefault();

            activeIndex =
                Math.min(activeIndex + 1, options.length - 1);

            updateActive(options);

        }


        else if (event.key === "ArrowUp") {

            event.preventDefault();

            activeIndex =
                Math.max(activeIndex - 1, 0);

            updateActive(options);

        }


        else if (
            event.key === "Enter" &&
            activeIndex >= 0
        ) {

            event.preventDefault();

            options[activeIndex].click();

        }


        else if (event.key === "Escape") {

            dropdown.classList.remove("is-visible");

        }

    });


    document.addEventListener("click", event => {

        if (!wrapper.contains(event.target)) {

            dropdown.classList.remove("is-visible");

        }

    });
}


function updateActive(options) {

    options.forEach((option, index) => {

        option.classList.toggle(
            "is-active",
            index === activeIndex
        );

    });
}

function highlight(text, query) {
    const index = text.toLowerCase().indexOf(query.toLowerCase());

    if (index === -1) {
        return text;
    }

    return (
        text.slice(0, index) +
        `<span class="destination-match">${text.slice(index, index + query.length)}</span>` +
        text.slice(index + query.length)
    );
}