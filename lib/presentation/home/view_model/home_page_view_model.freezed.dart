// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomePageViewModel {

 String get userName; int get streakCount; LifeWeekGrid get lifeWeekGrid;/// ISO weekday (1 = Monday … 7 = Sunday) at which the week starts.
 int get weekStartDay;/// Set of dates (normalized to midnight) that have been recorded.
 Set<DateTime> get recordedDays;
/// Create a copy of HomePageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomePageViewModelCopyWith<HomePageViewModel> get copyWith => _$HomePageViewModelCopyWithImpl<HomePageViewModel>(this as HomePageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomePageViewModel&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.streakCount, streakCount) || other.streakCount == streakCount)&&(identical(other.lifeWeekGrid, lifeWeekGrid) || other.lifeWeekGrid == lifeWeekGrid)&&(identical(other.weekStartDay, weekStartDay) || other.weekStartDay == weekStartDay)&&const DeepCollectionEquality().equals(other.recordedDays, recordedDays));
}


@override
int get hashCode => Object.hash(runtimeType,userName,streakCount,lifeWeekGrid,weekStartDay,const DeepCollectionEquality().hash(recordedDays));

@override
String toString() {
  return 'HomePageViewModel(userName: $userName, streakCount: $streakCount, lifeWeekGrid: $lifeWeekGrid, weekStartDay: $weekStartDay, recordedDays: $recordedDays)';
}


}

/// @nodoc
abstract mixin class $HomePageViewModelCopyWith<$Res>  {
  factory $HomePageViewModelCopyWith(HomePageViewModel value, $Res Function(HomePageViewModel) _then) = _$HomePageViewModelCopyWithImpl;
@useResult
$Res call({
 String userName, int streakCount, LifeWeekGrid lifeWeekGrid, int weekStartDay, Set<DateTime> recordedDays
});




}
/// @nodoc
class _$HomePageViewModelCopyWithImpl<$Res>
    implements $HomePageViewModelCopyWith<$Res> {
  _$HomePageViewModelCopyWithImpl(this._self, this._then);

  final HomePageViewModel _self;
  final $Res Function(HomePageViewModel) _then;

/// Create a copy of HomePageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? streakCount = null,Object? lifeWeekGrid = null,Object? weekStartDay = null,Object? recordedDays = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,streakCount: null == streakCount ? _self.streakCount : streakCount // ignore: cast_nullable_to_non_nullable
as int,lifeWeekGrid: null == lifeWeekGrid ? _self.lifeWeekGrid : lifeWeekGrid // ignore: cast_nullable_to_non_nullable
as LifeWeekGrid,weekStartDay: null == weekStartDay ? _self.weekStartDay : weekStartDay // ignore: cast_nullable_to_non_nullable
as int,recordedDays: null == recordedDays ? _self.recordedDays : recordedDays // ignore: cast_nullable_to_non_nullable
as Set<DateTime>,
  ));
}

}


/// Adds pattern-matching-related methods to [HomePageViewModel].
extension HomePageViewModelPatterns on HomePageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomePageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomePageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomePageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _HomePageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomePageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _HomePageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userName,  int streakCount,  LifeWeekGrid lifeWeekGrid,  int weekStartDay,  Set<DateTime> recordedDays)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomePageViewModel() when $default != null:
return $default(_that.userName,_that.streakCount,_that.lifeWeekGrid,_that.weekStartDay,_that.recordedDays);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userName,  int streakCount,  LifeWeekGrid lifeWeekGrid,  int weekStartDay,  Set<DateTime> recordedDays)  $default,) {final _that = this;
switch (_that) {
case _HomePageViewModel():
return $default(_that.userName,_that.streakCount,_that.lifeWeekGrid,_that.weekStartDay,_that.recordedDays);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userName,  int streakCount,  LifeWeekGrid lifeWeekGrid,  int weekStartDay,  Set<DateTime> recordedDays)?  $default,) {final _that = this;
switch (_that) {
case _HomePageViewModel() when $default != null:
return $default(_that.userName,_that.streakCount,_that.lifeWeekGrid,_that.weekStartDay,_that.recordedDays);case _:
  return null;

}
}

}

/// @nodoc


class _HomePageViewModel implements HomePageViewModel {
  const _HomePageViewModel({required this.userName, required this.streakCount, required this.lifeWeekGrid, this.weekStartDay = DateTime.monday, final  Set<DateTime> recordedDays = const {}}): _recordedDays = recordedDays;
  

@override final  String userName;
@override final  int streakCount;
@override final  LifeWeekGrid lifeWeekGrid;
/// ISO weekday (1 = Monday … 7 = Sunday) at which the week starts.
@override@JsonKey() final  int weekStartDay;
/// Set of dates (normalized to midnight) that have been recorded.
 final  Set<DateTime> _recordedDays;
/// Set of dates (normalized to midnight) that have been recorded.
@override@JsonKey() Set<DateTime> get recordedDays {
  if (_recordedDays is EqualUnmodifiableSetView) return _recordedDays;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_recordedDays);
}


/// Create a copy of HomePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomePageViewModelCopyWith<_HomePageViewModel> get copyWith => __$HomePageViewModelCopyWithImpl<_HomePageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomePageViewModel&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.streakCount, streakCount) || other.streakCount == streakCount)&&(identical(other.lifeWeekGrid, lifeWeekGrid) || other.lifeWeekGrid == lifeWeekGrid)&&(identical(other.weekStartDay, weekStartDay) || other.weekStartDay == weekStartDay)&&const DeepCollectionEquality().equals(other._recordedDays, _recordedDays));
}


@override
int get hashCode => Object.hash(runtimeType,userName,streakCount,lifeWeekGrid,weekStartDay,const DeepCollectionEquality().hash(_recordedDays));

@override
String toString() {
  return 'HomePageViewModel(userName: $userName, streakCount: $streakCount, lifeWeekGrid: $lifeWeekGrid, weekStartDay: $weekStartDay, recordedDays: $recordedDays)';
}


}

/// @nodoc
abstract mixin class _$HomePageViewModelCopyWith<$Res> implements $HomePageViewModelCopyWith<$Res> {
  factory _$HomePageViewModelCopyWith(_HomePageViewModel value, $Res Function(_HomePageViewModel) _then) = __$HomePageViewModelCopyWithImpl;
@override @useResult
$Res call({
 String userName, int streakCount, LifeWeekGrid lifeWeekGrid, int weekStartDay, Set<DateTime> recordedDays
});




}
/// @nodoc
class __$HomePageViewModelCopyWithImpl<$Res>
    implements _$HomePageViewModelCopyWith<$Res> {
  __$HomePageViewModelCopyWithImpl(this._self, this._then);

  final _HomePageViewModel _self;
  final $Res Function(_HomePageViewModel) _then;

/// Create a copy of HomePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? streakCount = null,Object? lifeWeekGrid = null,Object? weekStartDay = null,Object? recordedDays = null,}) {
  return _then(_HomePageViewModel(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,streakCount: null == streakCount ? _self.streakCount : streakCount // ignore: cast_nullable_to_non_nullable
as int,lifeWeekGrid: null == lifeWeekGrid ? _self.lifeWeekGrid : lifeWeekGrid // ignore: cast_nullable_to_non_nullable
as LifeWeekGrid,weekStartDay: null == weekStartDay ? _self.weekStartDay : weekStartDay // ignore: cast_nullable_to_non_nullable
as int,recordedDays: null == recordedDays ? _self._recordedDays : recordedDays // ignore: cast_nullable_to_non_nullable
as Set<DateTime>,
  ));
}


}

// dart format on
