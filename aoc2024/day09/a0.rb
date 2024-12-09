require 'set'

# INPUT='test'
INPUT='input'

data = File.read(INPUT).strip().split("").map(&:to_i)

def generate_disk(data)
  disk = []
  is_file = true
  file_idx = 0
  data.each do |len|
    len.times do
      disk << file_idx if is_file
      disk << -1 unless is_file
    end
    file_idx += 1 if is_file
    is_file = !is_file
  end
  disk
end

def compress(disk)
  scan_left = 0
  scan_right = disk.length - 1
  while scan_left < scan_right
    scan_left += 1 while disk[scan_left] != -1 && scan_left < scan_right
    scan_right -=1 while disk[scan_right] == -1 && scan_right > scan_left
    disk[scan_left] = disk[scan_right] if scan_left < scan_right
    disk[scan_right] = -1 if scan_left < scan_right
  end
  disk
end

def checksum(disk)
  disk.take_while{|x| x > -1}.each_with_index.map do |x, i|
    x*i
  end.sum
end

def generate_disk2(data)
  disk = []
  is_file = true
  file_idx = 0
  data.each do |len|
    disk << [is_file ? file_idx : -1, len]
    file_idx += 1 if is_file
    is_file = !is_file
  end
  disk
end

def compress2(disk)
  scan_right = disk.length - 1
  while scan_right > 0
    scan_right -= 1 while scan_right > 0 && disk[scan_right].first == -1
    scan_left = 0
    scan_left += 1 while not(scan_left >= scan_right || disk[scan_left].first == -1 && disk[scan_left].last >= disk[scan_right].last)
    # p scan_right
    if scan_left < scan_right
      if disk[scan_left].last == disk[scan_right].last
        disk[scan_left][0] = disk[scan_right].first
        disk[scan_right][0] = -1
      else
        disk.insert(scan_left, disk[scan_right].dup)
        scan_left += 1
        scan_right += 1
        disk[scan_left][1] -= disk[scan_right][1]
        disk[scan_right][0] = -1
      end
      # actually, no need to merge around scan_right
      merge_start = scan_right
      merge_len = 1
      merge_size = disk[scan_right].last
      if scan_right > 0 && disk[scan_right-1].first == -1
        merge_start -= 1
        merge_len += 1
        merge_size += disk[scan_right-1].last
      end
      if scan_right + 1 < disk.length && disk[scan_right+1].first == -1
        merge_len += 1
        merge_size += disk[scan_right+1].last
      end
      # p [merge_start, merge_len, merge_size, disk[merge_start...merge_start+merge_len]]
      if merge_len > 1
        disk[merge_start] = [-1, merge_size]
        disk.slice!(merge_start + 1, merge_len - 1)
        scan_right = merge_start
      end
    else
      scan_right -= 1
    end
  end
  disk
end

def encode2(disk)
  disk.map do |item|
    item.last.times.map do
      item.first
    end
  end.flatten
end

def checksum2(disk)
  disk.each_with_index.map do |x, i|
    x>=0?x*i:0
  end.sum
end

p checksum(compress(generate_disk(data)))
p checksum2(encode2(compress2(generate_disk2(data))))

# 6341711060162 pt1
# 6381557825368 bad
