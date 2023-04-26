import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_compress/video_compress.dart';
import 'package:videofilecomp/progress.dart';

import 'button.dart';
import 'compressapi.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? fileVideo;
  Uint8List? thumbnailBytes;
  MediaInfo? compressVideoInfo;
  int? videoSize;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Compress"),centerTitle: true,
      actions: [TextButton(onPressed: clearSelection, child: Text('Clear', style: TextStyle(color: Colors.black),))],),
        body: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(40),
      child: BuildContent(),
    ));
  }

  Widget BuildContent() {
    if (fileVideo == null) {
      return MyButton(text: 'Pick Video', onClicked: pickVideo);
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildThumbnail(),
          const SizedBox(
            height: 24,
          ),
          buildVideoInfo(),
          const SizedBox(
            height: 24,
          ),
          buildVideoCompressedInfo(),
          const SizedBox(
            height: 24,
          ),
          MyButton(text: 'Compress Video', onClicked: compressVideo)
        ],
      );
    }
  }

  Widget buildVideoCompressedInfo() {
    if (compressVideoInfo == null) return Container();
    final size = compressVideoInfo!.filesize! / 1000;

    return Column(
      children: [
        const Text(
          'Compressed Video info ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8,),
        Text('Size: $size KB', style: const TextStyle(fontSize: 20),),
        const SizedBox(height: 8,),
        Text('${compressVideoInfo!.path}',textAlign: TextAlign.center,)
      ],
    );
  }

  Widget buildThumbnail() => thumbnailBytes == null
      ? CircularProgressIndicator()
      : Image.memory(
          thumbnailBytes!,
          height: 200,
        );

  Widget buildVideoInfo() {
    if (videoSize == null) return Container();
    final fsize = videoSize! / 1000;

    return Column(
      children: [
        const Text(
          'Original Video info ',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Size: $fsize KB',
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  void clearSelection()=>setState(() {
    compressVideoInfo =null;
    fileVideo =null;
  });

  Future pickVideo() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getVideo(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final file = File(pickedFile.path);

    setState(
      () => fileVideo = file,
    );

    generateThumbnail(fileVideo!);

    getVideoSize(fileVideo!);
  }

  Future generateThumbnail(File file) async {
    final thumbnailBytes = await VideoCompress.getByteThumbnail(file.path);
    setState(
      () => this.thumbnailBytes = thumbnailBytes,
    );
  }

  Future getVideoSize(File file) async {
    final size = await file.length();

    setState(() => videoSize = size);
  }

  Future compressVideo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
              child: ProgressDialogWidget(),
            ));
    final info = await VideoCompressApi.compressVideo(fileVideo!);

    setState(
      () => compressVideoInfo = info,
    );

    Navigator.of(context).pop();
  }
}
