import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ShowProductImage extends StatelessWidget {
  final XFile? imageXFile; //package image_picker

  const ShowProductImage({super.key, required this.imageXFile});

  @override
  Widget build(BuildContext context) {
    //   return Padding(
    //     padding: const EdgeInsets.only(bottom: 24),
    //     child: Center(
    //       child: SizedBox(
    //         width: 200,
    //         height: 200,
    //         child: ClipRRect(
    //           borderRadius: BorderRadius.circular(12.0),
    //           child: Image.file(imageFile),
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return SizedBox(
        height: MediaQuery.of(context).size.width * 0.4,
        width: MediaQuery.of(context).size.width * 0.8,
        child: Center(
            child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0), //Added a radius
                    image: DecorationImage(
                      image: FileImage(File(imageXFile!.path)),
                      fit: BoxFit.cover,
                    ),
                  ),
                ))));
  }
}
