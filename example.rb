#!/usr/bin/env ruby
require 'colsole'
include Colsole

# colored output (respects pipe)
say "gi` Example 1 ` Color output"
say 'Colored: b`Hello` bi` World `'
say ''
sleep 2

# partial messages
say "gi` Example 2 ` Partial messages"
say 'Downloading... '
sleep 1
say 'g`Done`'
say ''
sleep 2

# rewriting messages
say "gi` Example 3 ` Replacing a message"
say 'Compiling... '
sleep 1
say 'g`Done`', replace: true
say ''
sleep 2

# wrap long lines with indentation
say "gi` Example 4 ` Word wrap"
say word_wrap "    What good is a reward if you ain't around to use it? Besides, attacking that battle station ain't my idea of courage. It's more like…suicide. I want to come with you to Alderaan. There's nothing for me here now. I want to learn the ways of the Force and be a Jedi, like my father before me."
say word_wrap "        Still, she's got a lot of spirit. I don't know, what do you think? Leave that to me. Send a distress signal, and inform the Senate that all on board were killed. Don't underestimate the Force. Remember, a Jedi can feel the Force flowing through him. As you wish."
sleep 1
say ''

# wrap long lines that contain newlines
poem = "Today I made my way to school\nI sat in back and played it cool.\n\nI think of all I might have missed\nand then I put them in a list."
say "\ny`No Wrap:`"
say poem
say ''

say "\ny`Wrap 30:`"
say word_wrap("#{poem}", 30)
say "\ny`Wrap 30 with indent:`"
say word_wrap("        #{poem}", 30)
sleep 1

# say to STDERR
say "gi` Example 5 ` Say to stderr"
say! 'ri` Error ` r`Failed Successfully`'
say ''
sleep 2

# detect if command exists
say "gi` Example 6 ` command_exist?"
puts "git exists" if command_exist? 'git'
