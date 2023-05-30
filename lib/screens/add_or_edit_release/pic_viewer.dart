import 'package:flutter/material.dart';

import '../../domain/entities/release_picture.dart';
import '../../domain/enums/picture_type.dart';
import '../../widgets/picture_type_selection.dart';
import '../../widgets/preview_pic.dart';

typedef OnSetSelectedPicIndex = void Function(int selectedPicIndex);

class PicViewer extends StatefulWidget {
  const PicViewer({
    super.key,
    required this.selectedPicIndex,
    required this.pictures,
    required this.saveDir,
    required this.setSelectedPicIndex,
    required this.onPictureTypeChanged,
  });
  final int selectedPicIndex;
  final List<ReleasePicture> pictures;
  final String saveDir;
  final OnSetSelectedPicIndex setSelectedPicIndex;
  final ValueChanged<PictureType> onPictureTypeChanged;

  @override
  State<StatefulWidget> createState() {
    return _PicViewerState();
  }
}

class _PicViewerState extends State<PicViewer> {
  late int selectedPicIndex;

  @override
  void initState() {
    super.initState();
    selectedPicIndex = widget.selectedPicIndex;
  }

  void prevPic() {
    setState(() {
      selectedPicIndex--;
    });
    widget.setSelectedPicIndex(selectedPicIndex);
  }

  void nextPic() {
    setState(() {
      selectedPicIndex++;
    });
    widget.setSelectedPicIndex(selectedPicIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
            width: 100,
            child: selectedPicIndex > 0
                ? PreviewPic(
                    releasePicture: widget.pictures[selectedPicIndex - 1],
                    saveDirPath: widget.saveDir,
                    picTapped: prevPic,
                  )
                : null),
        Expanded(
          child: widget.pictures.isNotEmpty
              ? PictureTypeSelection(
                  onValueChanged: widget.onPictureTypeChanged,
                  releasePicture: widget.pictures[selectedPicIndex],
                  saveDirPath: widget.saveDir,
                )
              : const Icon(
                  Icons.image,
                  size: 150,
                ),
        ),
        SizedBox(
          width: 100,
          child: widget.pictures.length > 1 &&
                  selectedPicIndex < widget.pictures.length - 1
              ? PreviewPic(
                  releasePicture: widget.pictures[selectedPicIndex + 1],
                  saveDirPath: widget.saveDir,
                  picTapped: nextPic,
                )
              : null,
        ),
      ],
    );
  }
}
