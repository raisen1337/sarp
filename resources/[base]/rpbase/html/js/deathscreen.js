let deathscreen = document.querySelector(".deathscreen");
let deathscreenTime = document.querySelector(".deathscreen-time");

window.addEventListener("message", function (event1) {
  let event = event1['data'];
  if (event.action == "showDeathScreen") {
    // show deatscreen as flex, but first add fadeIn
    deathscreen.classList.remove("fadeOut");

    deathscreen.classList.add("fadeIn");
    deathscreen.style.display = "flex";
    // set deathscreenTime to the time

    //event.time is in seconds, make it look like mm:ss
    let minutes = Math.floor(event.time / 60);
    let seconds = event.time - minutes * 60;
    if (seconds < 10) {
      seconds = "0" + seconds;
    }
    event.time = minutes + ":" + seconds;
    deathscreenTime.innerHTML = event.time;
    
  }else if (event.action == "hideDeathScreen") {    
    // hide deathscreen
    deathscreen.classList.remove("fadeIn");
    //add fadeout
    deathscreen.classList.add("fadeOut");
    setTimeout(() => {
        deathscreen.style.display = "none";
    }, 1100);
  }else if (event.action == "updateDeathScreen") {
  
    let minutes = Math.floor(event.time / 60);
    let seconds = event.time - minutes * 60;
    if (seconds < 10) {
      seconds = "0" + seconds;
    }
    event.time = minutes + ":" + seconds;
    deathscreenTime.innerHTML = event.time
  }
});