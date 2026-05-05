// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AppState {
  RemoteConfigState get remoteConfigState => throw _privateConstructorUsedError;
  UserState get userState => throw _privateConstructorUsedError;
  PurchaseState get purchaseState => throw _privateConstructorUsedError;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AppStateCopyWith<AppState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AppStateCopyWith<$Res> {
  factory $AppStateCopyWith(AppState value, $Res Function(AppState) then) =
      _$AppStateCopyWithImpl<$Res, AppState>;
  @useResult
  $Res call({
    RemoteConfigState remoteConfigState,
    UserState userState,
    PurchaseState purchaseState,
  });

  $RemoteConfigStateCopyWith<$Res> get remoteConfigState;
  $UserStateCopyWith<$Res> get userState;
  $PurchaseStateCopyWith<$Res> get purchaseState;
}

/// @nodoc
class _$AppStateCopyWithImpl<$Res, $Val extends AppState>
    implements $AppStateCopyWith<$Res> {
  _$AppStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remoteConfigState = null,
    Object? userState = null,
    Object? purchaseState = null,
  }) {
    return _then(
      _value.copyWith(
            remoteConfigState: null == remoteConfigState
                ? _value.remoteConfigState
                : remoteConfigState // ignore: cast_nullable_to_non_nullable
                      as RemoteConfigState,
            userState: null == userState
                ? _value.userState
                : userState // ignore: cast_nullable_to_non_nullable
                      as UserState,
            purchaseState: null == purchaseState
                ? _value.purchaseState
                : purchaseState // ignore: cast_nullable_to_non_nullable
                      as PurchaseState,
          )
          as $Val,
    );
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $RemoteConfigStateCopyWith<$Res> get remoteConfigState {
    return $RemoteConfigStateCopyWith<$Res>(_value.remoteConfigState, (value) {
      return _then(_value.copyWith(remoteConfigState: value) as $Val);
    });
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserStateCopyWith<$Res> get userState {
    return $UserStateCopyWith<$Res>(_value.userState, (value) {
      return _then(_value.copyWith(userState: value) as $Val);
    });
  }

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $PurchaseStateCopyWith<$Res> get purchaseState {
    return $PurchaseStateCopyWith<$Res>(_value.purchaseState, (value) {
      return _then(_value.copyWith(purchaseState: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AppStateImplCopyWith<$Res>
    implements $AppStateCopyWith<$Res> {
  factory _$$AppStateImplCopyWith(
    _$AppStateImpl value,
    $Res Function(_$AppStateImpl) then,
  ) = __$$AppStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    RemoteConfigState remoteConfigState,
    UserState userState,
    PurchaseState purchaseState,
  });

  @override
  $RemoteConfigStateCopyWith<$Res> get remoteConfigState;
  @override
  $UserStateCopyWith<$Res> get userState;
  @override
  $PurchaseStateCopyWith<$Res> get purchaseState;
}

/// @nodoc
class __$$AppStateImplCopyWithImpl<$Res>
    extends _$AppStateCopyWithImpl<$Res, _$AppStateImpl>
    implements _$$AppStateImplCopyWith<$Res> {
  __$$AppStateImplCopyWithImpl(
    _$AppStateImpl _value,
    $Res Function(_$AppStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? remoteConfigState = null,
    Object? userState = null,
    Object? purchaseState = null,
  }) {
    return _then(
      _$AppStateImpl(
        remoteConfigState: null == remoteConfigState
            ? _value.remoteConfigState
            : remoteConfigState // ignore: cast_nullable_to_non_nullable
                  as RemoteConfigState,
        userState: null == userState
            ? _value.userState
            : userState // ignore: cast_nullable_to_non_nullable
                  as UserState,
        purchaseState: null == purchaseState
            ? _value.purchaseState
            : purchaseState // ignore: cast_nullable_to_non_nullable
                  as PurchaseState,
      ),
    );
  }
}

/// @nodoc

class _$AppStateImpl implements _AppState {
  const _$AppStateImpl({
    required this.remoteConfigState,
    required this.userState,
    required this.purchaseState,
  });

  @override
  final RemoteConfigState remoteConfigState;
  @override
  final UserState userState;
  @override
  final PurchaseState purchaseState;

  @override
  String toString() {
    return 'AppState(remoteConfigState: $remoteConfigState, userState: $userState, purchaseState: $purchaseState)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AppStateImpl &&
            (identical(other.remoteConfigState, remoteConfigState) ||
                other.remoteConfigState == remoteConfigState) &&
            (identical(other.userState, userState) ||
                other.userState == userState) &&
            (identical(other.purchaseState, purchaseState) ||
                other.purchaseState == purchaseState));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, remoteConfigState, userState, purchaseState);

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      __$$AppStateImplCopyWithImpl<_$AppStateImpl>(this, _$identity);
}

abstract class _AppState implements AppState {
  const factory _AppState({
    required final RemoteConfigState remoteConfigState,
    required final UserState userState,
    required final PurchaseState purchaseState,
  }) = _$AppStateImpl;

  @override
  RemoteConfigState get remoteConfigState;
  @override
  UserState get userState;
  @override
  PurchaseState get purchaseState;

  /// Create a copy of AppState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AppStateImplCopyWith<_$AppStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
