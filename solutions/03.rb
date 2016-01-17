class Integer
  def prime?
    return false if self == 1
    (2..self / 2).all? { |i| self % i != 0 }
  end
end

class FibonacciSequence
  include Enumerable

  def initialize(count, first_two_members = {first: 1, second: 1})
    @count = count
    @first = first_two_members[:first]
    @second = first_two_members[:second]
  end

  def each(&block)
    enum_for(:sequence).
      lazy.
      take(@count).
      each(&block)
  end

  private

  def sequence
    previous = @first
    current = @second

    loop do
      yield previous
      current, previous = current + previous, current
    end
  end
end

class RationalSequence
  include Enumerable

  def initialize(count)
    @count = count
  end

  def each(&block)
    enum_for(:sequence).
      lazy.
      take(@count).
      each(&block)
  end

  private

  def sequence
    numerator = 1
    denominator = 1

    loop do
      yield Rational(numerator, denominator)
      numerator, denominator = next_pair(numerator, denominator)
    end
  end

  def next_pair(numerator, denominator)
    if numerator % 2 == denominator % 2
      numerator += 1
      denominator -= 1 unless denominator == 1
    else
      denominator += 1
      numerator -= 1 unless numerator == 1
    end

    numerator.gcd(denominator) == 1 ? [numerator, denominator] : next_pair(numerator, denominator)
  end
end

class PrimeSequence
  include Enumerable

  def initialize(count)
    @count = count
  end

  def each(&block)
    enum_for(:sequence).
      lazy.
      take(@count).
      each(&block)
  end

  private

  def sequence
    1.upto(Float::INFINITY).each { |n| yield n if n.prime? }
  end
end

module DrunkenMathematician
  module_function

  def meaningless(n)
    sequence =  RationalSequence.new(n)
    primeish, non_primeish = sequence.partition { |n| n.numerator.prime? or n.denominator.prime? }

    primeish.reduce(1, :*) / non_primeish.reduce(1, :*)
  end

  def aimless(n)
    PrimeSequence.new(n).
      each_slice(2).
      map { |numerator, denominator| Rational(numerator, denominator || 1) }.
      reduce(:+)
  end

  def worthless(n)
    nth_fibonacci_number = FibonacciSequence.new(n).to_a.last
    rational_numbers = RationalSequence.new(nth_fibonacci_number)
    sum = 0

    rational_numbers.take_while do |i|
      sum += i
      sum <= nth_fibonacci_number
    end
  end
end