import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/profile_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../auth/login_screen.dart';

const _allInterests = [
  'Student Leadership', 'Entrepreneurship', 'Tech & Innovation', 'Climate Action',
  'Arts & Culture', 'Research', 'Community Service', 'Health & Wellness', 'African Policy', 'Finance',
];

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileProvider>(builder: (_, p, __) {
      final user = p.user;
      if (user == null) return const SizedBox.shrink();
      return DefaultTabController(length: 3, child: Scaffold(
        backgroundColor: AppColors.background,
        body: NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(child: _Header(p: p)),
            SliverPersistentHeader(pinned: true, delegate: _TabDelegate(TabBar(
              labelColor: AppColors.primary, unselectedLabelColor: AppColors.textMuted,
              indicatorColor: AppColors.primary, indicatorWeight: 2,
              labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              tabs: const [Tab(text: 'Interests'), Tab(text: 'My RSVPs'), Tab(text: 'Settings')],
            ))),
          ],
          body: TabBarView(children: [_InterestsTab(p: p), _RsvpsTab(p: p), _SettingsTab(p: p)]),
        ),
      ));
    });
  }
}

class _Header extends StatelessWidget {
  final ProfileProvider p;
  const _Header({required this.p});
  @override
  Widget build(BuildContext context) {
    final u = p.user!;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 20),
      color: AppColors.surface,
      child: Column(children: [
        Stack(alignment: Alignment.bottomRight, children: [
          UserAvatar(initials: u.initials, radius: 44),
          Container(width: 28, height: 28,
            decoration: BoxDecoration(color: AppColors.primary, shape: BoxShape.circle, border: Border.all(color: AppColors.surface, width: 2)),
            child: const Icon(Icons.edit, color: Colors.white, size: 14)),
        ]),
        const SizedBox(height: 14),
        Text(u.fullName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(u.email, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          _Chip(label: u.roleLabel, icon: Icons.badge_outlined),
          const SizedBox(width: 8),
          _Chip(label: u.campus, icon: Icons.location_on_outlined),
        ]),
        const SizedBox(height: 16),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _Stat('RSVPs', u.rsvpedEventIds.length.toString()),
          Container(height: 30, width: 1, color: AppColors.divider),
          _Stat('Saved', u.savedEventIds.length.toString()),
          Container(height: 30, width: 1, color: AppColors.divider),
          _Stat('Communities', u.communityIds.length.toString()),
        ]),
      ]),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label; final IconData icon;
  const _Chip({required this.label, required this.icon});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(16)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, color: AppColors.textMuted, size: 13), const SizedBox(width: 4),
      Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
    ]),
  );
}

class _Stat extends StatelessWidget {
  final String label, value;
  const _Stat(this.label, this.value);
  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
  ]);
}

class _InterestsTab extends StatelessWidget {
  final ProfileProvider p;
  const _InterestsTab({required this.p});
  @override
  Widget build(BuildContext context) {
    final interests = p.user!.interests;
    return ListView(padding: const EdgeInsets.all(24), children: [
      const Text('Your Interests', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
      const SizedBox(height: 6),
      const Text('These help us surface relevant opportunities for you.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      const SizedBox(height: 20),
      Wrap(spacing: 10, runSpacing: 10, children: _allInterests.map((t) => InterestChip(
        label: t, selected: interests.contains(t), onTap: () => p.toggleInterest(t))).toList()),
      if (interests.isNotEmpty) ...[
        const SizedBox(height: 24),
        const Text('Selected', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Text(interests.join(' · '), style: const TextStyle(color: AppColors.primary, fontSize: 13)),
      ],
    ]);
  }
}

class _RsvpsTab extends StatelessWidget {
  final ProfileProvider p;
  const _RsvpsTab({required this.p});
  @override
  Widget build(BuildContext context) {
    final ids = p.user!.rsvpedEventIds;
    if (ids.isEmpty) {
      return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.event_busy_outlined, color: AppColors.textMuted, size: 48),
        const SizedBox(height: 12),
        const Text('No RSVPs yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        const Text('Events you RSVP to will appear here.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
      ]));
    }
    final titles = {'e1': 'ALU Hackathon 2026', 'e2': 'Master Class Internship', 'e3': 'Pan-African Tech Summit', 'e4': 'Social Impact Hackathon', 'e5': 'Global Leadership Workshop', 'e6': 'Mastercard Foundation Internship'};
    return ListView(padding: const EdgeInsets.all(20), children: ids.map((id) => Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
      child: Row(children: [
        Container(width: 44, height: 44,
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.event, color: AppColors.primary, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(titles[id] ?? 'Event $id', style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(6)),
            child: const Text('Registered', style: TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.w600))),
        ])),
        IconButton(icon: const Icon(Icons.close, color: AppColors.textMuted, size: 18), onPressed: () => p.toggleRsvp(id)),
      ]),
    )).toList());
  }
}

