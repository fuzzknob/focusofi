// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Settings {

 int get workLength; int get shortBreakLength; int get longBreakLength; int get breakSuccessions;
/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsCopyWith<Settings> get copyWith => _$SettingsCopyWithImpl<Settings>(this as Settings, _$identity);

  /// Serializes this Settings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Settings&&(identical(other.workLength, workLength) || other.workLength == workLength)&&(identical(other.shortBreakLength, shortBreakLength) || other.shortBreakLength == shortBreakLength)&&(identical(other.longBreakLength, longBreakLength) || other.longBreakLength == longBreakLength)&&(identical(other.breakSuccessions, breakSuccessions) || other.breakSuccessions == breakSuccessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workLength,shortBreakLength,longBreakLength,breakSuccessions);

@override
String toString() {
  return 'Settings(workLength: $workLength, shortBreakLength: $shortBreakLength, longBreakLength: $longBreakLength, breakSuccessions: $breakSuccessions)';
}


}

/// @nodoc
abstract mixin class $SettingsCopyWith<$Res>  {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) _then) = _$SettingsCopyWithImpl;
@useResult
$Res call({
 int workLength, int shortBreakLength, int longBreakLength, int breakSuccessions
});




}
/// @nodoc
class _$SettingsCopyWithImpl<$Res>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._self, this._then);

  final Settings _self;
  final $Res Function(Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? workLength = null,Object? shortBreakLength = null,Object? longBreakLength = null,Object? breakSuccessions = null,}) {
  return _then(_self.copyWith(
workLength: null == workLength ? _self.workLength : workLength // ignore: cast_nullable_to_non_nullable
as int,shortBreakLength: null == shortBreakLength ? _self.shortBreakLength : shortBreakLength // ignore: cast_nullable_to_non_nullable
as int,longBreakLength: null == longBreakLength ? _self.longBreakLength : longBreakLength // ignore: cast_nullable_to_non_nullable
as int,breakSuccessions: null == breakSuccessions ? _self.breakSuccessions : breakSuccessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Settings implements Settings {
  const _Settings({required this.workLength, required this.shortBreakLength, required this.longBreakLength, required this.breakSuccessions});
  factory _Settings.fromJson(Map<String, dynamic> json) => _$SettingsFromJson(json);

@override final  int workLength;
@override final  int shortBreakLength;
@override final  int longBreakLength;
@override final  int breakSuccessions;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsCopyWith<_Settings> get copyWith => __$SettingsCopyWithImpl<_Settings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Settings&&(identical(other.workLength, workLength) || other.workLength == workLength)&&(identical(other.shortBreakLength, shortBreakLength) || other.shortBreakLength == shortBreakLength)&&(identical(other.longBreakLength, longBreakLength) || other.longBreakLength == longBreakLength)&&(identical(other.breakSuccessions, breakSuccessions) || other.breakSuccessions == breakSuccessions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,workLength,shortBreakLength,longBreakLength,breakSuccessions);

@override
String toString() {
  return 'Settings(workLength: $workLength, shortBreakLength: $shortBreakLength, longBreakLength: $longBreakLength, breakSuccessions: $breakSuccessions)';
}


}

/// @nodoc
abstract mixin class _$SettingsCopyWith<$Res> implements $SettingsCopyWith<$Res> {
  factory _$SettingsCopyWith(_Settings value, $Res Function(_Settings) _then) = __$SettingsCopyWithImpl;
@override @useResult
$Res call({
 int workLength, int shortBreakLength, int longBreakLength, int breakSuccessions
});




}
/// @nodoc
class __$SettingsCopyWithImpl<$Res>
    implements _$SettingsCopyWith<$Res> {
  __$SettingsCopyWithImpl(this._self, this._then);

  final _Settings _self;
  final $Res Function(_Settings) _then;

/// Create a copy of Settings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? workLength = null,Object? shortBreakLength = null,Object? longBreakLength = null,Object? breakSuccessions = null,}) {
  return _then(_Settings(
workLength: null == workLength ? _self.workLength : workLength // ignore: cast_nullable_to_non_nullable
as int,shortBreakLength: null == shortBreakLength ? _self.shortBreakLength : shortBreakLength // ignore: cast_nullable_to_non_nullable
as int,longBreakLength: null == longBreakLength ? _self.longBreakLength : longBreakLength // ignore: cast_nullable_to_non_nullable
as int,breakSuccessions: null == breakSuccessions ? _self.breakSuccessions : breakSuccessions // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
