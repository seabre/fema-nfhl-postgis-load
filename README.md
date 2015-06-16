# FEMA NFHL PostGIS Load

Load FEMA National Flood Hazard Layer (NFHL) data into PostGIS.

The FEMA Flood Map Service Center makes it really hard to download data in bulk. This allows you to download the NFHL data for all states/territories.

## Requirements

To support the ESRI GDB file format, you need a version of GDAL that supports it.

For ubuntu you can do:

```bash
sudo add-apt-repository ppa:ubuntugis/ubuntugis-unstable
sudo apt-get install gdal-bin
```

## Configuration

`download.sh` assumes you already have a PostGIS database named `gis` already created. It also automatically a creates a table named `floodplain` to load the data. By default, it pulls in the `S_Fld_Haz_Ar` table from the GDB file database.

If you wish to change this, the following variables in `download.sh`:
  * `gis_database`
  * `gis_table`
  * `gdb_table`

## Running

Assuming you have all the requirements in place, run `./download.sh` and it will pull in the data into PostGIS.

## License

This project is under the MIT license. See `LICENSE` for details.
