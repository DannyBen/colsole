require 'spec_helper'

describe Colsole do
  describe '#say' do
    it 'prints the message' do
      expect { say 'hello' }.to output("hello\n").to_stdout
    end

    context 'with a space ending' do
      it 'stays on the same line' do
        expect { say 'hello ' }.to output('hello ').to_stdout
      end

      context 'when not in tty' do
        before do
          @old_value = ENV['TTY']
          ENV['TTY'] = 'off'
        end

        after { ENV['TTY'] = @old_value }

        it 'adds newline as if the text did not end with a space' do
          expect { say 'hello ' }.to output("hello \n").to_stdout
        end
      end
    end

    context 'with color markers' do
      it 'prints ansi colors' do
        expect { say '!txtgrn!hello' }.to output("\e[0;32mhello\n\e[0m").to_stdout
      end
    end
  end

  describe '#say!' do
    it 'prints the message to stderr' do
      expect { say! 'hello' }.to output("hello\n").to_stderr
    end

    context 'with color markers' do
      it 'prints ansi colors' do
        expect { say! '!txtgrn!hello' }.to output("\e[0;32mhello\e[0m\n").to_stderr
      end
    end
  end

  describe '#resay' do
    it 'overwrites the current line' do
      expect do
        say 'go '
        resay 'home'
      end.to output("go \e[2K\rhome\n").to_stdout
    end
  end

  describe '#say_status' do
    it 'prints a colorful status message' do
      expected = "\e[0;32m      create \e[0m hello\n"
      expect { say_status :create, 'hello' }.to output(expected).to_stdout
    end

    context 'with an explicit color' do
      it 'prints a colorful status message' do
        expected = "\e[0;31m      create \e[0m hello\n"
        expect { say_status :create, 'hello', :txtred }.to output(expected).to_stdout
      end
    end

    context 'without a message' do
      it 'uses a different default color' do
        expected = "\e[0;34m      create \e[0m\n"
        expect { say_status :create }.to output(expected).to_stdout
      end
    end
  end

  describe '#terminal?' do
    context 'when TTY environment is on' do
      it 'always returns true' do
        prev_value = ENV['TTY']
        ENV['TTY'] = 'on'
        expect(terminal?).to be true
        ENV['TTY'] = prev_value
      end
    end

    context 'when TTY environment is off' do
      it 'always returns false' do
        prev_value = ENV['TTY']
        ENV['TTY'] = 'off'
        expect(terminal?).to be false
        ENV['TTY'] = prev_value
      end
    end

    context 'when TTY environment is unset' do
      it 'refers to the stream' do
        prev_value = ENV['TTY']
        ENV['TTY'] = nil
        expect($stdout).to receive(:tty?).and_return true
        expect(terminal?).to be true
        ENV['TTY'] = prev_value
      end
    end
  end

  describe '#command_exist?' do
    context 'with an existing command' do
      it 'returns true' do
        expect(command_exist? 'ruby').to be true
      end
    end

    context 'with an non existing command' do
      it 'returns false' do
        expect(command_exist? 'some_non_existing_command').to be false
      end
    end

    context 'with an existing command on windows' do
      before :all do
        @original_path = ENV['PATH']
        system 'touch tmp/some-command.exe'
        ENV['PATH'] = "./tmp:#{@original_path}"
      end

      after :all do
        system 'rm tmp/some-command.exe'
        ENV['PATH'] = @original_path
      end

      it 'returns true' do
        expect(command_exist? 'some-command').to be true
      end
    end
  end

  describe '#detect_terminal_size' do
    context 'when COLUMNS and LINES are set' do
      before do
        ENV['COLUMNS'] = '44'
        ENV['LINES'] = '11'
      end

      subject { detect_terminal_size }

      it 'returns the size from the environment' do
        expect(subject[0]).to eq 44
        expect(subject[1]).to eq 11
      end
    end

    context 'when COLUMNS and LINES are unset' do
      before do
        ENV['COLUMNS'] = nil
        ENV['LINES'] = nil
      end

      context 'when using tput' do
        subject { detect_terminal_size }

        before do
          expect($stdin).to receive(:tty?).and_return false
          ENV['TERM'] ||= 'linux'
          expect(self).to receive(:command_exist?).with('tput').and_return true
          expect(self).to receive(:`).with('tput cols 2>&1').and_return 44
          expect(self).to receive(:`).with('tput lines 2>&1').and_return 33
        end

        it 'returns the size' do
          expect(subject[0]).to eq 44
          expect(subject[1]).to eq 33
        end
      end

      context 'when using stty' do
        subject { detect_terminal_size }

        before do
          expect($stdin).to receive(:tty?).twice.and_return true
          expect(self).to receive(:command_exist?).with('stty').and_return true
          expect(self).to receive(:`).with('stty size 2>&1').and_return '12 66'
        end

        it 'returns the size' do
          expect(subject[0]).to eq 66
          expect(subject[1]).to eq 12
        end
      end

      context 'when cannot detect size' do
        subject { detect_terminal_size [55, 33] }

        before do
          expect($stdin).to receive(:tty?).twice.and_return true
          expect(self).to receive(:command_exist?).with('stty').and_return false
        end

        it 'returns the default size' do
          expect(subject[0]).to eq 55
          expect(subject[1]).to eq 33
        end
      end

      context 'when result is not a number' do
        subject { detect_terminal_size [55, 33] }

        before do
          expect($stdin).to receive(:tty?).twice.and_return true
          expect(self).to receive(:command_exist?).with('stty').and_return true
          expect(self).to receive(:`).with('stty size 2>&1').and_return 'invalid-values'
        end

        it 'returns the default size' do
          expect(subject[0]).to eq 55
          expect(subject[1]).to eq 33
        end
      end
    end
  end

  describe '#terminal_width' do
    it 'returns the first element of #detect_terminal_size' do
      expect(terminal_width).to eq detect_terminal_size[0]
    end
  end

  describe '#word_wrap' do
    it 'adds newlines at wrap point' do
      str = '   The winding path to peace is always a worthy one, regardless of how many turns it takes.'
      out = "   The winding path to peace is always a\n   worthy one, regardless of how many\n   turns it takes."
      expect(word_wrap(str, 40)).to eq out
    end

    context 'with newlines in the source string' do
      it 'adds newlines at wrap points' do
        str = "   hello world\n\none\ntwo"
        out = "   hello\n   world\n   \n   one\n   two"
        expect(word_wrap(str, 12)).to eq out
      end
    end

    context 'with lines that contain words longer than width' do
      it 'adds newlines at wrap points' do
        str = '  12345678 abc 12345678'
        out = "  123456\n  78 abc\n  123456\n  78"
        expect(word_wrap(str, 8)).to eq out
      end
    end
  end

  describe '#colorize' do
    it 'returns an ansi-colored string' do
      expected = "\e[0;34mhello\e[0m world"
      expect(colorize '!txtblu!hello!txtrst! world').to eq expected
    end

    context 'when the stream is not a terminal' do
      it 'strips colors' do
        expect(self).to receive(:terminal?).and_return false
        expected = 'hello world'
        expect(colorize '!txtblu!hello!txtrst! world').to eq expected
      end
    end

    context 'without arguments' do
      it 'outputs a demo string' do
        expected = /txtblk = .*m 36 bottles of beer on the wall .*m\n/
        expect { colorize }.to output(expected).to_stdout
      end
    end
  end
end
