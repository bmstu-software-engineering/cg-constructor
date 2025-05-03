// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figure_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FigureCollectionImpl _$$FigureCollectionImplFromJson(
  Map<String, dynamic> json,
) => _$FigureCollectionImpl(
  points:
      (json['points'] as List<dynamic>?)
          ?.map((e) => Point.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  triangles:
      (json['triangles'] as List<dynamic>?)
          ?.map((e) => Triangle.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$FigureCollectionImplToJson(
  _$FigureCollectionImpl instance,
) => <String, dynamic>{
  'points': instance.points,
  'lines': instance.lines,
  'triangles': instance.triangles,
};
