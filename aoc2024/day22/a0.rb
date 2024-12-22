require 'set'

MODU = 16777216
#INPUT='test2'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map(&:to_i)

def next_secret(value)
  value = ((64 * value) ^ value) % MODU
  value = ((value / 32) ^ value) % MODU
  value = ((2048 * value) ^ value) % MODU
  value
end

def buyer_price_sequence(base, length)
  [base%10] + length.times.map do
    base = next_secret(base)
    base%10
  end
end

def sequence_delta(seq)
  seq.each_cons(2).map {|a, b| b - a}
end

def deltas_to_string(seq)
  seq.map{|v|(v+78).chr}.join
end

# solve
p1 = data.map do |value|
  2000.times do
    value = next_secret(value)
  end
  value
end.sum

p p1

def pick_value_after(seq, subst)
  idx = seq[1].index(subst)
  return 0 if idx.nil?
  seq[0][idx+4] || 0
end

def find_best(seqs)
  r=("E".."W").to_a
  r.product(r,r,r).map do |letters|
    substr = letters.join
    seqs.map do |seq|
      pick_value_after(seq, substr)
    end.sum
  end.max
end

seqs = data.map do |base|
  price_seq = buyer_price_sequence(base, 2000)
  deltas = deltas_to_string(sequence_delta(price_seq))
  [price_seq, deltas]
end
p find_best(seqs)

# 15335183969
# 1696
