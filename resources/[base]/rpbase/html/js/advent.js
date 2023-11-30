let adventCalender = document.querySelector('.advent-calendar');
let collectedGifts = document.querySelector('.event-info-count');
adventCalender.style.display = 'none'
function createGift(giftId, isUnlocked, giftData, imageUrl, imgAlt, claimed) {
    const giftElement = document.createElement('div');
    giftElement.classList.add('advent-gift');
    giftElement.dataset.giftId = giftId;

    const titleSpan = document.createElement('span');
    titleSpan.classList.add('advent-gift-title');
    titleSpan.textContent = giftId;
    giftElement.appendChild(titleSpan);

    const imgElement = document.createElement('img');
    imgElement.src = imageUrl;
    imgElement.alt = imgAlt || '';
    imgElement.classList.add('advent-gift-img');
    giftElement.appendChild(imgElement);

    if (!isUnlocked) {
        const lockedDiv = document.createElement('div');
        lockedDiv.classList.add('advent-locked');
        const lockIcon = document.createElement('i');
        if (claimed) {
            lockIcon.classList.add('fa-solid', 'fa-check');
        } else {
            lockIcon.classList.add('fa-solid', 'fa-lock');
        }

        lockedDiv.appendChild(lockIcon);
        giftElement.appendChild(lockedDiv);
    }

    if (isUnlocked) {
        giftElement.addEventListener('click', function() {
            //remove fadeIn 
            adventCalender.classList.remove('fadeIn');
            //add fadeOut
            adventCalender.classList.add('fadeOut');
            const audio = new Audio('./sounds/ding.mp3');

            audio.volume = 0.2;
            audio.play();
            setTimeout(() => {
                adventCalender.style.display = 'none'
                
                $.post('https://rpbase/openGift', JSON.stringify({
                    giftId: giftId
                }));

                //play sound
                
            }, 900);
            $.post('https://rpbase/closeAdvent', JSON.stringify({}));

        });
    }

    // Append the gift element to the 'advent-gifts' container
    const adventGiftsContainer = document.querySelector('.advent-gifts');
    if (adventGiftsContainer) {
        adventGiftsContainer.appendChild(giftElement);
    } else {
        console.error("Container with class 'advent-gifts' not found.");
    }
}

function deleteAllGifts(){
    const adventGiftsContainer = document.querySelector('.advent-gifts');
    if (adventGiftsContainer) {
        adventGiftsContainer.innerHTML = '';
    } else {
        console.error("Container with class 'advent-gifts' not found.");
    }
}


let giftImgs = [
    'https://cdn3d.iconscout.com/3d/premium/thumb/christmas-present-6816727-5602724.png?f=webp',
    'https://cdn3d.iconscout.com/3d/premium/thumb/christmas-gift-box-4026865-3345671.png',
    'https://cdn3d.iconscout.com/3d/free/thumb/free-christmas-gift-4575236-3798356.png',
    'https://cdn3d.iconscout.com/3d/premium/thumb/christmas-gift-7106760-5753973.png?f=webp',
    'https://cdn3d.iconscout.com/3d/premium/thumb/christmas-gift-7084394-5742566.png?f=webp',
]

window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "showAdvent") {
        //add fadeIn class to adventCalendar
        deleteAllGifts()
        adventCalender.classList.remove('fadeOut');
        adventCalender.classList.add('fadeIn');
        adventCalender.style.display = 'block'
        let gifts = event.gifts;
        
        for (let gift of gifts) {
            const randomIndex = Math.floor(Math.random() * giftImgs.length);
            const randomImageUrl = giftImgs[randomIndex];
            createGift(gift.id, gift.unlocked, gift.content, randomImageUrl, "gift", gift.claimed);
        }
    }else if(event.action == "updateGifts"){
        collectedGifts.textContent = event.gifts;
    }
});

window.addEventListener("keydown", function (event) {
    if (event.key == "Escape" && adventCalender.style.display == 'block') {
        //remove fadeIn 
        adventCalender.classList.remove('fadeIn');
        //add fadeOut
        adventCalender.classList.add('fadeOut');

        setTimeout(() => {
            adventCalender.style.display = 'none'
        }, 900);
        $.post('https://rpbase/closeAdvent', JSON.stringify({}));
    }
});

  