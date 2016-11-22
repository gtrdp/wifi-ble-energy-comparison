"""
bluetooth-server.py

File to subscribe to the bluetooth phone and get the notification.

How it works:
- scan for LE devices and get its MAC address
- for each LE devices, list its services and characteristics UUID
- Find appropriate device with desired UUID characteristic
- Connect and subscribe to the device
- Wait for notification
"""

import struct
from bluepy.btle import Scanner, DefaultDelegate, UUID, Peripheral

# scanning delegate
# this class is needed to scan for LE device (done by delegate pattern)
class ScanDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

    def handleDiscovery(self, dev, isNewDev, isNewData):
        if isNewDev:
            print "Discovered device ", dev.addr
        elif isNewData:
            print "Received new data from", dev.addr

# a delegate to handle the notification
class NotificationDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

    def handleNotification(self, handle, data):
        print handle
        print data

def main():
    # uuid definition
    targetDevice = ""
    targetUUID   = UUID("08590f7e-db05-467e-8757-72f6f66666d4")
    # targetUUID   = UUID(0x2a2b)
    serviceUUID  = UUID("e20a39f4-73f5-4bc4-a12f-17d1ad666661")

    # scanning for Bluetooth LE device
    # P.S. root permission is needed
    print "scanning started..."
    scanner = Scanner().withDelegate(ScanDelegate())
    devices = scanner.scan(5)

    print "\n\nscanning completed...\n found %d device(s)\n" % len(devices)

    for dev in devices:
        print "Device %s (%s), RSSI=%d dB" % (dev.addr, dev.addrType, dev.rssi)
        for (adtype, desc, value) in dev.getScanData():
            print "  %s = %s" % (desc, value)

        try:
            p = Peripheral(dev.addr, "random")
            ch = p.getCharacteristics(uuid=targetUUID)
            if len(ch) > 0:
                print "the desired target found. the address is", dev.addr
                targetDevice = dev.addr
        except:
            # print "Unexpected error:", sys.exc_info()[0]
            print "Unable to connect"
            print " "
        finally:
            p.disconnect()

    # scanning completed, now continue to connect to device
    if targetDevice == "":
        # the target is not found. end.
        print "no target was found."
    else:
        # the target found, continue to subscribe.
        print "\n\nthe target device is ", targetDevice
        print "now try to subscribe..."

        try:
            # try to get the handle first
            p = Peripheral(targetDevice, "random")
            p.setDelegate(NotificationDelegate())
            # svc = p.getServiceByUUID(serviceUUID)
            ch = p.getCharacteristics(uuid=targetUUID)[0] # svc.getCharacteristics(targetUUID)[0]
            handle = ch.getHandle()
            print handle
            ch.write(struct.pack('<bb', 0x01, 0x00))
            # ch.write(bytes('aa', 'utf-8'))
            # p.writeCharacteristic(handle, struct.pack('<bb', 0x01, 0x00), True)

            print

            # Main loop
            while True:
                if p.waitForNotifications(5):
                    # handleNotification() was called
                    continue

                print "Waiting..."
                # Perhaps do something else here
        # except:
        #     print "Unexpected error:", sys.exc_info()[0]
        finally:
            p.disconnect()

if __name__ == "__main__":
    main()


# temp_uuid = UUID("08590f7e-db05-467e-8757-72f6f66666d4")
#
# p = Peripheral("5F:2E:63:05:CF:28", "random")
#
# try:
#     ch = p.getCharacteristics(uuid=temp_uuid)[0]
#     print ch.propertiesToString()
#
#     if (ch.supportsRead()):
#         print "yes it is now connected"
#
#         while 1:
#             print "the loop"
#             val = binascii.b2a_hex(ch.read())
#             val = binascii.unhexlify(val)
#             val = struct.unpack('f', val)[0]
#             print str(val)
#             time.sleep(1)
#     else:
#         print "it does not support reading"
# finally:
#     p.disconnect()