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
  class Hand
    SUITS = [:spades, :hearts, :diamonds, :clubs]
    attr_reader :cards

    def initialize(cards)
      @cards = cards
    end

    def size
      @cards.length
    end

    def king_and_queen?(suit)
      includes?(:king, suit) and includes?(:queen, suit)
    end

    private

    def includes?(rank, suit)
      @cards.include? Card.new(rank, suit)
    end
  end

  include Enumerable

  RANKS = [:ace, :king, :queen, :jack, 10, 9, 8, 7, 6, 5, 4, 3, 2]
  SUITS = [:spades, :hearts, :diamonds, :clubs]

  def initialize(deck = default_deck, ranks = RANKS)
    @deck = deck
    @ranks = ranks
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

  def sort
    @deck.sort_by! { |card| [SUITS.index(card.suit), @ranks.index(card.rank)] }
  end

  def to_s
    @deck.map(&:to_s).join("\n")
  end

  def deal(cards)
    hand = cards < self.size ? @deck.take(cards) : @deck
    @deck -= hand
    hand
  end

  def each
    @deck.each { |card| yield card }
  end

  private

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

  class WarHand < Deck::Hand
    def play_card
      @cards.shift
    end

    def allow_face_up?
      self.size <= 3
    end
  end
end

class BeloteDeck < Deck
  RANKS = [:ace, 10, :king, :queen, :jack, 9, 8, 7]
  CARDS_FOR_HAND = 8

  def initialize(deck = default_deck(RANKS))
    super(deck, RANKS)
  end

  def deal
    BeloteHand.new(super CARDS_FOR_HAND)
  end

  class BeloteHand < Deck::Hand
    RANKS = [7, 8, 9, :jack, :queen, :king, 10, :ace]

    def highest_of_suit(suit)
      sorted_cards.select { |card| card.suit == suit }.last
    end

    def belote?
      SUITS.any? { |suit| king_and_queen? suit }
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
      SUITS.any? do |suit|
        sorted_cards.select { |card| card.suit == suit }.
          each_cons(number_of_cons).
          any? { |sequence| consecutive_ranks? sequence }
      end
    end

    def consecutive_ranks?(cards)
      cards.each_cons(2).all? do |first, second|
        RANKS.index(first.rank) == RANKS.index(second.rank) - 1
      end
    end

    def sorted_cards
      @cards.sort_by { |card| [SUITS.index(card.suit), RANKS.index(card.rank)] }
    end

    def carre?(rank)
      @cards.select { |card| card.rank == rank }.count == 4
    end
  end
end

class SixtySixDeck < Deck
  RANKS = [:ace, 10, :king, :queen, :jack, 9]
  CARDS_FOR_HAND = 6

  def initialize(deck = default_deck(RANKS))
    super(deck, RANKS)
  end

  def deal
    SixtySixHand.new(super CARDS_FOR_HAND)
  end

  class SixtySixHand < Deck::Hand
    def twenty?(trump_suit)
      allowed_suits = SUITS - [trump_suit]
      allowed_suits.any? { |suit| king_and_queen? suit }
    end

    def forty?(trump_suit)
      king_and_queen? trump_suit
    end
  end
end