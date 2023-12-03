var menuTable = []
var mainMenu = true
var cacheSS
var colorPicker
var opened = false
var mainMenuScrollPosition
var pode = false
$(document).on('click', ".menu-item", function() {
    var index = $(this).attr('data-index');
    var type = $(this).attr('data-menuType');
    if (type == "main-menu") {
        currentSubMenu = menuTable[index].subMenu;
        $.post('https://rpbase/action', JSON.stringify({
            action: "openSubMenu",
            type: menuTable[index].type,
        }));
        mainMenuScrollPosition = $("#item-wrapper").scrollTop();
        beforesubsubindex = index;
        openSecondPage(index);
    } if (type == "second-menu") {
        var type = $(this).attr('data-type');    
        if (menuTable[beforesubsubindex].subMenuSelected == index) {
            menuTable[beforesubsubindex].subMenuSelected = 999;
        } else {
            menuTable[beforesubsubindex].subMenuSelected = index;
        }
        var subMenu = menuTable[beforesubsubindex].subMenu
        $("#item-wrapper").html('');
		$.each(subMenu, function(index2, value) {
            var sel = ""
			value.src = value.src.replace(/ /g,"");
			var icon = "item-icon"
			if (value.src == "assets/rgb.png") {
				icon = "item-icon2"
			}
            if (value.subSubMenu) {
                menuTable[beforesubsubindex].subMenuSelected = 999;
                var newItemDiv = `<div class="menu-item" data-type="${value.type}" data-index="${beforesubsubindex}" data-index2="${index2}" data-menuType = "subSubMenu"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
                $("#item-wrapper").append(newItemDiv);
            } else {
                if (menuTable[beforesubsubindex].subMenuSelected == index2) {sel = "selected"}
                var menuType = "second-menu"
                if (value.colorpicker == true) {menuType = "colorpicker"}
                var newItemDiv = `<div class="menu-item ${sel}" data-type="${value.type}" data-index="${index2}" data-menuType = "${menuType}"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
                $("#item-wrapper").append(newItemDiv);
            }
            
        });
        $.post('https://rpbase/action', JSON.stringify({
            action: "subMenuAction",
            type:  menuTable[beforesubsubindex].subMenu[index].type,
        }));
    } if (type == "colorpicker") {
        subsub = true;
        menuTable[beforesubsubindex].subMenuSelected = index;
        $("#item-wrapper").html('');
		var newItemDiv = `<div id="colorPicker"></div>`;
		var textoinput = `<label id="texto">Hex Code: </label>`;
		var testeinput = `<input id="hexInput" type="text" value="Hex Code"></input>`;
        $("#item-wrapper").append(newItemDiv);
		$("#item-wrapper").append(testeinput);
		$("#item-wrapper").append(textoinput);
		var hexInput = document.getElementById("hexInput");
        colorPicker = new iro.ColorPicker("#colorPicker", {
            // color picker options
            // Option guide: https://iro.js.org/guide.html#color-picker-options
            width: convertVWToPX(10),
            color: tableToRgbString(menuTable[beforesubsubindex].subMenu[index].currentColor),
            borderWidth: 1,
            borderColor: "#fff",
        });
		hexInput.addEventListener('change', function() {
		  colorPicker.color.hexString = this.value;
		});
		hexInput.value = colorPicker.color.hexString;
		document.getElementById("hexInput").style.borderColor = colorPicker.color.hexString;
		document.getElementById("texto").style.color = colorPicker.color.hexString;
        colorPicker.on('color:change', function(color) {
            // log the current color as a HEX string
            var type = $(this).attr('data-type');    
			hexInput.value = color.hexString;
			document.getElementById("hexInput").style.borderColor = color.hexString;
			document.getElementById("texto").style.color = color.hexString;
            $.post('https://rpbase/action', JSON.stringify({
            action: "changeColor",
            type: type,
            rgb: color.rgb,
            }));
        });
        // subsub = true;
        // beforesubsubindex = index;
        // var index2 = $(this).attr('data-index2');
        $.post('https://rpbase/action', JSON.stringify({
            action: "opensubSubMenu",
            type:  menuTable[beforesubsubindex].subMenu[index].type,
        }));
    } if (type == "colorpicker-subsub") {
        subsub = "colorpicker-subsub";
        var index2 = $(this).attr('data-subsubindex');
        cacheSS = index2;
        menuTable[beforesubsubindex].subMenu[index2].subSubMenuSelected = index;
        $("#item-wrapper").html('');
        var newItemDiv = `<div id="colorPicker"></div>`;
		var textoinput = `<label id="texto">Hex Code: </label>`;
		var testeinput = `<input id="hexInput" type="text" value="Hex Code"></input>`;
        $("#item-wrapper").append(newItemDiv);
		$("#item-wrapper").append(testeinput);
		$("#item-wrapper").append(textoinput);
		var hexInput = document.getElementById("hexInput");
        colorPicker = new iro.ColorPicker("#colorPicker", {
            // color picker options
            // Option guide: https://iro.js.org/guide.html#color-picker-options
            width: convertVWToPX(10),
            color: tableToRgbString(menuTable[beforesubsubindex].subMenu[index2].subSubMenu[index].currentColor),
            borderWidth: 1,
            borderColor: "#fff",
        });
		hexInput.addEventListener('change', function() {
		  colorPicker.color.hexString = this.value;
		});
		hexInput.value = colorPicker.color.hexString;
		document.getElementById("hexInput").style.borderColor = colorPicker.color.hexString;
		document.getElementById("texto").style.color = colorPicker.color.hexString;
        colorPicker.on('color:change', function(color) {
            // log the current color as a HEX string
            var type = $(this).attr('data-type');
			hexInput.value = color.hexString;
			document.getElementById("hexInput").style.borderColor = color.hexString;
			document.getElementById("texto").style.color = color.hexString;
            $.post('https://rpbase/action', JSON.stringify({
				action: "changeColor",
				type: type,
				rgb: color.rgb,
            }));
        });
        // subsub = true;
        // beforesubsubindex = index;
        // var index2 = $(this).attr('data-index2');
        $.post('https://rpbase/action', JSON.stringify({
            action: "opensubSubMenu",
            type:  menuTable[beforesubsubindex].subMenu[index2].subSubMenu[index].type,
        }));
    } if (type == "subSubMenu") {
        subsub = true;
        beforesubsubindex = index;
        var index2 = $(this).attr('data-index2');
        $.post('https://rpbase/action', JSON.stringify({
            action: "opensubSubMenu",
            type: menuTable[beforesubsubindex].subMenu[index2].type,
        }));
        openSubSubPage(index, index2);
    } if (type == "subSubMenuAction") {
        var type = $(this).attr('data-type');
        var index2 = $(this).attr('data-subsubindex');
        if (menuTable[beforesubsubindex].subMenu[index2].subSubMenuSelected == index) {
            menuTable[beforesubsubindex].subMenu[index2].subSubMenuSelected = 999;
        } else {
            menuTable[beforesubsubindex].subMenu[index2].subSubMenuSelected = index;
        }
        var subMenu = menuTable[beforesubsubindex].subMenu[index2].subSubMenu
        $("#item-wrapper").html('');
		$.each(subMenu, function(index, value) {
            var sel = ""
			value.src = value.src.replace(/ /g,"");
			var icon = "item-icon"
			if (value.src == "assets/rgb.png") {
				icon = "item-icon2"
			}
            if (menuTable[beforesubsubindex].subMenu[index2].subSubMenuSelected == index) {sel = "selected"}
            var menuType = "subSubMenuAction"
            if (value.colorpicker == true) {menuType = "colorpicker-subsub"}
            var newItemDiv = `<div class="menu-item ${sel}" data-type="${value.type}" data-subsubindex="${index2}" data-index="${index}" data-menuType = "${menuType}"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
            $("#item-wrapper").append(newItemDiv);
        
        });

        $.post('https://rpbase/action', JSON.stringify({
            action: "subSubMenuAction",
            type: menuTable[beforesubsubindex].subMenu[index2].subSubMenu[index].type,
        }));
    }
});

$("#backbtn").click(function() {
    if (subsub == false) {
        $("#backbtn").hide();
        $("#item-wrapper").html('');
        $.post('https://rpbase/action', JSON.stringify({
            action: "backToMainMenu",
        }));
        $("#title").text("Car Tuning");
	    $.each(menuTable, function(index, value) {
			value.src = value.src.replace(/ /g,"");
			var icon = "item-icon"
			if (value.src == "assets/rgb.png") {
				icon = "item-icon2"
			}
            var newItemDiv = `<div class="menu-item" data-index="${index}" data-menuType = "main-menu"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
            $("#item-wrapper").append(newItemDiv);
        });
        $("#item-wrapper").scrollTop(mainMenuScrollPosition);
    } if (subsub == true) {
		$.post('https://rpbase/action', JSON.stringify({
            action: "backTosubMainMenu",
        }));
        var subMenu = menuTable[beforesubsubindex].subMenu
        subsub = false;
        $("#item-wrapper").html('');
        $("#title").text(menuTable[beforesubsubindex].subMenuTitle);
		$("#item-wrapper").animate({ scrollTop: 0 }, "fast");
	    $.each(subMenu, function(index2, value) {
            var sel = ""
			value.src = value.src.replace(/ /g,"");
			var icon = "item-icon"
			if (value.src == "assets/rgb.png") {
				icon = "item-icon2"
			}
            if (value.subSubMenu) {
                var newItemDiv = `<div class="menu-item" data-type="${value.type}" data-index="${beforesubsubindex}" data-index2="${index2}" data-menuType = "subSubMenu"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
                $("#item-wrapper").append(newItemDiv);
            } else {
                if (menuTable[beforesubsubindex].subMenuSelected == index2) {sel = "selected"}
                var newItemDiv = `<div class="menu-item ${sel}" data-type="${value.type}" data-index="${index2}" data-menuType = "second-menu"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
                $("#item-wrapper").append(newItemDiv);
            }
            
        });
    } if (subsub == "colorpicker-subsub") {
        var subMenu = menuTable[beforesubsubindex].subMenu[cacheSS].subSubMenu
        subsub = true;
        $("#item-wrapper").html('');
        $("#title").text(menuTable[beforesubsubindex].subMenu[cacheSS].subSubMenuTitle);
        $("#item-wrapper").animate({ scrollTop: 0 }, "fast");
		$.each(subMenu, function(index, value) {
			value.src = value.src.replace(/ /g,"");
            var sel = ""
			var icon = "item-icon"
			if (value.src == "assets/rgb.png") {
				icon = "item-icon2"
			}
            if (menuTable[beforesubsubindex].subMenu[cacheSS].subSubMenuSelected == index) {sel = "selected"}
            var menuType = "subSubMenuAction"
            if (value.colorpicker == true) {menuType = "colorpicker-subsub"}
            var newItemDiv = `<div class="menu-item ${sel}" data-type="${value.type}" data-subsubindex="${cacheSS}" data-index="${index}" data-menuType = "${menuType}"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
            $("#item-wrapper").append(newItemDiv);
        
        });
    }
});

$("#finishbutton").click(function() {
    $("#popup").show();
});

$("#cancel").click(function() {
    $("#popup").hide();
    $("#toggle").hide();
    $("#item-wrapper").html('');
    $.post('https://rpbase/action', JSON.stringify({
        action: "cancel",
    }));
});

$("#confirm").click(function() {
    $("#popup").hide();
    $("#toggle").hide();
    $("#item-wrapper").html('');
    $.post('https://rpbase/action', JSON.stringify({
        action: "finish",
    }));
});

$("#kinda").click(function() {
    $("#popup").hide();
	$.post('https://rpbase/action', JSON.stringify({
        action: "kinda",
    }));
});

var subsub = false
var beforesubsubindex

function openSecondPage(index) {
    $("#backbtn").show();
    var subMenu = menuTable[index].subMenu
    mainMenu = false;
    $("#item-wrapper").html('');
    $("#title").text(menuTable[index].subMenuTitle);
    $("#item-wrapper").animate({ scrollTop: 0 }, "fast");
	$.each(subMenu, function(index2, value) {
        var sel = ""
		value.src = value.src.replace(/ /g,"");
		var icon = "item-icon"
		if (value.src == "assets/rgb.png") {
			icon = "item-icon2"
		}
        if (menuTable[index].subMenuSelected == index2) {sel = "selected"}
        if (value.subSubMenu) {
            var newItemDiv = `<div class="menu-item ${sel}" data-type="${value.type}" data-index="${index}" data-index2="${index2}" data-menuType = "subSubMenu"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
            $("#item-wrapper").append(newItemDiv);
        } else {
            var menuType = "second-menu"
            if (value.colorpicker == true) {menuType = "colorpicker"}
            var newItemDiv = `<div class="menu-item ${sel}" data-type="${value.type}" data-index="${index2}" data-menuType = "${menuType}"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
            $("#item-wrapper").append(newItemDiv);
        }
        
    });
}

function openSubSubPage(firstindex, index2) {
    $("#backbtn").show();
    menuTable[firstindex].subMenuSelected = index2;
    var subMenu = menuTable[firstindex].subMenu[index2].subSubMenu
    subsub = true;
    $("#item-wrapper").html('');
    $("#title").text(menuTable[firstindex].subMenu[index2].subSubMenuTitle);
	$("#item-wrapper").animate({ scrollTop: 0 }, "fast");
    $.each(subMenu, function(index, value) {
		value.src = value.src.replace(/ /g,"");
        var sel = ""
		var icon = "item-icon"
		if (value.src == "assets/rgb.png") {
			icon = "item-icon2"
		}
        if (menuTable[firstindex].subMenu[index2].subSubMenuSelected == index) {sel = "selected"}
        var menuType = "subSubMenuAction"
        if (value.colorpicker == true) {menuType = "colorpicker-subsub"}
        var newItemDiv = `<div class="menu-item ${sel}" data-type="${value.type}" data-subsubindex="${index2}" data-index="${index}" data-menuType = "${menuType}"><div class="item-icon-wrapper"><Img class="${icon}" src="${value.src}"></Img></div><div class="item-name">${value.title}</div></div>`;
        $("#item-wrapper").append(newItemDiv);
    
    });
}

window.addEventListener('message', function(event) {
    switch (event.data.action) {
        case 'openMenu':
            opened = true;
			$("#backbtn").hide();
            $("#title").text("Car Tuning");
            $("#item-wrapper").html('');
            menuTable = event.data.menuTable;
            mainMenuScrollPosition = 0;
			$.each(menuTable, function(index, value) {
				value.src = value.src.replace(/ /g,"");
				var icon = "item-icon"
				if (value.src == "assets/rgb.png") {
					icon = "item-icon2"
				}
                var newItemDiv = `<div class="menu-item" data-index="${index}" data-menuType = "main-menu"><div class="item-icon-wrapper"><Img class="${icon}" src=${value.src}></Img></div><div class="item-name">${value.title}</div></div>`;
                $("#item-wrapper").append(newItemDiv);
            });
            $("#toggle").fadeIn(500);
        break
        case 'close':
            opened = false;
            $("#toggle").fadeOut(500);
        break
        case 'updateTotal':
            $(".total").text(event.data.text);
        break
        case 'showFreeUpButton':
			pode = true
            $("#freecam").fadeIn("slow");
        break
        case 'hideFreeUpButton':
			pode = false
            $("#freecam").fadeOut("slow");
        break
    }
});


function convertVWToPX(vw) {
	return (document.documentElement.clientWidth * vw) / 100;
}

function tableToRgbString(tb) {
    var red = tb.r;
    var green = tb.g;
    var blue = tb.b;
    return `rgb(${red}, ${green}, ${blue})`
}

$(document).ready(function(){
	document.onkeyup = function (data) {
        if(opened){
            if (data.which == 27) {
                $.post('https://rpbase/action', JSON.stringify({
                    action: "camlivre",
                }));
            } else if (data.which == 81 & pode) {
                $.post('https://rpbase/action', JSON.stringify({
                    action: "camlivre",
                }));
            }
        }
		
	};
});

