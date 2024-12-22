require 'set'

MODULUS = 16777216
# INPUT='test2'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map(&:to_i)

def next_secret(value)
  value = ((64 * value) ^ value) % MODULUS
  value = ((value / 32) ^ value) % MODULUS
  ((2048 * value) ^ value) % MODULUS
end

def secret_sequence(base, length)
  [base] + length.times.map do
    base = next_secret(base)
  end
end

def first_price_map_from_secret_seq(secret_seq)
  price_seq = secret_seq.map{|v|v%10}
  sequence_delta = price_seq.each_cons(2).map {|a, b| b - a}
  deltas_string = sequence_delta.map{|v|(v+78).chr}.join
  (deltas_string.length-4+1).times.map do |i|
    [deltas_string[i...i+4], price_seq[i+4]]
  end.reverse.to_h
end

def find_best(price_maps)
  price_sets = price_maps.map{|pm|pm.keys}
  valid_prices = price_sets.reduce(Set.new) { |acc, set| acc.merge(set) }
  valid_prices.map do |substr|
    price_maps.map do |price_map|
      price_map[substr] || 0
    end.sum
  end.max
end

secret_sequences = data.map{|v|secret_sequence(v, 2000)}
p secret_sequences.map(&:last).sum
p find_best(secret_sequences.map{|s|first_price_map_from_secret_seq(s)})
