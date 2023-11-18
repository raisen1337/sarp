const subtitlesContainer = document.querySelector('.subtitles');
const subtitlesText = document.querySelector('.subtitle-text');

subtitlesContainer.style.display = 'none';

function colorize(str) {
  const colorDict = {
    0: '#ffffff',
    1: '#ff4444',
    2: '#99cc00',
    3: '#ffbb33',
    4: '#0099cc',
    5: '#33b5e5',
    6: '#aa66cc',
    8: '#cc0000',
    9: '#cc0068',
  };

  const styleDict = {
    '*': 'font-weight: bold;',
    '_': 'text-decoration: underline;',
    '~': 'text-decoration: line-through;',
    '=': 'text-decoration: underline line-through;',
    'r': 'text-decoration: none; font-weight: normal;',
  };

  const colorRegex = /\^([0-9])((?:(?!\^r|\^\d|\{\w{6}\}).)*?)(?=\^r|$|\^\d|\{\w{6}\})/g;
  const styleRegex = /\^(\_|\*|\=|\~|\/|r)((?:(?!\^r|\^\d|\{\w{6}\}).)*?)(?=\^r|$|\^\d|\{\w{6}\})/g;
  const hexColorRegex = /\{([a-fA-F0-9]{6})\}((?:(?!\^r|\^\d|\{\w{6}\}).)*?)(?=\^r|$|\^\d|\{\w{6}\})/g;

  function applyColors(match, colorCode, content) {
    if (colorCode in colorDict) {
      return `<span class="color-${colorCode}" style="color: ${colorDict[colorCode]}">${content}</span>`;
    }
    return match;
  }

  function applyStyles(match, styleCode, content) {
    if (styleCode in styleDict) {
      return `<em style="${styleDict[styleCode]}">${content}</em>`;
    }
    return match;
  }

  function applyHexColors(match, hexColor, content) {
    return `<span style="color: #${hexColor}">${content}</span>`;
  }

  let colorizedStr = str.replace(colorRegex, applyColors);
  colorizedStr = colorizedStr.replace(styleRegex, applyStyles);
  colorizedStr = colorizedStr.replace(hexColorRegex, applyHexColors);

  
  return colorizedStr.replace(/<span[^>]*><\/span[^>]*>/g, '');
}

let subtitleAlready = false;

function hideSubtitles(){
  subtitlesContainer.style.display = 'none';
  subtitlesText.innerHTML = "";
  subtitleAlready = false
}


window.addEventListener("message", function (event1) {
    let event = event1['data'];
    if (event.action == "showSubtitle") {
        if(!subtitleAlready) {
            subtitleAlready = true;
            const subtitlesContainer = document.querySelector('.subtitles');
            const subtitlesText = document.querySelector('.subtitle-text');
          
            subtitlesContainer.style.display = 'flex';
            subtitlesText.innerHTML = colorize(event.msg);
    
            const audio = new Audio('./assets/notify.mp3');
            audio.volume = 0.3;
            audio.play();
    
            setTimeout(() => {
                hideSubtitles()
            }, event.time);
        }
        
    }
    if(event.action == "hideSubtitle"){
        hideSubtitles()
    }
});
