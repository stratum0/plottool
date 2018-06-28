plottool
========

This script is intended to be used with a HPGL plotter/cutter connected over a
serial port.

It will split the file into blocks <=10kB to prevent the plotter from choking on data,
as long as data is waiting, the tool will resume with the next part after user input.

This script has been tested with a Cogi CT-630 cutting plotter @Stratum0:
https://stratum0.org/wiki/Cogi_CT-630

It also works on macOS, but less reliably so prepare for occasional job cancellation.

Dependencies
------------

For Debian-based Linux distributions (Ubuntu, Mint): `sudo apt-get install
python-serial python-wxgtk-3.0 python-numpy` (Sorry, no Python 3 support until
a Python 3-compatible release of wxPython lands in Debian.)

For Arch Linux: `sudo pacman -S python-numpy python-pyserial`, and install
`wxpython-phoenix-git` from AUR.

For macOS you can use `homebrew` and `pip` to install the dependencies: `pip install numpy pyserial && brew install wxpython`.

Usage
-----

usage is simple:

```./plottool file.hpgl``` will simply print the data to ```/dev/ttyUSB0```

```./plottool -p /dev/ttyUSB4 file.hpgl``` will do the same but to port ```/dev/ttyUSB4```

Note that on macOS, tty-devices follow another naming convention. Look for something like `/dev/tty.usbserial-14430` or `/dev/cu.usbserial-14430`. [Both should work equally](https://stackoverflow.com/q/37688257), but some users reported better results with one or the other.
