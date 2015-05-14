#!/usr/bin/env ruby
require_relative 'lib/colsole'

# colored output (respects pipe)
say "!txtblu!Hello !txtred!World"

# partial messages
say "Downloading... "
sleep 1
say "!txtgrn!Downloaded"

# rewriting messages
say "Compiling... "
sleep 1
say "!txtgrn!Done"

