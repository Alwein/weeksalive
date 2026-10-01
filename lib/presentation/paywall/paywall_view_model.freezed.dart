// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'paywall_view_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PaywallPlanOption {

 PaywallPlanKind get kind; Package get package; String get price;/// Weekly equivalent of an annual price, so the annual card can show the comparison.
 String? get equivalentWeeklyPrice;/// Percent saved versus paying the weekly price for a year. Null when the
/// weekly plan is missing or the annual plan is not cheaper.
 int? get savingsPercent;
/// Create a copy of PaywallPlanOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywallPlanOptionCopyWith<PaywallPlanOption> get copyWith => _$PaywallPlanOptionCopyWithImpl<PaywallPlanOption>(this as PaywallPlanOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallPlanOption&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.package, package) || other.package == package)&&(identical(other.price, price) || other.price == price)&&(identical(other.equivalentWeeklyPrice, equivalentWeeklyPrice) || other.equivalentWeeklyPrice == equivalentWeeklyPrice)&&(identical(other.savingsPercent, savingsPercent) || other.savingsPercent == savingsPercent));
}


@override
int get hashCode => Object.hash(runtimeType,kind,package,price,equivalentWeeklyPrice,savingsPercent);

@override
String toString() {
  return 'PaywallPlanOption(kind: $kind, package: $package, price: $price, equivalentWeeklyPrice: $equivalentWeeklyPrice, savingsPercent: $savingsPercent)';
}


}

/// @nodoc
abstract mixin class $PaywallPlanOptionCopyWith<$Res>  {
  factory $PaywallPlanOptionCopyWith(PaywallPlanOption value, $Res Function(PaywallPlanOption) _then) = _$PaywallPlanOptionCopyWithImpl;
@useResult
$Res call({
 PaywallPlanKind kind, Package package, String price, String? equivalentWeeklyPrice, int? savingsPercent
});




}
/// @nodoc
class _$PaywallPlanOptionCopyWithImpl<$Res>
    implements $PaywallPlanOptionCopyWith<$Res> {
  _$PaywallPlanOptionCopyWithImpl(this._self, this._then);

  final PaywallPlanOption _self;
  final $Res Function(PaywallPlanOption) _then;

/// Create a copy of PaywallPlanOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? package = null,Object? price = null,Object? equivalentWeeklyPrice = freezed,Object? savingsPercent = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PaywallPlanKind,package: null == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as Package,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,equivalentWeeklyPrice: freezed == equivalentWeeklyPrice ? _self.equivalentWeeklyPrice : equivalentWeeklyPrice // ignore: cast_nullable_to_non_nullable
as String?,savingsPercent: freezed == savingsPercent ? _self.savingsPercent : savingsPercent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaywallPlanOption].
extension PaywallPlanOptionPatterns on PaywallPlanOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaywallPlanOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaywallPlanOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaywallPlanOption value)  $default,){
final _that = this;
switch (_that) {
case _PaywallPlanOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaywallPlanOption value)?  $default,){
final _that = this;
switch (_that) {
case _PaywallPlanOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaywallPlanKind kind,  Package package,  String price,  String? equivalentWeeklyPrice,  int? savingsPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaywallPlanOption() when $default != null:
return $default(_that.kind,_that.package,_that.price,_that.equivalentWeeklyPrice,_that.savingsPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaywallPlanKind kind,  Package package,  String price,  String? equivalentWeeklyPrice,  int? savingsPercent)  $default,) {final _that = this;
switch (_that) {
case _PaywallPlanOption():
return $default(_that.kind,_that.package,_that.price,_that.equivalentWeeklyPrice,_that.savingsPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaywallPlanKind kind,  Package package,  String price,  String? equivalentWeeklyPrice,  int? savingsPercent)?  $default,) {final _that = this;
switch (_that) {
case _PaywallPlanOption() when $default != null:
return $default(_that.kind,_that.package,_that.price,_that.equivalentWeeklyPrice,_that.savingsPercent);case _:
  return null;

}
}

}

/// @nodoc


class _PaywallPlanOption implements PaywallPlanOption {
  const _PaywallPlanOption({required this.kind, required this.package, required this.price, this.equivalentWeeklyPrice, this.savingsPercent});
  

@override final  PaywallPlanKind kind;
@override final  Package package;
@override final  String price;
/// Weekly equivalent of an annual price, so the annual card can show the comparison.
@override final  String? equivalentWeeklyPrice;
/// Percent saved versus paying the weekly price for a year. Null when the
/// weekly plan is missing or the annual plan is not cheaper.
@override final  int? savingsPercent;

/// Create a copy of PaywallPlanOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaywallPlanOptionCopyWith<_PaywallPlanOption> get copyWith => __$PaywallPlanOptionCopyWithImpl<_PaywallPlanOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaywallPlanOption&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.package, package) || other.package == package)&&(identical(other.price, price) || other.price == price)&&(identical(other.equivalentWeeklyPrice, equivalentWeeklyPrice) || other.equivalentWeeklyPrice == equivalentWeeklyPrice)&&(identical(other.savingsPercent, savingsPercent) || other.savingsPercent == savingsPercent));
}


@override
int get hashCode => Object.hash(runtimeType,kind,package,price,equivalentWeeklyPrice,savingsPercent);

@override
String toString() {
  return 'PaywallPlanOption(kind: $kind, package: $package, price: $price, equivalentWeeklyPrice: $equivalentWeeklyPrice, savingsPercent: $savingsPercent)';
}


}

