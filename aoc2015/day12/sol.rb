# 19:48:00
# 19:59:40 - initially implemented recursive has_red. buhhh
require 'json'

def has_avoid(data, avoid)
	!avoid.nil? && data.values.map{|v|v.kind_of?(String) && !v.index(avoid).nil?}.any?
end

def sumnum(data, avoid)
	if data.kind_of? Array
		data.map{|v|sumnum(v, avoid)}.sum
	elsif data.kind_of? Hash
		has_avoid(data, avoid) ? 0 : data.values.map{|v|sumnum(v, avoid)}.sum 
	elsif data.kind_of? Integer
		data
	else
		0
	end
end

data = JSON.parse File.open("input").read()
p sumnum data, nil
p sumnum data, "red"
