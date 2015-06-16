#!/bin/bash

gis_database="gis"
gis_table="floodplain"
gdb_table="S_Fld_Haz_Ar"
first_file=`cut -d , -f 2 femadownload.csv | head -1`


# Initialize table.
mkdir fematemp &&
wget -qO- -O fematemp/$first_file.zip https://hazards.fema.gov/nfhlv2/output/State/$first_file.zip &&
unzip fematemp/$first_file.zip -d fematemp &&
rm -rf fematemp/$first_file.zip &&
ogr2ogr -progress -f "ESRI Shapefile" fematemp/$first_file.shp -t_srs "EPSG:4326" "fematemp/$first_file.gdb" "$gdb_table" &&
rm -rf fematemp/$first_file.gdb &&
shp2pgsql -I -s 4326 fematemp/$first_file.shp $gis_table | sudo -u postgres psql -d $gis_database &&
rm -rf fematemp


# Initialize append table.
for fema_file in $(cut -d , -f 2 femadownload.csv | tail -n+2) ; do
  mkdir fematemp &&
  wget -qO- -O fematemp/$fema_file.zip https://hazards.fema.gov/nfhlv2/output/State/$fema_file.zip &&
  unzip fematemp/$fema_file.zip -d fematemp &&
  rm -rf fematemp/$fema_file.zip &&
  ogr2ogr -progress -f "ESRI Shapefile" fematemp/$fema_file.shp -t_srs "EPSG:4326" "fematemp/$fema_file.gdb" "$gdb_table" &&
  rm -rf fematemp/$fema_file.gdb &&
  shp2pgsql -a -s 4326 fematemp/$fema_file.shp $gis_table | sudo -u postgres psql -d $gis_database &&
  rm -rf fematemp
done
