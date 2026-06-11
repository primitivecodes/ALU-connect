import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  const PrimaryButton({super.key, required this.label, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(width: 20, height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.textPrimary))
            : Text(label),
      ),
    );
  }
}

class AuthTextField extends StatefulWidget {
  final String label, hint;
  final TextEditingController controller;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;

  const AuthTextField({
    super.key, required this.label, required this.hint,
    required this.controller, this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.validator, this.prefixIcon,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool _obscure = true;
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(widget.label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w500)),
      const SizedBox(height: 6),
      TextFormField(
        controller: widget.controller,
        obscureText: widget.isPassword && _obscure,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: AppColors.textMuted, size: 20),
                  onPressed: () => setState(() => _obscure = !_obscure))
              : null,
        ),
      ),
    ]);
  }
}

class AluLogoWidget extends StatelessWidget {
  final double size;
  const AluLogoWidget({super.key, this.size = 56});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(14)),
      child: Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: size * 0.5, fontWeight: FontWeight.bold))),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  const ErrorBanner({super.key, required this.message});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.error.withOpacity(0.4)),
      ),
      child: Row(children: [
        const Icon(Icons.error_outline, color: AppColors.error, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(message, style: const TextStyle(color: AppColors.error, fontSize: 13))),
      ]),
    );
  }
}

class InterestChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const InterestChip({super.key, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(label, style: TextStyle(
          color: selected ? Colors.white : AppColors.textSecondary,
          fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }
}

class UserAvatar extends StatelessWidget {
  final String initials;
  final double radius;
  final String? imageUrl;
  final Color? bgColor;
  const UserAvatar({super.key, required this.initials, this.radius = 28, this.imageUrl, this.bgColor});
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: bgColor ?? AppColors.primary,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(initials, style: TextStyle(color: Colors.white, fontSize: radius * 0.65, fontWeight: FontWeight.bold))
          : null,
    );
  }
}

class CategoryChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const CategoryChip({super.key, required this.label, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(label, style: TextStyle(
          color: selected ? Colors.white : AppColors.textSecondary,
          fontSize: 13, fontWeight: selected ? FontWeight.w600 : FontWeight.normal)),
      ),
    );
  }
}

class TagBadge extends StatelessWidget {
  final String label;
  final Color? color;
  const TagBadge({super.key, required this.label, this.color});
  @override
  Widget build(BuildContext context) {
    final c = color ?? AppColors.primary;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: c.withOpacity(0.4)),
      ),
      child: Text(label, style: TextStyle(color: c, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;
  const SectionHeader({super.key, required this.title, this.actionLabel, this.onAction});
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      if (actionLabel != null)
        GestureDetector(onTap: onAction,
            child: Text(actionLabel!, style: const TextStyle(color: AppColors.primary, fontSize: 13))),
    ]);
  }
}
