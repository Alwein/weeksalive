// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PurchaseState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PurchaseState()';
}


}

/// @nodoc
class $PurchaseStateCopyWith<$Res>  {
$PurchaseStateCopyWith(PurchaseState _, $Res Function(PurchaseState) __);
}


/// Adds pattern-matching-related methods to [PurchaseState].
extension PurchaseStatePatterns on PurchaseState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PurchaseStateInitial value)?  initial,TResult Function( PurchaseStateLoading value)?  loading,TResult Function( PurchaseStateSuccess value)?  success,TResult Function( PurchaseStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PurchaseStateInitial() when initial != null:
return initial(_that);case PurchaseStateLoading() when loading != null:
return loading(_that);case PurchaseStateSuccess() when success != null:
return success(_that);case PurchaseStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PurchaseStateInitial value)  initial,required TResult Function( PurchaseStateLoading value)  loading,required TResult Function( PurchaseStateSuccess value)  success,required TResult Function( PurchaseStateError value)  error,}){
final _that = this;
switch (_that) {
case PurchaseStateInitial():
return initial(_that);case PurchaseStateLoading():
return loading(_that);case PurchaseStateSuccess():
return success(_that);case PurchaseStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PurchaseStateInitial value)?  initial,TResult? Function( PurchaseStateLoading value)?  loading,TResult? Function( PurchaseStateSuccess value)?  success,TResult? Function( PurchaseStateError value)?  error,}){
final _that = this;
switch (_that) {
case PurchaseStateInitial() when initial != null:
return initial(_that);case PurchaseStateLoading() when loading != null:
return loading(_that);case PurchaseStateSuccess() when success != null:
return success(_that);case PurchaseStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function( PurchaseOfferings offerings)?  loading,TResult Function( PurchaseOfferings offerings,  bool isPro)?  success,TResult Function( String message,  PurchaseOfferings offerings,  bool isPro)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PurchaseStateInitial() when initial != null:
return initial();case PurchaseStateLoading() when loading != null:
return loading(_that.offerings);case PurchaseStateSuccess() when success != null:
return success(_that.offerings,_that.isPro);case PurchaseStateError() when error != null:
return error(_that.message,_that.offerings,_that.isPro);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function( PurchaseOfferings offerings)  loading,required TResult Function( PurchaseOfferings offerings,  bool isPro)  success,required TResult Function( String message,  PurchaseOfferings offerings,  bool isPro)  error,}) {final _that = this;
switch (_that) {
case PurchaseStateInitial():
return initial();case PurchaseStateLoading():
return loading(_that.offerings);case PurchaseStateSuccess():
return success(_that.offerings,_that.isPro);case PurchaseStateError():
return error(_that.message,_that.offerings,_that.isPro);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function( PurchaseOfferings offerings)?  loading,TResult? Function( PurchaseOfferings offerings,  bool isPro)?  success,TResult? Function( String message,  PurchaseOfferings offerings,  bool isPro)?  error,}) {final _that = this;
switch (_that) {
case PurchaseStateInitial() when initial != null:
return initial();case PurchaseStateLoading() when loading != null:
return loading(_that.offerings);case PurchaseStateSuccess() when success != null:
return success(_that.offerings,_that.isPro);case PurchaseStateError() when error != null:
return error(_that.message,_that.offerings,_that.isPro);case _:
  return null;

}
}

}

/// @nodoc


class PurchaseStateInitial implements PurchaseState {
  const PurchaseStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PurchaseState.initial()';
}


}




/// @nodoc


class PurchaseStateLoading implements PurchaseState {
  const PurchaseStateLoading({this.offerings = PurchaseOfferings.none});
  

@JsonKey() final  PurchaseOfferings offerings;

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseStateLoadingCopyWith<PurchaseStateLoading> get copyWith => _$PurchaseStateLoadingCopyWithImpl<PurchaseStateLoading>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseStateLoading&&(identical(other.offerings, offerings) || other.offerings == offerings));
}


@override
int get hashCode => Object.hash(runtimeType,offerings);

@override
String toString() {
  return 'PurchaseState.loading(offerings: $offerings)';
}


}

/// @nodoc
abstract mixin class $PurchaseStateLoadingCopyWith<$Res> implements $PurchaseStateCopyWith<$Res> {
  factory $PurchaseStateLoadingCopyWith(PurchaseStateLoading value, $Res Function(PurchaseStateLoading) _then) = _$PurchaseStateLoadingCopyWithImpl;
@useResult
$Res call({
 PurchaseOfferings offerings
});


$PurchaseOfferingsCopyWith<$Res> get offerings;

}
/// @nodoc
class _$PurchaseStateLoadingCopyWithImpl<$Res>
    implements $PurchaseStateLoadingCopyWith<$Res> {
  _$PurchaseStateLoadingCopyWithImpl(this._self, this._then);

  final PurchaseStateLoading _self;
  final $Res Function(PurchaseStateLoading) _then;

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? offerings = null,}) {
  return _then(PurchaseStateLoading(
offerings: null == offerings ? _self.offerings : offerings // ignore: cast_nullable_to_non_nullable
as PurchaseOfferings,
  ));
}

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseOfferingsCopyWith<$Res> get offerings {
  
  return $PurchaseOfferingsCopyWith<$Res>(_self.offerings, (value) {
    return _then(_self.copyWith(offerings: value));
  });
}
}

