# Colsole

![repocard](https://repocard.dannyben.com/svg/colsole.svg)

Utility functions for colorful console applications.

## Install

Add to your Gemfile:

```
$ gem 'colsole', '>= 0.8.1', '< 2.0'
```

## Usage

```ruby
require 'colsole'
include Colsole
say 'b`Blue` Man Group'
```

All the methods described below can also be called directly on the `Colsole` module. This is useful when you want to use it at the top level of your project, without namespace contamination:

```ruby
require 'colsole'
Colsole.say 'b`Blue` Man Group'
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

| Color Code | Color    |
| ---------- | -------- |
| `n`        | no color |
| `k`        | black    |
| `r`        | red      |
| `g`        | green    |
| `y`        | yellow   |
| `b`        | blue     |
| `m`        | magenta  |
| `c`        | cyan     |
| `w`        | white    |

| Style Code | Style      |
| ---------- | ---------- |
| `b`        | bold       |
| `u`        | underlined |
| `i`        | inverted   |
| `z`        | terminate  |

## Contributing / Support

If you experience any issue, have a question or a suggestion, or if you wish
to contribute, feel free to [open an issue][issues].

---

[issues]: https://github.com/dannyben/colsole/issues
