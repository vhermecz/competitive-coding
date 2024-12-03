require 'set'

# INPUT='test'
INPUT='input'

data = File.read(INPUT)

# solve
matches = data.scan(/mul\((\d+),(\d+)\)/)
p1 = matches.map do |match|
  a, b = match.map(&:to_i)
  a * b
end.sum

status = true
matches = data.scan(/mul\((\d+),(\d+)\)|(don't)|(do)/)
p2 = matches.map do |match|
  res = if match[0].nil?
          0
        else
          match[0].to_i * match[1].to_i
        end
  status = true unless match[3].nil?
  status = false unless match[2].nil?
  res = 0 unless status
  res
end.sum
p p1
p p2

# 167090022
# 89823704
