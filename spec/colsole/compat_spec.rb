describe Colsole do
  describe '#say' do
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
        expect { say! '!txtgrn!hello' }.to output("\e[0;32mhello\n\e[0m").to_stderr
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
end
