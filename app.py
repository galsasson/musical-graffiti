#!/usr/bin/python

import Adafruit_GPIO as GPIO
import Adafruit_MPR121.MPR121 as MPR121
import time, os, threading


gpio = GPIO.get_platform_gpio()
IRQ_PIN = "XIO-P0"
cap = MPR121.MPR121()

def irqCallback(channel):
	print cap.touched()


def init():
	if not cap.begin():
		print('Error initializing MPR121')

	gpio.setup(IRQ_PIN, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)
	gpio.add_event_detect(IRQ_PIN, GPIO.RISING, irqCallback)

def loop():
	time.sleep(0.001)
	print cap.touched()
	

def cleanup():
	gpio.cleanup()





def main():
	try:
		init()

		print('Press Ctrl-C to quit.')
		while True :
			loop()
			time.sleep(0.01667)


	except KeyboardInterrupt:
		cleanup()


if __name__ == '__main__':
    main()


