import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:image_background_remover/image_background_remover.dart';
import 'package:your_drip/features/ImageCrop/image_picker.dart';

class ImagePicker extends StatefulWidget {
  const ImagePicker({super.key});

  @override
  State<ImagePicker> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker> {
  final ValueNotifier<ui.Image?> outImg = ValueNotifier<ui.Image?>(null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Background Remover')),    
      body: ValueListenableBuilder(
        valueListenable: ImagePickerService.pickedFile,
        builder: (context, image, _) {
          return GestureDetector(
            onTap: () async {
              await ImagePickerService.pickImage();
            },
            child: Container(
              alignment: Alignment.center,
              child: image == null
                  ? const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image, size: 100),
                        Text('No image selected.'),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Image.file(image),
                          const SizedBox(height: 20),
                          TextButton(
                            onPressed: () async {
                              outImg.value = await BackgroundRemover.instance
                                  .removeBg(image.readAsBytesSync());
                            },
                            child: const Text('Remove Background'),
                          ),
                          ValueListenableBuilder(
                            valueListenable: outImg,
                            builder: (context, img, _) {
                              return img == null
                                  ? const SizedBox()
                                  : FutureBuilder(
                                      future: img
                                          .toByteData(
                                            format: ui.ImageByteFormat.png,
                                          )
                                          .then(
                                            (value) =>
                                                value!.buffer.asUint8List(),
                                          ),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.done) {
                                          return Column(
                                            children: [
                                              Image.memory(snapshot.data!),
                                              FutureBuilder(
                                                future: BackgroundRemover
                                                    .instance
                                                    .addBackground(
                                                      image: snapshot.data!,
                                                      bgColor: Colors.orange,
                                                    ),
                                                builder: (context, snapshot) {
                                                  if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.waiting) {
                                                    return const CircularProgressIndicator();
                                                  } else if (snapshot
                                                          .connectionState ==
                                                      ConnectionState.done) {
                                                    return Image.memory(
                                                      snapshot.data!,
                                                    );
                                                  } else {
                                                    return const Text('Error');
                                                  }
                                                },
                                              ),
                                            ],
                                          );
                                        } else {
                                          return const Text('Error');
                                        }
                                      },
                                    );
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    BackgroundRemover.instance.dispose();
    super.dispose();
  }

  @override
  void initState() {
    BackgroundRemover.instance.initializeOrt();
    super.initState();
  }
}
