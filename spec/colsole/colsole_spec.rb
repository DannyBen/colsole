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
        old_value = ENV['TTY']

        before { ENV['TTY'] = 'off' }
        after { ENV['TTY'] = old_value }

        it 'adds newline as if the text did not end with a space' do
          expect { say 'hello ' }.to output("hello \n").to_stdout
        end
      end
    end

    context 'with color markers' do
      it 'prints ansi colors' do
        expect { say 'g`hello` w`world`' }
          .to output("\e[32mhello\e[0m w`world`\n").to_stdout
      end
    end

    context 'with replace: true' do
      it 'overwrites the current line' do
        expect do
          say 'go '
          say 'home', replace: true
        end.to output("go \e[2K\rhome\n").to_stdout
      end
    end
  end

  describe '#say!' do
    it 'prints the message to stderr' do
      expect { say! 'hello' }.to output("hello\n").to_stderr
    end

    context 'with color markers' do
      it 'prints ansi colors' do
        expect { say! 'g`hello` w`world`' }
          .to output("\e[32mhello\e[0m w`world`\n").to_stderr
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
        allow($stdout).to receive(:tty?).and_return true
        expect(terminal?).to be true
        ENV['TTY'] = prev_value
      end
    end

    context 'with $stderr parameter' do
      context 'when TTY environment is on' do
        it 'always returns true' do
          prev_value = ENV['TTY']
          ENV['TTY'] = 'on'
          expect(terminal? $stderr).to be true
          ENV['TTY'] = prev_value
        end
      end

      context 'when TTY environment is off' do
        it 'always returns false' do
          prev_value = ENV['TTY']
          ENV['TTY'] = 'off'
          expect(terminal? $stderr).to be false
          ENV['TTY'] = prev_value
        end
      end

      context 'when TTY environment is unset' do
        it 'refers to the stream' do
          prev_value = ENV['TTY']
          ENV['TTY'] = nil
          allow($stderr).to receive(:tty?).and_return true
          expect(terminal? $stderr).to be true
          ENV['TTY'] = prev_value
        end
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
      original_path = ENV['PATH']

      before :all do
        system 'touch tmp/some-command.exe'
        ENV['PATH'] = "./tmp:#{original_path}"
      end

      after :all do
        system 'rm tmp/some-command.exe'
        ENV['PATH'] = original_path
      end

      it 'returns true' do
        expect(command_exist? 'some-command').to be true
      end
    end
  end

  describe '#terminal_size' do
    subject { terminal_size }

    context 'when COLUMNS and LINES are set' do
      before do
        ENV['COLUMNS'] = '44'
        ENV['LINES'] = '11'
      end

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

      it 'refers to $stdout.winsize' do
        expected = $stdout.winsize.reverse
        expect(subject).to match_array([Integer, Integer])
        expect(subject[0]).to eq expected[0]
        expect(subject[1]).to eq expected[1]
      end

      context 'when it cannot detect size' do
        subject { terminal_size [55, 33] }

        before do
          allow($stdout).to receive(:winsize).and_return [nil, nil]
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
      expect(terminal_width).to eq terminal_size[0]
    end
  end

  describe '#terminal_height' do
    it 'returns the second element of #detect_terminal_size' do
      expect(terminal_height).to eq terminal_size[1]
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
      expect(colorize 'b`hello` g`world`').to eq "\e[34mhello\e[0m \e[32mworld\e[0m"
    end
  end

  describe '#strip_colors' do
    it 'returns a strin without colsole color markers' do
      expect(strip_colors 'b`hello` g`world`').to eq 'hello world'
    end
  end
end
