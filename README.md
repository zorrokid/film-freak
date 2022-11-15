# film_freak

*film_freak* is WIP name for my collection management app which is mostly focusing on managing a movie collection but might support other types of media in future (games, music, books, comics etc).

## Technology

It's implemented with [Flutter SDK](https://flutter.dev/) using [Dart](https://dart.dev/) programming language. This is my first serious attempt with Flutter and I must say I'm quite impressed with it. I really enjoy developing with Flutter and Dart.

Currently data is saved to a local [SQLite](https://www.sqlite.org) database but I'm planning implementing a data synchronization with a cloud database (at that phase user accounts will be supported as well).

One of the features I've been focusing from the start is using [Google ML Kit](https://developers.google.com/ml-kit) to recognize text from images and implementing a widget to fill textual form fields by selecting text from a image.

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