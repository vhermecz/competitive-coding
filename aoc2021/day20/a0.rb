require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = []
enh, data = File.open(INPUT).read.split("\n\n")
enh = enh.strip
data = data.split("\n").map{|r|r.strip.split("")}

Image = Struct.new(:data, :out)

def debug(image)
	image.data.each do |r|
		puts r.join
	end
end

def grow(image)
	data, out = data
	nw = image.data.first.length + 2
	Image.new(
		[nw.times.map{image.out}] + image.data.map{|r|[image.out]+r[0..-1]+[image.out]} + [nw.times.map{image.out}],
		image.out
	)
end

def shrink(image)
	return image if border_value(image.data).nil?
	return image if border_value(image.data) != image.out
	Image.new(image.data[1..-2].map{|r| r[1..-2]}, image.out)
end

# Return the value of the border
# If the border has a single color it is returned, otherwise nil
def border_value(data)
	h = data.length
	border_values = (data[0] + data[-1] + h.times.map{|y|[data[y][0], data[y][-1]]}).flatten.tally.keys.join
	border_values.length == 1 ? border_values : nil
end

def enhance(image, enh)
	image = grow(grow(image))
	w = image.data.first.length
	h = image.data.length
	data = h.times.map do |y|
		w.times.map do |x|
			val = (-1..1).map do |dy|
				(-1..1).map do |dx|
					image.data[y+dy][x+dx] or image.out rescue image.out
				end
			end.flatten(1).join("").gsub("#", "1").gsub(".", "0").to_i(2)
			enh[val]
		end
	end
	shrink(shrink(Image.new(data, (border_value(data) or '.'))))
end

# solve

image = Image.new(data, ".")
25.times do |i|
	image = enhance(image, enh)
	image = enhance(image, enh)
	p image.data.flatten.tally["#"] if i==0 || i==24
end

# 00:32:49    795 - 5419
# 00:36:35    778 - 17325

# Mistakes:
# - first implementation missed varying default color
# - d[y][x] rescue v  (this does not raise if x is out of bounds)
