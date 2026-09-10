import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../main.dart';
import '../../../model/widget_model.dart';
import '../../../utils/AppConstant.dart';
import '../../../utils/AppWidget.dart';

class MobileTreeSheet extends StatefulWidget {
  final VoidCallback onClose;
  const MobileTreeSheet({super.key, required this.onClose});

  @override
  State<MobileTreeSheet> createState() => _MobileTreeSheetState();
}

class _MobileTreeSheetState extends State<MobileTreeSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 8),
                IconButton(onPressed: widget.onClose, icon: const Icon(Icons.close)),
                const Expanded(child: Text('Layers', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: TextField(
                onChanged: (value) => setState(() => _query = value.toLowerCase()),
                decoration: const InputDecoration(prefixIcon: Icon(Icons.search), hintText: 'Search layers', border: OutlineInputBorder()),
              ),
            ),
            Expanded(child: Observer(builder: (_) => ListView(children: _buildTree(appStore.selectedWidgetList)))),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTree(List<WidgetModel> nodes, {int depth = 0}) {
    final result = <Widget>[];
    for (final node in nodes) {
      final title = getWidgetTitle(node.widgetSubType);
      final matches = _query.isEmpty || title.toLowerCase().contains(_query) || (node.id ?? '').toLowerCase().contains(_query);
      final descendants = node.subWidgetsList == null ? <WidgetModel>[] : node.subWidgetsList!.whereType<WidgetModel>().toList();
      final descendantWidgets = descendants.isEmpty ? <Widget>[] : _buildTree(descendants, depth: depth + 1);
      if (matches || descendantWidgets.isNotEmpty) {
        final selected = appStore.currentSelectedWidget?.id == node.id;
        result.add(
          InkWell(
            onTap: () {
              appStore.updateSelectedWidget(node);
              widget.onClose();
            },
            child: Container(
              height: 44,
              padding: EdgeInsets.only(left: 14.0 + depth * 18.0, right: 8),
              decoration: BoxDecoration(color: selected ? Theme.of(context).colorScheme.primaryContainer : null),
              child: Row(
                children: [
                  Icon(node.subWidgetsList?.isNotEmpty == true ? Icons.expand_more : Icons.circle, size: node.subWidgetsList?.isNotEmpty == true ? 18 : 7),
                  const SizedBox(width: 8),
                  Expanded(child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Text('#${(node.id ?? '').toString().substring((node.id ?? '').length > 4 ? (node.id ?? '').length - 4 : 0)}', style: TextStyle(fontSize: 10, color: Theme.of(context).hintColor)),
                ],
              ),
            ),
          ),
        );
        result.addAll(descendantWidgets);
      }
    }
    return result;
  }
}
