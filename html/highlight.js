/* Part of this code was taken from the JavaScript tutorial
http://dh.obdurodon.org/javascript/obama/obama.xhtml 
written by David Birbaum, www.obdrodon.org */


var targets = document.getElementsByClassName('');

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

window.addEventListener('DOMContentLoaded', function () {
var source = getAllElementsWithAttribute('id');
  for (var i = 0; i < source.length; i++) {
    source[i].addEventListener('mouseover', highlight, false);
  }
}, false);

function highlight() {
clearHighlights();
  targets = document.getElementsByClassName(this.id);
  for (var i = 0; i < targets.length; i++) {
    targets[i].style.backgroundColor = "white";
  }
}

function clearHighlights() {

  for (var i = 0; i < targets.length; i++) {
    targets[i].style.backgroundColor = "";
  }
}
