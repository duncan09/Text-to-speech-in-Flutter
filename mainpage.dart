import 'dart:io';

import 'package:chaquopy/chaquopy.dart';
import 'package:flutter/material.dart';
import 'package:text_to_speech/utils/colors.dart';
import 'package:file_picker/file_picker.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String fileType = 'All';
  var fileTypeList = ['All', 'docx', 'pdf', 'doc', 'txt'];

  FilePickerResult? result;
  PlatformFile? file;
  String code=
  "import pyttsx3\n"
  "import PyPDF2 as pd\n"
  "book=open(file)\n"
  "pdfReader=pd.PdfFileReader(book,'rb')\npages=pdfReader.numPages\n"
  "speaker=pyttsx3.init()\n"
  "voices=speaker.getProperty('voices')\n"
  "speaker.setProperty('voice',voices[1].id)\n"
  "for num in range(pages):\n"
  "try:\n"
    "page=pdfReader.getPage(num)\n"
    "page_text=page.extractText()\n"
    "pdfReader.say(page_text)\n"
    "pdfReader.runAndWait()\n"
  "except:\n"
  "pass";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: red,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
        ),
        centerTitle: true,
        title: Text("Home",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                )),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.person))],
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/monster.jpg",
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Selected File Type",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white),
                    ),
                  ),
                  DropdownButton(
                    dropdownColor: purple,
                    value: fileType,
                    items: fileTypeList.map((String type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          type,
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        fileType = value!;
                        file = null;
                      });
                    },
                  ),
                ]),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30, vertical: 30)),
                ElevatedButton(
                  onPressed: () async {
                    pickFiles(fileType);
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(250, 80),
                      primary: red,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      maximumSize: Size(250, 50)),
                  child: Text(
                    "Select File",
                    style:
                        TextStyle(fontSize: 25),
                  ),
                ),
                if (file != null) fileDetails(file!),
                if (file != null)
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: Size(150, 50),
                          primary: red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          maximumSize: Size(250, 50)),
                      onPressed: () async{
                        await Chaquopy.executeCode(code);
                      },
                      child: Text("Read",
                          style: TextStyle(
                              fontSize: 18)))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget fileDetails(PlatformFile file) {
    final kb = file.size / 1024;
    final mb = kb / 1024;
    final size = (mb >= 1)
        ? '${mb.toStringAsFixed(2)} MB'
        : '${kb.toStringAsFixed(2)} KB';
    return Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'File Name: ${file.name}',
              style: TextStyle(color: Colors.white),
            ),
            Text('File Size: $size', style: TextStyle(color: Colors.white)),
            Text('File Extension: ${file.extension}',
                style: TextStyle(color: Colors.white)),
            Text('File Path: ${file.path}',
                style: TextStyle(color: Colors.white)),
          ],
        ));
  }

  Future readFile(PlatformFile file) async{
    await Chaquopy.executeCode(
      '''import pyttsx3
      import PyPDF2 as pd

      book=open(file)
      pdfReader=pd.PdfFileReader(book,'rb')
      pages=pdfReader.numPages
      speaker=pyttsx3.init()
      voices=speaker.getProperty('voices')
      speaker.setProperty('voice',voices[1].id)
      textList=[]
      for num in range(pages):
        try:
          page=pdfReader.getPage(num)
          page_text=page.extractText()
          pdfReader.say(page_text)
          pdfReader.runAndWait()
        except:
          print("No file found")'''
    );
  }

  void pickFiles(String? fileType) async {
    switch (fileType) {
      case 'pdf':
        result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'doc':
        result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['doc']);
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'docx':
        result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['docx']);
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'All':
        result = await FilePicker.platform.pickFiles();
        if (result == null) return;
        file = result!.files.first;
        setState(() {});
        break;
      case 'txt':
        result = await FilePicker.platform
            .pickFiles(type: FileType.custom, allowedExtensions: ['txt']);
        if (result == null) return;
        break;
    }
  }
}
