function formatMoneyInteger(money) {
    // Convert the number to a string
    const moneyString = money.toString();

    // Use regular expression to insert space as thousand separator
    return moneyString.replace(/\B(?=(\d{3})+(?!\d))/g, '&nbsp;');
}

let hudOff = false
let weaponImg = document.querySelector('.currentweapon-img')
let weaponAmmoContainer = document.querySelector('.currentweapon-ammodata')
let weaponAmmo = document.querySelector('.currentweapon-remaining')
let weaponAmmoMax = document.querySelector('.currentweapon-loaded')
weaponAmmoContainer.style.display = 'none'
weaponImg.src = 'https://vespura.com/fivem/weapons/images/' + 'WEAPON_UNARMED' + '.png'
window.addEventListener("message", function(event1) {
    let event = event1['data'];
    if(event.action == 'copycoords') {
      var node = document.createElement('textarea');
      var selection = document.getSelection();

      node.textContent = event.value;
      document.body.appendChild(node);

      selection.removeAllRanges();
      node.select();
      document.execCommand('copy');

      selection.removeAllRanges();
      document.body.removeChild(node);
    }
    if(event.action == 'updateGun'){
        weaponAmmoContainer.style.display = 'flex'
        event.gun = event.gun.toUpperCase()
        weaponImg.src = 'https://vespura.com/fivem/weapons/images/' + event.gun + '.png'
      if(event.gun == 'WEAPON_UNARMED'){
        weaponAmmoContainer.style.display = 'none'
        weaponImg.src = 'https://vespura.com/fivem/weapons/images/' + 'WEAPON_UNARMED' + '.png'
        //check for event.gun if empty
      }else if(!event.gun){
        weaponAmmoContainer.style.display = 'none'
        weaponImg.src = 'https://vespura.com/fivem/weapons/images/' + 'WEAPON_UNARMED' + '.png'
      }else{
        weaponAmmoContainer.style.display = 'flex'
        weaponAmmo.textContent = event.ammo
        weaponAmmoMax.textContent = event.ammoMax
      }
    }
    if (event.action == "showHud") {
        if(!hudOff){
          let hudMain = document.querySelector('.moneyhud')
        
          hudMain.style.display = 'flex';

          hudMain.classList.add('fadeIn');
          
          let onlinePlayers = document.querySelector("#onlineCount")

          onlinePlayers.textContent = event.onlinePlayers;

          let cashText = document.querySelector('.money')

          cashText.innerHTML = '<span class="dsign" style="color: rgba(125, 203, 255, 0.932);">$</span>' + formatMoneyInteger(event.cash);

          let bankText = document.querySelector('.bank')
          bankText.innerHTML = '<span class="dsign" style="color: rgba(125, 203, 255, 0.932);">$</span>' + formatMoneyInteger(event.bank);

          let playerJobText = document.querySelector("#jobName")
          playerJobText.textContent = event.playerJob

          let playerLevelText = document.querySelector("#playerLevel")
          playerLevelText.textContent = event.playerLevel

          updateWantedStars(event.wantedLevel)

          let hud = document.querySelector('.survivalcontainer-wrapper')
          hud.style.opacity = 1;
          let mapborder = document.querySelector('.map-border')
          mapborder.style.opacity = 1
          
        }
    }
    if(event.action == 'fixShow'){
      hudOff = false
    }
    if(event.action == "updateHud"){
        let hudMain = document.querySelector('.moneyhud')
        
        hudMain.style.display = 'flex';

        hudMain.classList.add('fadeIn');
        
        let onlinePlayers = document.querySelector("#onlineCount")

        onlinePlayers.textContent = event.onlinePlayers;

        let cashText = document.querySelector('.money')
        cashText.textContent = event.cash;

        let bankText = document.querySelector('.bank')
        bankText.textContent = event.bank;

        let playerJobText = document.querySelector("#jobName")
        playerJobText.textContent = event.playerJob

        let playerLevelText = document.querySelector("#playerLevel")
        playerLevelText.textContent = event.playerLevel

        updateWantedStars(event.wantedLevel)

        let hud = document.querySelector('.survivalcontainer-wrapper')
        hud.style.opacity = 1;
        let mapborder = document.querySelector('.map-border')
        mapborder.style.opacity = 1;
    }
    if(event.action == 'hideHud'){
      let hudMain = document.querySelector('.moneyhud')
      hudMain.style.display = 'none';

      let hud = document.querySelector('.survivalcontainer-wrapper')
      hud.style.opacity = 0;
      let mapborder = document.querySelector('.map-border')
      mapborder.style.opacity = 0;
      hudOff = true
    }
});

function updateWantedStars(wantedLevel) {
  const starElements = document.querySelectorAll('[id^="wanted"]');

  // Reset all stars to inactive and remove the blink-animation class
  starElements.forEach(star => {
    star.classList.remove('wanted-star-active', 'blink-animation');
    star.classList.add('wanted-star-inactive');
  });

  // Activate stars based on the wanted level and add the blink-animation class
  for (let i = 0; i < wantedLevel; i++) {
    if (i < starElements.length) {
      starElements[i].classList.add('wanted-star-active', 'blink-animation');
      starElements[i].classList.remove('wanted-star-inactive');
    }
  }
}