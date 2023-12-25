require 'set'

#INPUT='test'
INPUT='input'

# read_input
data = File.read(INPUT).split("\n").map do |row|
	p, v = row.split(" @ ")
	[p.split(", ").map(&:to_i), v.split(", ").map(&:to_i)]
end

def collide a, b
	#px1+vx1*t=px2+vx2*t
	#(px1-px2)/(vx2-vx1)=tx
	#(py1-py2)/(vy2-vy1)=ty
	#(py1-py2)*(vx2-vx1)=(px1-px2)*(vy2-vy1)
	py1_py2 = (a.first[1]-b.first[1])
	vx2_vx1 = (b.last[0]-a.last[0])
	px1_px2 = (a.first[0]-b.first[0])
	vy2_vy1 =  (b.last[1]-a.last[1])
	val1 = py1_py2*vx2_vx1
	val2 = px1_px2*vy2_vy1
	if vx2_vx1 == 0 || vy2_vy1 == 0 #|| val1 != val2
		return false
	end
	t = 1.0 * px1_px2 / vx2_vx1
	px = a.first[0] + t * a.last[0]
	py = a.first[1] + t * a.last[1]
	p [t, px, py, a, b]
	t >= 0 && px >= 7 && px <= 27 && py >= 7 && py <= 27
end

def get_cm a
	m_a = 1.0 * a.last[1] / a.last[0]  # vy/vx
	c_a = a.first[1] - m_a * a.first[0]
	[m_a, c_a]
end

if INPUT == 'test'
	AREA_START = 7.0
	AREA_END = 27.0
else
	AREA_START = 200000000000000
	AREA_END = 400000000000000
end

def cross a, b
	# y = c + m*x
	m_a, c_a = get_cm a
	m_b, c_b = get_cm b
	# y = c1 + m1*x
	# y = c2 + m2*x
	return false if m_a == m_b
	#c1 + m1*x = c2+m2*x
	#c1 - c2 / (m2 - m1)
	x = 1.0 * (c_a - c_b) /  (m_b - m_a)
	y = c_a + m_a * x
	#t1 = (x - x0) / vx = x_0 + t_1 * vx_0
	t_a = 1.0 * (x - a.first[0]) / a.last[0]
	t_b = 1.0 * (x - b.first[0]) / b.last[0]
	x >= AREA_START && x <= AREA_END && y >= AREA_START && y<=AREA_END && t_a >= 0 && t_b >= 0

# 19, 13, 30 @ -2, 1, -2
# m=-1/2  # vy/vx
# c = y+m*-x
# c=-6
# 

end


# solve
part1 = data.combination(2).filter{|a,b|cross(a,b)}.length
#p cross(data[0], data[1])
p part1


# Hailstone A: 19, 13, 30 @ -2, 1, -2
# Hailstone B: 18, 19, 22 @ -1, -1, -2
# Hailstones' paths will cross inside the test area (at x=14.333, y=15.333).

# t=2.3335
# 18+2.3335*-1

# h1
# h2
# h3
# hu
# m_hu = vy_hu / vx_hu
# c_hu = py_hu - m_hu * px_hu
# x1 = (c_h1 - c_hu) / (m_hu - m_h1)
# y1 = c_h1 + m_h1 * x
# t11 = (x - x0_h1) / vx_h1
# t1u = (x - x0_hu) / vx_hu

# t11 = t1u > 0
# t11 = ((c_h1 - c_hu) / (m_hu - m_h1) - x0_h1) / vx_h1

# ((c_h1 - c_hu) / (m_hu - m_h1) - x0_h1) / vx_h1  > 0

# ((c_h1 - c_hu) / (m_hu - m_h1) - x0_h1) / vx_h1 = ((c_h1 - c_hu) / (m_hu - m_h1) - x0_hu) / vx_hu
# vx_hu * ((c_h1 - c_hu) / (m_hu - m_h1) - x0_h1) = vx_h1 * ((c_h1 - c_hu) / (m_hu - m_h1) - x0_hu)
# vx_hu * (c_h1 - c_hu) / (m_hu - m_h1) - vx_hu * x0_h1 = vx_h1 * (c_h1 - c_hu) / (m_hu - m_h1) - vx_h1 * x0_hu
# vx_hu * (c_h1 - c_hu) - vx_hu * x0_h1 * (m_hu - m_h1) = vx_h1 * (c_h1 - c_hu) * (m_hu - m_h1) / (m_hu - m_h1) - vx_h1 * x0_hu * (m_hu - m_h1)
# vx_hu * (c_h1 - c_hu) * (m_hu - m_h1) - vx_hu * x0_h1 * (m_hu - m_h1) * (m_hu - m_h1) = vx_h1 * (c_h1 - c_hu) * (m_hu - m_h1) - vx_h1 * x0_hu * (m_hu - m_h1) * (m_hu - m_h1)

# nope
