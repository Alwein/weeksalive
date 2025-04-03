import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter_fast_template/data/analytics/analytics_repository.dart';
import 'package:flutter_fast_template/data/device/configuration_repository.dart';
import 'package:flutter_fast_template/data/user/update_user_config_request.dart';
import 'package:flutter_fast_template/data/user/user_repository.dart';
import 'package:flutter_fast_template/domain/user/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_bloc.freezed.dart';
part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc({
    required UserRepository userRepository,
    required ConfigurationRepository configurationRepository,
    required AnalyticsRepository analyticsRepository,
  })  : _userRepository = userRepository,
        _configurationRepository = configurationRepository,
        _analyticsRepository = analyticsRepository,
        super(const UserState()) {
    on<UserEvent>((event, emit) => event.map(
          initialize: (event) => _onInitialize(event, emit),
          userChanged: (event) => _onUserChanged(event, emit),
        ));
  }

  final UserRepository _userRepository;
  final ConfigurationRepository _configurationRepository;
  final AnalyticsRepository _analyticsRepository;

  late StreamSubscription<User?> _userSubscription;

  FutureOr<void> _onInitialize(_Initialize event, Emitter<UserState> emit) async {
    emit(state.copyWith(status: const UserStatus.loading()));

    _userSubscription = _userRepository.streamUser(event.userId).listen((user) {
      add(UserEvent.userChanged(user));
    });

    await _userRepository.updateUserConfig(
      event.userId,
      UpdateUserConfigRequest.create(
        appVersion: await _configurationRepository.getAppVersion(),
        currencySymbol: await _configurationRepository.getCurrencySymbol(),
        locale: await _configurationRepository.getLocale(),
        timeZone: await _configurationRepository.getTimeZone(),
      ),
    );
  }

  FutureOr<void> _onUserChanged(_UserChanged event, Emitter<UserState> emit) async {
    final user = event.user;
    if (user == null) {
      emit(state.copyWith(status: const UserStatus.error()));
    } else {
      await _analyticsRepository.setUserProperty(
        name: 'user_type',
        value: user.premiumPlan?.toString() ?? 'free',
      );
      emit(UserState(status: UserStatus.success(user)));
    }
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
