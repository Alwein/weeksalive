import 'package:flutter_test/flutter_test.dart';
import 'package:weeksalive/presentation/redux/app_state.dart';

// ignore_for_file: avoid_print

TypeMatcher<AppState> stateWith<V>(V Function(AppState) extract, dynamic matcher) {
  final wrapped = wrapMatcher(matcher);
  return isA<AppState>().having(extract, wrapped.describe(StringDescription()).toString(), wrapped);
}

extension TypeMatcherX<T> on TypeMatcher<T> {
  TypeMatcher<T> where<V>(V Function(T) fn, dynamic matcher) {
    final wrapped = wrapMatcher(matcher);
    return having(fn, wrapped.describe(StringDescription()).toString(), wrapped);
  }
}

class StateMatch extends Matcher {
  final bool Function(AppState) statePredicate;

  const StateMatch(this.statePredicate);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item == null || item is! AppState) return false;
    return statePredicate(item);
  }

  @override
  Description describe(Description description) => description.add("AppState doesn't match predicate");
}

class DebugMatcher extends Matcher {
  final dynamic Function(AppState) getDebugInfo;

  DebugMatcher(this.getDebugInfo);

  @override
  bool matches(Object? item, Map<dynamic, dynamic> matchState) {
    if (item == null) {
      print("DebugMatcher: item null");
      return false;
    }
    if (item is! AppState) {
      print("DebugMatcher: item isn't an AppState");
      return false;
    }
    print("DebugMatcher: ${getDebugInfo(item)}");
    return false;
  }

  @override
  Description describe(Description description) => description.add('state debug');
}
