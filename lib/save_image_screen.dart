import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:save_image_sqlite_flutter/DBHelper.dart';
import 'package:save_image_sqlite_flutter/Photo.dart';
import 'package:save_image_sqlite_flutter/Utility.dart';

class SaveImageSqlite extends StatefulWidget {
  SaveImageSqlite() : super();
  final String title = "Flutter Save Image To SQLite Demo";
  @override
  _SaveImageSqliteState createState() => _SaveImageSqliteState();
}

class _SaveImageSqliteState extends State<SaveImageSqlite> {
  Future<File> imageFile;
  Image image;
  DBHelper dbHelper;
  List<Photo> images;
  @override
  void initState() {
    super.initState();
    images = [];
    dbHelper = DBHelper();
    refreshImage();
  }

  refreshImage() {
    dbHelper.getPhotos().then((imgs) {
      setState(() {
        print(imgs.length);
        images.clear();
        images.addAll(imgs);
        print("images= " + images.length.toString());
      });
    });
  }

  pickImageFromGallery() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((imageFile) {
      String imgString = Utility.base64String(imageFile.readAsBytesSync());
      Photo photo = Photo(id: 0, photoName: imgString);
      dbHelper.save(photo);
      refreshImage();
    });
  }

  gridView() {
    return Padding(
      padding: EdgeInsets.all(5),
      child: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        children: images.map((photo) {
          return Utility.imageFromBase64String(photo.photoName);
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              pickImageFromGallery();
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Flexible(
              child: gridView(),
            ),
          ],
        ),
      ),
    );
  }
}
