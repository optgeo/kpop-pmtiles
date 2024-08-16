require 'h3'
require 'json'
require 'lmdb'

$db = LMDB.new('db', :mapsize => 1000 * 1024 * 1024 * 1024).database

count = 0
while gets
  f = JSON.parse($_)
  h3 = H3.from_string(f['properties']['h3'])
  pop = f['properties']['population'].to_i
  H3.resolution(h3).downto(0) {|resolution|
    h3h = H3.to_string(H3.parent(h3, resolution))
    poph = $db[h3h].to_i + pop
    $db[h3h] = poph.to_s
  }
  count += 1
  print "#{count}\r" if count % 1000 == 0
end