/// @nodoc


class PurchaseStateSuccess implements PurchaseState {
  const PurchaseStateSuccess({this.offerings = PurchaseOfferings.none, required this.isPro});
  

@JsonKey() final  PurchaseOfferings offerings;
 final  bool isPro;

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseStateSuccessCopyWith<PurchaseStateSuccess> get copyWith => _$PurchaseStateSuccessCopyWithImpl<PurchaseStateSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseStateSuccess&&(identical(other.offerings, offerings) || other.offerings == offerings)&&(identical(other.isPro, isPro) || other.isPro == isPro));
}


@override
int get hashCode => Object.hash(runtimeType,offerings,isPro);

@override
String toString() {
  return 'PurchaseState.success(offerings: $offerings, isPro: $isPro)';
}


}

/// @nodoc
abstract mixin class $PurchaseStateSuccessCopyWith<$Res> implements $PurchaseStateCopyWith<$Res> {
  factory $PurchaseStateSuccessCopyWith(PurchaseStateSuccess value, $Res Function(PurchaseStateSuccess) _then) = _$PurchaseStateSuccessCopyWithImpl;
@useResult
$Res call({
 PurchaseOfferings offerings, bool isPro
});


$PurchaseOfferingsCopyWith<$Res> get offerings;

}
/// @nodoc
class _$PurchaseStateSuccessCopyWithImpl<$Res>
    implements $PurchaseStateSuccessCopyWith<$Res> {
  _$PurchaseStateSuccessCopyWithImpl(this._self, this._then);

  final PurchaseStateSuccess _self;
  final $Res Function(PurchaseStateSuccess) _then;

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? offerings = null,Object? isPro = null,}) {
  return _then(PurchaseStateSuccess(
offerings: null == offerings ? _self.offerings : offerings // ignore: cast_nullable_to_non_nullable
as PurchaseOfferings,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseOfferingsCopyWith<$Res> get offerings {
  
  return $PurchaseOfferingsCopyWith<$Res>(_self.offerings, (value) {
    return _then(_self.copyWith(offerings: value));
  });
}
}

/// @nodoc


class PurchaseStateError implements PurchaseState {
  const PurchaseStateError({required this.message, this.offerings = PurchaseOfferings.none, required this.isPro});
  

 final  String message;
@JsonKey() final  PurchaseOfferings offerings;
 final  bool isPro;

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseStateErrorCopyWith<PurchaseStateError> get copyWith => _$PurchaseStateErrorCopyWithImpl<PurchaseStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseStateError&&(identical(other.message, message) || other.message == message)&&(identical(other.offerings, offerings) || other.offerings == offerings)&&(identical(other.isPro, isPro) || other.isPro == isPro));
}


@override
int get hashCode => Object.hash(runtimeType,message,offerings,isPro);

@override
String toString() {
  return 'PurchaseState.error(message: $message, offerings: $offerings, isPro: $isPro)';
}


}

/// @nodoc
abstract mixin class $PurchaseStateErrorCopyWith<$Res> implements $PurchaseStateCopyWith<$Res> {
  factory $PurchaseStateErrorCopyWith(PurchaseStateError value, $Res Function(PurchaseStateError) _then) = _$PurchaseStateErrorCopyWithImpl;
@useResult
$Res call({
 String message, PurchaseOfferings offerings, bool isPro
});


$PurchaseOfferingsCopyWith<$Res> get offerings;

}
/// @nodoc
class _$PurchaseStateErrorCopyWithImpl<$Res>
    implements $PurchaseStateErrorCopyWith<$Res> {
  _$PurchaseStateErrorCopyWithImpl(this._self, this._then);

  final PurchaseStateError _self;
  final $Res Function(PurchaseStateError) _then;

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? offerings = null,Object? isPro = null,}) {
  return _then(PurchaseStateError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,offerings: null == offerings ? _self.offerings : offerings // ignore: cast_nullable_to_non_nullable
as PurchaseOfferings,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of PurchaseState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PurchaseOfferingsCopyWith<$Res> get offerings {
  
  return $PurchaseOfferingsCopyWith<$Res>(_self.offerings, (value) {
    return _then(_self.copyWith(offerings: value));
  });
}
}

// dart format on
