import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'register_screen.dart';
import '../main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fade = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    _slide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() { _anim.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await context.read<ProfileProvider>().login(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok && mounted) {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const MainShell()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: FadeTransition(opacity: _fade,
            child: SlideTransition(position: _slide,
              child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SizedBox(height: 48),
                Center(child: Column(children: [
                  const AluLogoWidget(size: 64),
                  const SizedBox(height: 16),
                  const Text('ALUConnect', style: TextStyle(color: AppColors.textPrimary, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  const SizedBox(height: 6),
                  const Text('Welcome back. Sign in to your ALU account.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14), textAlign: TextAlign.center),
                ])),
                const SizedBox(height: 40),
                Consumer<ProfileProvider>(builder: (_, p, __) => p.error != null
                    ? Padding(padding: const EdgeInsets.only(bottom: 16), child: ErrorBanner(message: p.error!))
                    : const SizedBox.shrink()),
                AuthTextField(
                  label: 'Student Email', hint: 'yourname@alustudent.com',
                  controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textMuted, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email is required';
                    if (!v.contains('@')) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                AuthTextField(
                  label: 'Password', hint: 'Enter your password',
                  controller: _passCtrl, isPassword: true,
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password is required';
                    if (v.length < 6) return 'At least 6 characters';
                    return null;
                  },
                ),
                Align(alignment: Alignment.centerRight,
                  child: TextButton(onPressed: () {},
                    child: const Text('Forgot password?', style: TextStyle(color: AppColors.primary, fontSize: 13)))),
                const SizedBox(height: 8),
                Consumer<ProfileProvider>(builder: (_, p, __) =>
                    PrimaryButton(label: 'Sign In', onPressed: _submit, isLoading: p.isLoading)),
                const SizedBox(height: 20),
                Row(children: [
                  Expanded(child: Divider(color: AppColors.divider, height: 1)),
                  Padding(padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: TextStyle(color: AppColors.textMuted, fontSize: 13))),
                  Expanded(child: Divider(color: AppColors.divider, height: 1)),
                ]),
                const SizedBox(height: 20),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Container(width: 20, height: 20,
                    decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(4)),
                    child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)))),
                  label: const Text('Sign in with your ALU Account', style: TextStyle(color: AppColors.textPrimary)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.divider),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                const SizedBox(height: 32),
                Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text("Don't have an account? ", style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
                  GestureDetector(
                    onTap: () { context.read<ProfileProvider>().clearError(); Navigator.of(context).push(MaterialPageRoute(builder: (_) => const RegisterScreen())); },
                    child: const Text('Register', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600))),
                ])),
                const SizedBox(height: 24),
                Center(child: Text('© African Leadership University. All rights reserved.', style: TextStyle(color: AppColors.textMuted, fontSize: 11), textAlign: TextAlign.center)),
                const SizedBox(height: 16),
              ])),
            ),
          ),
        ),
      ),
    );
  }
}
