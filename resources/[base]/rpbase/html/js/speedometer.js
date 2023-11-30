let speedometer = document.querySelector(".speedometer-container");
let vehicleSpeed = document.querySelector("#vehicleSpeed");
let lockStatus = document.querySelector("#lockStatus");
let engineHealth = document.querySelector("#engineHealth");
let fuelLevel = document.querySelector("#fuelLevel");
let vehicleGear = document.querySelector("#vehicleGear");


window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.type == "speed") {
        if(event.display) {
            speedometer.style.display = "flex";
        }else{
            speedometer.style.display = "none";
        }
        
        vehicleSpeed.innerHTML = event.speed;
        vehicleGear.innerHTML = event.vehicleGear;

        // if event.locked remove fa-lock-open and add fa-lock
        if(event.locked == 2) {
            lockStatus.classList.remove("fa-lock-open");
            lockStatus.classList.add("fa-lock");
        }else{
            lockStatus.classList.remove("fa-lock");
            lockStatus.classList.add("fa-lock-open");
        }

        // if event.engineHealth is lower than 100 add fa-fade class
        if(event.engineHealth < 500) {
            engineHealth.classList.add("fa-fade");
            engineHealth.style.color = "#ff3030";
        }else{
            engineHealth.classList.remove("fa-fade");
            //style color to white
            engineHealth.style.color = "#fff";
        }

        if(event.lights == 0) {
            document.querySelector("#lightsStatus").style.color = "#fff";
        }
        else{
            document.querySelector("#lightsStatus").style.color = "#3098ff";
        }

        // if event.fuelLevel is lower than 20 add fa-fade class
        if(event.fuelLevel < 20) {
            fuelLevel.classList.add("fa-fade");
            fuelLevel.style.color = "#ff3030";
        }
        else{
            fuelLevel.classList.remove("fa-fade");
            //style color to white
            fuelLevel.style.color = "#fff";
        }
    }
});