// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'remote_config_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$RemoteConfigState {
  AppRemoteConfig? get remoteConfig => throw _privateConstructorUsedError;

  /// Create a copy of RemoteConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RemoteConfigStateCopyWith<RemoteConfigState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RemoteConfigStateCopyWith<$Res> {
  factory $RemoteConfigStateCopyWith(
    RemoteConfigState value,
    $Res Function(RemoteConfigState) then,
  ) = _$RemoteConfigStateCopyWithImpl<$Res, RemoteConfigState>;
  @useResult
  $Res call({AppRemoteConfig? remoteConfig});

  $AppRemoteConfigCopyWith<$Res>? get remoteConfig;
}

/// @nodoc
class _$RemoteConfigStateCopyWithImpl<$Res, $Val extends RemoteConfigState>
    implements $RemoteConfigStateCopyWith<$Res> {
  _$RemoteConfigStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RemoteConfigState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? remoteConfig = freezed}) {
    return _then(
      _value.copyWith(
            remoteConfig: freezed == remoteConfig
                ? _value.remoteConfig
                : remoteConfig // ignore: cast_nullable_to_non_nullable
                      as AppRemoteConfig?,
          )
          as $Val,
    );
  }

  /// Create a copy of RemoteConfigState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AppRemoteConfigCopyWith<$Res>? get remoteConfig {
    if (_value.remoteConfig == null) {
      return null;
    }

    return $AppRemoteConfigCopyWith<$Res>(_value.remoteConfig!, (value) {
      return _then(_value.copyWith(remoteConfig: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$RemoteConfigStateImplCopyWith<$Res>
    implements $RemoteConfigStateCopyWith<$Res> {
  factory _$$RemoteConfigStateImplCopyWith(
    _$RemoteConfigStateImpl value,
    $Res Function(_$RemoteConfigStateImpl) then,
  ) = __$$RemoteConfigStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({AppRemoteConfig? remoteConfig});

  @override
  $AppRemoteConfigCopyWith<$Res>? get remoteConfig;
}

/// @nodoc
class __$$RemoteConfigStateImplCopyWithImpl<$Res>
    extends _$RemoteConfigStateCopyWithImpl<$Res, _$RemoteConfigStateImpl>
    implements _$$RemoteConfigStateImplCopyWith<$Res> {
  __$$RemoteConfigStateImplCopyWithImpl(
    _$RemoteConfigStateImpl _value,
    $Res Function(_$RemoteConfigStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of RemoteConfigState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? remoteConfig = freezed}) {
    return _then(
      _$RemoteConfigStateImpl(
        remoteConfig: freezed == remoteConfig
            ? _value.remoteConfig
            : remoteConfig // ignore: cast_nullable_to_non_nullable
                  as AppRemoteConfig?,
      ),
    );
  }
}

/// @nodoc

class _$RemoteConfigStateImpl implements _RemoteConfigState {
  const _$RemoteConfigStateImpl({this.remoteConfig});

  @override
  final AppRemoteConfig? remoteConfig;

  @override
  String toString() {
    return 'RemoteConfigState(remoteConfig: $remoteConfig)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RemoteConfigStateImpl &&
            (identical(other.remoteConfig, remoteConfig) ||
                other.remoteConfig == remoteConfig));
  }

  @override
  int get hashCode => Object.hash(runtimeType, remoteConfig);

  /// Create a copy of RemoteConfigState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RemoteConfigStateImplCopyWith<_$RemoteConfigStateImpl> get copyWith =>
      __$$RemoteConfigStateImplCopyWithImpl<_$RemoteConfigStateImpl>(
        this,
        _$identity,
      );
}

abstract class _RemoteConfigState implements RemoteConfigState {
  const factory _RemoteConfigState({final AppRemoteConfig? remoteConfig}) =
      _$RemoteConfigStateImpl;

  @override
  AppRemoteConfig? get remoteConfig;

  /// Create a copy of RemoteConfigState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RemoteConfigStateImplCopyWith<_$RemoteConfigStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
