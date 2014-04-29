# To the extent possible under law, Eric Muller has waived all
# copyright and related or neighboring rights to the efele.net/tz maps
# (comprising the shapefiles, the web pages describing them and the scripts
# and data used to build them. This work is published from the United States of
# America.
#
# See http://creativecommons.org/publicdomain/zero/1.0/ for more details.

shp2pgsql -s 4326 -S -d -g geom -i -I tz_world tz_world | \
    psql -L world.log -q

psql.exe  <<EOF

------------------------------------------------- multipolygon/polygon version ---

DROP TABLE tz_world_mp;

CREATE TABLE tz_world_mp (tzid  text);

SELECT AddGeometryColumn ('tz_world_mp', 'geom', '4326', 'GEOMETRY', 2);

INSERT INTO tz_world_mp (tzid, geom)
SELECT tzid AS tzid, ST_Union (geom) as geom
FROM tz_world
GROUP by tzid;

EOF

pgsql2shp -g geom -f tz_world_mp geo tz_world_mp


#---- for the snapshot

rm -f tz_world_robinson.{shp,shx,dbf,prj}

ogr2ogr -s_srs '+proj=latlong' -t_srs '+proj=robin' \
    tz_world_robinson.shp tz_world.shp
