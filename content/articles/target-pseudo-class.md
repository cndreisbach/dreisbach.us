---
title: "The :target pseudo-class"
date: 2018-04-27T14:50:03-04:00
draft: false
---

I just learned about the `:target` pseudo-class in CSS and it is pretty amazing. It targets the element with an id equal to the URL's fragment (the hash part at the end.) This can be used with plain old links to create features that would normally require JavaScript. [This CodePen shows a hamburger menu implemented with it.](https://codepen.io/markcaron/pen/pPZVWO)

The way this works is brilliant. The hamburger icon is a link to `#main-menu`. When clicked, the URL changes to have the fragment `#main-menu` without reloading the page, as fragment changes don't trigger a reload. The element with the id `main-menu` is normally positioned 200px left of the page, so that it's hidden, but `#main-menu:target` is positioned on the page, so as that URL fragment changes, the menu appears. The menu can be closed by clicking a link that doesn't have that fragment, thereby making the menu disappear.


