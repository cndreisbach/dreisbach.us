---
title: "Building scikit-learn transformers"
subtitle: "Extending and debugging ML preprocessors"
date: 2015-06-05T00:00:00-04:00
draft: false
aliases:
  - /blog/building-scikit-learn-compatible-transformers/
---

[scikit-learn](http://scikit-learn.org/stable/index.html) is a great library for doing machine learning in Python, and one of my favorite things about it is its interface. All objects  in scikit-learn, whether data transformers or predictors, have a similar interface, making it easy to use your own transformers or models, but I haven't seen this documented much.

For transformers, you have to define the methods `.fit(self, X, y=None)` and `.transform(self, X)`. There is a class, [`TransformerMixin`](https://github.com/scikit-learn/scikit-learn/blob/bb39b493ef084a4f362d77163c2ca506790c38b6/sklearn/base.py#L406), that doesn't do much besides add a `.fit_transform` method that calls `.fit` and `.transform`, but it's still nice to inherit from it in order to document that you're intending to make your code work well with scikit-learn.

I'm going to make a really dumb transformer: it takes any data and returns a feature vector of `[1]`.

```py
from sklearn.base import TransformerMixin

class DumbFeaturizer(TransformerMixin):
    def __init__(self):
        pass

    def fit(self, X, y=None):
        return self

    def transform(self, X):
        return [[1] for _ in X]
```

Note that `.fit` returned `self`: this is standard behavior for `.fit` methods in scikit-learn.

Let's build a better featurizer. Let's say I have a lot of text and I want to extract certain data from it. I'm going to build a featurizer that takes a list of functions, calls each function with our text, and returns the results of all functions as a feature vector.

```py
import re

def longest_run_of_capitol_letters_feature(text):
    """Find the longest run of capitol letters and return their length."""
    runs = sorted(re.findall(r"[A-Z]+", text), key=len)
    if runs:
        return len(runs[-1])
    else:
        return 0

def percent_character_feature(char):
    """Return percentage of text that is a particular char compared to total
    text length."""
    def feature_fn(text):
        periods = text.count(char)
        return periods / len(text)
    return feature_fn

class FunctionFeaturizer(TransformerMixin):
    def __init__(self, *featurizers):
        self.featurizers = featurizers

    def fit(self, X, y=None):
        """All SciKit-Learn compatible transformers and classifiers have the
        same interface. `fit` always returns the same object."""
        return self

    def transform(self, X):
        """Given a list of original data, return a list of feature vectors."""
        fvs = []
        for datum in X:
            fv = [f(datum) for f in self.featurizers]
            fvs.append(fv)
        return np.array(fvs)
```

Let's run this on some [SMS spam data](https://archive.ics.uci.edu/ml/datasets/SMS+Spam+Collection).

```py
from sklearn.tree import DecisionTreeClassifier

sms_featurizer = FunctionFeaturizer(longest_run_of_capitol_letters_feature,
                                    percent_character_feature("."))
sms_featurizer.transform(sms_data[:10])

X_train, X_test, y_train, y_test = train_test_split(sms_data, sms_results)

pipe = make_pipeline(sms_featurizer, DecisionTreeClassifier())
pipe.fit(X_train, y_train)
pipe.score(X_test, y_test)
# => 0.91385498923187369
```

You might think that was a pretty good result if you didn't know 87% of the SMS messages are ham. Anyway, pretty cool that this works!

You can build any sort of transformer you want this way. I thought it'd be a good idea to build one for use in debugging: it takes another transformer and then shows us data before and after the transformer.

```py
class PipelineDebugger(TransformerMixin):
    def __init__(self, transformer):
        self.transformer = transformer

    def fit(self, X, y=None):
        self.transformer.fit(X, y)
        return self

    def transform(self, X):
        print(self.transformer.__class__.__name__)
        idx = random.randrange(0, len(X))
        print("Before", "=" * 40)
        print(X[idx])
        X = self.transformer.transform(X)
        print("After ", "=" * 40)
        print(X[idx])
        return X

pipe = make_pipeline(PipelineDebugger(sms_featurizer), DecisionTreeClassifier())
pipe.fit(X_train, y_train)

# FunctionFeaturizer
# Before ========================================
# LOL .. *grins* .. I'm not babe, but thanks for thinking of me!
# After  ========================================
# [ 3.          0.06451613]
```
