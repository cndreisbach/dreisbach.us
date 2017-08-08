---
title: "A simple guide: reinforcement learning"
date: 2017-02-07T00:00:00-04:00
draft: false
aliases:
  - /blog/a-simple-guide-reinforcement-learning/
---

Creating a simple AI that can learn is not that hard. The same techniques that power AlphaGo and poker-playing AIs can be implemented by you.

<!--more-->

I ran across [an article in _Wired_ about a poker AI that can beat human champs](https://www.wired.com/2017/02/libratus/). Buried a few paragraphs in, I saw:

> "[Libratus, the AI] relied on a form of AI known as reinforcement learning, a method of extreme trial-and-error. In essence, it played game after game against itself. Google’s DeepMind lab used reinforcement learning in building AlphaGo, the system that that cracked the ancient game of Go ten years ahead of schedule, but there’s a key difference between the two systems. AlphaGo learned the game by analyzing 30 million Go moves from human players, before refining its skills by playing against itself. By contrast, Libratus learned from scratch. Through an algorithm called counterfactual regret minimization, it began by playing at random, and eventually, after several months of training and trillions of hands of poker, it too reached a level where it could not just challenge the best humans but play in ways they couldn’t."

I couldn't tell you what "counterfactual regret minimization" is, but I do recall an assignment I used to give at The Iron Yard that I [adapted from Stanford's "Nifty Assignments."](http://nifty.stanford.edu/2014/laaksonen-vihavainen-game-of-sticks/) (As an aside, [the Nifty Assignments site](http://nifty.stanford.edu/) is the best repository of simple exercises to understand computer science fundamentals I know of.) In this assignment, you build an AI to play the "Game of Sticks." The two-player game is simple:

1. Start with 20 sticks on a table.
2. Player 1 picks up 1, 2, or 3 sticks.
3. Player 2 picks up 1, 2, or 3 sticks.
4. This repeats until a player has to pick up the last stick. That player loses.

This game is solvable, which makes it fun for this exercise -- there's a good way to test that your AI works. The goal is to make an AI that learns how to play without knowing the solution ahead of time.

[My code for this AI is here, which you might want to pull up.](https://gist.github.com/cndreisbach/33fd1f6a992a48467ba2a7d8149c40cf#file-game_of_sticks-py)

The simplest way to code this AI is to allow it to make any legal choice in the game and have it change its chances of each choice based off its previous successes and failures. The following isn't my own idea: I'm paraphrasing from the Nifty Assignments text.

Imagine you have 20 hats, numbered 1 through 20, each with three balls in them. One ball has the number 1, another the number 2, the last the number 3. When it's your turn to pick up sticks, you pick up the hat with the current number of sticks on it. If there's 17 sticks, pick up hat #17. Draw a random ball out of it and pick up that many sticks. Set the ball aside. Do this for each of your turns. At the end of the game, if you won, put the balls back in the hats -- and put another with the same number on it in, too. If you draw a ball with "2" written on it out of hat #17, and you won, put two balls with "2" written on them back into #17. If you lost, throw the ball away (unless it's the last ball in the hat.) If you play enough games this way, the balls in each hat should have winning moves written on them.

Before I explain the program, here's its output. The table shows the hats (there's no need for hats less than #5) and the number of balls of each number in them, before and after the game.

```
100 training games being run...
   5 | {2: 1}
   6 | {1: 1}
   7 | {1: 3, 2: 2, 3: 1}
   8 | {1: 1, 3: 22}
   9 | {1: 1, 3: 6}
  10 | {1: 1, 3: 6}
  11 | {1: 3, 2: 17, 3: 1}
  12 | {2: 1, 3: 17}
  13 | {1: 9, 2: 7, 3: 1}
  14 | {1: 1}
  15 | {2: 1}
  16 | {1: 1, 2: 3}
  17 | {1: 6, 2: 12, 3: 1}
  18 | {1: 1, 2: 7, 3: 19}
  19 | {1: 5, 2: 5, 3: 1}
  20 | {1: 32, 2: 1}
There are 20 sticks left.
AI picks up 1 sticks.
There are 19 sticks left.
How many will you pick up? 2
There are 17 sticks left.
AI picks up 1 sticks.
There are 16 sticks left.
How many will you pick up? 3
There are 13 sticks left.
AI picks up 1 sticks.
There are 12 sticks left.
How many will you pick up? 2
There are 10 sticks left.
AI picks up 3 sticks.
There are 7 sticks left.
How many will you pick up? 2
There are 5 sticks left.
AI picks up 2 sticks.
There are 3 sticks left.
How many will you pick up? 2
The other player has to pick up the last stick and has lost.
   5 | {2: 1}
   6 | {1: 1}
   7 | {1: 3, 2: 2, 3: 1}
   8 | {1: 1, 3: 22}
   9 | {1: 1, 3: 6}
  10 | {1: 1, 3: 5}
  11 | {1: 3, 2: 17, 3: 1}
  12 | {2: 1, 3: 17}
  13 | {1: 8, 2: 7, 3: 1}
  14 | {1: 1}
  15 | {2: 1}
  16 | {1: 1, 2: 3}
  17 | {1: 5, 2: 12, 3: 1}
  18 | {1: 1, 2: 7, 3: 19}
  19 | {1: 5, 2: 5, 3: 1}
  20 | {1: 31, 2: 1}
```

The AI lost -- it's not that good yet. It's learning, though. Look at hat #10 as an example. Before the game, it had 1 "1" ball and 6 "3" balls in it. It drew a "3", so after the game, it has 1 "1" ball and 5 "3" balls.

Let's see how this works:

```py
class AIPlayer(Player):
    def pick(self, hat_number):
        """Pick a random ball from a particular hat.
        When we pick this ball, we set it aside for use at the end of the game.
        """
        assert hat_number > 0

        balls = self.balls(hat_number)
        random.shuffle(balls)
        ball = balls.pop()
        self.current_picks[hat_number] = ball
        return ball
```

I've removed some code for output and special cases, but this is basically the code the AI uses to decide how many sticks to pick up. Pretty simple -- get the hat, shake it up to randomize the balls, draw out a ball, store it for later, and return it. At the end of the game, we use the following code:

```py
class AIPlayer(Player):
    def record_win(self):
        """Record a win for the AI.
        When the AI wins, we place the picked balls back in their hats, along
        with a copy of the picked balls. If hat 10 started with [1, 2, 3] and
        3 was picked, after the win hat 10 will have [1, 2, 3, 3].
        """
        for key, value in self.current_picks.items():
            self.hats[key].extend([value, value])
        self.current_picks = {}

    def record_loss(self):
        """Record a loss for the AI.
        When the AI loses, we do not place the picked balls back in their hats,
        unless that would leave the hat empty. If the hat would be empty, we put
        the ball back.
        """
        for key, value in self.current_picks.items():
            if len(self.hats[key]) == 0:
                self.hats[key].append(value)
        self.current_picks = {}
```

That's basically it to reinforcement learning. This example is easy because there's one piece of game state -- the number of sticks left over -- and only three options for choices. This becomes much more complex even for simple games like tic-tac-toe where there are [around 6,000 possible legal states](https://math.stackexchange.com/questions/485752/tictactoe-state-space-choose-calculation) for the board.
