// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'day_form_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$DayFormViewModel {
  String get dayCount => throw _privateConstructorUsedError;

  /// Create a copy of DayFormViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DayFormViewModelCopyWith<DayFormViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DayFormViewModelCopyWith<$Res> {
  factory $DayFormViewModelCopyWith(
    DayFormViewModel value,
    $Res Function(DayFormViewModel) then,
  ) = _$DayFormViewModelCopyWithImpl<$Res, DayFormViewModel>;
  @useResult
  $Res call({String dayCount});
}

/// @nodoc
class _$DayFormViewModelCopyWithImpl<$Res, $Val extends DayFormViewModel>
    implements $DayFormViewModelCopyWith<$Res> {
  _$DayFormViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DayFormViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dayCount = null}) {
    return _then(
      _value.copyWith(
            dayCount: null == dayCount
                ? _value.dayCount
                : dayCount // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DayFormViewModelImplCopyWith<$Res>
    implements $DayFormViewModelCopyWith<$Res> {
  factory _$$DayFormViewModelImplCopyWith(
    _$DayFormViewModelImpl value,
    $Res Function(_$DayFormViewModelImpl) then,
  ) = __$$DayFormViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String dayCount});
}

/// @nodoc
class __$$DayFormViewModelImplCopyWithImpl<$Res>
    extends _$DayFormViewModelCopyWithImpl<$Res, _$DayFormViewModelImpl>
    implements _$$DayFormViewModelImplCopyWith<$Res> {
  __$$DayFormViewModelImplCopyWithImpl(
    _$DayFormViewModelImpl _value,
    $Res Function(_$DayFormViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DayFormViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? dayCount = null}) {
    return _then(
      _$DayFormViewModelImpl(
        dayCount: null == dayCount
            ? _value.dayCount
            : dayCount // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DayFormViewModelImpl implements _DayFormViewModel {
  const _$DayFormViewModelImpl({required this.dayCount});

  @override
  final String dayCount;

  @override
  String toString() {
    return 'DayFormViewModel._(dayCount: $dayCount)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DayFormViewModelImpl &&
            (identical(other.dayCount, dayCount) ||
                other.dayCount == dayCount));
  }

  @override
  int get hashCode => Object.hash(runtimeType, dayCount);

  /// Create a copy of DayFormViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DayFormViewModelImplCopyWith<_$DayFormViewModelImpl> get copyWith =>
      __$$DayFormViewModelImplCopyWithImpl<_$DayFormViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _DayFormViewModel implements DayFormViewModel {
  const factory _DayFormViewModel({required final String dayCount}) =
      _$DayFormViewModelImpl;

  @override
  String get dayCount;

  /// Create a copy of DayFormViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DayFormViewModelImplCopyWith<_$DayFormViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
