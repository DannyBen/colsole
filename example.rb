#!/usr/bin/env ruby
require_relative 'lib/colsole'

# colored output (respects pipe)
say '!txtblu!Hello !txtred!World'

# partial messages
say 'Downloading... '
sleep 1
say '!txtgrn!Downloaded'

# rewriting messages
say 'Compiling... '
sleep 1
resay '!txtgrn!Done'
sleep 1

# wrap long lines with indentation
say word_wrap "    What good is a reward if you ain't around to use it? Besides, attacking that battle station ain't my idea of courage. It's more like…suicide. I want to come with you to Alderaan. There's nothing for me here now. I want to learn the ways of the Force and be a Jedi, like my father before me."
say word_wrap "        Still, she's got a lot of spirit. I don't know, what do you think? Leave that to me. Send a distress signal, and inform the Senate that all on board were killed. Don't underestimate the Force. Remember, a Jedi can feel the Force flowing through him. As you wish."
sleep 1

# wrap long lines that contain newlines
poem = "Today I made my way to school\nI sat in back and played it cool.\n\nI think of all I might have missed\nand then I put them in a list."
say "\n!txtylw!No Wrap:"
say poem
say "\n!txtylw!Wrap 30:"
say word_wrap("#{poem}", 30)
say "\n!txtylw!Wrap 30 with indent:"
say word_wrap("        #{poem}", 30)
sleep 1

# say to STDERR
say! '!txtred!Error: Failed to fail'
sleep 1

# say status
say_status :create, 'perpetual energy'
say_status :destroy, 'ozone layer', :txtred
sleep 1

# see all color tags
say "\n!txtylw!All color markers:"
colorize
