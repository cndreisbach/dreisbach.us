---
title: My advice to new developers
date: 2019-01-02T20:01:26-05:00
draft: false
---

On the last day of lecture for each class I teach, I give the same talk -- my seven pieces of advice for new developers. I don't know if my advice is all that great, but it's what I've learned over the past 20 years of writing code and it's worked out ok for me. Today was the last lecture for my third cohort at [Momentum](https://www.momentumlearn.com/), the company I co-founded last year, and after giving the talk a third time, I thought I'd write it up.

Each of these seven tips are guidelines; they aren't always to be followed.

**1. Avoid comments.** A comment in code is usually there to explain something confusing or to show something that should be self-evident. Instead of spending time writing comments, spend that time naming variables and functions and splitting your code into smaller pieces. Here's a constructor from a React component I wrote a few months ago, with comments:

```js
constructor () {
  super()
  this.state = {
    currentUser: null
  }

  // The user and their token are stored in the browser's localStorage
  // (which isn't very secure, but works for this). We need to get them
  // from localStorage and then set the token in the data object -- where
  // we make API calls.
  const username = window.localStorage.getItem('username')
  const token = window.localStorage.getItem('token')
  if (username && token) {
    this.state.currentUser = { username, token }
    data.setUserToken(token)
  }

  // We have to do this because JavaScript's `this` keyword
  // doesn't point to what you might want it to always, and we
  // can't use these in event listeners without this boilerplate.
  this.setCurrentUser = this.setCurrentUser.bind(this)
  this.logout = this.logout.bind(this)
}
```

Here's the same code re-written:

```js
constructor () {
  super()
  this.state = {
    currentUser: null
  }

  this.getUserAndAPITokenFromLocalStorage()
  this.bindThisForEventListeners(['setCurrentUser', 'logout'])  
}

getUserAndAPITokenFromLocalStorage () {
  const username = window.localStorage.getItem('username')
  const token = window.localStorage.getItem('token')
  if (username && token) {
    this.state.currentUser = { username, token }
    data.setUserToken(token)
  }
}

bindThisForEventListeners (methodNames) {
  for (let name in methodNames) {
    this[name] = this[name].bind(name)
  }
}
```

Long variable and function names are great, by the way. Auto-complete makes them not a pain to type and you have to read your code more often than you write it.

**2. ["Never use a plugin you would not be able to write yourself."](http://weblog.jamisbuck.org/2007/2/21/review-build-your-own-ruby-on-rails-web-applications) (credit to Jamis Buck).** When I first read this line 11 years ago in Jamis Buck's review of a Ruby on Rails book, I spent months thinking about it. It seems so counter-intuitive. Don't we use other people's code because we can't write everything ourselves? In the original context of that quote, don't we use Ruby on Rails because we couldn't write a web application from scratch without a framework? Isn't this overly extreme?

This one is definitely a guideline that you should try to live into and can't always follow. My less extreme version is this: never use a library you can't read and understand. Take time to read the code you're using. Sooner or later, you will have to know how it works and you'll be glad for the time you spent. You'll learn so much from reading and have a major advantage in your career.

**3. Use simple tools.** Everyone is going to try to convince you to use their special tool: zsh, fish, vim, Emacs, [direnv](/articles/a-favorite-development-tool-direnv/), or whatever. Avoid this urge. Use what comes on every system first: bash and vim. Learn them well and get good with them. Before adding a plugin or configuration option, ask if it's really necessary. When you have to use a new system, you'll have the advantage of being able to work immediately.

About 10 years ago, I remapped Caps Lock to Ctrl on my keyboard. I like that position so much better. Now I can't use anyone else's computer without either getting frustrated or going into their settings and remapping the keys on their computer. Is my enjoyment worth this? Probably not.

You will find tools you love along the way and adopt them. Every programmer has their own *mise en place* and you will too. Just remember that keeping it simple will always pay off.

**4. Working code is good code.** Every piece of code you write is a learning experience. Just because you didn't do things the "right way" doesn't mean you didn't do a good job. There's not a piece of code I've written that I haven't looked at six months later and wondered what was wrong with me when I wrote it. The "right way" comes from writing code, seeing how it could be improved, rewriting it, and repeating forever.

**5. Don't be afraid to delete code.** Version control is there for you!  _Please_ don't comment out old code because you might need it later. You are not going to forget your previous code.

If you're 80% into a feature and you realize you've done it wrong, just throw it away. It won't take you that much time to re-write your code, but it'll take forever to debug the mess you'll make if you don't delete your code. The worst problems come from tangled code -- you've solved the problem 80% of the way, stepped back halfway, and done it again over and over.

**6. Prefer data.** Objects are useful and you will use them all the time, for sure. When you use any sort of framework, you'll probably inherit from other classes all the time. But when you're trying to solve a problem, reach for lists and dictionaries (or arrays and hashes or whatever you call it in your language) first. They will work for 90% of code. Data has the best API around: map, reduce, and filter. Learn them and love them.

**7. Always do the hard thing.** When you have an opportunity at work that no one else wants, jump on it. When you get asked to do something you don't know how to do, absolutely jump on it. My career has been made up of these decisions and it has been fantastic for it. Hypothetical situations you should always say yes to (and that I have said yes to):

- We need someone to maintain and debug this codebase written over 10 years in an obscure language by an employee who isn't here any more. **Say yes.** You will get to play code archeologist. You will learn a bunch of arcane lore. You will feel like a champion.

- We need someone to write this application that should take two months in two weeks (or less.) **Please say yes.** People will leave you alone and you will get two weeks of the most concentrated programming time you'll ever have. You will make crazy choices to save a few hours that might change your career. (I reach for SQLite a lot more than other devs I know because I had to write a web app used by thousands in ten days and someone else had started it using the built-in sqlite library in Python. I didn't have time to change what I thought was a bad decision. Instead I found out that SQLite holds up a lot better than you'd expect if your app is read-only.)

- We need someone to work with another department using a language you don't already know. **Why would you consider saying no to this?** It will either be the most fun or a great story later. I got to write Logo for a month 20 years into my career because I said yes to this once.

That's my advice. Again, some of it's probably wrong. One of my other pieces of common advice is "listen to everything and ignore 90% of it" and that applies here, too. Still, these tips have made my career great so far and keep me excited about programming into the future.
