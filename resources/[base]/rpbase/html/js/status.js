var Health = new CircleProgress(".progress2");
Health.max = 100;
Health.value = 10;
Health.textFormat = "none"

var Armour = new CircleProgress(".progress3");
Armour.max = 100;
Armour.value = 0;
Armour.textFormat = "none"

window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "updateStatus") {
        Health.value = event.health / 2; // Adapt event.health to fit the range of 0-100
        Armour.value = event.armour
    }
    if(event.action == 'hideHud'){
        hudOff = true
    }
    if(event.action == 'fixShow'){
        hudOff = false
    }
    if(event.action == "showStatus"){
        if(!hudOff){
            let hud = document.querySelector('.survivalcontainer-wrapper')
            hud.style.opacity = 1;
            let mapborder = document.querySelector('.map-border')
            mapborder.style.opacity = 1;
        }
    }
});