# ruby-dzen

A small wrapper for [dzen2][dzen]'s in-text formatting

You can define what dzen2 displays by using pure ruby code.

The DSL is heavily inspired by [Sinatra][].

## Simple DSL
There are just 4 methods you need to know: `app`, `configure`, `before_run` and `order`

The simplest way to use ruby-dzen is to define a simple app:

    app :clock do
      Time.now.strftime("%d.%m.%Y %H:%M")
    end

Each of these `app` blocks must return a string to be displayed.

You can easily configure the output:

    configure do |c|
      c.interval = 3 
    end

There are several options configurable. See [dzen/base.rb][base.rb] for the defaults. ruby-dzen comes with two pre-defined option sets: 

* One for real dzen2-formatted text including colors and delimiters. This is used by default.
* One for simple text console output using escape sequences to display colors. Just define TERMINAL in your code or via commandline. (I will change this to a more ruby-ish way, soon)

You can define a handler to be run beforehand, for example to display a short loading message:

    before_run do
      "--- Loading ---"
    end

The output order will either be in the order as the apps are defined in your app file or you can sort them using the `order` method:

    order :clock, :loadavg

If you define an app but you don't define it in your order list, it won't be displayed at all.

See the [example file][example] for a already working script.

## Run it!

As I'm to lazy for now to create a proper gem, just clone my repo and write your own small app collection.

Then run it with

    ruby -Ipath/to/ruby-dzen/lib yourscript.rb | dzen2

Make sure you have the svn-Version of dzen2, as it has some extra things which are not in the released packages:

    svn checkout http://dzen.googlecode.com/svn/trunk/ dzen

You can then set dzen2's output by its commandline options. For example change the used font with:

    ... | dzen2 -fn "-*-terminus-medium-r-normal--14-120-75-75-C-70-iso8859-1"

See [dzen2's documentation][dzen] for all possible options.

If you want to use the text console output (for debugging or whatever) run it as:

    TERMINAL=1 ruby -Ipath/to/ruby-dzen/lib yourscript.rb

This will change soon to a more ruby-ish way, I hope.

## Helpers

As it is all pure ruby code, just define a method in your code and call it within your app module.

I already wrote 2 small helper functions: `_color` and `color_critical`.

`_color` colorizes a given string using the callbacks defined by DZEN::Base (or its subclass).

`color_critical` colorizes a number value based on wether it's below a critical value or not.

See the docu for their arguments in [dzen/helpers.rb][helpers.rb].

To use them in your code just do the following in your script:

    include DZEN::Helpers

and use them in your apps.

## New outputs

To define a new output class, just subclass DZEN::Base and make sure your class defines the `Config` constant overwriting the existent config keys.

This is exactly the way DZEN::Default and DZEN::Terminal are defined. See [dzen/base.rb][base.rb].

## ToDo

* caching of apps (nearly finished, just need a proper API)
* more ruby-ish way to switch output class

Feel free to implement what you need and let me know about your changes.

## License

The code is released under the MIT license. See [LICENSE][].

## Contribute

If you'd like to hack on ruby-dzen, start by forking my repo on GitHub:

http://github.com/badboy/ruby-dzen

ruby-dzen has no external dependencies other than dzen2 itself.

1. Clone down your fork
1. Create a thoughtfully named topic branch to contain your change
1. Hack away
1. Add tests and make sure everything still passes by running `rake`
1. If you are adding new functionality, document it in the README
1. Do not change the version number, I will do that on my end
1. If necessary, rebase your commits into logical chunks, without errors
1. Push the branch up to GitHub
1. Send me (badboy) a pull request for your branch

[dzen]: http://dzen.geekmode.org/dwiki/doku.php
[base.rb]: http://github.com/badboy/ruby-dzen/blob/master/lib/dzen/base.rb
[helpers.rb]: http://github.com/badboy/ruby-dzen/blob/master/lib/dzen/helpers.rb
[sinatra]: http://www.sinatrarb.com/
[LICENSE]: http://github.com/badboy/ruby-dzen/blob/master/LICENSE
[example]: http://github.com/badboy/ruby-dzen/blob/master/example/sample.rb
