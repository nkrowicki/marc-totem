# Use Raspbian as Website display

Proyect developed for Marc.

0. Start Raspbian (on Raspberry Pi)
1. Use the default user
2. Run this script
3. If necessary (due to an unresponsive dashboard or a superlarge screen), change the zoom factor on kiosk.sh file (1 = 100%, 0.5 = 50%, 2 = 200%)

Note: This software generates a file called 'kiosk.log' which contains events that happen (errors, warnings and information)

## How to install:
1. Open terminal and run the following command:

git clone https://github.com/nkrowicki/marc-totem.git && cd marc-totem/kiosk && sudo bash install.sh

2. Configure /home/pi/license.txt with the code license

3. (Optional) Install AnyDesk 

## How to reinstall:
Open terminal and run the following command: (replace "DIRECTORY" for the directory where the project is located)

cd DIRECTORY

sudo rm -rf marc-totem/

git clone https://github.com/nkrowicki/marc-totem.git && cd marc-totem/kiosk && sudo bash install.sh


## Developer contact

To contact the developer directly, email nahuelkrowicki@gmail.com
