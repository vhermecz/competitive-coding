p eval(File.read('input').gsub(/(\w+):([^\n]+)/, 'def \1()\2 end') + "root")