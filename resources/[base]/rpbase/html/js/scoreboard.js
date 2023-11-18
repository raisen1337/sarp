let players = []; // Initialize an empty 'players' array

function createScoreboardPlayer(id, name, level) {
    const playersDiv = document.querySelector('.players');
    
    // Check if the player with the given ID already exists
    if (players.some(player => player.id === id)) {
        console.log(`Player with ID ${id} already exists.`);
        return;
    }

    const scoreboardPlayerDiv = document.createElement('div');
    scoreboardPlayerDiv.classList.add('scoreboard-player');

    const playerIdDiv = document.createElement('div');
    playerIdDiv.classList.add('playerinfo', 'player-id');
    playerIdDiv.textContent = id;

    const playerNameDiv = document.createElement('div');
    playerNameDiv.classList.add('playerinfo', 'player-name');
    playerNameDiv.textContent = name;

    const playerLevelDiv = document.createElement('div');
    playerLevelDiv.classList.add('playerinfo', 'player-level');
    playerLevelDiv.textContent = level;

    scoreboardPlayerDiv.appendChild(playerIdDiv);
    scoreboardPlayerDiv.appendChild(playerNameDiv);
    scoreboardPlayerDiv.appendChild(playerLevelDiv);

    playersDiv.appendChild(scoreboardPlayerDiv);

    players.push({
        id: id,
        name: name,
        level: level,
    });
}

function removeAllScoreboardPlayers() {
    const playersDiv = document.querySelector('.players');

    // Remove all players from the scoreboard
    const playersList = playersDiv.querySelectorAll('.scoreboard-player');
    for (const playerDiv of playersList) {
        playersDiv.removeChild(playerDiv);
    }

    // Clear the 'players' array
    players = [];
}

function removeScoreboardPlayerById(id) {
    const playersDiv = document.querySelector('.players');

    // Check if the player with the given ID exists
    const existingPlayerIndex = players.findIndex(player => player.id === id);
    if (existingPlayerIndex === -1) {
        console.log(`Player with ID ${id} does not exist.`);
        return;
    }

    const playersList = playersDiv.querySelectorAll('.scoreboard-player');
    for (const playerDiv of playersList) {
        const playerIdDiv = playerDiv.querySelector('.player-id');
        if (playerIdDiv.textContent === id.toString()) {
            playersDiv.removeChild(playerDiv);
            players.splice(existingPlayerIndex, 1);
            break;
        }
    }
}


window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "addPlayer") {
        createScoreboardPlayer(event.playerId, event.playerName, event.playerLevel)
    }
    if(event.action == "removePlayer"){
        removeScoreboardPlayerById(event.playerId)
    }
    if(event.action == "showScoreboard"){
        let scoreboardContainer = document.querySelector(".scoreboard")
        scoreboardContainer.style.display = 'flex'
    }
    if(event.action == "hideScoreboard"){
        removeAllScoreboardPlayers();
        let scoreboardContainer = document.querySelector(".scoreboard")
        scoreboardContainer.style.display = 'none'
    }
});