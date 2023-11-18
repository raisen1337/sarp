let categories = []

let dealershipBtnBuy = document.querySelector("#buyVehicle")
let dealershipBtnTest = document.querySelector("#testVehicle")
let selectedVehicleContainer = document.querySelector('.selectedvehicle-info')
let selectedVehicleName = document.querySelector(".selectedvehicle-name")
let selectedVehiclePrice = document.querySelector(".selectedvehicle-price")
let testDrive = document.querySelector(".testdrive")

let inCategory = false;

function appendDealershipCategory(categoryName, vehicles) {
    // Create the main container div
    const dealershipCategoryDiv = document.createElement('div');
    dealershipCategoryDiv.classList.add('dealership-category');

    // Create the icon element
    const iconElement = document.createElement('i');
    iconElement.classList.add('fas', 'fa-car', 'category-icon');

    // Create the title element and set the categoryName
    const titleElement = document.createElement('span');
    titleElement.classList.add('category-title');
    titleElement.textContent = categoryName;

    // Append the icon and title elements to the main container
    dealershipCategoryDiv.appendChild(iconElement);
    dealershipCategoryDiv.appendChild(titleElement);

    let category = {
        name: categoryName,
        vehicles: vehicles,
    }

    dealershipCategoryDiv.addEventListener('click', () => {
        let dealershipButtons = document.querySelector('.dealership-buttons')
        dealershipButtons.style.display = 'flex';

        let dealershipCategories = document.querySelector('.dealership-categories');
        dealershipCategories.style.display = 'none';

        let dealershipTitle = document.querySelector('.dealership-list-title')
        dealershipTitle.innerHTML = "Alege o masina din catalogul de mai jos";

        inCategory = true;

        let dealershipSearch = document.querySelector('.dealership-search-vehicle')
        dealershipSearch.style.display = 'block';

        let dealershipVehicles = document.querySelector('.dealership-vehicles')
        dealershipVehicles.style.display = 'block';

        for (const vehicle of vehicles) {
            createDealershipVehicle(vehicle.name, vehicle.price, vehicle.spawncode)
        }
    })

    // Get the .dealership-categories container
    const dealershipCategoriesContainer = document.querySelector('.dealership-categories');

    // Append the new element to the .dealership-categories container
    dealershipCategoriesContainer.appendChild(dealershipCategoryDiv);
}

let activeVehicle = ""

function removeAllCategories() {
    // Get the .dealership-categories container
    const dealershipCategoriesContainer = document.querySelector('.dealership-categories');

    // Loop through all category elements and remove them
    while (dealershipCategoriesContainer.firstChild) {
        dealershipCategoriesContainer.removeChild(dealershipCategoriesContainer.firstChild);
    }

}


function deleteAllVehicles() {
    // Empty the 'vehicles' array
    vehicles = [];

    // Get the .dealership-vehicles container
    const dealershipVehiclesContainer = document.querySelector('.dealership-vehicles');

    // Loop through all child elements and remove them
    while (dealershipVehiclesContainer.firstChild) {
        dealershipVehiclesContainer.removeChild(dealershipVehiclesContainer.firstChild);
    }
}

let selectedVehicle = {}

dealershipBtnTest.addEventListener('click', () => {
    if (selectedVehicle.length == 0) {
        return;
    }

    let asdad = document.querySelector("#testdrivea")
    asdad.style.display = 'block !important';

    let dealershipContainer = document.querySelector('.dealership-container');
    dealershipContainer.style.display = 'none';

    testDriveFunc(300)

    deleteAllVehicles()

    setTimeout(() => {
        $.post('http://rpbase/testVehicle', JSON.stringify({
            spawncode: selectedVehicle.spawncode,
            name: selectedVehicle.name,
        }))
    }, 500);

    closeShowroom()
    $.post('http://rpbase/closeShowroom', JSON.stringify({

    }));
})

dealershipBtnBuy.addEventListener('click', () => {
    if (selectedVehicle.length == 0) {
        return;
    }
    
    $.post('http://rpbase/buyVehicle', JSON.stringify({
        price: selectedVehicle.price,
        priceFormatted: "$" + selectedVehicle.price.toLocaleString(),
        spawncode: selectedVehicle.spawncode,
        name: selectedVehicle.name,
    }))

    let dealershipContainer = document.querySelector('.dealership-container');
    dealershipContainer.style.display = 'none';

    deleteAllVehicles()

    closeShowroom()
    $.post('http://rpbase/closeShowroom', JSON.stringify({

    }));
})

