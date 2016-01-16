class Card
  attr_reader :rank, :suit

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def ==(other)
    self.to_s == other.to_s
  end

  def to_s
    "#{@rank.to_s.capitalize} of #{@suit.capitalize}"
  end
end

class Deck
  include Enumerable

  RANKS = [2, 3, 4, 5, 6, 7, 8, 9, 10, :jack, :queen, :king, :ace]
  SUITS = [:spades, :hearts, :diamonds, :clubs]

  def initialize(deck = default_deck)
    @deck = deck
  end

  def size
    @deck.length
  end

  def draw_top_card
    @deck.shift
  end

  def draw_bottom_card
    @deck.pop
  end

  def top_card
    @deck.first
  end

  def bottom_card
    @deck.last
  end

  def shuffle
    @deck.shuffle!
  end

  def sort(ranks = RANKS)
    @deck.sort! do |a, b|
      comp = SUITS.index(a.suit) <=> SUITS.index(b.suit)
      comp.zero? ? (ranks.index(b.rank) <=> ranks.index(a.rank)) : comp
    end
  end

  def to_s
    @deck.each { |card| card.to_s }
  end

  def deal(cards)
    hand = cards < self.size ? @deck.take(cards) : @deck
    @deck -= hand
    hand
  end

  private
  def each
    @deck.each { |card| yield card }
  end

  def default_deck(ranks = RANKS)
    ranks.collect_concat { |rank|
      SUITS.map { |suit| Card.new(rank, suit) }
    }
  end
end

class WarDeck < Deck
  CARDS_FOR_HAND = 26

  def deal
    WarHand.new(super CARDS_FOR_HAND)
  end
end

class BeloteDeck < Deck
  RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]
  CARDS_FOR_HAND = 8

  def initialize(deck = default_deck(RANKS))
    super(deck)
  end

  def deal
    BeloteHand.new(super CARDS_FOR_HAND)
  end

  def sort
    super(RANKS)
  end
end

class SixtySixDeck < Deck
  RANKS = [9, :jack, :queen, :king, 10, :ace]
  CARDS_FOR_HAND = 6

  def initialize(deck = default_deck(RANKS))
    super(deck)
  end

  def deal
    SixtySixHand.new(super CARDS_FOR_HAND)
  end

  def sort
    super(RANKS)
  end
end

class Hand
  SUITS = [:spades, :hearts, :diamonds, :clubs]
  attr_reader :cards

  def initialize(cards)
    @cards = cards
  end

  def size
    @cards.length
  end
end

class WarHand < Hand
  def play_card
    @cards.shift
  end

  def allow_face_up?
    self.size <= 3
  end
end

class BeloteHand < Hand
  RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]

  def highest_of_suit(suit)
    @cards.select { |card| card.suit == suit }.
      sort { |a, b| RANKS.index(a.rank) <=> RANKS.index(b.rank) }.
      last
  end

  def belote?
    split_by_suit(@cards).
      map { |suit| suit.include? :queen and suit.include? :king }.
      any?
  end

  def tierce?
    consecutive? 3
  end

  def quarte?
    consecutive? 4
  end

  def quint?
    consecutive? 5
  end

  def carre_of_jacks?
    carre?(:jack)
  end

  def carre_of_nines?
    carre?(9)
  end

  def carre_of_aces?
    carre?(:ace)
  end

  private
  def consecutive?(number_of_cons)
    sorted_cards = sort(@cards)

    ranks = split_by_suit(sorted_cards).
      map { |group| group.map { |rank| RANKS.index(rank) } }

    ranks.map do |suit|
      suit.each_cons(number_of_cons).
      map { |arr| consecutive_numbers?(arr) }.
      any?
    end.
    any?
  end

  def consecutive_numbers?(arr)
    arr.each_cons(2).all? { |a, b| a == b + 1 }
  end

  def split_by_suit(cards)
    cards.group_by { |card| card.suit }.
    map { |group| group.last }.
    map { |group| group.map { |card| card.rank } }
  end

  def sort(cards)
    cards.sort! do |a, b|
      sort = SUITS.index(a.suit) <=> SUITS.index(b.suit)
      sort.zero? ? (RANKS.index(b.rank) <=> RANKS.index(a.rank)) : sort
    end
  end

  def carre?(rank)
    @cards.select { |card| card.rank == rank }.count == 4
  end
end

class SixtySixHand < Hand
  def twenty?(trump_suit)
    @cards.select { |card| card.suit != trump_suit }.
      group_by { |card| card.suit }.
      map { |group| group.last }.
      map { |suit| suit.map! { |card| card.rank } }.
      map { |suit| suit.include? :queen and suit.include? :king }.
      any?
  end

  def forty?(trump_suit)
    trumps = @cards.select { |card| card.suit == trump_suit }.
      map { |card| card.rank }
    trumps.include? :queen and trumps.include? :king
  end
end