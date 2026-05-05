// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$PurchaseState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Offering? offering) loading,
    required TResult Function(Offering? offering, bool isPro) idle,
    required TResult Function(String message, Offering? offering, bool isPro)
    error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Offering? offering)? loading,
    TResult? Function(Offering? offering, bool isPro)? idle,
    TResult? Function(String message, Offering? offering, bool isPro)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Offering? offering)? loading,
    TResult Function(Offering? offering, bool isPro)? idle,
    TResult Function(String message, Offering? offering, bool isPro)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseStateInitial value) initial,
    required TResult Function(PurchaseStateLoading value) loading,
    required TResult Function(PurchaseStateIdle value) idle,
    required TResult Function(PurchaseStateError value) error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseStateInitial value)? initial,
    TResult? Function(PurchaseStateLoading value)? loading,
    TResult? Function(PurchaseStateIdle value)? idle,
    TResult? Function(PurchaseStateError value)? error,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseStateInitial value)? initial,
    TResult Function(PurchaseStateLoading value)? loading,
    TResult Function(PurchaseStateIdle value)? idle,
    TResult Function(PurchaseStateError value)? error,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PurchaseStateCopyWith<$Res> {
  factory $PurchaseStateCopyWith(
    PurchaseState value,
    $Res Function(PurchaseState) then,
  ) = _$PurchaseStateCopyWithImpl<$Res, PurchaseState>;
}

/// @nodoc
class _$PurchaseStateCopyWithImpl<$Res, $Val extends PurchaseState>
    implements $PurchaseStateCopyWith<$Res> {
  _$PurchaseStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$PurchaseStateInitialImplCopyWith<$Res> {
  factory _$$PurchaseStateInitialImplCopyWith(
    _$PurchaseStateInitialImpl value,
    $Res Function(_$PurchaseStateInitialImpl) then,
  ) = __$$PurchaseStateInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$PurchaseStateInitialImplCopyWithImpl<$Res>
    extends _$PurchaseStateCopyWithImpl<$Res, _$PurchaseStateInitialImpl>
    implements _$$PurchaseStateInitialImplCopyWith<$Res> {
  __$$PurchaseStateInitialImplCopyWithImpl(
    _$PurchaseStateInitialImpl _value,
    $Res Function(_$PurchaseStateInitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$PurchaseStateInitialImpl implements PurchaseStateInitial {
  const _$PurchaseStateInitialImpl();

  @override
  String toString() {
    return 'PurchaseState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseStateInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Offering? offering) loading,
    required TResult Function(Offering? offering, bool isPro) idle,
    required TResult Function(String message, Offering? offering, bool isPro)
    error,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Offering? offering)? loading,
    TResult? Function(Offering? offering, bool isPro)? idle,
    TResult? Function(String message, Offering? offering, bool isPro)? error,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Offering? offering)? loading,
    TResult Function(Offering? offering, bool isPro)? idle,
    TResult Function(String message, Offering? offering, bool isPro)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseStateInitial value) initial,
    required TResult Function(PurchaseStateLoading value) loading,
    required TResult Function(PurchaseStateIdle value) idle,
    required TResult Function(PurchaseStateError value) error,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseStateInitial value)? initial,
    TResult? Function(PurchaseStateLoading value)? loading,
    TResult? Function(PurchaseStateIdle value)? idle,
    TResult? Function(PurchaseStateError value)? error,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseStateInitial value)? initial,
    TResult Function(PurchaseStateLoading value)? loading,
    TResult Function(PurchaseStateIdle value)? idle,
    TResult Function(PurchaseStateError value)? error,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class PurchaseStateInitial implements PurchaseState {
  const factory PurchaseStateInitial() = _$PurchaseStateInitialImpl;
}

/// @nodoc
abstract class _$$PurchaseStateLoadingImplCopyWith<$Res> {
  factory _$$PurchaseStateLoadingImplCopyWith(
    _$PurchaseStateLoadingImpl value,
    $Res Function(_$PurchaseStateLoadingImpl) then,
  ) = __$$PurchaseStateLoadingImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Offering? offering});
}

/// @nodoc
class __$$PurchaseStateLoadingImplCopyWithImpl<$Res>
    extends _$PurchaseStateCopyWithImpl<$Res, _$PurchaseStateLoadingImpl>
    implements _$$PurchaseStateLoadingImplCopyWith<$Res> {
  __$$PurchaseStateLoadingImplCopyWithImpl(
    _$PurchaseStateLoadingImpl _value,
    $Res Function(_$PurchaseStateLoadingImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? offering = freezed}) {
    return _then(
      _$PurchaseStateLoadingImpl(
        offering: freezed == offering
            ? _value.offering
            : offering // ignore: cast_nullable_to_non_nullable
                  as Offering?,
      ),
    );
  }
}

