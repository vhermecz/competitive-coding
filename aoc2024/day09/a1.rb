require 'set'

# INPUT='test'
INPUT='input'

data = File.read(INPUT).strip().split("").map(&:to_i)

def generate_disk_bitmap(data)
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

def compress_bitmap(disk)
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

def checksum_bitmap(disk)
  disk.each_with_index.map do |x, i|
    x>=0?x*i:0
  end.sum
end

def generate_disk_rle(data)
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

def compress_rle(disk)
  scan_right = disk.length - 1
  while scan_right > 0
    scan_right -= 1 while scan_right > 0 && disk[scan_right].first == -1
    scan_left = 0
    scan_left += 1 while scan_left < scan_right && (disk[scan_left].first != -1 || disk[scan_left].last < disk[scan_right].last)
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
    else
      scan_right -= 1
    end
  end
  disk
end

def encode_rle2bitmap(disk)
  disk.map do |item|
    item.last.times.map do
      item.first
    end
  end.flatten
end

p checksum_bitmap(compress_bitmap(generate_disk_bitmap(data)))
p checksum_bitmap(encode_rle2bitmap(compress_rle(generate_disk_rle(data))))

# 6341711060162
# 6377400869326
