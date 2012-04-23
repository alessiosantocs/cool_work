{ // written by Kae - kae@verens.com
    /*
     Use this as you wish. Please retain this notice.
     This source has elements coded by Dean Edwards - please read his notices before copying
     */
}
function getCss(){
    var a = document.getElementsByTagName('style'), b = document.getElementsByTagName('link'), i = 0;
    getCss_done = 1;
    /* get internal styles */
    {
        for (i = 0; i < a.length; i++) 
            getCss_text += a[i++].innerHTML;
    }
    
    if (!getCss_leftToDo) 
        getCss_parseCssText();
}

function fillArr(arr, keys, val){

    for (i = 0; i < keys.length; i++) 
        arr[keys[i]] = val;
    return arr;
}

function getCss_parseCssText(){
    getCss_done = 1;
    var a, rules = [], i, j = 0, rules2, b;
    /* get CSS parts */
    {
        getCss_text = getCss_text.replace(/<!--|\n|\r| +|\t/g, ' ');
        getCss_text = getCss_text.replace(/( +|)(:|{|}|;)( +|)/g, '$2');
        b = getCss_text.split(/}/);
        for (a = 0; a < b.length; a++) 
            if (b[a] != '' && /\{/.test(b[a])) 
                rules.push(b[a]);
    }
    for (j = 0; j < rules.length; j++) { // separate rules into selectors, then build parameters array
        a = -1;
        parts = rules[j].split(/{/);
        for (i = 0; i < getCss_rules.length; i++) 
            if (getCss_rules[i][0] == parts[0]) 
                a = i;
        if (a == -1) {
            a = getCss_rules.length;
            getCss_rules[a] = [parts[0], []];
        }
        rules2 = parts[1].split(/;/);
        if (rules2[rules2.length - 1] == '') 
            rules2.pop();
        var elRules = [];
        elRules['border-bottom-left-radius'] = '0px 0px';
        elRules['border-bottom-right-radius'] = '0px 0px';
        elRules['border-top-left-radius'] = '0px 0px';
        elRules['border-top-right-radius'] = '0px 0px';
        elRules['border-bottom-width'] = 0;
        elRules['border-left-width'] = 0;
        elRules['border-right-width'] = 0;
        elRules['border-top-width'] = 0;
        for (i = 0; i < rules2.length; ++i) {
            parts2 = [rules2[i].replace(/(^[^:]*):.*/, '$1'), rules2[i].replace(/(^[^:]*):/, '')];
            parts2[0] = parts2[0].toLowerCase();
            parts3 = parts2[1].split(/ /);
            parts3L = parts3.length;
            switch (parts2[0]) {
                case 'background':{
                    lefttop = 0;
                    for (k = 0; k < parts3.length; ++k) {
                        if (parts3[k].match(/repeat/)) 
                            elRules['background-repeat'] = parts3[k];
                        else 
                            if (parts3[k].match(/^url/)) 
                                elRules['background-image'] = parts3[k];
                            else 
                                if (parts3[k].match(/^[0-9]|center|top|right|bottom|left/)) {
                                    if (lefttop++) 
                                        elRules['background-position-horizontal'] = parts3[k];
                                    else 
                                        elRules['background-position-vertical'] = parts3[k];
                                }
                                else 
                                    elRules['background-color'] = parts3[k];
                    }
                    break;
                }
                case 'border':{
                    for (k = 0; k < parts3.length; ++k) {
                        if (parts3[k].match(/px$/)) 
                            elRules = fillArr(elRules, ['border-top-width', 'border-right-width', 'border-bottom-width', 'border-left-width'], parts3[k]);
                        else 
                            if (parts3[k].match(/solid|dashed|dotted|none/)) 
                                elRules = fillArr(elRules, ['border-top-style', 'border-right-style', 'border-bottom-style', 'border-left-style'], parts3[k]);
                            else 
                                elRules = fillArr(elRules, ['border-top-color', 'border-right-color', 'border-bottom-color', 'border-left-color'], parts3[k]);
                    }
                    break;
                }
                case 'border-radius':{
                    elRules = fillArr(elRules, ['border-top-right-radius', 'border-top-left-radius', 'border-bottom-right-radius', 'border-bottom-left-radius'], (parts3L > 1) ? parts3[0] + ' ' + parts3[1] : parts3[0] + ' ' + parts3[0]);
                    break;
                }
                case 'border-top-right-radius':
                case 'border-top-left-radius':
                case 'border-bottom-right-radius':
                case 'border-bottom-left-radius':{
                    elRules['border-' + parts2[0].replace(/border-|-radius/g, '') + '-radius'] = (parts3L > 1) ? parts3[0] + ' ' + parts3[1] : parts3[0] + ' ' + parts3[0];
                    break;
                }
                case 'border-color':
                case 'border-style':
                case 'border-width':{
                    var suffix = parts2[0].substring(6);
                    elRules['border-top' + suffix] = parts3[0];
                    elRules['border-right' + suffix] = parts3L > 1 ? parts3[1] : parts3[0];
                    elRules['border-bottom' + suffix] = parts3L > 2 ? parts3[2] : parts3[0];
                    elRules['border-left' + suffix] = parts3L > 3 ? parts3[3] : (parts3L > 1 ? parts3[1] : parts3[0]);
                    break;
                }
                default:
                    {
                        elRules[parts2[0]] = parts2[1];
                    }
            }
        }
        getCss_rules[a][1] = elRules;
    }
}

function borders(){
    if (getCss_done) 
        return borders_generateBorders();
    getCss();
    borders_waitForCss();
}

function borders_waitForCss(){
    if (!getCss_done) 
        return setTimeout('borders_waitForCss()', 20);
    borders_generateBorders();
}

function borders_generateBorders(){
    /* common variables */
    {
        var i = 0, x, y, k, tpp = 2;
    }
    for (; i < getCss_rules.length; ++i) {
        /* variables */
        {
            var rules = getCss_rules[i][1];
            var wt = parseInt(rules['border-top-width']), wr = parseInt(rules['border-right-width']);
            var wb = parseInt(rules['border-bottom-width']), wl = parseInt(rules['border-left-width']);
        }
        if (wt || wr || wb || wl) {
            /* common variables */
            {
                var tr = rules['border-top-right-radius'].split(' '), br = rules['border-bottom-right-radius'].split(' ');
                var bl = rules['border-bottom-left-radius'].split(' '), tl = rules['border-top-left-radius'].split(' ');
                var bl0 = parseInt(bl[0]), br0 = parseInt(br[0]), tl0 = parseInt(tl[0]), tr0 = parseInt(tr[0]);
                var bl1 = parseInt(bl[1]), br1 = parseInt(br[1]), tl1 = parseInt(tl[1]), tr1 = parseInt(tr[1]);
                var els = cssQuery(getCss_rules[i][0]), j = 0, tpp2 = tpp * tpp;
            }
            for (; j < els.length; ++j) { /* draw border and background */
                /* setup border array and common variables */
                {
                    var a, theEl = els[j];
                    var x = parseInt(theEl.offsetLeft), y = parseInt(theEl.offsetTop), xw = parseInt(theEl.offsetWidth);
                    var yh = parseInt(theEl.offsetHeight), b_arr = [], k = 0, tppTR0 = tr0 * tpp, tppTR1 = tr1 * tpp;
                    var tppBR0 = br0 * tpp, tppBR1 = br1 * tpp, tppBL0 = bl0 * tpp, tppBL1 = bl1 * tpp, tppTL0 = tl0 * tpp, tppTL1 = tl1 * tpp;
                    var tppWR = wr * tpp, tppWL = wl * tpp, tppWidth = xw * tpp, tppHeight = yh * tpp, b_arrInnerTop = wt * tpp, tppWB = wb * tpp;
                    var b_arrInnerBottom = tppHeight - tppWB;
                    for (; k < tppWidth; ++k) 
                        b_arr[k] = [0, b_arrInnerTop, b_arrInnerBottom, tppHeight]; // array of borders for the curves
                    if (isKonqueror) {
                        x += parseInt(document.defaultView.getComputedStyle(theEl.offsetParent, '').getPropertyValue('margin-left'));
                        y += parseInt(document.defaultView.getComputedStyle(theEl.offsetParent, '').getPropertyValue('margin-top'));
                    }
                    if (isMSIE) {
                        var ml = parseInt(theEl.offsetParent.currentStyle.marginLeft);
                        if (!isNaN(ml)) 
                            x += ml;
                        var mt = parseInt(theEl.offsetParent.currentStyle.marginTop);
                        if (!isNaN(mt)) 
                            y += mt;
                    }
                }
                /* create background element */
                {
                    var bgwNum = theEl.backgroundwrapper ? theEl.backgroundwrapper : (++backgroundwrappers);
                    var bgwZ = (theEl.style.zIndex && parseInt(theEl.style.zIndex) > 1) ? parseInt(theEl.style.zIndex) - 1 : 1;
                    theEl.backgroundwrapper = bgwNum;
                    theEl.style.zIndex = bgwZ + 1;
                    theEl.style.position = 'relative';
                    var bgw = document.getElementById('borderradiuswrapper' + bgwNum);
                    if (bgw) 
                        bgw.parentNode.removeChild(bgw);
                    var bgw = document.createElement('pseudo');
                    bgw.id = 'borderradiuswrapper' + bgwNum;
                    var bgwStyle = bgw.style;
                    bgwStyle.zIndex = bgwZ;
                    bgwStyle.position = 'absolute';
                    bgwStyle.left = x + 'px';
                    bgwStyle.top = y + 'px';
                    bgwStyle.width = xw;
                    bgwStyle.height = yh;
                }
                /* generate curved borders */
                {
                    if (tr0) { // top right corner
                        var irx = tppTR0 - tppWR, iry = tppTR1 - b_arrInnerTop;
                        var irx2 = irx * irx, iry2 = iry * iry, tppTR0_2 = tppTR0 * tppTR0, tppTR1_2 = tppTR1 * tppTR1;
                        for (var cx = tppTR0 - 1; cx > -1; --cx) {
                            var cx2 = cx * cx, ind = tppWidth - tppTR0 + cx;
                            if (ind > -1) {
                                var h = (cx < irx) ? Math.sqrt(iry2 * (1 - cx2 / irx2)) : 0;
                                b_arr[ind][0] = tppTR1 - Math.sqrt(tppTR1_2 * (1 - cx2 / tppTR0_2));
                                b_arr[ind][1] = tppTR1 - h;
                            }
                        }
                    }
                    if (br0) { // bottom right corner
                        var irx = tppBR0 - tppWR, iry = tppBR1 - tppWB;
                        var irx2 = irx * irx, tmp2 = tppHeight - tppBR1, tppBR0_2 = tppBR0 * tppBR0, tppBR1_2 = tppBR1 * tppBR1;
                        for (var cx = tppBR0 - 1; cx > -1; --cx) {
                            var cx2 = cx * cx, ind = tppWidth - tppBR0 + cx;
                            if (ind > -1) {
                                var h = (cx < irx) ? Math.sqrt(iry * iry * (1 - cx2 / irx2)) : 0;
                                b_arr[ind][2] = tmp2 + h;
                                b_arr[ind][3] = tmp2 + Math.sqrt(tppBR1_2 * (1 - cx2 / tppBR0_2));
                            }
                        }
                    }
                    if (bl0) { // bottom left corner
                        var bl02 = tppBL0 * tppBL0, bl12 = tppBL1 * tppBL1, irx = tppBL0 - tppWL, iry = tppBL1 - tppWB;
                        var irx2 = irx * irx, iry2 = iry * iry, tmp1 = bl0 * tpp - 1, tmp2 = tppHeight - tppBL1;
                        for (var cx = tppBL0 - 1; cx > -1; --cx) {
                            var cx2 = cx * cx, ind = tmp1 - cx;
                            if (ind > -1) {
                                var h = (cx < irx) ? Math.sqrt(iry2 * (1 - cx2 / irx2)) : 0;
                                b_arr[ind][2] = tmp2 + h;
                                b_arr[ind][3] = tmp2 + Math.sqrt(bl12 * (1 - cx2 / (bl02)));
                            }
                        }
                    }
                    if (tl0) { // top left corner
                        var tl02 = tppTL0 * tppTL0, tl12 = tppTL1 * tppTL1, irx = tppTL0 - tppWL, iry = tppTL1 - b_arrInnerTop;
                        var irx2 = irx * irx, iry2 = iry * iry, tmp1 = tppTL0 - 1;
                        for (cx = tppTL0 - 1; cx > -1; --cx) {
                            var cx2 = cx * cx, ind = tmp1 - cx;
                            if (ind > -1) {
                                var h = (cx < irx) ? Math.sqrt(iry2 * (1 - cx2 / irx2)) : 0;
                                b_arr[ind][0] = tppTL1 - Math.sqrt(tl12 * (1 - cx2 / (tl02)));
                                b_arr[ind][1] = tppTL1 - h;
                            }
                        }
                    }
                }
                /* fill in the background */
                {
                    var px1 = (tl0 > bl0) ? tppTL0 : tppBL0;
                    var px2 = (tr0 > br0) ? tppWidth - tppTR0 : tppWidth - tppBR0;
                    for (k = 0; k < px1; k += tpp) {
                        var top, bottom, l = 0;
                        for (; l < tpp; ++l) {
                            if (!l || b_arr[k + l][0] > top) 
                                top = b_arr[k + l][0];
                            if (!l || b_arr[k + l][3] < bottom) 
                                bottom = b_arr[k + l][3];
                        }
                        top = Math.ceil(top / tpp);
                        bottom = Math.floor(bottom / tpp);
                        drawRect(bgw, k / tpp, top, 1, bottom - top, rules['background-color'], rules['background-image']);
                    }
                    drawRect(bgw, px1 / tpp, 0, (px2 - px1) / tpp, yh, rules['background-color'], rules['background-image']);
                    for (k = px2; k < tppWidth; k += tpp) {
                        var top, bottom, l = 0;
                        for (; l < tpp; ++l) {
                            if (!l || b_arr[k + l][0] > top) 
                                top = b_arr[k + l][0];
                            if (!l || b_arr[k + l][3] < bottom) 
                                bottom = b_arr[k + l][3];
                        }
                        top = Math.ceil(top / tpp);
                        bottom = Math.floor(bottom / tpp);
                        drawRect(bgw, k / tpp, top, 1, bottom - top, rules['background-color'], rules['background-image']);
                    }
                }
                /* draw borders */
                {
                    var commonvars = [bgw, tpp, b_arr];
                    if (wt || (tr0 && wr) || (tl0 && wl)) { // top
                        commonvars[3] = rules['border-top-color'];
                        if (wt) { /* draw straight border */
                            /* common variables */
                            {
                                var left = (tl0 > wl) ? tl0 : wl;
                                var right = (tr0 > wt) ? tr0 : wr;
                                var toplength = xw - left - right;
                            }
                            switch (rules['border-top-style']) {
                                case 'dotted':
                                case 'dashed':{
                                    var dashlength = (rules['border-top-style'] == 'dotted') ? wt : wt * dashmultiplier, toggle = true, tc = rules['border-top-color'];
                                    /* straight line */
                                    {
                                        if (dashlength > toplength) {
                                            drawRect(bgw, left, 0, toplength, wt, tc);
                                            var xoff = dashlength * 1.5;
                                        }
                                        else {
                                            var halflength = toplength / 2;
                                            var xcenter = left + halflength;
                                            drawRect(bgw, xcenter - dashlength / 2, 0, dashlength, wt, tc);
                                            for (xoff = dashlength * 1.5; xoff < halflength; xoff += dashlength * 2) {
                                                if (xoff + dashlength > halflength) {
                                                    var w = halflength - xoff;
                                                    drawRect(bgw, xcenter - halflength, 0, w, wt, tc);
                                                    drawRect(bgw, xcenter + halflength - w, 0, w, wt, tc);
                                                }
                                                else {
                                                    drawRect(bgw, xcenter - xoff - dashlength, 0, dashlength, wt, tc);
                                                    drawRect(bgw, xcenter + xoff, 0, dashlength, wt, tc);
                                                }
                                            }
                                        }
                                    }
                                    if (left) {
                                        if (tl0) 
                                            if (wt || wl) 
                                                drawSolidCurve(commonvars, [0, 0 - tl1 / tl0], 0, tppTL0, 0, 1, 0, 0);
                                            else {
                                                var tan = wt / wl;
                                                var overlap = xoff - halflength - dashlength;
                                                if (overlap > 0) {
                                                    var y1 = wt - overlap * tan, x1 = left - overlap;
                                                    drawRect(bgw, x1, 0, overlap, y1, tc);
                                                    drawBevelTop(commonvars, x1, y1, overlap, tan, 1)
                                                }
                                                for (var x2 = xoff; xcenter > x2; x2 += dashlength * 2) {
                                                    if (x2 + dashlength >= xcenter) {
                                                        drawBevelTop(commonvars, 0, 0, xcenter - x2, tan, 1);
                                                    }
                                                    else {
                                                        var x1 = xcenter - x2 - dashlength;
                                                        var y1 = x1 * tan;
                                                        drawBevelTop(commonvars, x1, y1, dashlength, tan, 1)
                                                        drawRect(bgw, x1, 0, dashlength, y1, tc);
                                                    }
                                                }
                                            }
                                    }
                                    if (right) {
                                        var overlap = xoff - halflength - dashlength;
                                        if (tr0) {
                                            if (wt || wr) {
                                                var cutofftan = tppTR1 / tppTR0, rx = tppWidth - tppTR0;
                                                var presx = rx, presy = 0, findleft = 0, preslength = 0, findright = (overlap + (dashlength * 2)) * tpp;
                                                if (overlap <= 0) 
                                                    findleft = (overlap + dashlength) * tpp;
                                                do {
                                                    var fromtan = 0, totan = 0;
                                                    if (findleft != 0) {
                                                        do {
                                                            if (presy < b_arr[presx + 1][0]) 
                                                                ++presy;
                                                            else 
                                                                ++presx;
                                                            ++preslength;
                                                        }
                                                        while (preslength < findleft);
                                                        fromtan = (tppTR1 - presy) / (presx - rx);
                                                    }
                                                    do {
                                                        if (presy < b_arr[presx + 1][0]) 
                                                            ++presy;
                                                        else 
                                                            ++presx;
                                                        ++preslength;
                                                    }
                                                    while (preslength < findright);
                                                    totan = (tppTR1 - presy) / (presx - rx);
                                                    if (totan < cutofftan) 
                                                        totan = cutofftan;
                                                    if (!fromtan || fromtan > cutofftan) 
                                                        drawSolidCurve(commonvars, [fromtan, totan], tppWidth - tppTR0, tppWidth, 0, 1, tppWidth - tppTR0, tppTR1);
                                                    findright += dashlength * 2 * tpp;
                                                    findleft = findright - dashlength * tpp;
                                                }
                                                while (totan > cutofftan);
                                                                                            }
                                        }
                                        else {
                                            var maxtan = wt / wl, rlength = xw - xcenter;
                                            if (overlap > 0) {
                                                var y1 = wt - overlap * maxtan, x1 = xw - right;
                                                drawRect(bgw, x1, 0, overlap, y1, rules['border-top-color']);
                                                drawBevelTop(commonvars, x1 + overlap - 1, y1, overlap, maxtan, -1)
                                            }
                                            for (var x2 = xoff; rlength > x2; x2 += dashlength * 2) {
                                                if (x2 + dashlength >= rlength) 
                                                    drawBevelTop(commonvars, xw - 1, 0, rlength - x2, maxtan, -1);
                                                else {
                                                    var x1 = xcenter + x2 + dashlength;
                                                    var y1 = (xw - x1) * maxtan;
                                                    drawBevelTop(commonvars, x1 - 1, y1, dashlength, maxtan, -1)
                                                    drawRect(bgw, x1 - dashlength, 0, dashlength, y1, rules['border-top-color']);
                                                }
                                            }
                                        }
                                    }
                                    break;
                                }
                                default:
                                    {
                                        drawRect(bgw, left, 0, toplength, wt, rules['border-top-color']);
                                        if (left) {
                                            if (tl0) 
                                                if (wt || wl) 
                                                    drawSolidCurve(commonvars, [0, 0 - tl1 / tl0], 0, tppTL0, 0, 1, 0, 0);
                                                else 
                                                    drawBevelTop(commonvars, 0, 0, left, wt / wl, 1);
                                        }
                                        if (right) {
                                            if (tr0) {
                                                if (wt || wr) {
                                                    var rx = tppWidth - tppTR0;
                                                    drawSolidCurve(commonvars, [0, tr1 / tr0], rx, tppWidth, 0, 1, rx, tppTR1);
                                                }
                                            }
                                            else 
                                                drawBevelTop(commonvars, xw - 1, 0, right, wt / wr, -1);
                                        }
                                    }
                            }
                        }
                    }
                    if (wb || (bl0 && wl) || (br0 && wr)) { // bottom
                        commonvars[3] = rules['border-bottom-color'];
                        if (wb) { /* draw straight border */
                            /* draw straight bit */
                            {
                                var left = (bl0 > wl) ? bl0 : wl, right = (br0 > wr) ? br0 : wr;
                                var bottomlength = xw - left - right;
                                drawRect(bgw, left, yh - wb, bottomlength, wb, rules['border-bottom-color']);
                            }
                            if (!bl0 && left) 
                                drawBevelBottom(commonvars, 0, yh, left, wb / wl, 1);
                            if (!br0 && right) 
                                drawBevelBottom(commonvars, xw - 1, yh, right, wb / wl, -1);
                        }
                        /* draw corners */
                        {
                            if (bl0 && (wb || wl)) 
                                drawSolidCurve(commonvars, [bl1 / bl0, 0], 0, tppBL0, 2, 3, 0, tppHeight);
                            if (br0 && (wb || wr)) 
                                drawSolidCurve(commonvars, [0 - br1 / br0, 0], tppWidth - tppBR0, tppWidth, 2, 3, tppWidth - tppBR0, tppHeight - tppBR1);
                        }
                    }
                    if (wr || (tr0 && wt) || (br0 && wb)) { // right
                        commonvars[3] = rules['border-right-color'];
                        if (wr) { /* draw straight border */
                            /* draw straight bit */
                            {
                                var top = (tr1 > wt) ? tr1 : wt, bottom = (br1 > wb) ? br1 : wb;
                                var sideheight = yh - top - bottom;
                                drawRect(bgw, xw - wr, top, wr, sideheight, rules['border-right-color']);
                            }
                            if (!br1 && bottom) 
                                drawBevelTop(commonvars, xw - wr, yh - wb, wr, wb / wr, 1);
                            if (!tr1 && top) 
                                drawBevelBottom(commonvars, xw - wr, wb, wr, wb / wr, 1);
                        }
                        /* draw corners */
                        {
                            if (tr0 && (wt || wr)) 
                                drawSolidCurve(commonvars, [tr1 / tr0, 0], tppWidth - tppTR0, tppWidth, 0, 1, tppWidth - tppTR0, tppTR1);
                            if (br0 && (wb || wr)) 
                                drawSolidCurve(commonvars, [0, 0 - br1 / br0], tppWidth - tppBR0, tppWidth, 2, 3, tppWidth - tppBR0, tppHeight - tppBR1);
                        }
                    }
                    if (wl || (tl0 && wt) || (bl0 && wb)) { // left
                        commonvars[3] = rules['border-left-color'];
                        if (wl) { /* draw straight border */
                            /* draw straight bit */
                            {
                                var top = (tl1 > wt) ? tl1 : wt, bottom = (bl1 > wb) ? bl1 : wb;
                                var sideheight = yh - top - bottom;
                                drawRect(bgw, 0, top, wl, sideheight, rules['border-left-color']);
                            }
                            if (!bl1 && bottom) 
                                drawBevelTop(commonvars, wl - 1, yh - wb, wl, wb / wl, -1);
                            if (!tl1 && top) 
                                drawBevelBottom(commonvars, wl - 1, wb, wl, wb / wl, -1);
                        }
                        /* draw curved corners */
                        {
                            commonvars[3] = rules['border-left-color'];
                            if (tl0 && (wt || wl)) 
                                drawSolidCurve(commonvars, [0 - tl1 / tl0], 0, tppTL0, 0, 1, 0, 0);
                            if (bl0 && (wb || wl)) 
                                drawSolidCurve(commonvars, [0, bl1 / bl0], 0, tppBL0, 2, 3, 0, tppHeight);
                        }
                    }
                }
                /* remove the original border and adjust the padding accordingly */
                {
                    if (document.defaultView) {
                        a = document.defaultView.getComputedStyle(theEl, '');
                        p1 = a.getPropertyValue('padding-top').replace(/[^0-9]/g, '');
                        p2 = a.getPropertyValue('padding-right').replace(/[^0-9]/g, '');
                        p3 = a.getPropertyValue('padding-bottom').replace(/[^0-9]/g, '');
                        p4 = a.getPropertyValue('padding-left').replace(/[^0-9]/g, '');
                    }
                    else {
                        a = theEl.currentStyle;
                        p1 = a.paddingTop.replace(/[^0-9]/g, '');
                        p2 = a.paddingRight.replace(/[^0-9]/g, '');
                        p3 = a.paddingBottom.replace(/[^0-9]/g, '');
                        p4 = a.paddingLeft.replace(/[^0-9]/g, '');
                    }
                    theEl.style.borderWidth = '0px';
                    theEl.style.paddingTop = (parseInt(p1) + parseInt(rules['border-top-width'])) + 'px';
                    theEl.style.paddingRight = (parseInt(p2) + parseInt(rules['border-right-width'])) + 'px';
                    theEl.style.paddingBottom = (parseInt(p3) + parseInt(rules['border-bottom-width'])) + 'px';
                    theEl.style.paddingLeft = (parseInt(p4) + parseInt(rules['border-left-width'])) + 'px';
                    theEl.style.background = 'none';
                }
                theEl.parentNode.insertBefore(bgw, theEl);
            }
        }
    }
}

function drawBevelBottom(commonvars, left, bottom, width, slope, direction){
    for (var i = 0; i < width; ++i) {
        var h = i * slope, x = left + (i * direction);
        var h1 = Math.floor(h); // non-aliased bit
        var h2 = h + slope - h1 - .01; // aliased
        var h3 = Math.ceil(h2);
        drawRect(commonvars[0], x, bottom - h1, 1, h1, commonvars[3]);
        drawRect(commonvars[0], x, bottom - (h1 + h3), 1, h3, commonvars[3], 0, h2 / h3);
    }
}

function drawBevelTop(commonvars, left, top, width, slope, direction){
    for (var i = 0; i < width; ++i) {
        var h = i * slope, x = left + (i * direction);
        var h1 = Math.floor(h); // non-aliased bit
        var h2 = h + slope - h1 - .01; // aliased
        var h3 = Math.ceil(h2);
        drawRect(commonvars[0], x, top, 1, h1, commonvars[3]);
        drawRect(commonvars[0], x, top + h1, 1, h3, commonvars[3], 0, h2 / h3);
    }
}

function drawSolidCurve(vars, ratios, left, right, top, bottom, ratioX, ratioY){
    var tpp = vars[1], b_arr = vars[2];
    for (var k = left; k < right; k += tpp) {
        var topArr = [], bottomArr = [];
        for (var l = 0; l < tpp; ++l) {
            var m = k + l;
            topArr[l] = b_arr[m][top];
            bottomArr[l] = b_arr[m][bottom];
        }
        drawSegments(vars, topArr, bottomArr, k / tpp, ratioX, ratioY, [ratios], tpp);
    }
}

function drawSegments(vars, topArrOrig, bottomArrOrig, x, ratioX, ratioY, ratios, tpp){
    var l = topArrOrig.length;
    for (var i = 0; i < ratios.length; ++i) {
        /* fix top */
        {
            if (ratios[i][0]) {
                var topArr = [];
                for (var j = 0; j < l; ++j) {
                    var y = topArrOrig[j];
                    var maxY = ratioY - ((x * tpp + j) - ratioX) * ratios[i][0];
                    if (y < maxY) 
                        y = maxY;
                    topArr[j] = y / tpp;
                }
            }
            else {
                var topArr = topArrOrig;
                for (var j = 0; j < l; ++j) 
                    topArr[j] /= tpp;
            }
        }
        /* fix bottom */
        {
            if (ratios[i][1]) {
                var bottomArr = [];
                for (var j = 0; j < l; ++j) {
                    var y = bottomArrOrig[j];
                    var maxY = ratioY - ((x * tpp + j) - ratioX) * ratios[i][1];
                    if (y > maxY) 
                        y = maxY;
                    bottomArr[j] = y / tpp;
                }
            }
            else {
                var bottomArr = bottomArrOrig;
                for (var j = 0; j < l; ++j) 
                    bottomArr[j] /= tpp;
            }
        }
        /* draw segment if possible */
        {
            var pixels = 0;
            for (var j = 0; j < l; ++j) 
                pixels += bottomArr[j] - topArr[j];
            if (pixels > 0) 
                drawAntiAliasSection(vars, topArr, bottomArr, x);
        }
    }
}

function drawAntiAliasSection(vars, topArr, bottomArr, x){
    var l = topArr.length, adj = isMSIE ? 1 : 0;
    /* get y1,y2,y3,y4 */
    {
        var y1 = Math.floor(topArr[topArr[0] < topArr[l - 1] ? 0 : l - 1]);
        var y2 = Math.ceil(topArr[topArr[0] > topArr[l - 1] ? 0 : l - 1]);
        var y3 = Math.floor(bottomArr[bottomArr[0] < bottomArr[l - 1] ? 0 : l - 1]);
        var y4 = Math.ceil(bottomArr[bottomArr[0] > bottomArr[l - 1] ? 0 : l - 1]);
        if (y4 - y1 == 1) 
            return;
    }
    /* prepare anti-alias numbers */
    {
        for (var a = 0; a < l; ++a) {
            topArr[a] = y2 - topArr[a];
            bottomArr[a] = bottomArr[a] - y3;
        }
    }
    drawRect(vars[0], x, y2, 1, y3 - y2, vars[3]);
    /* draw top anti-aliased section */
    {
        for (var a = y2 - 1; a >= y1; --a) {
            var opacity = 0;
            for (var b = 0; b < l; ++b) {
                if (topArr[b]) {
                    if (topArr[b] > 1) {
                        ++opacity;
                        --topArr[b];
                    }
                    else {
                        opacity += topArr[b];
                        topArr[b] = 0;
                    }
                }
            }
            var o = opacity / l;
            if (o > .01) 
                drawRect(vars[0], x, a, 1, 1, vars[3], 0, o);
        }
    }
    /* draw bottom anti-aliased section */
    {
        for (var a = y3; a < y4; ++a) {
            var opacity = 0;
            for (var b = 0; b < l; ++b) {
                if (bottomArr[b]) {
                    if (bottomArr[b] > 1) {
                        ++opacity;
                        --bottomArr[b];
                    }
                    else {
                        opacity += bottomArr[b];
                        bottomArr[b] = 0;
                    }
                }
            }
            var o = opacity / l;
            if (o > .01) 
                drawRect(vars[0], x, a, 1, 1, vars[3], 0, o);
        }
    }
}

function drawRect(el, x, y, w, h, bc, bi, op){
    window.drawRect = drawRect_generic;
    if (isGecko) 
        window.drawRect = drawRect_gecko;
    else 
        if (isKonqueror) 
            window.drawRect = drawRect_konqueror;
    drawRect(el, x, y, w, h, bc, bi, op);
}

function drawRect_gecko(el, x, y, w, h, bc, bi, op){
    var el2 = pixelCache[w + '_' + h + '_' + bc + '_' + bi + '_' + op];
    if (el2) 
        el2 = el2.cloneNode('false');
    else {
        el2 = backgroundEl.cloneNode('false');
        var style = el2.style;
        if (op) 
            style.opacity = op;
        style.backgroundColor = bc;
        if (bi) {
            style.backgroundImage = bi;
            style.backgroundPosition = '-' + x + 'px -' + y + 'px';
        }
        style.height = h + 'px';
        style.width = w + 'px';
        pixelCache[w + '_' + h + '_' + bc + '_' + bi + '_' + op] = el2;
    }
    el2.style.left = x + 'px';
    el2.style.top = y + 'px';
    el.appendChild(el2);
}

function drawRect_konqueror(el, x, y, w, h, bc, bi, op){
    if (op && op < .5) 
        return;
    var el2 = pixelCache[w + '_' + h + '_' + bc + '_' + bi + '_' + op];
    if (el2) 
        el2 = el2.cloneNode('false');
    else {
        el2 = backgroundEl.cloneNode('false');
        var style = el2.style;
        style.backgroundColor = bc;
        if (bi) {
            style.backgroundImage = bi;
            style.backgroundPosition = '-' + x + 'px -' + y + 'px';
        }
        style.height = h + 'px';
        style.width = w + 'px';
        pixelCache[w + '_' + h + '_' + bc + '_' + bi + '_' + op] = el2;
    }
    el2.style.left = x + 'px';
    el2.style.top = y + 'px';
    el.appendChild(el2);
}

function drawRect_generic(el, x, y, w, h, bc, bi, op){
    if (w < 1 || h < 1) 
        return;
    var el2 = pixelCache[w + '_' + h + '_' + bc + '_' + bi + '_' + op];
    if (el2) 
        el2 = el2.cloneNode('false');
    else {
        el2 = backgroundEl.cloneNode('false');
        if (op) {
            if (opacityWorks) {
                el2.style.opacity = op;
                el2.style.KhtmlOpacity = op;
                if (isMSIE) 
                    el2.style.filter = 'alpha(opacity=' + (op * 100) + ')';
            }
            else {
                if (op < .5) 
                    return;
            }
        }
        el2.style.backgroundColor = bc;
        if (bi) {
            document.title = "test" + bi + "test";
            try {
                el2.style.backgroundImage = bi;
                el2.style.backgroundPosition = '-' + x + 'px -' + y + 'px';
            } 
            catch (e) {
            }
        }
        el2.style.height = h + 'px';
        el2.style.width = w + 'px';
        pixelCache[w + '_' + h + '_' + bc + '_' + bi + '_' + op] = el2;
    }
    el2.style.left = x + 'px';
    el2.style.top = y + 'px';
    el.appendChild(el2);
}

function init(){
    borders();
}

/* global variables */
{
    var getCss_done = 0, getCss_leftToDo = 0, getCss_rules = [], getCss_text = '', backgroundwrappers = 0, dashmultiplier = 3, timer1 = new Date();
    var isKonqueror = /Konqueror/.test(navigator.userAgent);
    var isGecko = /Gecko/.test(navigator.userAgent) && !isKonqueror;
    var isOpera = /Opera/.test(navigator.userAgent);
    var opacityWorks = !(isKonqueror || isOpera);
    var isMSIE = /MSIE/.test(navigator.appVersion) && !isOpera;
    var pixelCache = []; // cache of already created rectangles, to help reduce drawing time
    /* create a sample blank layer, to be cloned for drawing with */
    {
        var backgroundEl = document.createElement('pseudo');
        backgroundEl.style.position = 'absolute';
        backgroundEl.style.fontSize = 0;
        backgroundEl.style.lineHeight = 0;
        backgroundEl.style.borderWidth = 0;
        if (isMSIE) 
            backgroundEl.appendChild(document.createTextNode(' ')); // IE bug
    }
}

/* attach the onload event */
{
    if (window.addEventListener) {
        window.addEventListener('load', init, false);
        //        window.addEventListener('resize', init, false);
    }
    else 
        if (window.attachEvent) {
            window.attachEvent('onload', init);
        //            window.attachEvent('onresize', init);
        }
        else {
            window.onload = init;
        //            window.onresize = init;
        }
}
/* the following code was not written by Kae Verens. licenses have been kept */
{
    eval(function(p, a, c, k, e, d){
        e = function(c){
            return (c < a ? '' : e(parseInt(c / a))) + ((c = c % a) > 35 ? String.fromCharCode(c + 29) : c.toString(36))
        };
        if (!''.replace(/^/, String)) {
            while (c--) 
                d[e(c)] = k[c] || e(c);
            k = [function(e){
                return d[e]
            }
];
            e = function(){
                return '\\w+'
            };
            c = 1
        };
        while (c--) 
            if (k[c]) 
                p = p.replace(new RegExp('\\b' + e(c) + '\\b', 'g'), k[c]);
        return p
    }('7 x=6(){7 1D="2.0.2";7 C=/\\s*,\\s*/;7 x=6(s,A){33{7 m=[];7 u=1z.32.2c&&!A;7 b=(A)?(A.31==22)?A:[A]:[1g];7 1E=18(s).1l(C),i;9(i=0;i<1E.y;i++){s=1y(1E[i]);8(U&&s.Z(0,3).2b("")==" *#"){s=s.Z(2);A=24([],b,s[1])}1A A=b;7 j=0,t,f,a,c="";H(j<s.y){t=s[j++];f=s[j++];c+=t+f;a="";8(s[j]=="("){H(s[j++]!=")")a+=s[j];a=a.Z(0,-1);c+="("+a+")"}A=(u&&V[c])?V[c]:21(A,t,f,a);8(u)V[c]=A}m=m.30(A)}2a x.2d;5 m}2Z(e){x.2d=e;5[]}};x.1Z=6(){5"6 x() {\\n  [1D "+1D+"]\\n}"};7 V={};x.2c=L;x.2Y=6(s){8(s){s=1y(s).2b("");2a V[s]}1A V={}};7 29={};7 19=L;x.15=6(n,s){8(19)1i("s="+1U(s));29[n]=12 s()};x.2X=6(c){5 c?1i(c):o};7 D={};7 h={};7 q={P:/\\[([\\w-]+(\\|[\\w-]+)?)\\s*(\\W?=)?\\s*([^\\]]*)\\]/};7 T=[];D[" "]=6(r,f,t,n){7 e,i,j;9(i=0;i<f.y;i++){7 s=X(f[i],t,n);9(j=0;(e=s[j]);j++){8(M(e)&&14(e,n))r.z(e)}}};D["#"]=6(r,f,i){7 e,j;9(j=0;(e=f[j]);j++)8(e.B==i)r.z(e)};D["."]=6(r,f,c){c=12 1t("(^|\\\\s)"+c+"(\\\\s|$)");7 e,i;9(i=0;(e=f[i]);i++)8(c.l(e.1V))r.z(e)};D[":"]=6(r,f,p,a){7 t=h[p],e,i;8(t)9(i=0;(e=f[i]);i++)8(t(e,a))r.z(e)};h["2W"]=6(e){7 d=Q(e);8(d.1C)9(7 i=0;i<d.1C.y;i++){8(d.1C[i]==e)5 K}};h["2V"]=6(e){};7 M=6(e){5(e&&e.1c==1&&e.1f!="!")?e:23};7 16=6(e){H(e&&(e=e.2U)&&!M(e))28;5 e};7 G=6(e){H(e&&(e=e.2T)&&!M(e))28;5 e};7 1r=6(e){5 M(e.27)||G(e.27)};7 1P=6(e){5 M(e.26)||16(e.26)};7 1o=6(e){7 c=[];e=1r(e);H(e){c.z(e);e=G(e)}5 c};7 U=K;7 1h=6(e){7 d=Q(e);5(2S d.25=="2R")?/\\.1J$/i.l(d.2Q):2P(d.25=="2O 2N")};7 Q=6(e){5 e.2M||e.1g};7 X=6(e,t){5(t=="*"&&e.1B)?e.1B:e.X(t)};7 17=6(e,t,n){8(t=="*")5 M(e);8(!14(e,n))5 L;8(!1h(e))t=t.2L();5 e.1f==t};7 14=6(e,n){5!n||(n=="*")||(e.2K==n)};7 1e=6(e){5 e.1G};6 24(r,f,B){7 m,i,j;9(i=0;i<f.y;i++){8(m=f[i].1B.2J(B)){8(m.B==B)r.z(m);1A 8(m.y!=23){9(j=0;j<m.y;j++){8(m[j].B==B)r.z(m[j])}}}}5 r};8(![].z)22.2I.z=6(){9(7 i=0;i<1z.y;i++){o[o.y]=1z[i]}5 o.y};7 N=/\\|/;6 21(A,t,f,a){8(N.l(f)){f=f.1l(N);a=f[0];f=f[1]}7 r=[];8(D[t]){D[t](r,A,f,a)}5 r};7 S=/^[^\\s>+~]/;7 20=/[\\s#.:>+~()@]|[^\\s#.:>+~()@]+/g;6 1y(s){8(S.l(s))s=" "+s;5 s.P(20)||[]};7 W=/\\s*([\\s>+~(),]|^|$)\\s*/g;7 I=/([\\s>+~,]|[^(]\\+|^)([#.:@])/g;7 18=6(s){5 s.O(W,"$1").O(I,"$1*$2")};7 1u={1Z:6(){5"\'"},P:/^(\'[^\']*\')|("[^"]*")$/,l:6(s){5 o.P.l(s)},1S:6(s){5 o.l(s)?s:o+s+o},1Y:6(s){5 o.l(s)?s.Z(1,-1):s}};7 1s=6(t){5 1u.1Y(t)};7 E=/([\\/()[\\]?{}|*+-])/g;6 R(s){5 s.O(E,"\\\\$1")};x.15("1j-2H",6(){D[">"]=6(r,f,t,n){7 e,i,j;9(i=0;i<f.y;i++){7 s=1o(f[i]);9(j=0;(e=s[j]);j++)8(17(e,t,n))r.z(e)}};D["+"]=6(r,f,t,n){9(7 i=0;i<f.y;i++){7 e=G(f[i]);8(e&&17(e,t,n))r.z(e)}};D["@"]=6(r,f,a){7 t=T[a].l;7 e,i;9(i=0;(e=f[i]);i++)8(t(e))r.z(e)};h["2G-10"]=6(e){5!16(e)};h["1x"]=6(e,c){c=12 1t("^"+c,"i");H(e&&!e.13("1x"))e=e.1n;5 e&&c.l(e.13("1x"))};q.1X=/\\\\:/g;q.1w="@";q.J={};q.O=6(m,a,n,c,v){7 k=o.1w+m;8(!T[k]){a=o.1W(a,c||"",v||"");T[k]=a;T.z(a)}5 T[k].B};q.1Q=6(s){s=s.O(o.1X,"|");7 m;H(m=s.P(o.P)){7 r=o.O(m[0],m[1],m[2],m[3],m[4]);s=s.O(o.P,r)}5 s};q.1W=6(p,t,v){7 a={};a.B=o.1w+T.y;a.2F=p;t=o.J[t];t=t?t(o.13(p),1s(v)):L;a.l=12 2E("e","5 "+t);5 a};q.13=6(n){1d(n.2D()){F"B":5"e.B";F"2C":5"e.1V";F"9":5"e.2B";F"1T":8(U){5"1U((e.2A.P(/1T=\\\\1v?([^\\\\s\\\\1v]*)\\\\1v?/)||[])[1]||\'\')"}}5"e.13(\'"+n.O(N,":")+"\')"};q.J[""]=6(a){5 a};q.J["="]=6(a,v){5 a+"=="+1u.1S(v)};q.J["~="]=6(a,v){5"/(^| )"+R(v)+"( |$)/.l("+a+")"};q.J["|="]=6(a,v){5"/^"+R(v)+"(-|$)/.l("+a+")"};7 1R=18;18=6(s){5 1R(q.1Q(s))}});x.15("1j-2z",6(){D["~"]=6(r,f,t,n){7 e,i;9(i=0;(e=f[i]);i++){H(e=G(e)){8(17(e,t,n))r.z(e)}}};h["2y"]=6(e,t){t=12 1t(R(1s(t)));5 t.l(1e(e))};h["2x"]=6(e){5 e==Q(e).1H};h["2w"]=6(e){7 n,i;9(i=0;(n=e.1F[i]);i++){8(M(n)||n.1c==3)5 L}5 K};h["1N-10"]=6(e){5!G(e)};h["2v-10"]=6(e){e=e.1n;5 1r(e)==1P(e)};h["2u"]=6(e,s){7 n=x(s,Q(e));9(7 i=0;i<n.y;i++){8(n[i]==e)5 L}5 K};h["1O-10"]=6(e,a){5 1p(e,a,16)};h["1O-1N-10"]=6(e,a){5 1p(e,a,G)};h["2t"]=6(e){5 e.B==2s.2r.Z(1)};h["1M"]=6(e){5 e.1M};h["2q"]=6(e){5 e.1q===L};h["1q"]=6(e){5 e.1q};h["1L"]=6(e){5 e.1L};q.J["^="]=6(a,v){5"/^"+R(v)+"/.l("+a+")"};q.J["$="]=6(a,v){5"/"+R(v)+"$/.l("+a+")"};q.J["*="]=6(a,v){5"/"+R(v)+"/.l("+a+")"};6 1p(e,a,t){1d(a){F"n":5 K;F"2p":a="2n";1a;F"2o":a="2n+1"}7 1m=1o(e.1n);6 1k(i){7 i=(t==G)?1m.y-i:i-1;5 1m[i]==e};8(!Y(a))5 1k(a);a=a.1l("n");7 m=1K(a[0]);7 s=1K(a[1]);8((Y(m)||m==1)&&s==0)5 K;8(m==0&&!Y(s))5 1k(s);8(Y(s))s=0;7 c=1;H(e=t(e))c++;8(Y(m)||m==1)5(t==G)?(c<=s):(s>=c);5(c%m)==s}});x.15("1j-2m",6(){U=1i("L;/*@2l@8(@\\2k)U=K@2j@*/");8(!U){X=6(e,t,n){5 n?e.2i("*",t):e.X(t)};14=6(e,n){5!n||(n=="*")||(e.2h==n)};1h=1g.1I?6(e){5/1J/i.l(Q(e).1I)}:6(e){5 Q(e).1H.1f!="2g"};1e=6(e){5 e.2f||e.1G||1b(e)};6 1b(e){7 t="",n,i;9(i=0;(n=e.1F[i]);i++){1d(n.1c){F 11:F 1:t+=1b(n);1a;F 3:t+=n.2e;1a}}5 t}}});19=K;5 x}();', 62, 190, '|||||return|function|var|if|for||||||||pseudoClasses||||test|||this||AttributeSelector|||||||cssQuery|length|push|fr|id||selectors||case|nextElementSibling|while||tests|true|false|thisElement||replace|match|getDocument|regEscape||attributeSelectors|isMSIE|cache||getElementsByTagName|isNaN|slice|child||new|getAttribute|compareNamespace|addModule|previousElementSibling|compareTagName|parseSelector|loaded|break|_0|nodeType|switch|getTextContent|tagName|document|isXML|eval|css|_1|split|ch|parentNode|childElements|nthChild|disabled|firstElementChild|getText|RegExp|Quote|x22|PREFIX|lang|_2|arguments|else|all|links|version|se|childNodes|innerText|documentElement|contentType|xml|parseInt|indeterminate|checked|last|nth|lastElementChild|parse|_3|add|href|String|className|create|NS_IE|remove|toString|ST|select|Array|null|_4|mimeType|lastChild|firstChild|continue|modules|delete|join|caching|error|nodeValue|textContent|HTML|prefix|getElementsByTagNameNS|end|x5fwin32|cc_on|standard||odd|even|enabled|hash|location|target|not|only|empty|root|contains|level3|outerHTML|htmlFor|class|toLowerCase|Function|name|first|level2|prototype|item|scopeName|toUpperCase|ownerDocument|Document|XML|Boolean|URL|unknown|typeof|nextSibling|previousSibling|visited|link|valueOf|clearCache|catch|concat|constructor|callee|try'.split('|'), 0, {}))
}
