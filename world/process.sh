# To the extent possible under law, Eric Muller has waived all
# copyright and related or neighboring rights to the efele.net/tz maps
# (comprising the shapefiles, the web pages describing them and the scripts
# and data used to build them. This work is published from the United States of
# America.
#
# See http://creativecommons.org/publicdomain/zero/1.0/ for more details.

psql.exe  <<EOF

DROP TABLE tz_canada_mask;

CREATE TABLE tz_canada_mask (fips4 text,
                         tzid  text);

SELECT AddGeometryColumn('','tz_canada_mask','geom','4326','POLYGON',2);

EOF

shp2pgsql -s 4326 -S -d -g geom -i -I ../../fips_10/map/fips10s fips10s | \
    psql -L fips10s.log -q

for p in 01 02 03 04 05 07 08 09 10 11 12 13 14; do 
  shp2pgsql -s 4326 -S -a -g geom -i ../canada/tz_canada_${p} tz_canada_mask | psql
done

shp2pgsql -s 4326 -S -d -g geom -i -I tz_greenland_mask tz_greenland_mask | \
    sed -e "s_\\\'_''_g" |\
    psql -L tz_greenland_mask.log -q

shp2pgsql -s 4326 -S -d -g geom -i -I tz_brazil_mask tz_brazil_mask | \
    sed -e "s_\\\'_''_g" |\
    psql -L tz_brazil_mask.log -q

shp2pgsql -s 4326 -S -d -g geom -i -I tz_china_mask tz_china_mask | \
    sed -e "s_\\\'_''_g" |\
    psql -L tz_china_mask.log -q

shp2pgsql -s 4326 -S -d -g geom -i -I tz_russia_mask tz_russia_mask | \
    sed -e "s_\\\'_''_g" | \
    psql -L tz_russia_mask.log -q

shp2pgsql -s 4326 -S -d -g geom -i -I tz_us_mask tz_us_mask |\
    sed -e "s_\\\'_''_g" | \
    psql -L tz_us_mask.log -q

shp2pgsql -s 4326 -S -d -g geom -i -I tz_mexico_mask tz_mexico_mask |\
    sed -e "s_\\\'_''_g" | \
    psql -L tz_mexico_mask.log -q


psql.exe <<EOF

-- * indicates a decision beyond what is described in the tz database, 
-- where the resolution adopted here is deemed reasonable

-- ** indicates something that needs to be fixed; either a known problem
-- or an open question

-------------------------------------------------------------- table creation ---

DROP TABLE temp_tz;

CREATE TABLE temp_tz (tzid  text,
                      fips2 varchar(2),
                      fips4 varchar(4));

SELECT AddGeometryColumn ('', 'temp_tz', 'geom', '4326', 'POLYGON', 2);


------------------------------------------------ inserting initial geometries ---

-- Our strategy is to include all our fips geometries, and progressively 
-- assign a tzid to them. By starting with a tzid 'unknown', we 
-- can discover those geometries which this script does not deal with
--
-- for a few cases, we follow a different path, so we don't include 
-- them in our initial set

INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom, 'unknown', fips2, fips4 FROM fips10s
WHERE (fips2 != 'US' OR fips4 = 'US_A')  -- include Guantanamo Bay
  AND fips2 != 'CA'
  AND fips2 != 'CH'
  AND fips2 != 'GL'
  AND fips4 != 'RS63'
  AND fips4 != 'RS64'
  AND fips4 != 'BR04'
  AND fips4 != 'BR16' 
  AND fips4 != 'AS08'
  AND fips4 != 'AS02'
  AND fips4 != 'MX02'
  AND fips4 != 'MX06'
  AND fips4 != 'MX07'
  AND fips4 != 'MX10'
  AND fips4 != 'MX18'
  AND fips4 != 'MX19'
  AND fips4 != 'MX28';


---------------------- uninhabited zone, tz explicitly does not assign a zone ---

UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'AT';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'BQ';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'BV';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'CR';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'DQ';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'EU';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'FQ';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'GO';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'HM';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'HQ';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'IP';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'JU';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'KQ';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'LQ';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'PF';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'PG';
UPDATE temp_tz SET tzid = 'uninhabited'              WHERE fips2 = 'TE';

-- see also Brazil

----------------------------------- zones that correspond to one FIPS2 entity ---

UPDATE temp_tz SET tzid = 'Africa/Algiers'           WHERE fips2 = 'AG';
UPDATE temp_tz SET tzid = 'Africa/Luanda'            WHERE fips2 = 'AO';
UPDATE temp_tz SET tzid = 'Africa/Porto-Novo'        WHERE fips2 = 'BN';
UPDATE temp_tz SET tzid = 'Africa/Gaborone'          WHERE fips2 = 'BC';
UPDATE temp_tz SET tzid = 'Africa/Ouagadougou'       WHERE fips2 = 'UV';
UPDATE temp_tz SET tzid = 'Africa/Bujumbura'         WHERE fips2 = 'BY';
UPDATE temp_tz SET tzid = 'Africa/Douala'            WHERE fips2 = 'CM';
UPDATE temp_tz SET tzid = 'Atlantic/Cape_Verde'      WHERE fips2 = 'CV';
UPDATE temp_tz SET tzid = 'Africa/Bangui'            WHERE fips2 = 'CT';
UPDATE temp_tz SET tzid = 'Africa/Ndjamena'          WHERE fips2 = 'CD';
UPDATE temp_tz SET tzid = 'Indian/Comoro'            WHERE fips2 = 'CN';
UPDATE temp_tz SET tzid = 'Africa/Brazzaville'       WHERE fips2 = 'CF';
UPDATE temp_tz SET tzid = 'Africa/Abidjan'           WHERE fips2 = 'IV';
UPDATE temp_tz SET tzid = 'Africa/Djibouti'          WHERE fips2 = 'DJ';
UPDATE temp_tz SET tzid = 'Africa/Cairo'             WHERE fips2 = 'EG';
UPDATE temp_tz SET tzid = 'Africa/Malabo'            WHERE fips2 = 'EK';
UPDATE temp_tz SET tzid = 'Africa/Asmara'            WHERE fips2 = 'ER';
UPDATE temp_tz SET tzid = 'Africa/Addis_Ababa'       WHERE fips2 = 'ET';
UPDATE temp_tz SET tzid = 'Africa/Libreville'        WHERE fips2 = 'GB';
UPDATE temp_tz SET tzid = 'Africa/Banjul'            WHERE fips2 = 'GA';
UPDATE temp_tz SET tzid = 'Africa/Accra'             WHERE fips2 = 'GH';
UPDATE temp_tz SET tzid = 'Africa/Conakry'           WHERE fips2 = 'GV';
UPDATE temp_tz SET tzid = 'Africa/Bissau'            WHERE fips2 = 'PU';
UPDATE temp_tz SET tzid = 'Africa/Nairobi'           WHERE fips2 = 'KE';
UPDATE temp_tz SET tzid = 'Africa/Maseru'            WHERE fips2 = 'LT';
UPDATE temp_tz SET tzid = 'Africa/Monrovia'          WHERE fips2 = 'LI';
UPDATE temp_tz SET tzid = 'Africa/Tripoli'           WHERE fips2 = 'LY';
UPDATE temp_tz SET tzid = 'Indian/Antananarivo'      WHERE fips2 = 'MA';
UPDATE temp_tz SET tzid = 'Africa/Blantyre'          WHERE fips2 = 'MI';
UPDATE temp_tz SET tzid = 'Africa/Bamako'            WHERE fips2 = 'ML';
UPDATE temp_tz SET tzid = 'Africa/Nouakchott'        WHERE fips2 = 'MR';
UPDATE temp_tz SET tzid = 'Indian/Mauritius'         WHERE fips2 = 'MP';
UPDATE temp_tz SET tzid = 'Indian/Mayotte'           WHERE fips2 = 'MF';
UPDATE temp_tz SET tzid = 'Africa/Casablanca'        WHERE fips2 = 'MO';
UPDATE temp_tz SET tzid = 'Africa/El_Aaiun'          WHERE fips2 = 'WI';
UPDATE temp_tz SET tzid = 'Africa/Maputo'            WHERE fips2 = 'MZ';
UPDATE temp_tz SET tzid = 'Africa/Windhoek'          WHERE fips2 = 'WA';
UPDATE temp_tz SET tzid = 'Africa/Niamey'            WHERE fips2 = 'NG';
UPDATE temp_tz SET tzid = 'Africa/Lagos'             WHERE fips2 = 'NI';
UPDATE temp_tz SET tzid = 'Indian/Reunion'           WHERE fips2 = 'RE';
UPDATE temp_tz SET tzid = 'Africa/Kigali'            WHERE fips2 = 'RW';
UPDATE temp_tz SET tzid = 'Atlantic/St_Helena'       WHERE fips2 = 'SH';
UPDATE temp_tz SET tzid = 'Africa/Sao_Tome'          WHERE fips2 = 'TP';
UPDATE temp_tz SET tzid = 'Africa/Dakar'             WHERE fips2 = 'SG';
UPDATE temp_tz SET tzid = 'Indian/Mahe'              WHERE fips2 = 'SE';
UPDATE temp_tz SET tzid = 'Africa/Freetown'          WHERE fips2 = 'SL';
UPDATE temp_tz SET tzid = 'Africa/Mogadishu'         WHERE fips2 = 'SO';
UPDATE temp_tz SET tzid = 'Africa/Johannesburg'      WHERE fips2 = 'SF';

