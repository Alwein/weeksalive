// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notifications_settings_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NotificationsSettingsViewModel {

 bool get notificationsEnabled; NotificationSlotState get dailySlot1; NotificationSlotState get dailySlot2; NotificationSlotState get weeklySummarySlot; int get weekStartDay;
/// Create a copy of NotificationsSettingsViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotificationsSettingsViewModelCopyWith<NotificationsSettingsViewModel> get copyWith => _$NotificationsSettingsViewModelCopyWithImpl<NotificationsSettingsViewModel>(this as NotificationsSettingsViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotificationsSettingsViewModel&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailySlot1, dailySlot1) || other.dailySlot1 == dailySlot1)&&(identical(other.dailySlot2, dailySlot2) || other.dailySlot2 == dailySlot2)&&(identical(other.weeklySummarySlot, weeklySummarySlot) || other.weeklySummarySlot == weeklySummarySlot)&&(identical(other.weekStartDay, weekStartDay) || other.weekStartDay == weekStartDay));
}


@override
int get hashCode => Object.hash(runtimeType,notificationsEnabled,dailySlot1,dailySlot2,weeklySummarySlot,weekStartDay);

@override
String toString() {
  return 'NotificationsSettingsViewModel(notificationsEnabled: $notificationsEnabled, dailySlot1: $dailySlot1, dailySlot2: $dailySlot2, weeklySummarySlot: $weeklySummarySlot, weekStartDay: $weekStartDay)';
}


}

/// @nodoc
abstract mixin class $NotificationsSettingsViewModelCopyWith<$Res>  {
  factory $NotificationsSettingsViewModelCopyWith(NotificationsSettingsViewModel value, $Res Function(NotificationsSettingsViewModel) _then) = _$NotificationsSettingsViewModelCopyWithImpl;
@useResult
$Res call({
 bool notificationsEnabled, NotificationSlotState dailySlot1, NotificationSlotState dailySlot2, NotificationSlotState weeklySummarySlot, int weekStartDay
});




}
/// @nodoc
class _$NotificationsSettingsViewModelCopyWithImpl<$Res>
    implements $NotificationsSettingsViewModelCopyWith<$Res> {
  _$NotificationsSettingsViewModelCopyWithImpl(this._self, this._then);

  final NotificationsSettingsViewModel _self;
  final $Res Function(NotificationsSettingsViewModel) _then;

/// Create a copy of NotificationsSettingsViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? notificationsEnabled = null,Object? dailySlot1 = null,Object? dailySlot2 = null,Object? weeklySummarySlot = null,Object? weekStartDay = null,}) {
  return _then(_self.copyWith(
notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailySlot1: null == dailySlot1 ? _self.dailySlot1 : dailySlot1 // ignore: cast_nullable_to_non_nullable
as NotificationSlotState,dailySlot2: null == dailySlot2 ? _self.dailySlot2 : dailySlot2 // ignore: cast_nullable_to_non_nullable
as NotificationSlotState,weeklySummarySlot: null == weeklySummarySlot ? _self.weeklySummarySlot : weeklySummarySlot // ignore: cast_nullable_to_non_nullable
as NotificationSlotState,weekStartDay: null == weekStartDay ? _self.weekStartDay : weekStartDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [NotificationsSettingsViewModel].
extension NotificationsSettingsViewModelPatterns on NotificationsSettingsViewModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NotificationsSettingsViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NotificationsSettingsViewModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NotificationsSettingsViewModel value)  $default,){
final _that = this;
switch (_that) {
case _NotificationsSettingsViewModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NotificationsSettingsViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _NotificationsSettingsViewModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool notificationsEnabled,  NotificationSlotState dailySlot1,  NotificationSlotState dailySlot2,  NotificationSlotState weeklySummarySlot,  int weekStartDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NotificationsSettingsViewModel() when $default != null:
return $default(_that.notificationsEnabled,_that.dailySlot1,_that.dailySlot2,_that.weeklySummarySlot,_that.weekStartDay);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool notificationsEnabled,  NotificationSlotState dailySlot1,  NotificationSlotState dailySlot2,  NotificationSlotState weeklySummarySlot,  int weekStartDay)  $default,) {final _that = this;
switch (_that) {
case _NotificationsSettingsViewModel():
return $default(_that.notificationsEnabled,_that.dailySlot1,_that.dailySlot2,_that.weeklySummarySlot,_that.weekStartDay);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool notificationsEnabled,  NotificationSlotState dailySlot1,  NotificationSlotState dailySlot2,  NotificationSlotState weeklySummarySlot,  int weekStartDay)?  $default,) {final _that = this;
switch (_that) {
case _NotificationsSettingsViewModel() when $default != null:
return $default(_that.notificationsEnabled,_that.dailySlot1,_that.dailySlot2,_that.weeklySummarySlot,_that.weekStartDay);case _:
  return null;

}
}

}

