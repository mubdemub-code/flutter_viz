import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../main.dart';
import '../../../model/widget_model.dart';
import '../../../utils/AppColors.dart';
import '../../../utils/AppConstant.dart';
import '../../../utils/AppWidget.dart';
import '../../../widgets/widgets.dart';

class MobileWidgetPicker extends StatefulWidget {
  final ScrollController? controller;
  final VoidCallback? onAdded;

  const MobileWidgetPicker({super.key, this.controller, this.onAdded});

  @override
  State<MobileWidgetPicker> createState() => _MobileWidgetPickerState();
}

class _MobileWidgetPickerState extends State<MobileWidgetPicker> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<WidgetModel> _filter(List<WidgetModel> source) {
    if (_query.trim().isEmpty) return source;
    final q = _query.trim().toLowerCase();
    return source.where((item) => (item.title ?? getWidgetTitle(item.widgetSubType)).toLowerCase().contains(q)).toList();
  }

  void _add(WidgetModel template) {
    // Never insert the palette template itself. A fresh model prevents shared ids and state.
    appStore.addChildWidget(appStore.createCopyOfWidgets(getWidgets(template.widgetSubType)));
    widget.onAdded?.call();
  }

  Widget _section(String title, List<WidgetModel> source) {
    final items = _filter(source);
    if (items.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(title, style: boldTextStyle(size: 13, color: appStore.isDarkMode ? darkModeHighLightColor : btnBackgroundColor)),
          ),
          GridView.builder(
            controller: null,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return _WidgetCard(item: item, onTap: () => _add(item));
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search widgets',
                suffixIcon: _query.isEmpty ? null : IconButton(icon: const Icon(Icons.clear), onPressed: () {
                  _searchController.clear();
                  setState(() => _query = '');
                }),
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              controller: widget.controller,
              padding: EdgeInsets.zero,
              children: [
                if (_query.isEmpty)
                  _section('Recent', [
                    if (baseWidgetsList.isNotEmpty) baseWidgetsList.first,
                    if (baseWidgetsList.length > 1) baseWidgetsList[1],
                    if (layoutWidgetsList.isNotEmpty) layoutWidgetsList.first,
                  ].whereType<WidgetModel>().toList()),
                _section(language?.layoutWidget ?? 'Layout', layoutWidgetsList),
                _section(language?.baseWidget ?? 'Basic', baseWidgetsList),
                _section(language?.pageWidget ?? 'Page', pageWidgetsList),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WidgetCard extends StatelessWidget {
  final WidgetModel item;
  final VoidCallback onTap;

  const _WidgetCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        onLongPress: onTap,
        child: Padding(
          padding: const EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: SvgPicture.asset(getWidgetsIcon(item.widgetSubType), width: 34, height: 34),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.title ?? getWidgetTitle(item.widgetSubType),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
