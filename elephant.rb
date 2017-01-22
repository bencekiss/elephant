require 'io/console'

class Stage
  attr_reader :x_length, :y_length
  attr_accessor :elephant, :peanut

  def initialize(elephant, peanut)
    @elephant = elephant
    @peanut = peanut
    # print "Input x-length of stage: "
    # x_length = gets.chomp.to_i
    # print "Input y-length of stage: "
    # y_length = gets.chomp.to_i
    @x_length = 9
    @y_length = 9
    peanut_generator
    # self.interface
  end

  def self.create(elephant, peanut) # Don't forget to include arguments identical to initialize method
    stage_info = self.new(elephant, peanut)
  end

  def peanut_generator
    @peanut.x = rand(1..@x_length)
    @peanut.y = rand(1..@y_length)
    if [@peanut.x, @peanut.y] == [@elephant.x, @elephant.y]
      until [@peanut.x, @peanut.y] != [@elephant.x, @elephant.y]
        @peanut.x = rand(1..@x_length)
        @peanut.y = rand(1..@y_length)
      end
    end
    return [@peanut.x, @peanut.y]
  end

  def interface
    while true
      print_interface
      puts ""
      puts "ELEPHANT PROGRAM"
      puts "================"
      puts "Move the elephant [E] around the map to help it eat the peanut [*]."
      puts "[w] = move up \t\t[a] = move left \n[s] = move down \t[d] = move right\n"
      puts "[x] = exit"
      input = STDIN.getch.chomp
      @elephant.move(input, @x_length, @y_length)
    end
  end

  def print_interface
    wipe
    x_line = ""
    e_line = ""
    num = @y_length
    # Generating generic x line
    @x_length.times { x_line += "|_" }

    # Generating x line with the elephant on it.
    @x_length.times { |num|
      if num == @elephant.x-1
        e_line += "|E"
      else
        e_line += "|_"
      end
    }
    wipe

    # Generating generic y line
    @y_length.times {
      print num.to_s
      if num == @elephant.y
        puts e_line
      else
        puts x_line
      end
      num -= 1
    }
    print "  "
    (1..@x_length).each { |num| print "#{num} "}
    puts "\n"
  end

  def wipe
    puts "\e[H\e[2J"
  end
end

class Elephant
  attr_accessor :x, :y

  def initialize(x = 1, y = 1)
    @x = x
    @y = y
  end

  def move(input, x_length, y_length)
    case input
    when "a" then @x -= 1 unless @x <= 1
    when "s" then @y -= 1 unless @y <= 1
    when "d" then @x += 1 unless @x >= x_length
    when "w" then @y += 1 unless @y >= y_length
    when "x" then exit
    end
  end
end

class Peanut
  attr_accessor :x, :y

  def initialize
    @x = 0
    @y = 0
  end
end

stage = Stage.create(Elephant.new(1, 1), Peanut.new)
