// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_form_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DayFormViewModel {

 String get dayCount; DayEntry? get existingEntry;
/// Create a copy of DayFormViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayFormViewModelCopyWith<DayFormViewModel> get copyWith => _$DayFormViewModelCopyWithImpl<DayFormViewModel>(this as DayFormViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayFormViewModel&&(identical(other.dayCount, dayCount) || other.dayCount == dayCount)&&(identical(other.existingEntry, existingEntry) || other.existingEntry == existingEntry));
}


@override
int get hashCode => Object.hash(runtimeType,dayCount,existingEntry);

@override
String toString() {
  return 'DayFormViewModel(dayCount: $dayCount, existingEntry: $existingEntry)';
}


}

/// @nodoc
abstract mixin class $DayFormViewModelCopyWith<$Res>  {
  factory $DayFormViewModelCopyWith(DayFormViewModel value, $Res Function(DayFormViewModel) _then) = _$DayFormViewModelCopyWithImpl;
@useResult
$Res call({
 String dayCount, DayEntry? existingEntry
});




}
/// @nodoc
class _$DayFormViewModelCopyWithImpl<$Res>
    implements $DayFormViewModelCopyWith<$Res> {
  _$DayFormViewModelCopyWithImpl(this._self, this._then);

  final DayFormViewModel _self;
  final $Res Function(DayFormViewModel) _then;

/// Create a copy of DayFormViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dayCount = null,Object? existingEntry = freezed,}) {
  return _then(_self.copyWith(
dayCount: null == dayCount ? _self.dayCount : dayCount // ignore: cast_nullable_to_non_nullable
as String,existingEntry: freezed == existingEntry ? _self.existingEntry : existingEntry // ignore: cast_nullable_to_non_nullable
as DayEntry?,
  ));
}

}


/// Adds pattern-matching-related methods to [DayFormViewModel].
extension DayFormViewModelPatterns on DayFormViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DayFormViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DayFormViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DayFormViewModel value)  $default,){
final _that = this;
switch (_that) {
case _DayFormViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DayFormViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _DayFormViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String dayCount,  DayEntry? existingEntry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DayFormViewModel() when $default != null:
return $default(_that.dayCount,_that.existingEntry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String dayCount,  DayEntry? existingEntry)  $default,) {final _that = this;
switch (_that) {
case _DayFormViewModel():
return $default(_that.dayCount,_that.existingEntry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String dayCount,  DayEntry? existingEntry)?  $default,) {final _that = this;
switch (_that) {
case _DayFormViewModel() when $default != null:
return $default(_that.dayCount,_that.existingEntry);case _:
  return null;

}
}

}

/// @nodoc


class _DayFormViewModel implements DayFormViewModel {
  const _DayFormViewModel({required this.dayCount, this.existingEntry});
  

@override final  String dayCount;
@override final  DayEntry? existingEntry;

/// Create a copy of DayFormViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DayFormViewModelCopyWith<_DayFormViewModel> get copyWith => __$DayFormViewModelCopyWithImpl<_DayFormViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DayFormViewModel&&(identical(other.dayCount, dayCount) || other.dayCount == dayCount)&&(identical(other.existingEntry, existingEntry) || other.existingEntry == existingEntry));
}


@override
int get hashCode => Object.hash(runtimeType,dayCount,existingEntry);

@override
String toString() {
  return 'DayFormViewModel(dayCount: $dayCount, existingEntry: $existingEntry)';
}


}

/// @nodoc
abstract mixin class _$DayFormViewModelCopyWith<$Res> implements $DayFormViewModelCopyWith<$Res> {
  factory _$DayFormViewModelCopyWith(_DayFormViewModel value, $Res Function(_DayFormViewModel) _then) = __$DayFormViewModelCopyWithImpl;
@override @useResult
$Res call({
 String dayCount, DayEntry? existingEntry
});




}
/// @nodoc
class __$DayFormViewModelCopyWithImpl<$Res>
    implements _$DayFormViewModelCopyWith<$Res> {
  __$DayFormViewModelCopyWithImpl(this._self, this._then);

  final _DayFormViewModel _self;
  final $Res Function(_DayFormViewModel) _then;

/// Create a copy of DayFormViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dayCount = null,Object? existingEntry = freezed,}) {
  return _then(_DayFormViewModel(
dayCount: null == dayCount ? _self.dayCount : dayCount // ignore: cast_nullable_to_non_nullable
as String,existingEntry: freezed == existingEntry ? _self.existingEntry : existingEntry // ignore: cast_nullable_to_non_nullable
as DayEntry?,
  ));
}


}

// dart format on