/// @nodoc

class _$PurchaseStateLoadingImpl implements PurchaseStateLoading {
  const _$PurchaseStateLoadingImpl({this.offering});

  @override
  final Offering? offering;

  @override
  String toString() {
    return 'PurchaseState.loading(offering: $offering)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseStateLoadingImpl &&
            (identical(other.offering, offering) ||
                other.offering == offering));
  }

  @override
  int get hashCode => Object.hash(runtimeType, offering);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseStateLoadingImplCopyWith<_$PurchaseStateLoadingImpl>
  get copyWith =>
      __$$PurchaseStateLoadingImplCopyWithImpl<_$PurchaseStateLoadingImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Offering? offering) loading,
    required TResult Function(Offering? offering, bool isPro) idle,
    required TResult Function(String message, Offering? offering, bool isPro)
    error,
  }) {
    return loading(offering);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Offering? offering)? loading,
    TResult? Function(Offering? offering, bool isPro)? idle,
    TResult? Function(String message, Offering? offering, bool isPro)? error,
  }) {
    return loading?.call(offering);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Offering? offering)? loading,
    TResult Function(Offering? offering, bool isPro)? idle,
    TResult Function(String message, Offering? offering, bool isPro)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(offering);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseStateInitial value) initial,
    required TResult Function(PurchaseStateLoading value) loading,
    required TResult Function(PurchaseStateIdle value) idle,
    required TResult Function(PurchaseStateError value) error,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseStateInitial value)? initial,
    TResult? Function(PurchaseStateLoading value)? loading,
    TResult? Function(PurchaseStateIdle value)? idle,
    TResult? Function(PurchaseStateError value)? error,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseStateInitial value)? initial,
    TResult Function(PurchaseStateLoading value)? loading,
    TResult Function(PurchaseStateIdle value)? idle,
    TResult Function(PurchaseStateError value)? error,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class PurchaseStateLoading implements PurchaseState {
  const factory PurchaseStateLoading({final Offering? offering}) =
      _$PurchaseStateLoadingImpl;

  Offering? get offering;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseStateLoadingImplCopyWith<_$PurchaseStateLoadingImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PurchaseStateIdleImplCopyWith<$Res> {
  factory _$$PurchaseStateIdleImplCopyWith(
    _$PurchaseStateIdleImpl value,
    $Res Function(_$PurchaseStateIdleImpl) then,
  ) = __$$PurchaseStateIdleImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Offering? offering, bool isPro});
}

/// @nodoc
class __$$PurchaseStateIdleImplCopyWithImpl<$Res>
    extends _$PurchaseStateCopyWithImpl<$Res, _$PurchaseStateIdleImpl>
    implements _$$PurchaseStateIdleImplCopyWith<$Res> {
  __$$PurchaseStateIdleImplCopyWithImpl(
    _$PurchaseStateIdleImpl _value,
    $Res Function(_$PurchaseStateIdleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? offering = freezed, Object? isPro = null}) {
    return _then(
      _$PurchaseStateIdleImpl(
        offering: freezed == offering
            ? _value.offering
            : offering // ignore: cast_nullable_to_non_nullable
                  as Offering?,
        isPro: null == isPro
            ? _value.isPro
            : isPro // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PurchaseStateIdleImpl implements PurchaseStateIdle {
  const _$PurchaseStateIdleImpl({required this.offering, required this.isPro});

  @override
  final Offering? offering;
  @override
  final bool isPro;

  @override
  String toString() {
    return 'PurchaseState.idle(offering: $offering, isPro: $isPro)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseStateIdleImpl &&
            (identical(other.offering, offering) ||
                other.offering == offering) &&
            (identical(other.isPro, isPro) || other.isPro == isPro));
  }

  @override
  int get hashCode => Object.hash(runtimeType, offering, isPro);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseStateIdleImplCopyWith<_$PurchaseStateIdleImpl> get copyWith =>
      __$$PurchaseStateIdleImplCopyWithImpl<_$PurchaseStateIdleImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Offering? offering) loading,
    required TResult Function(Offering? offering, bool isPro) idle,
    required TResult Function(String message, Offering? offering, bool isPro)
    error,
  }) {
    return idle(offering, isPro);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Offering? offering)? loading,
    TResult? Function(Offering? offering, bool isPro)? idle,
    TResult? Function(String message, Offering? offering, bool isPro)? error,
  }) {
    return idle?.call(offering, isPro);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Offering? offering)? loading,
    TResult Function(Offering? offering, bool isPro)? idle,
    TResult Function(String message, Offering? offering, bool isPro)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(offering, isPro);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseStateInitial value) initial,
    required TResult Function(PurchaseStateLoading value) loading,
    required TResult Function(PurchaseStateIdle value) idle,
    required TResult Function(PurchaseStateError value) error,
  }) {
    return idle(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseStateInitial value)? initial,
    TResult? Function(PurchaseStateLoading value)? loading,
    TResult? Function(PurchaseStateIdle value)? idle,
    TResult? Function(PurchaseStateError value)? error,
  }) {
    return idle?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseStateInitial value)? initial,
    TResult Function(PurchaseStateLoading value)? loading,
    TResult Function(PurchaseStateIdle value)? idle,
    TResult Function(PurchaseStateError value)? error,
    required TResult orElse(),
  }) {
    if (idle != null) {
      return idle(this);
    }
    return orElse();
  }
}