UPDATE temp_tz SET tzid = 'Africa/Khartoum'
WHERE fips4 = 'SU27'
   OR fips4 = 'SU29'
   OR fips4 = 'SU30'
   OR fips4 = 'SU31'
   OR fips4 = 'SU33'
   OR fips4 = 'SU34';

UPDATE temp_tz SET tzid = 'Africa/Juba'              
WHERE fips4 = 'SU26'
   OR fips4 = 'SU28'
   OR fips4 = 'SU32';

UPDATE temp_tz SET tzid = 'Africa/Mbabane'           WHERE fips2 = 'WZ';
UPDATE temp_tz SET tzid = 'Africa/Dar_es_Salaam'     WHERE fips2 = 'TZ';
UPDATE temp_tz SET tzid = 'Africa/Lome'              WHERE fips2 = 'TO';
UPDATE temp_tz SET tzid = 'Africa/Tunis'             WHERE fips2 = 'TS';
UPDATE temp_tz SET tzid = 'Africa/Kampala'           WHERE fips2 = 'UG';
UPDATE temp_tz SET tzid = 'Africa/Lusaka'            WHERE fips2 = 'ZA';
UPDATE temp_tz SET tzid = 'Africa/Harare'            WHERE fips2 = 'ZI';
UPDATE temp_tz SET tzid = 'Asia/Kabul'               WHERE fips2 = 'AF';
UPDATE temp_tz SET tzid = 'Asia/Yerevan'             WHERE fips2 = 'AM';
UPDATE temp_tz SET tzid = 'Asia/Baku'                WHERE fips2 = 'AJ';
UPDATE temp_tz SET tzid = 'Asia/Bahrain'             WHERE fips2 = 'BA';
UPDATE temp_tz SET tzid = 'Asia/Dhaka'               WHERE fips2 = 'BG';
UPDATE temp_tz SET tzid = 'Asia/Thimphu'             WHERE fips2 = 'BT';
UPDATE temp_tz SET tzid = 'Indian/Chagos'            WHERE fips2 = 'IO';
UPDATE temp_tz SET tzid = 'Asia/Brunei'              WHERE fips2 = 'BX';
UPDATE temp_tz SET tzid = 'Asia/Rangoon'             WHERE fips2 = 'BM';
UPDATE temp_tz SET tzid = 'Asia/Phnom_Penh'          WHERE fips2 = 'CB';
UPDATE temp_tz SET tzid = 'Asia/Hong_Kong'           WHERE fips2 = 'HK';
UPDATE temp_tz SET tzid = 'Asia/Taipei'              WHERE fips2 = 'TW';
UPDATE temp_tz SET tzid = 'Asia/Macau'               WHERE fips2 = 'MC';
UPDATE temp_tz SET tzid = 'Asia/Nicosia'             WHERE fips2 = 'CY';
UPDATE temp_tz SET tzid = 'Asia/Nicosia'             WHERE fips2 = 'DX';
UPDATE temp_tz SET tzid = 'Asia/Nicosia'             WHERE fips2 = 'AX';
UPDATE temp_tz SET tzid = 'Asia/Tbilisi'             WHERE fips2 = 'GG';
UPDATE temp_tz SET tzid = 'Asia/Dili'                WHERE fips2 = 'TT';
UPDATE temp_tz SET tzid = 'Asia/Kolkata'             WHERE fips2 = 'IN';
UPDATE temp_tz SET tzid = 'Asia/Tehran'              WHERE fips2 = 'IR';
UPDATE temp_tz SET tzid = 'Asia/Baghdad'             WHERE fips2 = 'IZ';
UPDATE temp_tz SET tzid = 'Asia/Jerusalem'           WHERE fips2 = 'IS';
UPDATE temp_tz SET tzid = 'Asia/Tokyo'               WHERE fips2 = 'JA';
UPDATE temp_tz SET tzid = 'Asia/Amman'               WHERE fips2 = 'JO';
UPDATE temp_tz SET tzid = 'Asia/Bishkek'             WHERE fips2 = 'KG';
UPDATE temp_tz SET tzid = 'Asia/Seoul'               WHERE fips2 = 'KS';
UPDATE temp_tz SET tzid = 'Asia/Pyongyang'           WHERE fips2 = 'KN';
UPDATE temp_tz SET tzid = 'Asia/Kuwait'              WHERE fips2 = 'KU';
UPDATE temp_tz SET tzid = 'Asia/Vientiane'           WHERE fips2 = 'LA';
UPDATE temp_tz SET tzid = 'Asia/Beirut'              WHERE fips2 = 'LE';
UPDATE temp_tz SET tzid = 'Indian/Maldives'          WHERE fips2 = 'MV';
UPDATE temp_tz SET tzid = 'Asia/Kathmandu'           WHERE fips2 = 'NP';
UPDATE temp_tz SET tzid = 'Asia/Muscat'              WHERE fips2 = 'MU';
UPDATE temp_tz SET tzid = 'Asia/Karachi'             WHERE fips2 = 'PK';
UPDATE temp_tz SET tzid = 'Asia/Gaza'                WHERE fips2 = 'GZ';
UPDATE temp_tz SET tzid = 'Asia/Hebron'              WHERE fips2 = 'WE';
UPDATE temp_tz SET tzid = 'Asia/Manila'              WHERE fips2 = 'RP';
UPDATE temp_tz SET tzid = 'Asia/Qatar'               WHERE fips2 = 'QA';
UPDATE temp_tz SET tzid = 'Asia/Riyadh'              WHERE fips2 = 'SA';
UPDATE temp_tz SET tzid = 'Asia/Singapore'           WHERE fips2 = 'SN';
UPDATE temp_tz SET tzid = 'Asia/Colombo'             WHERE fips2 = 'CE';
UPDATE temp_tz SET tzid = 'Asia/Damascus'            WHERE fips2 = 'SY';
UPDATE temp_tz SET tzid = 'Asia/Dushanbe'            WHERE fips2 = 'TI';
UPDATE temp_tz SET tzid = 'Asia/Bangkok'             WHERE fips2 = 'TH';
UPDATE temp_tz SET tzid = 'Asia/Ashgabat'            WHERE fips2 = 'TX';
UPDATE temp_tz SET tzid = 'Asia/Dubai'               WHERE fips2 = 'AE';
UPDATE temp_tz SET tzid = 'Asia/Ho_Chi_Minh'         WHERE fips2 = 'VM';
UPDATE temp_tz SET tzid = 'Asia/Aden'                WHERE fips2 = 'YM';
UPDATE temp_tz SET tzid = 'Indian/Christmas'         WHERE fips2 = 'KT';
UPDATE temp_tz SET tzid = 'Pacific/Rarotonga'        WHERE fips2 = 'CW';
UPDATE temp_tz SET tzid = 'Indian/Cocos'             WHERE fips2 = 'CK';
UPDATE temp_tz SET tzid = 'Pacific/Fiji'             WHERE fips2 = 'FJ';
UPDATE temp_tz SET tzid = 'Pacific/Guam'             WHERE fips2 = 'GQ';
UPDATE temp_tz SET tzid = 'Pacific/Saipan'           WHERE fips2 = 'CQ';
UPDATE temp_tz SET tzid = 'Pacific/Nauru'            WHERE fips2 = 'NR';
UPDATE temp_tz SET tzid = 'Pacific/Noumea'           WHERE fips2 = 'NC';
UPDATE temp_tz SET tzid = 'Pacific/Niue'             WHERE fips2 = 'NE';
UPDATE temp_tz SET tzid = 'Pacific/Norfolk'          WHERE fips2 = 'NF';
UPDATE temp_tz SET tzid = 'Pacific/Palau'            WHERE fips2 = 'PS';
UPDATE temp_tz SET tzid = 'Pacific/Port_Moresby'     WHERE fips2 = 'PP';
UPDATE temp_tz SET tzid = 'Pacific/Pitcairn'         WHERE fips2 = 'PC';
UPDATE temp_tz SET tzid = 'Pacific/Pago_Pago'        WHERE fips2 = 'AQ';
UPDATE temp_tz SET tzid = 'Pacific/Apia'             WHERE fips2 = 'WS';
UPDATE temp_tz SET tzid = 'Pacific/Guadalcanal'      WHERE fips2 = 'BP';
UPDATE temp_tz SET tzid = 'Pacific/Fakaofo'          WHERE fips2 = 'TL';
UPDATE temp_tz SET tzid = 'Pacific/Tongatapu'        WHERE fips2 = 'TN';
UPDATE temp_tz SET tzid = 'Pacific/Funafuti'         WHERE fips2 = 'TV';
UPDATE temp_tz SET tzid = 'Pacific/Johnston'         WHERE fips2 = 'JQ';
UPDATE temp_tz SET tzid = 'Pacific/Midway'           WHERE fips2 = 'MQ';
UPDATE temp_tz SET tzid = 'Pacific/Wake'             WHERE fips2 = 'WQ';
UPDATE temp_tz SET tzid = 'Pacific/Efate'            WHERE fips2 = 'NH';
UPDATE temp_tz SET tzid = 'Pacific/Wallis'           WHERE fips2 = 'WF';
UPDATE temp_tz SET tzid = 'Europe/London'            WHERE fips2 = 'UK';
UPDATE temp_tz SET tzid = 'Europe/Isle_of_Man'       WHERE fips2 = 'IM';
UPDATE temp_tz SET tzid = 'Europe/Jersey'            WHERE fips2 = 'JE';
UPDATE temp_tz SET tzid = 'Europe/Guernsey'          WHERE fips2 = 'GK';
UPDATE temp_tz SET tzid = 'Europe/Dublin'            WHERE fips2 = 'EI';
UPDATE temp_tz SET tzid = 'Europe/Tirane'            WHERE fips2 = 'AL';
UPDATE temp_tz SET tzid = 'Europe/Andorra'           WHERE fips2 = 'AN';
UPDATE temp_tz SET tzid = 'Europe/Vienna'            WHERE fips2 = 'AU';
UPDATE temp_tz SET tzid = 'Europe/Minsk'             WHERE fips2 = 'BO';
UPDATE temp_tz SET tzid = 'Europe/Brussels'          WHERE fips2 = 'BE';
UPDATE temp_tz SET tzid = 'Europe/Sofia'             WHERE fips2 = 'BU';
UPDATE temp_tz SET tzid = 'Europe/Prague'            WHERE fips2 = 'EZ';
UPDATE temp_tz SET tzid = 'Europe/Copenhagen'        WHERE fips2 = 'DA';
UPDATE temp_tz SET tzid = 'Atlantic/Faroe'           WHERE fips2 = 'FO';
UPDATE temp_tz SET tzid = 'Europe/Tallinn'           WHERE fips2 = 'EN';
UPDATE temp_tz SET tzid = 'Europe/Paris'             WHERE fips2 = 'FR';
UPDATE temp_tz SET tzid = 'Europe/Berlin'            WHERE fips2 = 'GM';
UPDATE temp_tz SET tzid = 'Europe/Gibraltar'         WHERE fips2 = 'GI';
UPDATE temp_tz SET tzid = 'Europe/Athens'            WHERE fips2 = 'GR';
UPDATE temp_tz SET tzid = 'Europe/Budapest'          WHERE fips2 = 'HU';
UPDATE temp_tz SET tzid = 'Atlantic/Reykjavik'       WHERE fips2 = 'IC';
UPDATE temp_tz SET tzid = 'Europe/Rome'              WHERE fips2 = 'IT';
UPDATE temp_tz SET tzid = 'Europe/Vatican'           WHERE fips2 = 'VT';
UPDATE temp_tz SET tzid = 'Europe/San_Marino'        WHERE fips2 = 'SM';
UPDATE temp_tz SET tzid = 'Europe/Riga'              WHERE fips2 = 'LG';
UPDATE temp_tz SET tzid = 'Europe/Vaduz'             WHERE fips2 = 'LS';
UPDATE temp_tz SET tzid = 'Europe/Vilnius'           WHERE fips2 = 'LH';
UPDATE temp_tz SET tzid = 'Europe/Luxembourg'        WHERE fips2 = 'LU';
UPDATE temp_tz SET tzid = 'Europe/Malta'             WHERE fips2 = 'MT';
UPDATE temp_tz SET tzid = 'Europe/Chisinau'          WHERE fips2 = 'MD';
UPDATE temp_tz SET tzid = 'Europe/Monaco'            WHERE fips2 = 'MN';
UPDATE temp_tz SET tzid = 'Europe/Amsterdam'         WHERE fips2 = 'NL';
UPDATE temp_tz SET tzid = 'Europe/Oslo'              WHERE fips2 = 'NO';
UPDATE temp_tz SET tzid = 'Arctic/Longyearbyen'      WHERE fips2 = 'SV';
UPDATE temp_tz SET tzid = 'Arctic/Longyearbyen'      WHERE fips2 = 'JN';
UPDATE temp_tz SET tzid = 'Europe/Warsaw'            WHERE fips2 = 'PL';
UPDATE temp_tz SET tzid = 'Europe/Bucharest'         WHERE fips2 = 'RO';
UPDATE temp_tz SET tzid = 'Europe/Belgrade'          WHERE fips2 = 'SR';
UPDATE temp_tz SET tzid = 'Europe/Ljubljana'         WHERE fips2 = 'SI';
UPDATE temp_tz SET tzid = 'Europe/Podgorica'         WHERE fips2 = 'MJ';
UPDATE temp_tz SET tzid = 'Europe/Sarajevo'          WHERE fips2 = 'BK';
UPDATE temp_tz SET tzid = 'Europe/Skopje'            WHERE fips2 = 'MK';
UPDATE temp_tz SET tzid = 'Europe/Zagreb'            WHERE fips2 = 'HR';
UPDATE temp_tz SET tzid = 'Europe/Bratislava'        WHERE fips2 = 'LO';
UPDATE temp_tz SET tzid = 'Europe/Stockholm'         WHERE fips2 = 'SW';
UPDATE temp_tz SET tzid = 'Europe/Zurich'            WHERE fips2 = 'SZ';
UPDATE temp_tz SET tzid = 'Europe/Istanbul'          WHERE fips2 = 'TU';
UPDATE temp_tz SET tzid = 'America/Anguilla'         WHERE fips2 = 'AV';
UPDATE temp_tz SET tzid = 'America/Antigua'          WHERE fips2 = 'AC';
UPDATE temp_tz SET tzid = 'America/Nassau'           WHERE fips2 = 'BF';
UPDATE temp_tz SET tzid = 'America/Barbados'         WHERE fips2 = 'BB';
UPDATE temp_tz SET tzid = 'America/Belize'           WHERE fips2 = 'BH';
UPDATE temp_tz SET tzid = 'Atlantic/Bermuda'         WHERE fips2 = 'BD';
UPDATE temp_tz SET tzid = 'America/Cayman'           WHERE fips2 = 'CJ';
UPDATE temp_tz SET tzid = 'America/Costa_Rica'       WHERE fips2 = 'CS';
UPDATE temp_tz SET tzid = 'America/Havana'           WHERE fips2 = 'CU';
UPDATE temp_tz SET tzid = 'America/Dominica'         WHERE fips2 = 'DO';
UPDATE temp_tz SET tzid = 'America/Santo_Domingo'    WHERE fips2 = 'DR';
UPDATE temp_tz SET tzid = 'America/El_Salvador'      WHERE fips2 = 'ES';
UPDATE temp_tz SET tzid = 'America/Grenada'          WHERE fips2 = 'GJ';
UPDATE temp_tz SET tzid = 'America/Guadeloupe'       WHERE fips2 = 'GP';
UPDATE temp_tz SET tzid = 'America/St_Barthelemy'    WHERE fips2 = 'TB';
UPDATE temp_tz SET tzid = 'America/Marigot'          WHERE fips2 = 'RN';
UPDATE temp_tz SET tzid = 'America/Guatemala'        WHERE fips2 = 'GT';
UPDATE temp_tz SET tzid = 'America/Port-au-Prince'   WHERE fips2 = 'HA';
UPDATE temp_tz SET tzid = 'America/Tegucigalpa'      WHERE fips2 = 'HO';
UPDATE temp_tz SET tzid = 'America/Jamaica'          WHERE fips2 = 'JM';
UPDATE temp_tz SET tzid = 'America/Martinique'       WHERE fips2 = 'MB';
UPDATE temp_tz SET tzid = 'America/Montserrat'       WHERE fips2 = 'MH';
UPDATE temp_tz SET tzid = 'America/Managua'          WHERE fips2 = 'NU';
UPDATE temp_tz SET tzid = 'America/Panama'           WHERE fips2 = 'PM';
UPDATE temp_tz SET tzid = 'America/Puerto_Rico'      WHERE fips2 = 'RQ';
UPDATE temp_tz SET tzid = 'America/St_Kitts'         WHERE fips2 = 'SC';
UPDATE temp_tz SET tzid = 'America/St_Lucia'         WHERE fips2 = 'ST';
UPDATE temp_tz SET tzid = 'America/Miquelon'         WHERE fips2 = 'SB';
UPDATE temp_tz SET tzid = 'America/St_Vincent'       WHERE fips2 = 'VC';
UPDATE temp_tz SET tzid = 'America/Grand_Turk'       WHERE fips2 = 'TK';
UPDATE temp_tz SET tzid = 'America/Tortola'          WHERE fips2 = 'VI';
UPDATE temp_tz SET tzid = 'America/St_Thomas'        WHERE fips2 = 'VQ';
UPDATE temp_tz SET tzid = 'America/Aruba'            WHERE fips2 = 'AA';
UPDATE temp_tz SET tzid = 'America/La_Paz'           WHERE fips2 = 'BL';
UPDATE temp_tz SET tzid = 'America/Bogota'           WHERE fips2 = 'CO';

