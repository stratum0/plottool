plottool
========

This script is intended to be used with a HPGL plotter/cutter connected over a
serial port.

It will split the file into blocks <=10kB to prevent the plotter from choking on data,
as long as data is waiting, the tool will resume with the next part after user input.

This script has been tested with a Cogi CT-630 cutting plotter @Stratum0:
https://stratum0.org/wiki/Cogi_CT-630

Dependencies
------------

For Debian-based Linux distributions (Ubuntu, Mint): `sudo apt-get install
python-serial python-wxgtk-3.0 python-numpy` (Sorry, no Python 3 support until
a Python 3-compatible release of wxPython lands in Debian.)

For Arch Linux: `sudo pacman -S python-numpy python-pyserial`, and install
`wxpython-phoenix-git` from AUR.

Usage
-----

usage is simple:

```./plottool file.hpgl``` will simply print the data to ```/dev/ttyUSB0```

```./plottool -p /dev/ttyUSB4 file.hpgl``` will do the same but to port ```/dev/ttyUSB4```
