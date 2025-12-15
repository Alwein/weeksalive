// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quick_action_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$QuickActionEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(String type) trigger,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(String type)? trigger,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(String type)? trigger,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Trigger value) trigger,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Trigger value)? trigger,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Trigger value)? trigger,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickActionEventCopyWith<$Res> {
  factory $QuickActionEventCopyWith(
    QuickActionEvent value,
    $Res Function(QuickActionEvent) then,
  ) = _$QuickActionEventCopyWithImpl<$Res, QuickActionEvent>;
}

/// @nodoc
class _$QuickActionEventCopyWithImpl<$Res, $Val extends QuickActionEvent>
    implements $QuickActionEventCopyWith<$Res> {
  _$QuickActionEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickActionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StartedImplCopyWith<$Res> {
  factory _$$StartedImplCopyWith(
    _$StartedImpl value,
    $Res Function(_$StartedImpl) then,
  ) = __$$StartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartedImplCopyWithImpl<$Res>
    extends _$QuickActionEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
    _$StartedImpl _value,
    $Res Function(_$StartedImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuickActionEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartedImpl implements _Started {
  const _$StartedImpl();

  @override
  String toString() {
    return 'QuickActionEvent.started()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(String type) trigger,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(String type)? trigger,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(String type)? trigger,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Trigger value) trigger,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Trigger value)? trigger,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Trigger value)? trigger,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements QuickActionEvent {
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$TriggerImplCopyWith<$Res> {
  factory _$$TriggerImplCopyWith(
    _$TriggerImpl value,
    $Res Function(_$TriggerImpl) then,
  ) = __$$TriggerImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String type});
}

/// @nodoc
class __$$TriggerImplCopyWithImpl<$Res>
    extends _$QuickActionEventCopyWithImpl<$Res, _$TriggerImpl>
    implements _$$TriggerImplCopyWith<$Res> {
  __$$TriggerImplCopyWithImpl(
    _$TriggerImpl _value,
    $Res Function(_$TriggerImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuickActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null}) {
    return _then(
      _$TriggerImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$TriggerImpl implements _Trigger {
  const _$TriggerImpl({required this.type});

  @override
  final String type;

  @override
  String toString() {
    return 'QuickActionEvent.trigger(type: $type)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggerImpl &&
            (identical(other.type, type) || other.type == type));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type);

  /// Create a copy of QuickActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggerImplCopyWith<_$TriggerImpl> get copyWith =>
      __$$TriggerImplCopyWithImpl<_$TriggerImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(String type) trigger,
  }) {
    return trigger(type);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(String type)? trigger,
  }) {
    return trigger?.call(type);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(String type)? trigger,
    required TResult orElse(),
  }) {
    if (trigger != null) {
      return trigger(type);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_Trigger value) trigger,
  }) {
    return trigger(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_Trigger value)? trigger,
  }) {
    return trigger?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_Trigger value)? trigger,
    required TResult orElse(),
  }) {
    if (trigger != null) {
      return trigger(this);
    }
    return orElse();
  }
}

abstract class _Trigger implements QuickActionEvent {
  const factory _Trigger({required final String type}) = _$TriggerImpl;

  String get type;

  /// Create a copy of QuickActionEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TriggerImplCopyWith<_$TriggerImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QuickActionState {
  QuickActionStatus get status => throw _privateConstructorUsedError;

  /// Create a copy of QuickActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuickActionStateCopyWith<QuickActionState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickActionStateCopyWith<$Res> {
  factory $QuickActionStateCopyWith(
    QuickActionState value,
    $Res Function(QuickActionState) then,
  ) = _$QuickActionStateCopyWithImpl<$Res, QuickActionState>;
  @useResult
  $Res call({QuickActionStatus status});

  $QuickActionStatusCopyWith<$Res> get status;
}

