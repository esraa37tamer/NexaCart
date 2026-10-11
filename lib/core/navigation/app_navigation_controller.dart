import 'package:flutter/foundation.dart'; import 'route_names.dart';
class AppRouteEntry { const AppRouteEntry(this.name,{this.id}); final String name; final int? id; }
class AppNavigationController extends ChangeNotifier {
  final List<AppRouteEntry> _stack=[const AppRouteEntry(RouteNames.splash)];
  List<AppRouteEntry> get stack=>List.unmodifiable(_stack);
  void replaceAll(String name,{int? id}){_stack..clear()..add(AppRouteEntry(name,id:id));notifyListeners();}
  void push(String name,{int? id}){_stack.add(AppRouteEntry(name,id:id));notifyListeners();}
  bool pop(){if(_stack.length<=1)return false;_stack.removeLast();notifyListeners();return true;}
}
