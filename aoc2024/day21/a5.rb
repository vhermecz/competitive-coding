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

# num   dir
# 789    ^A
# 456   <v>
# 123
#  0A

# <vA<AA>>^AvAA<^A>A<v<A>>^AvA^A<vA>^A<v<A>^A>AAvA^A<v<A>A>^AAAvA<^A>A 68
#   v <<   A >>  ^ A   <   A > A  v  A   <  ^ AA > A   < v  AAA >  ^ A 28
#          <       A       ^   A     >   0     ^^   A        vvv      A 12
#                  0           2                   9                 A  4

def has_denied(pos_start, motion, denied_coordinates)
  pos_curr = pos_start
  motion.map do |step|
    pos_curr += step
  end.any? do |pos_curr|
    denied_coordinates.include? pos_curr
  end
end

def all_motion_variants(button_start, button_end, keypad)
  pos_start = keypad.mapping[button_start]
  pos_end = keypad.mapping[button_end]
  delta = pos_end - pos_start
  (
    Array.new(delta[0].abs, Vector[delta[0] <=> 0, 0]) + # vertical steps
      Array.new(delta[1].abs, Vector[0, delta[1] <=> 0])  # horizontal steps
  ).permutation.uniq.filter do |seq|
    !has_denied(pos_start, seq, keypad.denied_coordinates)
  end.map do |seq|
    seq.map do |step|
      DIR_VEC2CHAR[step]
    end + ["A"]
  end
end

def encode_variants(string, keypad)
  curr_button = "A"
  string.each.map do |next_button|
    res = all_motion_variants(curr_button, next_button, keypad)
    curr_button = next_button
    res
  end
end

class SolverCached
  def initialize(num_keypad_depth)
    @num_keypad_depth = num_keypad_depth
    @memo = {}
  end
  def solve_a_section(section, depth)
    return section.length if depth == 0
    @memo[[section, depth]] ||=
      begin
        vss = encode_variants(section, depth == @num_keypad_depth ? NUM_KEYPAD : DIR_KEYPAD)
        vss.map do |vs|
          vs.map do |v|
            split_to_sections(v).map do |v0|
              solve_a_section(v0, depth-1)
            end.sum
          end.min
        end.sum
      end
  end
end

def split_to_sections(v)
  v.join("").scan(/.*?A/).map do |section|
    section.split("")
  end
end

def solve(data, steps)
  s = SolverCached.new(steps)
  data.map do |value|
    code = value.join("")[..-1].to_i
    length = s.solve_a_section(value, steps)
    length * code
  end.sum
end

p solve(data, 3)
p solve(data, 26)
