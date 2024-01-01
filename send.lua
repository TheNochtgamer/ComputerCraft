local modem = peripheral.find("modem") or error("No modem attached", 0)
modem.transmit(99, 99, table.concat(arg, " "))