-- Curacao
UPDATE temp_tz SET tzid = 'America/Curacao'
WHERE fips2 = 'NT'
  AND ST_Intersects (geom, ST_PolygonFromText ('POLYGON((-70   11.5,
                                                         -70   13,
                                                         -68.5 13,
                                                         -68.5 11.5,
                                                         -70   11.5))', 4326));

-- Bonaire
UPDATE temp_tz SET tzid = 'America/Kralendijk'
WHERE fips2 = 'NT'
  AND ST_Intersects (geom, ST_PolygonFromText ('POLYGON((-68.5 11.5,
                                                         -68.5 13,
                                                         -68   13,
                                                         -68   11.5,
                                                         -68.5 11.5))', 4326));

-- Sint Eustatius, Saba
UPDATE temp_tz SET tzid = 'America/Kralendijk'
WHERE fips2 = 'NT'
  AND ST_Intersects (geom, ST_PolygonFromText ('POLYGON((-62   17,  
                                                         -62   17.8,
                                                         -64   17.8,
                                                         -64   17,
                                                         -62   17  ))', 4326));

-- Sint Maarten
UPDATE temp_tz SET tzid = 'America/Lower_Princes'
WHERE fips2 = 'NT'
  AND ST_Intersects (geom, ST_PolygonFromText ('POLYGON((-62   17.8,
                                                         -62   19,  
                                                         -64   19,  
                                                         -64   17.8,
                                                         -62   17.8))', 4326));

