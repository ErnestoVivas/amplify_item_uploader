/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'ContentReferences.dart';
import 'DragAndDropQuestion.dart';
import 'Feedback.dart';
import 'GeneralAppData.dart';
import 'MultipleChoiceQuestion.dart';
import 'OrderItemsExercise.dart';
import 'OverviewPage.dart';
import 'SingleChoiceQuestion.dart';
import 'SingleImageChoiceQuestion.dart';
import 'StripeInformation.dart';
import 'StudyStreamStudent.dart';
import 'StudyStreamTeacher.dart';
import 'Topic.dart';
import 'TrueFalseQuestion.dart';
import 'User.dart';
import 'Rating.dart';
import 'SetDetails.dart';
import 'TopicCategories.dart';

export 'ContentReferences.dart';
export 'DragAndDropQuestion.dart';
export 'Feedback.dart';
export 'GeneralAppData.dart';
export 'MultipleChoiceQuestion.dart';
export 'OrderItemsExercise.dart';
export 'OverviewPage.dart';
export 'Rating.dart';
export 'SetDetails.dart';
export 'SingleChoiceQuestion.dart';
export 'SingleImageChoiceQuestion.dart';
export 'StripeInformation.dart';
export 'StudyStreamStudent.dart';
export 'StudyStreamTeacher.dart';
export 'TileSize.dart';
export 'Topic.dart';
export 'TopicCategories.dart';
export 'TrueFalseQuestion.dart';
export 'User.dart';

class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "2f2a4d5a202de28af9ec382196568d0b";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [ContentReferences.schema, DragAndDropQuestion.schema, Feedback.schema, GeneralAppData.schema, MultipleChoiceQuestion.schema, OrderItemsExercise.schema, OverviewPage.schema, SingleChoiceQuestion.schema, SingleImageChoiceQuestion.schema, StripeInformation.schema, StudyStreamStudent.schema, StudyStreamTeacher.schema, Topic.schema, TrueFalseQuestion.schema, User.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [Rating.schema, SetDetails.schema, TopicCategories.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "ContentReferences":
        return ContentReferences.classType;
      case "DragAndDropQuestion":
        return DragAndDropQuestion.classType;
      case "Feedback":
        return Feedback.classType;
      case "GeneralAppData":
        return GeneralAppData.classType;
      case "MultipleChoiceQuestion":
        return MultipleChoiceQuestion.classType;
      case "OrderItemsExercise":
        return OrderItemsExercise.classType;
      case "OverviewPage":
        return OverviewPage.classType;
      case "SingleChoiceQuestion":
        return SingleChoiceQuestion.classType;
      case "SingleImageChoiceQuestion":
        return SingleImageChoiceQuestion.classType;
      case "StripeInformation":
        return StripeInformation.classType;
      case "StudyStreamStudent":
        return StudyStreamStudent.classType;
      case "StudyStreamTeacher":
        return StudyStreamTeacher.classType;
      case "Topic":
        return Topic.classType;
      case "TrueFalseQuestion":
        return TrueFalseQuestion.classType;
      case "User":
        return User.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}
