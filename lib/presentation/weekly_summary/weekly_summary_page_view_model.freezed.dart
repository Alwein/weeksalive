// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'weekly_summary_page_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WeeklySummaryPageViewModel {

 int get weekNumber; String get weekDates; AverageFeeling? get lastWeekAverageFeeling; double get lastWeekAverageFeelingScore; double get lastWeekAverageMeaningScore; int get lastWeekNewExperiencesCount; List<(int, String)> get lastWeekLivingIntentions; List<(String dayLabel, int? sizeLevel)> get lastWeekDaySizes; List<String> get lastWeekImagePaths;/// The summarized week is the one the user started in. Its details are
/// free, and there is no earlier week to compare it with.
 bool get isFirstWeek; bool get isPro;/// Change from the week before, or `null` when that week has no entry.
 WeeklySummaryComparison? get comparison;
/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklySummaryPageViewModelCopyWith<WeeklySummaryPageViewModel> get copyWith => _$WeeklySummaryPageViewModelCopyWithImpl<WeeklySummaryPageViewModel>(this as WeeklySummaryPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklySummaryPageViewModel&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.weekDates, weekDates) || other.weekDates == weekDates)&&(identical(other.lastWeekAverageFeeling, lastWeekAverageFeeling) || other.lastWeekAverageFeeling == lastWeekAverageFeeling)&&(identical(other.lastWeekAverageFeelingScore, lastWeekAverageFeelingScore) || other.lastWeekAverageFeelingScore == lastWeekAverageFeelingScore)&&(identical(other.lastWeekAverageMeaningScore, lastWeekAverageMeaningScore) || other.lastWeekAverageMeaningScore == lastWeekAverageMeaningScore)&&(identical(other.lastWeekNewExperiencesCount, lastWeekNewExperiencesCount) || other.lastWeekNewExperiencesCount == lastWeekNewExperiencesCount)&&const DeepCollectionEquality().equals(other.lastWeekLivingIntentions, lastWeekLivingIntentions)&&const DeepCollectionEquality().equals(other.lastWeekDaySizes, lastWeekDaySizes)&&const DeepCollectionEquality().equals(other.lastWeekImagePaths, lastWeekImagePaths)&&(identical(other.isFirstWeek, isFirstWeek) || other.isFirstWeek == isFirstWeek)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.comparison, comparison) || other.comparison == comparison));
}


@override
int get hashCode => Object.hash(runtimeType,weekNumber,weekDates,lastWeekAverageFeeling,lastWeekAverageFeelingScore,lastWeekAverageMeaningScore,lastWeekNewExperiencesCount,const DeepCollectionEquality().hash(lastWeekLivingIntentions),const DeepCollectionEquality().hash(lastWeekDaySizes),const DeepCollectionEquality().hash(lastWeekImagePaths),isFirstWeek,isPro,comparison);

@override
String toString() {
  return 'WeeklySummaryPageViewModel(weekNumber: $weekNumber, weekDates: $weekDates, lastWeekAverageFeeling: $lastWeekAverageFeeling, lastWeekAverageFeelingScore: $lastWeekAverageFeelingScore, lastWeekAverageMeaningScore: $lastWeekAverageMeaningScore, lastWeekNewExperiencesCount: $lastWeekNewExperiencesCount, lastWeekLivingIntentions: $lastWeekLivingIntentions, lastWeekDaySizes: $lastWeekDaySizes, lastWeekImagePaths: $lastWeekImagePaths, isFirstWeek: $isFirstWeek, isPro: $isPro, comparison: $comparison)';
}


}

