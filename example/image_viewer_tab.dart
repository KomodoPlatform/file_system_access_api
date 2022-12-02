import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:file_system_access_api/file_system_access_api.dart';

class ImageViewerTab {
  HtmlElement get $view => querySelector("#viewer") as HtmlElement;

  ButtonElement get $btnOpenImage => $view.querySelector("button") as ButtonElement;
  ImageElement get $img => $view.querySelector("img") as ImageElement;

  Future<void> init() async {
    $btnOpenImage.onClick.listen(openImagePicker);
  }

  Future<void> openImagePicker(event) async {
    try {
      final handles = await window.showOpenFilePicker(
        excludeAcceptAllOption: true,
        types: [
          FilePickerAcceptType(description: "Images", accept: {
            "image/png+gif+jpg+webp": [".png", ".gif", ".jpg", ".webp"]
          })
        ],
      );
      final handle = handles.single;
      final file = await handle.getFile();
      final image = await loadImageAsBase64(file);

      showImage(image);
    } catch (error) {
      print(error);
    }
  }

  Future<String> loadImageAsBase64(File file) async {
    final reader = FileReader();
    final extension = file.name.substring(file.name.lastIndexOf(".") + 1);

    reader.readAsArrayBuffer(file);
    await reader.onLoad.first;

    Uint8List buffer = reader.result as Uint8List;
    return "data:image/$extension;base64,${base64Encode(buffer)}";
  }

  void showImage(String image) {
    $img.src = image;
    $img.style.display = "block";
  }
}