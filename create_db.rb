require 'h3'
require 'json'
require 'lmdb'

$env = LMDB.new('db', 
  :nosync => true, :nometasync => true, 
  :writemap => true, :mapasync => true, 
  :mapsize => 5000 * 1024 * 1024 * 1024
)
$db = $env.database

start_time = Time.now
count = 0
while gets
  f = JSON.parse($_)
  h3 = H3.from_string(f['properties']['h3'])
  pop = f['properties']['population'].to_i
  H3.resolution(h3).downto(0) {|resolution|
    h3h = [H3.parent(h3, resolution)].pack('Q>')
    poph = $db[h3h]
    $db[h3h] = [poph.nil? ? pop : poph.unpack('Q>').first + pop].pack('Q>')
  }
  count += 1
  if count % 1000 == 0
    print "#{count} #{(count / (Time.now - start_time)).round}r/s\r"
    $env.sync
  end
end

