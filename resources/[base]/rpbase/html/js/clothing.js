let clothingShopMainContainer = document.querySelector('.clothingshop-container')
let clothingContainer = document.querySelector('.clothing-shop')
let clothOptions = document.querySelector('.cloth-options')

let texturePrev = document.querySelector('#texturePrev')
let textureNext = document.querySelector('#textureNext')
let textureNumber = document.querySelector('#textureNumber')

let variationPrev = document.querySelector('#variationPrev')
let variationNext = document.querySelector('#variationNext')
let variationNumber = document.querySelector('#variationNumber')

let totalPrice = document.querySelector('#totalPrice')
clothingShopMainContainer.style.display = 'none'
clothingContainer.style.display = 'none';
clothOptions.style.display = 'none';

let total = 0
let currentTexture = 0
let currentVariation = 0
let selectedItem = 'none'

const minTex = -2
const minVar = -1

let data = {}

let prevElement = false
let currentClothing = {}
let savedClothing = {}

function selectItem(item, element) {
    selectedItem = item;
    const elementd = document.querySelector('#clothItem' + element);
    
    if (elementd.classList.contains('active')) {
      // If the element is already active (clicked before), hide the cloth options
      elementd.classList.remove('active');
        clothOptions.style.display = 'none';
    } else {
      // If the element is not active (first click), show the cloth options
      elementd.classList.add('active');
      clothOptions.classList.remove('fadeOut');
      clothOptions.style.display = 'flex';
      clothOptions.classList.add('fadeIn');
      
       if(currentClothing[selectedItem]){
        if(currentClothing[selectedItem].currentTex){
            textureNumber.valueAsNumber = currentClothing[selectedItem].currentTex
         }
         if(currentClothing[selectedItem].currentVar){
           variationNumber.valueAsNumber = currentClothing[selectedItem].currentVar
        }
       }else{
        textureNumber.valueAsNumber = 0
        variationNumber.valueAsNumber = 0
       }
      
      
    currentTexture = textureNumber.valueAsNumber
    currentVariation = variationNumber.valueAsNumber

      // Close any previously active element (if any)
      if (prevElement && prevElement !== elementd) {
        prevElement.classList.remove('active');
      }
      
      prevElement = elementd;
    }
  }
  

buy = function(){
    $.post('http://rpbase/buyClothing', JSON.stringify({
        price: 500,
        data: savedClothing
    }));
    closeClothing()
} 

cancelbuy = function() {
    closeClothing()
    $.post('http://rpbase/closeClothing', JSON.stringify({

    }));
}
updateClothing = function(component, texture, variation){
    if(selectedItem == 'glass'){
        $.post('http://rpbase/updateProps', JSON.stringify({
            component: data[selectedItem].id,
            texture: currentTexture,
            variation: currentVariation,
        }));
        return
    }

    if(selectedItem == 'ear'){
        $.post('http://rpbase/updateProps', JSON.stringify({
            component: data[selectedItem].id,
            texture: currentTexture,
            variation: currentVariation,
        }));
        return
    }

    if(selectedItem == 'bracelet'){
        $.post('http://rpbase/updateProps', JSON.stringify({
            component: data[selectedItem].id,
            texture: currentTexture,
            variation: currentVariation,
        }));
        return
    }

    if(selectedItem == 'watch'){
        $.post('http://rpbase/updateProps', JSON.stringify({
            component: data[selectedItem].id,
            texture: currentTexture,
            variation: currentVariation,
        }));
        return
    }

 
 
    if(selectedItem == 'hat'){
        $.post('http://rpbase/updateProps', JSON.stringify({
            component: data[selectedItem].id,
            texture: currentTexture,
            variation: currentVariation,
        }));
        return
    }

    $.post('http://rpbase/updateClothing', JSON.stringify({
        component: data[selectedItem].id,
        texture: currentTexture,
        variation: currentVariation,
    }));
  
}

openClothing = function(){
    clothingContainer.classList.remove('fadeOut')
    clothingShopMainContainer.classList.remove('fadeOut')

    clothingShopMainContainer.style.display = 'block'
    clothingContainer.style.display = 'block'
    clothingContainer.classList.add('fadeIn')
    clothingShopMainContainer.classList.add('fadeIn')
}

texturePrev.addEventListener('click', () => {
    if(currentTexture - 1 >= minTex){
        currentTexture--;
        variationNumber.valueAsNumber = 0
        currentVariation = 0
        textureNumber.valueAsNumber = currentTexture
        
        savedClothing[selectedItem] = data[selectedItem]

        savedClothing[selectedItem].item = currentTexture
       

        updateClothing(data[selectedItem].id, currentTexture, currentVariation)
    }
})