UPDATE temp_tz SET tzid = 'Atlantic/Stanley'         WHERE fips2 = 'FK';
UPDATE temp_tz SET tzid = 'America/Cayenne'          WHERE fips2 = 'FG';
UPDATE temp_tz SET tzid = 'America/Guyana'           WHERE fips2 = 'GY';
UPDATE temp_tz SET tzid = 'America/Asuncion'         WHERE fips2 = 'PA';
UPDATE temp_tz SET tzid = 'America/Lima'             WHERE fips2 = 'PE';
UPDATE temp_tz SET tzid = 'Atlantic/South_Georgia'   WHERE fips2 = 'SX';
UPDATE temp_tz SET tzid = 'America/Paramaribo'       WHERE fips2 = 'NS';
UPDATE temp_tz SET tzid = 'America/Port_of_Spain'    WHERE fips2 = 'TD';
UPDATE temp_tz SET tzid = 'America/Montevideo'       WHERE fips2 = 'UY';
UPDATE temp_tz SET tzid = 'America/Caracas'          WHERE fips2 = 'VE';
UPDATE temp_tz SET tzid = 'Indian/Kerguelen'         WHERE fips2 = 'FS';

------------------------------------------------------------------- Indonesia ---

UPDATE temp_tz SET tzid = 'Asia/Jakarta'
WHERE fips4 = 'ID01'
   OR fips4 = 'ID26'
   OR fips4 = 'ID24'
   OR fips4 = 'ID37'
   OR fips4 = 'ID19'
   OR fips4 = 'ID40'
   OR fips4 = 'ID05'
   OR fips4 = 'ID32'
   OR fips4 = 'ID25'
   OR fips4 = 'ID35'
   OR fips4 = 'ID03'
   OR fips4 = 'ID15'
   OR fips4 = 'ID04'
   OR fips4 = 'ID33'
   OR fips4 = 'ID30'
   OR fips4 = 'ID06'
   OR fips4 = 'ID07'
   OR fips4 = 'ID10'
   OR fips4 = 'ID08';

UPDATE temp_tz SET tzid = 'Asia/Pontianak'
WHERE fips4 = 'ID11'
   OR fips4 = 'ID13';

