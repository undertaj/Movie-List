import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Data {

  String movieName;
  String directorName;
  XFile pickedImage;

  Data({required this.movieName, required this.directorName, required this.pickedImage});
}