/// @nodoc
abstract mixin class $WeeklySummaryPageViewModelCopyWith<$Res>  {
  factory $WeeklySummaryPageViewModelCopyWith(WeeklySummaryPageViewModel value, $Res Function(WeeklySummaryPageViewModel) _then) = _$WeeklySummaryPageViewModelCopyWithImpl;
@useResult
$Res call({
 int weekNumber, String weekDates, AverageFeeling? lastWeekAverageFeeling, double lastWeekAverageFeelingScore, double lastWeekAverageMeaningScore, int lastWeekNewExperiencesCount, List<(int, String)> lastWeekLivingIntentions, List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes, List<String> lastWeekImagePaths, bool isFirstWeek, bool isPro, WeeklySummaryComparison? comparison
});


$WeeklySummaryComparisonCopyWith<$Res>? get comparison;

}
/// @nodoc
class _$WeeklySummaryPageViewModelCopyWithImpl<$Res>
    implements $WeeklySummaryPageViewModelCopyWith<$Res> {
  _$WeeklySummaryPageViewModelCopyWithImpl(this._self, this._then);

  final WeeklySummaryPageViewModel _self;
  final $Res Function(WeeklySummaryPageViewModel) _then;

/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekNumber = null,Object? weekDates = null,Object? lastWeekAverageFeeling = freezed,Object? lastWeekAverageFeelingScore = null,Object? lastWeekAverageMeaningScore = null,Object? lastWeekNewExperiencesCount = null,Object? lastWeekLivingIntentions = null,Object? lastWeekDaySizes = null,Object? lastWeekImagePaths = null,Object? isFirstWeek = null,Object? isPro = null,Object? comparison = freezed,}) {
  return _then(_self.copyWith(
weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,weekDates: null == weekDates ? _self.weekDates : weekDates // ignore: cast_nullable_to_non_nullable
as String,lastWeekAverageFeeling: freezed == lastWeekAverageFeeling ? _self.lastWeekAverageFeeling : lastWeekAverageFeeling // ignore: cast_nullable_to_non_nullable
as AverageFeeling?,lastWeekAverageFeelingScore: null == lastWeekAverageFeelingScore ? _self.lastWeekAverageFeelingScore : lastWeekAverageFeelingScore // ignore: cast_nullable_to_non_nullable
as double,lastWeekAverageMeaningScore: null == lastWeekAverageMeaningScore ? _self.lastWeekAverageMeaningScore : lastWeekAverageMeaningScore // ignore: cast_nullable_to_non_nullable
as double,lastWeekNewExperiencesCount: null == lastWeekNewExperiencesCount ? _self.lastWeekNewExperiencesCount : lastWeekNewExperiencesCount // ignore: cast_nullable_to_non_nullable
as int,lastWeekLivingIntentions: null == lastWeekLivingIntentions ? _self.lastWeekLivingIntentions : lastWeekLivingIntentions // ignore: cast_nullable_to_non_nullable
as List<(int, String)>,lastWeekDaySizes: null == lastWeekDaySizes ? _self.lastWeekDaySizes : lastWeekDaySizes // ignore: cast_nullable_to_non_nullable
as List<(String dayLabel, int? sizeLevel)>,lastWeekImagePaths: null == lastWeekImagePaths ? _self.lastWeekImagePaths : lastWeekImagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,isFirstWeek: null == isFirstWeek ? _self.isFirstWeek : isFirstWeek // ignore: cast_nullable_to_non_nullable
as bool,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,comparison: freezed == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as WeeklySummaryComparison?,
  ));
}
/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklySummaryComparisonCopyWith<$Res>? get comparison {
    if (_self.comparison == null) {
    return null;
  }

  return $WeeklySummaryComparisonCopyWith<$Res>(_self.comparison!, (value) {
    return _then(_self.copyWith(comparison: value));
  });
}
}