UPDATE temp_tz SET tzid = 'Asia/Makassar'
WHERE fips4 = 'ID31'
   OR fips4 = 'ID23'
   OR fips4 = 'ID34'
   OR fips4 = 'ID21'
   OR fips4 = 'ID41'
   OR fips4 = 'ID38'
   OR fips4 = 'ID20'
   OR fips4 = 'ID22'
   OR fips4 = 'ID02'
   OR fips4 = 'ID17'
   OR fips4 = 'ID18'
   OR fips4 = 'ID12'
   OR fips4 = 'ID14';

UPDATE temp_tz SET tzid = 'Asia/Jayapura'
WHERE fips4 = 'ID28'
   OR fips4 = 'ID16'
   OR fips4 = 'ID29'
   OR fips4 = 'ID36'
   OR fips4 = 'ID09'
   OR fips4 = 'ID39';

--------------------------------------------------------------------- Finland ---

UPDATE temp_tz SET tzid = 'Europe/Mariehamn'
WHERE fips4 = 'FI01';

UPDATE temp_tz SET tzid = 'Europe/Helsinki'
WHERE tzid = 'unknown'
  AND fips2 = 'FI';

--------------------------------------------------------------------- Ecuador ---

UPDATE temp_tz SET tzid = 'Pacific/Galapagos'
WHERE fips4 = 'EC01';

UPDATE temp_tz SET tzid = 'America/Guayaquil'
WHERE tzid = 'unknown'
  AND fips2 = 'EC';

---------------------------------------------------------------------- Mexico ---

UPDATE temp_tz SET tzid = 'America/Cancun'
WHERE fips4 = 'MX23';

UPDATE temp_tz SET tzid = 'America/Merida'
WHERE fips4 = 'MX04'
   OR fips4 = 'MX31';


INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_mexico_mask.geom))), 
       tz_mexico_mask.tzid, fips10s.fips2, fips10s.fips4
FROM fips10s, tz_mexico_mask
WHERE (   fips10s.fips4 = 'MX07' 
       OR fips10s.fips4 = 'MX10'
       OR fips10s.fips4 = 'MX19'
       OR fips10s.fips4 = 'MX28')
  AND (   tz_mexico_mask.tzid = 'America/Monterrey'
       OR tz_mexico_mask.tzid = 'America/Matamoros')
  AND ST_intersects (fips10s.geom, tz_mexico_mask.geom);


INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_mexico_mask.geom))), 
       tz_mexico_mask.tzid, fips10s.fips2, fips10s.fips4
FROM fips10s, tz_mexico_mask
WHERE fips10s.fips4 = 'MX06' 
  AND (   tz_mexico_mask.tzid = 'America/Chihuahua'
       OR tz_mexico_mask.tzid = 'America/Ojinaga')
  AND ST_intersects (fips10s.geom, tz_mexico_mask.geom);

INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_mexico_mask.geom))), 
       tz_mexico_mask.tzid, fips10s.fips2, fips10s.fips4
FROM fips10s, tz_mexico_mask
WHERE fips10s.fips4 = 'MX18' 
  AND (   tz_mexico_mask.tzid = 'America/Bahia_Banderas'
       OR tz_mexico_mask.tzid = 'America/Mazatlan')
  AND ST_intersects (fips10s.geom, tz_mexico_mask.geom);

UPDATE temp_tz SET tzid = 'America/Hermosillo'
WHERE fips4 = 'MX26';

UPDATE temp_tz SET tzid = 'America/Mazatlan'
WHERE fips4 = 'MX03'
   OR fips4 = 'MX25';


INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_mexico_mask.geom))), 
       tz_mexico_mask.tzid, fips10s.fips2, fips10s.fips4
FROM fips10s, tz_mexico_mask
WHERE fips10s.fips4 = 'MX02' 
  AND (   tz_mexico_mask.tzid = 'America/Tijuana'
       OR tz_mexico_mask.tzid = 'America/Santa_Isabel')
  AND ST_intersects (fips10s.geom, tz_mexico_mask.geom);

UPDATE temp_tz SET tzid = 'America/Mexico_City'
WHERE tzid = 'unknown'
  AND fips2 = 'MX';

-------------------------------------------------------------------- Portugal ---

UPDATE temp_tz SET tzid = 'Atlantic/Azores'
WHERE fips4 = 'PO23';

UPDATE temp_tz SET tzid = 'Atlantic/Madeira'
WHERE fips4 = 'PO10';

UPDATE temp_tz SET tzid = 'Europe/Lisbon'
WHERE tzid = 'unknown'
  AND fips2 = 'PO';

----------------------------------------------------------------- New Zealand ---

UPDATE temp_tz SET tzid = 'Pacific/Chatham'
WHERE fips4 = 'NZ10';

UPDATE temp_tz SET tzid = 'Pacific/Auckland'
WHERE tzid = 'unknown'
  AND fips2 = 'NZ';

---------------------------------------------- Federated States of Micronesia ---

UPDATE temp_tz SET tzid = 'Pacific/Chuuk'
WHERE fips4 = 'FM03'
   OR fips4 = 'FM04';

UPDATE temp_tz SET tzid = 'Pacific/Pohnpei'
WHERE fips4 = 'FM02';

UPDATE temp_tz SET tzid = 'Pacific/Kosrae'
WHERE fips4 = 'FM01';

-------------------------------------------------------------------- Kiribati ---

UPDATE temp_tz SET tzid = 'Pacific/Tarawa'
WHERE fips4 = 'KR01';

UPDATE temp_tz SET tzid = 'Pacific/Enderbury'
WHERE fips4 = 'KR03';

UPDATE temp_tz SET tzid = 'Pacific/Kiritimati'
WHERE fips4 = 'KR02';

------------------------------------------------ Democratic Republic of Congo ---

UPDATE temp_tz SET tzid = 'Africa/Kinshasa'
WHERE fips4 = 'CG08'
   OR fips4 = 'CG06'
   OR fips4 = 'CG01'
   OR fips4 = 'CG02';

UPDATE temp_tz SET tzid = 'Africa/Lubumbashi'
WHERE tzid = 'unknown'
  AND fips2 = 'CG';

------------------------------------------------------------------- Kazkhstan ---

UPDATE temp_tz SET tzid = 'Asia/Qyzylorda'
WHERE fips4 = 'KZ_C' OR fips4 = 'KZ_D' -- Qostanay (= KZ13)
   OR fips4 = 'KZ_L';                  -- Qyzylorda (= KZ14 + Bayqonyr [city])

UPDATE temp_tz SET tzid = 'Asia/Aqtobe'
WHERE fips4 = 'KZ04';                  -- Aqtobe

UPDATE temp_tz SET tzid = 'Asia/Aqtau'
WHERE fips4 = 'KZ09'                   -- Mangghystau
   OR fips4 = 'KZ06';                  -- Atyrau

UPDATE temp_tz SET tzid = 'Asia/Oral'             
WHERE fips4 = 'KZ07';                  -- West Kazakhstan

UPDATE temp_tz SET tzid = 'Asia/Almaty'
WHERE tzid = 'unknown'                    -- Alamaty, Qaraghandy, Aqmola, Astana
  AND fips2 = 'KZ';                    -- North Kazakhstan, East Kazakhstan,
                                       -- Almaty (city), South Kazakhstan, 
                                       -- Pavlodar, Zhambyl

-------------------------------------------------------------------- Malaysia ---

UPDATE temp_tz SET tzid = 'Asia/Kuching'
WHERE fips4 = 'MY11'
   OR fips4 = 'MY15'
   OR fips4 = 'MY16';

UPDATE temp_tz SET tzid = 'Asia/Kuala_Lumpur'
WHERE tzid = 'unknown'
  AND fips2 = 'MY';

-------------------------------------------------------------------- Mongolia ---

UPDATE temp_tz SET tzid = 'Asia/Choibalsan'       
WHERE fips4 = 'MG06'
   OR fips4 = 'MG17';

