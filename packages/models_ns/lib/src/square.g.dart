// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'square.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SquareImpl _$$SquareImplFromJson(Map<String, dynamic> json) => _$SquareImpl(
      center: Point.fromJson(json['center'] as Map<String, dynamic>),
      sideLength: (json['sideLength'] as num).toDouble(),
      color: json['color'] as String? ?? '#000000',
      thickness: (json['thickness'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$SquareImplToJson(_$SquareImpl instance) =>
    <String, dynamic>{
      'center': instance.center.toJson(),
      'sideLength': instance.sideLength,
      'color': instance.color,
      'thickness': instance.thickness,
    };