/// Adds pattern-matching-related methods to [WeeklySummaryPageViewModel].
extension WeeklySummaryPageViewModelPatterns on WeeklySummaryPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklySummaryPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklySummaryPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklySummaryPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekNumber,  String weekDates,  AverageFeeling? lastWeekAverageFeeling,  double lastWeekAverageFeelingScore,  double lastWeekAverageMeaningScore,  int lastWeekNewExperiencesCount,  List<(int, String)> lastWeekLivingIntentions,  List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes,  List<String> lastWeekImagePaths,  bool isFirstWeek,  bool isPro,  WeeklySummaryComparison? comparison)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel() when $default != null:
return $default(_that.weekNumber,_that.weekDates,_that.lastWeekAverageFeeling,_that.lastWeekAverageFeelingScore,_that.lastWeekAverageMeaningScore,_that.lastWeekNewExperiencesCount,_that.lastWeekLivingIntentions,_that.lastWeekDaySizes,_that.lastWeekImagePaths,_that.isFirstWeek,_that.isPro,_that.comparison);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekNumber,  String weekDates,  AverageFeeling? lastWeekAverageFeeling,  double lastWeekAverageFeelingScore,  double lastWeekAverageMeaningScore,  int lastWeekNewExperiencesCount,  List<(int, String)> lastWeekLivingIntentions,  List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes,  List<String> lastWeekImagePaths,  bool isFirstWeek,  bool isPro,  WeeklySummaryComparison? comparison)  $default,) {final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel():
return $default(_that.weekNumber,_that.weekDates,_that.lastWeekAverageFeeling,_that.lastWeekAverageFeelingScore,_that.lastWeekAverageMeaningScore,_that.lastWeekNewExperiencesCount,_that.lastWeekLivingIntentions,_that.lastWeekDaySizes,_that.lastWeekImagePaths,_that.isFirstWeek,_that.isPro,_that.comparison);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekNumber,  String weekDates,  AverageFeeling? lastWeekAverageFeeling,  double lastWeekAverageFeelingScore,  double lastWeekAverageMeaningScore,  int lastWeekNewExperiencesCount,  List<(int, String)> lastWeekLivingIntentions,  List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes,  List<String> lastWeekImagePaths,  bool isFirstWeek,  bool isPro,  WeeklySummaryComparison? comparison)?  $default,) {final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel() when $default != null:
return $default(_that.weekNumber,_that.weekDates,_that.lastWeekAverageFeeling,_that.lastWeekAverageFeelingScore,_that.lastWeekAverageMeaningScore,_that.lastWeekNewExperiencesCount,_that.lastWeekLivingIntentions,_that.lastWeekDaySizes,_that.lastWeekImagePaths,_that.isFirstWeek,_that.isPro,_that.comparison);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklySummaryPageViewModel extends WeeklySummaryPageViewModel {
  const _WeeklySummaryPageViewModel({required this.weekNumber, required this.weekDates, required this.lastWeekAverageFeeling, required this.lastWeekAverageFeelingScore, required this.lastWeekAverageMeaningScore, required this.lastWeekNewExperiencesCount, required final  List<(int, String)> lastWeekLivingIntentions, required final  List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes, required final  List<String> lastWeekImagePaths, required this.isFirstWeek, required this.isPro, required this.comparison}): _lastWeekLivingIntentions = lastWeekLivingIntentions,_lastWeekDaySizes = lastWeekDaySizes,_lastWeekImagePaths = lastWeekImagePaths,super._();
  

@override final  int weekNumber;
@override final  String weekDates;
@override final  AverageFeeling? lastWeekAverageFeeling;
@override final  double lastWeekAverageFeelingScore;
@override final  double lastWeekAverageMeaningScore;
@override final  int lastWeekNewExperiencesCount;
 final  List<(int, String)> _lastWeekLivingIntentions;
@override List<(int, String)> get lastWeekLivingIntentions {
  if (_lastWeekLivingIntentions is EqualUnmodifiableListView) return _lastWeekLivingIntentions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastWeekLivingIntentions);
}

 final  List<(String dayLabel, int? sizeLevel)> _lastWeekDaySizes;
@override List<(String dayLabel, int? sizeLevel)> get lastWeekDaySizes {
  if (_lastWeekDaySizes is EqualUnmodifiableListView) return _lastWeekDaySizes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastWeekDaySizes);
}

 final  List<String> _lastWeekImagePaths;
