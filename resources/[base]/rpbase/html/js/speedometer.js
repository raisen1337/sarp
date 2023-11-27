let speedometerWrapper = document.querySelector('.speedometer');
let vehicleSpeed = document.querySelector('.vehicle-speed');
let vehicleSpeedBar = document.querySelector('.vehicle-speed-bar');
let checkEngine = document.querySelector('#checkengine');
let checkFuel = document.querySelector('#needgas');
let doorStatus = document.querySelector('#lockstatus');
let paydayContainer = document.querySelector('.payday-container');

window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.type == "speed") {
        if (event.display) {
            speedometerWrapper.style.display = "block";
            paydayContainer.style.right = "25rem";

            // Set the innerHTML of vehicleSpeed including "KM/H"
            vehicleSpeed.innerHTML = `${event.speed}<span style="font-size: 1rem;">KM/H</span>`;

            // Convert RPM range (0.1 to 1.0) to percentage for width adjustment
            let rpmPercentage = event.rpm * 100;

            // Ensure a minimum width for vehicleSpeedBar to avoid flickering
            vehicleSpeedBar.style.width = Math.max(rpmPercentage, 5) + "%";

            // Check if the width exceeds 100%
            if (rpmPercentage > 100) {
                vehicleSpeedBar.style.width = "100%";
            }

            // Update other elements based on event data
            if (event.doorLocked) {
                doorStatus.classList.remove('fa-lock-open');
                doorStatus.classList.add('fa-lock');
            } else {
                doorStatus.classList.remove('fa-lock');
                doorStatus.classList.add('fa-lock-open');
            }

            if (checkEngine) {
                checkEngine.classList.add('fa-fade');
            } else if (!checkEngine) {
                checkEngine.classList.remove('fa-fade');
            }

            if (event.fuel < 20) {
                checkFuel.classList.add('fa-fade');
            } else if (event.fuel > 20) {
                checkFuel.classList.remove('fa-fade');
            }
        } else {
            paydayContainer.style.right = "10rem";
            speedometerWrapper.style.display = "none";
        }
    }
});
