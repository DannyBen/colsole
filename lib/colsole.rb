#  Colsole - Coloful Console Applications
#
#  This class provides several utility functions for console 
#  appliucation developers.
#
#  - #colorize string - return a colorized strings
#  - #say string - print a string with colors  
#  - #resay string - same as say, but overwrite current line  
#  - #word_wrap string - wrap a string and maintain indentation
#  - #detect_terminal_size
#
#  Credits:
#  terminal width detection by Gabrial Horner https://github.com/cldwalker
#  color mapping by ondrovic http://www.backtrack-linux.org/forums/showthread.php?t=29691&s=f681fb882b13be26ee726e5f335d089e

module Colsole
	
	# Prints a color-flagged string.
	# Use color flags (like !txtred!) to change color in the string.
	# Space terminated strings will leave the cursor at the same line.
	def say(text, force_color=false) 
		last = text[-1, 1]
		if last == ' ' or last == '\t'
			print colorize text, force_color
		else
			print colorize "#{text}\n", force_color;
		end
	end

	# Erase the current output line, and say a new string.
	# This should be used after a space terminated say().
	def resay(text, force_color=false) 
		is_terminal and text = "\033[2K\r#{text}"
		say text, force_color
	end

	# Returns true if interactive terminal, false if piped.
	def is_terminal 
		STDOUT.tty?
	end

	# Determines if a shell command exists.
	def command_exist?(command)
		ENV['PATH'].split(File::PATH_SEPARATOR).any? {|d| File.exist? File.join(d, command) }
	end

	# Returns [width, height] of terminal when detected, or a default
	# value otherwise.
	def detect_terminal_size(default=80)
		if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
			[ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
		elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && command_exist?('tput')
			[`tput cols`.to_i, `tput lines`.to_i]
		elsif STDIN.tty? && command_exist?('stty')
			`stty size`.scan(/\d+/).map { |s| s.to_i }.reverse
		else
			default
		end
	end

	# Converts a long string to be wrapped keeping words in tact.
	# If the string starts with one or more spaces, they will be 
	# preserved in all subsequent lines (i.e., remain indented).
	def word_wrap(text, length=78)
		lead = text[/^\s*/]
		length -= lead.size
		text.gsub(/(.{1,#{length}})(\s+|\Z)/, "\\1\n#{lead}").rstrip
	end

	# Parses and returns a color-flagged string.
	# Respects pipe and auto terminates colored strings.
	# Call without text to see a list/demo of all available colors.
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
			reset_called_last = true

			out = text.gsub(/\!([a-z]{6})\!/) do |m|
				reset_called_last = $1 == "txtrst";
			 	esc + colors[$1];
			end
			reset_called_last or out = "#{out}#{reset}";
		else 
			out = text.gsub(/\!([a-z]{6})\!/, '')
		end

		return out
	end
end

self.extend Colsole