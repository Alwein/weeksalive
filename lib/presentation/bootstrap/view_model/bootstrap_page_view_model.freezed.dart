// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bootstrap_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$BootstrapPageViewModel {
  bool get showOnboarding => throw _privateConstructorUsedError;

  /// Create a copy of BootstrapPageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BootstrapPageViewModelCopyWith<BootstrapPageViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BootstrapPageViewModelCopyWith<$Res> {
  factory $BootstrapPageViewModelCopyWith(
    BootstrapPageViewModel value,
    $Res Function(BootstrapPageViewModel) then,
  ) = _$BootstrapPageViewModelCopyWithImpl<$Res, BootstrapPageViewModel>;
  @useResult
  $Res call({bool showOnboarding});
}

/// @nodoc
class _$BootstrapPageViewModelCopyWithImpl<
  $Res,
  $Val extends BootstrapPageViewModel
>
    implements $BootstrapPageViewModelCopyWith<$Res> {
  _$BootstrapPageViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BootstrapPageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? showOnboarding = null}) {
    return _then(
      _value.copyWith(
            showOnboarding: null == showOnboarding
                ? _value.showOnboarding
                : showOnboarding // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BootstrapPageViewModelImplCopyWith<$Res>
    implements $BootstrapPageViewModelCopyWith<$Res> {
  factory _$$BootstrapPageViewModelImplCopyWith(
    _$BootstrapPageViewModelImpl value,
    $Res Function(_$BootstrapPageViewModelImpl) then,
  ) = __$$BootstrapPageViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool showOnboarding});
}

/// @nodoc
class __$$BootstrapPageViewModelImplCopyWithImpl<$Res>
    extends
        _$BootstrapPageViewModelCopyWithImpl<$Res, _$BootstrapPageViewModelImpl>
    implements _$$BootstrapPageViewModelImplCopyWith<$Res> {
  __$$BootstrapPageViewModelImplCopyWithImpl(
    _$BootstrapPageViewModelImpl _value,
    $Res Function(_$BootstrapPageViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BootstrapPageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? showOnboarding = null}) {
    return _then(
      _$BootstrapPageViewModelImpl(
        showOnboarding: null == showOnboarding
            ? _value.showOnboarding
            : showOnboarding // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc

class _$BootstrapPageViewModelImpl implements _BootstrapPageViewModel {
  const _$BootstrapPageViewModelImpl({required this.showOnboarding});

  @override
  final bool showOnboarding;

  @override
  String toString() {
    return 'BootstrapPageViewModel._(showOnboarding: $showOnboarding)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BootstrapPageViewModelImpl &&
            (identical(other.showOnboarding, showOnboarding) ||
                other.showOnboarding == showOnboarding));
  }

  @override
  int get hashCode => Object.hash(runtimeType, showOnboarding);

  /// Create a copy of BootstrapPageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BootstrapPageViewModelImplCopyWith<_$BootstrapPageViewModelImpl>
  get copyWith =>
      __$$BootstrapPageViewModelImplCopyWithImpl<_$BootstrapPageViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _BootstrapPageViewModel implements BootstrapPageViewModel {
  const factory _BootstrapPageViewModel({required final bool showOnboarding}) =
      _$BootstrapPageViewModelImpl;

  @override
  bool get showOnboarding;

  /// Create a copy of BootstrapPageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BootstrapPageViewModelImplCopyWith<_$BootstrapPageViewModelImpl>
  get copyWith => throw _privateConstructorUsedError;
}
