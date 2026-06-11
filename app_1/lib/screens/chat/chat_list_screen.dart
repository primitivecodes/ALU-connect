import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/community_provider.dart';
import '../../theme/app_theme.dart';
import 'chat_room_screen.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Chats & Messaging'),
          actions: [IconButton(icon: const Icon(Icons.edit_outlined), onPressed: () {})]),
      body: Consumer<CommunityProvider>(builder: (_, cp, __) {
        final joined = cp.joinedCommunities;
        if (joined.isEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.forum_outlined, color: AppColors.textMuted, size: 56),
            const SizedBox(height: 16),
            const Text('No conversations yet', style: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Join communities to start chatting\nwith other ALU students.', style: TextStyle(color: AppColors.textSecondary, fontSize: 14), textAlign: TextAlign.center),
          ]));
        }
        return ListView(padding: const EdgeInsets.symmetric(vertical: 8), children: joined.map((c) => ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          leading: Stack(children: [
            CircleAvatar(radius: 24,
              backgroundColor: Color(int.parse(c.avatarColor.replaceFirst('#', 'FF'), radix: 16)),
              child: Text(c.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
            if (c.unreadCount > 0) Positioned(right: 0, top: 0, child: Container(
              width: 16, height: 16,
              decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
              child: Center(child: Text('${c.unreadCount}', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold))))),
          ]),
          title: Text(c.name, style: TextStyle(color: AppColors.textPrimary, fontWeight: c.unreadCount > 0 ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
          subtitle: Text(c.lastMessage, style: TextStyle(color: c.unreadCount > 0 ? AppColors.textSecondary : AppColors.textMuted, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
          trailing: Text(c.lastMessageTime, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatRoomScreen(community: c))),
        )).toList());
      }),
    );
  }
}
