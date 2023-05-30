import 'package:flutter/material.dart';
import '../widgets/picture_type_viewer.dart';
import '../widgets/preview_pic.dart';
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

  void prevPic() {
    if (_selectedPicIndex == 0) return;
    setState(() {
      _selectedPicIndex--;
    });
  }

  void nextPic() {
    if (_selectedPicIndex == widget.pictures.length - 1) {
      return;
    }
    setState(() {
      _selectedPicIndex++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: _selectedPicIndex > 0
                      ? PreviewPic(
                          releasePicture:
                              widget.pictures[_selectedPicIndex - 1],
                          saveDirPath: widget.saveDir,
                          picTapped: prevPic,
                        )
                      : Container()),
              Expanded(
                flex: 2,
                child: widget.pictures.isNotEmpty
                    ? PictureTypeViewer(
                        releasePicture: widget.pictures[_selectedPicIndex],
                        saveDirPath: widget.saveDir,
                      )
                    : const Icon(
                        Icons.image,
                        size: 150,
                      ),
              ),
              Expanded(
                flex: 1,
                child: widget.pictures.length > 1 &&
                        _selectedPicIndex < widget.pictures.length - 1
                    ? PreviewPic(
                        releasePicture: widget.pictures[_selectedPicIndex + 1],
                        saveDirPath: widget.saveDir,
                        picTapped: nextPic,
                      )
                    : Container(),
              ),
            ],
          ),
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
