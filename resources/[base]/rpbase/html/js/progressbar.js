let progressTimer
function showProgress(percent, durationInSeconds) {
    clearTimeout(progressTimer); // Clear any existing animation timer

    const progressBarContainer = document.querySelector('.progressbar');
    const progress = document.querySelector('.progressbar-progress');
    const text = document.querySelector('.progressbar-text');
    progressBarContainer.style.display = 'flex';

    const circumference = 314; // Circumference of the circle
    const offset = circumference - (percent / 100) * circumference;

    progress.style.transition = 'none'; // Disable transition to reset progress instantly
    progress.style.strokeDashoffset = circumference; // Set progress to 0 instantly
    text.textContent = '0%'; // Set text to 0%

    // Trigger a repaint by accessing the computed style
    progress.getBoundingClientRect();

    // Convert duration from seconds to milliseconds
    const durationInMillis = durationInSeconds * 1000;

    // Enable transition to animate progress to the specified percentage and duration
    progress.style.transition = `stroke-dashoffset ${durationInSeconds}s ease-in-out`;
    progress.style.strokeDashoffset = offset;

    // Function to update text content with animation
    function updateTextContent(startTime) {
        const currentTime = Date.now();
        const elapsedTime = currentTime - startTime;
        const progressPercent = Math.min((elapsedTime / durationInMillis) * percent, percent);
        text.textContent = Math.floor(progressPercent) + '%';

        if (progressPercent < percent) {
            requestAnimationFrame(() => updateTextContent(startTime));
        }
    }

    // Start updating text content during the animation
    requestAnimationFrame(() => updateTextContent(Date.now()));

    // Hide the progress bar when the animation is finished
    progressTimer = setTimeout(() => {
        progressBarContainer.style.display = 'none';
    }, durationInMillis + 300);
}



window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "setProgress") {
        showProgress(event.percentage, event.duration);
    }
    if(event.action == 'cancelProgress'){
        clearTimeout(progressTimer);
        const progressBarContainer = document.querySelector('.progressbar');
        progressBarContainer.style.display = 'none';
    }
  });

// Example usage:
// showProgress(100, 2); // Update progress to 50% in 2 seconds
