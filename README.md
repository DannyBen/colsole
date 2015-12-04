Colsole
=======

[![Gem Version](https://badge.fury.io/rb/colsole.svg)](http://badge.fury.io/rb/colsole)
[![Build Status](https://travis-ci.org/DannyBen/colsole.svg?branch=master)](https://travis-ci.org/DannyBen/colsole)
[![Code Climate](https://codeclimate.com/github/DannyBen/colsole/badges/gpa.svg)](https://codeclimate.com/github/DannyBen/colsole)
[![Gem](https://img.shields.io/gem/dt/colsole.svg)](https://rubygems.org/gems/colsole)


Utility functions for colorful console applications.

## Install

	$ gem install colsole

## Primary Functions

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

### `word_wrap "   string"`

Wrap long lines while keeping words intact, and keeping 
indentation based on the leading spaces in your string:

```ruby
say word_wrap("    one two three four five", 15)

# output:
#    one two
#    three four
#    five
```


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

## Utility / Support Functions

### `colorize "!txtred!Hello"`

Parses and returns a color-flagged string.

Respects pipe and auto terminates colored strings.
	
Call without text to see a list/demo of all available colors.
	

### `terminal?`

Returns true if we are running in an interactive terminal

### `command_exist? "some_executable"`

Checks if the provided string is a command in the path.

### `detect_terminal_size fallback_value`

Returns an array [width, height] of the terminal, or the supplied 
`fallback_value` if it is unable to detect.

