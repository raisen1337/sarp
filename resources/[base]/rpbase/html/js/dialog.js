let dialogOkListener = null;
let dialogCancelListener = null;

window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "openPrompt") {

        let dialogContainer = document.querySelector(".dialog-container");
        let dialogTitle = document.querySelector(".dialog-title");
        let dialogSubtitle = document.querySelector(".dialog-subtitle");

        dialogTitle.textContent = event.dialogTitle;
        dialogSubtitle.textContent = event.dialogSubtitle;

        dialogContainer.style.display = 'block';

        let dialogOk = document.querySelector(".dialog-ok");
        let dialogCancel = document.querySelector(".dialog-cancel");
        let dialogInput = document.querySelector(".dialog-input");
        dialogInput.focus();

        if (dialogCancelListener) {
            dialogCancel.removeEventListener('click', dialogCancelListener);
            dialogCancelListener = null;
        }

        if (event.hasCancel) {
            dialogCancel.style.display = 'block';
            dialogCancelListener = () => {
                closeDialog(); // Close the dialog first
                let dialogInputValue = dialogInput.value;
                if (dialogInputValue.length == 0) {
                    if (event.canCloseEmpty) {
                        closeDialog();
                    } else {
                        // Handle the case when input is empty, and you don't want to close the dialog
                    }
                } else {
                    closeDialog();
                }
            };
            dialogCancel.addEventListener('click', dialogCancelListener);
        } else {
            dialogCancel.style.display = "none";
        }

        if (dialogOkListener) {
            dialogOk.removeEventListener('click', dialogOkListener);
            dialogOkListener = null;
        }

        dialogOkListener = () => {
            let dialogInputValue = dialogInput.value;
            if (dialogInputValue) {
                //console.log(event.dialogEvent);
                $.post('http://rpbase/dialogCallback', JSON.stringify({
                    eventName: event.dialogEvent,
                    response: dialogInputValue,
                    type: event.eventType,
                }));
                dialogInput.value = "";
                closeDialog();
            } else {
                if (event.canCloseEmpty) {
                    dialogInput.value = "";
                    closeDialog();
                } else {
                    // Handle the case when input is empty, and you don't want to close the dialog
                }
            }
        };
        dialogOk.addEventListener('click', dialogOkListener);

        const handleInputKeyPress = (event) => {
            //console.log(event.key)
            if (event.key === 'Enter') {
                dialogOk.click();
            } else if (event.key === 'Escape') {
                closeDialog(); // Close the dialog first
                dialogCancel.click();
            }
        };

        dialogInput.addEventListener('keydown', handleInputKeyPress);
    }
    if(event.action == 'closethisshit') {
        let dialogContainer = document.querySelector(".dialog-container");
        dialogContainer.style.display = 'none';
        let dialogInput = document.querySelector(".dialog-input");

        dialogInput.value = "";
    }
});

function closeDialog() {
    
    let dialogContainer = document.querySelector(".dialog-container");
    dialogContainer.style.display = 'none';
    let dialogInput = document.querySelector(".dialog-input");

    dialogInput.value = "";

    $.post('http://rpbase/dialogClose', JSON.stringify({
       
    }));
}