UPDATE temp_tz SET tzid = 'Asia/Hovd'
WHERE fips4 = 'MG03'
   OR fips4 = 'MG09'
   OR fips4 = 'MG10'
   OR fips4 = 'MG12'
   OR fips4 = 'MG19';

UPDATE temp_tz SET tzid = 'Asia/Ulaanbaatar'
WHERE tzid = 'unknown'
  AND fips2 = 'MG';

------------------------------------------------------------------- Argentina ---

UPDATE temp_tz SET tzid = 'America/Argentina/Buenos_Aires'
WHERE fips4 = 'AR01'
   OR fips4 = 'AR07';

UPDATE temp_tz SET tzid = 'America/Argentina/Cordoba'
WHERE fips4 = 'AR21'
   OR fips4 = 'AR08'
   OR fips4 = 'AR06'
   OR fips4 = 'AR14'
   OR fips4 = 'AR03'
   OR fips4 = 'AR09'
   OR fips4 = 'AR22'
   OR fips4 = 'AR05';

UPDATE temp_tz SET tzid = 'America/Argentina/Salta'
WHERE fips4 = 'AR17'
   OR fips4 = 'AR11'
   OR fips4 = 'AR15'
   OR fips4 = 'AR16';

UPDATE temp_tz SET tzid = 'America/Argentina/Tucuman'
WHERE fips4 = 'AR24';

UPDATE temp_tz SET tzid = 'America/Argentina/La_Rioja'
WHERE fips4 = 'AR12';

UPDATE temp_tz SET tzid = 'America/Argentina/San_Juan'
WHERE fips4 = 'AR18';

UPDATE temp_tz SET tzid = 'America/Argentina/Jujuy'
WHERE fips4 = 'AR10';

UPDATE temp_tz SET tzid = 'America/Argentina/Catamarca'
WHERE fips4 = 'AR02'
   OR fips4 = 'AR04';

UPDATE temp_tz SET tzid = 'America/Argentina/Mendoza'
WHERE fips4 = 'AR13';

UPDATE temp_tz SET tzid = 'America/Argentina/San_Luis'
WHERE fips4 = 'AR19';

UPDATE temp_tz SET tzid = 'America/Argentina/Rio_Gallegos'
WHERE fips4 = 'AR20';

UPDATE temp_tz SET tzid = 'America/Argentina/Ushuaia'
WHERE fips4 = 'AR23';

------------------------------------------------------------------ Uzbekistan ---

-- ** Follow WTE; not sure how correct this is

UPDATE temp_tz SET tzid = 'Asia/Tashkent'
WHERE fips4 = 'UZ03'
   OR fips4 = 'UZ01'
   OR fips4 = 'UZ06'
   OR fips4 = 'UZ13'
   OR fips4 = 'UZ16'
   OR fips4 = 'UZ15';

UPDATE temp_tz SET tzid = 'Asia/Samarkand'
WHERE tzid = 'unknown'
  AND fips2 = 'UZ';

------------------------------------------------------------------- Australia ---

-- Australia/Darwin 
--   Northern Territory

UPDATE temp_tz SET tzid = 'Australia/Darwin' WHERE fips4 = 'AS03';

-- Australia/Eucla 
--   area of Western Australia around Eucla, as far west as just east of Caiguna
--   Source: email to tz list from Alex Livingston in December 2006
--
--   * Arbitrarily make that zone the intersection of a rectangle and
--   Western Australia: Caiguna is a 125.490E, so we use somewhat
--   arbitrarily 125.5E as the west boundary; the north boundary is
--   arbitrarily -31.3S; the south boundary is the ocean; the east
--   boundary is the Western Australia/South Australia border.
--
-- Australia/Perth
--   the rest of Western Australia

INSERT INTO temp_tz (tzid, geom)
SELECT 'Australia/Eucla',
       ST_Intersection (geom, ST_PolygonFromText ('POLYGON((125.5 -31.3, 
                                                            130.0 -31.3,
                                                            130.0 -33.0, 
                                                            125.5 -33.0, 
                                                            125.5 -31.3))', 4326))
FROM fips10s 
WHERE fips4 = 'AS08'
  AND ST_within (ST_PointFromText ('POINT(125.5 -31.3)', 4326), geom);

INSERT INTO temp_tz (tzid, geom)
SELECT 'Australia/Perth', 
       ST_Difference (geom, ST_PolygonFromText ('POLYGON((125.5 -31.3,
                                                       130.0 -31.3,
                                                       130.0 -33.0,
                                                       125.5 -33.0,
                                                       125.5 -31.3))', 4326))
FROM fips10s 
WHERE fips4 = 'AS08'
  AND ST_within (ST_PointFromText ('POINT(125.5 -31.3)', 4326), geom);

INSERT INTO temp_tz (tzid, geom)
SELECT 'Australia/Perth', geom
FROM fips10s
WHERE fips4 = 'AS08'
  AND NOT ST_within (ST_PointFromText ('POINT(125.5 -31.3)', 4326), geom);


-- Australia/Lindeman
--   The three islands of Hayman, Lindeman, Hamilton, all in Queensland.
--   There are other islands in this area, but we don't include them.
--
-- Australia/Adelaide
--  the rest of Queensland

UPDATE temp_tz SET tzid = 'Australia/Lindeman'
WHERE ST_within (ST_PointFromText ('POINT(148.88 -20.05)', 4326), geom) -- Hayman Is.
   OR ST_within (ST_PointFromText ('POINT(149.04 -20.45)', 4326), geom) -- Lindeman Is.
   OR ST_within (ST_PointFromText ('POINT(148.96 -20.35)', 4326), geom);-- Hamilton

UPDATE temp_tz SET tzid = 'Australia/Brisbane'
WHERE fips4 = 'AS04'
  AND tzid = 'unknown';

-- Australia/Adelaide
--   South Australia

UPDATE temp_tz SET tzid = 'Australia/Adelaide' WHERE fips4 = 'AS05';

-- Australia/Currie
--   King Island and New Year Island in Tasmania
--
-- Australia/Hobart
--   the  rest of Tasmania

UPDATE temp_tz SET tzid = 'Australia/Currie'
WHERE fips4 = 'AS06' 
  AND ST_Intersects (geom, ST_PolygonFromText ('POLYGON((143.5 -39.5,
                                                      144.2 -39.5,
                                                      144.2 -40.2,
                                                      143.5 -40.2,
                                                      143.5 -39.5))', 4326));

UPDATE temp_tz set tzid = 'Antarctica/Macquarie'
WHERE fips4 = 'AS06'
  AND ST_Intersects (geom, ST_PolygonFromText ('POLYGON((158 -54,
                                                      160 -54,
                                                      160 -56,
                                                      158 -56,
                                                      158 -54))', 4326));

UPDATE temp_tz SET tzid = 'Australia/Hobart'
WHERE tzid = 'unknown'
  AND fips4 = 'AS06';


-- Australia/Melbourne
--   Victoria

UPDATE temp_tz SET tzid = 'Australia/Melbourne' WHERE fips4 = 'AS07';

-- Australia/Lord_Howe
--  the Lord Howe island of New South Wales
--
-- Australia/Broken_Hill
--   Yancowinna county of New South Wales, around Broken Hill
--
--   The polygon we use was obtained by georeferencing and tracing of
--   http://en.wikipedia.org/wiki/Image:New_South_Wales_cadastral_divisions.png
--
-- Australia/Sydney
--   the rest of New South Wales and the Australian Capital Territory

INSERT INTO temp_tz (tzid, geom)
SELECT 'Australia/Lord_Howe', geom
FROM fips10s
WHERE fips4 = 'AS02'
  AND ST_intersects (geom, ST_PolygonFromText ('POLYGON((158 -31,
                                                      160 -31,
                                                      160 -32,
                                                      158 -32,
                                                      158 -31))', 4326));

