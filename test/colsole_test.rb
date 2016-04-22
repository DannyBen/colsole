require_relative 'test_helper'
require_relative '../lib/colsole'

class ColsoleTest < Minitest::Test
  include Colsole
  def test_say
    str = "Great leaders inspire greatness in others."
    assert_output("#{str}\n") { say "#{str}" }
    assert_output("#{str} ") { say "#{str} " }
  end

  def test_say_colors
    str = "Belief is not a matter of choice, but of conviction."
    assert_output("\e[0;32m#{str}\n\e[0m") { say "!txtgrn!#{str}" }
    assert_output("\e[0;32m#{str} \e[0m") { say "!txtgrn!#{str} " }
  end

  def test_say_partial_colors
    str = "The best !txtgrn!confidence builder!txtrst! is experience."
    out = "The best \e[0;32mconfidence builder\e[0m is experience."
    assert_output("#{out}\n") { say "#{str}" }
    assert_output("#{out} ") { say "#{str} " }
  end

  def test_resay
    str = "Heroes are made by the "   
    out = "Heroes are made by the \e[2K\rtimes."
    assert_output("#{out}\n") { say "#{str}"; resay "times." }
  end

  def test_say_status
    expect = "\e[0;32m      create \e[0m hello\n"
    assert_output(expect) { say_status :create, "hello" }
  end

  def test_say_status_with_color
    expect = "\e[0;31m      create \e[0m hello\n"
    assert_output(expect) { say_status :create, "hello", :txtred }
  end

  def test_word_wrap
    str = "   The winding path to peace is always a worthy one, regardless of how many turns it takes."
    out = "   The winding path to peace is always a\n   worthy one, regardless of how many\n   turns it takes."
    assert_equal out, word_wrap(str, 40)
  end

  def test_word_wrap_newline
    str = "   hello world\n\none\ntwo"
    out = "   hello\n   world\n   \n   one\n   two"
    assert_equal out, word_wrap(str, 12)
  end

  def test_say!
    str = "True leaders dont create followers, they create more leaders"
    assert_output(nil, "#{str}\n") { say! str }
  end

end