function createDealershipVehicle(vehicleName, vehiclePrice, vehicleSpawn) {
    // Create the main container div
    const dealershipVehicleDiv = document.createElement('div');
    dealershipVehicleDiv.classList.add('dealership-vehicle');

    const vehicleTitleElement = document.createElement('span');
    vehicleTitleElement.classList.add('vehicle-title');
    vehicleTitleElement.textContent = vehicleName;

    // Create the vehicle price element and set the vehiclePrice
    const vehiclePriceElement = document.createElement('span');
    vehiclePriceElement.classList.add('vehicle-price');
    vehiclePriceElement.textContent = '$' + vehiclePrice.toLocaleString();

    // Append the vehicle price to the vehicle title
    vehicleTitleElement.appendChild(vehiclePriceElement);

    // Append the vehicle title to the main container
    dealershipVehicleDiv.appendChild(vehicleTitleElement);

    // Get the .dealership-vehicles container
    const dealershipVehiclesContainer = document.querySelector('.dealership-vehicles');

    // Append the new element to the .dealership-vehicles container
    dealershipVehiclesContainer.appendChild(dealershipVehicleDiv);

    dealershipVehicleDiv.addEventListener("click", () => {
        if (activeVehicle == "") {
            activeVehicle = dealershipVehicleDiv;
            activeVehicle.classList.add('active');

            $.post('http://rpbase/displayCar', JSON.stringify({
                car: vehicleSpawn
            }));

            selectedVehicleContainer.style.display = 'flex';
            selectedVehicleName.textContent = vehicleName;
            selectedVehiclePrice.textContent = "$" + vehiclePrice.toLocaleString();

            selectedVehicle.name = vehicleName
            selectedVehicle.spawncode = vehicleSpawn
            selectedVehicle.price = vehiclePrice
            selectedVehicle.priceFormatted = vehiclePrice.toLocaleString();
        } else {
            $.post('http://rpbase/removeCar', JSON.stringify({
            }));
            setTimeout(() => {
                $.post('http://rpbase/displayCar', JSON.stringify({
                    car: vehicleSpawn
                }));

            }, 300);

            selectedVehicleContainer.style.display = 'flex';
            selectedVehicleName.textContent = vehicleName;
            selectedVehiclePrice.textContent = "$" + vehiclePrice.toLocaleString();

            activeVehicle.classList.remove('active')
            activeVehicle = dealershipVehicleDiv;
            activeVehicle.classList.add('active');


            selectedVehicle.priceFormatted = vehiclePrice.toLocaleString();
            selectedVehicle.name = vehicleName
            selectedVehicle.spawncode = vehicleSpawn
            selectedVehicle.price = vehiclePrice
        }
    })

    // Create the vehicle title element and set the vehicleName

}

// Set up the event listener to handle 'keydown' events
document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape' || event.key === 'Esc') {
        // Check if inCategory is true or false
        if (inCategory) {
            // Logic when inCategory is true
            let dealershipButtons = document.querySelector('.dealership-buttons');
            dealershipButtons.style.display = 'none';

            let dealershipCategories = document.querySelector('.dealership-categories');
            dealershipCategories.style.display = 'block';

            let dealershipTitle = document.querySelector('.dealership-list-title');
            dealershipTitle.innerHTML = "Alege o masina din catalogul de mai jos";

            inCategory = false;

            selectedVehicleContainer.style.display = 'none';

            let dealershipSearch = document.querySelector('.dealership-search-vehicle')
            dealershipSearch.style.display = 'none';

            deleteAllVehicles();

            let dealershipVehicles = document.querySelector('.dealership-vehicles');
            dealershipVehicles.style.display = 'none';
        } else {
            // Logic when inCategory is false
            let dealershipContainer = document.querySelector('.dealership-container');
            dealershipContainer.style.display = 'none';
            let dealershipSearch = document.querySelector('.dealership-search-vehicle')
            dealershipSearch.style.display = 'none';
            deleteAllVehicles()
            removeAllCategories()
            closeShowroom()
            $.post('http://rpbase/closeShowroom', JSON.stringify({

            }));
        }
    }
});

