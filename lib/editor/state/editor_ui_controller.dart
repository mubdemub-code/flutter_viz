import 'package:flutter/foundation.dart';

/// Editor shell state. It intentionally contains presentation state only;
/// the existing AppStore remains the source of truth for the document.
enum MobileEditorPanel {
  widgets,
  tree,
  screens,
  components,
  media,
  more,
}

class EditorUiController extends ChangeNotifier {
  MobileEditorPanel _activePanel = MobileEditorPanel.widgets;
  bool _paletteOpen = true;
  bool _treeOpen = false;
  bool _screensOpen = false;
  bool _componentsOpen = false;
  bool _inspectorRequested = false;
  bool _focusMode = false;
  bool _previewMode = false;

  MobileEditorPanel get activePanel => _activePanel;
  bool get paletteOpen => _paletteOpen;
  bool get treeOpen => _treeOpen;
  bool get screensOpen => _screensOpen;
  bool get componentsOpen => _componentsOpen;
  bool get inspectorRequested => _inspectorRequested;
  bool get focusMode => _focusMode;
  bool get previewMode => _previewMode;

  void selectPanel(MobileEditorPanel panel) {
    _activePanel = panel;
    _paletteOpen = panel == MobileEditorPanel.widgets;
    _treeOpen = panel == MobileEditorPanel.tree;
    _screensOpen = panel == MobileEditorPanel.screens;
    _componentsOpen = panel == MobileEditorPanel.components;
    notifyListeners();
  }

  void togglePalette() {
    _paletteOpen = !_paletteOpen;
    if (_paletteOpen) {
      _activePanel = MobileEditorPanel.widgets;
    }
    notifyListeners();
  }

  void setInspectorRequested(bool value) {
    _inspectorRequested = value;
    notifyListeners();
  }

  void toggleFocusMode() {
    _focusMode = !_focusMode;
    notifyListeners();
  }

  void setPreviewMode(bool value) {
    _previewMode = value;
    notifyListeners();
  }

  void refreshCanvas() => notifyListeners();
}
