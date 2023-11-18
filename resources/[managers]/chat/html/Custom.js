
window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "TOG_CHAT") {
        if(!event.tog){
            let chatmsglist = document.querySelector('.chat-messages')
            chatmsglist.style.display = 'none';
        }else{
            let chatmsglist = document.querySelector('.chat-messages')
            chatmsglist.style.display = 'block';
        }
    }
});