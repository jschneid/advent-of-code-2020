class Cup
  attr_reader :label
  attr_accessor :clockwise_cup

  def initialize(label)
    @label = label
  end
end

def play_crab_game
  current_cup = setup_cups

  10000000.times do
    current_cup = perform_move(current_cup)
  end

  cup_one = @cup_pointers[1]
  cup_one.clockwise_cup.label * cup_one.clockwise_cup.clockwise_cup.label
end

def setup_cups
  initial_cup_order = File.read('input.txt').chomp

  @cup_pointers = {}
  current_cup = nil
  last_cup = nil
  initial_cup_order.each_char do |char|
    cup = Cup.new(char.to_i)

    current_cup = cup if !current_cup

    @cup_pointers[cup.label] = cup

    last_cup.clockwise_cup = cup if last_cup

    last_cup = cup
  end

  (((@cup_pointers.count)+1)..1000000).each do |i|
    cup = Cup.new(i)

    @cup_pointers[cup.label] = cup

    last_cup.clockwise_cup = cup
    last_cup = cup
  end

  last_cup.clockwise_cup = current_cup

  current_cup
end

def perform_move(current_cup)
  picked_up_cup_first = current_cup.clockwise_cup
  current_cup.clockwise_cup = current_cup.clockwise_cup.clockwise_cup.clockwise_cup.clockwise_cup

  destination_cup = select_destination_cup(current_cup, picked_up_cup_first)

  picked_up_cup_first.clockwise_cup.clockwise_cup.clockwise_cup = destination_cup.clockwise_cup
  destination_cup.clockwise_cup = picked_up_cup_first

  current_cup.clockwise_cup
end

def select_destination_cup(current_cup, picked_up_cup_first)
  destination_label = current_cup.label
  loop do
    destination_label = destination_label - 1
    destination_label = @cup_pointers.count if destination_label == 0

    if picked_up_cup_first.label != destination_label &&
      picked_up_cup_first.clockwise_cup.label != destination_label &&
      picked_up_cup_first.clockwise_cup.clockwise_cup.label != destination_label
      return @cup_pointers[destination_label]
    end
  end
end

pp play_crab_game
