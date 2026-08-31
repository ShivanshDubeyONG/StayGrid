document.addEventListener("DOMContentLoaded", () => {

    const flashMessages = document.querySelectorAll(
        ".flash-message"
    );

    flashMessages.forEach((message) => {

        setTimeout(() => {

            message.style.opacity = "0";
            message.style.transform = "translateY(-8px)";

            setTimeout(() => {
                message.remove();
            }, 250);

        }, 4500);

    });

});