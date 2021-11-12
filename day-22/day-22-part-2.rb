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
  previous_states = []

  while true do
    return 1 if player_2_deck.length == 0
    return 2 if player_1_deck.length == 0
    return 1 if previous_states.include?({'player_1_deck': player_1_deck, 'player_2_deck': player_2_deck})

    previous_states << {'player_1_deck': player_1_deck.clone, 'player_2_deck': player_2_deck.clone}

    round_winner = get_round_winner(player_1_deck, player_2_deck)
    adjust_decks(round_winner, player_1_deck, player_2_deck)
  end
end

def get_round_winner(player_1_deck, player_2_deck)
  if (player_1_deck.length - 1) >= player_1_deck[0] && (player_2_deck.length - 1) >= player_2_deck[0]
    player_1_subdeck = player_1_deck[1, player_1_deck[0]]
    player_2_subdeck = player_2_deck[1, player_2_deck[0]]
    return play_game_of_combat(player_1_subdeck, player_2_subdeck)
  end

  return 1 if player_1_deck[0] > player_2_deck[0]
  2
end

def adjust_decks(round_winner, player_1_deck, player_2_deck)
  if round_winner == 1
    player_1_deck.rotate!(1)
    player_1_deck << player_2_deck.shift
  else # round_winner == 2
    player_2_deck.rotate!(1)
    player_2_deck << player_1_deck.shift
  end
end

def calculate_score(winning_deck)
  total_score = 0
  winning_deck.reverse.each_with_index do |card, index|
    total_score += (card * (index + 1))
  end
  total_score
end

player_1_deck = load_deck('1')
player_2_deck = load_deck('2')

winner = play_game_of_combat(player_1_deck, player_2_deck)

puts calculate_score(player_1_deck) if (winner == 1)
puts calculate_score(player_2_deck) if (winner == 2)
