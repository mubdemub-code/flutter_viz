import 'package:flutter/material.dart';

import '../editor/ui/mobile/mobile_editor_screen.dart';

/// Backward-compatible entry point. The old "desktop only" screen has been
/// replaced by the real mobile editor shell.
class MobileViewScreen extends StatelessWidget {
  const MobileViewScreen({super.key});

  @override
  Widget build(BuildContext context) => const MobileEditorScreen();
}
