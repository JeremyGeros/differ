# Differ [![Code Climate](https://codeclimate.com/github/masukomi/differ.png)](https://codeclimate.com/github/emintham/differ) [![Build Status](https://travis-ci.org/masukomi/differ.svg?branch=master)](https://travis-ci.org/emintham/differ) [![Test Coverage](https://codeclimate.com/github/masukomi/differ/badges/coverage.svg)](https://codeclimate.com/github/masukomi/differ)

Originally by [pvande](https://github.com/pvande/differ), then forked by [JakobR](https://github.com/JakobR/differ/tree/jr) then forked by [emintham](https://github.com/emintham)

> As streams of text swirled before the young man's eyes, his mind swam with thoughts of many things. They would have to wait, however, as he focussed his full concentration on the shifting patterns ahead of him. A glint of light reflecting off a piece of buried code caught his eye and any hope he had was lost. For the very moment he glanced aside, the landscape became Different.
> The young man gave a small sigh and trudged onward in solemn resignation, fated to wander the desolate codebanks in perpetuity.

Differ is a flexible, pure-Ruby diff library, suitable for use in both command
line scripts and web applications.  The flexibility comes from the fact that
diffs can be built at completely arbitrary levels of granularity (some common
ones are built-in), and can be output in a variety of formats.

## Installation

Add this to your gemfile if you use bundler

```ruby
gem 'differ'
```

and bundle to install

```bash
bundle install
```

or install it manually

```bash
sudo gem install differ
```

## How do I use this thing?

There are a number of ways to use Differ, depending on your situation and needs. Lets examplify:

```ruby
require 'differ'

@original = "Epic lolcat fail!"
@current  = "Epic wolfman fail!"
```

There are a number of built-in diff_by_* methods to choose from for standard use:

```ruby
Differ.diff_by_line(@current, @original)
# => {"Epic lolcat fail!" >> "Epic wolfman fail!"}

Differ.diff_by_word(@current, @original)
# => Epic {"lolcat" >> "wolfman"} fail!

Differ.diff_by_char(@current, @original)
# => Epic {+"wo"}l{-"olcat "}f{+"m"}a{+"n fa"}il!
```

### Ok, but that doesn't quite cover my case, I have to split by "whatever".

No problem, you can call diff directly and supply your own boundary string:

```ruby
Differ.diff(@current, @original) # Implicitly by line by default
# => {"Epic lolcat fail!" >> "Epic wolfman fail!"}

Differ.diff(@current, @original, 'i')
# => Epi{"c lolcat fa" >> "c wolfman fa"}il
```

### Yeah, thats nice. But a simple string might not always cut it...

Well, you can supply a regex instead of your string if you have to:

```ruby
Differ.diff(@original, @current, /[a-z]i/)
# => E{"c wolfman f" >> "c lolcat f"}l!
```

Include a capture group if you want to keep the separator:

```ruby
Differ.diff(@original, @current, /([a-z]i)/)
# => Epi{"c wolfman f" >> "c lolcat f"}ail!
```

### Ok, ok, but I don't like having to write "Differ" everywhere.

If you would like something a little more inline you can `require 'differ/string'` to get some added inline string magic:

```ruby
@current.diff(@original) # Implicitly by line by default
# => {"Epic lolcat fail!" >> "Epic wolfman fail!"}
```

Or a lot more inline:

```ruby
@current - @original # Implicitly by line by default
# => {"Epic lolcat fail!" >> "Epic wolfman fail!"}

Differ.separator = ' ' # Custom string
@current - @original
# => Epic {"lolcat" >> "wolfman"} fail!

Differ.separator = /[a-z]i/ # Custom regex without capture group
@original - @current
# => E{"c wolfman f" >> "c lolcat f"}l!

Differ.separator = /([a-z]i)/ # Custom regex with capture group
@original - @current
# => Epi{"c wolfman f" >> "c lolcat f"}ail!
```

So we've pretty much got you covered.

## What about output formatting?

Need a different output format?  We've got a few of those too:

```ruby
Differ.format = :ascii  # Default
Differ.format = :color
Differ.format = :html

Differ.format = MyCustomFormatModule
```

The formatter must respond to the call method that takes an instant of the Change class as an argument and returns a string.

### But I don't want to change the system-wide default for only a single diff output!

Yeah, we either:

```ruby
diff = @current - @original
diff.format_as(:color)
```

Or with your own formatter:

```ruby
diff = @current - @original
diff.format_as(->(c){c.to_s})
```

## Copyright

Copyright (c) 2009 Pieter Vande Bruggen.

(The GIFT License, v1)

Permission is hereby granted to use this software and/or its source code for
whatever purpose you should choose. Seriously, go nuts. Use it for your personal
RSS feed reader, your wildly profitable social network, or your mission to Mars.

I don't care, it's yours. Change the name on it if you want -- in fact, if you
start significantly changing what it does, I'd rather you did! Make it your own
little work of art, complete with a stylish flowing signature in the corner. All
I really did was give you the canvas.  And my blessing.

> Know always right from wrong, and let others see your good works.
