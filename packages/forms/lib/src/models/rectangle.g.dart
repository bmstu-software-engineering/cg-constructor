// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rectangle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RectangleImpl _$$RectangleImplFromJson(Map<String, dynamic> json) =>
    _$RectangleImpl(
      topLeft: Point.fromJson(json['topLeft'] as Map<String, dynamic>),
      topRight: Point.fromJson(json['topRight'] as Map<String, dynamic>),
      bottomRight: Point.fromJson(json['bottomRight'] as Map<String, dynamic>),
      bottomLeft: Point.fromJson(json['bottomLeft'] as Map<String, dynamic>),
      color: json['color'] as String? ?? '#000000',
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$RectangleImplToJson(_$RectangleImpl instance) =>
    <String, dynamic>{
      'topLeft': instance.topLeft,
      'topRight': instance.topRight,
      'bottomRight': instance.bottomRight,
      'bottomLeft': instance.bottomLeft,
      'color': instance.color,
      'thickness': instance.thickness,
    };
