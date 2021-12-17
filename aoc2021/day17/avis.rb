require 'set'

#test
tx, ty = [20, 30], [-10, -5]
#input
tx, ty = [70, 96], [-179,-124]

MAX_X_SCAN = 1000
MAX_STEP_SCAN = 20000

cnt = [].to_set
cnt2 = 0
(0..MAX_X_SCAN).each do |ivx|
	step = 0
	px = 0
	vx = ivx
	good_steps = [].to_set
	while px <= tx[1] and vx > 0 do
		px += vx
		vx -= vx/vx.abs rescue 0
		step += 1
		good_steps << step if px >= tx[0] && px <= tx[1]
	end
	stuck = px >= tx[0] && px <= tx[1] && vx == 0
	step_range = [good_steps.min, stuck ? nil : good_steps.max]
	next if step_range.first.nil?  # if first.nil? there is no solution
	# if last.nil? within any step we are in the tx range
	(step_range.first..(step_range.last.nil? ? MAX_STEP_SCAN : step_range.last)).each do |step|
		# ty[0] <= ivy*step - 1*step*(step-1)/2 <= ty[1]
		min_ivy = (ty[0] + 1*step*(step-1)/2.0) / step
		max_ivy = (ty[1] + 1*step*(step-1)/2.0) / step
		(min_ivy.ceil..max_ivy.floor).each do |ivy|
			cnt << [ivx, ivy]
		end
	end
end

p "BBox x=#{cnt.map{|p|p[0]}.minmax} y=#{cnt.map{|p|p[1]}.minmax}"
p cnt.length

def visualize(points)
	require 'rmagick'
	include Magick

	minx, maxx = cnt.map{|p|p[0]}.minmax
	miny, maxy = cnt.map{|p|p[1]}.minmax
	minx -= 20
	maxx += 20
	miny -= 20
	maxy += 20
	imgw = maxx-minx
	imgh = maxy-miny

	f = Image.new(imgw, imgh) do |img|
		img.background_color = "white"
	end

	(10..61).each do |x|
		(-100..350).each do |y|
			if x>=-minx and x<maxx and y>=miny and y<maxy
				f.pixel_color(x-minx,imgh-1-(y-miny),"green")
			end
		end
	end
	(minx..maxx).each do |x|
		f.pixel_color(x-minx,imgh-1-(0-miny),"blue")
	end
	(miny..maxy).each do |y|
		f.pixel_color(0-minx,imgh-1-(y-miny),"blue")
	end
	cnt.each do |x,y|
		f.pixel_color(x-minx,imgh-1-(y-miny),"red")
	end
	f.write "debug.png"
	#f.display
end
