import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/navigation/app_navigation_controller.dart';
import '../../../../core/navigation/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_background.dart';
import '../../../../core/widgets/app_logo.dart';
import '../../../../core/widgets/gradient_button.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SignUpScreen extends StatefulWidget {const SignUpScreen({super.key});@override State<SignUpScreen> createState()=>_SignUpScreenState();}
class _SignUpScreenState extends State<SignUpScreen>{
 final _formKey=GlobalKey<FormState>();final _name=TextEditingController();final _email=TextEditingController();final _password=TextEditingController();final _confirm=TextEditingController();bool _obscure=true;bool _agree=false;
 @override void dispose(){_name.dispose();_email.dispose();_password.dispose();_confirm.dispose();super.dispose();}
 @override Widget build(BuildContext context){final colors=Theme.of(context).colorScheme;return Scaffold(body:AppBackground(child:SafeArea(child:SingleChildScrollView(padding:const EdgeInsets.fromLTRB(28,18,28,40),child:Form(key:_formKey,child:Column(children:[
  Row(children:[IconButton.filledTonal(onPressed:getIt<AppNavigationController>().pop,icon:const Icon(Icons.arrow_back)),const Spacer(),const AppLogo(size:82,showName:false),const Spacer(),const SizedBox(width:48)]),const SizedBox(height:10),Text('Create Account',style:TextStyle(fontSize:32,fontWeight:FontWeight.w900,color:colors.onSurface)),Text('Create your Firebase account, then sign in.',style:TextStyle(color:colors.onSurfaceVariant)),const SizedBox(height:22),
  TextFormField(controller:_name,validator:(v)=>(v==null||v.trim().length<2)?'Enter your full name':null,decoration:const InputDecoration(prefixIcon:Icon(Icons.person_outline),hintText:'Full Name')),const SizedBox(height:12),
  TextFormField(controller:_email,validator:Validators.email,keyboardType:TextInputType.emailAddress,decoration:const InputDecoration(prefixIcon:Icon(Icons.mail_outline),hintText:'Email Address')),const SizedBox(height:12),
  TextFormField(controller:_password,validator:Validators.password,obscureText:_obscure,decoration:InputDecoration(prefixIcon:const Icon(Icons.lock_outline),hintText:'Password',suffixIcon:IconButton(onPressed:()=>setState(()=>_obscure=!_obscure),icon:Icon(_obscure?Icons.visibility_off_outlined:Icons.visibility_outlined)))),const SizedBox(height:12),
  TextFormField(controller:_confirm,validator:(v)=>v!=_password.text?'Passwords do not match':null,obscureText:true,decoration:const InputDecoration(prefixIcon:Icon(Icons.lock_reset_outlined),hintText:'Confirm Password')),const SizedBox(height:8),
  Row(children:[Checkbox(value:_agree,onChanged:(v)=>setState(()=>_agree=v??false)),const Expanded(child:Text('I agree to the Terms of Service and Privacy Policy'))]),const SizedBox(height:12),
  BlocConsumer<AuthCubit,AuthState>(listener:(context,state){if(state.status==AuthStatus.registrationSuccess){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(state.message??'Account created')));getIt<AppNavigationController>().replaceAll(RouteNames.login);}else if(state.status==AuthStatus.failure&&state.message!=null){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text(state.message!)));}},builder:(context,state)=>GradientButton(label:'Create Account',loading:state.status==AuthStatus.loading,onPressed:()async{if(!_formKey.currentState!.validate())return;if(!_agree){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Please accept the terms first.')));return;}await context.read<AuthCubit>().signUp(_name.text.trim(),_email.text.trim(),_password.text);})),
  const SizedBox(height:16),
  Row(children:[const Expanded(child:Divider()),Padding(padding:const EdgeInsets.symmetric(horizontal:12),child:Text('OR',style:TextStyle(color:colors.onSurfaceVariant))),const Expanded(child:Divider())]),const SizedBox(height:12),
  Row(children:[
    Expanded(child:OutlinedButton.icon(onPressed:()async{if(!_agree){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Please accept the terms first.')));return;}final ok=await context.read<AuthCubit>().signInWithGoogle(rememberMe:true);if(ok&&context.mounted)getIt<AppNavigationController>().replaceAll(RouteNames.home);},icon:const Icon(Icons.g_mobiledata_rounded,size:28),label:const Text('Google'))),
    const SizedBox(width:12),
    Expanded(child:OutlinedButton.icon(onPressed:()async{if(!_agree){ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content:Text('Please accept the terms first.')));return;}final ok=await context.read<AuthCubit>().signInWithFacebook(rememberMe:true);if(ok&&context.mounted)getIt<AppNavigationController>().replaceAll(RouteNames.home);},icon:const Icon(Icons.facebook_rounded),label:const Text('Facebook'))),
  ]),
  const SizedBox(height:10),TextButton(onPressed:getIt<AppNavigationController>().pop,child:const Text('Already have an account? Sign In'))
 ]))))));}
}