@override List<String> get lastWeekImagePaths {
  if (_lastWeekImagePaths is EqualUnmodifiableListView) return _lastWeekImagePaths;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lastWeekImagePaths);
}

/// The summarized week is the one the user started in. Its details are
/// free, and there is no earlier week to compare it with.
@override final  bool isFirstWeek;
@override final  bool isPro;
/// Change from the week before, or `null` when that week has no entry.
@override final  WeeklySummaryComparison? comparison;

/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklySummaryPageViewModelCopyWith<_WeeklySummaryPageViewModel> get copyWith => __$WeeklySummaryPageViewModelCopyWithImpl<_WeeklySummaryPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklySummaryPageViewModel&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.weekDates, weekDates) || other.weekDates == weekDates)&&(identical(other.lastWeekAverageFeeling, lastWeekAverageFeeling) || other.lastWeekAverageFeeling == lastWeekAverageFeeling)&&(identical(other.lastWeekAverageFeelingScore, lastWeekAverageFeelingScore) || other.lastWeekAverageFeelingScore == lastWeekAverageFeelingScore)&&(identical(other.lastWeekAverageMeaningScore, lastWeekAverageMeaningScore) || other.lastWeekAverageMeaningScore == lastWeekAverageMeaningScore)&&(identical(other.lastWeekNewExperiencesCount, lastWeekNewExperiencesCount) || other.lastWeekNewExperiencesCount == lastWeekNewExperiencesCount)&&const DeepCollectionEquality().equals(other._lastWeekLivingIntentions, _lastWeekLivingIntentions)&&const DeepCollectionEquality().equals(other._lastWeekDaySizes, _lastWeekDaySizes)&&const DeepCollectionEquality().equals(other._lastWeekImagePaths, _lastWeekImagePaths)&&(identical(other.isFirstWeek, isFirstWeek) || other.isFirstWeek == isFirstWeek)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.comparison, comparison) || other.comparison == comparison));
}


@override
int get hashCode => Object.hash(runtimeType,weekNumber,weekDates,lastWeekAverageFeeling,lastWeekAverageFeelingScore,lastWeekAverageMeaningScore,lastWeekNewExperiencesCount,const DeepCollectionEquality().hash(_lastWeekLivingIntentions),const DeepCollectionEquality().hash(_lastWeekDaySizes),const DeepCollectionEquality().hash(_lastWeekImagePaths),isFirstWeek,isPro,comparison);

@override
String toString() {
  return 'WeeklySummaryPageViewModel(weekNumber: $weekNumber, weekDates: $weekDates, lastWeekAverageFeeling: $lastWeekAverageFeeling, lastWeekAverageFeelingScore: $lastWeekAverageFeelingScore, lastWeekAverageMeaningScore: $lastWeekAverageMeaningScore, lastWeekNewExperiencesCount: $lastWeekNewExperiencesCount, lastWeekLivingIntentions: $lastWeekLivingIntentions, lastWeekDaySizes: $lastWeekDaySizes, lastWeekImagePaths: $lastWeekImagePaths, isFirstWeek: $isFirstWeek, isPro: $isPro, comparison: $comparison)';
}


}

/// @nodoc
abstract mixin class _$WeeklySummaryPageViewModelCopyWith<$Res> implements $WeeklySummaryPageViewModelCopyWith<$Res> {
  factory _$WeeklySummaryPageViewModelCopyWith(_WeeklySummaryPageViewModel value, $Res Function(_WeeklySummaryPageViewModel) _then) = __$WeeklySummaryPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 int weekNumber, String weekDates, AverageFeeling? lastWeekAverageFeeling, double lastWeekAverageFeelingScore, double lastWeekAverageMeaningScore, int lastWeekNewExperiencesCount, List<(int, String)> lastWeekLivingIntentions, List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes, List<String> lastWeekImagePaths, bool isFirstWeek, bool isPro, WeeklySummaryComparison? comparison
});


