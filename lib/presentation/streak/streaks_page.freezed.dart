// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streaks_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StreaksPageViewModel {

 int get currentStreak; int get bestStreak; bool get isPro; List<StreakRewardItem> get rewards;
/// Create a copy of StreaksPageViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreaksPageViewModelCopyWith<StreaksPageViewModel> get copyWith => _$StreaksPageViewModelCopyWithImpl<StreaksPageViewModel>(this as StreaksPageViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreaksPageViewModel&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&const DeepCollectionEquality().equals(other.rewards, rewards));
}


@override
int get hashCode => Object.hash(runtimeType,currentStreak,bestStreak,isPro,const DeepCollectionEquality().hash(rewards));

@override
String toString() {
  return 'StreaksPageViewModel(currentStreak: $currentStreak, bestStreak: $bestStreak, isPro: $isPro, rewards: $rewards)';
}


}

/// @nodoc
abstract mixin class $StreaksPageViewModelCopyWith<$Res>  {
  factory $StreaksPageViewModelCopyWith(StreaksPageViewModel value, $Res Function(StreaksPageViewModel) _then) = _$StreaksPageViewModelCopyWithImpl;
@useResult
$Res call({
 int currentStreak, int bestStreak, bool isPro, List<StreakRewardItem> rewards
});




}
/// @nodoc
class _$StreaksPageViewModelCopyWithImpl<$Res>
    implements $StreaksPageViewModelCopyWith<$Res> {
  _$StreaksPageViewModelCopyWithImpl(this._self, this._then);

  final StreaksPageViewModel _self;
  final $Res Function(StreaksPageViewModel) _then;

/// Create a copy of StreaksPageViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? currentStreak = null,Object? bestStreak = null,Object? isPro = null,Object? rewards = null,}) {
  return _then(_self.copyWith(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,rewards: null == rewards ? _self.rewards : rewards // ignore: cast_nullable_to_non_nullable
as List<StreakRewardItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [StreaksPageViewModel].
extension StreaksPageViewModelPatterns on StreaksPageViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreaksPageViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreaksPageViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreaksPageViewModel value)  $default,){
final _that = this;
switch (_that) {
case _StreaksPageViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreaksPageViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _StreaksPageViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int currentStreak,  int bestStreak,  bool isPro,  List<StreakRewardItem> rewards)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreaksPageViewModel() when $default != null:
return $default(_that.currentStreak,_that.bestStreak,_that.isPro,_that.rewards);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int currentStreak,  int bestStreak,  bool isPro,  List<StreakRewardItem> rewards)  $default,) {final _that = this;
switch (_that) {
case _StreaksPageViewModel():
return $default(_that.currentStreak,_that.bestStreak,_that.isPro,_that.rewards);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int currentStreak,  int bestStreak,  bool isPro,  List<StreakRewardItem> rewards)?  $default,) {final _that = this;
switch (_that) {
case _StreaksPageViewModel() when $default != null:
return $default(_that.currentStreak,_that.bestStreak,_that.isPro,_that.rewards);case _:
  return null;

}
}

}

/// @nodoc


class _StreaksPageViewModel extends StreaksPageViewModel {
  const _StreaksPageViewModel({required this.currentStreak, required this.bestStreak, required this.isPro, required final  List<StreakRewardItem> rewards}): _rewards = rewards,super._();
  

@override final  int currentStreak;
@override final  int bestStreak;
@override final  bool isPro;
 final  List<StreakRewardItem> _rewards;
@override List<StreakRewardItem> get rewards {
  if (_rewards is EqualUnmodifiableListView) return _rewards;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rewards);
}


/// Create a copy of StreaksPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreaksPageViewModelCopyWith<_StreaksPageViewModel> get copyWith => __$StreaksPageViewModelCopyWithImpl<_StreaksPageViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreaksPageViewModel&&(identical(other.currentStreak, currentStreak) || other.currentStreak == currentStreak)&&(identical(other.bestStreak, bestStreak) || other.bestStreak == bestStreak)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&const DeepCollectionEquality().equals(other._rewards, _rewards));
}


