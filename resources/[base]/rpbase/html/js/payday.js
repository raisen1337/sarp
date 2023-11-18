let paydayTime = document.querySelector('.payday-time');
let interval;

function startPayday(seconds) {
  // Clear the existing interval (if it exists) before starting a new one
  clearInterval(interval);

  let currentSecond = seconds;

  interval = setInterval(() => {
    let minutes = Math.floor(currentSecond / 60).toString().padStart(2, '0');
    let seconds = (currentSecond % 60).toString().padStart(2, '0');
    paydayTime.textContent = `${minutes}:${seconds}`;

    currentSecond--;

    if (currentSecond < 0) {
      finishPayday();
    }
  }, 1000);
}

function finishPayday() {
  clearInterval(interval);
  paydayTime.textContent = '00:00';
}

window.addEventListener("message", function (event1) {
  let event = event1['data'];
  if (event.action == "startPayday") {
    startPayday(event.time * 60); // Starts payday for 10 seconds (modify as needed)
  }
});
