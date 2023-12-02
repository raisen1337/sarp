let turfsContainer = document.querySelector('.turfs-container')
let teamAName = document.querySelector('#teamAName')
let teamBName = document.querySelector('#teamBName')

let teamAScore = document.querySelector('#teamAScore')
let teamBScore = document.querySelector('#teamBScore')

let turfsTime = document.querySelector('#turfTime')

function hexToRgb(hex) {
    let bigint = parseInt(hex, 16);
    let r = (bigint >> 16) & 255;
    let g = (bigint >> 8) & 255;
    let b = bigint & 255;

    return r + ',' + g + ',' + b;
}

function secondsToFormattedString(seconds) {
    let minutes = Math.floor(seconds / 60).toString().padStart(2, '0');
    let remainingSeconds = (seconds % 60).toString().padStart(2, '0');
    return `${minutes}:${remainingSeconds}`;
}
let tAScore = 0
let tBScore = 0
turfsContainer.style.display = 'none';

window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "startTurf") {
        let teamAColor = hexToRgb(event.teamAColor)
        let teamBColor = hexToRgb(event.teamBColor)

        teamAName.textContent = event.teamAName
        teamBName.textContent = event.teamBName
        tAScore = 0
        tBScore = 0
        teamAScore.textContent = 0
        teamBScore.textContent = 0
       
        turfsTime.textContent = secondsToFormattedString(event.time)

        turfsContainer.style.display = 'flex'

        // teamAColor.style.background = `linear-gradient(180deg, rgba(${teamAColor}, 0.645) 0%, rgba(${teamAColor},0) 100%)`
        // teamBColor.style.background = `linear-gradient(180deg, rgba(${teamBColor}, 0.645) 0%, rgba(${teamBColor},0) 100%)`
        let currentSecond = secondsToFormattedString(event.time * 60)
    }else if (event.action == "updateTurf") {
        tBScore = event.teamBScore
        tAScore = event.teamAScore
        teamAScore.textContent = event.teamAScore
        teamBScore.textContent = event.teamBScore
    }else if (event.action == "finishTurf") {
        turfsContainer.style.display = 'none'
    }else if (event.action == "updateTurfTime") {
        turfsTime.textContent = secondsToFormattedString(event.time)
    }else if (event.action == "updateKillsForTeam") {
        if(event.team == 'teamA') {
            tAScore = event.kills
            teamAScore.textContent = event.kills
        }else{
            tBScore = event.kills
            teamBScore.textContent = event.kills
        }
    }else if (event.action == 'insertKill') {
        if(event.killType == 'teamA') {

            teamAScore.textContent = tAScore + 1
        }else{
            teamBScore.textContent = tBScore + 1
        }
    }
});
