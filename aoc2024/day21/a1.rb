require 'set'
require 'matrix'

# INPUT='test'
INPUT='input'

class Keypad
  attr_accessor :mapping, :width, :height, :denied_coordinates
  def initialize(mapping, width, height, denied_coordinates)
    @mapping = mapping
    @width = width
    @height = height
    @denied_coordinates = denied_coordinates
  end
end

NUM_MAP = {
  "7" => Vector[0, 0],
  "8" => Vector[0, 1],
  "9" => Vector[0, 2],
  "4" => Vector[1, 0],
  "5" => Vector[1, 1],
  "6" => Vector[1, 2],
  "1" => Vector[2, 0],
  "2" => Vector[2, 1],
  "3" => Vector[2, 2],
  "0" => Vector[3, 1],
  "A" => Vector[3, 2],
}

NUM_KEYPAD = Keypad.new(NUM_MAP, 3, 4, [Vector[3, 0]].to_set)

DIR_MAP = {
  "^" => Vector[0, 1],
  "A" => Vector[0, 2],
  "<" => Vector[1, 0],
  "v" => Vector[1, 1],
  ">" => Vector[1, 2],
}

DIR_VEC2CHAR = {
  Vector[-1, 0] => "^",
  Vector[1, 0] => "v",
  Vector[0, 1] => ">",
  Vector[0, -1] => "<",
}

DIR_KEYPAD = Keypad.new(DIR_MAP, 3, 2, [Vector[0, 0]].to_set)


# read_input
data = File.read(INPUT).split("\n").map do |line|
  line.split("")
end

# solve
p data

# num   dir
# 789    ^A
# 456   <v>
# 123
#  0A
# dir(me) => dir(bot) => dir(bot) => num(bot)

# <vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A
# v<<A>>^A<A>AvA<^AA>A<vAAA>^A
# <A^A>^^AvvvA
# 029A

def motion(num, negative, positive)
  char = if num < 0
           negative
         else
           positive
         end
  Array.new(num.abs, char)
end

def check_not_over_denied(pos_start, motion, denied_coordinates)
  pos_curr = pos_start
  motion.each do |step|
    pos_curr += step
    return false if denied_coordinates.include? pos_curr
  end
  true
end

def all_motion_variants(button_start, button_end, keypad)
  pos_start = keypad.mapping[button_start]
  pos_end = keypad.mapping[button_end]
  delta = pos_end - pos_start
  presses = []
  presses += Array.new(delta[0].abs, Vector[delta[0] <=> 0, 0])
  presses += Array.new(delta[1].abs, Vector[0, delta[1] <=> 0])
  res = presses.permutation.uniq.filter do |seq|
    check_not_over_denied(pos_start, seq, keypad.denied_coordinates)
  end.map do |seq|
    seq.map do |step|
      DIR_VEC2CHAR[step]
    end + ["A"]
  end
  res
end

def encode_variants(string, keypad)
  #p ["encode_variants", string]
  sections = []
  curr_button = "A"
  string.each do |next_button|
    sections << all_motion_variants(curr_button, next_button, keypad)
    curr_button = next_button
  end
  res = sections.shift.product(*sections).map{|v|v.flatten}
  #p ["With", res]
  res
end

def encode_multivariants(multistring, keypad)
  result = []
  multistring.each do |string|
    result += encode_variants(string, keypad)
  end
  minlen = result.map{|v|v.length}.min
  result.filter{|v|v.length==minlen}
end

def encode(string, keypad)
  result = []
  start_pos = keypad.mapping["A"]
  string.each do |button|
    next_pos = keypad.mapping[button]
    delta = next_pos - start_pos
    result += motion(delta[1], "<", ">") +
      motion(delta[0], "^", "v") +
      ["A"]
    start_pos = next_pos
  end
  result
end

def encode_all_layers(v, debug=false)
  p [v.length, v] if debug
  v = encode(v, NUM_KEYPAD)
  p [v.length, v] if debug
  v = encode(v, DIR_KEYPAD)
  p [v.length, v] if debug
  v = encode(v, DIR_KEYPAD)
  p [v.length, v] if debug
  v
end

def encode_all_layers_variants(vs, debug=false)
  vs = encode_multivariants(vs, NUM_KEYPAD)
  vs = encode_multivariants(vs, DIR_KEYPAD)
  vs = encode_multivariants(vs, DIR_KEYPAD)
  shortest_length = vs.map{|v|v.length}.min
end

p1 = data.map do |value|
  code = value.join("")[..-1].to_i
  length = encode_all_layers_variants([value])
  p [value, code, length]
  length * code
end.sum

p p1