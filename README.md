# film_freak

*film_freak* is WIP name for my collection management app which is mostly focusing on managing a movie collection but might support other types of media in future (games, music, books, comics etc).

Click image to see video of WIP version:

<a href="https://www.youtube.com/watch?v=czIBQMUGwhk"><img src="https://lh3.googleusercontent.com/S-dSDK1nRnyJlx3nZD2pf0AAgu1vQ4O7pBZ1QqHVsoi2kt-Hj_rK1bdOaGEBWktHqB1igO1EgBqVnwK_sKl7IS7-3ghHRYeMvXG2BQAeixdzeFz2jTUzG3jASCHvYuFktSFeer9j9hC6IYNYFPKM4G4xTqZ-Yx6egd-ZrM4skxu_0FJq3vjS2dOdv5p8qGgpkb8qj2qj90SYXO6Po0WwFeXoOaUVJY50wGOGMHUx90kWsKMfTWJxZmNjF9vqS0usajyisZzztxHMpOxxeQ4vfCyGuiq-zZi30gG52pyClA0RPz-X-pLappzDxajQbRjF0qx4a9r02utlMl_L1yQWPxZo3dofbJ3nWBKqgjDav3VnfO9aTTXMVdxhrBlJctVjAoeMPHzSfIfk8e_eBGtcLuQ68CqcS-zY5JryOZicvJteQ76Jz8Z1UbOTMA1PufDa1F7lmhvYQ4yVbmQVr34KZg3YQpytFOa8KywdP764kbRCv9VaX0ir1mFNkEN0s9RoUAngpFKdOaLF7QTMAvxtEFNffsFJPY_w1mouqpxp71goxgdZlYdFgZMeHk28H5kMpjyxjxUEMMCAiw8QPtE7qC2vY2KMkBO696ywcnZNlUghXz44gRp8LWKTqb7U-Iblaqn40DHc0kFpNX-tvvYsHzHU39s1pskF2khTHQuL7lBTTTwFUGwcD2-jSgHuDNEndgDfy9EHy6iZBm08uYf4G2jVOalib9bN35Sp0YuofqUcy4gBeYbiyS6dIKVYEMtUT7Vivo6BmG3Ny4rjd33dnpi8eU0SFHriTROuRcKjvMLSD_diFq2FMlyVCzZlMGV6goMzi0qfHWKYUD_fczAlg3sPA7z37gTHgvLHoyojf7mPKP3VgZSWnUMomH1-xSiOMB-gnL_RuYPFe1o0rJDssLuksZiFB0sXFqtW6sMZ3VmOhQ=w1095-h651-no?authuser=0" alt="View in YouTube" width="300px"/></a>

## Technology

It's implemented with [Flutter SDK](https://flutter.dev/) using [Dart](https://dart.dev/) programming language. This is my first serious attempt with Flutter and I must say I'm quite impressed with it. I really enjoy developing with Flutter and Dart.

Currently data is saved to a local [SQLite](https://www.sqlite.org) database but I'm planning implementing a data synchronization with a cloud database (at that phase user accounts will be supported as well).

One of the features I've been focusing from the start is using [Google ML Kit](https://developers.google.com/ml-kit) to recognize text from images and implementing a widget to fill textual form fields by selecting text from a image.

[Firebase Remote Config](https://firebase.google.com/docs/remote-config) is used for storing configurations such as API keys.

Currently developing this only for Android target since possible to test only with Android devices.

## Features

Some of the features currently implemented are:
- Search or add collection items by scanning a barcode using system camera
- Use system camera to add images to collection item
- Fill text fields by selecting text from active image 
    - Text from image can be selected by blocks of text or by words
- Select quadrilateral (four sided polygon) from image and translate it to a rectangle with selected aspect ratio (based on collection item case type)
- Assign different kind of properties for collection item
- Fill in the basic info related to collection item (such as release name, media type, case type and condition)
- Store items to local database