/// @nodoc


class _NotificationsSettingsViewModel implements NotificationsSettingsViewModel {
  const _NotificationsSettingsViewModel({required this.notificationsEnabled, required this.dailySlot1, required this.dailySlot2, required this.weeklySummarySlot, required this.weekStartDay});
  

@override final  bool notificationsEnabled;
@override final  NotificationSlotState dailySlot1;
@override final  NotificationSlotState dailySlot2;
@override final  NotificationSlotState weeklySummarySlot;
@override final  int weekStartDay;

/// Create a copy of NotificationsSettingsViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NotificationsSettingsViewModelCopyWith<_NotificationsSettingsViewModel> get copyWith => __$NotificationsSettingsViewModelCopyWithImpl<_NotificationsSettingsViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NotificationsSettingsViewModel&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailySlot1, dailySlot1) || other.dailySlot1 == dailySlot1)&&(identical(other.dailySlot2, dailySlot2) || other.dailySlot2 == dailySlot2)&&(identical(other.weeklySummarySlot, weeklySummarySlot) || other.weeklySummarySlot == weeklySummarySlot)&&(identical(other.weekStartDay, weekStartDay) || other.weekStartDay == weekStartDay));
}


@override
int get hashCode => Object.hash(runtimeType,notificationsEnabled,dailySlot1,dailySlot2,weeklySummarySlot,weekStartDay);

@override
String toString() {
  return 'NotificationsSettingsViewModel(notificationsEnabled: $notificationsEnabled, dailySlot1: $dailySlot1, dailySlot2: $dailySlot2, weeklySummarySlot: $weeklySummarySlot, weekStartDay: $weekStartDay)';
}


}

/// @nodoc
abstract mixin class _$NotificationsSettingsViewModelCopyWith<$Res> implements $NotificationsSettingsViewModelCopyWith<$Res> {
  factory _$NotificationsSettingsViewModelCopyWith(_NotificationsSettingsViewModel value, $Res Function(_NotificationsSettingsViewModel) _then) = __$NotificationsSettingsViewModelCopyWithImpl;
@override @useResult
$Res call({
 bool notificationsEnabled, NotificationSlotState dailySlot1, NotificationSlotState dailySlot2, NotificationSlotState weeklySummarySlot, int weekStartDay
});




}
/// @nodoc
class __$NotificationsSettingsViewModelCopyWithImpl<$Res>
    implements _$NotificationsSettingsViewModelCopyWith<$Res> {
  __$NotificationsSettingsViewModelCopyWithImpl(this._self, this._then);

  final _NotificationsSettingsViewModel _self;
  final $Res Function(_NotificationsSettingsViewModel) _then;

/// Create a copy of NotificationsSettingsViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? notificationsEnabled = null,Object? dailySlot1 = null,Object? dailySlot2 = null,Object? weeklySummarySlot = null,Object? weekStartDay = null,}) {
  return _then(_NotificationsSettingsViewModel(
notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailySlot1: null == dailySlot1 ? _self.dailySlot1 : dailySlot1 // ignore: cast_nullable_to_non_nullable
as NotificationSlotState,dailySlot2: null == dailySlot2 ? _self.dailySlot2 : dailySlot2 // ignore: cast_nullable_to_non_nullable
as NotificationSlotState,weeklySummarySlot: null == weeklySummarySlot ? _self.weeklySummarySlot : weeklySummarySlot // ignore: cast_nullable_to_non_nullable
as NotificationSlotState,weekStartDay: null == weekStartDay ? _self.weekStartDay : weekStartDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
