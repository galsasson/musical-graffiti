#!/bin/sh

echo "Hello!!!"

MPR121_I2CADDR_DEFAULT=0x5A
MPR121_TOUCHSTATUS_L=0x00
MPR121_TOUCHSTATUS_H=0x01
MPR121_FILTDATA_0L=0x04
MPR121_FILTDATA_0H=0x05
MPR121_BASELINE_0=0x1E
MPR121_MHDR=0x2B
MPR121_NHDR=0x2C
MPR121_NCLR=0x2D
MPR121_FDLR=0x2E
MPR121_MHDF=0x2F
MPR121_NHDF=0x30
MPR121_NCLF=0x31
MPR121_FDLF=0x32
MPR121_NHDT=0x33
MPR121_NCLT=0x34
MPR121_FDLT=0x35

MPR121_TOUCHTH_0=0x41
MPR121_RELEASETH_0=0x42
MPR121_DEBOUNCE=0x5B
MPR121_CONFIG1=0x5C
MPR121_CONFIG2=0x5D
MPR121_CHARGECURR_0=0x5F
MPR121_CHARGETIME_1=0x6C
MPR121_ECR=0x5E
MPR121_AUTOCONFIG0=0x7B
MPR121_AUTOCONFIG1=0x7C
MPR121_UPLIMIT=0x7D
MPR121_LOWLIMIT=0x7E
MPR121_TARGETLIMIT=0x7F

MPR121_GPIODIR=0x76
MPR121_GPIOEN=0x77
MPR121_GPIOSET=0x78
MPR121_GPIOCLR=0x79
MPR121_GPIOTOGGLE=0x7A

function writeRegister()
{
	echo -n "writing $1=$2... "
	sudo /usr/sbin/i2cset -y 1 0x5a $1 $2
	echo "ok"
}

function readRegister()
{
	sudo /usr/sbin/i2cget -y 1 0x5a $1
}

function setThresholds()
{
	echo "Setting thresholds ($1, $2)"
	for i in `seq 0 11`
	do
		let tr=$MPR121_TOUCHTH_0+2*$i
		let rr=$MPR121_RELEASETH_0+2*$i
		writeRegister $tr $1
		writeRegister $rr $2
	done
}

writeRegister $MPR121_SOFTRESET 0x63
sleep 0.1

writeRegister $MPR121_ECR 0x0
c=`readRegister $MPR121_CONFIG2`
echo "MPR121_CONFIG2 = $c"

setThresholds 24 12
writeRegister $MPR121_MHDR 0x01
writeRegister $MPR121_NHDR 0x01
writeRegister $MPR121_NCLR 0x0E
writeRegister $MPR121_FDLR 0x00

writeRegister $MPR121_MHDF 0x01
writeRegister $MPR121_NHDF 0x05
writeRegister $MPR121_NCLF 0x01
writeRegister $MPR121_FDLF 0x00

writeRegister $MPR121_NHDT 0x00
writeRegister $MPR121_NCLT 0x00
writeRegister $MPR121_FDLT 0x00

writeRegister $MPR121_DEBOUNCE 0
#writeRegister $MPR121_CONFIG1 0x10 # default, 16uA charge current
writeRegister $MPR121_CONFIG1 0x3f # 63uA charge current
writeRegister $MPR121_CONFIG2 0x20 # 0.5uS encoding, 1ms period

# enable all electrodes
writeRegister $MPR121_ECR 0x8F  # start with first 5 bits of baseline tracking

