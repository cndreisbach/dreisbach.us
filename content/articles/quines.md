---
title: "Quines!"
date: 2012-02-17T10:40:10-04:00
draft: false
aliases:
  - /blog/quines/
---

[firebug]: http://getfirebug.com/
[node]: http://nodejs.org/
[worms]: https://en.wikipedia.org/wiki/Computer_worm
[matrix]: https://en.wikipedia.org/wiki/The_Matrix
[lua]: http://www.lua.org/
[trylua]: http://trylua.org/

A quine is a program that, when run, outputs itself. Here's one you can run in your browser: `quine = function () { console.log("quine = %s; quine()", quine) }; quine()`.

{{< figure src="/img/quines/quines.jpg" alt="Whorld" caption="\"Whorld\" by Zol, using Context Free Art" >}}

If you are using Chrome or Safari to look at this page, you can get to a Javascript console by going to your menu and choosing Tools > Javascript Console. If you are not using one of those, try installing [Firebug][firebug] in Firefox, or download [node.js][node] and try this at a terminal. Paste the above code into your console and hit enter, and you should see output that looks just like the code. (You might see some extra spaces, depending on what browser or console you are using.)

How does that work? In most versions of Javascript, you can print a function out into a string and get the original source code. You can see that we are repeating our program inside of the string we are printing out. The `%s` lets us substitute in another piece of information from outside the string. In this case, we substitute the function back into the string, allowing us to print out the original code.

The idea of a program that can duplicate itself is amazing. From the simple program above, we get real-world ideas [computer worms][worms] and science-fiction like [The Matrix][matrix]. Self-replication is the key to life, and you can make it in just a few lines of code.

To understand how to make your own quine, let's create one using a programming language called [Lua][lua]. You probably don't have Lua on your computer, but you can use it online at [Try Lua][trylua]. We know that we want the output of the program to be itself, but let's start just by outputting something. (The `-->` indicates the output of the program.)

```lua
print("quine")
--> quine
```

That obviously doesn't print the program. We printed the "quine" part, but we need to print the "print" part too. How about this?

```lua
print("print \"quine\"")
--> print "quine"
```

This is going to end up going on forever, with us adding more `print`s to the front and never getting there. In our Javascript version, we could output the function as text, but we can't do that in Lua. What should we do? Let's try saving the program in a string.

```lua
quine = "print(quine)"; print(quine)
--> print(quine)
```

This is getting somewhere! How do we get the assignment into the output, too?

```lua
quine = "quine = \"print(quine)\"; print(quine)"; print(quine)
--> quine = "print(quine)"; print(quine)
```

We have the same problem as before: we keep having to add another section to the front which doesn't get printed. What we need is a way to substitute into the string, like we had in our Javascript version with the `%s`. Lua has that capability with its `string.format` function. (I'm going to break up the rest of the code into multiple lines for ease of reading. That may make the quines not exact, in that the spacing may be different, but they should work if you put them on one line.)

```lua
quine = "quine = %s; print(string.format(quine, quine))";
print(string.format(quine, quine))
--> quine = quine = %s; print(string.format(quine, quine));
--> print(string.format(quine, quine))
```

Oh, man! That almost worked, but if you look close, you can see we are missing the quotes around the string from our original source. Reading the Lua documentation, I found what we need, `%q`. According to the docs, "The q option formats a string in a form suitable to be safely read back by the Lua interpreter: the string is written between double quotes, and all double quotes, newlines, embedded zeros, and backslashes in the string are correctly escaped when written." Let's try it.

```lua
quine = "quine = %q; print(string.format(quine, quine))";
print(string.format(quine, quine))
--> quine = "quine = %q; print(string.format(quine, quine))";
--> print(string.format(quine, quine))
```

That worked! It helped that we had a way to render the string inside itself with quotes. Not all languages have this, though, so you might have to resort to trickier solutions. Can you tell why the following Lua version works, even though it doesn't use `%q`? What would happen if we tried to escape quotes in the string?

```lua
quine = "quine = %s%s%s; \
print(string.format(quine, string.char(34), quine, string.char(34)))";
print(string.format(quine, string.char(34), quine, string.char(34)))
```

See if you can write a quine in your favorite language, and if so, post a comment with it. If you enjoyed this, check out the further reading.

### Further reading

* [_Godel, Escher, Bach_ by Douglas Hofstadter](https://en.wikipedia.org/wiki/G%C3%B6del%2C_Escher%2C_Bach)
* [The Quine Page](http://www.nyx.net/~gthompso/quine.htm)
* [Web Page That Shows Its Own Source Code](http://www.win.tue.nl/~wstomv/edu/javascript/quine.html)
