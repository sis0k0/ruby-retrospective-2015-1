def convert_to_bgn(price, currency)
  Price.new(price, currency).to_bgn
end

def compare_prices(first_price, first_currency, second_price, second_currency)
  first = Price.new(first_price, first_currency)
  second = Price.new(second_price, second_currency)

  first <=> second
end

class Price
  BGN_EXCHANGE_RATES = {
    bgn: 1,
    usd: 1.7408,
    eur: 1.9557,
    gbp: 2.6415,
  }

  PRECISION = 2

  def initialize(price, currency)
    @price = price
    @currency = currency
  end

  def to_bgn
    price_bgn = @price * BGN_EXCHANGE_RATES[@currency]
    format(price_bgn)
  end

  def <=>(other_price)
    self.to_bgn <=> other_price.to_bgn
  end

  private

  def format(price)
    price.round PRECISION
  end
end