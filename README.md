# Colsole

[![Gem Version](https://badge.fury.io/rb/colsole.svg)](https://badge.fury.io/rb/colsole)
[![Build Status](https://github.com/DannyBen/colsole/workflows/Test/badge.svg)](https://github.com/DannyBen/colsole/actions?query=workflow%3ATest)
[![Maintainability](https://api.codeclimate.com/v1/badges/0556015f7cd2080531a1/maintainability)](https://codeclimate.com/github/DannyBen/colsole/maintainability)

---

Utility functions for colorful console applications.

> **Upgrade Note**
>
> This README is for the latest version of colsole (0.8.x), which is compatible
> with older versions. Version 1.x will NOT be compatible.
>
> See [Uprading](#upgrading) below.

## Install

Add to your Gemfile:

```
$ gem 'colsole', '>= 0.6.0', '< 2.0'
```

## Examples

See the [Examples file](https://github.com/DannyBen/colsole/blob/master/example.rb).

## Primary Functions

### `say "anything"`

An alternative to puts with line wrapping, colors and more.

```ruby
say "Hello"
```

Leave a trailing space to keep the cursor at the same line

```ruby
say "appears in "
say "one line"
```

Embed [color markers](#colors) in the string:

```ruby
say "This is r`red`, and this gu`entire phrase is green underlined`"
```

Provide the `replace: true` option after a space terminated "said" string to
rewrite the line:

```ruby
# space terminated string to say it without a newline
say "downloading data... "
# long process here...
say "download complete.", replace: true
```


### `word_wrap "   string" [, length]`

Wrap long lines while keeping words intact, and keeping indentation based on the
leading spaces in your string:

```ruby
say word_wrap("    one two three four five", 15)

# output:
#    one two
#    three four
#    five
```

If `length` is not provided, `word_wrap` will attempt to determine it
automatically based on the width of the terminal.

### `say! "anything to stderr"`

Use say! to output to stderr with color markers:

```ruby
# red inverted ERROR
say! "ri` ERROR ` This just did not work"
```

## Utility / Support Functions

### `colorize "string"`

Parses and returns a color-flagged string.

### `terminal?`

Returns true if we are running in an interactive terminal

### `command_exist? "some_executable"`

Checks if the provided string is a command in the path.

### `terminal_size [fallback_cols, fallback_rows]`

Returns an array `[width, height]` of the terminal, or the supplied 
fallback if it is unable to detect.

### `terminal_width` / `terminal_height`

Returns only the terminal width or height. This is a shortcut to 
`terminal_size[0]` / terminal_size[1].


## Colors

Strings that are surrounded by backticks, and preceded by a color code and
optional styling markers will be converted to the respective ANSI color.

```ruby
say "this is b`blue` and ru`this is red underlined`"
```

The one letter color code is required, followed by up to 3 style code.

| Color Code | Color
|------------|-------
| `n`        | no color
| `k`        | black
| `r`        | red
| `g`        | green
| `y`        | yellow
| `b`        | blue
| `m`        | magenta
| `c`        | cyan
| `w`        | white

| Style Code | Style
|------------|-------
| `b`        | bold
| `u`        | underlined
| `i`        | inverted
| `z`        | terminate

## Upgrading

Version 0.8.x changes several things, including the syntax of the color
markers. For easy transition, it is compatible with older versions.

Follow these steps to upgrade:

```ruby

# => Require a more flexible version
# change this
gem 'colsole'
# to this (to avoid conflicts with other gems that require 0.x)
gem 'colsole', '>= 0.7.0', '< 2.0'

# => Remove 'say_status'
# It will no longer be supported in 1.0.0
say_status "text"

# => Replace 'resay'
# 'resay' is replaced with 'say replace: true'
# change this
resay "text"
# to this
say "text", replace: true

# => Change color markers syntax
# replace this
say "the !txtblu!blue"
# with this
say "the b`blue`"
```
