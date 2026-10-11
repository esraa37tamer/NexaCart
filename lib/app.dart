import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection.dart';
import 'core/navigation/app_route_parser.dart';
import 'core/navigation/app_router_delegate.dart';
import 'core/navigation/app_navigation_controller.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/theme/theme_service.dart';
import 'features/auth/domain/use_cases/restore_session.dart';
import 'features/auth/domain/use_cases/sign_in.dart';
import 'features/auth/domain/use_cases/sign_in_with_facebook.dart';
import 'features/auth/domain/use_cases/sign_in_with_google.dart';
import 'features/auth/domain/use_cases/sign_out.dart';
import 'features/auth/domain/use_cases/sign_up.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cart/domain/repositories/cart_repository.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/favorites/domain/repositories/favorites_repository.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';
import 'features/orders/domain/use_cases/create_order.dart';

class NexaCartApp extends StatefulWidget {const NexaCartApp({super.key});@override State<NexaCartApp> createState()=>_NexaCartAppState();}
class _NexaCartAppState extends State<NexaCartApp>{
 late final AppRouterDelegate delegate;
 @override void initState(){super.initState();delegate=AppRouterDelegate(getIt<AppNavigationController>());}
 @override Widget build(BuildContext context)=>MultiBlocProvider(
  providers:[
   BlocProvider(create:(_)=>AuthCubit(getIt<SignIn>(),getIt<SignInWithGoogle>(),getIt<SignInWithFacebook>(),getIt<SignUp>(),getIt<SignOut>(),getIt<RestoreSession>())),
   BlocProvider(create:(_)=>CartCubit(getIt<CartRepository>(),getIt<CreateOrder>())),
   BlocProvider(create:(_)=>FavoritesCubit(getIt<FavoritesRepository>())),
   BlocProvider(create:(_)=>ThemeCubit(getIt<ThemeService>())..load()),
  ],
  child:BlocBuilder<ThemeCubit,ThemeMode>(builder:(context,mode)=>MaterialApp.router(
   debugShowCheckedModeBanner:false,title:'NexaCart',theme:AppTheme.light(),darkTheme:AppTheme.dark(),themeMode:mode,routerDelegate:delegate,routeInformationParser:const AppRouteParser(),
  )),
 );
}
