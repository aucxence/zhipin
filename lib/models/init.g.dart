// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'init.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Init _$InitFromJson(Map<String, dynamic> json) {
  return Init()
    ..mode = json['mode'] as bool
    ..language = json['language'] as String
    ..fontFamily = json['fontFamily'] as String;
}

Map<String, dynamic> _$InitToJson(Init instance) => <String, dynamic>{
      'mode': instance.mode,
      'language': instance.language,
      'fontFamily': instance.fontFamily
    };
