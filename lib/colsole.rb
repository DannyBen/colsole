require 'io/console'
require 'colsole/compat'

# Utility functions for colorful console applications.
module Colsole
  ANSI_COLORS = {
    'n' => '',       # no color
    'k' => "\e[30m", # black
    'r' => "\e[31m", # red
    'g' => "\e[32m", # green
    'y' => "\e[33m", # yellow
    'b' => "\e[34m", # blue
    'm' => "\e[35m", # magenta
    'c' => "\e[36m", # cyan
    'w' => "\e[37m", # white
  }

  ANSI_STYLES = {
    'b' => "\e[1m", # bold
    'u' => "\e[4m", # underlined
    'i' => "\e[7m", # inverted
    'z' => "\e[0m", # terminate
  }

  # Output a string with optional color markers to stdout.
  # If text is ended with a white space, you can call again with replace: true
  # to replace that line
  def say(text, replace: false)
    internal_say text, $stdout, replace: replace
  end

  # Output a string with optional color markers to stderr.
  # Behaves similarly to `#say`.
  def say!(text, replace: false)
    internal_say text, $stderr, replace: replace
  end

  # Returns true if stdout/stderr are a terminal
  def terminal?(stream = $stdout)
    case ENV['TTY']
    when 'on'  then true
    when 'off' then false
    else
      stream.tty?
    end
  end

  # Returns true if the command exists in the path
  def command_exist?(command)
    ENV['PATH'].split(File::PATH_SEPARATOR).any? do |dir|
      File.exist?(File.join dir, command) or File.exist?(File.join dir, "#{command}.exe")
    end
  end

  # Returns true if we can and should use colors in this stream
  def use_colors?(stream = $stdout)
    ENV['FORCE_COLOR'] || (!ENV['NO_COLOR'] && terminal?(stream))
  end

  # Returns the terminal size as [columns, rows].
  # Environment variables can be used to cheat.
  def terminal_size(default = [80, 30])
    result = if (ENV['COLUMNS'] =~ /^\d+$/) && (ENV['LINES'] =~ /^\d+$/)
      [ENV['COLUMNS'].to_i, ENV['LINES'].to_i]
    else
      safe_get_tty_size default
    end

    unless result[0].is_a?(Integer) && result[1].is_a?(Integer) && result[0].positive? && result[1].positive?
      result = default
    end

    result
  end

  # Returns the columns part of the `#terminal_size`
  def terminal_width
    terminal_size[0]
  end

  # Returns the rows part of the `#terminal_size`
  def terminal_height
    terminal_size[1]
  end

  # Converts a long string to be wrapped keeping words in tact.
  # If the string starts with one or more spaces, they will be preserved in
  # all subsequent lines (i.e., remain indented).
  def word_wrap(text, length = nil)
    length ||= terminal_width
    lead = text[/^\s*/]
    text.strip!
    length -= lead.length
    text.split("\n").collect! do |line|
      if line.length > length
        line.gsub!(/([^\s]{#{length}})([^\s$])/, '\\1 \\2')
        line.gsub(/(.{1,#{length}})(\s+|$)/, "#{lead}\\1\n").rstrip
      else
        "#{lead}#{line}"
      end
    end * "\n"
  end

  # Convert color markers to ansi colors.
  def colorize(string)
    # compatibility later
    compat_string = old_colorize string

    process_color_markers compat_string do |color, styles, text|
      "#{styles}#{color}#{text}#{ANSI_STYLES['z']}"
    end
  end

  # Remove color markers.
  def strip_colors(string)
    # compatibility layer
    compat_string = old_strip_colors string

    process_color_markers(compat_string) { |_color, _styles, text| text }
  end

private

  def process_color_markers(string)
    string.gsub(/([rgybmcn])([ubi]{0,3})`([^`]*)`/) do
      color = ANSI_COLORS[$1]
      styles = $2.chars.map { |a| ANSI_STYLES[a] }.join
      text = $3
      yield color, styles, text
    end
  end

  def internal_say(text, stream, replace: false)
    text = "\033[2K\r#{text}" if replace && terminal?
    last = text[-1, 1]
    handler = use_colors?(stream) ? :colorize : :strip_colors

    if terminal? && ((last == ' ') || (last == '\t'))
      stream.print send(handler, text)
    else
      stream.print send(handler, "#{text}\n")
    end
  end

  def safe_get_tty_size(default = [80, 30])
    IO.console.winsize.reverse
  rescue Errno::ENOTTY
    default
  end
end
