#!/usr/bin/env ruby
require_relative 'lib/colsole'

say "hello"
exit

# colored output (respects pipe)
say "!txtblu!Hello !txtred!World"

# partial messages
say "Downloading... "
sleep 1
say "!txtgrn!Downloaded"

# rewriting messages
say "Compiling... "
sleep 1
resay "!txtgrn!Done"

# wrap long lines with indentation
say word_wrap "    What good is a reward if you ain't around to use it? Besides, attacking that battle station ain't my idea of courage. It's more like…suicide. I want to come with you to Alderaan. There's nothing for me here now. I want to learn the ways of the Force and be a Jedi, like my father before me."
say word_wrap "        Still, she's got a lot of spirit. I don't know, what do you think? Leave that to me. Send a distress signal, and inform the Senate that all on board were killed. Don't underestimate the Force. Remember, a Jedi can feel the Force flowing through him. As you wish."