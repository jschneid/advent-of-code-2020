def load_deck(player)
  input_lines = File.readlines('input.txt', chomp: true)

  player_start_index = input_lines.index { |line| line == "Player #{player}:" } + 1

  deck = []
  input_lines[player_start_index..].each do |line|
    break if line == ''
    deck << line.to_i
  end
  deck
end

def play_game_of_combat(player_1_deck, player_2_deck)
  while !game_over?(player_1_deck, player_2_deck) do
    play_round(player_1_deck, player_2_deck)
  end

  calculate_score(winning_deck(player_1_deck, player_2_deck))
end

def play_round(player_1_deck, player_2_deck)
  if player_1_deck[0] > player_2_deck[0]
    player_1_deck.rotate!(1)
    player_1_deck << player_2_deck.shift
  else
    player_2_deck.rotate!(1)
    player_2_deck << player_1_deck.shift
  end
end

def winning_deck(player_1_deck, player_2_deck)
  return player_1_deck if player_2_deck.length == 0
  player_2_deck
end

def calculate_score(winning_deck)
  total_score = 0
  winning_deck.reverse.each_with_index do |card, index|
    total_score += (card * (index + 1))
  end
  total_score
end

def game_over?(player_1_deck, player_2_deck)
  player_1_deck.length == 0 || player_2_deck.length == 0
end

player_1_deck = load_deck('1')
player_2_deck = load_deck('2')
puts play_game_of_combat(player_1_deck, player_2_deck)
