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
			@left = nil
			@right = nil
		else
			@type = :node
			@value = nil
			@left = SnailfishNumber.new(tree[0], parent=self)
			@right = SnailfishNumber.new(tree[1], parent=self)
		end
	end
	def eject
		if @type == :value
			return @value
		else
			return [@left.eject, @right.eject]
		end
	end
	def find_first(proc, depth=0)
		#p ["ff", depth, self.to_s]
		return self if proc.call(self, depth)
		if @type == :node
			m = @left.find_first(proc, depth+1)
			return m if !m.nil?
			return @right.find_first(proc, depth+1)
		end
		nil
	end
	def is_simple_pair
		@type == :node && @left.type == :value && @right.type == :value
	end
	def next_right
		curr = self
		while !curr.parent.nil? && curr.parent.right == curr
			curr = curr.parent
		end
		return nil if curr.parent.nil?
		curr = curr.parent.right
		while !curr.left.nil?
			curr = curr.left
		end
		curr
	end
	def next_left
		curr = self
		while !curr.parent.nil? && curr.parent.left == curr
			curr = curr.parent
		end
		return nil if curr.parent.nil?
		curr = curr.parent.left
		while !curr.right.nil?
			curr = curr.right
		end
		curr
	end
	def explode
		raise RuntimeError if @type != :node
		raise RuntimeError if !is_simple_pair
		nr = next_right
		raise RuntimeError if !nr.nil? && nr.type != :value
		nr.value += @right.value if !nr.nil?
		nl = next_left
		raise RuntimeError if !nl.nil? && nl.type != :value
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
			#p ["itr", self.to_s]
			exp = find_first(->(node, depth) { depth == 4 && node.is_simple_pair })
			if !exp.nil?
				#p "exp"
				exp.explode
				next
			end
			spl = find_first(->(node, depth) { node.type == :value && node.value >= 10 })
			if !spl.nil?
				#p "spl"
				spl.split
				next
			end
			break
		end
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
		n = self.parse("[#{num1.to_s},#{num2.to_s}]")
		n.reduce
		n
	end
end

data = data.map{|v|SnailfishNumber.parse(v)}
num = data[0]
data[1..].each do |n|
	num = SnailfishNumber.add(num, n)
	num = SnailfishNumber.parse(num.to_s)
end
p num.magnitude

max_m = 0
data.permutation(2).each do |a,b|
	max_m = [max_m, SnailfishNumber.add(a, b).magnitude].max
end

p max_m
