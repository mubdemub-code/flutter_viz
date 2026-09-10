import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../main.dart';
import '../../../utils/AppConstant.dart';
import '../../../widgetsProperty/comman_property_view.dart';
import '../../../components/rightView/selected_widget_property.dart';

class MobileInspectorSheet extends StatefulWidget {
  final VoidCallback onClose;

  const MobileInspectorSheet({super.key, required this.onClose});

  @override
  State<MobileInspectorSheet> createState() => _MobileInspectorSheetState();
}

class _MobileInspectorSheetState extends State<MobileInspectorSheet> {
  final DraggableScrollableController _controller = DraggableScrollableController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        final selected = appStore.currentSelectedWidget;
        if (selected == null) return const SizedBox.shrink();

        return DraggableScrollableSheet(
          controller: _controller,
          initialChildSize: 0.16,
          minChildSize: 0.09,
          maxChildSize: 0.84,
          snap: true,
          snapSizes: const [0.16, 0.48, 0.84],
          builder: (context, scrollController) {
            return Material(
              elevation: 18,
              color: Theme.of(context).colorScheme.surface,
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Column(
                children: [
                  const SizedBox(height: 7),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(color: Theme.of(context).dividerColor, borderRadius: BorderRadius.circular(99)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            getWidgetTitle(selected.widgetSubType),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          tooltip: 'More actions',
                          onPressed: () => _showActions(context),
                          icon: const Icon(Icons.more_horiz),
                        ),
                        IconButton(
                          tooltip: 'Close inspector',
                          onPressed: widget.onClose,
                          icon: const Icon(Icons.keyboard_arrow_down),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 32,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: const [
                        _InspectorTab('Basic'),
                        _InspectorTab('Layout'),
                        _InspectorTab('Style'),
                        _InspectorTab('Event'),
                        _InspectorTab('Advanced'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: PrimaryScrollController(
                      controller: scrollController,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: const EdgeInsets.only(bottom: 24),
                        child: SelectedWidgetProperty(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showActions(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final selected = appStore.currentSelectedWidget;
        if (selected == null) return const SizedBox.shrink();
        return SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(leading: const Icon(Icons.copy), title: const Text('Duplicate'), onTap: () { appStore.copyWidget(); Navigator.pop(context); }),
              ListTile(leading: const Icon(Icons.keyboard_arrow_up), title: const Text('Move up'), onTap: () { appStore.moveWidget(isMoveUpOperation: true); Navigator.pop(context); }),
              ListTile(leading: const Icon(Icons.keyboard_arrow_down), title: const Text('Move down'), onTap: () { appStore.moveWidget(isMoveUpOperation: false); Navigator.pop(context); }),
              if (selected.widgetSubType != WidgetTypeRootView)
                ListTile(
                  leading: const Icon(Icons.delete_outline),
                  title: const Text('Delete'),
                  onTap: () {
                    appStore.removeSelectedWidget();
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _InspectorTab extends StatelessWidget {
  final String label;
  const _InspectorTab(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(label: Text(label, style: const TextStyle(fontSize: 11)), visualDensity: VisualDensity.compact),
    );
  }
}
