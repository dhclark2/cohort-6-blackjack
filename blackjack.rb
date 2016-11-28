class Card
  # value
  # suit
  attr_accessor :value, :suit, :face

  def description
    "The #{face} of #{suit}"
  end
end

class Deck
  # 52 cards (13 of each suit)
  #   2,3,4,5,6,7,8,9,10,J,Q,K,Ace
  # Spade, Club, Heart, Diamond
  # Shuffle
  # Deal
  attr_accessor :cards
  def initialize
    @cards = []

    ["Spades", "Clubs", "Hearts", "Diamonds"].each do |suit|
      faces_and_values = {
        2       => 2,
        3       => 3,
        4       => 4,
        5       => 5,
        6       => 6,
        7       => 7,
        8       => 8,
        9       => 9,
        10      => 10,
        "Jack"  => 10,
        "Queen" => 10,
        "King"  => 10,
        "Ace"   => 11
      }
      faces_and_values.each do |face, value|
        card = Card.new
        card.value = value
        card.suit = suit
        card.face = face
        @cards << card
      end
    end
    @cards.shuffle!
  end

  def deal
    @cards.pop
  end
end

class Hand
  # At least 2 cards(At least 1 is hidden from dealer)
  # value
  # blackjack?
  # bust
  attr_accessor :cards
  def initialize (deck)
    @cards = []
    2.times do
      hit(deck)
    end
  end

  def hit(deck)
    card = deck.deal
    @cards << card
  end

  def description
    @cards.map { |card| card.description}.join(" and ")
  end

  def value
    # Long version of inject
    @cards.inject(0) { |total, card| total + card.value}
    # Short hand version of inject
    @cards.map { |card| card.value}.inject(:+)
    # Without inject
    total = 0
    @cards.each do |card|
      total = total + card.value
    end
    return total
  end

  def blackjack?
    if value == 21
      true
    else
      false
    end
  end
end

deck = Deck.new

puts "The dealer starts with a full deck of #{deck.cards.length} cards."
puts
puts

puts "The dealer draws the player two cards from a fresh deck."

player_hand = Hand.new(deck)
puts
puts "The two cards the player recieves: "
puts "#{player_hand.description}"
puts "Card Value: #{player_hand.value}"
if player_hand.value == 21
  puts "YOU HAVE WOND THE GAME"
  exit
end

dealer_hand = Hand.new(deck)
puts
puts "The two cards the dealer recieves: "
puts "#{dealer_hand.description}"
puts "Card Value: #{dealer_hand.value}"
if dealer_hand.value == 21
  puts "DEALER HAS BLACKJACK. YOU LOST THE GAME."
  exit
end

loop do
  puts "Player, do you want another card? (y/n)"
  answer = gets.chomp

  if answer == "n"
    dealer_hand.hit(deck)
    puts
    puts "The cards the DEALER now holds are: "
    puts "#{dealer_hand.description}"
    puts "Combined value: #{dealer_hand.value}"
    puts

    if player_hand.value < 21 && dealer_hand.value < 21
      break
    else
      if player_hand.value == 21 || (player_hand.value < 21 && dealer_hand.value > 21)
        puts "YOU HAVE WON THE GAME"
        break
      else player_hand.value > 21
        puts "YOU HAVE BUSTED AND LOST THE GAME"
        break
      end
    end
  end

  if answer == "y"
    player_hand.hit(deck)
    dealer_hand.hit(deck)
    puts
    puts "The cards the PLAYER now holds are: "
    puts "#{player_hand.description}"
    puts "Combined value: #{player_hand.value}"
    puts
    puts
    puts "The cards the DEALER now holds are: "
    puts "#{dealer_hand.description}"
    puts "Combined value: #{dealer_hand.value}"
    puts

    if player_hand.value < 21 && dealer_hand.value < 21
      break
    else
      if player_hand.value == 21 || (player_hand.value < 21 && dealer_hand.value > 21)
        puts "YOU HAVE WON THE GAME"
        break
      else player_hand.value > 21
        puts "YOU HAVE BUSTED AND LOST THE GAME"
        break
      end
    end
  end
end
