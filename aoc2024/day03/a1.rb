require 'set'

# INPUT='test'
INPUT='input'

data = File.read(INPUT)

# solve
def solve(data, always_on=true)
  gate = 1
  data.scan(/mul\((\d+),(\d+)\)|(don't)|(do)/).map do |a, b, dont, _|
    if a.nil?
      gate = (dont.nil? or always_on) ? 1 : 0
      0
    else
      a.to_i * b.to_i * gate
    end
  end.sum
end

p solve(data, true)
p solve(data, false)

# 167090022
# 89823704