/// @nodoc
class _$QuickActionStateCopyWithImpl<$Res, $Val extends QuickActionState>
    implements $QuickActionStateCopyWith<$Res> {
  _$QuickActionStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _value.copyWith(
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as QuickActionStatus,
          )
          as $Val,
    );
  }

  /// Create a copy of QuickActionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $QuickActionStatusCopyWith<$Res> get status {
    return $QuickActionStatusCopyWith<$Res>(_value.status, (value) {
      return _then(_value.copyWith(status: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuickActionStateImplCopyWith<$Res>
    implements $QuickActionStateCopyWith<$Res> {
  factory _$$QuickActionStateImplCopyWith(
    _$QuickActionStateImpl value,
    $Res Function(_$QuickActionStateImpl) then,
  ) = __$$QuickActionStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({QuickActionStatus status});

  @override
  $QuickActionStatusCopyWith<$Res> get status;
}

/// @nodoc
class __$$QuickActionStateImplCopyWithImpl<$Res>
    extends _$QuickActionStateCopyWithImpl<$Res, _$QuickActionStateImpl>
    implements _$$QuickActionStateImplCopyWith<$Res> {
  __$$QuickActionStateImplCopyWithImpl(
    _$QuickActionStateImpl _value,
    $Res Function(_$QuickActionStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuickActionState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? status = null}) {
    return _then(
      _$QuickActionStateImpl(
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as QuickActionStatus,
      ),
    );
  }
}

/// @nodoc

class _$QuickActionStateImpl implements _QuickActionState {
  const _$QuickActionStateImpl({
    this.status = const QuickActionStatus.initial(),
  });

  @override
  @JsonKey()
  final QuickActionStatus status;

  @override
  String toString() {
    return 'QuickActionState(status: $status)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuickActionStateImpl &&
            (identical(other.status, status) || other.status == status));
  }

  @override
  int get hashCode => Object.hash(runtimeType, status);

  /// Create a copy of QuickActionState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuickActionStateImplCopyWith<_$QuickActionStateImpl> get copyWith =>
      __$$QuickActionStateImplCopyWithImpl<_$QuickActionStateImpl>(
        this,
        _$identity,
      );
}

abstract class _QuickActionState implements QuickActionState {
  const factory _QuickActionState({final QuickActionStatus status}) =
      _$QuickActionStateImpl;

  @override
  QuickActionStatus get status;

  /// Create a copy of QuickActionState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuickActionStateImplCopyWith<_$QuickActionStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$QuickActionStatus {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String type, DateTime timestamp) triggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String type, DateTime timestamp)? triggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String type, DateTime timestamp)? triggered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Triggered value) triggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Triggered value)? triggered,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Triggered value)? triggered,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuickActionStatusCopyWith<$Res> {
  factory $QuickActionStatusCopyWith(
    QuickActionStatus value,
    $Res Function(QuickActionStatus) then,
  ) = _$QuickActionStatusCopyWithImpl<$Res, QuickActionStatus>;
}

/// @nodoc
class _$QuickActionStatusCopyWithImpl<$Res, $Val extends QuickActionStatus>
    implements $QuickActionStatusCopyWith<$Res> {
  _$QuickActionStatusCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuickActionStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
    _$InitialImpl value,
    $Res Function(_$InitialImpl) then,
  ) = __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$QuickActionStatusCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
    _$InitialImpl _value,
    $Res Function(_$InitialImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuickActionStatus
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl implements _Initial {
  const _$InitialImpl();

  @override
  String toString() {
    return 'QuickActionStatus.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String type, DateTime timestamp) triggered,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String type, DateTime timestamp)? triggered,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String type, DateTime timestamp)? triggered,
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
    required TResult Function(_Initial value) initial,
    required TResult Function(_Triggered value) triggered,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Triggered value)? triggered,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Triggered value)? triggered,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements QuickActionStatus {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$TriggeredImplCopyWith<$Res> {
  factory _$$TriggeredImplCopyWith(
    _$TriggeredImpl value,
    $Res Function(_$TriggeredImpl) then,
  ) = __$$TriggeredImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String type, DateTime timestamp});
}

/// @nodoc
class __$$TriggeredImplCopyWithImpl<$Res>
    extends _$QuickActionStatusCopyWithImpl<$Res, _$TriggeredImpl>
    implements _$$TriggeredImplCopyWith<$Res> {
  __$$TriggeredImplCopyWithImpl(
    _$TriggeredImpl _value,
    $Res Function(_$TriggeredImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of QuickActionStatus
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? type = null, Object? timestamp = null}) {
    return _then(
      _$TriggeredImpl(
        type: null == type
            ? _value.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        timestamp: null == timestamp
            ? _value.timestamp
            : timestamp // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc

class _$TriggeredImpl implements _Triggered {
  const _$TriggeredImpl({required this.type, required this.timestamp});

  @override
  final String type;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'QuickActionStatus.triggered(type: $type, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TriggeredImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @override
  int get hashCode => Object.hash(runtimeType, type, timestamp);

  /// Create a copy of QuickActionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TriggeredImplCopyWith<_$TriggeredImpl> get copyWith =>
      __$$TriggeredImplCopyWithImpl<_$TriggeredImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function(String type, DateTime timestamp) triggered,
  }) {
    return triggered(type, timestamp);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function(String type, DateTime timestamp)? triggered,
  }) {
    return triggered?.call(type, timestamp);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function(String type, DateTime timestamp)? triggered,
    required TResult orElse(),
  }) {
    if (triggered != null) {
      return triggered(type, timestamp);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Triggered value) triggered,
  }) {
    return triggered(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Triggered value)? triggered,
  }) {
    return triggered?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Triggered value)? triggered,
    required TResult orElse(),
  }) {
    if (triggered != null) {
      return triggered(this);
    }
    return orElse();
  }
}

abstract class _Triggered implements QuickActionStatus {
  const factory _Triggered({
    required final String type,
    required final DateTime timestamp,
  }) = _$TriggeredImpl;

  String get type;
  DateTime get timestamp;

  /// Create a copy of QuickActionStatus
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TriggeredImplCopyWith<_$TriggeredImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