@override
int get hashCode => Object.hash(runtimeType,currentStreak,bestStreak,isPro,const DeepCollectionEquality().hash(_rewards));

@override
String toString() {
  return 'StreaksPageViewModel(currentStreak: $currentStreak, bestStreak: $bestStreak, isPro: $isPro, rewards: $rewards)';
}


}

/// @nodoc
abstract mixin class _$StreaksPageViewModelCopyWith<$Res> implements $StreaksPageViewModelCopyWith<$Res> {
  factory _$StreaksPageViewModelCopyWith(_StreaksPageViewModel value, $Res Function(_StreaksPageViewModel) _then) = __$StreaksPageViewModelCopyWithImpl;
@override @useResult
$Res call({
 int currentStreak, int bestStreak, bool isPro, List<StreakRewardItem> rewards
});




}
/// @nodoc
class __$StreaksPageViewModelCopyWithImpl<$Res>
    implements _$StreaksPageViewModelCopyWith<$Res> {
  __$StreaksPageViewModelCopyWithImpl(this._self, this._then);

  final _StreaksPageViewModel _self;
  final $Res Function(_StreaksPageViewModel) _then;

/// Create a copy of StreaksPageViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? currentStreak = null,Object? bestStreak = null,Object? isPro = null,Object? rewards = null,}) {
  return _then(_StreaksPageViewModel(
currentStreak: null == currentStreak ? _self.currentStreak : currentStreak // ignore: cast_nullable_to_non_nullable
as int,bestStreak: null == bestStreak ? _self.bestStreak : bestStreak // ignore: cast_nullable_to_non_nullable
as int,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,rewards: null == rewards ? _self._rewards : rewards // ignore: cast_nullable_to_non_nullable
as List<StreakRewardItem>,
  ));
}


}

/// @nodoc
mixin _$StreakRewardItem {

 RewardRule get rule;/// The streak has reached this milestone, so the reward is earned for
/// good, Pro or not.
 bool get isReached;/// The reward can be used now: earned, or included in Pro.
 bool get isAvailable;/// The next milestone the streak is heading for.
 bool get isActive; bool get isLast;
/// Create a copy of StreakRewardItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StreakRewardItemCopyWith<StreakRewardItem> get copyWith => _$StreakRewardItemCopyWithImpl<StreakRewardItem>(this as StreakRewardItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StreakRewardItem&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.isReached, isReached) || other.isReached == isReached)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isLast, isLast) || other.isLast == isLast));
}


@override
int get hashCode => Object.hash(runtimeType,rule,isReached,isAvailable,isActive,isLast);

@override
String toString() {
  return 'StreakRewardItem(rule: $rule, isReached: $isReached, isAvailable: $isAvailable, isActive: $isActive, isLast: $isLast)';
}


}

