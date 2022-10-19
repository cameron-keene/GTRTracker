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

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';

/** This is an auto generated class representing the Todo type in your schema. */
@immutable
class Todo extends Model {
  static const classType = const _TodoModelType();
  final String id;
  final String? _name;
  final String? _description;
  final bool? _isComplete;
  final int? _goalDuration;
  final int? _currentDuration;
  final double? _latitude;
  final double? _longitude;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;

  @override
  String getId() {
    return id;
  }

  String get name {
    try {
      return _name!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  String? get description {
    return _description;
  }

  bool get isComplete {
    try {
      return _isComplete!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  int get goalDuration {
    try {
      return _goalDuration!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  int get currentDuration {
    try {
      return _currentDuration!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double get latitude {
    try {
      return _latitude!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  double get longitude {
    try {
      return _longitude!;
    } catch (e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion: AmplifyExceptionMessages
              .codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString());
    }
  }

  TemporalDateTime? get createdAt {
    return _createdAt;
  }

  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }

  const Todo._internal(
      {required this.id,
      required name,
      description,
      required isComplete,
      required goalDuration,
      required currentDuration,
      required latitude,
      required longitude,
      createdAt,
      updatedAt})
      : _name = name,
        _description = description,
        _isComplete = isComplete,
        _goalDuration = goalDuration,
        _currentDuration = currentDuration,
        _latitude = latitude,
        _longitude = longitude,
        _createdAt = createdAt,
        _updatedAt = updatedAt;

  factory Todo(
      {String? id,
      required String name,
      String? description,
      required bool isComplete,
      required int goalDuration,
      required int currentDuration,
      required double latitude,
      required double longitude}) {
    return Todo._internal(
        id: id == null ? UUID.getUUID() : id,
        name: name,
        description: description,
        isComplete: isComplete,
        goalDuration: goalDuration,
        currentDuration: currentDuration,
        latitude: latitude,
        longitude: longitude);
  }

  bool equals(Object other) {
    return this == other;
  }

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Todo &&
        id == other.id &&
        _name == other._name &&
        _description == other._description &&
        _isComplete == other._isComplete &&
        _goalDuration == other._goalDuration &&
        _currentDuration == other._currentDuration &&
        _latitude == other._latitude &&
        _longitude == other._longitude;
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  String toString() {
    var buffer = new StringBuffer();

    buffer.write("Todo {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("isComplete=" +
        (_isComplete != null ? _isComplete!.toString() : "null") +
        ", ");
    buffer.write("goalDuration=" +
        (_goalDuration != null ? _goalDuration!.toString() : "null") +
        ", ");
    buffer.write("currentDuration=" +
        (_currentDuration != null ? _currentDuration!.toString() : "null") +
        ", ");
    buffer.write("latitude=" +
        (_latitude != null ? _latitude!.toString() : "null") +
        ", ");
    buffer.write("longitude=" +
        (_longitude != null ? _longitude!.toString() : "null") +
        ", ");
    buffer.write("createdAt=" +
        (_createdAt != null ? _createdAt!.format() : "null") +
        ", ");
    buffer.write(
        "updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");

    return buffer.toString();
  }

  Todo copyWith(
      {String? id,
      String? name,
      String? description,
      bool? isComplete,
      int? goalDuration,
      int? currentDuration,
      double? latitude,
      double? longitude}) {
    return Todo._internal(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        isComplete: isComplete ?? this.isComplete,
        goalDuration: goalDuration ?? this.goalDuration,
        currentDuration: currentDuration ?? this.currentDuration,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude);
  }

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        _name = json['name'],
        _description = json['description'],
        _isComplete = json['isComplete'],
        _goalDuration = (json['goalDuration'] as num?)?.toInt(),
        _currentDuration = (json['currentDuration'] as num?)?.toInt(),
        _latitude = (json['latitude'] as num?)?.toDouble(),
        _longitude = (json['longitude'] as num?)?.toDouble(),
        _createdAt = json['createdAt'] != null
            ? TemporalDateTime.fromString(json['createdAt'])
            : null,
        _updatedAt = json['updatedAt'] != null
            ? TemporalDateTime.fromString(json['updatedAt'])
            : null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': _name,
        'description': _description,
        'isComplete': _isComplete,
        'goalDuration': _goalDuration,
        'currentDuration': _currentDuration,
        'latitude': _latitude,
        'longitude': _longitude,
        'createdAt': _createdAt?.format(),
        'updatedAt': _updatedAt?.format()
      };

  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField DESCRIPTION = QueryField(fieldName: "description");
  static final QueryField ISCOMPLETE = QueryField(fieldName: "isComplete");
  static final QueryField GOALDURATION = QueryField(fieldName: "goalDuration");
  static final QueryField CURRENTDURATION =
      QueryField(fieldName: "currentDuration");
  static final QueryField LATITUDE = QueryField(fieldName: "latitude");
  static final QueryField LONGITUDE = QueryField(fieldName: "longitude");
  static var schema =
      Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Todo";
    modelSchemaDefinition.pluralName = "Todos";

    modelSchemaDefinition.authRules = [
      AuthRule(authStrategy: AuthStrategy.PUBLIC, operations: [
        ModelOperation.CREATE,
        ModelOperation.UPDATE,
        ModelOperation.DELETE,
        ModelOperation.READ
      ])
    ];

    modelSchemaDefinition.addField(ModelFieldDefinition.id());

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.NAME,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.DESCRIPTION,
        isRequired: false,
        ofType: ModelFieldType(ModelFieldTypeEnum.string)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.ISCOMPLETE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.bool)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.GOALDURATION,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.CURRENTDURATION,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.int)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.LATITUDE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(ModelFieldDefinition.field(
        key: Todo.LONGITUDE,
        isRequired: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.double)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'createdAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));

    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
        fieldName: 'updatedAt',
        isRequired: false,
        isReadOnly: true,
        ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)));
  });
}

class _TodoModelType extends ModelType<Todo> {
  const _TodoModelType();

  @override
  Todo fromJson(Map<String, dynamic> jsonData) {
    return Todo.fromJson(jsonData);
  }
}