class _SettingsTab extends StatelessWidget {
  final ProfileProvider p;
  const _SettingsTab({required this.p});
  @override
  Widget build(BuildContext context) {
    final u = p.user!;
    return ListView(padding: const EdgeInsets.all(20), children: [
      _SLabel('Account'),
      _STile(icon: Icons.person_outline, label: 'Edit Profile', onTap: () {}),
      _STile(icon: Icons.notifications_outlined, label: 'Notifications', onTap: () {}),
      _STile(icon: Icons.lock_outline, label: 'Change Password', onTap: () {}),
      const SizedBox(height: 20),
      _SLabel('Campus'),
      _STile(icon: Icons.location_on_outlined, label: 'My Campus', trailing: Text(u.campus, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)), onTap: () {}),
      _STile(icon: Icons.badge_outlined, label: 'My Role', trailing: Text(u.roleLabel, style: const TextStyle(color: AppColors.textMuted, fontSize: 13)), onTap: () {}),
      const SizedBox(height: 20),
      _SLabel('Saved'),
      _STile(icon: Icons.bookmark_outline, label: 'Saved Events', trailing: Text('${u.savedEventIds.length} saved', style: const TextStyle(color: AppColors.textMuted, fontSize: 13)), onTap: () {}),
      const SizedBox(height: 20),
      _SLabel('App'),
      _STile(icon: Icons.info_outline, label: 'About ALUConnect', onTap: () {}),
      _STile(icon: Icons.help_outline, label: 'Help & Support', onTap: () {}),
      const SizedBox(height: 20),
      GestureDetector(
        onTap: () async {
          final ok = await showDialog<bool>(context: context, builder: (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            title: const Text('Sign out', style: TextStyle(color: AppColors.textPrimary)),
            content: const Text('Are you sure you want to sign out?', style: TextStyle(color: AppColors.textSecondary)),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Sign Out', style: TextStyle(color: AppColors.error))),
            ],
          ));
          if (ok == true) {
            await p.logout();
            if (context.mounted) Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(color: AppColors.error.withOpacity(0.08), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.error.withOpacity(0.3))),
          child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.logout, color: AppColors.error, size: 18), SizedBox(width: 8),
            Text('Sign Out', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.w600)),
          ]),
        ),
      ),
      const SizedBox(height: 32),
    ]);
  }
}

class _SLabel extends StatelessWidget {
  final String label; const _SLabel(this.label);
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(label.toUpperCase(), style: const TextStyle(color: AppColors.textMuted, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.2)));
}

class _STile extends StatelessWidget {
  final IconData icon; final String label; final VoidCallback onTap; final Widget? trailing;
  const _STile({required this.icon, required this.label, required this.onTap, this.trailing});
  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.only(bottom: 2),
    child: ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
      tileColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14)),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 18),
      onTap: onTap,
    ),
  );
}

class _TabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar; const _TabDelegate(this.tabBar);
  @override double get minExtent => tabBar.preferredSize.height;
  @override double get maxExtent => tabBar.preferredSize.height;
  @override Widget build(BuildContext ctx, double s, bool o) => Container(color: AppColors.background, child: tabBar);
  @override bool shouldRebuild(_TabDelegate o) => false;
}