abstract class PurchaseStateIdle implements PurchaseState {
  const factory PurchaseStateIdle({
    required final Offering? offering,
    required final bool isPro,
  }) = _$PurchaseStateIdleImpl;

  Offering? get offering;
  bool get isPro;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseStateIdleImplCopyWith<_$PurchaseStateIdleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PurchaseStateErrorImplCopyWith<$Res> {
  factory _$$PurchaseStateErrorImplCopyWith(
    _$PurchaseStateErrorImpl value,
    $Res Function(_$PurchaseStateErrorImpl) then,
  ) = __$$PurchaseStateErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message, Offering? offering, bool isPro});
}

/// @nodoc
class __$$PurchaseStateErrorImplCopyWithImpl<$Res>
    extends _$PurchaseStateCopyWithImpl<$Res, _$PurchaseStateErrorImpl>
    implements _$$PurchaseStateErrorImplCopyWith<$Res> {
  __$$PurchaseStateErrorImplCopyWithImpl(
    _$PurchaseStateErrorImpl _value,
    $Res Function(_$PurchaseStateErrorImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? offering = freezed,
    Object? isPro = null,
  }) {
    return _then(
      _$PurchaseStateErrorImpl(
        message: null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
        offering: freezed == offering
            ? _value.offering
            : offering // ignore: cast_nullable_to_non_nullable
                  as Offering?,
        isPro: null == isPro
            ? _value.isPro
            : isPro // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$PurchaseStateErrorImpl implements PurchaseStateError {
  const _$PurchaseStateErrorImpl({
    required this.message,
    this.offering,
    required this.isPro,
  });

  @override
  final String message;
  @override
  final Offering? offering;
  @override
  final bool isPro;

  @override
  String toString() {
    return 'PurchaseState.error(message: $message, offering: $offering, isPro: $isPro)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PurchaseStateErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.offering, offering) ||
                other.offering == offering) &&
            (identical(other.isPro, isPro) || other.isPro == isPro));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, offering, isPro);

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PurchaseStateErrorImplCopyWith<_$PurchaseStateErrorImpl> get copyWith =>
      __$$PurchaseStateErrorImplCopyWithImpl<_$PurchaseStateErrorImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(Offering? offering) loading,
    required TResult Function(Offering? offering, bool isPro) idle,
    required TResult Function(String message, Offering? offering, bool isPro)
    error,
  }) {
    return error(message, offering, isPro);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(Offering? offering)? loading,
    TResult? Function(Offering? offering, bool isPro)? idle,
    TResult? Function(String message, Offering? offering, bool isPro)? error,
  }) {
    return error?.call(message, offering, isPro);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(Offering? offering)? loading,
    TResult Function(Offering? offering, bool isPro)? idle,
    TResult Function(String message, Offering? offering, bool isPro)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message, offering, isPro);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(PurchaseStateInitial value) initial,
    required TResult Function(PurchaseStateLoading value) loading,
    required TResult Function(PurchaseStateIdle value) idle,
    required TResult Function(PurchaseStateError value) error,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(PurchaseStateInitial value)? initial,
    TResult? Function(PurchaseStateLoading value)? loading,
    TResult? Function(PurchaseStateIdle value)? idle,
    TResult? Function(PurchaseStateError value)? error,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(PurchaseStateInitial value)? initial,
    TResult Function(PurchaseStateLoading value)? loading,
    TResult Function(PurchaseStateIdle value)? idle,
    TResult Function(PurchaseStateError value)? error,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class PurchaseStateError implements PurchaseState {
  const factory PurchaseStateError({
    required final String message,
    final Offering? offering,
    required final bool isPro,
  }) = _$PurchaseStateErrorImpl;

  String get message;
  Offering? get offering;
  bool get isPro;

  /// Create a copy of PurchaseState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PurchaseStateErrorImplCopyWith<_$PurchaseStateErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
