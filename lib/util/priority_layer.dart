class LayerPriority {
  // ignore: constant_identifier_names
  static const int BACKGROUND = 10;
  // ignore: constant_identifier_names
  static const int MAP = 20;
  // ignore: constant_identifier_names
  static const int _COMPONENTS = 30;

  static int getComponentPriority(int bottom) {
    return _COMPONENTS + bottom;
  }

  static int getAbovePriority(int highestPriority) {
    return highestPriority + 5;
  }

  static int getLightingPriority(int highestPriority) {
    return highestPriority + 10;
  }

  static int getColorFilterPriority(int highestPriority) {
    return highestPriority + 20;
  }

  static int getInterfacePriority(int highestPriority) {
    return highestPriority + 30;
  }

  static int getJoystickPriority(int highestPriority) {
    return highestPriority + 40;
  }
}
