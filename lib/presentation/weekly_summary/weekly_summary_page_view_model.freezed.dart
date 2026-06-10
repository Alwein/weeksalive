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

 int get weekNumber; String get weekDates; AverageFeeling? get lastWeekAverageFeeling; double get lastWeekAverageFeelingScore; double get lastWeekAverageMeaningScore; int get lastWeekNewExperiencesCount; List<(int, String)> get lastWeekLivingIntentions; List<(String dayLabel, int? sizeLevel)> get lastWeekDaySizes; List<String> get lastWeekImagePaths;
/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeeklySummaryPageViewModelCopyWith<WeeklySummaryPageViewModel> get copyWith => _$WeeklySummaryPageViewModelCopyWithImpl<WeeklySummaryPageViewModel>(this as WeeklySummaryPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeeklySummaryPageViewModel&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.weekDates, weekDates) || other.weekDates == weekDates)&&(identical(other.lastWeekAverageFeeling, lastWeekAverageFeeling) || other.lastWeekAverageFeeling == lastWeekAverageFeeling)&&(identical(other.lastWeekAverageFeelingScore, lastWeekAverageFeelingScore) || other.lastWeekAverageFeelingScore == lastWeekAverageFeelingScore)&&(identical(other.lastWeekAverageMeaningScore, lastWeekAverageMeaningScore) || other.lastWeekAverageMeaningScore == lastWeekAverageMeaningScore)&&(identical(other.lastWeekNewExperiencesCount, lastWeekNewExperiencesCount) || other.lastWeekNewExperiencesCount == lastWeekNewExperiencesCount)&&const DeepCollectionEquality().equals(other.lastWeekLivingIntentions, lastWeekLivingIntentions)&&const DeepCollectionEquality().equals(other.lastWeekDaySizes, lastWeekDaySizes)&&const DeepCollectionEquality().equals(other.lastWeekImagePaths, lastWeekImagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,weekNumber,weekDates,lastWeekAverageFeeling,lastWeekAverageFeelingScore,lastWeekAverageMeaningScore,lastWeekNewExperiencesCount,const DeepCollectionEquality().hash(lastWeekLivingIntentions),const DeepCollectionEquality().hash(lastWeekDaySizes),const DeepCollectionEquality().hash(lastWeekImagePaths));

@override
String toString() {
  return 'WeeklySummaryPageViewModel(weekNumber: $weekNumber, weekDates: $weekDates, lastWeekAverageFeeling: $lastWeekAverageFeeling, lastWeekAverageFeelingScore: $lastWeekAverageFeelingScore, lastWeekAverageMeaningScore: $lastWeekAverageMeaningScore, lastWeekNewExperiencesCount: $lastWeekNewExperiencesCount, lastWeekLivingIntentions: $lastWeekLivingIntentions, lastWeekDaySizes: $lastWeekDaySizes, lastWeekImagePaths: $lastWeekImagePaths)';
}


}

/// @nodoc
abstract mixin class $WeeklySummaryPageViewModelCopyWith<$Res>  {
  factory $WeeklySummaryPageViewModelCopyWith(WeeklySummaryPageViewModel value, $Res Function(WeeklySummaryPageViewModel) _then) = _$WeeklySummaryPageViewModelCopyWithImpl;
@useResult
$Res call({
 int weekNumber, String weekDates, AverageFeeling? lastWeekAverageFeeling, double lastWeekAverageFeelingScore, double lastWeekAverageMeaningScore, int lastWeekNewExperiencesCount, List<(int, String)> lastWeekLivingIntentions, List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes, List<String> lastWeekImagePaths
});




}
/// @nodoc
class _$WeeklySummaryPageViewModelCopyWithImpl<$Res>
    implements $WeeklySummaryPageViewModelCopyWith<$Res> {
  _$WeeklySummaryPageViewModelCopyWithImpl(this._self, this._then);

  final WeeklySummaryPageViewModel _self;
  final $Res Function(WeeklySummaryPageViewModel) _then;

/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? weekNumber = null,Object? weekDates = null,Object? lastWeekAverageFeeling = freezed,Object? lastWeekAverageFeelingScore = null,Object? lastWeekAverageMeaningScore = null,Object? lastWeekNewExperiencesCount = null,Object? lastWeekLivingIntentions = null,Object? lastWeekDaySizes = null,Object? lastWeekImagePaths = null,}) {
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
as List<String>,
  ));
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int weekNumber,  String weekDates,  AverageFeeling? lastWeekAverageFeeling,  double lastWeekAverageFeelingScore,  double lastWeekAverageMeaningScore,  int lastWeekNewExperiencesCount,  List<(int, String)> lastWeekLivingIntentions,  List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes,  List<String> lastWeekImagePaths)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel() when $default != null:
return $default(_that.weekNumber,_that.weekDates,_that.lastWeekAverageFeeling,_that.lastWeekAverageFeelingScore,_that.lastWeekAverageMeaningScore,_that.lastWeekNewExperiencesCount,_that.lastWeekLivingIntentions,_that.lastWeekDaySizes,_that.lastWeekImagePaths);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int weekNumber,  String weekDates,  AverageFeeling? lastWeekAverageFeeling,  double lastWeekAverageFeelingScore,  double lastWeekAverageMeaningScore,  int lastWeekNewExperiencesCount,  List<(int, String)> lastWeekLivingIntentions,  List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes,  List<String> lastWeekImagePaths)  $default,) {final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel():
return $default(_that.weekNumber,_that.weekDates,_that.lastWeekAverageFeeling,_that.lastWeekAverageFeelingScore,_that.lastWeekAverageMeaningScore,_that.lastWeekNewExperiencesCount,_that.lastWeekLivingIntentions,_that.lastWeekDaySizes,_that.lastWeekImagePaths);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int weekNumber,  String weekDates,  AverageFeeling? lastWeekAverageFeeling,  double lastWeekAverageFeelingScore,  double lastWeekAverageMeaningScore,  int lastWeekNewExperiencesCount,  List<(int, String)> lastWeekLivingIntentions,  List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes,  List<String> lastWeekImagePaths)?  $default,) {final _that = this;
switch (_that) {
case _WeeklySummaryPageViewModel() when $default != null:
return $default(_that.weekNumber,_that.weekDates,_that.lastWeekAverageFeeling,_that.lastWeekAverageFeelingScore,_that.lastWeekAverageMeaningScore,_that.lastWeekNewExperiencesCount,_that.lastWeekLivingIntentions,_that.lastWeekDaySizes,_that.lastWeekImagePaths);case _:
  return null;

}
}

}

