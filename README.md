Smart Meters are regarded as a key component of Smart Grids allowing precise measurements of consumption and thereby as a second step steering of consumers with respect to the available energy produced (demand side management).
While the theory sounds good, convincing business cases are still missing. Smart Meters are a costly investment and currently do not yield a significant return of it. So why go out and buy one?
Technically interested people might not ask such questions and are interested in measuring their energy consumption just for the sake of seeing the exact values. However, they are not willing to spend much money on it.
Retro-fitting the existing energy meter is an appropriate means to reach that aim.

After browsing the Internet I found that Volkszähler is the right place to find information to realize your personal Smart Meter project.
Energienetze Bayern provided me with an EMH-ITZ meter which has two IR LEDs on the front side for read-out and is supported by the Volkszähler IR-USB reader device.

Instead of soldering one on my own I contacted Udo and made demands on his Lötservice. After some emails which where quickly responded, paying 35,08€ via Paypal and three days of waiting time I received the device.

While mounting the device was an easy job (via magnet ring with cable to lower), connecting it to my Raspberry PI and putting it into into operation was a bit tricky. The distance in cable length between the IR reader and the PI is about 5 meters in my environment. Therefore I chose an active USB cable and powered up the USB ports of the PI via appending the following to /boot/config.txt:

max_usb_current=1

The IR reader is recognized under /dev/ttyUSB0 which firstly has to be configured:
sudo minicom -s
- Serial port setup
- under A- Serial Device: /dev/ttyUSB0
- under E- Bps/Par/Bits: 300 7E1
- under F- Hardware Flow Control: No
- under G- Software Flow Control: No
- Save setup as df1
- Exit

Secondly the device must be queried to receive the meter data: see d0test.sh

Thirdly a more advanced script should periodically read out the meter and extract the pure numbers of the relevant values for further use in applications such as openHAB.

chmod a+x d0read.sh

Via crontab -e add:
- SHELL=/bin/bash
- PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
- \#\# m h  dom mon dow   command
- @reboot /bin/bash /home/pi/lesekopf/d0read.sh
