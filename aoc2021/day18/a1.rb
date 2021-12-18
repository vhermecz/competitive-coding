require 'set'

#INPUT='test'
INPUT='input'

data = File.open( INPUT ).map(&:strip)

class SnailfishNumber
	attr_accessor :type, :value, :left, :right, :parent
	def initialize(tree, parent=nil)
		@parent = parent
		if tree.kind_of? Integer
			@type = :value
			@value = tree
		else
			raise RuntimeError unless tree.length == 2
			@type = :node
			@left = SnailfishNumber.new(tree[0], parent=self)
			@right = SnailfishNumber.new(tree[1], parent=self)
		end
	end
	def eject
		return @value if @type == :value
		[@left.eject, @right.eject]
	end
	def find_first(proc, depth=0)
		proc.call(self, depth) && self || 
		  @left&.find_first(proc, depth+1) ||
		  @right&.find_first(proc, depth+1)
	end
	def is_simple_pair
		@type == :node &&
		  @left.type == :value &&
		  @right.type == :value
	end
	def next_right
		curr = self
		curr = curr.parent while !curr.parent.nil? && curr.parent.right == curr
		return nil if curr.parent.nil?
		curr = curr.parent.right
		curr = curr.left while !curr.left.nil?
		curr
	end
	def next_left
		curr = self
		curr = curr.parent while !curr.parent.nil? && curr.parent.left == curr
		return nil if curr.parent.nil?
		curr = curr.parent.left
		curr = curr.right while !curr.right.nil?
		curr
	end
	def explode
		raise RuntimeError unless @type == :node
		raise RuntimeError unless is_simple_pair
		nr = next_right
		raise RuntimeError unless nr.nil? || nr.type == :value
		nr.value += @right.value if !nr.nil?
		nl = next_left
		raise RuntimeError unless nl.nil? || nl.type == :value
		nl.value += @left.value if !nl.nil?
		@type = :value
		@value = 0
		@left = nil
		@right = nil
	end
	def split
		raise RuntimeError if @type != :value
		@type = :node
		v = @value / 2.0
		@left = SnailfishNumber.new(v.floor, parent=self)
		@right = SnailfishNumber.new(v.ceil, parent=self)
		@value = nil
	end
	def reduce
		while true
			exp = find_first(->(node, depth) { depth == 4 && node.is_simple_pair })
			if !exp.nil?
				exp.explode
				next
			end
			spl = find_first(->(node, depth) { node.type == :value && node.value >= 10 })
			if !spl.nil?
				spl.split
				next
			end
			break
		end
		self
	end
	def magnitude
		return @value if @type == :value
		@left.magnitude*3 + @right.magnitude*2
	end
	def to_s
		eject.to_s.gsub(" ", "")
	end
	def self.parse(str)
		self.new(eval(str))
	end
	def self.add(num1, num2)
		self.parse("[#{num1.to_s},#{num2.to_s}]").reduce
	end
end

data = data.map{|v|SnailfishNumber.parse(v)}
num = data[0]
data[1..].each do |n|
	num = SnailfishNumber.add(num, n)
end
p num.magnitude

max_m = 0
data.permutation(2).each do |a,b|
	max_m = [max_m, SnailfishNumber.add(a, b).magnitude].max
end
p max_m

# no reading (was 10 minutes)
# @38:19 - split does not add parent is the only error
# @1:17:30 - finally got it
#  best of a bug, ate almost 40 minutes :P lol
# @1:20:50 done

# Errors:
#   Keyword arg syntax
#     def a(depth=4)
#       a(depth=depth+1)
#       # NOTE: This is not keyword arg syntax, this is increasing a local
#     end
#   Forgot to add parent in split and never valiated that it works fine.
#     After all, it is so simple
#     Cost me 40 minutes
