require "matrix"
require "set"

#INPUT='test'
INPUT='input'

class Hail
	attr_reader :p0, :v
	def initialize(p0, v)
		@p0 = p0
		@v = v
	end
end

# read_input
storm = File.read(INPUT).split("\n").map do |row|
	p, v = row.split(" @ ")
	p = p.split(", ").map(&:to_i)
	v = v.split(", ").map(&:to_i)
	Hail.new(Vector.[](*p), Vector.[](*v))
end

=begin

p0 + t * v0 = pi + t * vi
p0 - pi = (vi - v0) * t
(p0 - pi) / (vi - v0) = t

(p0x - pix) / (vix - v0x) = (p0y - piy) / (viy - v0y)
# t should be natural number (integer + >=0)

=end

def solver_2dim(storm, dim0, dim1)
	Enumerator.new do |res|
		(-1000..1000).each do |vx|
			(-1000..1000).each do |vy|
				# first hail
				h0 = storm[0]
				#(p0x - pix) / (vix - v0x) = (p0y - piy) / (viy - v0y)
				d0vx = h0.v[dim0] - vx
				d0vy = h0.v[dim1] - vy
				next if d0vx ==0 || d0vy == 0
				#(p0x - pix) / d0vx = (p0y - piy) / d0vy
				#(p0x - h0.p[0])*d0vy = (p0y - h0.p[1])*d0vx
				#p0x*d0vy - h0.p[0]*d0vy = p0y*d0vx - h0.p[1]*d0vx
				#p0x = (p0y*d0vx - h0.p[1]*d0vx)/d0vy + h0.p[0]
				# second hail
				h1 = storm[1]
				d1vx = h1.v[dim0] - vx
				d1vy = h1.v[dim1] - vy
				next if d1vx ==0 || d1vy == 0
				# p0x = (p0y*d0vx - h0.p[1]*d0vx)/d0vy + h0.p[0]
				# p0x = (p0y*d1vx - h1.p[1]*d1vx)/d1vy + h1.p[0]
				# (p0y*d0vx - h0.p[1]*d0vx)/d0vy + h0.p[0] = (p0y*d1vx - h1.p[1]*d1vx)/d1vy + h1.p[0]
				# (p0y*d0vx - h0.p[1]*d0vx)*d1vy + h0.p[0]*d0vy*d1vy = (p0y*d1vx - h1.p[1]*d1vx)*d0vy + h1.p[0]*d0vy*d1vy
				# p0y*d0vx*d1vy - h0.p[1]*d0vx*d1vy + h0.p[0]*d0vy*d1vy = p0y*d1vx*d0vy - h1.p[1]*d1vx*d0vy + h1.p[0]*d0vy*d1vy
				# p0y*(d0vx*d1vy - d1vx*d0vy) = - h1.p[1]*d1vx*d0vy + h1.p[0]*d0vy*d1vy + h0.p[1]*d0vx*d1vy - h0.p[0]*d0vy*d1vy
				nom = - h1.p0[dim1]*d1vx*d0vy + h1.p0[dim0]*d0vy*d1vy + h0.p0[dim1]*d0vx*d1vy - h0.p0[dim0]*d0vy*d1vy
				denom = (d0vx*d1vy - d1vx*d0vy)
				next if denom == 0
				next if nom % denom != 0
				p0y = nom / denom
				next if (p0y*d0vx - h0.p0[dim1]*d0vx) % d0vy != 0
				p0x = (p0y*d0vx - h0.p0[dim1]*d0vx)/d0vy + h0.p0[dim0]
				res << [p0x, p0y, vx, vy]
			end
		end
	end
end

def validate storm, rock
	storm.each_with_index.all? do |hail, idx|
		ts = [0,1,2].map do |dim|
			# p0 + t * v0 = pi + t * vi
			# p0 - pi / (vi - v0) = t
			dp = rock.p0[dim] - hail.p0[dim]
			dnv = hail.v[dim] - rock.v[dim]
			# have to allow if they are same pos same velocity
			dnv != 0 && dp % dnv == 0 && dp / dnv || dnv == 0 && dp == 0 && nil
		end.compact.uniq
		ts.length == 1 && ts.first != false
	end
end

def solver storm
	Enumerator.new do |res|
		xys = solver_2dim(storm, 0, 1)
		xzs_by_vx = solver_2dim(storm, 0, 2).group_by{|v|v[2]}
		yzs_by_vy = solver_2dim(storm, 1, 2).group_by{|v|v[2]}

		xys.each do |v1p0x, v1p0y, v1vx, v1vy|
			(xzs_by_vx[v1vx] || []).each do |v2p0x, v2p0z, v2vx, v2vz|
				next if v1p0x != v2p0x
				(yzs_by_vy[v1vy] || []).each do |v3p0y, v3p0z, v3vy, v3vz|
					next if v1p0y != v3p0y
					next if v2p0z != v3p0z
					next if v2vz != v3vz
					rp0 = Vector.[](v1p0x, v1p0y, v2p0z)
					rv = Vector.[](v1vx, v1vy, v2vz)
					rock = Hail.new(rp0, rv)
					next if !validate(storm, rock)
					res << rock
				end
			end
		end
	end
end

solver(storm).each do |rock|
	p rock
	p rock.p0.sum
end

# (344525619959965, 437880958119624, 242720827369528) (-99, -269, 81)
# 1025127405449117