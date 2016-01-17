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

  def each
    previous = @first
    current = @second
    counter = 0

    while counter < @count
      yield previous
      current, previous = current + previous, current
      counter += 1
    end
  end
end

class RationalSequence
  include Enumerable

  def initialize(count = Float::INFINITY)
    @count = count
  end

  def generate_next_number(n, d)
    if n % 2 == d % 2
      n += 1
      d -= 1 unless d == 1
    else
      d += 1
      n -= 1 unless n == 1
    end

    number = Rational(n, d)

    if number.numerator == n && number.denominator == d
      number
    else
      generate_next_number(n, d)
    end
  end

  def each
    n = 1
    d = 1
    counter = 0

    if @count > 0
      yield Rational(n, d)
      counter += 1
    end

    while counter < @count
      number = generate_next_number(n, d)
      yield number

      n = number.numerator
      d = number.denominator
      counter += 1
    end
  end
end

class PrimeSequence
  include Enumerable

  def initialize(count)
    @count = count
  end

  def each
    number = 2 # two is the first prime number
    counter = 0

    while counter < @count
      if number.prime?
        yield number
        counter += 1
      end
      number += 1
    end
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
    rational_numbers = RationalSequence.new
    sum = 0

    rational_numbers.take_while do |i|
      sum += i
      sum <= nth_fibonacci_number
    end
  end
end