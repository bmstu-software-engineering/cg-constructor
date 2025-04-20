import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:viewer/viewer.dart';

import 'viewer_page.dart';
import 'home_page.dart';
import 'models/route_state.dart';

/// Парсер информации о маршруте для Navigator 2.0
class MyRouteInformationParser extends RouteInformationParser<RouteState> {
  @override
  Future<RouteState> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.uri.toString());

    // Обработка пути к Viewer
    // Примечание: в реальном приложении параметры точек и линий
    // должны передаваться через URL или состояние приложения
    if (uri.path == '/viewer') {
      throw UnimplementedError(
        'Не поддерживается запуск через путь. Передайте контроллер.',
      );
    }

    // По умолчанию возвращаем домашнюю страницу
    return const RouteState.home();
  }

  @override
  RouteInformation? restoreRouteInformation(RouteState configuration) {
    return configuration.map(
      home: (_) => RouteInformation(uri: Uri.parse('/')),
      viewer: (_) => RouteInformation(uri: Uri.parse('/viewer')),
    );
  }
}

/// Делегат маршрутизатора для Navigator 2.0 с использованием BehaviorSubject
class MyRouterDelegate extends RouterDelegate<RouteState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<RouteState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // Используем BehaviorSubject для хранения состояния маршрута
  final BehaviorSubject<RouteState> _routeSubject;
  StreamSubscription<RouteState>? _routeSubscription;

  MyRouterDelegate()
    : navigatorKey = GlobalKey<NavigatorState>(),
      _routeSubject = BehaviorSubject<RouteState>.seeded(
        const RouteState.home(),
      ) {
    // Подписываемся на изменения маршрута и уведомляем слушателей
    _routeSubscription = _routeSubject.listen((_) {
      notifyListeners();
    });
  }

  // Геттер для текущего состояния маршрута
  RouteState get currentRoute => _routeSubject.value;

  // Стрим для отслеживания изменений маршрута
  Stream<RouteState> get routeStream => _routeSubject.stream;

  // Методы для навигации
  void goToHome() => _routeSubject.add(const RouteState.home());

  void goToViewer(Viewer viewer) {
    _routeSubject.add(RouteState.viewer(viewer));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<RouteState>(
      stream: routeStream,
      initialData: currentRoute,
      builder: (context, snapshot) {
        final route = snapshot.data!;

        return Navigator(
          key: navigatorKey,
          pages: [
            // Домашняя страница всегда присутствует в стеке
            const MaterialPage(key: ValueKey('HomePage'), child: HomePage()),
            ...route.maybeMap(
              // Страница Viewer добавляется, если текущий путь - viewer
              viewer:
                  (params) => [
                    MaterialPage(
                      key: const ValueKey('ViewerPage'),
                      child: ViewerPage(params.viewer),
                    ),
                  ],
              orElse: () => [],
            ),
          ],
          onPopPage: (route, result) {
            if (!route.didPop(result)) {
              return false;
            }

            // Обработка возврата со страницы деталей или Viewer
            if (currentRoute is ViewerRoute) {
              goToHome();
            }

            return true;
          },
        );
      },
    );
  }

  @override
  Future<void> setNewRoutePath(RouteState configuration) async {
    _routeSubject.add(configuration);
  }

  @override
  void dispose() {
    _routeSubscription?.cancel();
    _routeSubject.close();
    super.dispose();
  }
}
