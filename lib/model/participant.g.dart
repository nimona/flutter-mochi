// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'participant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Participant _$ParticipantFromJson(Map<String, dynamic> json) {
  return Participant(
    key: json['key'] as String,
    profile: json['profile'] == null
        ? null
        : Profile.fromJson(json['profile'] as Map<String, dynamic>),
    type: _$enumDecodeNullable(_$ParticipantTypeEnumMap, json['type']),
    contact: json['contact'] == null
        ? null
        : Contact.fromJson(json['contact'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ParticipantToJson(Participant instance) =>
    <String, dynamic>{
      'key': instance.key,
      'profile': instance.profile,
      'contact': instance.contact,
      'type': _$ParticipantTypeEnumMap[instance.type],
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ParticipantTypeEnumMap = {
  ParticipantType.OWNER: 'OWNER',
  ParticipantType.ADMINISTRATOR: 'ADMINISTRATOR',
  ParticipantType.MODERATOR: 'MODERATOR',
  ParticipantType.USER: 'USER',
};
