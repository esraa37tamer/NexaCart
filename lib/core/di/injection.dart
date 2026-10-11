import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/firebase_runtime_config.dart';
import '../network/dio_client.dart';
import '../navigation/app_navigation_controller.dart';
import '../storage/realm_database.dart';
import '../theme/theme_service.dart';
import '../theme/theme_service_impl.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/demo_auth_remote_data_source.dart';
import '../../features/auth/data/datasources/firebase_auth_remote_data_source.dart';
import '../../features/auth/data/datasources/session_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/use_cases/restore_session.dart';
import '../../features/auth/domain/use_cases/sign_in.dart';
import '../../features/auth/domain/use_cases/sign_in_with_facebook.dart';
import '../../features/auth/domain/use_cases/sign_in_with_google.dart';
import '../../features/auth/domain/use_cases/sign_out.dart';
import '../../features/auth/domain/use_cases/sign_up.dart';
import '../../features/cart/data/datasources/cart_local_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/favorites/data/datasources/favorites_local_data_source.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/orders/data/datasources/orders_local_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/use_cases/create_order.dart';
import '../../features/orders/domain/use_cases/get_orders.dart';
import '../../features/products/data/datasources/products_remote_data_source.dart';
import '../../features/products/data/repositories/products_repository_impl.dart';
import '../../features/products/domain/repositories/products_repository.dart';
import '../../features/products/domain/use_cases/get_categories.dart';
import '../../features/products/domain/use_cases/get_product.dart';
import '../../features/products/domain/use_cases/get_products.dart';
import '../../features/products/domain/use_cases/get_products_by_category.dart';
import '../../features/products/domain/use_cases/search_products.dart';

final getIt=GetIt.instance;
class BootstrapResult { const BootstrapResult({required this.firebaseReady}); final bool firebaseReady; }
Future<BootstrapResult> configureDependencies() async {
  getIt.registerSingleton(AppNavigationController());
  final db=RealmDatabase(); getIt.registerSingleton(db);
  final preferences=SharedPreferencesAsync(); getIt.registerSingleton(preferences);
  getIt.registerLazySingleton<ThemeService>(()=>ThemeServiceImpl(getIt()));
  getIt.registerSingleton(DioClient()); getIt.registerSingleton(getIt<DioClient>().dio);
  bool firebaseReady=false;
  try {
    final options=FirebaseRuntimeConfig.options;
    if(options!=null){await Firebase.initializeApp(options:options);firebaseReady=true;}
    else {try{await Firebase.initializeApp();firebaseReady=true;}catch(_){firebaseReady=false;}}
  } catch (_) { firebaseReady=false; }
  final AuthRemoteDataSource authRemote=firebaseReady?FirebaseAuthRemoteDataSource(FirebaseAuth.instance):DemoAuthRemoteDataSource();
  getIt.registerSingleton<AuthRemoteDataSource>(authRemote);
  getIt.registerLazySingleton(()=>SessionLocalDataSource(db.sessionRealm));
  getIt.registerLazySingleton<AuthRepository>(()=>AuthRepositoryImpl(getIt(),getIt()));
  getIt.registerLazySingleton(()=>SignIn(getIt())); getIt.registerLazySingleton(()=>SignInWithGoogle(getIt())); getIt.registerLazySingleton(()=>SignInWithFacebook(getIt())); getIt.registerLazySingleton(()=>SignUp(getIt())); getIt.registerLazySingleton(()=>SignOut(getIt())); getIt.registerLazySingleton(()=>RestoreSession(getIt()));
  getIt.registerLazySingleton(()=>ProductsRemoteDataSource(getIt())); getIt.registerLazySingleton<ProductsRepository>(()=>ProductsRepositoryImpl(getIt()));
  getIt.registerLazySingleton(()=>GetProducts(getIt())); getIt.registerLazySingleton(()=>SearchProducts(getIt())); getIt.registerLazySingleton(()=>GetCategories(getIt())); getIt.registerLazySingleton(()=>GetProductsByCategory(getIt())); getIt.registerLazySingleton(()=>GetProduct(getIt()));
  getIt.registerLazySingleton(()=>CartLocalDataSource(db)); getIt.registerLazySingleton<CartRepository>(()=>CartRepositoryImpl(getIt()));
  getIt.registerLazySingleton(()=>OrdersLocalDataSource(db)); getIt.registerLazySingleton<OrdersRepository>(()=>OrdersRepositoryImpl(getIt())); getIt.registerLazySingleton(()=>GetOrders(getIt())); getIt.registerLazySingleton(()=>CreateOrder(getIt()));
  getIt.registerLazySingleton(()=>FavoritesLocalDataSource(getIt())); getIt.registerLazySingleton<FavoritesRepository>(()=>FavoritesRepositoryImpl(getIt()));
  return BootstrapResult(firebaseReady:firebaseReady);
}
