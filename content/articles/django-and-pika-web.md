---
title: "Using @pika/web with Django to handle JavaScript dependencies"
date: 2019-03-29T15:31:35-04:00
---

I love Django, but its story for handling JavaScript dependencies and bundling is not very good. Without plugins, you're stuck using old-school multiple `script` tags in order of dependencies and praying that you get it right. The best solution I've found until recently is [django-webpack-loader](https://github.com/owais/django-webpack-loader), but that requires a Webpack setup, which can be complex.

I've been watching [@pika/web](https://www.pikapkg.com/blog/pika-web-a-future-without-webpack) for a little while, and I really like its approach to JavaScript dependencies. 

It assumes you will use [ES6 modules](https://flaviocopes.com/es-modules/) to load your dependencies. If you aren't familiar, ES6 modules allow you to import other JavaScript files from within JavaScript and encapsulate those other JavaScript files within a namespace instead of slapping all their stuff into a global scope.

*An example of ES6 imports*

```js
import cookie from 'cookiejs.js'
import Ramda from 'ramda.js'
```

@pika/web lets you use a standard npm `package.json` file to list your dependencies and will then download them and put them into single-file modules you can import with [the ES6 module `import` syntax](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Statements/import).

Because @pika/web downloads the files into a directory and gives them reasonable names, you can load them using plain old Django static files, giving you the power of real JavaScript dependency management without adding much overhead to your Django project.

## How to use @pika/web with Django

First, create an empty `package.json` file at the root of your Django project. If you haven't used npm before, your `package.json` should look like this:

```js
{"private": true}
```

Next, run `npm install @pika/web` at the root of your project. You'll have to do this for each new project. (This assumes you have npm installed. If not, [install npm first](https://nodejs.org/en/).) This will be installed under `node_modules/`, which you will want to exclude from version control.

Edit your `package.json` so that it looks like the following:

```js
{
  "private": true,
  "scripts": {
    "prepare": "pika-web --dest static/web_modules/"
  },
  "dependencies": {
    "@pika/web": "^0.4.1"
  }
}
```

The version number after `@pika/web` may be different; that is fine.

The above changes to your `package.json` file allow you to run `npm run prepare` to generate your bundled modules. In addition, when installing new modules (covered below), they will automatically be bundled up for you. I've configured it to install the bundled modules in `static/web_modules/`, as I use a `static/` directory in the root of my project to hold static files. You can adjust this to install them elsewhere.

In order for your static files to be found in the `static/` directory, you'll need the following in `settings.py`:

```py
STATICFILES_DIRS = [
    os.path.join(BASE_DIR, "static"),
]
```

You'll also likely want to exclude the `static/web_modules/` directory from version control.

<aside>
{{% md %}}@pika/web is putting its bundles into `static/web_modules/` because of the `--dest` flag I put in the `prepare` npm script above. You can leave that out and they'll be installed in `web_modules/` by default. You could add that directory to `STATICFILES_DIRS` in your Django settings and that would work, too. You will need to watch out for static file name collisions in that case.{{% /md %}}
</aside>

Once all the above is done, you are good to start using `@pika/web`. To install new packages, first check [the pika website](https://www.pikapkg.com/) to see if the npm package you want uses ES modules yet. Then you can run `npm install <package_name>` to install whatever packages you want.

Once you have the above in place, importing ES modules is as easy as:

```js
import cookie from 'web_modules/cookiejs.js'
```
