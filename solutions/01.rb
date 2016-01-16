BGN_EXCHANGE_RATES = {
  bgn: 1,
  usd: 1.7408,
  eur: 1.9557,
  gbp: 2.6415,
}

PRECISION = 2

def convert_to_bgn(price, currency)
  price_bgn = price * BGN_EXCHANGE_RATES[currency]
  price_bgn.round PRECISION
end

def compare_prices(first_price, first_currency, second_price, second_currency)
  first_price_bgn = convert_to_bgn(first_price, first_currency)
  second_price_bgn = convert_to_bgn(second_price, second_currency)

  first_price_bgn <=> second_price_bgn
end