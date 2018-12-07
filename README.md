Colsole
==================================================

[![Gem Version](https://badge.fury.io/rb/colsole.svg)](https://badge.fury.io/rb/colsole)
[![Build Status](https://travis-ci.com/DannyBen/colsole.svg?branch=master)](https://travis-ci.com/DannyBen/colsole)
[![Maintainability](https://api.codeclimate.com/v1/badges/0556015f7cd2080531a1/maintainability)](https://codeclimate.com/github/DannyBen/colsole/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/0556015f7cd2080531a1/test_coverage)](https://codeclimate.com/github/DannyBen/colsole/test_coverage)

---

Utility functions for colorful console applications.

---


Install
--------------------------------------------------

```
$ gem install colsole
```

Features
--------------------------------------------------

- Print colored messages 
- Color parts of a message
- Print neatly aligned status messages
- Word wrap with indentation consideration

See the [Examples file][1] for more.

Primary Functions
--------------------------------------------------

### `say "anything"`

An alternative to puts.

```ruby
say "Hello"
```

Leave a trailing space to keep the cursor at the same line

```ruby
say "appears in "
say "one line"
```

Embed color markers in the string:

```ruby
say "!txtred!I am RED !txtgrn!I am GREEN"
```

### `say_status :status, "message" [, :color]`

Print a message with a colored status

```ruby
say_status :create, "perpetual energy"
```

You can provide a color in the regulat 6 letter code:

```ruby
say_status :error, "does not compute", :txtred
```

### `word_wrap "   string" [, length]`

Wrap long lines while keeping words intact, and keeping 
indentation based on the leading spaces in your string:

```ruby
say word_wrap("    one two three four five", 15)

# output:
#    one two
#    three four
#    five
```

If `length` is not provided, `word_wrap` will attempt to determine it
automatically based on the width of the terminal.


### `resay "anything"`

Use resay after a space terminated "said" string to rewrite the line

```ruby
say "downloading... "
# long process here...
resay "downloaded."
```


### `say! "anything to stderr"`

Use say! to output to stderr with color markers:

```ruby
say! "!txtred!Error!txtrst!: This just did not work"
```

Utility / Support Functions
--------------------------------------------------

### `colorize "!txtred!Hello"`

Parses and returns a color-flagged string.

Respects pipe and auto terminates colored strings.
	
Call without text to see a list/demo of all available colors.

### `terminal?`

Returns true if we are running in an interactive terminal

### `command_exist? "some_executable"`

Checks if the provided string is a command in the path.

### `detect_terminal_size fallback_value`

Returns an array `[width, height]` of the terminal, or the supplied 
`fallback_value` if it is unable to detect.

### `terminal_width`

Returns only the terminal width. This is a shortcut to 
`detect_terminal_size[0]`.


Color Codes
--------------------------------------------------

[![Color Codes](https://raw.githubusercontent.com/DannyBen/colsole/master/color-codes.png)](https://raw.githubusercontent.com/DannyBen/colsole/master/color-codes.png)


[1]: https://github.com/DannyBen/colsole/blob/master/example.rb
