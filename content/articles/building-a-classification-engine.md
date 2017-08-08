---
title: "Building a classification engine"
subtitle: "Using a naive Bayes classifier to find interesting documents"
date: 2014-12-04T00:00:00-04:00
draft: false
aliases:
  - /blog/building-a-classification-engine/
---

Tonight, I built my first stab at an engine for the Reading Machine to classify articles that get pulled in via RSS or social media links as interesting or not interesting to me. I already see a few problems with what I built, but it's a good first step and I'd like to talk about it.

<!--more-->

The term "naive Bayes" gets used a lot when people are talking about classifying documents. The classic example that everyone has seen is spam filtering. When you receive email, your email provider or client looks at the email and uses a [naive Bayes classifier](https://en.wikipedia.org/wiki/Naive_Bayes_classifier) (among other things) to determine if the email is spam or not. A naive Bayes classifier is trained on some data where the class of each piece of data is already known. This doesn't have to be a binary state like spam or not spam: you could classify articles into categories, or investments into levels of risk, for example. These classifiers are called naive because they don't assume the different features of the data (features being whatever you choose to point out to the classifier about the data -- with a document, it'd be the individual words in the document) are related, which seems like it wouldn't work, but in practice, it tends to work out just fine.

So, code!

```python
from collections import Counter
from math import log

class InterestClassifier:
    """Classifies sets of features (normalized words from documents) as interesting
    or not interesting based on prior knowledge of what documents the user has
    found interesting.

    This uses the Bernoulli Bayes model, which looks for the absence of features
    as well as the standard presence of features.

    https://en.wikipedia.org/wiki/Naive_Bayes_classifier#Bernoulli_naive_Bayes
    http://nlp.stanford.edu/IR-book/html/htmledition/the-bernoulli-model-1.html

    This also acts like NLTK's positivenaivebayes module:
    http://www.nltk.org/api/nltk.classify.html#module-nltk.classify.positivenaivebayes

    We only have one class: interesting. While a document can be classified as
    interesting or not, we only train with interesting documents and a population
    of unlabeled documents that may or may not be interesting.
    """

    def __init__(self, pos_prob_prior=0.5):
        self.pos_count = 0
        self.doc_count = 0
        self.feature_counts = Counter()
        self.pos_feature_counts = Counter()

        self.pos_prob = pos_prob_prior
        self.pos_feature_probs = dict()
        self.neg_feature_probs = dict()
```

This is just setup, but my large comment is worth diving into. Unlike some classification scenarios where all data has a category or class, I expect my documents to be either marked as interesting or in an unknown state. Asking the user to mark everything they read as interesting or not sounds like a bore, so I'm just going to take what they say is interesting and use that. Everything else might or might not be: who knows?

If you take a look [at the Stanford text I linked in the comment](http://nlp.stanford.edu/IR-book/html/htmledition/the-bernoulli-model-1.html), you will notice that no one seems to know how to talk about this stuff without switching to moon language. The image with the psuedo-code  on that page is good, though, and I used it in implementing this.

```python
    def train(self, pos=[], unlabeled=[]):
        """Adds all the new feature sets to the classifier.
        I had an exceptionally hard time finding a classifier that could be
        trained after the fact, so I made this one to work that way."""
        for doc in pos:
            self.pos_count += 1
            self.doc_count += 1
            for feature in doc:
                self.feature_counts[feature] += 1
                self.pos_feature_counts[feature] += 1

        for doc in unlabeled:
            self.doc_count += 1
            for feature in doc:
                self.feature_counts[feature] += 1

        self._evaluate_probs()
```

All the pre-made naive Bayes classifiers I found were set up so you give it all your data at the beginning and then you're done. I expect to keep updating this as I pull in more documents and mark them as interesting, so I made my classifier work differently. This `train` method can be called multiple times. With each document I pull in, I take each feature (remember, a feature is just a word in the document, or more specifically, a [stemmed](https://en.wikipedia.org/wiki/Stemming) word) and add it to my running counts. These counts will be used in the next step to calculate the probability that the feature will be found in an interesting document.

This is the crux of [Bayes' theorem](https://en.wikipedia.org/wiki/Bayes%27_theorem), which Bayes classifiers are named for and powered by: if we know the probability of two things being true (A and B), and we know the probability of B being true given A being true, then we can know the probability of A being true given B. In the case of my classifier for finding out if documents are interesting to me, I know the probability of a document being interesting (let's say 50% of documents I'll pull in) and the probability of an interesting document having the word "Python" in it. I know this because I can look at all the interesting documents and count how many have the word Python in them. I also know the probability of a document having the word Python in it, regardless of it being interesting. Again, this is because I can count them. Given all that information, my question is "if a document has the word Python in it, what's the probability I'll find it interesting?" Bayes' theorem lets me know this.

```python
    def _evaluate_probs(self):
        p_pos = self.pos_prob
        p_neg = 1 - p_pos

        self.pos_feature_probs = dict()
        self.neg_feature_probs = dict()

        for feature in self.feature_counts.keys():
            p_feature = (self.feature_counts[feature] + 1) / (self.doc_count + 2)
            p_feature_pos = (self.pos_feature_counts[feature] + 1) / (self.pos_count + 2)
            p_feature_neg = (p_feature - p_feature_pos * p_pos) / p_neg

            self.pos_feature_probs[feature] = p_feature_pos
            self.neg_feature_probs[feature] = p_feature_neg
```

This is the second step in determining probabilities. This code isn't that interesting in that it just calculates all the probabilities I just mentioned that I'll need. There's some smoothing of the data by adding small constants, and a calculation of the probability of a term being in an uninteresting document which I got from [the Natural Language Toolkit](http://www.nltk.org/api/nltk.classify.html#module-nltk.classify.positivenaivebayes). Even though I don't have any documents explicitly marked as uninteresting, I'll need that probability in order to state whether documents I attempt to classify are not interesting. Bayesian filtering works by choosing the category for data that is most likely, so you need at least two categories.

```python
    def classify(self, feature_set):
        pos_score = log(self.pos_prob)
        neg_score = log(1 - self.pos_prob)
        for feature in self.feature_counts.keys():
            if feature in feature_set:
                pos_score += log(self.pos_feature_probs[feature])
                neg_score += log(self.neg_feature_probs[feature])
            else:
                pos_score += log(1 - self.pos_feature_probs[feature])
                neg_score += log(1 - self.neg_feature_probs[feature])

        return pos_score >= neg_score
```

Here's the meat of the program, and it's really simple! There's a little complicated math: we get the natural logarithm of all the probabilities for each word in the document being in an interesting or uninteresting document. To be honest, the why of this is over my head right now: I got it from the description of the algorithm.We add up the logarithms of the probability of each word in the document being in an interesting document or not, and also penalize the document for each word it doesn't have that we know about. After we add up all those logarithms, it provides us with a score for each category, interesting or not interesting.

Let's see it in action:

```python

from readingmachine.classifier import InterestClassifier
ic = InterestClassifier()
interesting = ["clojure data population growth", "python ansible linux", "homeless population growing", "linux music management", "ruby and rails show promise for web apps", "being a dad is exciting"]
unlabeled = ["ruby data analysis", "football game exciting", "president goes to paris", "cows growing at fast rate"]

interesting = list(map(normalized_words, interesting))
unlabeled = list(map(normalized_words, unlabeled))

print(interesting)
#=> [{'growth', 'clojur', 'popul', 'data'}, {'linux', 'python', 'ansibl'}, {'popul', 'grow', 'homeless'}, {'manag', 'linux', 'music'}, {'web', 'show', 'rubi', 'rail', 'app', 'promis'}, {'dad', 'excit'}]

print(ic.classify(normalized_words("new ruby study show promising data")))
#=> True
print(ic.classify(normalized_words("promise shown in clinical trials")))
# => False
```

Fantastic! With small documents, this seems to be working well. Even though the second phrase had the word "promise," which had only shown up in interesting documents, it didn't have enough interesting words to trigger the classifier. Now I'll have to try it with real articles on the web to see how it works. Next time!
