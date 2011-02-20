
@foundChars = ""
@word

def choose_word
  file = File.new '/usr/share/dict/ngerman',"r"
  if not File.exist? file.path
    return %w(ameisengrube salbeiblaetterteemischung konservierungstoffe)[rand(2)]
  else
    dict = Array.new
    file.each { |word|
      dict << word
    }
    return dict[rand(dict.size - 1)].downcase.strip
  end
end

def gui pull, errors, win = false, dead = false, solution = ""
  space = ""
  base = "########" 
  chain = "^^^^^^^^^^^^^^"    
  errors.times do
    space += " "
    base = " " + base
  end
  szene = "    _________   
    |/      #{!win ? "|" : ""}    
    |       #{!dead ? "O" : "@"}   #{!win ? "" : '"thank god"'}                       
    |      /|\\                                        
   /\\     #{!dead ? "/ " : " |"}|#{!dead ? " \\" : "  "}            #{space}       O___ \"#{pull ? !dead ? (@foundChars.size == 0 and errors == 0 ? "Guess...": "wrong") : "see you in hell. " + "you should said '" + solution + "'" : !win ? "lucky man" : "damn!"}\"              
  /  \\     #{!dead ? "/ " : " |"}\\             #{space}      /|   
 /    \\ #{base}#{!pull ? "               " : chain + "|"}#{pull ? "_/" : "  "} |    
/      \\#{base}#{pull ? "                 " : chain + "^^^"}/#{pull ? "/" : "|"}\n\n"
end

def hangman errors = 0, pull = true
  win = @foundChars.size > 0 ? (@foundChars.split(//).sort == @word.split(//).uniq.sort) : false
  dead = errors == 7 ? true : false
 
  puts gui pull, errors, win, dead, dead ? @word : ""
   
  @word.size.times do |i|
    print ((@foundChars.include? @word[i]) ? @word[i].chr : "_") + " "
  end
  
  if dead or win
    puts ""
    return
  end
  
  print "\n\nEnter an character: "
  c =  gets.strip[0,1].gsub /\s/, "@" # unlikely in a word
  found = (@word[/#{c}/] and not @foundChars[/#{c}/]) ? @foundChars += c : false  
  hangman errors + (found.class == FalseClass ? 1 : 0),  !found 
end

if ARGV[0] == "test"
  require 'test/unit'
  class TC_Gui < Test::Unit::TestCase
    def test_normal_stuff
      assert (gui(true, 0, false, true) =~ /^.*see you in hell.*$/)
    end
  end
else
 ARGV.clear
 @word = choose_word() 
 hangman()
end