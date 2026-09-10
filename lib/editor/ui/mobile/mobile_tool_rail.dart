import 'package:flutter/material.dart';

import '../../state/editor_ui_controller.dart';

class MobileToolRail extends StatelessWidget {
  final EditorUiController controller;

  const MobileToolRail({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final items = <_RailItem>[
      const _RailItem(Icons.widgets_outlined, 'Widgets', MobileEditorPanel.widgets),
      const _RailItem(Icons.account_tree_outlined, 'Layers', MobileEditorPanel.tree),
      const _RailItem(Icons.phone_android_outlined, 'Screens', MobileEditorPanel.screens),
      const _RailItem(Icons.view_quilt_outlined, 'Components', MobileEditorPanel.components),
      const _RailItem(Icons.perm_media_outlined, 'Media', MobileEditorPanel.media),
    ];

    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      elevation: 8,
      child: SafeArea(
        top: false,
        right: false,
        bottom: false,
        child: SizedBox(
          width: 56,
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              _RailButton(
                icon: Icons.add_box_outlined,
                label: 'Add',
                selected: controller.activePanel == MobileEditorPanel.widgets && controller.paletteOpen,
                onTap: controller.togglePalette,
              ),
              const SizedBox(height: 8),
              ...items.skip(1).map((item) => _RailButton(
                    icon: item.icon,
                    label: item.label,
                    selected: controller.activePanel == item.panel && (item.panel != MobileEditorPanel.media || controller.activePanel == MobileEditorPanel.media),
                    onTap: () => controller.selectPanel(item.panel),
                  )),
              const SizedBox(height: 8),
              const Divider(height: 1, indent: 10, endIndent: 10),
              const SizedBox(height: 8),
              _RailButton(
                icon: controller.focusMode ? Icons.fullscreen_exit : Icons.fullscreen,
                label: 'Focus',
                onTap: controller.toggleFocusMode,
              ),
              _RailButton(
                icon: Icons.more_horiz,
                label: 'More',
                selected: controller.activePanel == MobileEditorPanel.more,
                onTap: () => controller.selectPanel(MobileEditorPanel.more),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RailItem {
  final IconData icon;
  final String label;
  final MobileEditorPanel panel;
  const _RailItem(this.icon, this.label, this.panel);
}

class _RailButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RailButton({required this.icon, required this.label, this.selected = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Tooltip(
      message: label,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 48,
          margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: selected ? colorScheme.primaryContainer : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: selected ? colorScheme.primary : colorScheme.onSurfaceVariant, size: 22),
        ),
      ),
    );
  }
}
