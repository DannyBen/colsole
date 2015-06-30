Colsole
=======

[![Gem Version](https://badge.fury.io/rb/colsole.svg)](http://badge.fury.io/rb/colsole)
[![Build Status](https://travis-ci.org/DannyBen/colsole.svg?branch=master)](https://travis-ci.org/DannyBen/colsole)
[![Code Climate](https://codeclimate.com/github/DannyBen/colsole/badges/gpa.svg)](https://codeclimate.com/github/DannyBen/colsole)

Utility functions for colorful console applications.

## Install

	$ gem install colsole

## Test

	$ rake test

## Functions

```ruby

# use #say as an alternative to puts
say "anything"					

# leave a trailing space to keep cursor at the same line
say "appears in "
say "one line"

# embed color markers in the string
say "!txtred!I am RED !txtgrn!I am GREEN"

# wrap long lines while keeping words in tact, and keeping 
# indentation based on the leading space
say word_wrap("    one two three four five", 15)

# output:
#    one two
#    three four
#    five

# use #resay after a space terminated string to rewrite the line
say "downloading... "
resay "downloaded."
```

## Todo

- Consider having `say` automatically word wrap
