
import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../utils/Data.dart';
import '../utils/routes.dart';
import 'dart:async';

typedef OnPickImageCallback = void Function();


class HomePage extends StatefulWidget {

  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _picker = ImagePicker();
  dynamic _pickImageError;
  final formKey = GlobalKey<FormState>();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  final nameController = TextEditingController();

  final directorController = TextEditingController();

  final _add = PanelController();

  final List<XFile> _imageFileList = [];
  final List<Data> data = [];
  late final XFile pickedFile;

  String? _retrieveDataError;


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    if (kDebugMode) {
      print(user.displayName);
      print(user.photoURL);
      print(user.email);
    }

    return SlidingUpPanel(
      minHeight: 0,
      backdropEnabled: true,
      backdropTapClosesPanel: true,
      controller: _add,
      panel: Scaffold(


        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Movie Name",
                      labelText: "Movie Name",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if(value!.isEmpty || !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)){
                        return 'Enter correct full name';
                      }else {
                        return null;
                      }
                    }

                ),
                SizedBox(height: 15,),
                TextFormField(
                    controller: directorController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter director Name",
                      labelText: "Director's Name",
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if(value!.isEmpty || !RegExp(r'^[a-zA-Z ]+$').hasMatch(value)){
                        return 'Enter correct full name';
                      }else {
                        return null;
                      }
                    }

                ),
                ElevatedButton(
                  onPressed: () async {
                    pickedFile = (await _picker.pickImage(source: ImageSource.gallery,))!;
                    //_onImageButtonPressed(ImageSource.gallery, context: context);
                    //null;
                  },

                  child: const Icon(Icons.photo),
                ),
                ElevatedButton(
                  onPressed: () {

                    data.add(Data(
                        movieName: nameController.text.toString(),
                        directorName: directorController.text.toString(),
                        pickedImage: pickedFile)
                    );
                    setState(() {
                      _add.close();
                    });
                    },
                  child: Text("Add")
                ),
              ],
            ),
          ),
        ),
      ),
      body: Scaffold(
        drawer: Drawer(
          child:Column(
                  children: [
                  SizedBox(height: 30),
                  Text("Welcome\nSigned in as:"),
                  SizedBox(height: 8),

                  // CircleAvatar(
                  //   radius: 40,
                  //   backgroundImage: NetworkImage(user.photoURL!),
                  // ),
                  SizedBox(height: 8),
                  // Text(
                  //   'Name:  ${user.displayName!}',
                  //   style: const TextStyle(
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.bold
                  //   ),
                  // ),
                  SizedBox(height: 8),
                  Text(
                  'Email:  ${user.email!}',
                  style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
              ),
              ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, MyRoutes.loginRoute);
                  },
                  child: Text('Sign out'))
            ],
          ),
        ),
        appBar: AppBar(
          title: const Text("Movie List"),
          centerTitle: true,
          actions: [
            FloatingActionButton(
              onPressed: () => _add.open(),
              child: const Icon(Icons.add),
            ),
          ],

        ),

        body: (data.length != 0) ?
        ListView.builder(
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(

                child: ListTile(

                  title: Container(
                    height: 150,
                    width: 100,
                    child: Row(
                      children: [
                        Text("${data[index].movieName} \n${data[index].directorName}"),
                        Image.file(File(data[index].pickedImage.path))
                      ],
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        data.remove(data[index]);
                      });
                    },
                  ),
                ),
              ),
            );
          },

        )
            : const Scaffold(),

      ),
    );
  }

  @override
  void dispose() {
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }
}