/// @nodoc
abstract mixin class _$PaywallPlanOptionCopyWith<$Res> implements $PaywallPlanOptionCopyWith<$Res> {
  factory _$PaywallPlanOptionCopyWith(_PaywallPlanOption value, $Res Function(_PaywallPlanOption) _then) = __$PaywallPlanOptionCopyWithImpl;
@override @useResult
$Res call({
 PaywallPlanKind kind, Package package, String price, String? equivalentWeeklyPrice, int? savingsPercent
});




}
/// @nodoc
class __$PaywallPlanOptionCopyWithImpl<$Res>
    implements _$PaywallPlanOptionCopyWith<$Res> {
  __$PaywallPlanOptionCopyWithImpl(this._self, this._then);

  final _PaywallPlanOption _self;
  final $Res Function(_PaywallPlanOption) _then;

/// Create a copy of PaywallPlanOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? package = null,Object? price = null,Object? equivalentWeeklyPrice = freezed,Object? savingsPercent = freezed,}) {
  return _then(_PaywallPlanOption(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as PaywallPlanKind,package: null == package ? _self.package : package // ignore: cast_nullable_to_non_nullable
as Package,price: null == price ? _self.price : price // ignore: cast_nullable_to_non_nullable
as String,equivalentWeeklyPrice: freezed == equivalentWeeklyPrice ? _self.equivalentWeeklyPrice : equivalentWeeklyPrice // ignore: cast_nullable_to_non_nullable
as String?,savingsPercent: freezed == savingsPercent ? _self.savingsPercent : savingsPercent // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$PaywallPlanData {

 Package? get annualPackage; int? get trialDays; int? get trialWeeks; String? get pricePerYear; String? get pricePerWeek; String? get trialEndDate; String? get offeringId;
/// Create a copy of PaywallPlanData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywallPlanDataCopyWith<PaywallPlanData> get copyWith => _$PaywallPlanDataCopyWithImpl<PaywallPlanData>(this as PaywallPlanData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallPlanData&&(identical(other.annualPackage, annualPackage) || other.annualPackage == annualPackage)&&(identical(other.trialDays, trialDays) || other.trialDays == trialDays)&&(identical(other.trialWeeks, trialWeeks) || other.trialWeeks == trialWeeks)&&(identical(other.pricePerYear, pricePerYear) || other.pricePerYear == pricePerYear)&&(identical(other.pricePerWeek, pricePerWeek) || other.pricePerWeek == pricePerWeek)&&(identical(other.trialEndDate, trialEndDate) || other.trialEndDate == trialEndDate)&&(identical(other.offeringId, offeringId) || other.offeringId == offeringId));
}


@override
int get hashCode => Object.hash(runtimeType,annualPackage,trialDays,trialWeeks,pricePerYear,pricePerWeek,trialEndDate,offeringId);

@override
String toString() {
  return 'PaywallPlanData(annualPackage: $annualPackage, trialDays: $trialDays, trialWeeks: $trialWeeks, pricePerYear: $pricePerYear, pricePerWeek: $pricePerWeek, trialEndDate: $trialEndDate, offeringId: $offeringId)';
}


}

/// @nodoc
abstract mixin class $PaywallPlanDataCopyWith<$Res>  {
  factory $PaywallPlanDataCopyWith(PaywallPlanData value, $Res Function(PaywallPlanData) _then) = _$PaywallPlanDataCopyWithImpl;
@useResult
$Res call({
 Package? annualPackage, int? trialDays, int? trialWeeks, String? pricePerYear, String? pricePerWeek, String? trialEndDate, String? offeringId
});




}
/// @nodoc
class _$PaywallPlanDataCopyWithImpl<$Res>
    implements $PaywallPlanDataCopyWith<$Res> {
  _$PaywallPlanDataCopyWithImpl(this._self, this._then);

  final PaywallPlanData _self;
  final $Res Function(PaywallPlanData) _then;

/// Create a copy of PaywallPlanData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? annualPackage = freezed,Object? trialDays = freezed,Object? trialWeeks = freezed,Object? pricePerYear = freezed,Object? pricePerWeek = freezed,Object? trialEndDate = freezed,Object? offeringId = freezed,}) {
  return _then(_self.copyWith(
annualPackage: freezed == annualPackage ? _self.annualPackage : annualPackage // ignore: cast_nullable_to_non_nullable
as Package?,trialDays: freezed == trialDays ? _self.trialDays : trialDays // ignore: cast_nullable_to_non_nullable
as int?,trialWeeks: freezed == trialWeeks ? _self.trialWeeks : trialWeeks // ignore: cast_nullable_to_non_nullable
as int?,pricePerYear: freezed == pricePerYear ? _self.pricePerYear : pricePerYear // ignore: cast_nullable_to_non_nullable
as String?,pricePerWeek: freezed == pricePerWeek ? _self.pricePerWeek : pricePerWeek // ignore: cast_nullable_to_non_nullable
as String?,trialEndDate: freezed == trialEndDate ? _self.trialEndDate : trialEndDate // ignore: cast_nullable_to_non_nullable
as String?,offeringId: freezed == offeringId ? _self.offeringId : offeringId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PaywallPlanData].
extension PaywallPlanDataPatterns on PaywallPlanData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaywallPlanData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaywallPlanData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaywallPlanData value)  $default,){
final _that = this;
switch (_that) {
case _PaywallPlanData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaywallPlanData value)?  $default,){
final _that = this;
switch (_that) {
case _PaywallPlanData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Package? annualPackage,  int? trialDays,  int? trialWeeks,  String? pricePerYear,  String? pricePerWeek,  String? trialEndDate,  String? offeringId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaywallPlanData() when $default != null:
return $default(_that.annualPackage,_that.trialDays,_that.trialWeeks,_that.pricePerYear,_that.pricePerWeek,_that.trialEndDate,_that.offeringId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Package? annualPackage,  int? trialDays,  int? trialWeeks,  String? pricePerYear,  String? pricePerWeek,  String? trialEndDate,  String? offeringId)  $default,) {final _that = this;
switch (_that) {
case _PaywallPlanData():
return $default(_that.annualPackage,_that.trialDays,_that.trialWeeks,_that.pricePerYear,_that.pricePerWeek,_that.trialEndDate,_that.offeringId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Package? annualPackage,  int? trialDays,  int? trialWeeks,  String? pricePerYear,  String? pricePerWeek,  String? trialEndDate,  String? offeringId)?  $default,) {final _that = this;
switch (_that) {
case _PaywallPlanData() when $default != null:
return $default(_that.annualPackage,_that.trialDays,_that.trialWeeks,_that.pricePerYear,_that.pricePerWeek,_that.trialEndDate,_that.offeringId);case _:
  return null;

}
}

}

/// @nodoc


class _PaywallPlanData implements PaywallPlanData {
  const _PaywallPlanData({required this.annualPackage, required this.trialDays, required this.trialWeeks, required this.pricePerYear, required this.pricePerWeek, required this.trialEndDate, required this.offeringId});
  

@override final  Package? annualPackage;
@override final  int? trialDays;
@override final  int? trialWeeks;
@override final  String? pricePerYear;
@override final  String? pricePerWeek;
@override final  String? trialEndDate;
@override final  String? offeringId;

/// Create a copy of PaywallPlanData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaywallPlanDataCopyWith<_PaywallPlanData> get copyWith => __$PaywallPlanDataCopyWithImpl<_PaywallPlanData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaywallPlanData&&(identical(other.annualPackage, annualPackage) || other.annualPackage == annualPackage)&&(identical(other.trialDays, trialDays) || other.trialDays == trialDays)&&(identical(other.trialWeeks, trialWeeks) || other.trialWeeks == trialWeeks)&&(identical(other.pricePerYear, pricePerYear) || other.pricePerYear == pricePerYear)&&(identical(other.pricePerWeek, pricePerWeek) || other.pricePerWeek == pricePerWeek)&&(identical(other.trialEndDate, trialEndDate) || other.trialEndDate == trialEndDate)&&(identical(other.offeringId, offeringId) || other.offeringId == offeringId));
}


@override
int get hashCode => Object.hash(runtimeType,annualPackage,trialDays,trialWeeks,pricePerYear,pricePerWeek,trialEndDate,offeringId);

@override
String toString() {
  return 'PaywallPlanData(annualPackage: $annualPackage, trialDays: $trialDays, trialWeeks: $trialWeeks, pricePerYear: $pricePerYear, pricePerWeek: $pricePerWeek, trialEndDate: $trialEndDate, offeringId: $offeringId)';
}


}

/// @nodoc
abstract mixin class _$PaywallPlanDataCopyWith<$Res> implements $PaywallPlanDataCopyWith<$Res> {
  factory _$PaywallPlanDataCopyWith(_PaywallPlanData value, $Res Function(_PaywallPlanData) _then) = __$PaywallPlanDataCopyWithImpl;
@override @useResult
$Res call({
 Package? annualPackage, int? trialDays, int? trialWeeks, String? pricePerYear, String? pricePerWeek, String? trialEndDate, String? offeringId
});




}
/// @nodoc
class __$PaywallPlanDataCopyWithImpl<$Res>
    implements _$PaywallPlanDataCopyWith<$Res> {
  __$PaywallPlanDataCopyWithImpl(this._self, this._then);

  final _PaywallPlanData _self;
  final $Res Function(_PaywallPlanData) _then;

/// Create a copy of PaywallPlanData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? annualPackage = freezed,Object? trialDays = freezed,Object? trialWeeks = freezed,Object? pricePerYear = freezed,Object? pricePerWeek = freezed,Object? trialEndDate = freezed,Object? offeringId = freezed,}) {
  return _then(_PaywallPlanData(
annualPackage: freezed == annualPackage ? _self.annualPackage : annualPackage // ignore: cast_nullable_to_non_nullable
as Package?,trialDays: freezed == trialDays ? _self.trialDays : trialDays // ignore: cast_nullable_to_non_nullable
as int?,trialWeeks: freezed == trialWeeks ? _self.trialWeeks : trialWeeks // ignore: cast_nullable_to_non_nullable
as int?,pricePerYear: freezed == pricePerYear ? _self.pricePerYear : pricePerYear // ignore: cast_nullable_to_non_nullable
as String?,pricePerWeek: freezed == pricePerWeek ? _self.pricePerWeek : pricePerWeek // ignore: cast_nullable_to_non_nullable
as String?,trialEndDate: freezed == trialEndDate ? _self.trialEndDate : trialEndDate // ignore: cast_nullable_to_non_nullable
as String?,offeringId: freezed == offeringId ? _self.offeringId : offeringId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$PaywallViewModel {

 PaywallPlanData? get primaryPlan; PaywallPlanData? get alternatePlan; List<PaywallPlanOption> get plans; bool get isLoading; bool get isPro; String? get errorMessage;
/// Create a copy of PaywallViewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PaywallViewModelCopyWith<PaywallViewModel> get copyWith => _$PaywallViewModelCopyWithImpl<PaywallViewModel>(this as PaywallViewModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PaywallViewModel&&(identical(other.primaryPlan, primaryPlan) || other.primaryPlan == primaryPlan)&&(identical(other.alternatePlan, alternatePlan) || other.alternatePlan == alternatePlan)&&const DeepCollectionEquality().equals(other.plans, plans)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,primaryPlan,alternatePlan,const DeepCollectionEquality().hash(plans),isLoading,isPro,errorMessage);

@override
String toString() {
  return 'PaywallViewModel(primaryPlan: $primaryPlan, alternatePlan: $alternatePlan, plans: $plans, isLoading: $isLoading, isPro: $isPro, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $PaywallViewModelCopyWith<$Res>  {
  factory $PaywallViewModelCopyWith(PaywallViewModel value, $Res Function(PaywallViewModel) _then) = _$PaywallViewModelCopyWithImpl;
@useResult
$Res call({
 PaywallPlanData? primaryPlan, PaywallPlanData? alternatePlan, List<PaywallPlanOption> plans, bool isLoading, bool isPro, String? errorMessage
});


$PaywallPlanDataCopyWith<$Res>? get primaryPlan;$PaywallPlanDataCopyWith<$Res>? get alternatePlan;

}
/// @nodoc
class _$PaywallViewModelCopyWithImpl<$Res>
    implements $PaywallViewModelCopyWith<$Res> {
  _$PaywallViewModelCopyWithImpl(this._self, this._then);

  final PaywallViewModel _self;
  final $Res Function(PaywallViewModel) _then;

/// Create a copy of PaywallViewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? primaryPlan = freezed,Object? alternatePlan = freezed,Object? plans = null,Object? isLoading = null,Object? isPro = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
primaryPlan: freezed == primaryPlan ? _self.primaryPlan : primaryPlan // ignore: cast_nullable_to_non_nullable
as PaywallPlanData?,alternatePlan: freezed == alternatePlan ? _self.alternatePlan : alternatePlan // ignore: cast_nullable_to_non_nullable
as PaywallPlanData?,plans: null == plans ? _self.plans : plans // ignore: cast_nullable_to_non_nullable
as List<PaywallPlanOption>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of PaywallViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywallPlanDataCopyWith<$Res>? get primaryPlan {
    if (_self.primaryPlan == null) {
    return null;
  }

  return $PaywallPlanDataCopyWith<$Res>(_self.primaryPlan!, (value) {
    return _then(_self.copyWith(primaryPlan: value));
  });
}/// Create a copy of PaywallViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywallPlanDataCopyWith<$Res>? get alternatePlan {
    if (_self.alternatePlan == null) {
    return null;
  }

  return $PaywallPlanDataCopyWith<$Res>(_self.alternatePlan!, (value) {
    return _then(_self.copyWith(alternatePlan: value));
  });
}
}


/// Adds pattern-matching-related methods to [PaywallViewModel].
extension PaywallViewModelPatterns on PaywallViewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PaywallViewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PaywallViewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PaywallViewModel value)  $default,){
final _that = this;
switch (_that) {
case _PaywallViewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PaywallViewModel value)?  $default,){
final _that = this;
switch (_that) {
case _PaywallViewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PaywallPlanData? primaryPlan,  PaywallPlanData? alternatePlan,  List<PaywallPlanOption> plans,  bool isLoading,  bool isPro,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PaywallViewModel() when $default != null:
return $default(_that.primaryPlan,_that.alternatePlan,_that.plans,_that.isLoading,_that.isPro,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PaywallPlanData? primaryPlan,  PaywallPlanData? alternatePlan,  List<PaywallPlanOption> plans,  bool isLoading,  bool isPro,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _PaywallViewModel():
return $default(_that.primaryPlan,_that.alternatePlan,_that.plans,_that.isLoading,_that.isPro,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PaywallPlanData? primaryPlan,  PaywallPlanData? alternatePlan,  List<PaywallPlanOption> plans,  bool isLoading,  bool isPro,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _PaywallViewModel() when $default != null:
return $default(_that.primaryPlan,_that.alternatePlan,_that.plans,_that.isLoading,_that.isPro,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _PaywallViewModel extends PaywallViewModel {
  const _PaywallViewModel({required this.primaryPlan, required this.alternatePlan, required final  List<PaywallPlanOption> plans, required this.isLoading, required this.isPro, required this.errorMessage}): _plans = plans,super._();
  

@override final  PaywallPlanData? primaryPlan;
@override final  PaywallPlanData? alternatePlan;
 final  List<PaywallPlanOption> _plans;
@override List<PaywallPlanOption> get plans {
  if (_plans is EqualUnmodifiableListView) return _plans;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_plans);
}

@override final  bool isLoading;
@override final  bool isPro;
@override final  String? errorMessage;

/// Create a copy of PaywallViewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PaywallViewModelCopyWith<_PaywallViewModel> get copyWith => __$PaywallViewModelCopyWithImpl<_PaywallViewModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PaywallViewModel&&(identical(other.primaryPlan, primaryPlan) || other.primaryPlan == primaryPlan)&&(identical(other.alternatePlan, alternatePlan) || other.alternatePlan == alternatePlan)&&const DeepCollectionEquality().equals(other._plans, _plans)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isPro, isPro) || other.isPro == isPro)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,primaryPlan,alternatePlan,const DeepCollectionEquality().hash(_plans),isLoading,isPro,errorMessage);

@override
String toString() {
  return 'PaywallViewModel(primaryPlan: $primaryPlan, alternatePlan: $alternatePlan, plans: $plans, isLoading: $isLoading, isPro: $isPro, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$PaywallViewModelCopyWith<$Res> implements $PaywallViewModelCopyWith<$Res> {
  factory _$PaywallViewModelCopyWith(_PaywallViewModel value, $Res Function(_PaywallViewModel) _then) = __$PaywallViewModelCopyWithImpl;
@override @useResult
$Res call({
 PaywallPlanData? primaryPlan, PaywallPlanData? alternatePlan, List<PaywallPlanOption> plans, bool isLoading, bool isPro, String? errorMessage
});


@override $PaywallPlanDataCopyWith<$Res>? get primaryPlan;@override $PaywallPlanDataCopyWith<$Res>? get alternatePlan;

}
/// @nodoc
class __$PaywallViewModelCopyWithImpl<$Res>
    implements _$PaywallViewModelCopyWith<$Res> {
  __$PaywallViewModelCopyWithImpl(this._self, this._then);

  final _PaywallViewModel _self;
  final $Res Function(_PaywallViewModel) _then;

/// Create a copy of PaywallViewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? primaryPlan = freezed,Object? alternatePlan = freezed,Object? plans = null,Object? isLoading = null,Object? isPro = null,Object? errorMessage = freezed,}) {
  return _then(_PaywallViewModel(
primaryPlan: freezed == primaryPlan ? _self.primaryPlan : primaryPlan // ignore: cast_nullable_to_non_nullable
as PaywallPlanData?,alternatePlan: freezed == alternatePlan ? _self.alternatePlan : alternatePlan // ignore: cast_nullable_to_non_nullable
as PaywallPlanData?,plans: null == plans ? _self._plans : plans // ignore: cast_nullable_to_non_nullable
as List<PaywallPlanOption>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isPro: null == isPro ? _self.isPro : isPro // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of PaywallViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywallPlanDataCopyWith<$Res>? get primaryPlan {
    if (_self.primaryPlan == null) {
    return null;
  }

  return $PaywallPlanDataCopyWith<$Res>(_self.primaryPlan!, (value) {
    return _then(_self.copyWith(primaryPlan: value));
  });
}/// Create a copy of PaywallViewModel
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PaywallPlanDataCopyWith<$Res>? get alternatePlan {
    if (_self.alternatePlan == null) {
    return null;
  }

  return $PaywallPlanDataCopyWith<$Res>(_self.alternatePlan!, (value) {
    return _then(_self.copyWith(alternatePlan: value));
  });
}
}

// dart format on