textureNext.addEventListener('click', () => {
    if(data[selectedItem].maxdraws){
        if(currentTexture + 1 <= data[selectedItem].maxdraws){
            currentTexture++;
            variationNumber.valueAsNumber = 0
            currentVariation = 0
            textureNumber.valueAsNumber = currentTexture

            savedClothing[selectedItem] = data[selectedItem]

            savedClothing[selectedItem].item = currentTexture

            updateClothing(data[selectedItem].id, currentTexture, currentVariation)
        }
    }
   
})
textureNumber.addEventListener("change", function () {
  // When the input value changes, update the content of the output element
  currentTexture = textureNumber.valueAsNumber

  savedClothing[selectedItem] = data[selectedItem]

  savedClothing[selectedItem].item = currentTexture

  updateClothing(data[selectedItem].id, currentTexture, currentVariation)

});

variationPrev.addEventListener('click', () => {
    if(currentVariation - 1 >= minVar){
        currentVariation--;
        
        variationNumber.valueAsNumber = currentVariation

        savedClothing[selectedItem] = data[selectedItem]

        savedClothing[selectedItem].texture = currentVariation
        updateClothing(data[selectedItem].id, currentTexture, currentVariation)
    }
})

variationNext.addEventListener('click', () => {
    if(currentVariation + 1 <= data[selectedItem].maxtextures){
        currentVariation++;
        variationNumber.valueAsNumber = currentVariation

        savedClothing[selectedItem] = data[selectedItem]

        savedClothing[selectedItem].texture = currentVariation
        updateClothing(data[selectedItem].id, currentTexture, currentVariation)
    }
})
variationNumber.addEventListener("change", function () {
  // When the input value changes, update the content of the output element
  currentVariation = variationPrev.valueAsNumber
  updateClothing(data[selectedItem].id, currentTexture, currentVariation)
});

closeClothing = function(){
    clothingContainer.classList.remove('fadeIn')

    clothingShopMainContainer.classList.remove('fadeIn')

    clothingShopMainContainer.classList.add('fadeOut')

    clothingContainer.classList.add('fadeOut')
    setTimeout(() => {
        clothingContainer.style.display = 'none'
        clothingShopMainContainer.style.display = 'none'
    }, 900);
}

window.addEventListener("message", function (event1) {
    let event = event1.data;
    if(event.action == 'updateMax'){
        for(var key in event.maxValues){
            if (data[key]) {
                data[key].maxdraws = event.maxValues[key].item
                data[key].maxtextures = event.maxValues[key].texture
            }
        }
    }
    if(event.action == 'getData'){
        data = event.data
    }
    if (event.action == 'openClothing') {
        for(let key in event.data.drawables){
            for(k in currentClothing){
                if(currentClothing[event.data.drawables[key][0]]) {
                    currentTexture = event.data.drawables[key][1]
                    textureNumber.valueAsNumber = currentTexture
                    currentClothing[event.data.drawables[key][0]].currentTex = event.data.drawables[key][1]
                }
            }
        }
        for(let key in event.data.props){
            for(k in currentClothing){
                if(currentClothing[event.data.props[key][0]]) {
                    currentTexture = event.data.drawables[key][1]
                    textureNumber.valueAsNumber = currentTexture
                    currentClothing[event.data.props[key][0]].currentTex = event.data.props[key][1]
                }
            }
        }
        for(let key in event.data.drawableTex) {
            for(k in currentClothing){
                if(currentClothing[event.data.drawableTex[key][0]]) {
                    currentVariation = event.data.drawableTex[key][1]
                    variationNumber.valueAsNumber = currentVariation
                    currentClothing[event.data.drawableTex[key][0]].currentVar = event.data.drawableTex[key][1]
                }
            }
        }
        for(let key in event.data.propTex) {
            for(k in currentClothing){
                if(currentClothing[event.data.propTex[key][0]]) {
                    currentVariation = event.data.drawableTex[key][1]
                    variationNumber.valueAsNumber = currentVariation
                    currentClothing[event.data.propTex[key][0]].currentVar = event.data.propTex[key][1]
                }
            }
        }
        openClothing()
    }
    if (event.action == 'closeClothing') {
        closeClothing()
    }
    if (event.action == "setData") {
        
    }
});

switchCam = function(pos, a){
    if(a){
        $.post('http://rpbase/rotate', JSON.stringify({
            rotateFor: 'bag'
    }));
    }else{
        $.post('http://rpbase/rotate', JSON.stringify({
            rotateFor: 'normal'
        }));
    }
    
    $.post('http://rpbase/switchCam', JSON.stringify({
            pos: pos
    }));
}