import 'dart:io';

import 'package:film_freak/widgets/picture_type_viewer.dart';
import 'package:film_freak/widgets/preview_pic.dart';
import 'package:film_freak/widgets/spinner.dart';
import 'package:flutter/material.dart';

import '../../entities/release_picture.dart';
import '../../utils/directory_utils.dart';
import '../../widgets/error_display_widget.dart';

class PicturesCard extends StatefulWidget {
  const PicturesCard({super.key, required this.pictures});
  final List<ReleasePicture> pictures;
  @override
  State<PicturesCard> createState() {
    return _PicturesCardState();
  }
}

class _PicturesCardState extends State<PicturesCard> {
  late Future<Directory> _futureSaveDirectory;
  int _selectedPicIndex = 0;

  Future<Directory> _getSaveDirectory() async {
    return await getReleasePicsSaveDir();
  }

  @override
  void initState() {
    super.initState();
    _futureSaveDirectory = _getSaveDirectory();
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
    return FutureBuilder(
      future: _futureSaveDirectory,
      builder: (BuildContext context, AsyncSnapshot<Directory> snapshot) {
        if (snapshot.hasError) {
          return ErrorDisplayWidget(snapshot.error.toString());
        }
        if (!snapshot.hasData) {
          return const Spinner();
        }
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
                              saveDirPath: snapshot.data!.path,
                              picTapped: prevPic,
                            )
                          : Container()),
                  Expanded(
                    flex: 2,
                    child: widget.pictures.isNotEmpty
                        ? PictureTypeViewer(
                            releasePicture: widget.pictures[_selectedPicIndex],
                            saveDirPath: snapshot.data!.path,
                          )
                        : const Icon(
                            Icons.image,
                            size: 200,
                          ),
                  ),
                  Expanded(
                    flex: 1,
                    child: widget.pictures.length > 1 &&
                            _selectedPicIndex < widget.pictures.length - 1
                        ? PreviewPic(
                            releasePicture:
                                widget.pictures[_selectedPicIndex + 1],
                            saveDirPath: snapshot.data!.path,
                            picTapped: nextPic,
                          )
                        : Container(),
                  ),
                ],
              ),
              Row(
                children: [
                  widget.pictures.isEmpty
                      ? const Text('No pictures')
                      : Text(
                          '${_selectedPicIndex + 1}/${widget.pictures.length}'),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