@override $WeeklySummaryComparisonCopyWith<$Res>? get comparison;

}
/// @nodoc
class __$WeeklySummaryPageViewModelCopyWithImpl<$Res>
    implements _$WeeklySummaryPageViewModelCopyWith<$Res> {
  __$WeeklySummaryPageViewModelCopyWithImpl(this._self, this._then);

  final _WeeklySummaryPageViewModel _self;
  final $Res Function(_WeeklySummaryPageViewModel) _then;

/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekNumber = null,Object? weekDates = null,Object? lastWeekAverageFeeling = freezed,Object? lastWeekAverageFeelingScore = null,Object? lastWeekAverageMeaningScore = null,Object? lastWeekNewExperiencesCount = null,Object? lastWeekLivingIntentions = null,Object? lastWeekDaySizes = null,Object? lastWeekImagePaths = null,Object? isFirstWeek = null,Object? isPro = null,Object? comparison = freezed,}) {
  return _then(_WeeklySummaryPageViewModel(
weekNumber: null == weekNumber ? _self.weekNumber : weekNumber // ignore: cast_nullable_to_non_nullable
as int,weekDates: null == weekDates ? _self.weekDates : weekDates // ignore: cast_nullable_to_non_nullable
as String,lastWeekAverageFeeling: freezed == lastWeekAverageFeeling ? _self.lastWeekAverageFeeling : lastWeekAverageFeeling // ignore: cast_nullable_to_non_nullable
as AverageFeeling?,lastWeekAverageFeelingScore: null == lastWeekAverageFeelingScore ? _self.lastWeekAverageFeelingScore : lastWeekAverageFeelingScore // ignore: cast_nullable_to_non_nullable
as double,lastWeekAverageMeaningScore: null == lastWeekAverageMeaningScore ? _self.lastWeekAverageMeaningScore : lastWeekAverageMeaningScore // ignore: cast_nullable_to_non_nullable
as double,lastWeekNewExperiencesCount: null == lastWeekNewExperiencesCount ? _self.lastWeekNewExperiencesCount : lastWeekNewExperiencesCount // ignore: cast_nullable_to_non_nullable
as int,lastWeekLivingIntentions: null == lastWeekLivingIntentions ? _self._lastWeekLivingIntentions : lastWeekLivingIntentions // ignore: cast_nullable_to_non_nullable
as List<(int, String)>,lastWeekDaySizes: null == lastWeekDaySizes ? _self._lastWeekDaySizes : lastWeekDaySizes // ignore: cast_nullable_to_non_nullable
as List<(String dayLabel, int? sizeLevel)>,lastWeekImagePaths: null == lastWeekImagePaths ? _self._lastWeekImagePaths : lastWeekImagePaths // ignore: cast_nullable_to_non_nullable
as List<String>,isFirstWeek: null == isFirstWeek ? _self.isFirstWeek : isFirstWeek // ignore: cast_nullable_to_non_nullable
as bool,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,comparison: freezed == comparison ? _self.comparison : comparison // ignore: cast_nullable_to_non_nullable
as WeeklySummaryComparison?,
  ));
}

/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WeeklySummaryComparisonCopyWith<$Res>? get comparison {
    if (_self.comparison == null) {
    return null;
  }

  return $WeeklySummaryComparisonCopyWith<$Res>(_self.comparison!, (value) {
    return _then(_self.copyWith(comparison: value));
  });
}
}

