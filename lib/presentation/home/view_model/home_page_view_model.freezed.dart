// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$HomePageViewModel {
  String get userName => throw _privateConstructorUsedError;
  int get streakCount => throw _privateConstructorUsedError;
  LifeWeekGrid get lifeWeekGrid => throw _privateConstructorUsedError;

  /// Create a copy of HomePageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomePageViewModelCopyWith<HomePageViewModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomePageViewModelCopyWith<$Res> {
  factory $HomePageViewModelCopyWith(
    HomePageViewModel value,
    $Res Function(HomePageViewModel) then,
  ) = _$HomePageViewModelCopyWithImpl<$Res, HomePageViewModel>;
  @useResult
  $Res call({String userName, int streakCount, LifeWeekGrid lifeWeekGrid});
}

/// @nodoc
class _$HomePageViewModelCopyWithImpl<$Res, $Val extends HomePageViewModel>
    implements $HomePageViewModelCopyWith<$Res> {
  _$HomePageViewModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomePageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? streakCount = null,
    Object? lifeWeekGrid = null,
  }) {
    return _then(
      _value.copyWith(
            userName: null == userName
                ? _value.userName
                : userName // ignore: cast_nullable_to_non_nullable
                      as String,
            streakCount: null == streakCount
                ? _value.streakCount
                : streakCount // ignore: cast_nullable_to_non_nullable
                      as int,
            lifeWeekGrid: null == lifeWeekGrid
                ? _value.lifeWeekGrid
                : lifeWeekGrid // ignore: cast_nullable_to_non_nullable
                      as LifeWeekGrid,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$HomePageViewModelImplCopyWith<$Res>
    implements $HomePageViewModelCopyWith<$Res> {
  factory _$$HomePageViewModelImplCopyWith(
    _$HomePageViewModelImpl value,
    $Res Function(_$HomePageViewModelImpl) then,
  ) = __$$HomePageViewModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String userName, int streakCount, LifeWeekGrid lifeWeekGrid});
}

/// @nodoc
class __$$HomePageViewModelImplCopyWithImpl<$Res>
    extends _$HomePageViewModelCopyWithImpl<$Res, _$HomePageViewModelImpl>
    implements _$$HomePageViewModelImplCopyWith<$Res> {
  __$$HomePageViewModelImplCopyWithImpl(
    _$HomePageViewModelImpl _value,
    $Res Function(_$HomePageViewModelImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of HomePageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userName = null,
    Object? streakCount = null,
    Object? lifeWeekGrid = null,
  }) {
    return _then(
      _$HomePageViewModelImpl(
        userName: null == userName
            ? _value.userName
            : userName // ignore: cast_nullable_to_non_nullable
                  as String,
        streakCount: null == streakCount
            ? _value.streakCount
            : streakCount // ignore: cast_nullable_to_non_nullable
                  as int,
        lifeWeekGrid: null == lifeWeekGrid
            ? _value.lifeWeekGrid
            : lifeWeekGrid // ignore: cast_nullable_to_non_nullable
                  as LifeWeekGrid,
      ),
    );
  }
}

/// @nodoc

class _$HomePageViewModelImpl implements _HomePageViewModel {
  const _$HomePageViewModelImpl({
    required this.userName,
    required this.streakCount,
    required this.lifeWeekGrid,
  });

  @override
  final String userName;
  @override
  final int streakCount;
  @override
  final LifeWeekGrid lifeWeekGrid;

  @override
  String toString() {
    return 'HomePageViewModel._(userName: $userName, streakCount: $streakCount, lifeWeekGrid: $lifeWeekGrid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomePageViewModelImpl &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.streakCount, streakCount) ||
                other.streakCount == streakCount) &&
            (identical(other.lifeWeekGrid, lifeWeekGrid) ||
                other.lifeWeekGrid == lifeWeekGrid));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, userName, streakCount, lifeWeekGrid);

  /// Create a copy of HomePageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomePageViewModelImplCopyWith<_$HomePageViewModelImpl> get copyWith =>
      __$$HomePageViewModelImplCopyWithImpl<_$HomePageViewModelImpl>(
        this,
        _$identity,
      );
}

abstract class _HomePageViewModel implements HomePageViewModel {
  const factory _HomePageViewModel({
    required final String userName,
    required final int streakCount,
    required final LifeWeekGrid lifeWeekGrid,
  }) = _$HomePageViewModelImpl;

  @override
  String get userName;
  @override
  int get streakCount;
  @override
  LifeWeekGrid get lifeWeekGrid;

  /// Create a copy of HomePageViewModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomePageViewModelImplCopyWith<_$HomePageViewModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
