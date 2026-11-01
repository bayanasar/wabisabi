import 'package:flutter/widgets.dart';
import 'wab_utils.dart';

/// Base for widgets whose iOS and Material forms are genuinely different
/// widgets — a [CupertinoPageScaffold] against a [Scaffold], say.
///
/// Subclasses may narrow the return type, so a `WabScaffold` can still promise
/// a `Scaffold` to a caller that wants one.
///
/// If both branches would build the same thing, this is the wrong base class:
/// extend `StatelessWidget` and write one `build`.
///
/// Deliberately not on the barrel. Consumers use the widgets, not the base; a
/// public abstract class with nothing to show for itself is surface for its
/// own sake.
abstract class WabWidget extends StatelessWidget {
  const WabWidget({super.key});

  @override
  Widget build(BuildContext context) => wabIsIos()
      ? createCupertinoWidget(context)
      : createMaterialWidget(context);

  Widget createCupertinoWidget(BuildContext context);
  Widget createMaterialWidget(BuildContext context);
}
