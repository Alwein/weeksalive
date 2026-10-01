// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_offerings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PurchaseOfferings {

/// The onboarding offer, with a free trial.
 Offering? get current;/// Another trial length, offered alongside [current].
 Offering? get alternate;/// Annual, weekly and lifetime with no trial, sold by the in-app paywall.
 Offering? get plans;
/// Create a copy of PurchaseOfferings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseOfferingsCopyWith<PurchaseOfferings> get copyWith => _$PurchaseOfferingsCopyWithImpl<PurchaseOfferings>(this as PurchaseOfferings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseOfferings&&(identical(other.current, current) || other.current == current)&&(identical(other.alternate, alternate) || other.alternate == alternate)&&(identical(other.plans, plans) || other.plans == plans));
}


@override
int get hashCode => Object.hash(runtimeType,current,alternate,plans);

@override
String toString() {
  return 'PurchaseOfferings(current: $current, alternate: $alternate, plans: $plans)';
}


}

/// @nodoc
abstract mixin class $PurchaseOfferingsCopyWith<$Res>  {
  factory $PurchaseOfferingsCopyWith(PurchaseOfferings value, $Res Function(PurchaseOfferings) _then) = _$PurchaseOfferingsCopyWithImpl;
@useResult
$Res call({
 Offering? current, Offering? alternate, Offering? plans
});




}
/// @nodoc
class _$PurchaseOfferingsCopyWithImpl<$Res>
    implements $PurchaseOfferingsCopyWith<$Res> {
  _$PurchaseOfferingsCopyWithImpl(this._self, this._then);

  final PurchaseOfferings _self;
  final $Res Function(PurchaseOfferings) _then;

/// Create a copy of PurchaseOfferings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? current = freezed,Object? alternate = freezed,Object? plans = freezed,}) {
  return _then(_self.copyWith(
current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as Offering?,alternate: freezed == alternate ? _self.alternate : alternate // ignore: cast_nullable_to_non_nullable
as Offering?,plans: freezed == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as Offering?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseOfferings].
extension PurchaseOfferingsPatterns on PurchaseOfferings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseOfferings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseOfferings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseOfferings value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseOfferings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseOfferings value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseOfferings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Offering? current,  Offering? alternate,  Offering? plans)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseOfferings() when $default != null:
return $default(_that.current,_that.alternate,_that.plans);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Offering? current,  Offering? alternate,  Offering? plans)  $default,) {final _that = this;
switch (_that) {
case _PurchaseOfferings():
return $default(_that.current,_that.alternate,_that.plans);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Offering? current,  Offering? alternate,  Offering? plans)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseOfferings() when $default != null:
return $default(_that.current,_that.alternate,_that.plans);case _:
  return null;

}
}

}

/// @nodoc


class _PurchaseOfferings extends PurchaseOfferings {
  const _PurchaseOfferings({this.current, this.alternate, this.plans}): super._();
  

/// The onboarding offer, with a free trial.
@override final  Offering? current;
/// Another trial length, offered alongside [current].
@override final  Offering? alternate;
/// Annual, weekly and lifetime with no trial, sold by the in-app paywall.
@override final  Offering? plans;

/// Create a copy of PurchaseOfferings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseOfferingsCopyWith<_PurchaseOfferings> get copyWith => __$PurchaseOfferingsCopyWithImpl<_PurchaseOfferings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseOfferings&&(identical(other.current, current) || other.current == current)&&(identical(other.alternate, alternate) || other.alternate == alternate)&&(identical(other.plans, plans) || other.plans == plans));
}


@override
int get hashCode => Object.hash(runtimeType,current,alternate,plans);

@override
String toString() {
  return 'PurchaseOfferings(current: $current, alternate: $alternate, plans: $plans)';
}


}

/// @nodoc
abstract mixin class _$PurchaseOfferingsCopyWith<$Res> implements $PurchaseOfferingsCopyWith<$Res> {
  factory _$PurchaseOfferingsCopyWith(_PurchaseOfferings value, $Res Function(_PurchaseOfferings) _then) = __$PurchaseOfferingsCopyWithImpl;
@override @useResult
$Res call({
 Offering? current, Offering? alternate, Offering? plans
});




}
/// @nodoc
class __$PurchaseOfferingsCopyWithImpl<$Res>
    implements _$PurchaseOfferingsCopyWith<$Res> {
  __$PurchaseOfferingsCopyWithImpl(this._self, this._then);

  final _PurchaseOfferings _self;
  final $Res Function(_PurchaseOfferings) _then;

/// Create a copy of PurchaseOfferings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? current = freezed,Object? alternate = freezed,Object? plans = freezed,}) {
  return _then(_PurchaseOfferings(
current: freezed == current ? _self.current : current // ignore: cast_nullable_to_non_nullable
as Offering?,alternate: freezed == alternate ? _self.alternate : alternate // ignore: cast_nullable_to_non_nullable
as Offering?,plans: freezed == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as Offering?,
  ));
}


}

// dart format on
