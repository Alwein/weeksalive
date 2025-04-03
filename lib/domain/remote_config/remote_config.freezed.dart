// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AppRemoteConfig {
  String get minAppVersion => throw _privateConstructorUsedError;

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppRemoteConfigCopyWith<AppRemoteConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppRemoteConfigCopyWith<$Res> {
  factory $AppRemoteConfigCopyWith(
          AppRemoteConfig value, $Res Function(AppRemoteConfig) then) =
      _$AppRemoteConfigCopyWithImpl<$Res, AppRemoteConfig>;
  @useResult
  $Res call({String minAppVersion});
}

/// @nodoc
class _$AppRemoteConfigCopyWithImpl<$Res, $Val extends AppRemoteConfig>
    implements $AppRemoteConfigCopyWith<$Res> {
  _$AppRemoteConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minAppVersion = null,
  }) {
    return _then(_value.copyWith(
      minAppVersion: null == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AppRemoteConfigImplCopyWith<$Res>
    implements $AppRemoteConfigCopyWith<$Res> {
  factory _$$AppRemoteConfigImplCopyWith(_$AppRemoteConfigImpl value,
          $Res Function(_$AppRemoteConfigImpl) then) =
      __$$AppRemoteConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String minAppVersion});
}

/// @nodoc
class __$$AppRemoteConfigImplCopyWithImpl<$Res>
    extends _$AppRemoteConfigCopyWithImpl<$Res, _$AppRemoteConfigImpl>
    implements _$$AppRemoteConfigImplCopyWith<$Res> {
  __$$AppRemoteConfigImplCopyWithImpl(
      _$AppRemoteConfigImpl _value, $Res Function(_$AppRemoteConfigImpl) _then)
      : super(_value, _then);

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? minAppVersion = null,
  }) {
    return _then(_$AppRemoteConfigImpl(
      minAppVersion: null == minAppVersion
          ? _value.minAppVersion
          : minAppVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AppRemoteConfigImpl implements _AppRemoteConfig {
  const _$AppRemoteConfigImpl({this.minAppVersion = "1.0.0"});

  @override
  @JsonKey()
  final String minAppVersion;

  @override
  String toString() {
    return 'AppRemoteConfig(minAppVersion: $minAppVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppRemoteConfigImpl &&
            (identical(other.minAppVersion, minAppVersion) ||
                other.minAppVersion == minAppVersion));
  }

  @override
  int get hashCode => Object.hash(runtimeType, minAppVersion);

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppRemoteConfigImplCopyWith<_$AppRemoteConfigImpl> get copyWith =>
      __$$AppRemoteConfigImplCopyWithImpl<_$AppRemoteConfigImpl>(
          this, _$identity);
}

abstract class _AppRemoteConfig implements AppRemoteConfig {
  const factory _AppRemoteConfig({final String minAppVersion}) =
      _$AppRemoteConfigImpl;

  @override
  String get minAppVersion;

  /// Create a copy of AppRemoteConfig
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppRemoteConfigImplCopyWith<_$AppRemoteConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
