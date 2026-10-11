import 'package:flutter/widgets.dart';

import 'app_navigation_controller.dart';
import 'route_names.dart';

class AppRouteParser extends RouteInformationParser<List<AppRouteEntry>> {
  const AppRouteParser();

  @override
  Future<List<AppRouteEntry>> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    final stack = <AppRouteEntry>[];

    if (uri.pathSegments.isEmpty) {
      return [const AppRouteEntry(RouteNames.splash)];
    }

    switch (uri.pathSegments.first) {
      case 'login':
        stack.add(const AppRouteEntry(RouteNames.login));
        break;
      case 'signup':
        stack.add(const AppRouteEntry(RouteNames.signup));
        break;
      case 'home':
        stack.add(const AppRouteEntry(RouteNames.home));
        break;
      case 'cart':
        stack.addAll([
          const AppRouteEntry(RouteNames.home),
          const AppRouteEntry(RouteNames.cart),
        ]);
        break;
      case 'history':
        stack.addAll([const AppRouteEntry(RouteNames.home), const AppRouteEntry(RouteNames.history)]);
        break;
      case 'favorites':
        stack.addAll([const AppRouteEntry(RouteNames.home), const AppRouteEntry(RouteNames.favorites)]);
        break;
      case 'details':
        final id = int.tryParse(
          uri.pathSegments.length > 1 ? uri.pathSegments[1] : '',
        );
        stack.addAll([
          const AppRouteEntry(RouteNames.home),
          AppRouteEntry(RouteNames.details, id: id),
        ]);
        break;
      default:
        stack.add(const AppRouteEntry(RouteNames.login));
    }

    return stack;
  }

  @override
  RouteInformation? restoreRouteInformation(
    List<AppRouteEntry> configuration,
  ) {
    final last = configuration.last;
    final path = last.name == RouteNames.details
        ? '${RouteNames.details}/${last.id}'
        : last.name;
    return RouteInformation(uri: Uri.parse(path));
  }
}
