require 'set'

# INPUT='test'
INPUT='input'

state = File.read(INPUT).strip.split(" ").map(&:to_i)

def convert(v)
  vs = v.to_s
  vsl = vs.length
  return [1] if v == 0
  return [vs[0...vsl/2].to_i, vs[vsl/2..].to_i] if vsl % 2 == 0
  [v*2024]
end

$cache = Hash.new
def blinky(num, steps)
  return $cache[[num, steps]] if $cache.key?([num, steps])
  return 1 if steps == 0
  $cache[[num, steps]] = convert(num).map do |v1|
    blinky(v1, steps - 1)
  end.sum
end

p state.map{|v|blinky(v, 25)}.sum
p state.map{|v|blinky(v, 75)}.sum
