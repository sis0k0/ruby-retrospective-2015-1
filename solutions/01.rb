CURRENCY_TO_BGN = {
  usd: 1.7408,
  eur: 1.9557,
  gbp: 2.6415,
  bgn: 1,
}

PRECISION = 2

def convert_to_bgn(price, currency)
  (price * CURRENCY_TO_BGN[currency]).round PRECISION
end

def compare_prices(first_price, first_currency, second_price, second_currency)
  first_bgn = convert_to_bgn(first_price, first_currency)
  second_bgn = convert_to_bgn(second_price, second_currency)

  first_bgn <=> second_bgn
end