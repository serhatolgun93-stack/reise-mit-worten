import 'package:flutter/widgets.dart';

enum MotionMode { normal, reduced }

final class MotionPolicy {
  final MotionMode mode;
  const MotionPolicy(this.mode);

  bool get reduced => mode == MotionMode.reduced;

  Duration duration(Duration normal) => reduced ? Duration.zero : normal;

  static MotionPolicy of(BuildContext context) => MotionPolicy(
    MediaQuery.of(context).disableAnimations ? MotionMode.reduced : MotionMode.normal,
  );
}
