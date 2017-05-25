require "colsole/version"

# Colsole - Colorful Console Applications
#
# This class provides several utility functions for console application 
# developers.
#
# - #colorize string - return a colorized strings
# - #say string - print a string with colors  
# - #say! string - print a string with colors to stderr
# - #resay string - same as say, but overwrite current line  
# - #say_status symbol, string [, color] - print a message with status
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

  # Prints a line with a colored status and message.
  # Status can be a symbol or a string. Color is optional, defaulted to
  # green (:txtgrn).
  def say_status(status, message, color=:txtgrn)
    say "!#{color}!#{status.to_s.rjust 12} !txtrst! #{message}"
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
  def detect_terminal_size(default=[80,30])
    if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
      [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
    elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && command_exist?('tput')
      [`tput cols`.to_i, `tput lines`.to_i]
    elsif STDIN.tty? && command_exist?('stty')
      result = `stty size`.scan(/\d+/).map { |s| s.to_i }.reverse
      result == [0,0] ? default : result
    else
      default
    end
  end

  # Returns terminal width with re-asking
  def terminal_width
    @terminal_width ||= detect_terminal_size[0]
  end

  # Converts a long string to be wrapped keeping words in tact.
  # If the string starts with one or more spaces, they will be 
  # preserved in all subsequent lines (i.e., remain indented).
  def word_wrap(text, length=nil)
    length ||= terminal_width
    lead = text[/^\s*/]
    text.strip!
    length -= lead.length
    text.split("\n").collect! do |line|
      line.length > length ? line.gsub(/(.{1,#{length}})(\s+|$)/, "#{lead}\\1\n").rstrip : "#{lead}#{line}"
    end * "\n"
  end

  # Parses and returns a color-flagged string.
  # Respects pipe and auto terminates colored strings.
  # Call without text to see a list/demo of all available colors.
  def colorize(text=nil, force_color=false, stream=:stdout) 
    return show_color_demo if text.nil?
    return strip_color_markers(text) unless terminal?(stream) || force_color
    colorize! text
  end

  private

  def colors
    @colors ||= prepare_colors
  end

  def colorize!(text)
    reset = colors['txtrst']
    reset_called_last = true

    out = text.gsub(/\!([a-z]{6})\!/) do |m|
      reset_called_last = $1 == "txtrst";
      colors[$1];
    end
    
    reset_called_last or out = "#{out}#{reset}";
    out
  end

  # Create a colors array with keys such as :txtgrn and :bldgrn
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

  def show_color_demo
    i=33;
    colors.each do |k,v| 
      puts colorize "#{k} = !#{k}! #{i} bottles of beer on the wall !txtrst!"
      i -= 1
    end
  end

  def strip_color_markers(text)
    text.gsub(/\!([a-z]{6})\!/, '')
  end

end

self.extend Colsole
