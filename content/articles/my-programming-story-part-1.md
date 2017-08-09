---
title: "My programming story, part 1"
subtitle: "The BASICs (1984)"
date: 2014-12-09T09:35:27-04:00
draft: false
aliases:
  - /blog/my-programming-story-part-1/
---

I wrote my first program on an [IBM PC XT](https://en.wikipedia.org/wiki/IBM_Personal_Computer_XT) my parents had bought to run the books for their farm. It was in the [BASIC](https://en.wikipedia.org/wiki/BASIC) programming language.

<iframe width="560" height="315" src="//www.youtube.com/embed/VfvGS7qJr4M" frameborder="0" allowfullscreen></iframe>

That computer came with a collection of ring binders, one of which contained [a reference for BASIC](http://www.retroarchive.org/dos/docs/basic_ref_1.pdf).

![Binder cover](https://upload.wikimedia.org/wikipedia/en/5/58/IBM_tech_ref_640.jpg)

I don't remember what the first thing I wrote was, but it probably looked like this:

```basic
10 PRINT "CLINT IS AWESOME"
20 GOTO 10
```

I went by Clint back then. Now only my mom calls me that, and my wife when she wants to get on my nerves.

Anyway, that code would print out `CLINT IS AWESOME` in an infinite loop. I didn't get very far with BASIC on the PC XT, because as soon as my parents saw I could tell the computer what to do, they got pretty worried about their books in Lotus 1-2-3.

A few weeks later, they came home from the John Deere tractor store with an [IBM PCjr](http://www.old-computers.com/museum/computer.asp?st=1&c=186). I know that sounds impossible, but IBM sold computers through the tractor store. The PCjr was not selling well -- it was an odd idea for a computer with even odder execution -- so they were heavily discounted. I was lucky for that: my parents got the upgraded version with 256KB of RAM. The PCjr had no hard drive, only a floppy drive and two slots for cartridges.

![IBM PCjr](/img/my-programming-story/ibm_pcjr_with_display_medium.jpg)

What the PCjr did have, however, is one of the best books introducing people to programming that I can imagine for the time (1983). *Hands-On BASIC* was written by Arthur Luehrmann and Herbert Peckham, who had founded a partnership called "Computer Literacy" to create better educational materials for use with computers.

![Hands-On BASIC table of contents](/img/my-programming-story/hands-on-basic.jpg)

Every section had detailed instructions with pictures, questions for you to think about, and fun projects. I dream of creating my own book based off its style someday. It would use [Racket](http://racket-lang.org/) as the programming language, as I think it's about as close as you can get to the self-contained nature that BASIC had back then.

I had that computer for 7 years and programmed on it every day. I wrote games, invoicing systems, imaginary friends, dice rollers, and music compositions on it, all in BASIC.

---

Earlier this year when I accepted my job at The Iron Yard, I knew I'd be teaching Ruby. It had been over 2 years since I'd written Ruby. I felt confident, but needed a warm-up. To do so, I wrote [a BASIC interpreter in Ruby](https://github.com/cndreisbach/redbasic). I didn't finish it, but it can run simple BASIC programs.

I'm thinking about writing a BASIC compiler to Python bytecode over the Christmas break, before I start teaching Python in January.
