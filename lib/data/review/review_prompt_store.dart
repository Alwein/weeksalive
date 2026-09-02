abstract class ReviewPromptStore {
  bool get hasRequested;
  int get checkInCount;

  Future<int> incrementCheckInCount();
  Future<void> markRequested();
}
