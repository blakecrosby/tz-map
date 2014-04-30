# To the extent possible under law, Eric Muller has waived all
# copyright and related or neighboring rights to the efele.net/tz maps
# (comprising the shapefiles, the web pages describing them and the scripts
# and data used to build them. This work is published from the United States of
# America.
#
# See http://creativecommons.org/publicdomain/zero/1.0/ for more details.


psql <<EOF

SELECT DropGeometryColumn ('', 'tz_antarctica', 'geom');
DROP TABLE tz_antarctica;

CREATE TABLE tz_antarctica (station text, tzid text);
SELECT addgeometrycolumn ('tz_antarctica', 'geom', 4326, 'POINT', 2);

------ Argentina

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Belgrano II',
       'unknown',
       pointfromtext ('POINT(-34.616667 -77.866667)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Esperenza',
       'unknown',
       pointfromtext ('POINT(-57 -63.4)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Jubany',
       'unknown',
       pointfromtext ('POINT(-58.676667 -62.236667)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Marambio',
       'unknown',
       pointfromtext ('POINT(-56.616667 -64.233333)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Orcadas',
       'unknown',
       pointfromtext ('POINT(-44.733333 -60.733333)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'San Martin',
       'unknown',
       pointfromtext ('POINT(-67.1 -68.133333)', 4326);

------ Australia

-- Macquarie Island is listed in the Antarctica bases, but
-- is not part of Antactica


INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Casey',
       'Antarctica/Casey',
       pointfromtext ('POINT(110.533333 -66.283333)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Davis',
       'Antarctica/Davis',
       pointfromtext ('POINT(77.966667 -68.583333)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Mawson',
       'Antarctica/Mawson',
       pointfromtext ('POINT(62.883333 -67.6)', 4326);

------ Belgium

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Princess Elisabeth',
       'unknown',
       pointfromtext ('POINT(23.2 -71.57)', 4326);


------ Brazil

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Comandante Ferraz',
       'unknown',
       pointfromtext ('POINT(-58.403333 -62.085)', 4326);

------ Bulgaria

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'St. Kliment Ohridski',
       'unknown',
       pointfromtext ('POINT(-60.364722 -62.641389)', 4326);

------ Chile

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Bernardo O''Higgins',
       'America/Santiago',
       pointfromtext ('POINT(-57.9 -63.316667)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Captain Arturo Prat',
       'America/Santiago',
       pointfromtext ('POINT(-59.683333 -62.5)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Presidente Eduardo Frei Montalva',
       'America/Santiago',
       pointfromtext ('POINT(-58.978333 -62.195)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Professor Julio Escudero',
       'America/Santiago',
       pointfromtext ('POINT(-58.975 -62.205)', 4326);

------ China

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Great Wall',
       'unknown',
       pointfromtext ('POINT(-58.97 -62.216667)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Zhongshan',
       'unknown',
       pointfromtext ('POINT(76.377778 -69.378889)', 4326);

------ France

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Dumont d''Urville',
       'Antarctica/DumontDUrville',
       pointfromtext ('POINT(140 -66.666667)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Concordia',
       'unknown',
       pointfromtext ('POINT(123.333333 -75.1)', 4326);

------ Germany

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Neumayer',
       'unknown',
       pointfromtext ('POINT(-8.25 -70.65)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Neumayer III',
       'unknown',
       pointfromtext ('POINT(-8.27 -70.68)', 4326);

------ India

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Maitri',
       'unknown',
       pointfromtext ('POINT(11.726 -70.759667)', 4326);

------ Japan

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Dome Fuji',
       'Antarctica/Syowa',
       pointfromtext ('POINT(39.703333 -77.316944)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Showa',
       'Antarctica/Syowa',
       pointfromtext ('POINT(39.59 -69.006111)', 4326);

------ New Zealand

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Scott',
       'Antarctica/McMurdo',
       pointfromtext ('POINT(166.75 -77.85)', 4326);

------ Norway

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Troll',
       'Antarctica/Troll',
       pointfromtext ('POINT(2.532222 -72.012083)', 4326);

------ Poland

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Henryk Arctowski',
       'unknown',
       pointfromtext ('POINT(-58.481667 -62.153333)', 4326);

------ Russia

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Bellingshausen',
       'unknown',
       pointfromtext ('POINT(-58.960833 -62.196389)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Leningradskaya',
       'unknown',
       pointfromtext ('POINT(159.383333 -69.5)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Mirny',
       'unknown',
       pointfromtext ('POINT(93.014722 -66.551944)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Novolazarevskaya',
       'unknown',
       pointfromtext ('POINT(11.831667 -70.767778)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Russkaya',
       'unknown',
       pointfromtext ('POINT(-136.866667 -74.766667)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Vostok',
       'Antarctica/Vostok',
       pointfromtext ('POINT(106.8 -78.466667)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Molodyozhnaya',
       'unknown',
       pointfromtext ('POINT(45.855833 -67.671667)', 4326);

------ South Africa

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'SANAE IV',
       'unknown',
       pointfromtext ('POINT(-2.85 -71.666667)', 4326);

------ South Korea

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'King Sejong',
       'unknown',
       pointfromtext ('POINT(-58.783333 -62.22)', 4326);

------ Ukraine

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Vernadsky',
       'unknown',
       pointfromtext ('POINT(-64.25 -65.233333)', 4326);

------ UK

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Halley',
       'unknown',
       pointfromtext ('POINT(-26.566667 -75.583333)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Rothera',
       'Antarctica/Rothera',
       pointfromtext ('POINT(-68.133333 -67.566667)', 4326);

------ US

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Amundsen-Scott',
       'Antarctica/South_Pole',
       pointfromtext ('POINT(0 -90)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Byrd',
       'unknown',
       pointfromtext ('POINT(-119.533333 -80.016667)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'McMurdo',
       'Antarctica/McMurdo',
       pointfromtext ('POINT(166.666667 -77.85)', 4326);

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Palmer',
       'Antarctica/Palmer',
       pointfromtext ('POINT(-64.05 -64.77)', 4326);


------ Urugay

INSERT INTO tz_antarctica (station, tzid, geom)
SELECT 'Artigas',
       'unknown',
       pointfromtext ('POINT(-58.861667 -62.175)', 4326);

EOF

pgsql2shp -g geom -f tz_antarctica geo tz_antarctica


#----- for the snapshot

rm -f tz_antarctica_{stations,land}.{shp,shx,dbf,prj}

ogr2ogr -s_srs '+proj=latlong +ellps=WGS84 +datum=WGS84 +nodefs' \
    -t_srs '+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs' \
    tz_antarctica_stations.shp tz_antarctica.shp

ogr2ogr -s_srs '+proj=latlong +ellps=WGS84 +datum=WGS84 +nodefs' \
    -t_srs '+proj=stere +lat_0=-90 +lat_ts=-71 +lon_0=0 +k=1 +x_0=0 +y_0=0 +ellps=WGS84 +datum=WGS84 +units=m +no_defs' \
    -where "fips2=AY" \
    tz_antarctica_land.shp ../../fips_10/map/fips10c.shp 