/// @nodoc
mixin _$WeeklySummaryComparison {

 int get loggedDaysDelta;/// `null` when either week has no feeling recorded.
 double? get averageFeelingDelta;/// `null` when either week has no meaning score recorded.
 double? get averageMeaningDelta; int get newExperiencesDelta;
/// Create a copy of WeeklySummaryComparison
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklySummaryComparisonCopyWith<WeeklySummaryComparison> get copyWith => _$WeeklySummaryComparisonCopyWithImpl<WeeklySummaryComparison>(this as WeeklySummaryComparison, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklySummaryComparison&&(identical(other.loggedDaysDelta, loggedDaysDelta) || other.loggedDaysDelta == loggedDaysDelta)&&(identical(other.averageFeelingDelta, averageFeelingDelta) || other.averageFeelingDelta == averageFeelingDelta)&&(identical(other.averageMeaningDelta, averageMeaningDelta) || other.averageMeaningDelta == averageMeaningDelta)&&(identical(other.newExperiencesDelta, newExperiencesDelta) || other.newExperiencesDelta == newExperiencesDelta));
}


@override
int get hashCode => Object.hash(runtimeType,loggedDaysDelta,averageFeelingDelta,averageMeaningDelta,newExperiencesDelta);

@override
String toString() {
  return 'WeeklySummaryComparison(loggedDaysDelta: $loggedDaysDelta, averageFeelingDelta: $averageFeelingDelta, averageMeaningDelta: $averageMeaningDelta, newExperiencesDelta: $newExperiencesDelta)';
}


}

