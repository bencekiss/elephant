require 'io/console'

class Stage
  attr_reader :x_length, :y_length
  attr_accessor :elephant, :peanut

  @@score = 0
  @@moves_left = 0
  @@bonus = 0

  def initialize(elephant, peanut)
    @elephant = elephant
    @peanut = peanut
    game_initialize
  end

  def game_initialize
    while true
      wipe
      puts "ELEPHANT PROGRAM"
      puts "================"
      print "Choose a grid size: \n[1] easy \n[2] medium \n[3] hard\n[x] quit\n"
      input = gets.chomp
      if input == "1"
        @x_length = 5; @y_length = 5
        @@moves_left = 8
        @@bonus = 3
        peanut_generator
        self.interface
      elsif input == "2"
        @x_length = 7; @y_length = 7
        @@moves_left = 10
        @@bonus = 5
        peanut_generator
        self.interface
      elsif input == "3"
        @x_length = 10; @y_length = 10
        @@moves_left = 12
        @@bonus = 7
        peanut_generator
        self.interface
      elsif input == "x"
        quit
      else
        wipe
        puts "Incorrect input. Please select [1], [2] or [3]."
      end
    end
  end

  def quit
    puts "Are you sure you want to quit? [Y/N]"
    yesno = gets.chomp
    if yesno == "Y"
      exit
    else
      game_initialize
    end
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
    while @@moves_left >= 0
      grid_display
      puts ""
      puts "Move the elephant [E] around the map to help it eat the peanut [*]."
      puts "[w] = move up \t\t[a] = move left \n[s] = move down \t[d] = move right\n"
      puts "[x] = exit"
      puts "\nPeanuts Eaten: #{@@score}"
      puts "Moves Left: #{@@moves_left}"
      possible_inputs = ["a", "s", "d", "w"]
      input = STDIN.getch.chomp
      @elephant.move(input, @x_length, @y_length)
      if possible_inputs.include?(input)
        @@moves_left -= 1
      end
      if [@elephant.x, @elephant.y] == [@peanut.x, @peanut.y]
        @@moves_left += @@bonus
        peanut_generator
        @@score += 1
      end
    end
    @@score = 0
    @elephant.x = 1; @elephant.y = 1
    puts "GAME OVER..."
    puts "Press any key to return to the main menu."
    input = gets.chomp
    if input != ""
      game_initialize
    end
  end

  def grid_display
    wipe
    puts "ELEPHANT PROGRAM"
    puts "================"
    # puts "Peanut #{[@peanut.x, @peanut.y]}, Elephant #{[@elephant.x, @elephant.y]}"
    x_line = ""
    e_line = ""
    p_line = ""
    ep_line = ""
    num = @y_length

    # Generating generic x line
    @x_length.times { x_line += "|_"
    }
    x_line += "|"

    # Generating x line when both peanut and elephant are on it.
    if @peanut.y == @elephant.y
      @x_length.times { |num|
        if num == @elephant.x-1
          ep_line += "|E"
        elsif num == @peanut.x-1
          ep_line += "|*"
        else
          ep_line += "|_"
        end
      }
      ep_line += "|"
    end

    # Generating x line with the elephant on it.
    @x_length.times { |num|
      if num == @elephant.x-1
        e_line += "|E"
      else
        e_line += "|_"
      end
    }
    e_line += "|"

    # Generating x line with the peanut on it.
    @x_length.times { |num|
      if num == @peanut.x-1
        p_line += "|*"
      else
        p_line += "|_"
      end
    }
    p_line += "|"

    # Generating generic y line
    @y_length.times {
      # print num.to_s
      if num == @elephant.y && num == @peanut.y
        puts ep_line
      elsif num == @elephant.y
        puts e_line
      elsif num == @peanut.y
        puts p_line
      else
        puts x_line
      end
      num -= 1
    }
    # print "  "
    # (1..@x_length).each { |num| print "#{num} "}
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
