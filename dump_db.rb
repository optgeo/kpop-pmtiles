require 'lmdb'
require 'json'
require 'h3'

LAYER = 'kpop'
MINZOOMS = [0, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]
MAXZOOMS = [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]

$db = LMDB.new('db', :mapsize => 1000 * 1024 * 1024 * 1024).database

$db.each {|h3s, pops|
  h3 = H3.from_string(h3s)
  pop = pops.to_i
  resolution = H3.resolution(h3)
  f = {
    :type => 'Feature',
    :geometry => JSON.parse(H3.coordinates_to_geo_json([H3.to_boundary(h3)])),
    :properties => { :pop => pop, :h3 => h3s },
    :tippecanoe => {
      :layer => LAYER,
      :minzoom => MINZOOMS[resolution],
      :maxzoom => MAXZOOMS[resolution]
    }
  }
  print "#{JSON.dump(f)}\n"
}

