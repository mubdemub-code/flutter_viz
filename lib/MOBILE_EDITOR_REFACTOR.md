# FlutterViz — Mobile Editor Refactor

Cette archive transforme le mode mobile de FlutterViz en véritable shell d'édition tactile, au lieu de l'écran `Desktop Only`.

## Ce qui est déjà refondu

### Shell mobile
- `screen/mobile_view_screen.dart` devient un point d'entrée de compatibilité vers `MobileEditorScreen`.
- `editor/ui/mobile/mobile_editor_screen.dart` fournit le shell mobile : top bar, rail d'outils, canvas, palette, inspecteur, focus mode et actions secondaires.
- `editor/ui/mobile/mobile_tool_rail.dart` remplace le menu desktop permanent par un rail compact.
- `editor/ui/mobile/mobile_widget_picker.dart` ajoute recherche, sections et ajout par tap/long-press.
- `editor/ui/mobile/mobile_inspector_sheet.dart` transforme l'inspecteur en `DraggableScrollableSheet` multi-hauteurs avec actions rapides et réutilisation directe de `SelectedWidgetProperty` (le panneau desktop complet n'est plus embarqué).
- `editor/ui/mobile/mobile_tree_sheet.dart` fournit une vue Layers tactile et synchronisée avec `AppStore.currentSelectedWidget`.
- `editor/state/editor_ui_controller.dart` isole l'état d'interface mobile du document métier.

### Canvas
- `components/centerView/center_body_component.dart` accepte maintenant `mobileMode`.
- Le canvas mobile s'adapte aux contraintes disponibles, calcule un zoom de départ et utilise `InteractiveViewer` pour pan/pinch.
- Les contrôles de zoom mobiles sont compacts et le canvas ne force plus la sélection du root à chaque tap.
- La taille globale du device est synchronisée avec `selectedDeviceScreenSize` au démarrage.
- Un sélecteur rapide de device est disponible dans la top bar mobile.

### Portabilité Web / Android / iOS
Les imports Web ne sont plus exposés directement au code partagé :
- `utils/platform/platform_bootstrap.dart`
- `utils/platform/download_service.dart`
- `utils/platform/platform_bootstrap_web.dart`
- `utils/platform/platform_bootstrap_stub.dart`
- `utils/platform/download_service_web.dart`
- `utils/platform/download_service_stub.dart`

Même principe pour Google Maps :
- `widgetsClass/google_map_class.dart`
- `widgetsClass/platform/google_map_platform.dart`
- `widgetsClass/platform/google_map_platform_web.dart`
- `widgetsClass/platform/google_map_platform_stub.dart`

Ainsi `dart:html`, `package:web` et le renderer Google Maps Web sont confinés aux implémentations Web.

### Génération / téléchargement de code
`HeaderComponent`, `CodeViewHeaderComponent` et `PubSpecFileDetails` passent maintenant par le service de téléchargement abstrait. Sur mobile, le service tente un sélecteur de fichier puis retombe sur le presse-papiers en cas d'échec.

## Architecture cible

```text
FlutterViz
  │
  ├─ Editor Core existant (AppStore + widget classes + property views + JSON)
  │
  └─ Editor Shells
       ├─ Desktop shell existant
       ├─ Tablet shell à converger progressivement
       └─ Mobile shell (nouveau)
            ├─ Tool rail
            ├─ Canvas viewport
            ├─ Widget picker
            ├─ Layers sheet
            ├─ Inspector sheet
            └─ Actions / preview / code
```

Le travail garde volontairement `AppStore` et le moteur de génération existants comme source de vérité afin de ne pas créer un deuxième moteur métier mobile.

## Actions tactiles couvertes

- Tap widget → sélection.
- Tap widget dans la palette → ajout.
- Long press palette → même chemin d'ajout rapide, prêt à évoluer vers drag tactile plus précis.
- Pinch / pan sur le canvas.
- Undo / redo depuis la top bar.
- Actions `Duplicate`, `Move up`, `Move down`, `Delete` depuis l'inspecteur.
- Layers → sélection directe d'un nœud.
- Focus mode → canvas quasi plein écran.
- Sélection d'appareil → changement de viewport.

## Ce qui n'a volontairement pas été réécrit dans cette passe

Le refactor ne réécrit pas le moteur métier complet. Les parties suivantes restent candidates à une phase 2 :

1. Remplacer les snapshots d'Undo/Redo par un vrai système de commandes (`Add`, `Delete`, `Move`, `UpdateProperty`, `Wrap`, `Duplicate`).
2. Découper `AppStore` en stores spécialisés (`ProjectStore`, `EditorStore`, `SelectionStore`, `HistoryStore`, etc.).
3. Extraire un modèle documentaire indépendant de `WidgetModel.displayWidget` / `widgetViewModel`.
4. Extraire `RightScreenComponent` en sections de propriétés réutilisables dans le bottom sheet mobile, au lieu d'embarquer tout le panneau desktop.
5. Remplacer progressivement les menus contextuels droit-clic par des actions tactiles unifiées.
6. Ajouter une persistance locale offline/draft et un autosave debounce plutôt qu'un timer fixe de 30 s.

## Point d'attention pour l'intégration

L'archive fournie à l'origine ne contenait pas de `pubspec.yaml`. Le code a donc été refactoré statiquement sans exécution d'un `flutter analyze` ou d'un build complet sur cette archive. Il faut lancer `flutter pub get` puis `flutter analyze` dans le vrai projet et corriger les éventuelles différences de versions de plugins/API.

## Fichiers historiques supprimés

Les copies `.bak` présentes dans l'archive ont été retirées du résultat final afin d'éviter la coexistence de plusieurs versions du même écran/composant.
