---
title: "My programming story, part 4"
subtitle: "Fortran (1993)"
date: 2014-12-12T09:42:03-04:00
draft: false
aliases:
  - /blog/my-programming-story-part-4/
---

The summer between my junior and senior year of high school, I lived with my grandma in Auburn, AL, and attended Auburn University for a semester, taking Chemistry 101, Calculus 101, and a computer science course that used Fortran.

My grandma was amazing. I know everyone thinks their grandma is sweet and I'm not going to convince anyone that mine was the sweetest, but I know the truth on this one. I never once heard an unkind word from Grandma Em, and she had plenty of reasons to say them. She was single, divorced from a man who had not been kind at all. Her life had not been easy, yet she remained the gentlest, most open-hearted person I've ever known. She treated me like I was 10, constantly trying to feed me more and asking me if I was sure it was ok for me to have caffeine after lunch, but I loved it.

---

Fortran didn't strike me as that much different than BASIC. You had variables and loops and (optional) line numbers and GOTO statements. What it was and is good at is numerical computing.

Here's a program in Fortran 77 (which is what I was using then) to find the nth Fibonacci number:

```fortran
FUNCTION IFIB(N)
  IF (N.EQ.0) THEN
    ITEMP0=0
  ELSE IF (N.EQ.1) THEN
    ITEMP0=1
  ELSE
    ITEMP1=0
    ITEMP0=1
    DO 1 I=2,N
      ITEMP2=ITEMP1
      ITEMP1=ITEMP0
      ITEMP0=ITEMP1+ITEMP2
1   CONTINUE
  END IF
  IFIB=ITEMP0
END
```

What I learned from Fortran is that programming is _hard_. Everything I'd done up to that point was child's play, done on my own schedule. Getting assignments due in a few days, usually implementing some algorithm, was not easy for me as a 16-year-old, especially when I had calculus and chemistry homework on top of it. I wrote a lot of code late at night while Grandma Em brought me fresh oatmeal cookies.

---

Earlier this year, my grandma passed away. In the last 10 years, I haven't been a great grandson. I probably saw her 5 times over those 10 years, and I regret it. She did get to meet Dashiell, my oldest son, once, which I'm so glad of.

I went to her funeral and it was beautiful, like she always was. During my time living with her, she took in a stray graduate student in math who happened to also be a Primitive Baptist minister. He ate dinner with us often and helped me with some of the harder parts of my calculus. He gave the sermon by her graveside at her tiny country church. During it, he said, "Miss Emily lived her life according to JOY: Jesus, then others, then you." To my urban, secular, modern ears today, that sounds cringe-worthy, but it was entirely true. She embodied the true messages of Jesus: forgive those who hurt you; love your neighbor unconditionally. She always put others first.

After her graveside service, we had a big potluck at her church, the kind of thing it might be hard to envision unless you grew up in the rural South. There was ham and green beans and fried chicken and rolls and Jello salad and lemonade. All the people whose lives she had touched caught up with each other and told stories about her life.

Afterward, I drove the 9 hours back to North Carolina to get ready to teach my first class at The Iron Yard. I was teaching Ruby, not Fortran, but I was glad to have those memories of my summer with her and how hard it was to learn something new and how much it helped to have someone who loved me unconditionally and would bring me cookies.

I miss her so much. I just hope I can be one-tenth of the loving and forgiving person she was.