/// @nodoc


class _WeeklySummaryPageViewModel implements WeeklySummaryPageViewModel {
  const _WeeklySummaryPageViewModel({required this.weekNumber, required this.weekDates, required this.lastWeekAverageFeeling, required this.lastWeekAverageFeelingScore, required this.lastWeekAverageMeaningScore, required this.lastWeekNewExperiencesCount, required final  List<(int, String)> lastWeekLivingIntentions, required final  List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes, required final  List<String> lastWeekImagePaths}): _lastWeekLivingIntentions = lastWeekLivingIntentions,_lastWeekDaySizes = lastWeekDaySizes,_lastWeekImagePaths = lastWeekImagePaths;
  

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


/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeeklySummaryPageViewModelCopyWith<_WeeklySummaryPageViewModel> get copyWith => __$WeeklySummaryPageViewModelCopyWithImpl<_WeeklySummaryPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeeklySummaryPageViewModel&&(identical(other.weekNumber, weekNumber) || other.weekNumber == weekNumber)&&(identical(other.weekDates, weekDates) || other.weekDates == weekDates)&&(identical(other.lastWeekAverageFeeling, lastWeekAverageFeeling) || other.lastWeekAverageFeeling == lastWeekAverageFeeling)&&(identical(other.lastWeekAverageFeelingScore, lastWeekAverageFeelingScore) || other.lastWeekAverageFeelingScore == lastWeekAverageFeelingScore)&&(identical(other.lastWeekAverageMeaningScore, lastWeekAverageMeaningScore) || other.lastWeekAverageMeaningScore == lastWeekAverageMeaningScore)&&(identical(other.lastWeekNewExperiencesCount, lastWeekNewExperiencesCount) || other.lastWeekNewExperiencesCount == lastWeekNewExperiencesCount)&&const DeepCollectionEquality().equals(other._lastWeekLivingIntentions, _lastWeekLivingIntentions)&&const DeepCollectionEquality().equals(other._lastWeekDaySizes, _lastWeekDaySizes)&&const DeepCollectionEquality().equals(other._lastWeekImagePaths, _lastWeekImagePaths));
}


@override
int get hashCode => Object.hash(runtimeType,weekNumber,weekDates,lastWeekAverageFeeling,lastWeekAverageFeelingScore,lastWeekAverageMeaningScore,lastWeekNewExperiencesCount,const DeepCollectionEquality().hash(_lastWeekLivingIntentions),const DeepCollectionEquality().hash(_lastWeekDaySizes),const DeepCollectionEquality().hash(_lastWeekImagePaths));

@override
String toString() {
  return 'WeeklySummaryPageViewModel(weekNumber: $weekNumber, weekDates: $weekDates, lastWeekAverageFeeling: $lastWeekAverageFeeling, lastWeekAverageFeelingScore: $lastWeekAverageFeelingScore, lastWeekAverageMeaningScore: $lastWeekAverageMeaningScore, lastWeekNewExperiencesCount: $lastWeekNewExperiencesCount, lastWeekLivingIntentions: $lastWeekLivingIntentions, lastWeekDaySizes: $lastWeekDaySizes, lastWeekImagePaths: $lastWeekImagePaths)';
}


}

/// @nodoc
abstract mixin class _$WeeklySummaryPageViewModelCopyWith<$Res> implements $WeeklySummaryPageViewModelCopyWith<$Res> {
  factory _$WeeklySummaryPageViewModelCopyWith(_WeeklySummaryPageViewModel value, $Res Function(_WeeklySummaryPageViewModel) _then) = __$WeeklySummaryPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 int weekNumber, String weekDates, AverageFeeling? lastWeekAverageFeeling, double lastWeekAverageFeelingScore, double lastWeekAverageMeaningScore, int lastWeekNewExperiencesCount, List<(int, String)> lastWeekLivingIntentions, List<(String dayLabel, int? sizeLevel)> lastWeekDaySizes, List<String> lastWeekImagePaths
});




}
/// @nodoc
class __$WeeklySummaryPageViewModelCopyWithImpl<$Res>
    implements _$WeeklySummaryPageViewModelCopyWith<$Res> {
  __$WeeklySummaryPageViewModelCopyWithImpl(this._self, this._then);

  final _WeeklySummaryPageViewModel _self;
  final $Res Function(_WeeklySummaryPageViewModel) _then;

/// Create a copy of WeeklySummaryPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? weekNumber = null,Object? weekDates = null,Object? lastWeekAverageFeeling = freezed,Object? lastWeekAverageFeelingScore = null,Object? lastWeekAverageMeaningScore = null,Object? lastWeekNewExperiencesCount = null,Object? lastWeekLivingIntentions = null,Object? lastWeekDaySizes = null,Object? lastWeekImagePaths = null,}) {
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
as List<String>,
  ));
}


}

// dart format on
