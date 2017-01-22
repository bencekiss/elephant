require 'io/console'

class Stage
  attr_reader :x_length, :y_length
  attr_accessor :elephant, :peanut

  @@moves_left = 0
  @@bonus = 0
  @@fly = 3
  @@level_stat = "ELEPHANT!"
  @@info = ""

  def initialize(elephant, peanut)
    @elephant = elephant
    @peanut = peanut
    game_initialize
  end

  def self.create(elephant, peanut) # Don't forget to include arguments identical to initialize method
    stage_info = self.new(elephant, peanut)
  end

  def game_initialize
    while true
      wipe
      puts "DUMBO THE ELEPHANT"
      puts "=================="
      print "Choose a difficulty level: \n[1] easy \n[2] medium \n[3] hard\n[x] quit\n"
      input = gets.chomp
      if input == "1"
        @x_length = 3; @y_length = 3
        @@moves_left = 10
        @@bonus = 5
        peanut_generator
        self.interface
      elsif input == "2"
        @x_length = 4; @y_length = 3
        @@moves_left = 15
        @@bonus = 4
        peanut_generator
        self.interface
      elsif input == "3"
        @x_length = 4; @y_length = 4
        @@moves_left = 20
        @@bonus = 3
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
    yesno = gets.chomp.downcase
    if yesno == "y"
      exit
    else
      game_initialize
    end
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

  def interface # All gameplay mechanics fall into here
    level = 0
    score = 0
    level_string = "E"
    over = false
    until over
      grid_display
      stat_display
      puts "\nPeanuts Eaten: #{score}"
      puts "Moves Left: #{@@moves_left}"
      puts "Current Level: #{level_string}"
      puts "\n#{@@info}"
      possible_inputs = ["a", "s", "d", "w"]
      input = STDIN.getch.chomp.downcase

      # Move and Fly counter
      if input == "f"
        unless @@fly <= 0
          @elephant.move(input, @x_length, @y_length)
          @@fly -= 1
        end
      else
        @elephant.move(input, @x_length, @y_length)
        if possible_inputs.include?(input)
          @@info = ""
          @@moves_left -= 1
        end
      end

      # Elephant eats the peanut
      if [@elephant.x, @elephant.y] == [@peanut.x, @peanut.y]
        @@info += "CHOMP!"
        @@moves_left += @@bonus
        peanut_generator
        score += 1
        if score % 5 == 0
          level += 1
          @x_length += 1
          @y_length += 1
          level_string += @@level_stat[level]
        end
      end

      # Conditions for winning
      if level_string == @@level_stat
        wipe
        grid_display
        stat_display
        puts "\nPeanuts Eaten: #{score}"
        puts "Moves Left: #{@@moves_left}"
        puts "Current Level: #{level_string}"
        puts "\nYOU WIN!!!"
        puts "Dumbo is full from all the peanuts!"
        over = true
      end

      # Conditions for losing
      if @@moves_left <= 0
        wipe
        grid_display
        stat_display
        puts "\nPeanuts Eaten: #{score}"
        puts "Moves Left: #{@@moves_left}"
        puts "Current Level: #{level_string}"
        puts "\nGAME OVER..."
        puts "Dumbo died of starvation."
        over = true
      end
    end
    return game_over
  end

  def game_over
    @@fly = 3
    @elephant.x = 1; @elephant.y = 1
    puts "Press any key to return to the main menu."
    input = gets.chomp
    if input != ""
      game_initialize
    end
  end

  def stat_display
    puts ""
    puts "Move Dumbo [D] around the map to help him eat the peanut [*]."
    puts "Dumbo can fly to a new place on the map, but only a limited number of times."
    puts "[w] = move up \t\t[a] = move left \n[s] = move down \t[d] = move right\n"
    puts "[f] = fly (#{@@fly} left) \t[x] = exit"
  end

  def grid_display
    wipe
    puts "DUMBO THE ELEPHANT"
    puts "=================="
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
          ep_line += "|D"
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
        e_line += "|D"
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
    when "f" then @x = rand(1..x_length); @y = rand(1..y_length)
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
