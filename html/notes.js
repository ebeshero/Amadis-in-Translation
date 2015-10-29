
function init() {
    var cells = document.getElementsByClassName('embNote')
for (var i = 0; i < cells.length; i++) {
        cells[i].addEventListener('click', popup, true);
    }
}


function popup(event) {
    if (! this.id) {
        var overlay = document.createElement("div");
        var x = event.pageX;
        var y = event.pageY;
        var random = "n" + Math.random();
        
        this.id = random;
        overlay.innerHTML = this.getElementsByClassName("noteContents")[0].textContent;
        overlay.style.backgroundColor = "#550B03";
        overlay.style.position = "absolute";
        overlay.style.left = x + "px";
        overlay.style.top = y + "px";
        overlay.style.border = "2px solid #AA0000";
        overlay.style.color = "#fffff7";
       /* overlay.style.opacity = "0.9";*/
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