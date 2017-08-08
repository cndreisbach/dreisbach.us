---
title: "Beating the odds"
subtitle: "Modeling Blackjack techniques with Python"
date: 2014-11-25T00:00:00-04:00
draft: false
aliases:
  - /blog/beating-the-odds/
---

I love making little games in new programming languages. Blackjack is one of my favorites to implement, and I often give it as a first-week assignment in my programming classes.

<!--more-->

Lately, I've been in love with making [Monte Carlo simulations](https://en.wikipedia.org/wiki/Monte_Carlo_method). When I was asked to give a lightning talk about what I'll be teaching in [my Python class at The Iron Yard](http://theironyard.com/academy/python-engineering/) in January, I decided to use the Monte Carlo method to optimize my blackjack technique.

Here's some of my favorite parts of the code:

```python
class WizardStrategyPlayer(BasicStrategyPlayer):
    """http://wizardofodds.com/games/blackjack/

    A very simple and easy to remember strategy. It's not
    quite as good as basic blackjack strategy, but is easier
    for novice players.
    """

    def decide(self, game):
        """The core of the game. Each Player class must
        implement a decide method to determine whether to
        hit, double, or stand."""
        if self.is_soft():
            return self.decide_soft(game)
        else:
            return self.decide_hard(game)

    def dealer_low(self, game):
        return 2 <= game.up_card().value() <= 6

    def decide_soft(self, game):
        if self.hand_value() >= 19:
            return Stand
        elif self.hand_value() >= 16:
            return Double if self.dealer_low(game) else Hit
        else:
            return Hit

    def decide_hard(self, game):
        if self.hand_value() >= 17:
            return Stand
        elif self.hand_value() >= 12:
            return Stand if self.dealer_low(game) else Hit
        elif self.hand_value() >= 10:
            return Double if self.hand_value() > game.up_card.value() else Hit
        else:
            return Hit    
```

Per normal for simulations like this, I implemented my different strategies as different classes, all subclassed from my default behavior. [The Wizard's strategy](http://wizardofodds.com/games/blackjack/#toc-Wizard27sSimpleStrategy) isn't as good as "basic blackjack strategy," which is not basic at all, but it does well, and even I could remember it. (The [Wizard of Odds site](http://wizardofodds.com/) has become one of my favorites.)

```py
class AceFiveStrategyPlayer(BasicStrategyPlayer):
    """This player counts cards using the Ace/Five Count:
    http://wizardofodds.com/games/blackjack/appendix/17/

    Every time you see a 5, count +1.
    Every time you see an ace, count -1."""

    def bet_amount(self):
        return 2 if self.count >= 2 else 1

    def notice_cards(self, cards):
        for card in cards:
            if card.value() == 5:
                self.count += 1
            elif card.value() == 1:
                self.count -= 1

    def notice_reshuffle(self):
        self.count = 0
```

Card counting! Again, this is a much simpler method than the popular Hi-Lo method, but it's easy to remember and implement.

What I found in all this is that the house has a 1% edge even if you're a good player, and if you're a simple card counter -- that is, you change your bets only, not your behavior, based on the count -- the odds remain not in your favor, but you can get close enough to breaking even to have fun.

I've put [all the code from my explorations up at nbviewer](http://nbviewer.ipython.org/gist/cndreisbach/c2bad3de531e2b6122a9#). Go there to see the final results and try it for yourself.
