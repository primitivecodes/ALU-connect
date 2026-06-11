import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../main_shell.dart';

class RoleSelectionScreen extends StatefulWidget {
  final String fullName, email, password, campus;
  const RoleSelectionScreen({super.key, required this.fullName, required this.email, required this.password, required this.campus});
  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  UserRole? _selected;

  final _roles = const [
    _RO(UserRole.student, 'Student', 'Discover events, join communities, RSVP to opportunities.', Icons.school_outlined),
    _RO(UserRole.clubLeader, 'Club Leader', 'Post club events, manage members, moderate chat spaces.', Icons.groups_outlined),
    _RO(UserRole.eventOrganiser, 'Event Organiser', 'Create and manage events, track RSVPs and attendance.', Icons.event_outlined),
    _RO(UserRole.academicTeam, 'Academic Team', 'Post programme announcements, internship opportunities, and workshops.', Icons.workspace_premium_outlined),
  ];

  Future<void> _finish() async {
    if (_selected == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select your role.'), backgroundColor: AppColors.error));
      return;
    }
    final ok = await context.read<ProfileProvider>().register(
      fullName: widget.fullName, email: widget.email,
      password: widget.password, campus: widget.campus, role: _selected!,
    );
    if (ok && mounted) {
      Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const MainShell()), (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Select Your Role'),
          leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 18), onPressed: () => Navigator.pop(context))),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          Row(children: List.generate(2, (i) => Expanded(child: Container(
            margin: EdgeInsets.only(right: i < 1 ? 6 : 0), height: 4,
            decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(2)),
          )))),
          const SizedBox(height: 28),
          const Text('Who are you at ALU?', style: TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Your role determines what you can do on ALUConnect.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
          const SizedBox(height: 24),
          Expanded(child: ListView.separated(
            itemCount: _roles.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final r = _roles[i];
              final sel = _selected == r.role;
              return GestureDetector(
                onTap: () => setState(() => _selected = r.role),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: sel ? AppColors.primary.withOpacity(0.12) : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: sel ? AppColors.primary : AppColors.divider, width: sel ? 1.5 : 1),
                  ),
                  child: Row(children: [
                    Container(width: 44, height: 44,
                      decoration: BoxDecoration(color: sel ? AppColors.primary : AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
                      child: Icon(r.icon, color: sel ? Colors.white : AppColors.textSecondary, size: 22)),
                    const SizedBox(width: 14),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(r.title, style: TextStyle(color: sel ? AppColors.primary : AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 15)),
                      const SizedBox(height: 3),
                      Text(r.subtitle, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12.5)),
                    ])),
                    if (sel) const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                  ]),
                ),
              );
            },
          )),
          const SizedBox(height: 16),
          Consumer<ProfileProvider>(builder: (_, p, __) =>
              PrimaryButton(label: 'Create Account', onPressed: _finish, isLoading: p.isLoading)),
          const SizedBox(height: 24),
        ]),
      )),
    );
  }
}

class _RO {
  final UserRole role; final String title, subtitle; final IconData icon;
  const _RO(this.role, this.title, this.subtitle, this.icon);
}
