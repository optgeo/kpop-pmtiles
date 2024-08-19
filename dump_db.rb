require 'lmdb'
require 'json'
require 'h3'

LAYER = 'kpop'
MINZOOMS = [0, 2, 3, 4, 5, 6, 7, 8, 9]
MAXZOOMS = [1, 2, 3, 4, 5, 6, 7, 8, 9]

env = LMDB.new('db', :mapsize => 1000 * 1024 * 1024 * 1024)

db = env.database
db.each {|h3p, popp|
  h3 = h3p.unpack('Q>').first
  pop = popp.unpack('Q>').first
  resolution = H3.resolution(h3)
  f = {
    :type => 'Feature',
    :geometry => JSON.parse(H3.coordinates_to_geo_json([H3.to_boundary(h3)])),
    :properties => { :pop => pop },
    :tippecanoe => {
      :layer => LAYER,
      :minzoom => MINZOOMS[resolution],
      :maxzoom => MAXZOOMS[resolution]
    }
  }
  print "#{JSON.dump(f)}\n"
}

