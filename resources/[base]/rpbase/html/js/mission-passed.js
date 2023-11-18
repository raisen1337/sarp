window.addEventListener("message", function(event1) {
    let event = event1['data'];
    if (event.action == "missionPassed") {
        let missionPassedTitle = document.querySelector('.mission-bigtext')
        let missionPassedDiv = document.querySelector('.mission-passed')
        let missionPassedText = document.querySelector('.mission-subtext')
        
        missionPassedTitle.textContent = 'mission passed'
        missionPassedDiv.style.display = 'flex';

        missionPassedText.textContent = event.missionText;

        missionPassedDiv.classList.remove('fadeOut')
        missionPassedDiv.classList.add('fadeIn');

        const audio = new Audio('./assets/mp.mp3');
        audio.volume = 0.3;
        audio.play();

        setTimeout(() => {
            missionPassedDiv.classList.remove('fadeIn')
            missionPassedDiv.classList.add('fadeOut');
            setTimeout(() => {
                missionPassedDiv.style.display = 'none';
            }, 1000);
        }, 6500);
    }
    if(event.action == 'propertyBought') {
        let missionPassedTitle = document.querySelector('.mission-bigtext')
        let missionPassedDiv = document.querySelector('.mission-passed')
        let missionPassedText = document.querySelector('.mission-subtext')
        
        missionPassedDiv.style.display = 'flex';

        missionPassedTitle.textContent = 'property bought'
        missionPassedText.textContent = event.missionText;

        missionPassedDiv.classList.remove('fadeOut')
        missionPassedDiv.classList.add('fadeIn');

        const audio = new Audio('./assets/pp.mp3');
        audio.volume = 0.3;
        audio.play();

        setTimeout(() => {
            missionPassedDiv.classList.remove('fadeIn')
            missionPassedDiv.classList.add('fadeOut');
            setTimeout(() => {
                missionPassedDiv.style.display = 'none';
            }, 1000);
        }, 6500);
    }
    if(event.action == 'payday') {
        let missionPassedTitle = document.querySelector('.mission-bigtext')
        let missionPassedDiv = document.querySelector('.mission-passed')
        let missionPassedText = document.querySelector('.mission-subtext')
        
        missionPassedDiv.style.display = 'flex';

        missionPassedTitle.textContent = 'payday'
        missionPassedText.innerHTML = event.paydayInfo;
        missionPassedDiv.classList.remove('fadeOut')
        missionPassedDiv.classList.add('fadeIn');

        const audio = new Audio('./assets/pp.mp3');
        audio.volume = 0.3;
        audio.play();

        setTimeout(() => {
            missionPassedDiv.classList.remove('fadeIn')
            missionPassedDiv.classList.add('fadeOut');
            setTimeout(() => {
                missionPassedDiv.style.display = 'none';
            }, 1000);
        }, 6500);
    }
    
});