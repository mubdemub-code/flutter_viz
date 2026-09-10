import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../model/device_screen_size.dart';

import '../../../components/centerView/center_body_component.dart';
import '../../../components/media_component.dart';
import '../../../components/predefine_list_component.dart';
import '../../../components/screen_list_component.dart';
import '../../../main.dart';
import '../../../utils/AppConstant.dart';
import '../../state/editor_ui_controller.dart';
import 'mobile_inspector_sheet.dart';
import 'mobile_tool_rail.dart';
import 'mobile_tree_sheet.dart';
import 'mobile_widget_picker.dart';

class MobileEditorScreen extends StatefulWidget {
  const MobileEditorScreen({super.key});

  @override
  State<MobileEditorScreen> createState() => _MobileEditorScreenState();
}

class _MobileEditorScreenState extends State<MobileEditorScreen> {
  late final EditorUiController _ui;

  @override
  void initState() {
    super.initState();
    _ui = EditorUiController();
  }

  @override
  void dispose() {
    _ui.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ui,
      builder: (context, _) {
        if (_ui.focusMode) {
          return _buildFocusMode(context);
        }
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                _MobileTopBar(ui: _ui),
                Expanded(
                  child: Row(
                    children: [
                      MobileToolRail(controller: _ui),
                      Expanded(child: _buildMainSurface(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainSurface(BuildContext context) {
    if (_ui.activePanel == MobileEditorPanel.screens) {
      return _panelShell(ScreenListComponent(), 'Screens', () => _ui.selectPanel(MobileEditorPanel.widgets));
    }
    if (_ui.activePanel == MobileEditorPanel.components) {
      return _panelShell(PredefineListComponent(), 'Components', () => _ui.selectPanel(MobileEditorPanel.widgets));
    }
    if (_ui.activePanel == MobileEditorPanel.media) {
      return _panelShell(MediaComponent(), 'Media', () => _ui.selectPanel(MobileEditorPanel.widgets));
    }
    if (_ui.activePanel == MobileEditorPanel.tree) {
      return MobileTreeSheet(onClose: () => _ui.selectPanel(MobileEditorPanel.widgets));
    }
    if (_ui.activePanel == MobileEditorPanel.more) {
      return _morePanel(context);
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: const Color(0xFF0C1719),
          child: CenterBodyComponent(mobileMode: true),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 220),
          left: 0,
          right: 0,
          bottom: _ui.paletteOpen ? 0 : -260,
          height: 260,
          child: Material(
            elevation: 20,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
            clipBehavior: Clip.antiAlias,
            child: MobileWidgetPicker(onAdded: () => _ui.togglePalette()),
          ),
        ),
        Observer(
          builder: (_) {
            if (appStore.currentSelectedWidget == null || _ui.paletteOpen) return const SizedBox.shrink();
            return Positioned.fill(
              child: MobileInspectorSheet(onClose: () => appStore.currentSelectedWidget = null),
            );
          },
        ),
      ],
    );
  }

  Widget _panelShell(Widget child, String title, VoidCallback onBack) {
    return Column(
      children: [
        ListTile(
          dense: true,
          leading: IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        ),
        const Divider(height: 1),
        Expanded(child: child),
      ],
    );
  }

  Widget _morePanel(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Editor', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        _ActionTile(Icons.code, 'View generated code', () => appStore.setPreviewCode(true)),
        _ActionTile(Icons.keyboard, 'Keyboard shortcuts', () {}),
        _ActionTile(Icons.settings_outlined, 'Project settings', () {}),
        _ActionTile(Icons.help_outline, 'Help & FAQ', () {}),
      ],
    );
  }

  Widget _buildFocusMode(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          const CenterBodyComponent(mobileMode: true),
          Positioned(
            top: 8,
            right: 8,
            child: SafeArea(child: IconButton(onPressed: _ui.toggleFocusMode, color: Colors.white, icon: const Icon(Icons.fullscreen_exit))),
          ),
        ],
      ),
    );
  }
}

class _MobileTopBar extends StatelessWidget {
  final EditorUiController ui;
  const _MobileTopBar({required this.ui});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      child: SizedBox(
        height: 52,
        child: Row(
          children: [
            IconButton(onPressed: () => Navigator.of(context).maybePop(), icon: const Icon(Icons.arrow_back)),
            Expanded(
              child: Observer(
                builder: (_) => Text(
                  appStore.projectName?.isNotEmpty == true ? appStore.projectName! : 'FlutterViz',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
            IconButton(onPressed: () => _tryUndo(), tooltip: 'Undo', icon: const Icon(Icons.undo)),
            IconButton(onPressed: () => _tryRedo(), tooltip: 'Redo', icon: const Icon(Icons.redo)),
            IconButton(onPressed: () => _showDevicePicker(context), tooltip: 'Device', icon: const Icon(Icons.phone_android_outlined)),
            IconButton(onPressed: () => ui.setPreviewMode(true), tooltip: 'Preview', icon: const Icon(Icons.play_arrow_outlined)),
            IconButton(onPressed: () => _showMore(context), tooltip: 'More', icon: const Icon(Icons.more_horiz)),
          ],
        ),
      ),
    );
  }

  void _tryUndo() {
    if (appStore.canUndo()) appStore.undo();
  }

  void _tryRedo() {
    if (appStore.canRedo()) appStore.redo();
  }

  void _showDevicePicker(BuildContext context) {
    final devices = <DeviceScreenSize>[
      DeviceScreenSize(name: 'Vivo V11 Pro', deviceWidth: 350, deviceHeight: 650),
      DeviceScreenSize(name: 'Samsung S20', deviceWidth: 360, deviceHeight: 800),
      DeviceScreenSize(name: 'iPhone 12 Pro Max', deviceWidth: 428, deviceHeight: 926),
      DeviceScreenSize(name: 'iPad Mini', deviceWidth: 768, deviceHeight: 1024),
    ];
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: devices.length,
          itemBuilder: (context, index) {
            final device = devices[index];
            return ListTile(
              leading: const Icon(Icons.smartphone_outlined),
              title: Text(device.name ?? 'Device'),
              subtitle: Text('${device.deviceWidth?.round()} × ${device.deviceHeight?.round()}'),
              onTap: () {
                deviceWidth = device.deviceWidth ?? DEVICE_WIDTH;
                deviceHeight = device.deviceHeight ?? DEVICE_HEIGHT;
                Navigator.pop(context);
                ui.refreshCanvas();
              },
            );
          },
        ),
      ),
    );
  }

  void _showMore(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(leading: const Icon(Icons.fullscreen), title: const Text('Focus canvas'), onTap: () { Navigator.pop(context); ui.toggleFocusMode(); }),
            ListTile(leading: const Icon(Icons.layers_outlined), title: const Text('Layers'), onTap: () { Navigator.pop(context); ui.selectPanel(MobileEditorPanel.tree); }),
            ListTile(leading: const Icon(Icons.widgets_outlined), title: const Text('Widgets'), onTap: () { Navigator.pop(context); ui.selectPanel(MobileEditorPanel.widgets); }),
            ListTile(leading: const Icon(Icons.code), title: const Text('Generated code'), onTap: () { Navigator.pop(context); appStore.setPreviewCode(true); }),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _ActionTile(this.icon, this.title, this.onTap);
  @override
  Widget build(BuildContext context) => Card(child: ListTile(leading: Icon(icon), title: Text(title), trailing: const Icon(Icons.chevron_right), onTap: onTap));
}
