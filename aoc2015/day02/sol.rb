data = File.read('input').split("\n").map{|row|row.strip.split("x").map(&:to_i).sort}
p data.map{|l,w,h|3*l*w + 2*w*h + 2*h*l}.sum
p data.map{|l,w,h|2*l + 2*w + l*w*h}.sum
