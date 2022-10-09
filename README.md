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

        ---

        Exception has occurred.

    \_AssertionError ('package:flutter/src/material/dropdown.dart': Failed assertion: line 1580 pos 15: 'items == null || items.isEmpty || value == null ||
    items.where((DropdownMenuItem<T> item) {
    return item.value == value;
    }).length == 1': There should be exactly one item with [DropdownButton]'s value: Instance of 'MediaTypeFormField'.
    Either zero or 2 or more [DropdownMenuItem]s were detected with the same value)
