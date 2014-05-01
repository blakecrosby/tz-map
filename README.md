#Introduction#

Eric Muller (http://efele.net/maps/tz/world/) originally created the awesome Shape file of time zones. This essentially allows you to look up a time zone based on geographic coordinates (lat/long). 

Why would you want to do this?

- You can convert times/dates displayed on your website in the users local time
- You can use it as part of a validation scheme (make sure the users computer time zone is the same as you expect, and they are not using a proxy or VPN)
- Notify a user if their local time zone setting may be incorrect
- Show a cool map of what the world looks like with time zone boundaries instead of political ones.

If decided to fork his work so that I can keep the data up to date on my own cycle. As well, I have plans to turn this into a shared library that can be used elsewhere.

#The Data#
The shape file contains just one field. The "name" of the time zone as found in IANA's Time Zone Database (http://www.iana.org/time-zones). This means that you will have to work with strings such as "America/Toronto" or "Australia/Sydney". 

It's up to you to then convert that time zone name into a proper numerical offset from UTC. This can usually be done with your language of choice and your operating systems local version of the ```zoneinfo``` database.

##Update Frequency##
I try to update the data as soon as IANA does. They announce updates via their mailing list, and versions are numbered based on the year. So for example: ```2014b``` would be the second version released in 2014. It's usually updated around once a month. 

#Gimme my shapefile!#
You can find the latest version of the shape file in this repo (in the ```output``` subdirectory):

- World: https://github.com/blakecrosby/tz-map/tree/master/world/output
  - ```tz_world.*``` contains individual polygons for every region. (1 record per region)
  - ```tz_world_mp.*``` contains multipolygons for every region. (1 record per time zone)
  - ```tz_world_robinson``` is the tz_world shape in Robinson Projection (for display purposes)
- Antarctica: https://github.com/blakecrosby/tz-map/tree/master/antarctica/output
  - This shapefile contains POINTS and not areas. This is because the region is dotted by research stations and not actual areas. Keep this in mind when trying to run a Postgis query against this data set.

#Contact#
Please feel free to contact me (me@blakecrosby.com) if you have any questions. I encourage pull requests to update the database if you find any errors.
