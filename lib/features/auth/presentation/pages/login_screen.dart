import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_navigation_controller.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginScreen extends StatefulWidget { const LoginScreen({super.key}); @override State<LoginScreen> createState()=>_LoginScreenState(); }
class _LoginScreenState extends State<LoginScreen> {
  final _formKey=GlobalKey<FormState>(); final _email=TextEditingController(); final _password=TextEditingController(); bool _obscure=true; bool _rememberMe=false;
  @override void dispose(){_email.dispose();_password.dispose();super.dispose();}
  Future<void> _afterSocial(Future<bool> future) async { final ok=await future; if(ok&&mounted)getIt<AppNavigationController>().replaceAll(RouteNames.home); }
  @override Widget build(BuildContext context){final colors=Theme.of(context).colorScheme;return Scaffold(body:AppBackground(child:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.fromLTRB(28,20,28,40),child:Form(key:_formKey,child:Column(children:[
    Align(alignment:Alignment.centerRight,child:IconButton.filledTonal(tooltip:'Toggle theme',onPressed:()=>context.read<ThemeCubit>().toggle(),icon:Icon(Theme.of(context).brightness==Brightness.dark?Icons.light_mode_rounded:Icons.dark_mode_rounded))),
    const AppLogo(size:104),const SizedBox(height:18),Text('Welcome Back',style:TextStyle(fontSize:34,fontWeight:FontWeight.w900,color:colors.onSurface)),const SizedBox(height:4),Text('Sign in to continue',style:TextStyle(letterSpacing:4,color:colors.onSurfaceVariant)),const SizedBox(height:26),
    TextFormField(controller:_email,validator:Validators.email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(prefixIcon:Icon(Icons.mail_outline_rounded),hintText:'Email')),
    const SizedBox(height:14),TextFormField(controller:_password,validator:Validators.password,obscureText:_obscure,decoration:InputDecoration(prefixIcon:const Icon(Icons.lock_outline_rounded),hintText:'Password',suffixIcon:IconButton(onPressed:()=>setState(()=>_obscure=!_obscure),icon:Icon(_obscure?Icons.visibility_off_outlined:Icons.visibility_outlined)))),
    const SizedBox(height:8),Row(children:[Checkbox(value:_rememberMe,onChanged:(v)=>setState(()=>_rememberMe=v??false)),const Text('Remember Me'),const Spacer(),Text('Keeps you signed in',style:TextStyle(fontSize:12,color:colors.onSurfaceVariant))]),
    const SizedBox(height:14),BlocConsumer<AuthCubit,AuthState>(listener:(context,state){if(state.status==AuthStatus.failure&&state.message!=null)ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(state.message!)));},builder:(context,state)=>GradientButton(label:'Sign In',loading:state.status==AuthStatus.loading,onPressed:()async{if(!_formKey.currentState!.validate())return;final ok=await context.read<AuthCubit>().signIn(_email.text.trim(),_password.text,rememberMe:_rememberMe);if(ok&&context.mounted)getIt<AppNavigationController>().replaceAll(RouteNames.home);})),
    const SizedBox(height:18),Row(children:[const Expanded(child:Divider()),Padding(padding:const EdgeInsets.symmetric(horizontal:12),child:Text('OR',style:TextStyle(color:colors.onSurfaceVariant))),const Expanded(child:Divider())]),const SizedBox(height:14),
    Row(children:[Expanded(child:OutlinedButton.icon(onPressed:()=>_afterSocial(context.read<AuthCubit>().signInWithGoogle(rememberMe:_rememberMe)),icon:const Icon(Icons.g_mobiledata_rounded,size:28),label:const Text('Google'))),const SizedBox(width:12),Expanded(child:OutlinedButton.icon(onPressed:()=>_afterSocial(context.read<AuthCubit>().signInWithFacebook(rememberMe:_rememberMe)),icon:const Icon(Icons.facebook_rounded),label:const Text('Facebook')))]),
    const SizedBox(height:14),OutlinedButton.icon(style:OutlinedButton.styleFrom(minimumSize:const Size.fromHeight(56),shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(22))),onPressed:()=>getIt<AppNavigationController>().push(RouteNames.signup),icon:const Icon(Icons.person_add_alt_1_rounded),label:const Text('Create Account')),
  ]))))));}
}
