import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import 'event_detail_screen.dart';
import 'create_post_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: RefreshIndicator(
        color: AppColors.primary, backgroundColor: AppColors.surface,
        onRefresh: () => context.read<FeedProvider>().refresh(),
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Consumer<ProfileProvider>(builder: (_, p, __) => Text(
                  'Hello, ${p.user?.fullName.split(' ').first ?? 'there'} 👋',
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 20, fontWeight: FontWeight.bold))),
                const Text('Discover what\'s happening at ALU', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
              ])),
              Consumer<ProfileProvider>(builder: (_, p, __) => UserAvatar(initials: p.user?.initials ?? 'A', radius: 20)),
            ]),
          )),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
              child: Row(children: [
                const Icon(Icons.search, color: AppColors.textMuted, size: 18),
                const SizedBox(width: 10),
                Text('Search opportunities, events, clubs...', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
              ]),
            ),
          )),
          SliverToBoxAdapter(child: Consumer<FeedProvider>(builder: (_, feed, __) {
            final featured = feed.featuredEvent;
            if (featured == null) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: featured))),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Color(0xFF922B21), Color(0xFF1A252F)]),
                  ),
                  child: Stack(children: [
                    const Positioned(top: 12, left: 12, child: TagBadge(label: 'FEATURED', color: Colors.white)),
                    Positioned(bottom: 0, left: 0, right: 0, child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.transparent, Colors.black.withOpacity(0.7)]),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(featured.title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(children: [
                          const Icon(Icons.calendar_today_outlined, color: Colors.white70, size: 13),
                          const SizedBox(width: 4),
                          Text(featured.date, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const SizedBox(width: 12),
                          const Icon(Icons.people_outline, color: Colors.white70, size: 13),
                          const SizedBox(width: 4),
                          Text('${featured.seatsLeft} seats left', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          const Spacer(),
                          Consumer<ProfileProvider>(builder: (_, p, __) {
                            final rsvped = p.user?.rsvpedEventIds.contains(featured.id) ?? false;
                            return GestureDetector(
                              onTap: () { if (!rsvped) { p.toggleRsvp(featured.id); context.read<FeedProvider>().rsvpEvent(featured.id); } },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(color: rsvped ? Colors.green : AppColors.primary, borderRadius: BorderRadius.circular(8)),
                                child: Text(rsvped ? 'Registered' : 'Free RSVP', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                              ),
                            );
                          }),
                        ]),
                      ]),
                    )),
                  ]),
                ),
              ),
            );
          })),
          SliverToBoxAdapter(child: Consumer<FeedProvider>(builder: (_, feed, __) {
            return SizedBox(height: 56, child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              itemCount: EventCategory.values.length,
              itemBuilder: (_, i) {
                final cat = EventCategory.values[i];
                final label = cat == EventCategory.all ? 'All' : cat.categoryLabel;
                return CategoryChip(label: label, selected: feed.selectedCategory == cat, onTap: () => feed.setCategory(cat));
              },
            ));
          })),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: const SectionHeader(title: 'Latest Opportunities'),
          )),
          Consumer<FeedProvider>(builder: (_, feed, __) {
            final events = feed.filteredEvents;
            return SliverList(delegate: SliverChildBuilderDelegate(
              (_, i) => _EventCard(event: events[i]), childCount: events.length));
          }),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ]),
      )),
      floatingActionButton: Consumer<ProfileProvider>(builder: (_, p, __) {
        if (!(p.user?.canPost ?? false)) return const SizedBox.shrink();
        return FloatingActionButton(
          backgroundColor: AppColors.primary,
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CreatePostScreen())),
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }
}

class _EventCard extends StatelessWidget {
  final EventModel event;
  const _EventCard({required this.event});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
        child: Row(children: [
          Container(width: 52, height: 52,
            decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(10)),
            child: Center(child: Text(event.date.split(',').first.substring(0, 3).toUpperCase(), style: const TextStyle(color: AppColors.primary, fontSize: 11, fontWeight: FontWeight.bold)))),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(event.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 3),
            Text(event.organiser, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 6),
            Row(children: [
              TagBadge(label: event.tag),
              const SizedBox(width: 6),
              if (event.seatsLeft < 10) TagBadge(label: '${event.seatsLeft} left', color: AppColors.warning),
            ]),
          ])),
          Consumer<ProfileProvider>(builder: (_, p, __) {
            final rsvped = p.user?.rsvpedEventIds.contains(event.id) ?? false;
            return GestureDetector(
              onTap: () {
                if (rsvped) { p.toggleRsvp(event.id); context.read<FeedProvider>().cancelRsvp(event.id); }
                else { p.toggleRsvp(event.id); context.read<FeedProvider>().rsvpEvent(event.id); }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: rsvped ? AppColors.success.withOpacity(0.15) : AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                  border: rsvped ? Border.all(color: AppColors.success.withOpacity(0.4)) : null,
                ),
                child: Text(rsvped ? 'Registered' : 'RSVP',
                    style: TextStyle(color: rsvped ? AppColors.success : Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
              ),
            );
          }),
        ]),
      ),
    );
  }
}
