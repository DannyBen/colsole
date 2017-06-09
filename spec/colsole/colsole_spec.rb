require 'spec_helper'

describe Colsole do
  describe "#say" do
    it "prints the message" do
      expect{say 'hello'}.to output("hello\n").to_stdout
    end

    context "with a space ending" do
      it "stays on the same line" do
        expect{say 'hello '}.to output('hello ').to_stdout 
      end
    end

    context "with color markers" do
      it "prints ansi colors" do
        expect{say '!txtgrn!hello'}.to output("\e[0;32mhello\n\e[0m").to_stdout
      end
    end
  end

  describe "#say!" do
    it "prints the message to stderr" do
      expect{say! 'hello'}.to output("hello\n").to_stderr
    end

    context "with color markers" do
      it "prints ansi colors" do
        expect{say! '!txtgrn!hello'}.to output("\e[0;32mhello\e[0m\n").to_stderr
      end
    end
  end

  describe "#resay" do
    it "overwrites the current line" do
      expect{say 'go '; resay 'home'}.to output("go \e[2K\rhome\n").to_stdout
    end
  end

  describe "#say_status" do
    it "prints a colorful status message" do
      expected = "\e[0;32m      create \e[0m hello\n"
      expect{say_status :create, "hello"}.to output(expected).to_stdout
    end

    context "with an explicit color" do
      it "prints a colorful status message" do
        expected = "\e[0;31m      create \e[0m hello\n"
        expect{say_status :create, "hello", :txtred}.to output(expected).to_stdout
      end
    end
  end

  describe "#command_exist?" do
    context "with an existing command" do
      it "returns true" do
        expect(command_exist? 'ruby').to be true
      end
    end
    
    context "with an non existing command" do
      it "returns false" do
        expect(command_exist? 'some_non_existing_command').to be false
      end
    end
  end

  describe "#detect_terminal_size" do
    context "when size can be detected" do
      let(:subject) { detect_terminal_size }

      it "returns the size" do
        expect(subject[0]).to be_a Fixnum
        expect(subject[1]).to be_a Fixnum
      end
    end

    context "when size cannot be detected" do
      let(:subject) { detect_terminal_size [40,20]}

      it "returns the default size" do
        expect(Terminal).to receive(:size).and_return({width:nil, height:nil})
        expect(subject).to eq [40,20]
      end
    end
  end

  describe "#termina_width" do
    it "returns the first element of #detect_terminal_size" do
      expect(terminal_width).to eq detect_terminal_size[0]
    end
  end


  describe "#word_wrap" do
    it "adds newlines at wrap point" do
      str = "   The winding path to peace is always a worthy one, regardless of how many turns it takes."
      out = "   The winding path to peace is always a\n   worthy one, regardless of how many\n   turns it takes."
      expect(word_wrap(str, 40)).to eq out
    end

    context "with newlines in the source string" do
      it "adds newlines at wrap points" do
        str = "   hello world\n\none\ntwo"
        out = "   hello\n   world\n   \n   one\n   two"
        expect(word_wrap(str, 12)).to eq out      
      end
    end
  end

  describe "#colorize" do    
    it "returns an ansi-colored string" do
      expected = "\e[0;34mhello\e[0m world"
      expect(colorize "!txtblu!hello!txtrst! world").to eq expected
    end

    context "when the stream is not a terminal" do
      it "strips colors" do
        expect(self).to receive(:terminal?).and_return false
        expected = "hello world"
        expect(colorize "!txtblu!hello!txtrst! world").to eq expected
      end
    end

    context "without arguments" do
      it "outputs a demo string" do
        expected = /txtblk = .*m 33 bottles of beer on the wall .*m\n/
        expect{colorize}.to output(expected).to_stdout
      end
    end
  end

end
