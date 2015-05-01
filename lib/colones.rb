#
#  Colones - perfume for the console
#
#  colorize string : return a colorized strings
#  say string      : puts enhancement
#  resay string    : same as say, but overwrite current line
#
#  See usage at the end of the file
#

module Colones
	# use color flags (like !txtred!) to change color in the string
	# space terminated string will leave the cursor at the same line
	def say(text, force_color=false) 
		last = text[-1, 1]
		if last == ' ' or last == '\t'
			print colorize text, force_color
		else
			print colorize "#{text}!txtrst!\n", $force_color;
		end
	end

	# use resay() after a space terminated say() to replace the line
	def resay(text, force_color=false) 
		is_terminal and text = "\033[2K\r#{text}"
		say text, force_color
	end

	# return true of interactive, false if piped
	def is_terminal 
		STDOUT.tty?
	end

	# parse and return a color-flagged string, respect pipe and
	# auto terminate colored strings
	def colorize(text=nil, force_color=false) 
		colors = { 
			'txtblk' => '[0;30m', # Black - Regular
			'txtred' => '[0;31m', # Red
			'txtgrn' => '[0;32m', # Green
			'txtylw' => '[0;33m', # Yellow
			'txtblu' => '[0;34m', # Blue
			'txtpur' => '[0;35m', # Purple
			'txtcyn' => '[0;36m', # Cyan
			'txtwht' => '[0;37m', # White
			'bldblk' => '[1;30m', # Black - Bold
			'bldred' => '[1;31m', # Red
			'bldgrn' => '[1;32m', # Green
			'bldylw' => '[1;33m', # Yellow
			'bldblu' => '[1;34m', # Blue
			'bldpur' => '[1;35m', # Purple
			'bldcyn' => '[1;36m', # Cyan
			'bldwht' => '[1;37m', # White
			'unkblk' => '[4;30m', # Black - Underline
			'undred' => '[4;31m', # Red
			'undgrn' => '[4;32m', # Green
			'undylw' => '[4;33m', # Yellow
			'undblu' => '[4;34m', # Blue
			'undpur' => '[4;35m', # Purple
			'undcyn' => '[4;36m', # Cyan
			'undwht' => '[4;37m', # White
			'bakblk' => '[40m'  , # Black - Background
			'bakred' => '[41m'  , # Red
			'bakgrn' => '[42m'  , # Green
			'bakylw' => '[43m'  , # Yellow
			'bakblu' => '[44m'  , # Blue
			'bakpur' => '[45m'  , # Purple
			'bakcyn' => '[46m'  , # Cyan
			'bakwht' => '[47m'  , # White
			'txtrst' => '[0m'   , # Text Reset
		}

		if text.nil? # Demo
			i=33;
			colors.each do |k,v| 
				puts colorize "#{k} = !#{k}! #{i} bottles of beer on the wall !txtrst!"
				i -= 1
			end
			return
		end

		esc = 27.chr
		reset = esc + colors['txtrst']
		if is_terminal or force_color
			reset_called_last = false

			out = text.gsub /\!([a-z]{6})\!/ do |m|
				reset_called_last = $1 == "txtrst";
			 	esc + colors[$1];
			end

			reset_called_last or out = "#{out}#{reset}";
		else 
			out = text.gsub /\!([a-z]{6})\!/, ''
		end

		return out
	end

end

# Colorize string
#   colorize() # Demo
#   puts colorize "!txtred!Self terminating string\n"
#   puts colorize "A !txtred!multiple !txtylw!color !undblu!string!txtrst! with reset\n"
	
# Use say() as a puts enhancer
#   say "!txtred!Downloading... "
#   say "!txtgrn!Done"
#   say "!txtred!Downloading... "
#   sleep 2
#   resay "!txtgrn!Downloaded"
