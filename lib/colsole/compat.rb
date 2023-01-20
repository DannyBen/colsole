# This file contains methods that are called by the main Colsole module
# for compatibility with older versions of colsole.
# Do not use these methods directly.
module Colsole
  def detect_terminal_size(*args)
    terminal_size(*args)
  end

  def old_colorize(text)
    reset = colors['txtrst']
    reset_called_last = true

    out = text.gsub(/!([a-z]{6})!/) do
      reset_called_last = $1 == 'txtrst'
      colors[$1]
    end

    reset_called_last or out = "#{out}#{reset}"
    out
  end

  def old_strip_colors(text)
    text.gsub(/!([a-z]{6})!/, '')
  end

  def resay(text)
    say text, replace: true
  end

  def say_status(status, message = nil, color = nil)
    color ||= (message ? :txtgrn : :txtblu)
    say "!#{color}!#{status.to_s.rjust 12} !txtrst! #{message}".strip
  end

  def colors
    @colors ||= begin
      esc = 27.chr
      pattern = "#{esc}[%{decor};%{fg}m"

      decors = { txt: 0, bld: 1, und: 4, rev: 7 }
      color_codes = { blk: 0, red: 1, grn: 2, ylw: 3, blu: 4, pur: 5, cyn: 6, wht: 7 }
      colors = {}

      decors.each do |dk, dv|
        color_codes.each do |ck, cv|
          key = "#{dk}#{ck}"
          val = pattern % { decor: dv, fg: "3#{cv}" }
          colors[key] = val
        end
      end

      colors['txtbld'] = "#{esc}[1m"
      colors['txtund'] = "#{esc}[4m"
      colors['txtrev'] = "#{esc}[7m"
      colors['txtrst'] = "#{esc}[0m"
      colors
    end
  end
end
