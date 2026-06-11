import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/community_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../chat/chat_room_screen.dart';

class CommunitiesScreen extends StatefulWidget {
  const CommunitiesScreen({super.key});
  @override
  State<CommunitiesScreen> createState() => _CommunitiesScreenState();
}

class _CommunitiesScreenState extends State<CommunitiesScreen> with SingleTickerProviderStateMixin {
  late TabController _tab;
  @override void initState() { super.initState(); _tab = TabController(length: 2, vsync: this); }
  @override void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Communities'),
        bottom: TabBar(controller: _tab,
          labelColor: AppColors.primary, unselectedLabelColor: AppColors.textMuted,
          indicatorColor: AppColors.primary, indicatorWeight: 2,
          tabs: const [Tab(text: 'All Clubs'), Tab(text: 'My Chats')])),
      body: TabBarView(controller: _tab, children: [_AllTab(), _MyTab()]),
    );
  }
}

class _AllTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(builder: (_, cp, __) {
      return ListView(padding: const EdgeInsets.all(16), children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
          child: Row(children: [const Icon(Icons.search, color: AppColors.textMuted, size: 18), const SizedBox(width: 10), Text('Search communities...', style: TextStyle(color: AppColors.textMuted, fontSize: 14))])),
        const SizedBox(height: 16),
        ...cp.allCommunities.map((c) => _CommunityCard(community: c)),
      ]);
    });
  }
}

class _CommunityCard extends StatelessWidget {
  final CommunityModel community;
  const _CommunityCard({required this.community});
  @override
  Widget build(BuildContext context) {
    final cp = context.read<CommunityProvider>();
    return GestureDetector(
      onTap: community.isJoined ? () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoomScreen(community: community))) : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
        child: Row(children: [
          CircleAvatar(radius: 22,
            backgroundColor: Color(int.parse(community.avatarColor.replaceFirst('#', 'FF'), radix: 16)),
            child: Text(community.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(community.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(community.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('${community.memberCount} members · ${community.category}', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          ])),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => cp.toggleJoin(community.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: community.isJoined ? AppColors.surfaceLight : AppColors.primary,
                borderRadius: BorderRadius.circular(8),
                border: community.isJoined ? Border.all(color: AppColors.divider) : null),
              child: Text(community.isJoined ? 'Joined' : 'Join',
                  style: TextStyle(color: community.isJoined ? AppColors.textSecondary : Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }
}

class _MyTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<CommunityProvider>(builder: (_, cp, __) {
      final joined = cp.joinedCommunities;
      if (joined.isEmpty) {
        return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.chat_bubble_outline, color: AppColors.textMuted, size: 48),
          const SizedBox(height: 12),
          const Text('No communities joined yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          const Text('Join clubs from the All Clubs tab to start chatting.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13), textAlign: TextAlign.center),
        ]));
      }
      return ListView(padding: const EdgeInsets.all(16), children: joined.map((c) => GestureDetector(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoomScreen(community: c))),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Stack(children: [
              CircleAvatar(radius: 22,
                backgroundColor: Color(int.parse(c.avatarColor.replaceFirst('#', 'FF'), radix: 16)),
                child: Text(c.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))),
              if (c.unreadCount > 0) Positioned(right: 0, top: 0, child: Container(
                width: 16, height: 16,
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: Center(child: Text('${c.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))),
            ]),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(c.name, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
                Text(c.lastMessageTime, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
              ]),
              const SizedBox(height: 3),
              Text(c.lastMessage, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
          ]),
        ),
      )).toList());
    });
  }
}
