---
title: "Prevent content jumps when loading images"
date: 2018-07-06T13:48:06-04:00
draft: false
---

Web pages often shift their content around while loading images and other data. Using [skeleton screens](http://hannahatkin.com/skeleton-screens/) is one approach to prevent this. If you know the width and height you want to display for the image you're loading, this is pretty easy to implement by setting the width and height in the CSS, along with a background color.

<!--more-->

<p data-height="265" data-theme-id="0" data-slug-hash="JZQqPM" data-default-tab="css,result" data-user="cndreisbach" data-embed-version="2" data-pen-title="Fixed size image loading" class="codepen">See the Pen <a href="https://codepen.io/cndreisbach/pen/JZQqPM/">Fixed size image loading</a> by Clinton Dreisbach (<a href="https://codepen.io/cndreisbach">@cndreisbach</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

If your image is responsive, however, this is harder, as you have to calculate the height. If your image width is, for example, 50% of the page, how do you calculate the height? There's ways to do this in JavaScript, but there's an easier way to do it in CSS.

This solution is based around the fact that padding in CSS is relative to the width of the element. Given that, we can make a container for our image with a percentage-based width, a height of 0, and padding on the bottom based on our picture's aspect ratio. If you have a picture that is 4:3, and it should take up 50% of the page, the padding we will use is 37.5% (50% * 3/4). Give the container `position: relative` and set the image to have 100% height and width and give it `position: absolute`.

<p data-height="265" data-theme-id="0" data-slug-hash="vroYwm" data-default-tab="css,result" data-user="cndreisbach" data-embed-version="2" data-pen-title="Percentage size image loading" class="codepen">See the Pen <a href="https://codepen.io/cndreisbach/pen/vroYwm/">Percentage size image loading</a> by Clinton Dreisbach (<a href="https://codepen.io/cndreisbach">@cndreisbach</a>) on <a href="https://codepen.io">CodePen</a>.</p>
<script async src="https://static.codepen.io/assets/embed/ei.js"></script>

Credit where it is due: I found this trick [in this answer from Stack Overflow](https://stackoverflow.com/a/11243324).
