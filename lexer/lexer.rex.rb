#--
# DO NOT MODIFY!!!!
# This file is automatically generated by rex 1.0.4
# from lexical definition file "/Users/lborges/projects/ruby/lang/bin/../lexer/lexer.rex".
#++

require 'racc/parser'
class Lexer < Racc::Parser
  require 'strscan'

  class ScanError < StandardError ; end

  attr_reader   :lineno
  attr_reader   :filename
  attr_accessor :state

  def scan_setup(str)
    @ss = StringScanner.new(str)
    @lineno =  1
    @state  = nil
  end

  def action(&block)
    yield
  end

  def scan_str(str)
    scan_setup(str)
    do_parse
  end

  def load_file( filename )
    @filename = filename
    open(filename, "r") do |f|
      scan_setup(f.read)
    end
  end

  def scan_file( filename )
    load_file(filename)
    do_parse
  end


  def next_token
    return if @ss.eos?

    text = @ss.peek(1)
    @lineno  +=  1  if text == "\n"
    token = case @state
    when nil
      case
      when (text = @ss.scan(/[ \t]+/))
         action { [:WHITESPACE, text] }

      when (text = @ss.scan(/func/))
         action { [:FUNC, [text, lineno]] }

      when (text = @ss.scan(/if/))
         action { [:IF, [text, lineno]] }

      when (text = @ss.scan(/else/))
         action { [:ELSE, [text, lineno]] }

      when (text = @ss.scan(/return/))
         action { [:RETURN, [text, lineno]] }

      when (text = @ss.scan(/==/))
         action { [:EQUALS, [text, lineno]] }

      when (text = @ss.scan(/\|\|/))
         action { [:OP_OR, [text, lineno]] }

      when (text = @ss.scan(/".*"/))
         action { [:STRING, [(/"(.*)"/.match(text)).captures[0], lineno]] }

      when (text = @ss.scan(/[a-z]\w*/))
         action { [:IDENTIFIER, [text, lineno]] }

      when (text = @ss.scan(/\d+/))
         action { [:NUMBER, [text.to_i, lineno]] }

      when (text = @ss.scan(/\n/))
         action { [:NEWLINE, text] }

      when (text = @ss.scan(/./))
         action { [text, [text, lineno]] }

      else
        text = @ss.string[@ss.pos .. -1]
        raise  ScanError, "can not match: '" + text + "'"
      end  # if

    else
      raise  ScanError, "undefined state: '" + state.to_s + "'"
    end  # case state
    token
  end  # def next_token

end # class

if __FILE__ == $0
  exit  if ARGV.size != 1
  filename = ARGV.shift
  rex = Lexer.new
  begin
    rex.load_file  filename
    while  token = rex.next_token
      p token
    end
  rescue
    $stderr.printf  "%s:%d:%s\n", rex.filename, rex.lineno, $!.message
  end
end
