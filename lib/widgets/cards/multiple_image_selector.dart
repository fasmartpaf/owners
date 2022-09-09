import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/custom_grid_view.dart';
import 'package:fuodz/widgets/custom_image.view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:velocity_x/velocity_x.dart';

class MultipleImageSelectorView extends StatefulWidget {
  const MultipleImageSelectorView({this.photos, this.onImagesSelected, Key key})
      : super(key: key);

  final List<String> photos;
  final Function(List<File>) onImagesSelected;

  @override
  _MultipleImageSelectorViewState createState() =>
      _MultipleImageSelectorViewState();
}

class _MultipleImageSelectorViewState extends State<MultipleImageSelectorView> {
  //
  List<File> selectedFiles;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return VStack(
      [
        //
        Visibility(
          visible: showImageUrl() && !showSelectedImage(),
          child: CustomGridView(
            noScrollPhysics: true,
            dataSet: widget.photos,
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            itemBuilder: (context, index) {
              final photo = widget.photos[index];
              return CustomImage(
                imageUrl: photo ?? "",
              ).h20(context).wFull(context);
            },
          ),
        ),
        //
        showSelectedImage()
            ? CustomGridView(
              noScrollPhysics: true,
                dataSet: selectedFiles ?? [],
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                itemBuilder: (context, index) {
                  final file = selectedFiles[index];
                  return Image.file(
                    file,
                    fit: BoxFit.cover,
                  ).h20(context).wFull(context);
                },
              )
            : UiSpacer.emptySpace(),
        //
        Visibility(
          // visible: !showImageUrl() && !showSelectedImage(),
          visible: true,
          child: CustomButton(
            title: "Select a photo",
            onPressed: pickNewPhoto,
          ).centered(),
        ),
      ],
    )
        .wFull(context)
        .box
        .clip(Clip.antiAlias)
        .border(color: context.accentColor)
        .roundedSM
        .outerShadow
        .make()
        .onTap(pickNewPhoto);
  }

  bool showImageUrl() {
    return widget.photos != null && widget.photos.isNotEmpty;
  }

  bool showSelectedImage() {
    return selectedFiles != null;
  }

  //
  pickNewPhoto() async {
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        selectedFiles = pickedFiles.map((e) => File(e.path)).toList();
      });
      //
      widget.onImagesSelected(selectedFiles);
      showSelectedImage();
    }
  }
}
