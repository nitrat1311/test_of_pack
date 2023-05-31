class AppState {
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();
  bool soundEffects = false;
  bool backgroundMusic = false;
}
