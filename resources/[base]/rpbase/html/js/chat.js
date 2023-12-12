let chatMessages = {};
let chatSuggestions = {};
let chatContainer = document.querySelector(".chat");
let chatInput = document.querySelector(".chat-input");
let chatInputText = document.querySelector(".chat-input-text");
let chatMessagesContainer = document.querySelector(".messages");
let chatMessageLength = document.querySelector(".message-characters");
let chatSuggestionsContainer = document.querySelector(".chat-suggestions");

let chatOn = false;
function createChatMessage(messageText, hasDate) {
    // Create a new message element
    const newMessage = document.createElement("div");
    newMessage.classList.add("message");

    // Create a message-text span
    const messageTextSpan = document.createElement("span");
    messageTextSpan.classList.add("message-text", "popIn");

    // Create a span for the message date
    if (hasDate) {
        const dateSpan = document.createElement("span");
        dateSpan.classList.add("message-date");
        const currentDate = new Date();
        const hours = currentDate.getHours().toString().padStart(2, "0");
        const minutes = currentDate.getMinutes().toString().padStart(2, "0");
        const seconds = currentDate.getSeconds().toString().padStart(2, "0");
        const formattedTime = `${hours}:${minutes}:${seconds}`;

        // Set the formatted time as text content for the date span
        dateSpan.textContent = formattedTime;

        // Append the date to the message-text span
        messageTextSpan.appendChild(dateSpan);
    }

    // Get current time and format it

    // Add the message text to the message-text span
    messageTextSpan.innerHTML += messageText;

    // Append the message-text span to the new message element
    newMessage.appendChild(messageTextSpan);

    // Get the messages container and append the new message to it
    const messagesContainer = document.querySelector(".messages");
    messagesContainer.appendChild(newMessage);

    // Scroll to the bottom of the messages container
    messagesContainer.scrollTop = messagesContainer.scrollHeight;
}

function createChatSuggestion(suggestionText) {
    const iconClass = "fa-square-terminal";
    const suggestionsContainer = document.querySelector(".chat-suggestions");

    // Create suggestion elements
    const suggestion = document.createElement("span");
    suggestion.classList.add("chat-suggestion");

    const icon = document.createElement("i");
    icon.classList.add("fa-solid", iconClass);

    const suggestionTextSpan = document.createElement("span");
    suggestionTextSpan.classList.add("chat-suggestion-text");
    suggestionTextSpan.textContent = suggestionText;

    // Append suggestion elements
    suggestion.appendChild(icon);
    suggestion.appendChild(suggestionTextSpan);

    // Append the suggestion to the suggestions container
    suggestionsContainer.appendChild(suggestion);
}
chatMessagesContainer.style.display = "block";

function openChat() {
    chatInput.style.display = "flex";
    chatInputText.focus();
}

function hideChat() {
    chatInput.style.display = "none";
    chatSuggestionsContainer.style.display = "none";
}
function colorizeOld(str) {
    return `<span style="color: rgb(${this.color[0]}, ${this.color[1]}, ${this.color[2]})">${str}</span>`;
}

function colorize(str) {
    let s =
        "<span>" +
        str.replace(
            /\^([0-9])/g,
            (str, color) => `</span><span class="color-${color}">`
        ) +
        "</span>";

    const styleDict = {
        "*": "font-weight: bold;",
        _: "text-decoration: underline;",
        "~": "text-decoration: line-through;",
        "=": "text-decoration: underline line-through;",
        r: "text-decoration: none; font-weight: normal;",
        g: "color: #00c851;", // Green
        b: "color: #33b5e5;", // Blue
        y: "color: #ffbb33;", // Yellow
        p: "color: #aa66cc;", // Purple
        o: "color: #ff8800;", // Orange
        c: "color: #99cc00;", // Cyan
        m: "color: #ff00dd;", // Magenta
        w: "color: #ffffff;", // White
    };

    const styleRegex =
        /\^(\_|\*|\=|\~|\/|r|g|b|y|p|o|c|m|w)(.*?)(?=$|\^r|<\/em>)/;
    while (s.match(styleRegex)) {
        s = s.replace(
            styleRegex,
            (str, style, inner) =>
                `<em style="${styleDict[style]}">${inner}</em>`
        );
    }
    return s.replace(/<span[^>]*><\/span[^>]*>/g, "");
}

//disable tab switching when pressing tab in the chat input
chatInputText.addEventListener("keydown", function (event) {
    if (event.keyCode == 9) {
        event.preventDefault();
    }
});

chatInputText.addEventListener("input", function (event) {
    const inputValue = event.target.value;
    const inputValueLength = inputValue.length;

    //update chatMessageLength text content
    chatMessageLength.textContent = `${inputValueLength}/128`;

    //detect if the input is a command
    if (inputValue.startsWith("/")) {
        //remove the slash from the input
        const command = inputValue.slice(1);

        //clear the suggestions container
        chatSuggestionsContainer.innerHTML = "";

        //loop through the suggestions and add them to the suggestions container
        chatSuggestions.forEach((suggestion) => {
            if (suggestion.name.includes(command)) {
                createChatSuggestion(suggestion.name);
            }
        });

        //show the suggestions container
        chatSuggestionsContainer.style.display = "block";
    } else {
        //hide the suggestions container
        chatSuggestionsContainer.style.display = "none";
    }
});
function splitMessage(message) {
    const maxLength = 100;
    let messages = [];
    while (message.length > maxLength) {
        messages.push(message.substring(0, maxLength));
        message = message.substring(maxLength);
    }
    if (message.length > 0) {
        messages.push(message);
    }
    return messages;
}
window.addEventListener("message", function (event1) {
    let event = event1["data"];
    if (event.action == "openChat") {
        if (chatOn) {
            hideChat();
            chatOn = false;
        } else {
            openChat();
            chatOn = true;
        }
    }
    if (event.action == "addChatMessage") {
        if (event.action == "addChatMessage") {
            if (event.message.length > 90) {
                let messages = splitMessage(event.message);
                messages.forEach((msg, index) => {
                    if (index === 0) {
                        createChatMessage(colorize(msg), true);
                    } else {
                        createChatMessage(colorize(msg), false);
                    }
                });
            } else {
                createChatMessage(colorize(event.message), true);
            }
        }
    }
    if (event.action == "setSuggestions") {
        chatSuggestions = event.suggestions;
    }
});

//close chat if T, Enter, Esc is pressed
document.addEventListener("keydown", function (event) {
    if (chatOn) {
        if (event.keyCode == 13 || event.keyCode == 27) {
            hideChat();
            chatOn = false;
            $.post("http://rpbase/closeChat", JSON.stringify({}));
        }
        //add chat message if enter is pressed
        if (event.keyCode == 13) {
            if (
                chatInputText.value.length > 0 &&
                chatInputText.value.length < 128
            ) {
                $.post(
                    "http://rpbase/sendChatMessage",
                    JSON.stringify({
                        message: chatInputText.value,
                    })
                );
                chatInputText.value = "";
            }
        }
    }
});
