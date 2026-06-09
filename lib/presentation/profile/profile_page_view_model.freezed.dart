// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfilePageViewModel {

 String get userName; DateTime get dateOfBirth; int get lifespan; int get age; int get yearsAhead; Gender get gender; bool get notificationsEnabled; int get weekStartDay;
/// Create a copy of ProfilePageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfilePageViewModelCopyWith<ProfilePageViewModel> get copyWith => _$ProfilePageViewModelCopyWithImpl<ProfilePageViewModel>(this as ProfilePageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfilePageViewModel&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.lifespan, lifespan) || other.lifespan == lifespan)&&(identical(other.age, age) || other.age == age)&&(identical(other.yearsAhead, yearsAhead) || other.yearsAhead == yearsAhead)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.weekStartDay, weekStartDay) || other.weekStartDay == weekStartDay));
}


@override
int get hashCode => Object.hash(runtimeType,userName,dateOfBirth,lifespan,age,yearsAhead,gender,notificationsEnabled,weekStartDay);

@override
String toString() {
  return 'ProfilePageViewModel(userName: $userName, dateOfBirth: $dateOfBirth, lifespan: $lifespan, age: $age, yearsAhead: $yearsAhead, gender: $gender, notificationsEnabled: $notificationsEnabled, weekStartDay: $weekStartDay)';
}


}

/// @nodoc
abstract mixin class $ProfilePageViewModelCopyWith<$Res>  {
  factory $ProfilePageViewModelCopyWith(ProfilePageViewModel value, $Res Function(ProfilePageViewModel) _then) = _$ProfilePageViewModelCopyWithImpl;
@useResult
$Res call({
 String userName, DateTime dateOfBirth, int lifespan, int age, int yearsAhead, Gender gender, bool notificationsEnabled, int weekStartDay
});




}
/// @nodoc
class _$ProfilePageViewModelCopyWithImpl<$Res>
    implements $ProfilePageViewModelCopyWith<$Res> {
  _$ProfilePageViewModelCopyWithImpl(this._self, this._then);

  final ProfilePageViewModel _self;
  final $Res Function(ProfilePageViewModel) _then;

/// Create a copy of ProfilePageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userName = null,Object? dateOfBirth = null,Object? lifespan = null,Object? age = null,Object? yearsAhead = null,Object? gender = null,Object? notificationsEnabled = null,Object? weekStartDay = null,}) {
  return _then(_self.copyWith(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,lifespan: null == lifespan ? _self.lifespan : lifespan // ignore: cast_nullable_to_non_nullable
as int,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,yearsAhead: null == yearsAhead ? _self.yearsAhead : yearsAhead // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,weekStartDay: null == weekStartDay ? _self.weekStartDay : weekStartDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfilePageViewModel].
extension ProfilePageViewModelPatterns on ProfilePageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfilePageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfilePageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfilePageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfilePageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfilePageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfilePageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userName,  DateTime dateOfBirth,  int lifespan,  int age,  int yearsAhead,  Gender gender,  bool notificationsEnabled,  int weekStartDay)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfilePageViewModel() when $default != null:
return $default(_that.userName,_that.dateOfBirth,_that.lifespan,_that.age,_that.yearsAhead,_that.gender,_that.notificationsEnabled,_that.weekStartDay);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userName,  DateTime dateOfBirth,  int lifespan,  int age,  int yearsAhead,  Gender gender,  bool notificationsEnabled,  int weekStartDay)  $default,) {final _that = this;
switch (_that) {
case _ProfilePageViewModel():
return $default(_that.userName,_that.dateOfBirth,_that.lifespan,_that.age,_that.yearsAhead,_that.gender,_that.notificationsEnabled,_that.weekStartDay);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userName,  DateTime dateOfBirth,  int lifespan,  int age,  int yearsAhead,  Gender gender,  bool notificationsEnabled,  int weekStartDay)?  $default,) {final _that = this;
switch (_that) {
case _ProfilePageViewModel() when $default != null:
return $default(_that.userName,_that.dateOfBirth,_that.lifespan,_that.age,_that.yearsAhead,_that.gender,_that.notificationsEnabled,_that.weekStartDay);case _:
  return null;

}
}

}

/// @nodoc


class _ProfilePageViewModel implements ProfilePageViewModel {
  const _ProfilePageViewModel({required this.userName, required this.dateOfBirth, required this.lifespan, required this.age, required this.yearsAhead, required this.gender, required this.notificationsEnabled, required this.weekStartDay});
  

@override final  String userName;
@override final  DateTime dateOfBirth;
@override final  int lifespan;
@override final  int age;
@override final  int yearsAhead;
@override final  Gender gender;
@override final  bool notificationsEnabled;
@override final  int weekStartDay;

/// Create a copy of ProfilePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfilePageViewModelCopyWith<_ProfilePageViewModel> get copyWith => __$ProfilePageViewModelCopyWithImpl<_ProfilePageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfilePageViewModel&&(identical(other.userName, userName) || other.userName == userName)&&(identical(other.dateOfBirth, dateOfBirth) || other.dateOfBirth == dateOfBirth)&&(identical(other.lifespan, lifespan) || other.lifespan == lifespan)&&(identical(other.age, age) || other.age == age)&&(identical(other.yearsAhead, yearsAhead) || other.yearsAhead == yearsAhead)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.weekStartDay, weekStartDay) || other.weekStartDay == weekStartDay));
}


@override
int get hashCode => Object.hash(runtimeType,userName,dateOfBirth,lifespan,age,yearsAhead,gender,notificationsEnabled,weekStartDay);

@override
String toString() {
  return 'ProfilePageViewModel(userName: $userName, dateOfBirth: $dateOfBirth, lifespan: $lifespan, age: $age, yearsAhead: $yearsAhead, gender: $gender, notificationsEnabled: $notificationsEnabled, weekStartDay: $weekStartDay)';
}


}

/// @nodoc
abstract mixin class _$ProfilePageViewModelCopyWith<$Res> implements $ProfilePageViewModelCopyWith<$Res> {
  factory _$ProfilePageViewModelCopyWith(_ProfilePageViewModel value, $Res Function(_ProfilePageViewModel) _then) = __$ProfilePageViewModelCopyWithImpl;
@override @useResult
$Res call({
 String userName, DateTime dateOfBirth, int lifespan, int age, int yearsAhead, Gender gender, bool notificationsEnabled, int weekStartDay
});




}
/// @nodoc
class __$ProfilePageViewModelCopyWithImpl<$Res>
    implements _$ProfilePageViewModelCopyWith<$Res> {
  __$ProfilePageViewModelCopyWithImpl(this._self, this._then);

  final _ProfilePageViewModel _self;
  final $Res Function(_ProfilePageViewModel) _then;

/// Create a copy of ProfilePageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userName = null,Object? dateOfBirth = null,Object? lifespan = null,Object? age = null,Object? yearsAhead = null,Object? gender = null,Object? notificationsEnabled = null,Object? weekStartDay = null,}) {
  return _then(_ProfilePageViewModel(
userName: null == userName ? _self.userName : userName // ignore: cast_nullable_to_non_nullable
as String,dateOfBirth: null == dateOfBirth ? _self.dateOfBirth : dateOfBirth // ignore: cast_nullable_to_non_nullable
as DateTime,lifespan: null == lifespan ? _self.lifespan : lifespan // ignore: cast_nullable_to_non_nullable
as int,age: null == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int,yearsAhead: null == yearsAhead ? _self.yearsAhead : yearsAhead // ignore: cast_nullable_to_non_nullable
as int,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,weekStartDay: null == weekStartDay ? _self.weekStartDay : weekStartDay // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