INSERT INTO temp_tz (tzid, geom)
SELECT 'Australia/Broken_Hill', 
       ST_Intersection (geom, ST_PolygonFromText ('POLYGON ((140.99184231181187 -31.494372302465813, 141.17598529015888 -31.49716234759228, 141.17598529015888 -31.58365374651284, 141.35175813312645 -31.586443791639308, 141.34617804287353 -31.533432934236387, 141.49405043457642 -31.533432934236387, 141.49963052482934 -31.605974107524595, 141.95719792557037 -31.600394017271658, 141.95161783531742 -31.971470019092116, 141.83164589487924 -31.968679973965646, 141.82048571437335 -32.29232520863612, 140.980682131306 -32.21699399022144, 140.99184231181187 -31.494372302465813))', 4326))
FROM fips10s 
WHERE fips4 = 'AS02'
  AND ST_within (ST_PointFromText ('POINT(141.433 -31.95)', 4326), geom);

INSERT INTO temp_tz (tzid, geom)
SELECT 'Australia/Sydney', 
       ST_Difference (geom, ST_PolygonFromText ('POLYGON ((140.99184231181187 -31.494372302465813, 141.17598529015888 -31.49716234759228, 141.17598529015888 -31.58365374651284, 141.35175813312645 -31.586443791639308, 141.34617804287353 -31.533432934236387, 141.49405043457642 -31.533432934236387, 141.49963052482934 -31.605974107524595, 141.95719792557037 -31.600394017271658, 141.95161783531742 -31.971470019092116, 141.83164589487924 -31.968679973965646, 141.82048571437335 -32.29232520863612, 140.980682131306 -32.21699399022144, 140.99184231181187 -31.494372302465813))', 4326))
FROM fips10s 
WHERE fips4 = 'AS02'
  AND ST_within (ST_PointFromText ('POINT(141.433 -31.95)', 4326), geom);

INSERT INTO temp_tz (tzid, geom)
SELECT 'Australia/Sydney', geom
FROM fips10s
WHERE fips4 = 'AS02'
  AND NOT ST_within (ST_PointFromText ('POINT(141.433 -31.95)', 4326), geom)
  AND NOT ST_intersects (geom, ST_PolygonFromText ('POLYGON((158 -31,
                                                           160 -31, 
                                                           160 -32, 
                                                           158 -32,
                                                           158 -31))', 4326));

UPDATE temp_tz SET tzid = 'Australia/Sydney' WHERE fips4 = 'AS01';


------------------------------------------------------------ French Polynesia ---

-- Pacific/Gambier
--   the Gambier islands of French Polynesia

UPDATE temp_tz SET tzid = 'Pacific/Gambier'
WHERE fips2 = 'FP'
  AND ST_within (geom, ST_PolygonFromText ('POLYGON((-137.5 -20.5, 
                                                  -134.0 -20.5,
                                                  -134.0 -24.5,
                                                  -137.5 -24.5,
                                                  -137.5 -20.5))', 4326));

-- Pacific/Marquesas
--   the Marquesas islands of French Polynesia

UPDATE temp_tz SET tzid = 'Pacific/Marquesas'
WHERE fips2 = 'FP'
  AND ST_within (geom, ST_PolygonFromText ('POLYGON((-142 -7,
                                                  -142 -11.5,
                                                  -138 -11.5,
                                                  -138 -7,
                                                  -142 -7))', 4326));

-- Pacific/Tahiti
--   the rest of French Polynesia

UPDATE temp_tz SET tzid = 'Pacific/Tahiti'
WHERE fips2 = 'FP'
  AND tzid = 'unknown';

------------------------------------------------------------ Marshall Islands ---

-- Pacific/Kwajalein
--   the Kwajalein Atoll

--   ** unclear whether it should only be the islands leased by the US
--   or the whole atoll

UPDATE temp_tz SET tzid = 'Pacific/Kwajalein'
WHERE fips2 = 'RM'
  AND ST_within (geom, ST_PolygonFromText ('POLYGON((166.6 9.5, 
                                                  168   9.5,
                                                  168   8.5,
                                                  166.6 8.5, 
                                                  166.6 9.5))', 4326));

-- Pacific/Majuro
--   the rest of the Marshall Islands

UPDATE temp_tz SET tzid = 'Pacific/Majuro'
WHERE tzid = 'unknown'
  AND fips2 = 'RM';

------------------------------------------------------------------- Greenland ---

INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_greenland_mask.geom))),
       tz_greenland_mask.tzid, fips10s.fips2, fips10s.fips4
FROM fips10s, tz_greenland_mask
WHERE fips10s.fips2 = 'GL'
  AND ST_intersects (fips10s.geom, tz_greenland_mask.geom);

---------------------------------------------------------------------- Russia ---

UPDATE temp_tz SET tzid = 'Europe/Kaliningrad'
WHERE fips4 = 'RS23';

UPDATE temp_tz SET tzid = 'Europe/Volgograd'
WHERE fips4 = 'RS07'
   OR fips4 = 'RS33'
   OR fips4 = 'RS67'
   OR fips4 = 'RS84'; 

UPDATE temp_tz SET tzid = 'Europe/Samara'
WHERE fips4 = 'RS65'
   OR fips4 = 'RS80';

UPDATE temp_tz SET tzid = 'Asia/Yekaterinburg'
WHERE fips4 = 'RS08'
   OR fips4 = 'RS35'
   OR fips4 = 'RS40'
   OR fips4 = 'RS55'
   OR fips4 = 'RS58'
   OR fips4 = 'RS71'
   OR fips4 = 'RS78'
   OR fips4 = 'RS32'
   OR fips4 = 'RS13'
   OR fips4 = 'RS87';

UPDATE temp_tz SET tzid = 'Asia/Omsk'
WHERE fips4 = 'RS03'
   OR fips4 = 'RS04'
   OR fips4 = 'RS54';

UPDATE temp_tz SET tzid = 'Asia/Novosibirsk'
WHERE fips4 = 'RS53'
   OR fips4 = 'RS75';

UPDATE temp_tz SET tzid = 'Asia/Novokuznetsk'
WHERE fips4 = 'RS29';

UPDATE temp_tz SET tzid = 'Asia/Krasnoyarsk'
WHERE fips4 = 'RS39'
   OR fips4 = 'RS74'
   OR fips4 = 'RS79'
   OR fips4 = 'RS31'
   OR fips4 = 'RS18'; 

UPDATE temp_tz SET tzid = 'Asia/Irkutsk'
WHERE fips4 = 'RS11'
   OR fips4 = 'RS20'
   OR fips4 = 'RS82'; 

INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_russia_mask.geom))), 
       tz_russia_mask.tzid, 'RS', 'RS63'
FROM fips10s, tz_russia_mask
WHERE fips10s.fips4 = 'RS63' 
  AND ST_intersects (fips10s.geom, tz_russia_mask.geom);

INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_russia_mask.geom))), 
       tz_russia_mask.tzid, 'RS', 'RS64'
FROM fips10s, tz_russia_mask
WHERE fips10s.fips4 = 'RS64' 
  AND ST_intersects (fips10s.geom, tz_russia_mask.geom);

UPDATE temp_tz SET tzid = 'Asia/Yakutsk'
WHERE fips4 = 'RS02'
   OR fips4 = 'RS05'
   OR fips4 = 'RS14'; 

UPDATE temp_tz SET tzid = 'Asia/Vladivostok'
WHERE fips4 = 'RS89'
   OR fips4 = 'RS30'
   OR fips4 = 'RS59';


UPDATE temp_tz SET tzid = 'Asia/Magadan'
WHERE fips4 = 'RS44';

UPDATE temp_tz SET tzid = 'Asia/Kamchatka'
WHERE fips4 = 'RS26'
   OR fips4 = 'RS36';

UPDATE temp_tz SET tzid = 'Asia/Anadyr'
WHERE fips4 = 'RS15';

