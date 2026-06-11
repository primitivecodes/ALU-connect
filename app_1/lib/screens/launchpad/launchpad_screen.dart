import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/launchpad_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class LaunchpadScreen extends StatelessWidget {
  const LaunchpadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Row(children: [
          const Text('The Launchpad'),
          const SizedBox(width: 8),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
            child: const Text('BETA', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold))),
        ]),
        actions: [Consumer<ProfileProvider>(builder: (_, p, __) {
          if (!(p.user?.canPost ?? false)) return const SizedBox.shrink();
          return IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () => _showSubmit(context));
        })],
      ),
      body: Consumer<LaunchpadProvider>(builder: (_, lp, __) {
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Container(
            margin: const EdgeInsets.all(16), padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF922B21), Color(0xFF1A252F)]),
              borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Row(children: [
                Icon(Icons.rocket_launch_outlined, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Student Startup Ideas', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ]),
              const SizedBox(height: 6),
              const Text('Back fellow ALU entrepreneurs. 3 backers = auto team chat opens.', style: TextStyle(color: Colors.white70, fontSize: 13)),
            ]),
          )),
          SliverToBoxAdapter(child: SizedBox(height: 48, child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            itemCount: lp.filters.length,
            itemBuilder: (_, i) => CategoryChip(label: lp.filters[i], selected: lp.filter == lp.filters[i], onTap: () => lp.setFilter(lp.filters[i])),
          ))),
          const SliverToBoxAdapter(child: SizedBox(height: 12)),
          SliverList(delegate: SliverChildBuilderDelegate(
            (_, i) => _IdeaCard(idea: lp.filteredIdeas[i]), childCount: lp.filteredIdeas.length)),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ]);
      }),
    );
  }

  void _showSubmit(BuildContext context) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final skillsCtrl = TextEditingController();
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Submit Your Idea', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          TextField(controller: titleCtrl, style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'Idea title', labelText: 'Title')),
          const SizedBox(height: 12),
          TextField(controller: descCtrl, maxLines: 3, style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'What problem does it solve?', labelText: 'Description')),
          const SizedBox(height: 12),
          TextField(controller: skillsCtrl, style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'e.g. Flutter, AI, Design', labelText: 'Skills Needed (comma-separated)')),
          const SizedBox(height: 20),
          PrimaryButton(label: 'Submit Idea', onPressed: () {
            if (titleCtrl.text.isEmpty) return;
            final user = context.read<ProfileProvider>().user!;
            context.read<LaunchpadProvider>().addIdea(IdeaModel(
              id: 'i_${DateTime.now().millisecondsSinceEpoch}',
              title: titleCtrl.text, description: descCtrl.text,
              authorName: user.fullName, authorInitials: user.initials,
              skills: skillsCtrl.text.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList(),
              stage: 'Idea', domain: 'Other',
            ));
            Navigator.pop(ctx);
          }),
        ]),
      ),
    );
  }
}

class _IdeaCard extends StatelessWidget {
  final IdeaModel idea;
  const _IdeaCard({required this.idea});

  Color _stageColor(String s) {
    switch (s) {
      case 'MVP':       return const Color(0xFF27AE60);
      case 'Prototype': return const Color(0xFFF39C12);
      case 'Research':  return const Color(0xFF2980B9);
      default:          return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LaunchpadProvider>(builder: (_, lp, __) => Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: idea.isBacked ? AppColors.primary.withOpacity(0.4) : AppColors.divider)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          UserAvatar(initials: idea.authorInitials, radius: 18),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(idea.authorName, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
            Text(idea.domain, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ])),
          TagBadge(label: idea.stage, color: _stageColor(idea.stage)),
        ]),
        const SizedBox(height: 12),
        Text(idea.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(idea.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.5), maxLines: 3, overflow: TextOverflow.ellipsis),
        const SizedBox(height: 12),
        Wrap(spacing: 6, runSpacing: 6, children: idea.skills.map((s) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(6)),
          child: Text(s, style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)))).toList()),
        const SizedBox(height: 14),
        Row(children: [
          GestureDetector(
            onTap: () => lp.toggleBack(idea.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: idea.isBacked ? AppColors.primary : AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
                border: idea.isBacked ? null : Border.all(color: AppColors.divider)),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(idea.isBacked ? Icons.favorite : Icons.favorite_border,
                    color: idea.isBacked ? Colors.white : AppColors.textSecondary, size: 15),
                const SizedBox(width: 6),
                Text('${idea.backerCount} ${idea.backerCount == 1 ? 'backer' : 'backers'}',
                    style: TextStyle(color: idea.isBacked ? Colors.white : AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            ),
          ),
          const SizedBox(width: 8),
          if (idea.backerCount >= 3)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(color: AppColors.success.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.chat_bubble_outline, color: AppColors.success, size: 14),
                SizedBox(width: 4),
                Text('Team chat open', style: TextStyle(color: AppColors.success, fontSize: 12, fontWeight: FontWeight.w600)),
              ]),
            ),
        ]),
      ]),
    ));
  }
}
