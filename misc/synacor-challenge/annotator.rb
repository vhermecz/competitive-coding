# Format:
#   # Comment
#   0xNNNN: CATEGORY NAME/DESCRIPTION
#
# Items:
#   0xNNNN - item address, we will search for
#   CATEGORY - item category, if _ will be skipped
#   NAME/DESCRIPTION - will be printed with CATEGORY
#
# RULES define what and how to annotate
# NOTE: Does not rewrite changes yet

def load_annotaitons fname
	File.read(fname).split("\n").each_with_index.filter do |row, idx|
		# skip comment, empty lines
		!row.start_with?("#") && !row.empty?
	end.map do |row, idx|
		# splint into fields, filter invalid rows
		addr, desc = row.split ": ", 2
		type, name = (desc || "").split " ", 2
		fields = [addr, type, name]
		puts "WARNING: Invalid row ##{idx+1} with value #{row[..10]}..." if addr.nil? || type.nil?
		fields = nil if fields.any?(&:nil?)
		fields
	end.compact.map do |addr, type, name|
		[addr, [type, name]]
	end.to_h
end

RULES = [
	[/CALL (0x[0-9a-f]{4})$/, "       # "],
	[/SET r[0-7] (0x[0-9a-f]{4})$/, "     # "],
	[/(0x[0-9a-f]{4}) +DATA$/, "  "],
]

def annotator row, annotations
	RULES.each do |regex, appendstr|
		match = row.match(regex)
		if !match.nil? && !annotations[match[1]].nil? && annotations[match[1]].first != "_"
			row += appendstr + annotations[match[1]].join(" ")
		end
	end
	row
end

def annotate_file fname, annotations
	rows = File.read(fname).split("\n")
	rows = rows.map{|row| annotator(row, annotations)}
	File.write(fname, rows.join("\n") + "\n")
end

def main
	annotations = load_annotaitons "annotations.txt"
	annotate_file "cave_adventure.source.txt", annotations
end

if __FILE__ == $PROGRAM_NAME
	main()
end
