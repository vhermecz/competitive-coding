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

def sequence_delta(seq)
  seq.each_cons(2).map {|a, b| b - a}
end

def deltas_to_string(seq)
  seq.map{|v|(v+78).chr}.join
end

class MonkeyAgent
  def initialize(secret_seq)
    price_seq = secret_seq.map{|v|v%10}
    @price_seq = price_seq
    @deltas = deltas_to_string(sequence_delta(price_seq))
  end
  def pick_price_after(change)
    idx = @deltas.index(change)
    return 0 if idx.nil?
    @price_seq[idx+4] || 0
  end
end

def find_best(sequences)
  r=("E".."W").to_a
  r.product(r,r,r).map do |letters|
    substr = letters.join
    sequences.map do |seq|
      seq.pick_price_after(substr)
    end.sum
  end.max
end

secret_sequences = data.map{|v|secret_sequence(v, 2000)}
p secret_sequences.map(&:last).sum
p find_best(secret_sequences.map{|s|MonkeyAgent.new(s)})