/// @nodoc
abstract mixin class $WeeklySummaryComparisonCopyWith<$Res>  {
  factory $WeeklySummaryComparisonCopyWith(WeeklySummaryComparison value, $Res Function(WeeklySummaryComparison) _then) = _$WeeklySummaryComparisonCopyWithImpl;
@useResult
$Res call({
 int loggedDaysDelta, double? averageFeelingDelta, double? averageMeaningDelta, int newExperiencesDelta
});




}
/// @nodoc
class _$WeeklySummaryComparisonCopyWithImpl<$Res>
    implements $WeeklySummaryComparisonCopyWith<$Res> {
  _$WeeklySummaryComparisonCopyWithImpl(this._self, this._then);

  final WeeklySummaryComparison _self;
  final $Res Function(WeeklySummaryComparison) _then;

/// Create a copy of WeeklySummaryComparison
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loggedDaysDelta = null,Object? averageFeelingDelta = freezed,Object? averageMeaningDelta = freezed,Object? newExperiencesDelta = null,}) {
  return _then(_self.copyWith(
loggedDaysDelta: null == loggedDaysDelta ? _self.loggedDaysDelta : loggedDaysDelta // ignore: cast_nullable_to_non_nullable
as int,averageFeelingDelta: freezed == averageFeelingDelta ? _self.averageFeelingDelta : averageFeelingDelta // ignore: cast_nullable_to_non_nullable
as double?,averageMeaningDelta: freezed == averageMeaningDelta ? _self.averageMeaningDelta : averageMeaningDelta // ignore: cast_nullable_to_non_nullable
as double?,newExperiencesDelta: null == newExperiencesDelta ? _self.newExperiencesDelta : newExperiencesDelta // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WeeklySummaryComparison].
extension WeeklySummaryComparisonPatterns on WeeklySummaryComparison {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeeklySummaryComparison value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeeklySummaryComparison() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeeklySummaryComparison value)  $default,){
final _that = this;
switch (_that) {
case _WeeklySummaryComparison():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeeklySummaryComparison value)?  $default,){
final _that = this;
switch (_that) {
case _WeeklySummaryComparison() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int loggedDaysDelta,  double? averageFeelingDelta,  double? averageMeaningDelta,  int newExperiencesDelta)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklySummaryComparison() when $default != null:
return $default(_that.loggedDaysDelta,_that.averageFeelingDelta,_that.averageMeaningDelta,_that.newExperiencesDelta);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int loggedDaysDelta,  double? averageFeelingDelta,  double? averageMeaningDelta,  int newExperiencesDelta)  $default,) {final _that = this;
switch (_that) {
case _WeeklySummaryComparison():
return $default(_that.loggedDaysDelta,_that.averageFeelingDelta,_that.averageMeaningDelta,_that.newExperiencesDelta);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int loggedDaysDelta,  double? averageFeelingDelta,  double? averageMeaningDelta,  int newExperiencesDelta)?  $default,) {final _that = this;
switch (_that) {
case _WeeklySummaryComparison() when $default != null:
return $default(_that.loggedDaysDelta,_that.averageFeelingDelta,_that.averageMeaningDelta,_that.newExperiencesDelta);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklySummaryComparison implements WeeklySummaryComparison {
  const _WeeklySummaryComparison({required this.loggedDaysDelta, required this.averageFeelingDelta, required this.averageMeaningDelta, required this.newExperiencesDelta});
  

@override final  int loggedDaysDelta;
/// `null` when either week has no feeling recorded.
@override final  double? averageFeelingDelta;
/// `null` when either week has no meaning score recorded.
@override final  double? averageMeaningDelta;
@override final  int newExperiencesDelta;

/// Create a copy of WeeklySummaryComparison
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklySummaryComparisonCopyWith<_WeeklySummaryComparison> get copyWith => __$WeeklySummaryComparisonCopyWithImpl<_WeeklySummaryComparison>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklySummaryComparison&&(identical(other.loggedDaysDelta, loggedDaysDelta) || other.loggedDaysDelta == loggedDaysDelta)&&(identical(other.averageFeelingDelta, averageFeelingDelta) || other.averageFeelingDelta == averageFeelingDelta)&&(identical(other.averageMeaningDelta, averageMeaningDelta) || other.averageMeaningDelta == averageMeaningDelta)&&(identical(other.newExperiencesDelta, newExperiencesDelta) || other.newExperiencesDelta == newExperiencesDelta));
}


@override
int get hashCode => Object.hash(runtimeType,loggedDaysDelta,averageFeelingDelta,averageMeaningDelta,newExperiencesDelta);

@override
String toString() {
  return 'WeeklySummaryComparison(loggedDaysDelta: $loggedDaysDelta, averageFeelingDelta: $averageFeelingDelta, averageMeaningDelta: $averageMeaningDelta, newExperiencesDelta: $newExperiencesDelta)';
}


}

/// @nodoc
abstract mixin class _$WeeklySummaryComparisonCopyWith<$Res> implements $WeeklySummaryComparisonCopyWith<$Res> {
  factory _$WeeklySummaryComparisonCopyWith(_WeeklySummaryComparison value, $Res Function(_WeeklySummaryComparison) _then) = __$WeeklySummaryComparisonCopyWithImpl;
@override @useResult
$Res call({
 int loggedDaysDelta, double? averageFeelingDelta, double? averageMeaningDelta, int newExperiencesDelta
});




}
/// @nodoc
class __$WeeklySummaryComparisonCopyWithImpl<$Res>
    implements _$WeeklySummaryComparisonCopyWith<$Res> {
  __$WeeklySummaryComparisonCopyWithImpl(this._self, this._then);

  final _WeeklySummaryComparison _self;
  final $Res Function(_WeeklySummaryComparison) _then;

/// Create a copy of WeeklySummaryComparison
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loggedDaysDelta = null,Object? averageFeelingDelta = freezed,Object? averageMeaningDelta = freezed,Object? newExperiencesDelta = null,}) {
  return _then(_WeeklySummaryComparison(
loggedDaysDelta: null == loggedDaysDelta ? _self.loggedDaysDelta : loggedDaysDelta // ignore: cast_nullable_to_non_nullable
as int,averageFeelingDelta: freezed == averageFeelingDelta ? _self.averageFeelingDelta : averageFeelingDelta // ignore: cast_nullable_to_non_nullable
as double?,averageMeaningDelta: freezed == averageMeaningDelta ? _self.averageMeaningDelta : averageMeaningDelta // ignore: cast_nullable_to_non_nullable
as double?,newExperiencesDelta: null == newExperiencesDelta ? _self.newExperiencesDelta : newExperiencesDelta // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
