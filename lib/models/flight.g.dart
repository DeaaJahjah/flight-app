// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Flight _$FlightFromJson(Map<String, dynamic> json) => Flight(
      id: json['id'] as String?,
      flightNo: json['flightNo'] as String,
      airplaneNo: json['airplaneNo'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      lunchDate: DateTime.parse(json['lunchDate'] as String),
      arriveDate: DateTime.parse(json['arriveDate'] as String),
      businessClassCost: json['businessClassCost'] as int,
      normalClassCost: json['normalClassCost'] as int,
      seats: (json['seats'] as List<dynamic>).map((e) => Seat.fromJson(e as Map<String, dynamic>)).toList(),
    );

Map<String, dynamic> _$FlightToJson(Flight instance) => <String, dynamic>{
      'id': instance.id,
      'flightNo': instance.flightNo,
      'airplaneNo': instance.airplaneNo,
      'from': instance.from,
      'to': instance.to,
      'lunchDate': instance.lunchDate.toIso8601String(),
      'arriveDate': instance.arriveDate.toIso8601String(),
      'businessClassCost': instance.businessClassCost,
      'normalClassCost': instance.normalClassCost,
      'seats': instance.seats.map((e) => e.toJson()).toList(),
    };

Seat _$SeatFromJson(Map<String, dynamic> json) => Seat(
      id: json['id'] as String?,
      name: json['name'] as String,
      available: json['available'] as bool,
    );

Map<String, dynamic> _$SeatToJson(Seat instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'available': instance.available,
    };