/// @nodoc
abstract mixin class $StreakRewardItemCopyWith<$Res>  {
  factory $StreakRewardItemCopyWith(StreakRewardItem value, $Res Function(StreakRewardItem) _then) = _$StreakRewardItemCopyWithImpl;
@useResult
$Res call({
 RewardRule rule, bool isReached, bool isAvailable, bool isActive, bool isLast
});




}
/// @nodoc
class _$StreakRewardItemCopyWithImpl<$Res>
    implements $StreakRewardItemCopyWith<$Res> {
  _$StreakRewardItemCopyWithImpl(this._self, this._then);

  final StreakRewardItem _self;
  final $Res Function(StreakRewardItem) _then;

/// Create a copy of StreakRewardItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rule = null,Object? isReached = null,Object? isAvailable = null,Object? isActive = null,Object? isLast = null,}) {
  return _then(_self.copyWith(
rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as RewardRule,isReached: null == isReached ? _self.isReached : isReached // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isLast: null == isLast ? _self.isLast : isLast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StreakRewardItem].
extension StreakRewardItemPatterns on StreakRewardItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StreakRewardItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StreakRewardItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StreakRewardItem value)  $default,){
final _that = this;
switch (_that) {
case _StreakRewardItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StreakRewardItem value)?  $default,){
final _that = this;
switch (_that) {
case _StreakRewardItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RewardRule rule,  bool isReached,  bool isAvailable,  bool isActive,  bool isLast)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StreakRewardItem() when $default != null:
return $default(_that.rule,_that.isReached,_that.isAvailable,_that.isActive,_that.isLast);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RewardRule rule,  bool isReached,  bool isAvailable,  bool isActive,  bool isLast)  $default,) {final _that = this;
switch (_that) {
case _StreakRewardItem():
return $default(_that.rule,_that.isReached,_that.isAvailable,_that.isActive,_that.isLast);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RewardRule rule,  bool isReached,  bool isAvailable,  bool isActive,  bool isLast)?  $default,) {final _that = this;
switch (_that) {
case _StreakRewardItem() when $default != null:
return $default(_that.rule,_that.isReached,_that.isAvailable,_that.isActive,_that.isLast);case _:
  return null;

}
}

}

/// @nodoc


class _StreakRewardItem extends StreakRewardItem {
  const _StreakRewardItem({required this.rule, required this.isReached, required this.isAvailable, required this.isActive, required this.isLast}): super._();
  

@override final  RewardRule rule;
/// The streak has reached this milestone, so the reward is earned for
/// good, Pro or not.
@override final  bool isReached;
/// The reward can be used now: earned, or included in Pro.
@override final  bool isAvailable;
/// The next milestone the streak is heading for.
@override final  bool isActive;
@override final  bool isLast;

/// Create a copy of StreakRewardItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StreakRewardItemCopyWith<_StreakRewardItem> get copyWith => __$StreakRewardItemCopyWithImpl<_StreakRewardItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StreakRewardItem&&(identical(other.rule, rule) || other.rule == rule)&&(identical(other.isReached, isReached) || other.isReached == isReached)&&(identical(other.isAvailable, isAvailable) || other.isAvailable == isAvailable)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.isLast, isLast) || other.isLast == isLast));
}


@override
int get hashCode => Object.hash(runtimeType,rule,isReached,isAvailable,isActive,isLast);

@override
String toString() {
  return 'StreakRewardItem(rule: $rule, isReached: $isReached, isAvailable: $isAvailable, isActive: $isActive, isLast: $isLast)';
}


}

/// @nodoc
abstract mixin class _$StreakRewardItemCopyWith<$Res> implements $StreakRewardItemCopyWith<$Res> {
  factory _$StreakRewardItemCopyWith(_StreakRewardItem value, $Res Function(_StreakRewardItem) _then) = __$StreakRewardItemCopyWithImpl;
@override @useResult
$Res call({
 RewardRule rule, bool isReached, bool isAvailable, bool isActive, bool isLast
});




}
/// @nodoc
class __$StreakRewardItemCopyWithImpl<$Res>
    implements _$StreakRewardItemCopyWith<$Res> {
  __$StreakRewardItemCopyWithImpl(this._self, this._then);

  final _StreakRewardItem _self;
  final $Res Function(_StreakRewardItem) _then;

/// Create a copy of StreakRewardItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rule = null,Object? isReached = null,Object? isAvailable = null,Object? isActive = null,Object? isLast = null,}) {
  return _then(_StreakRewardItem(
rule: null == rule ? _self.rule : rule // ignore: cast_nullable_to_non_nullable
as RewardRule,isReached: null == isReached ? _self.isReached : isReached // ignore: cast_nullable_to_non_nullable
as bool,isAvailable: null == isAvailable ? _self.isAvailable : isAvailable // ignore: cast_nullable_to_non_nullable
as bool,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,isLast: null == isLast ? _self.isLast : isLast // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
