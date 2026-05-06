enum DisplayState {
  initial,
  loading,
  success,
  error;

  bool get isLoading => this == loading;
  bool get isSuccess => this == success;
  bool get isError => this == error;
  bool get isInitial => this == initial;
}
