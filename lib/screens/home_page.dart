import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:async';
import 'package:tflite/tflite.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  PickedFile? _image;
  bool _loading = false;
  List<dynamic>? _outputs;

  void initState() {
    super.initState();
    _loading = true;

    loadModel().then((value) {
      setState(() {
        _loading = false;
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
    );
  }

  classifyImage(image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(output![0]['label']);
    if (output[0]["label"] == '1 E cell') {
      await launchUrl(Uri.parse('https://www.ecelliitbhu.com/'));
    }
    setState(() {
      _loading = false;
      _outputs = output;
    });
  }

  Future pickImage() async {
    var image = await _picker.getImage(source: ImageSource.gallery);
    if (image == null) return null;
    setState(() {
      _loading = true;
      _image = image;
    });
    classifyImage(image);
  }

  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: _loading
            ? Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              )
            : SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _image == null
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.45,
                          )
                        : SizedBox(
                            height: MediaQuery.of(context).size.height * 0.10,
                          ),
                    _image == null
                        ? const Text(
                            "Please scan any E-summit \n logo to proceed",
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 23),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Image.file(File(_image!.path)),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton.icon(
                      label: const Text(
                        "Take a Picture",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      icon: Icon(Icons.camera),
                      onPressed: openCamera,
                    ),
                    const Padding(padding: EdgeInsets.all(10.0)),
                    ElevatedButton.icon(
                      label: const Text(
                        "Upload from Gallery",
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                      icon: Icon(Icons.photo_album),
                      onPressed: openGallery,
                    )
                  ],
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Image.asset('assets/ecell_logo_dark.jpeg'),
      ),
    );
  }

  Future openCamera() async {
    var image = await _picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  Future openGallery() async {
    var piture = await _picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = piture;
    });
    classifyImage(piture);
  }
}
