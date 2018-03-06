#!/bin/sh

function readBaseline()
{
	let addr=0x04+$1*2
	sudo /usr/sbin/i2cget -y 1 0x5a $addr w
}

while true
do
	for i in `seq 0 11`
	do
		echo -n `readBaseline $i`" "
	done
	echo
done

