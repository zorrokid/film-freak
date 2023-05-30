import 'package:film_freak/screens/add_or_edit_release/pic_viewer.dart';
import 'package:flutter/material.dart';
import '../domain/enums/picture_type.dart';
import '../domain/entities/release_picture.dart';

class PicturesCard extends StatefulWidget {
  const PicturesCard(
      {super.key, required this.pictures, required this.saveDir});
  final List<ReleasePicture> pictures;
  final String saveDir;

  @override
  State<PicturesCard> createState() {
    return _PicturesCardState();
  }
}

class _PicturesCardState extends State<PicturesCard> {
  late int _selectedPicIndex;

  @override
  void initState() {
    super.initState();
    _selectedPicIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          PicViewer(
              selectedPicIndex: _selectedPicIndex,
              pictures: widget.pictures,
              saveDir: widget.saveDir,
              setSelectedPicIndex: (int index) => setState(() {
                    _selectedPicIndex = index;
                  }),
              onPictureTypeChanged: (PictureType? pictureType) {}),
          Row(
            children: [
              widget.pictures.isNotEmpty
                  ? Text('${_selectedPicIndex + 1}/${widget.pictures.length}')
                  : Container()
            ],
          ),
        ],
      ),
    );
  }
}