UPDATE temp_tz SET tzid = 'Europe/Moscow'
WHERE tzid = 'unknown'
  AND fips2 = 'RS';

----------------------------------------------------------------------- Spain ---

UPDATE temp_tz SET tzid = 'Atlantic/Canary'
WHERE fips4 = 'SP53';

UPDATE temp_tz SET tzid = 'Africa/Ceuta'
WHERE fips4 = 'SP';

UPDATE temp_tz SET tzid = 'Europe/Madrid'
WHERE tzid = 'unknown' 
  AND fips2 = 'SP';

--------------------------------------------------------------------- Ukraine ---

-- ** Follow WTE; not sure how correct this is

UPDATE temp_tz SET tzid = 'Europe/Uzhgorod'
WHERE fips4 = 'UP25';

UPDATE temp_tz SET tzid = 'Europe/Moscow'
WHERE fips4 = 'UP11';

UPDATE temp_tz SET tzid = 'Europe/Zaporozhye'
WHERE fips4 = 'UP26';

UPDATE temp_tz SET tzid = 'Europe/Kiev'
WHERE tzid = 'unknown'
  AND fips2 = 'UP';

------------------------------------------------------------------ Antarctica ---

-- we have a separate map for the bases

UPDATE temp_tz SET tzid = 'uninhabited'
WHERE fips2 = 'AY';

---------------------------------------------------------------------- Brazil ---


-- BR16
-- BR04
INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_brazil_mask.geom))), 
       tz_brazil_mask.tzid, fips10s.fips2, fips10s.fips4
FROM fips10s, tz_brazil_mask
WHERE fips10s.fips4 = tz_brazil_mask.fips4
  AND ST_intersects (fips10s.geom, tz_brazil_mask.geom);

UPDATE temp_tz SET tzid = 'America/Belem'
WHERE fips4 = 'BR03';

UPDATE temp_tz SET tzid = 'America/Fortaleza'
WHERE fips4 = 'BR13'
   OR fips4 = 'BR20'
   OR fips4 = 'BR06'
   OR fips4 = 'BR22'
   OR fips4 = 'BR17'; 

UPDATE temp_tz SET tzid = 'America/Recife'
WHERE fips4 = 'BR30';

UPDATE temp_tz SET tzid = 'America/Araguaina'
WHERE fips4 = 'BR31';

UPDATE temp_tz SET tzid = 'America/Maceio'
WHERE fips4 = 'BR28'
   OR fips4 = 'BR02';

UPDATE temp_tz SET tzid = 'America/Bahia'
WHERE fips4 = 'BR05';

UPDATE temp_tz SET tzid = 'America/Sao_Paulo'
WHERE fips4 = 'BR29'
   OR fips4 = 'BR07'
   OR fips4 = 'BR15'
   OR fips4 = 'BR08'
   OR fips4 = 'BR21'
   OR fips4 = 'BR27'
   OR fips4 = 'BR18'
   OR fips4 = 'BR26'
   OR fips4 = 'BR23';

UPDATE temp_tz SET tzid = 'America/Campo_Grande'
WHERE fips4 = 'BR11';

UPDATE temp_tz SET tzid = 'America/Cuiaba'
WHERE fips4 = 'BR14';

UPDATE temp_tz SET tzid = 'America/Porto_Velho'
WHERE fips4 = 'BR24';

UPDATE temp_tz SET tzid = 'America/Boa_Vista'
WHERE fips4 = 'BR25';

UPDATE temp_tz SET tzid = 'America/Rio_Branco'
WHERE fips4 = 'BR01';

-- uninhabited
--   Atlantic islands other than Fernando de Noronha, including
--   Trindade and Martin Vaz (ES), Atol das Rocas (RN) 
--   and Penedos de Sao Pedro e Sao Paulo (PE)
--   source: tz2008e/southamerica

UPDATE temp_tz SET tzid = 'uninhabited'
WHERE ST_within (geom, ST_PolygonFromText ('POLYGON((-33 -3.5, 
                                                  -34 -3.5,
                                                  -34 -4.5, 
                                                  -33 -4.5,
                                                  -33 -3.5))', 4326));

UPDATE temp_tz SET tzid = 'uninhabited'
WHERE ST_within (geom, ST_PolygonFromText ('POLYGON((-31 -19, 
                                                  -28 -19,
                                                  -28 -21, 
                                                  -31 -21,
                                                  -31 -19))', 4326));
-- America/Noronha

UPDATE temp_tz SET tzid = 'America/Noronha'
WHERE ST_within (geom, ST_PolygonFromText ('POLYGON((-32 -3.5,
                                                  -33 -3.5,
                                                  -33 -4.5, 
                                                  -32 -4.5, 
                                                  -32 -3.5))', 4326));

----------------------------------------------------------------------- Chile ---

UPDATE temp_tz SET tzid = 'Pacific/Easter'
WHERE fips2 = 'CI'
  AND ST_within (geom, ST_PolygonFromText ('POLYGON((-110 -28,
                                                  -108 -28, 
                                                  -108 -26, 
                                                  -110 -26,
                                                  -110 -28))', 4326));

UPDATE temp_tz SET tzid = 'America/Santiago'
WHERE tzid = 'unknown'
  AND fips2 = 'CI';

------------------------------------------------------------------------- USA ---

-- Guantamo Bay is on Eastern time
UPDATE temp_tz SET TZID = 'America/New_York'
WHERE fips4 = 'US_A';

INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_us_mask.geom))), 
       tz_us_mask.tzid, 'US', ''
FROM fips10s, tz_us_mask
WHERE fips10s.fips2 = 'US'
  AND ST_intersects (fips10s.geom, tz_us_mask.geom);

---------------------------------------------------------------------- Canada ---

INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_canada_mask.geom))), 
       tz_canada_mask.tzid, fips10s.fips2, fips10s.fips4
FROM fips10s, tz_canada_mask
WHERE fips10s.fips4 = tz_canada_mask.fips4
  AND ST_intersects (fips10s.geom, tz_canada_mask.geom);

----------------------------------------------------------------------- China ---

INSERT INTO temp_tz (geom, tzid, fips2, fips4)
SELECT geom (ST_Dump (ST_Intersection (fips10s.geom, tz_china_mask.geom))), 
       tz_china_mask.tzid, fips10s.fips2, fips10s.fips4
FROM fips10s, tz_china_mask
WHERE fips10s.fips2 = 'CH'
  AND ST_intersects (fips10s.geom, tz_china_mask.geom);

-------------------------------------------------------------- simplification ---

DROP TABLE tz_world;

CREATE TABLE tz_world (tzid text);

SELECT addgeometrycolumn ('tz_world', 'geom', 4326, 'POLYGON', 2);

INSERT INTO tz_world (tzid, geom)
  SELECT tzid, h AS geom FROM (
    SELECT tzid AS tzid, (ST_Dump (g)).geom AS h FROM (
      SELECT tzid AS tzid, ST_Union (geom) AS g
      FROM temp_tz
      GROUP by tzid)
    as x)
  as y;



DROP TABLE temp_tz;


------------------------------------------------- multipolygon/polygon version ---

DROP TABLE tz_world_mp;

CREATE TABLE tz_world_mp (tzid  text);

SELECT AddGeometryColumn ('tz_world_mp', 'geom', '4326', 'GEOMETRY', 2);

INSERT INTO tz_world_mp (tzid, geom)
SELECT tzid AS tzid, ST_Union (geom) as geom
FROM tz_world
GROUP by tzid;

EOF

pgsql2shp -g geom -f tz_world geo tz_world

pgsql2shp -g geom -f tz_world_mp geo tz_world_mp


#---- for the snapshot

rm -f tz_world_robinson.{shp,shx,dbf,prj}

ogr2ogr -s_srs '+proj=latlong' -t_srs '+proj=robin' \
    tz_world_robinson.shp tz_world.shp
