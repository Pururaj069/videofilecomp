import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:video_compress/video_compress.dart';

class ProgressDialogWidget extends StatefulWidget {
  const ProgressDialogWidget({super.key});

  @override
  State<ProgressDialogWidget> createState() => _ProgressDialogWidgetState();
}

class _ProgressDialogWidgetState extends State<ProgressDialogWidget> {
  late Subscription subscription;
  double? progress;

  @override
  void initState(){
    super.initState();

    subscription =VideoCompress.compressProgress$.subscribe((progress)=> setState(() => this.progress=progress,));
  }

  @override
  dispose(){
    VideoCompress.cancelCompression();
    subscription.unsubscribe();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final value = progress==null ? progress:progress!/100;
    return Padding(padding: EdgeInsets.all(20),
    child: Column(mainAxisSize: MainAxisSize.min,
    children: [
      const Text('Compressing video ....',
      style: TextStyle(fontSize: 20),),

      const SizedBox(height: 24,),
      LinearProgressIndicator(value: value,minHeight: 12,),
      const SizedBox(height: 16,),
      ElevatedButton(onPressed: ()=> VideoCompress.cancelCompression(), child: Text('cancle'))
    ],),);
  }
}