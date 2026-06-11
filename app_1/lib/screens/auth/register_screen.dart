import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'role_selection_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  String _campus = 'Kigali Campus';
  final List<String> _campuses = ['Kigali Campus', 'Mauritius Campus'];

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose(); super.dispose(); }

  void _next() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => RoleSelectionScreen(
      fullName: _nameCtrl.text.trim(), email: _emailCtrl.text.trim(),
      password: _passCtrl.text, campus: _campus,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Create Account'),
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context))),
      body: SafeArea(child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 24),
          _StepBar(current: 0),
          const SizedBox(height: 28),
          const Text('Your account details', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Use your official ALU email to register.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 28),
          Consumer<ProfileProvider>(builder: (_, p, __) => p.error != null
              ? Padding(padding: const EdgeInsets.only(bottom: 16), child: ErrorBanner(message: p.error!))
              : const SizedBox.shrink()),
          AuthTextField(
            label: 'Full Name', hint: 'e.g. Keza Uwase', controller: _nameCtrl,
            prefixIcon: const Icon(Icons.person_outline, color: AppColors.textMuted, size: 20),
            validator: (v) {
              if (v == null || v.trim().isEmpty) return 'Name is required';
              if (v.trim().split(' ').length < 2) return 'Enter first and last name';
              return null;
            }),
          const SizedBox(height: 18),
          AuthTextField(
            label: 'ALU Email', hint: 'yourname@alustudent.com',
            controller: _emailCtrl, keyboardType: TextInputType.emailAddress,
            prefixIcon: const Icon(Icons.mail_outline, color: AppColors.textMuted, size: 20),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Email is required';
              if (!v.endsWith('@alustudent.com') && !v.endsWith('@alusb.com'))
                return 'Must be an @alustudent.com or @alusb.com address';
              return null;
            }),
          const SizedBox(height: 18),
          const Text('Campus', style: TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: _campus, dropdownColor: AppColors.surface,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.textMuted, size: 20)),
            items: _campuses.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
            onChanged: (v) => setState(() => _campus = v!),
          ),
          const SizedBox(height: 18),
          AuthTextField(
            label: 'Password', hint: 'At least 8 characters',
            controller: _passCtrl, isPassword: true,
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Password is required';
              if (v.length < 8) return 'At least 8 characters';
              return null;
            }),
          const SizedBox(height: 18),
          AuthTextField(
            label: 'Confirm Password', hint: 'Re-enter your password',
            controller: _confirmCtrl, isPassword: true,
            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted, size: 20),
            validator: (v) { if (v != _passCtrl.text) return 'Passwords do not match'; return null; }),
          const SizedBox(height: 32),
          PrimaryButton(label: 'Continue — Choose Your Role', onPressed: _next),
          const SizedBox(height: 20),
          Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            GestureDetector(onTap: () => Navigator.pop(context),
                child: const Text('Sign In', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600))),
          ])),
          const SizedBox(height: 24),
        ])),
      )),
    );
  }
}

class _StepBar extends StatelessWidget {
  final int current;
  const _StepBar({required this.current});
  @override
  Widget build(BuildContext context) {
    return Row(children: List.generate(2, (i) => Expanded(
      child: Container(
        margin: EdgeInsets.only(right: i < 1 ? 6 : 0), height: 4,
        decoration: BoxDecoration(
          color: i <= current ? AppColors.primary : AppColors.divider,
          borderRadius: BorderRadius.circular(2)),
      ),
    )));
  }
}
