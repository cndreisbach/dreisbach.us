---
title: "beginPath and games"
date: 2018-08-16T19:45:23-04:00
draft: false
---

I got bit hard by a bug when making a canvas-based web game today. I forgot to call `context.beginPath()` after drawing some lines, and [as I found out on Stack Overflow, this will kill your framerate.](https://stackoverflow.com/questions/9558895/html5-canvas-slows-down-with-each-stroke-and-clear)
