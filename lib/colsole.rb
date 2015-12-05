require "colsole/version"

# Colsole - Colorful Console Applications
#
# This class provides several utility functions for console 
# appliucation developers.
#
# - #colorize string - return a colorized strings
# - #say string - print a string with colors  
# - #resay string - same as say, but overwrite current line  
# - #word_wrap string - wrap a string and maintain indentation
# - #detect_terminal_size
#
# Credits:
# terminal width detection by Gabrial Horner https://github.com/cldwalker

module Colsole
	# Prints a color-flagged string.
	# Use color flags (like !txtred!) to change color in the string.
	# Space terminated strings will leave the cursor at the same line.
	def say(text, force_color=false) 
		last = text[-1, 1]
		if last == ' ' or last == '\t'
			print colorize(text, force_color)
		else
			print colorize("#{text}\n", force_color)
		end
	end

	# Prints a color-flagged string to STDERR
	# Use color flags (like !txtred!) to change color in the string.
	def say!(text, force_color=false) 
		$stderr.puts colorize(text, force_color, :stderr)
	end

	# Erase the current output line, and say a new string.
	# This should be used after a space terminated say().
	def resay(text, force_color=false) 
		terminal? and text = "\033[2K\r#{text}"
		say text, force_color
	end

	# Returns true if stdout/stderr is interactive terminal
	def terminal?(stream=:stdout)
		stream == :stdout ? out_terminal? : err_terminal?
	end

	# Returns true if stdout is interactive terminal
	def out_terminal?
		STDOUT.tty?
	end

	# Returns true if stderr is interactive terminal
	def err_terminal?
		STDERR.tty?
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
	def colorize(text=nil, force_color=false, stream=:stdout) 
		colors = prepare_colors

		if text.nil? # Demo
			i=33;
			colors.each do |k,v| 
				puts colorize "#{k} = !#{k}! #{i} bottles of beer on the wall !txtrst!"
				i -= 1
			end
			return
		end

		reset = colors['txtrst']
		if terminal?(stream) or force_color
			reset_called_last = true

			out = text.gsub(/\!([a-z]{6})\!/) do |m|
				reset_called_last = $1 == "txtrst";
			 	colors[$1];
			end
			reset_called_last or out = "#{out}#{reset}";
		else 
			out = text.gsub(/\!([a-z]{6})\!/, '')
		end

		return out
	end

	private 

	# Create a colors array with keys such as :green and :bld_green
	# and values which are the escape codes for the colors.
	def prepare_colors
		esc = 27.chr
		# pattern_full  = "#{esc}[%{decor};%{fg};%{bg}m"
		pattern_fg    = "#{esc}[%{decor};%{fg}m"
		pattern_reset = "#{esc}[0m"

		decors = { txt: 0, bld: 1, und: 4, rev: 7 }
		color_codes = { blk: 0, red: 1, grn: 2, ylw: 3, blu: 4, pur: 5, cyn: 6, wht: 7 }
		colors = {}

		decors.each do |dk, dv|
			color_codes.each do |ck, cv|
				key = "#{dk}#{ck}"
				val = pattern_fg % { decor: dv, fg: "3#{cv}" }
				colors[key] = val
			end
		end
		colors['txtrst'] = pattern_reset
		colors
	end
end

self.extend Colsole