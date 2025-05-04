// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'figure_collection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FigureCollectionImpl _$$FigureCollectionImplFromJson(
        Map<String, dynamic> json) =>
    _$FigureCollectionImpl(
      points: (json['points'] as List<dynamic>?)
              ?.map((e) => Point.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      lines: (json['lines'] as List<dynamic>?)
              ?.map((e) => Line.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      triangles: (json['triangles'] as List<dynamic>?)
              ?.map((e) => Triangle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rectangles: (json['rectangles'] as List<dynamic>?)
              ?.map((e) => Rectangle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      squares: (json['squares'] as List<dynamic>?)
              ?.map((e) => Square.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      circles: (json['circles'] as List<dynamic>?)
              ?.map((e) => Circle.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      ellipses: (json['ellipses'] as List<dynamic>?)
              ?.map((e) => Ellipse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      arcs: (json['arcs'] as List<dynamic>?)
              ?.map((e) => Arc.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$FigureCollectionImplToJson(
        _$FigureCollectionImpl instance) =>
    <String, dynamic>{
      'points': instance.points,
      'lines': instance.lines,
      'triangles': instance.triangles,
      'rectangles': instance.rectangles,
      'squares': instance.squares,
      'circles': instance.circles,
      'ellipses': instance.ellipses,
      'arcs': instance.arcs,
    };
