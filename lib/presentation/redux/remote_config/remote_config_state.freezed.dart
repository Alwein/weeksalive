// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RemoteConfigState {

 AppRemoteConfig? get remoteConfig;
/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RemoteConfigStateCopyWith<RemoteConfigState> get copyWith => _$RemoteConfigStateCopyWithImpl<RemoteConfigState>(this as RemoteConfigState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RemoteConfigState&&(identical(other.remoteConfig, remoteConfig) || other.remoteConfig == remoteConfig));
}


@override
int get hashCode => Object.hash(runtimeType,remoteConfig);

@override
String toString() {
  return 'RemoteConfigState(remoteConfig: $remoteConfig)';
}


}

/// @nodoc
abstract mixin class $RemoteConfigStateCopyWith<$Res>  {
  factory $RemoteConfigStateCopyWith(RemoteConfigState value, $Res Function(RemoteConfigState) _then) = _$RemoteConfigStateCopyWithImpl;
@useResult
$Res call({
 AppRemoteConfig? remoteConfig
});


$AppRemoteConfigCopyWith<$Res>? get remoteConfig;

}
/// @nodoc
class _$RemoteConfigStateCopyWithImpl<$Res>
    implements $RemoteConfigStateCopyWith<$Res> {
  _$RemoteConfigStateCopyWithImpl(this._self, this._then);

  final RemoteConfigState _self;
  final $Res Function(RemoteConfigState) _then;

/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? remoteConfig = freezed,}) {
  return _then(_self.copyWith(
remoteConfig: freezed == remoteConfig ? _self.remoteConfig : remoteConfig // ignore: cast_nullable_to_non_nullable
as AppRemoteConfig?,
  ));
}
/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppRemoteConfigCopyWith<$Res>? get remoteConfig {
    if (_self.remoteConfig == null) {
    return null;
  }

  return $AppRemoteConfigCopyWith<$Res>(_self.remoteConfig!, (value) {
    return _then(_self.copyWith(remoteConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [RemoteConfigState].
extension RemoteConfigStatePatterns on RemoteConfigState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RemoteConfigState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RemoteConfigState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RemoteConfigState value)  $default,){
final _that = this;
switch (_that) {
case _RemoteConfigState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RemoteConfigState value)?  $default,){
final _that = this;
switch (_that) {
case _RemoteConfigState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AppRemoteConfig? remoteConfig)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RemoteConfigState() when $default != null:
return $default(_that.remoteConfig);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AppRemoteConfig? remoteConfig)  $default,) {final _that = this;
switch (_that) {
case _RemoteConfigState():
return $default(_that.remoteConfig);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AppRemoteConfig? remoteConfig)?  $default,) {final _that = this;
switch (_that) {
case _RemoteConfigState() when $default != null:
return $default(_that.remoteConfig);case _:
  return null;

}
}

}

/// @nodoc


class _RemoteConfigState implements RemoteConfigState {
  const _RemoteConfigState({this.remoteConfig});
  

@override final  AppRemoteConfig? remoteConfig;

/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RemoteConfigStateCopyWith<_RemoteConfigState> get copyWith => __$RemoteConfigStateCopyWithImpl<_RemoteConfigState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RemoteConfigState&&(identical(other.remoteConfig, remoteConfig) || other.remoteConfig == remoteConfig));
}


@override
int get hashCode => Object.hash(runtimeType,remoteConfig);

@override
String toString() {
  return 'RemoteConfigState(remoteConfig: $remoteConfig)';
}


}

/// @nodoc
abstract mixin class _$RemoteConfigStateCopyWith<$Res> implements $RemoteConfigStateCopyWith<$Res> {
  factory _$RemoteConfigStateCopyWith(_RemoteConfigState value, $Res Function(_RemoteConfigState) _then) = __$RemoteConfigStateCopyWithImpl;
@override @useResult
$Res call({
 AppRemoteConfig? remoteConfig
});


@override $AppRemoteConfigCopyWith<$Res>? get remoteConfig;

}
/// @nodoc
class __$RemoteConfigStateCopyWithImpl<$Res>
    implements _$RemoteConfigStateCopyWith<$Res> {
  __$RemoteConfigStateCopyWithImpl(this._self, this._then);

  final _RemoteConfigState _self;
  final $Res Function(_RemoteConfigState) _then;

/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? remoteConfig = freezed,}) {
  return _then(_RemoteConfigState(
remoteConfig: freezed == remoteConfig ? _self.remoteConfig : remoteConfig // ignore: cast_nullable_to_non_nullable
as AppRemoteConfig?,
  ));
}

/// Create a copy of RemoteConfigState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AppRemoteConfigCopyWith<$Res>? get remoteConfig {
    if (_self.remoteConfig == null) {
    return null;
  }

  return $AppRemoteConfigCopyWith<$Res>(_self.remoteConfig!, (value) {
    return _then(_self.copyWith(remoteConfig: value));
  });
}
}

// dart format on