function filterVehicles(searchText) {
    // Get the .dealership-categories container
    const dealershipCategoriesContainer = document.querySelector('.dealership-categories');

    // Loop through all category elements and filter vehicles
    for (const categoryElement of dealershipCategoriesContainer.children) {
        const categoryTitle = document.querySelector('.category-title').textContent.toLowerCase();
        const vehiclesContainer = document.querySelector('.dealership-vehicles');
        for (const vehicleElement of vehiclesContainer.children) {
            const vehicleName = vehicleElement.querySelector('.vehicle-title').textContent.toLowerCase();
            if (vehicleName.includes(searchText)) {
                vehicleElement.style.display = 'block';
            } else {
                vehicleElement.style.display = 'none';
            }
        }

        // Check if any vehicles are visible in the category
        const visibleVehicles = Array.from(vehiclesContainer.children).some(vehicleElement => {
            return vehicleElement.style.display !== 'none';
        });

        // Show/hide the entire category based on visible vehicles
        if (visibleVehicles) {
            categoryElement.style.display = 'block';
        } else {
            categoryElement.style.display = 'none';
        }
    }
}

// Add event listener to the search input
const searchInput = document.querySelector('.dealership-search-vehicle');
searchInput.addEventListener('input', function (event) {
    const searchText = event.target.value.toLowerCase();
    filterVehicles(searchText);
});

let testDriveTime
let canContinueTimer = true
function testDriveFunc(seconds) {

    testDriveTime = seconds

    let asdad = document.querySelector("#testdrivea")
    asdad.style.display = 'block';

    testDrive.style.display = 'block';
    const testDriveDiv = document.querySelector('.testdrive-timer');
    testDriveDiv.style.display = 'block';

    // Format the seconds into 'mm:ss' and set the initial time display
    canContinueTimer = true;
    updateTimerDisplay(testDriveTime);

    // Create the timer that will update the display every second
    const timerInterval = setInterval(() => {
        if(canContinueTimer){
            testDriveTime--;
            updateTimerDisplay(testDriveTime);
            if (testDriveTime <= 0 ) {
                testDriveTime = 0;
                canContinueTimer = false;
                testDrive.style.display = 'none';
                $.post("http://rpbase/endTestdrive", JSON.stringify({}))
                clearInterval(timerInterval);
            }
        }
       
    }, 1000);
}


function updateTimerDisplay(seconds) {
    const minutes = Math.floor(seconds / 60);
    const secondsRemain = seconds % 60;

    const formattedTime = `${padZero(minutes)}:${padZero(secondsRemain)}`;
    document.querySelector('.testdrive-timer').textContent = formattedTime;
}

function padZero(number) {
    return number.toString().padStart(2, '0');
}

function endTestdrive() {
    canContinueTimer = false
    testDriveTime = 0;
    testDrive.style.display = 'none';
    $.post("http://rpbase/endTestdriveB", JSON.stringify({}))
}

function closeShowroom() {
    removeAllCategories()
    selectedVehicleContainer.style.display = 'none';
    let dealershipSearch = document.querySelector('.dealership-search-vehicle')
    dealershipSearch.style.display = 'none';

    let moneyhud = document.querySelector('.moneyhud')
    moneyhud.style.display = "flex";

    selectedVehicleContainer.style.display = 'none';

    let survivalcontainer = document.querySelector('.survivalcontainer')
    survivalcontainer.style.display = "flex";
}

window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if(event.action == 'endTestdrive') {
        endTestdrive()
    }
    if (event.action == "openShowroom") {

        const searchInput = document.querySelector('.dealership-search-vehicle');
        searchInput.style.display = 'none';

        for (const categoryName in event.cfg) {
            const vehicles = event.cfg[categoryName]
            appendDealershipCategory(categoryName, vehicles)
        }

        setTimeout(() => {
            let dealershipContainer = document.querySelector('.dealership-container');
            let dealershipButtons = document.querySelector('.dealership-buttons')
            dealershipButtons.style.display = 'none';
            dealershipContainer.style.display = 'flex';
            inCategory = false;
           
            selectedVehicleContainer.style.display = 'none';

            let dealershipCategories = document.querySelector('.dealership-categories');
            dealershipCategories.style.display = 'block';

            let moneyhud = document.querySelector('.moneyhud')
            moneyhud.style.display = "none";

            let survivalcontainer = document.querySelector('.survivalcontainer')
            survivalcontainer.style.display = "none";
        }, 300);


    }
});