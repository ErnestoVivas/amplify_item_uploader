import 'dart:convert';
import 'dart:io';

import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:amplify_item_uploader/amplify_controller.dart' as amplify_controller;
import 'package:file_picker/file_picker.dart';

import 'models/DragAndDropQuestion.dart';
import 'models/MultipleChoiceQuestion.dart';
import 'models/OrderItemsExercise.dart';
import 'models/SingleChoiceQuestion.dart';
import 'models/SingleImageChoiceQuestion.dart';
import 'models/TrueFalseQuestion.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amplify Item Uploader',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Amplify Item Uploader'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool _amplifyConfigured = false;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _configureAmplify());
  }

  @override
  Widget build(BuildContext context) {
    if(!_amplifyConfigured) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => _uploadSingleChoiceItems(),
                child: const Text('Upload Single Choice Items')
              ),
              ElevatedButton(
                onPressed: () => _uploadSingleImageItems(),
                child: const Text('Upload Single Image Items')
              ),
              ElevatedButton(
                onPressed: () => _uploadMultipleChoiceItems(),
                child: const Text('Upload Multiple Choice Items')
              ),
              ElevatedButton(
                onPressed: () => _uploadTrueFalseItems(),
                child: const Text('Upload True False Items')
              ),
              ElevatedButton(
                onPressed: () => _uploadDragAndDropItems(),
                child: const Text('Upload Drag And Drop Items')
              ),
              ElevatedButton(
                onPressed: () => _uploadOrderItemsItems(),
                child: const Text('Upload Order Items Items')
              ),
            ]
          ),
        ),
      );
    }
  }

  void _uploadSingleChoiceItems() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if(result != null) {
      File scItemsFile = File(result.files.single.path!);
      String singleChoiceItems = scItemsFile.readAsStringSync();
      List<String> scItems = singleChoiceItems.split('\n');
      int scItemCounter = 0;
      for(int i = 0; i < scItems.length; ++i) {
        if(scItems[i].isNotEmpty) {
          ++scItemCounter;
          Map<String, dynamic> scAsJson = json.decode(scItems[i]);
          SingleChoiceQuestion newScQuestion = SingleChoiceQuestion.fromJson(scAsJson);

          try {
            //await Amplify.DataStore.save(newScQuestion);
            final request = ModelMutations.create(newScQuestion);
            final response = await Amplify.API.mutate(request: request).response;
            if(response.data != null) {
              print('succesfully saved sc question');
            }
          } on ApiException catch (e) {
            print('Something went wrong saving model: ${e.message}');
          }
          print(newScQuestion.toString());
        }
      }
      print(scItemCounter);
    }
  }

  void _uploadSingleImageItems() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File sicItemsFile = File(result.files.single.path!);
      String singleImageItems = sicItemsFile.readAsStringSync();
      List<String> sicItems = singleImageItems.split('\n');
      int sicItemCounter = 0;
      for(int i = 0; i < sicItems.length; ++i) {
        if(sicItems[i].isNotEmpty) {
          ++sicItemCounter;
          Map<String, dynamic> sicAsJson = json.decode(sicItems[i]);
          SingleImageChoiceQuestion newSicQuestion = SingleImageChoiceQuestion.fromJson(sicAsJson);

          try {
            //await Amplify.DataStore.save(newScQuestion);
            final request = ModelMutations.create(newSicQuestion);
            final response = await Amplify.API.mutate(request: request).response;
            if(response.data != null) {
              print('succesfully saved sic question');
            }
          } on ApiException catch (e) {
            print('Something went wrong saving model: ${e.message}');
          }
          print(newSicQuestion.toString());
        }
      }
      print(sicItemCounter);
    }
  }

  void _uploadMultipleChoiceItems() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File mcItemsFile = File(result.files.single.path!);
      String multipleChoiceItems = mcItemsFile.readAsStringSync();
      List<String> mcItems = multipleChoiceItems.split('\n');
      int mcItemCounter = 0;
      for(int i = 0; i < mcItems.length; ++i) {
        if(mcItems[i].isNotEmpty) {
          ++mcItemCounter;
          Map<String, dynamic> mcAsJson = json.decode(mcItems[i]);
          MultipleChoiceQuestion newMcQuestion = MultipleChoiceQuestion.fromJson(mcAsJson);

          try {
            //await Amplify.DataStore.save(newScQuestion);
            final request = ModelMutations.create(newMcQuestion);
            final response = await Amplify.API.mutate(request: request).response;
            if(response.data != null) {
              print('succesfully saved sic question');
            }
          } on ApiException catch (e) {
            print('Something went wrong saving model: ${e.message}');
          }
          print(newMcQuestion.toString());
        }
      }
      print(mcItemCounter);
    }
  }

  void _uploadTrueFalseItems() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File tfItemsFile = File(result.files.single.path!);
      String trueFalseItems = tfItemsFile.readAsStringSync();
      List<String> tfItems = trueFalseItems.split('\n');
      int tfItemCounter = 0;
      for(int i = 0; i < tfItems.length; ++i) {
        if(tfItems[i].isNotEmpty) {
          ++tfItemCounter;
          Map<String, dynamic> tfAsJson = json.decode(tfItems[i]);
          TrueFalseQuestion newTfQuestion = TrueFalseQuestion.fromJson(tfAsJson);

          try {
            //await Amplify.DataStore.save(newTfQuestion);
            final request = ModelMutations.create(newTfQuestion);
            final response = await Amplify.API.mutate(request: request).response;
            if(response.data != null) {
              print('succesfully saved tf question');
            }
          } on ApiException catch (e) {
            print('Something went wrong saving model: ${e.message}');
          }
          print(newTfQuestion.toString());
        }
      }
      print(tfItemCounter);
    }
  }

  void _uploadDragAndDropItems() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File ddItemsFile = File(result.files.single.path!);
      String dragAndDropItems = ddItemsFile.readAsStringSync();
      List<String> ddItems = dragAndDropItems.split('\n');
      int ddItemCounter = 0;
      for(int i = 0; i < ddItems.length; ++i) {
        if(ddItems[i].isNotEmpty) {
          ++ddItemCounter;
          Map<String, dynamic> ddAsJson = json.decode(ddItems[i]);
          DragAndDropQuestion newDDQuestion = DragAndDropQuestion.fromJson(ddAsJson);

          try {
            //await Amplify.DataStore.save(newScQuestion);
            final request = ModelMutations.create(newDDQuestion);
            final response = await Amplify.API.mutate(request: request).response;
            if(response.data != null) {
              print('succesfully saved dd question');
            }
          } on ApiException catch (e) {
            print('Something went wrong saving model: ${e.message}');
          }
          print(newDDQuestion.toString());
        }
      }
      print(ddItemCounter);
    }
  }

  void _uploadOrderItemsItems() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      File oieItemsFile = File(result.files.single.path!);
      String orderItemsItems = oieItemsFile.readAsStringSync();
      List<String> oieItems = orderItemsItems.split('\n');
      int oieItemCounter = 0;
      for(int i = 0; i < oieItems.length; ++i) {
        if(oieItems[i].isNotEmpty) {
          Map<String, dynamic> oieAsJson = json.decode(oieItems[i]);
          ++oieItemCounter;
          OrderItemsExercise newOIQuestion = OrderItemsExercise.fromJson(oieAsJson);
          try {
            //await Amplify.DataStore.save(newScQuestion);
            final request = ModelMutations.create(newOIQuestion);
            final response = await Amplify.API.mutate(request: request).response;
            if(response.data != null) {
              print('succesfully saved oi question');
            }
          } on ApiException catch (e) {
            print('Something went wrong saving model: ${e.message}');
          }
          print(newOIQuestion.toString());
        }
      }
      print(oieItemCounter);
    }
  }

  void _configureAmplify() async {
    await amplify_controller.configureAmplify();
    setState(() => _amplifyConfigured = true);
  }
}
