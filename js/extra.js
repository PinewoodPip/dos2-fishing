document.addEventListener("DOMContentLoaded", function() {
    load_navpane();
});

// Source: https://github.com/squidfunk/mkdocs-material/issues/767#issuecomment-384558269
function load_navpane() {
    var width = window.innerWidth;
    if (width <= 1200) {
        return;
    }

    var nav = document.getElementsByClassName("md-nav__toggle");
    for(var i = 0; i < nav.length; i++) {
        let item = nav.item(i)
        let label = item.parentElement.childNodes[3]

        // Uncollapse Major Features section
        if (label.textContent.includes("Major Features")) {
            nav.item(i).checked = true;
        }
    }
}