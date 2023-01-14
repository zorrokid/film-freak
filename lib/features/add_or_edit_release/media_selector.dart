import 'package:film_freak/enums/media_type.dart';
import 'package:film_freak/widgets/form/dropdown_form_field.dart';
import 'package:flutter/material.dart';

typedef OnAddMedia = void Function(int pcs, MediaType mediaType);
typedef OnCancel = void Function();

class MediaSelector extends StatefulWidget {
  final OnAddMedia onAddMedia;
  final VoidCallback onCancel;
  const MediaSelector(
      {super.key, required this.onAddMedia, required this.onCancel});
  @override
  State<StatefulWidget> createState() {
    return _MediaSelectorState();
  }
}

class _MediaSelectorState extends State<MediaSelector> {
  late int _count;
  late MediaType _mediaType;

  @override
  void initState() {
    super.initState();
    _count = 0;
    _mediaType = MediaType.unknown;
  }

  void increase() => setState(() {
        _count++;
      });

  void decrease() {
    if (_count == 0) return;
    setState(() {
      _count--;
    });
  }

  void setMediaType(MediaType? mediaType) => setState(() {
        _mediaType = mediaType ?? MediaType.unknown;
      });

  void onAdd() {
    if (_mediaType == MediaType.unknown || _count == 0) return;
    widget.onAddMedia(_count, _mediaType);
  }

  void onCancel() => widget.onCancel();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                iconSize: 42,
                onPressed: decrease,
                icon: const Icon(Icons.remove),
              ),
              Text('$_count'),
              IconButton(
                iconSize: 42,
                onPressed: increase,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          DropdownFormField(
            initialValue: _mediaType,
            labelText: 'Media type',
            onValueChange: setMediaType,
            values: mediaTypeFormFieldValues,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                onPressed: onCancel,
                icon: const Icon(Icons.cancel),
                iconSize: 42,
              ),
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.done),
                iconSize: 42,
              )
            ],
          )
        ],
      ),
    );
  }
}
