// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Timer {

 DateTime get startTime; TimerStatus get status; int get successionCount; int get totalWorkTime; int get totalBreakTime; int get elapsedPrePause;
/// Create a copy of Timer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerCopyWith<Timer> get copyWith => _$TimerCopyWithImpl<Timer>(this as Timer, _$identity);

  /// Serializes this Timer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Timer&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.successionCount, successionCount) || other.successionCount == successionCount)&&(identical(other.totalWorkTime, totalWorkTime) || other.totalWorkTime == totalWorkTime)&&(identical(other.totalBreakTime, totalBreakTime) || other.totalBreakTime == totalBreakTime)&&(identical(other.elapsedPrePause, elapsedPrePause) || other.elapsedPrePause == elapsedPrePause));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,status,successionCount,totalWorkTime,totalBreakTime,elapsedPrePause);

@override
String toString() {
  return 'Timer(startTime: $startTime, status: $status, successionCount: $successionCount, totalWorkTime: $totalWorkTime, totalBreakTime: $totalBreakTime, elapsedPrePause: $elapsedPrePause)';
}


}

/// @nodoc
abstract mixin class $TimerCopyWith<$Res>  {
  factory $TimerCopyWith(Timer value, $Res Function(Timer) _then) = _$TimerCopyWithImpl;
@useResult
$Res call({
 DateTime startTime, TimerStatus status, int successionCount, int totalWorkTime, int totalBreakTime, int elapsedPrePause
});




}
/// @nodoc
class _$TimerCopyWithImpl<$Res>
    implements $TimerCopyWith<$Res> {
  _$TimerCopyWithImpl(this._self, this._then);

  final Timer _self;
  final $Res Function(Timer) _then;

/// Create a copy of Timer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startTime = null,Object? status = null,Object? successionCount = null,Object? totalWorkTime = null,Object? totalBreakTime = null,Object? elapsedPrePause = null,}) {
  return _then(_self.copyWith(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TimerStatus,successionCount: null == successionCount ? _self.successionCount : successionCount // ignore: cast_nullable_to_non_nullable
as int,totalWorkTime: null == totalWorkTime ? _self.totalWorkTime : totalWorkTime // ignore: cast_nullable_to_non_nullable
as int,totalBreakTime: null == totalBreakTime ? _self.totalBreakTime : totalBreakTime // ignore: cast_nullable_to_non_nullable
as int,elapsedPrePause: null == elapsedPrePause ? _self.elapsedPrePause : elapsedPrePause // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _Timer implements Timer {
  const _Timer({required this.startTime, required this.status, required this.successionCount, required this.totalWorkTime, required this.totalBreakTime, required this.elapsedPrePause});
  factory _Timer.fromJson(Map<String, dynamic> json) => _$TimerFromJson(json);

@override final  DateTime startTime;
@override final  TimerStatus status;
@override final  int successionCount;
@override final  int totalWorkTime;
@override final  int totalBreakTime;
@override final  int elapsedPrePause;

/// Create a copy of Timer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimerCopyWith<_Timer> get copyWith => __$TimerCopyWithImpl<_Timer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TimerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Timer&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.status, status) || other.status == status)&&(identical(other.successionCount, successionCount) || other.successionCount == successionCount)&&(identical(other.totalWorkTime, totalWorkTime) || other.totalWorkTime == totalWorkTime)&&(identical(other.totalBreakTime, totalBreakTime) || other.totalBreakTime == totalBreakTime)&&(identical(other.elapsedPrePause, elapsedPrePause) || other.elapsedPrePause == elapsedPrePause));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,startTime,status,successionCount,totalWorkTime,totalBreakTime,elapsedPrePause);

@override
String toString() {
  return 'Timer(startTime: $startTime, status: $status, successionCount: $successionCount, totalWorkTime: $totalWorkTime, totalBreakTime: $totalBreakTime, elapsedPrePause: $elapsedPrePause)';
}


}

/// @nodoc
abstract mixin class _$TimerCopyWith<$Res> implements $TimerCopyWith<$Res> {
  factory _$TimerCopyWith(_Timer value, $Res Function(_Timer) _then) = __$TimerCopyWithImpl;
@override @useResult
$Res call({
 DateTime startTime, TimerStatus status, int successionCount, int totalWorkTime, int totalBreakTime, int elapsedPrePause
});




}
/// @nodoc
class __$TimerCopyWithImpl<$Res>
    implements _$TimerCopyWith<$Res> {
  __$TimerCopyWithImpl(this._self, this._then);

  final _Timer _self;
  final $Res Function(_Timer) _then;

/// Create a copy of Timer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startTime = null,Object? status = null,Object? successionCount = null,Object? totalWorkTime = null,Object? totalBreakTime = null,Object? elapsedPrePause = null,}) {
  return _then(_Timer(
startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TimerStatus,successionCount: null == successionCount ? _self.successionCount : successionCount // ignore: cast_nullable_to_non_nullable
as int,totalWorkTime: null == totalWorkTime ? _self.totalWorkTime : totalWorkTime // ignore: cast_nullable_to_non_nullable
as int,totalBreakTime: null == totalBreakTime ? _self.totalBreakTime : totalBreakTime // ignore: cast_nullable_to_non_nullable
as int,elapsedPrePause: null == elapsedPrePause ? _self.elapsedPrePause : elapsedPrePause // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
