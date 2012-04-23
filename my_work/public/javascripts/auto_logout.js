var c = 900;
var t;
function timedelay(){
    c = 900;
    clearTimeout(t);
    timedCount();
}

function timedCount(){
    //document.title = c + ' seconds';
    c = c - 1;
    t = setTimeout("timedCount()", 1000);
    
    if (c == -1) {
        clearTimeout(t);
        document.title = 'Redirecting ...';
        self.location = '/auto_logout';
    }
}

window.onfocus = timedelay;
