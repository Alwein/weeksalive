import 'package:mocktail/mocktail.dart';
import 'package:weeksalive/data/push_notifications/push_notification_repository.dart';
import 'package:weeksalive/data/remote_config/remote_config_repository.dart';
import 'package:weeksalive/data/user/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockRemoteConfigRepository extends Mock implements RemoteConfigRepository {}

class MockPushNotificationRepository extends Mock implements PushNotificationRepository {}
