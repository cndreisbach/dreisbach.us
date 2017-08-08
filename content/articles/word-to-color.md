---
title: "Word to color"
date: 2017-02-13T00:00:00-04:00
draft: false
aliases:
  - /blog/word-to-color/
---

I had to write some code today to convert words into colors, which was a lot of fun. I liked it so such I had to put a working example online.

<!--more-->

<div>
<input type="text" placeholder="type a word here" id="wordToColor" value="" />
<div id="colorBlock" style="display: inline-block; width: 100px; height: 50px; vertical-align: top;"></div>
</div>

---

The code is a simple function. How it works:

1. We have three channels: red, green, and blue.
2. Iterate over the word, with the first character adding to red, the second to green, and the third to blue. This continues for the whole word.
3. Add the Unicode value of the character to a sum. Each time you add a new letter, multiply the value by a multiplier. This multiplier starts at 11 and is multiplied by 11 every time you go through three letters.
4. Mod each sum by 256 to get the channel value.

```javascript
function colorHash(str) {
    var mul = 11;
    var sums = [0, 0, 0];
    var i;

    if (str.length === 0) { return [255, 255, 255] }

    for (i = 0; i < str.length; i++) {
        sums[i % 3] += (str.charCodeAt(i) * mul);
        if ((i % 3) == 2) {
            mul *= 11;
        }
    }

    for (i = 0; i < 3; i++) {
        sums[i] = sums[i] % 256;
    }

    return sums;
}

function toRGBA(sums, alpha) {
    var rgba = "rgba(";
    rgba += sums.map(function (x) { return x.toString() }).join(",")
    rgba += "," + alpha + ")";
    return rgba;
}
```

<script>
function colorHash(str) {
    var mul = 11;
    var sums = [0, 0, 0];
    var i;

    if (str.length === 0) { return [255, 255, 255] }

    for (i = 0; i < str.length; i++) {
        sums[i % 3] += (str.charCodeAt(i) * mul);
        if ((i % 3) == 2) {
            mul *= 11;
        }
    }

    for (i = 0; i < 3; i++) {
        sums[i] = sums[i] % 256;
    }

    return sums;
}

function toRGBA(sums, alpha) {
    var rgba = "rgba(";
    rgba += sums.map(function (x) { return x.toString() }).join(",")
    rgba += "," + alpha + ")";
    return rgba;
}

var wordToColor = document.getElementById("wordToColor");
wordToColor.addEventListener('keyup', function (event) {
    var field = event.target;
    var text = field.value;
    field.setAttribute("style", "background-color: " + toRGBA(colorHash(text), 0.5) + ";");
    document.getElementById("colorBlock").style.backgroundColor = toRGBA(colorHash(text), 1);
    event.preventDefault();
});
</script>
