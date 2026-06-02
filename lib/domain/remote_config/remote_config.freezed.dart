// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppRemoteConfig {

 String get minAppVersion;
/// Create a copy of AppRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppRemoteConfigCopyWith<AppRemoteConfig> get copyWith => _$AppRemoteConfigCopyWithImpl<AppRemoteConfig>(this as AppRemoteConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppRemoteConfig&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion));
}


@override
int get hashCode => Object.hash(runtimeType,minAppVersion);

@override
String toString() {
  return 'AppRemoteConfig(minAppVersion: $minAppVersion)';
}


}

/// @nodoc
abstract mixin class $AppRemoteConfigCopyWith<$Res>  {
  factory $AppRemoteConfigCopyWith(AppRemoteConfig value, $Res Function(AppRemoteConfig) _then) = _$AppRemoteConfigCopyWithImpl;
@useResult
$Res call({
 String minAppVersion
});




}
/// @nodoc
class _$AppRemoteConfigCopyWithImpl<$Res>
    implements $AppRemoteConfigCopyWith<$Res> {
  _$AppRemoteConfigCopyWithImpl(this._self, this._then);

  final AppRemoteConfig _self;
  final $Res Function(AppRemoteConfig) _then;

/// Create a copy of AppRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? minAppVersion = null,}) {
  return _then(_self.copyWith(
minAppVersion: null == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AppRemoteConfig].
extension AppRemoteConfigPatterns on AppRemoteConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppRemoteConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppRemoteConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppRemoteConfig value)  $default,){
final _that = this;
switch (_that) {
case _AppRemoteConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppRemoteConfig value)?  $default,){
final _that = this;
switch (_that) {
case _AppRemoteConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String minAppVersion)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppRemoteConfig() when $default != null:
return $default(_that.minAppVersion);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String minAppVersion)  $default,) {final _that = this;
switch (_that) {
case _AppRemoteConfig():
return $default(_that.minAppVersion);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String minAppVersion)?  $default,) {final _that = this;
switch (_that) {
case _AppRemoteConfig() when $default != null:
return $default(_that.minAppVersion);case _:
  return null;

}
}

}

/// @nodoc


class _AppRemoteConfig implements AppRemoteConfig {
  const _AppRemoteConfig({this.minAppVersion = "1.0.0"});
  

@override@JsonKey() final  String minAppVersion;

/// Create a copy of AppRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppRemoteConfigCopyWith<_AppRemoteConfig> get copyWith => __$AppRemoteConfigCopyWithImpl<_AppRemoteConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppRemoteConfig&&(identical(other.minAppVersion, minAppVersion) || other.minAppVersion == minAppVersion));
}


@override
int get hashCode => Object.hash(runtimeType,minAppVersion);

@override
String toString() {
  return 'AppRemoteConfig(minAppVersion: $minAppVersion)';
}


}

/// @nodoc
abstract mixin class _$AppRemoteConfigCopyWith<$Res> implements $AppRemoteConfigCopyWith<$Res> {
  factory _$AppRemoteConfigCopyWith(_AppRemoteConfig value, $Res Function(_AppRemoteConfig) _then) = __$AppRemoteConfigCopyWithImpl;
@override @useResult
$Res call({
 String minAppVersion
});




}
/// @nodoc
class __$AppRemoteConfigCopyWithImpl<$Res>
    implements _$AppRemoteConfigCopyWith<$Res> {
  __$AppRemoteConfigCopyWithImpl(this._self, this._then);

  final _AppRemoteConfig _self;
  final $Res Function(_AppRemoteConfig) _then;

/// Create a copy of AppRemoteConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? minAppVersion = null,}) {
  return _then(_AppRemoteConfig(
minAppVersion: null == minAppVersion ? _self.minAppVersion : minAppVersion // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
