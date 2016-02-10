"use strict";

function init() {
    var spans = getAllElementsWithAttribute('data-content')
for (var i = 0; i < spans.length; i++) {
        spans[i].addEventListener('click', popup, true);
    }
}

function getAllElementsWithAttribute(attribute) {
    var matchingElements =[];
    var allElements = document.getElementsByTagName('*');
    for (var i = 0, n = allElements.length; i < n; i++) {
        if (allElements[i].getAttribute(attribute) !== null) {
            matchingElements.push(allElements[i]);
        }
    }
    return matchingElements;
}


function popup(event) {
    if (! this.id) {
        var overlay = document.createElement("div");
        var x = event.pageX;
        var y = event.pageY;
        var random = "n" + Math.random();
        
        this.id = random;
            overlay.innerHTML = this.dataset.content;
        overlay.style.backgroundColor = "#031B3F";
        overlay.style.position = "absolute";
        overlay.style.left = x + "px";
        overlay.style.top = y + "px";
        overlay.style.border = "2px solid #AA0000";
        overlay.style.color = "#EEEEEE";
        /*overlay.style.opacity = "0.9"*/
        overlay.style.margin = "0";
        overlay.style.padding = ".5em";
        overlay.dataset.pointer = random;
        overlay.addEventListener('click', destroy, false);
        document.body.appendChild(overlay);
    }
}

function destroy() {
    var span = document.getElementById(this.dataset.pointer);
    span.removeAttribute("id");
    document.body.removeChild(this);
}

window.onload = init;