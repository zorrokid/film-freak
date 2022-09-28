# film_freak

# Debugging over wi-fi

-   Set "use wireless debuggin" on from your device

-   connect device with USB

    $ adb devices
    List of devices attached
    R3CT30KJA0L device

    $ adb tcpip 5555
    restarting in TCP mode port: 5555

-   get the device IP from device settings

    e.g. 192.168.32.4

    adb connect 192.168.32.4
    connected to 192.168.32.4:5555
