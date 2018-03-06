#!/bin/sh

function readStatus()
{
	sudo /usr/sbin/i2cget -y 1 0x5a 0x0 w
}

while true
do
	readStatus
done

