// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_resume_bottom_sheet_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DayResumeBottomSheetViewModel {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayResumeBottomSheetViewModel);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'DayResumeBottomSheetViewModel()';
}


}

/// @nodoc
class $DayResumeBottomSheetViewModelCopyWith<$Res>  {
$DayResumeBottomSheetViewModelCopyWith(DayResumeBottomSheetViewModel _, $Res Function(DayResumeBottomSheetViewModel) __);
}


/// Adds pattern-matching-related methods to [DayResumeBottomSheetViewModel].
extension DayResumeBottomSheetViewModelPatterns on DayResumeBottomSheetViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( DayResumeBottomSheetViewModelEmpty value)?  empty,TResult Function( DayResumeBottomSheetViewModelFilled value)?  filled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case DayResumeBottomSheetViewModelEmpty() when empty != null:
return empty(_that);case DayResumeBottomSheetViewModelFilled() when filled != null:
return filled(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( DayResumeBottomSheetViewModelEmpty value)  empty,required TResult Function( DayResumeBottomSheetViewModelFilled value)  filled,}){
final _that = this;
switch (_that) {
case DayResumeBottomSheetViewModelEmpty():
return empty(_that);case DayResumeBottomSheetViewModelFilled():
return filled(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( DayResumeBottomSheetViewModelEmpty value)?  empty,TResult? Function( DayResumeBottomSheetViewModelFilled value)?  filled,}){
final _that = this;
switch (_that) {
case DayResumeBottomSheetViewModelEmpty() when empty != null:
return empty(_that);case DayResumeBottomSheetViewModelFilled() when filled != null:
return filled(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( DateTime date)?  empty,TResult Function( DayEntry entry,  int dayCount)?  filled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case DayResumeBottomSheetViewModelEmpty() when empty != null:
return empty(_that.date);case DayResumeBottomSheetViewModelFilled() when filled != null:
return filled(_that.entry,_that.dayCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( DateTime date)  empty,required TResult Function( DayEntry entry,  int dayCount)  filled,}) {final _that = this;
switch (_that) {
case DayResumeBottomSheetViewModelEmpty():
return empty(_that.date);case DayResumeBottomSheetViewModelFilled():
return filled(_that.entry,_that.dayCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( DateTime date)?  empty,TResult? Function( DayEntry entry,  int dayCount)?  filled,}) {final _that = this;
switch (_that) {
case DayResumeBottomSheetViewModelEmpty() when empty != null:
return empty(_that.date);case DayResumeBottomSheetViewModelFilled() when filled != null:
return filled(_that.entry,_that.dayCount);case _:
  return null;

}
}

}

/// @nodoc


class DayResumeBottomSheetViewModelEmpty implements DayResumeBottomSheetViewModel {
  const DayResumeBottomSheetViewModelEmpty({required this.date});
  

 final  DateTime date;

/// Create a copy of DayResumeBottomSheetViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayResumeBottomSheetViewModelEmptyCopyWith<DayResumeBottomSheetViewModelEmpty> get copyWith => _$DayResumeBottomSheetViewModelEmptyCopyWithImpl<DayResumeBottomSheetViewModelEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayResumeBottomSheetViewModelEmpty&&(identical(other.date, date) || other.date == date));
}


@override
int get hashCode => Object.hash(runtimeType,date);

@override
String toString() {
  return 'DayResumeBottomSheetViewModel.empty(date: $date)';
}


}

/// @nodoc
abstract mixin class $DayResumeBottomSheetViewModelEmptyCopyWith<$Res> implements $DayResumeBottomSheetViewModelCopyWith<$Res> {
  factory $DayResumeBottomSheetViewModelEmptyCopyWith(DayResumeBottomSheetViewModelEmpty value, $Res Function(DayResumeBottomSheetViewModelEmpty) _then) = _$DayResumeBottomSheetViewModelEmptyCopyWithImpl;
@useResult
$Res call({
 DateTime date
});




}
/// @nodoc
class _$DayResumeBottomSheetViewModelEmptyCopyWithImpl<$Res>
    implements $DayResumeBottomSheetViewModelEmptyCopyWith<$Res> {
  _$DayResumeBottomSheetViewModelEmptyCopyWithImpl(this._self, this._then);

  final DayResumeBottomSheetViewModelEmpty _self;
  final $Res Function(DayResumeBottomSheetViewModelEmpty) _then;

/// Create a copy of DayResumeBottomSheetViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? date = null,}) {
  return _then(DayResumeBottomSheetViewModelEmpty(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class DayResumeBottomSheetViewModelFilled implements DayResumeBottomSheetViewModel {
  const DayResumeBottomSheetViewModelFilled({required this.entry, required this.dayCount});
  

 final  DayEntry entry;
 final  int dayCount;

/// Create a copy of DayResumeBottomSheetViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DayResumeBottomSheetViewModelFilledCopyWith<DayResumeBottomSheetViewModelFilled> get copyWith => _$DayResumeBottomSheetViewModelFilledCopyWithImpl<DayResumeBottomSheetViewModelFilled>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DayResumeBottomSheetViewModelFilled&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.dayCount, dayCount) || other.dayCount == dayCount));
}


@override
int get hashCode => Object.hash(runtimeType,entry,dayCount);

@override
String toString() {
  return 'DayResumeBottomSheetViewModel.filled(entry: $entry, dayCount: $dayCount)';
}


}

/// @nodoc
abstract mixin class $DayResumeBottomSheetViewModelFilledCopyWith<$Res> implements $DayResumeBottomSheetViewModelCopyWith<$Res> {
  factory $DayResumeBottomSheetViewModelFilledCopyWith(DayResumeBottomSheetViewModelFilled value, $Res Function(DayResumeBottomSheetViewModelFilled) _then) = _$DayResumeBottomSheetViewModelFilledCopyWithImpl;
@useResult
$Res call({
 DayEntry entry, int dayCount
});




}
/// @nodoc
class _$DayResumeBottomSheetViewModelFilledCopyWithImpl<$Res>
    implements $DayResumeBottomSheetViewModelFilledCopyWith<$Res> {
  _$DayResumeBottomSheetViewModelFilledCopyWithImpl(this._self, this._then);

  final DayResumeBottomSheetViewModelFilled _self;
  final $Res Function(DayResumeBottomSheetViewModelFilled) _then;

/// Create a copy of DayResumeBottomSheetViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? entry = null,Object? dayCount = null,}) {
  return _then(DayResumeBottomSheetViewModelFilled(
entry: null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as DayEntry,dayCount: null == dayCount ? _self.dayCount : dayCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
