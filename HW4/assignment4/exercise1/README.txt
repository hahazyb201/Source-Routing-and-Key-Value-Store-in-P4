Be sure to replace all files in your assignment4_src with files in my exercise1 
In the directory ~/assignment4_src/
sudo mn -c
./run_demo.sh
xterm h1
xterm h3

in h3:
./receive.py
You will see message sent from h1 here.

in h1:
./send.py h1 h3
hello h3!!!
