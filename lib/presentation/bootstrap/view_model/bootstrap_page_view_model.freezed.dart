// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bootstrap_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BootstrapPageViewModel {

 BootstrapPageRedirect get redirect;
/// Create a copy of BootstrapPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BootstrapPageViewModelCopyWith<BootstrapPageViewModel> get copyWith => _$BootstrapPageViewModelCopyWithImpl<BootstrapPageViewModel>(this as BootstrapPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BootstrapPageViewModel&&(identical(other.redirect, redirect) || other.redirect == redirect));
}


@override
int get hashCode => Object.hash(runtimeType,redirect);

@override
String toString() {
  return 'BootstrapPageViewModel(redirect: $redirect)';
}


}

/// @nodoc
abstract mixin class $BootstrapPageViewModelCopyWith<$Res>  {
  factory $BootstrapPageViewModelCopyWith(BootstrapPageViewModel value, $Res Function(BootstrapPageViewModel) _then) = _$BootstrapPageViewModelCopyWithImpl;
@useResult
$Res call({
 BootstrapPageRedirect redirect
});




}
/// @nodoc
class _$BootstrapPageViewModelCopyWithImpl<$Res>
    implements $BootstrapPageViewModelCopyWith<$Res> {
  _$BootstrapPageViewModelCopyWithImpl(this._self, this._then);

  final BootstrapPageViewModel _self;
  final $Res Function(BootstrapPageViewModel) _then;

/// Create a copy of BootstrapPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? redirect = null,}) {
  return _then(_self.copyWith(
redirect: null == redirect ? _self.redirect : redirect // ignore: cast_nullable_to_non_nullable
as BootstrapPageRedirect,
  ));
}

}


/// Adds pattern-matching-related methods to [BootstrapPageViewModel].
extension BootstrapPageViewModelPatterns on BootstrapPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BootstrapPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BootstrapPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BootstrapPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _BootstrapPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BootstrapPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _BootstrapPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BootstrapPageRedirect redirect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BootstrapPageViewModel() when $default != null:
return $default(_that.redirect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BootstrapPageRedirect redirect)  $default,) {final _that = this;
switch (_that) {
case _BootstrapPageViewModel():
return $default(_that.redirect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BootstrapPageRedirect redirect)?  $default,) {final _that = this;
switch (_that) {
case _BootstrapPageViewModel() when $default != null:
return $default(_that.redirect);case _:
  return null;

}
}

}

/// @nodoc


class _BootstrapPageViewModel implements BootstrapPageViewModel {
  const _BootstrapPageViewModel({required this.redirect});
  

@override final  BootstrapPageRedirect redirect;

/// Create a copy of BootstrapPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BootstrapPageViewModelCopyWith<_BootstrapPageViewModel> get copyWith => __$BootstrapPageViewModelCopyWithImpl<_BootstrapPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BootstrapPageViewModel&&(identical(other.redirect, redirect) || other.redirect == redirect));
}


@override
int get hashCode => Object.hash(runtimeType,redirect);

@override
String toString() {
  return 'BootstrapPageViewModel(redirect: $redirect)';
}


}

/// @nodoc
abstract mixin class _$BootstrapPageViewModelCopyWith<$Res> implements $BootstrapPageViewModelCopyWith<$Res> {
  factory _$BootstrapPageViewModelCopyWith(_BootstrapPageViewModel value, $Res Function(_BootstrapPageViewModel) _then) = __$BootstrapPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 BootstrapPageRedirect redirect
});




}
/// @nodoc
class __$BootstrapPageViewModelCopyWithImpl<$Res>
    implements _$BootstrapPageViewModelCopyWith<$Res> {
  __$BootstrapPageViewModelCopyWithImpl(this._self, this._then);

  final _BootstrapPageViewModel _self;
  final $Res Function(_BootstrapPageViewModel) _then;

/// Create a copy of BootstrapPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? redirect = null,}) {
  return _then(_BootstrapPageViewModel(
redirect: null == redirect ? _self.redirect : redirect // ignore: cast_nullable_to_non_nullable
as BootstrapPageRedirect,
  ));
}


}

// dart format on
