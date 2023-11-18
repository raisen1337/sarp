function createNotification(title, message, type) {
    // Create a new notification element
    const notificationElement = document.createElement("div");
    notificationElement.classList.add("notification");

    if(type == 'success'){
      notificationElement.style.boxShadow = 'inset 40px 0 50px rgba(255, 217, 0, 0.2)';
    }else if(type == 'error') {
      notificationElement.style.boxShadow = 'inset 40px 0 50px rgba(255, 0, 0, 0.2)';
    }

    // Create the icon element (you can customize this class or use your existing one)
    const iconElement = document.createElement("i");

    if(type == 'success'){
      iconElement.classList.add("fa-solid", "fa-check", "notification-icon");
    }else if(type == 'error'){
      iconElement.classList.add("fa-solid", "fa-x", "notification-icon");
    }


    // Create the notification content container
    const contentElement = document.createElement("div");
    contentElement.classList.add("notification-content");

    // Create title and message elements
    const titleElement = document.createElement("span");
    titleElement.classList.add("notification-title");
    titleElement.textContent = title;

    const messageElement = document.createElement("span");
    messageElement.classList.add("notification-message");
    messageElement.textContent = message;

    // Append title and message to the content container
    contentElement.appendChild(titleElement);
    contentElement.appendChild(messageElement);

    // Append icon and content container to the notification element
    notificationElement.appendChild(iconElement);
    notificationElement.appendChild(contentElement);

    // Append the notification to the .notifications container
    const notificationsContainer = document.querySelector(".notifications");
    notificationsContainer.appendChild(notificationElement);

    // Add class .appear to make the notification appear with an animation
    setTimeout(() => {
      notificationElement.classList.add("appear");
    }, 10);
    if(type == 'success'){
      const audio = new Audio('./assets/notify.mp3');
      audio.volume = 0.3;
      audio.play();
    }else if(type == 'error'){
      const audio = new Audio('./assets/notiferr.mp3');
      audio.volume = 0.3;
      audio.play();
    }
    // Remove .appear and add .disappear after 5 seconds
    setTimeout(() => {
      notificationElement.classList.remove("appear");
      notificationElement.classList.add("disappear");
    }, 5000);

    // Remove the notification from HTML after 6.5 seconds (1.5s after .disappear)
    setTimeout(() => {
      notificationElement.remove();
    }, 6500);
}

window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "notify") {
        createNotification(event.title, event.msg, event.type)
    }
});