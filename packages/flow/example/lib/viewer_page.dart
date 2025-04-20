import 'package:flutter/material.dart';
import 'package:viewer/viewer.dart';

import 'router.dart';

/// Страница с Viewer для отображения точек и линий
class ViewerPage extends StatelessWidget {
  final Viewer _viewer;

  const ViewerPage(this._viewer, {super.key});

  @override
  Widget build(BuildContext context) {
    final delegate = Router.of(context).routerDelegate as MyRouterDelegate;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Viewer'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => delegate.goToHome(),
        ),
      ),
      body: Column(children: [Expanded(child: _viewer.buildWidget())]),
    );
  }
}
