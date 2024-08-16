SRC_PATH = "/Users/hfu/Downloads/kontur_population_20231101.gpkg"
DST_PATH = "kpop.pmtiles"

database:
	rm -rf db; mkdir db; \
	ogr2ogr -of GeoJSONSeq /vsistdout/ $(SRC_PATH) | ruby create_db.rb

produce:
	ruby dump_db.rb | tippecanoe -o $(DST_PATH) --detect-longitude-wraparound \
	--minimum-zoom=0 --maximum-zoom=10 --force
