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
  bool _uploadingExercises = false;
  List<String> _uploadItemsFeedback = [];
  String setKey = '';

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
                onPressed: () => _uploadExerciseSet(),
                child: const Text('Upload Exercise Set')
              ),
              Container(
                height: 64,
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _uploadingExercises ? 'Saving set $setKey to production' : 'No upload to production in progress'
                    ),
                    if(_uploadingExercises)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: const CircularProgressIndicator()
                      )
                  ]
                )
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: ListView(
                    children: [
                      for(int i = 0; i < _uploadItemsFeedback.length; ++i) ... [
                        Text(_uploadItemsFeedback[i])
                      ]
                    ]
                  )
                )
              )
            ]
          ),
        ),
      );
    }
  }


  Future<void> _uploadExerciseSet() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      setState(() {
        _uploadItemsFeedback.clear();
        _uploadingExercises = true;
      });
      File exerciseSetFile = File(result.files.single.path!);
      String exerciseSetJsonStr = exerciseSetFile.readAsStringSync();
      Map<String, dynamic> exerciseSetJson = json.decode(exerciseSetJsonStr);

      // single choice questions
      if(exerciseSetJson.containsKey('singleChoiceQuestions')) {
        List<SingleChoiceQuestion> existentScQuestions = await amplify_controller.querySingleChoiceQuestions(exerciseSetJson['singleChoiceQuestions'][0]['exerciseSet']);
        bool scQuestionsExist = (existentScQuestions.isNotEmpty) ? true : false;
        if(scQuestionsExist) {
          await amplify_controller.deleteItems(existentScQuestions);
          setState(() { _uploadItemsFeedback.add('Deleted old single choice questions'); });
        }
        List<dynamic> scQuestions = exerciseSetJson['singleChoiceQuestions'];
        for(dynamic scQuestion in scQuestions) {
          SingleChoiceQuestion newScQuestion = SingleChoiceQuestion.fromJson(scQuestion);
          await saveNewScItem(newScQuestion);
        }
      }

      // single image choice questions
      if(exerciseSetJson.containsKey('singleImageChoiceQuestions')) {
        List<SingleImageChoiceQuestion> existentSicQuestions = await amplify_controller.querySingleImageChoiceQuestions(exerciseSetJson['singleImageChoiceQuestions'][0]['exerciseSet']);
        bool sicQuestionsExist = (existentSicQuestions.isNotEmpty) ? true : false;
        if(sicQuestionsExist) {
          await amplify_controller.deleteItems(existentSicQuestions);
          setState(() { _uploadItemsFeedback.add('Deleted old single image choice questions'); });
        }

        List<dynamic> sicQuestions = exerciseSetJson['singleImageChoiceQuestions'];
        for(dynamic sicQuestion in sicQuestions) {
          SingleImageChoiceQuestion newSicQuestion = SingleImageChoiceQuestion.fromJson(sicQuestion);
          await saveNewSicItem(newSicQuestion);
        }
      }

      // multiple choice questions
      if(exerciseSetJson.containsKey('multipleChoiceQuestions')) {

        List<MultipleChoiceQuestion> existentMcQuestions = await amplify_controller.queryMultipleChoiceQuestions(exerciseSetJson['multipleChoiceQuestions'][0]['exerciseSet']);
        bool mcQuestionsExist = (existentMcQuestions.isNotEmpty) ? true : false;
        if(mcQuestionsExist) {
          await amplify_controller.deleteItems(existentMcQuestions);
          setState(() { _uploadItemsFeedback.add('Deleted old multiple choice questions'); });
        }
        List<dynamic> mcQuestions = exerciseSetJson['multipleChoiceQuestions'];
        for(dynamic mcQuestion in mcQuestions) {
          MultipleChoiceQuestion newMcQuestion = MultipleChoiceQuestion.fromJson(mcQuestion);
          await saveNewMcItem(newMcQuestion);
        }
      }

      // true false questions
      if(exerciseSetJson.containsKey('trueFalseQuestions')) {
        List<TrueFalseQuestion> existentTfQuestions = await amplify_controller.queryTrueFalseQuestions(exerciseSetJson['trueFalseQuestions'][0]['exerciseSet']);
        bool tfQuestionsExist = (existentTfQuestions.isNotEmpty) ? true : false;
        if(tfQuestionsExist) {
          await amplify_controller.deleteItems(existentTfQuestions);
          setState(() { _uploadItemsFeedback.add('Deleted old true false questions'); });
        }

        List<dynamic> tfQuestions = exerciseSetJson['trueFalseQuestions'];
        for(dynamic tfQuestion in tfQuestions) {
          TrueFalseQuestion newTfQuestion = TrueFalseQuestion.fromJson(tfQuestion);
          await saveNewTfItem(newTfQuestion);
        }
      }

      // drag and drop questions
      if(exerciseSetJson.containsKey('dragAndDropQuestions')) {
        List<DragAndDropQuestion> existentDDQuestions = await amplify_controller.queryDragAndDropQuestions(exerciseSetJson['dragAndDropQuestions'][0]['exerciseSet']);
        bool ddQuestionsExist = (existentDDQuestions.isNotEmpty) ? true : false;
        if(ddQuestionsExist) {
          await amplify_controller.deleteItems(existentDDQuestions);
          setState(() { _uploadItemsFeedback.add('Deleted old drag and drop questions'); });
        }

        List<dynamic> ddQuestions = exerciseSetJson['dragAndDropQuestions'];
        for(dynamic ddQuestion in ddQuestions) {
          DragAndDropQuestion newDDQuestion = DragAndDropQuestion.fromJson(ddQuestion);
          await saveNewDDItem(newDDQuestion);
        }
      }

      // order items exercises
      if(exerciseSetJson.containsKey('orderItemsExercises')) {
        List<OrderItemsExercise> existentOieExercises = await amplify_controller.queryOrderItemsExercises(exerciseSetJson['orderItemsExercises'][0]['exerciseSet']);
        bool oieExercisesExist = (existentOieExercises.isNotEmpty) ? true : false;
        if(oieExercisesExist) {
          await amplify_controller.deleteItems(existentOieExercises);
          setState(() { _uploadItemsFeedback.add('Deleted old order items exercises'); });
        }

        List<dynamic> oieExercises = exerciseSetJson['orderItemsExercises'];
        for(dynamic oieExercise in oieExercises) {
          OrderItemsExercise newOieExercise = OrderItemsExercise.fromJson(oieExercise);
          await saveNewOieItem(newOieExercise);
        }
      }
      print('\n\n');
      setState(() => _uploadingExercises = false);
    }
  }


  Future<void> saveNewScItem(SingleChoiceQuestion newScItem) async {
    try {
      SingleChoiceQuestion newScQuestion = SingleChoiceQuestion(
        exerciseSet: newScItem.exerciseSet,
        question: newScItem.question,
        equation: newScItem.equation,
        image: newScItem.image,
        answer0: newScItem.answer0,
        answer1: newScItem.answer1,
        answer2: newScItem.answer2,
        answer3: newScItem.answer3,
        hint: newScItem.hint,
        solution: newScItem.solution
      );
      await Amplify.DataStore.save(newScQuestion);
      setState(() {
        _uploadItemsFeedback.add('Saved new ${newScQuestion.runtimeType}');
      });
    } catch(e) {
      safePrint('Something went wrong saving model: $e');
      setState(() {
        _uploadItemsFeedback.add('Failed to save ${newScItem.runtimeType}');
      });
    }
  }

  Future<void> saveNewSicItem(SingleImageChoiceQuestion newSicItem) async {
    try {
      SingleImageChoiceQuestion newSicQuestion = SingleImageChoiceQuestion(
        exerciseSet: newSicItem.exerciseSet,
        question: newSicItem.question,
        equation: newSicItem.equation,
        image0: newSicItem.image0,
        image1: newSicItem.image1,
        image2: newSicItem.image2,
        image3: newSicItem.image3,
        hint: newSicItem.hint,
        solution: newSicItem.solution,
      );
      await Amplify.DataStore.save(newSicQuestion);
      setState(() {
        _uploadItemsFeedback.add('Saved new ${newSicQuestion.runtimeType}');
      });
    } catch(e) {
      safePrint('Something went wrong saving model: $e');
      setState(() {
        _uploadItemsFeedback.add('Failed to save ${newSicItem.runtimeType}');
      });
    }
  }

  Future<void> saveNewMcItem(MultipleChoiceQuestion newMcItem) async {
    try {
      MultipleChoiceQuestion newMcQuestion = MultipleChoiceQuestion(
        exerciseSet: newMcItem.exerciseSet,
        question: newMcItem.question,
        equation: newMcItem.equation,
        image: newMcItem.image,
        answers: newMcItem.answers,
        numCorrectAnswers: newMcItem.numCorrectAnswers,
        hint: newMcItem.hint,
        solution: newMcItem.solution
      );
      await Amplify.DataStore.save(newMcQuestion);
      setState(() {
        _uploadItemsFeedback.add('Saved new ${newMcQuestion.runtimeType}');
      });
    } catch(e) {
      safePrint('Something went wrong saving model: $e');
      setState(() {
        _uploadItemsFeedback.add('Failed to save ${newMcItem.runtimeType}');
      });
    }
  }

  Future<void> saveNewTfItem(TrueFalseQuestion newTfItem) async {
    try {
      TrueFalseQuestion newTfQuestion = TrueFalseQuestion(
        exerciseSet: newTfItem.exerciseSet,
        question: newTfItem.question,
        equation: newTfItem.equation,
        image: newTfItem.image,
        isTrue: newTfItem.isTrue,
        hint: newTfItem.hint,
        solution: newTfItem.solution
      );
      await Amplify.DataStore.save(newTfQuestion);
      setState(() {
        _uploadItemsFeedback.add('Saved new ${newTfQuestion.runtimeType}');
      });
    } catch(e) {
      safePrint('Something went wrong saving model: $e');
      setState(() {
        _uploadItemsFeedback.add('Failed to save ${newTfItem.runtimeType}');
      });
    }
  }

  Future<void> saveNewDDItem(DragAndDropQuestion newDDItem) async {
    try {
      DragAndDropQuestion newDDQuestion = DragAndDropQuestion(
        exerciseSet: newDDItem.exerciseSet,
        question: newDDItem.question,
        typeListOne: newDDItem.typeListOne,
        typeListTwo: newDDItem.typeListTwo,
        listOne: newDDItem.listOne,
        listTwo: newDDItem.listTwo,
        tileSize: newDDItem.tileSize,
        isBucketExercise: newDDItem.isBucketExercise,
        bucketOne: newDDItem.bucketOne,
        bucketTwo: newDDItem.bucketTwo,
        hint: newDDItem.hint,
      );
      await Amplify.DataStore.save(newDDQuestion);
      setState(() {
        _uploadItemsFeedback.add('Saved new ${newDDQuestion.runtimeType}');
      });
    } catch(e) {
      safePrint('Something went wrong saving model: $e');
      setState(() {
        _uploadItemsFeedback.add('Failed to save ${newDDItem.runtimeType}');
      });
    }
  }

  Future<void> saveNewOieItem(OrderItemsExercise newOieItem) async {
    try {
      OrderItemsExercise newOieExercise = OrderItemsExercise(
        exerciseSet: newOieItem.exerciseSet,
        task: newOieItem.task,
        cloze: newOieItem.cloze,
        items: newOieItem.items,
        falseItems: newOieItem.falseItems,
        hint: newOieItem.hint
      );
      await Amplify.DataStore.save(newOieExercise);
      setState(() {
        _uploadItemsFeedback.add('Saved new ${newOieExercise.runtimeType}');
      });
    } catch(e) {
      safePrint('Something went wrong saving model: $e');
      setState(() {
        _uploadItemsFeedback.add('Failed to save ${newOieItem.runtimeType}');
      });
    }
  }

  Future<void> saveItem(Model newItem) async {
    try {
      await Amplify.DataStore.save(newItem);
      setState(() {
        _uploadItemsFeedback.add('Uploaded ${newItem.runtimeType}');
      });
    } catch(e) {
      print('Something went wrong saving model: $e');
      setState(() {
        _uploadItemsFeedback.add('Failed to upload ${newItem.runtimeType}');
      });
    }
  }


  void _configureAmplify() async {
    await amplify_controller.configureAmplify();
    setState(() => _amplifyConfigured = true);
  }
}
