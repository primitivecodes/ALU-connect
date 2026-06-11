import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/feed_provider.dart';
import '../../providers/profile_provider.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../home/event_detail_screen.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Explore')),
      body: Consumer<FeedProvider>(builder: (_, feed, __) {
        final cats = [EventCategory.all, EventCategory.events, EventCategory.internships, EventCategory.hackathons, EventCategory.workshops];
        return CustomScrollView(slivers: [
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.divider)),
              child: Row(children: [const Icon(Icons.search, color: AppColors.textMuted, size: 18), const SizedBox(width: 10), Text('Search events, internships, workshops...', style: TextStyle(color: AppColors.textMuted, fontSize: 14))])),
          )),
          SliverToBoxAdapter(child: SizedBox(height: 52, child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            itemCount: cats.length,
            itemBuilder: (_, i) => CategoryChip(
              label: cats[i] == EventCategory.all ? 'All' : cats[i].categoryLabel,
              selected: feed.selectedCategory == cats[i],
              onTap: () => feed.setCategory(cats[i]),
            ),
          ))),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Consumer<ProfileProvider>(builder: (_, p, __) {
              final interests = p.user?.interests ?? [];
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const SectionHeader(title: 'Recommended For You'),
                if (interests.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Wrap(spacing: 6, children: interests.map((i) => TagBadge(label: i)).toList()),
                ],
              ]);
            }),
          )),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: Consumer<FeedProvider>(builder: (_, f, __) {
              final events = f.filteredEvents;
              return SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.78),
                delegate: SliverChildBuilderDelegate((_, i) => _ExploreCard(event: events[i]), childCount: events.length),
              );
            }),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ]);
      }),
    );
  }
}

class _ExploreCard extends StatelessWidget {
  final EventModel event;
  const _ExploreCard({required this.event});

  IconData _icon(EventCategory c) {
    switch (c) {
      case EventCategory.hackathons:  return Icons.code;
      case EventCategory.workshops:   return Icons.build_outlined;
      case EventCategory.internships: return Icons.work_outline;
      case EventCategory.leadership:  return Icons.star_outline;
      default:                        return Icons.event;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => EventDetailScreen(event: event))),
      child: Container(
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.divider)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 90,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [
                Color(int.parse((event.imageColor ?? '#1E1E1E').replaceFirst('#', 'FF'), radix: 16)),
                AppColors.cardBg,
              ]),
            ),
            child: Center(child: Icon(_icon(event.category), color: Colors.white.withOpacity(0.4), size: 32))),
          Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TagBadge(label: event.tag),
            const SizedBox(height: 6),
            Text(event.title, style: const TextStyle(color: AppColors.textPrimary, fontSize: 12, fontWeight: FontWeight.w600), maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text(event.date, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.people_outline, color: AppColors.textMuted, size: 11),
              const SizedBox(width: 3),
              Text('${event.seatsLeft} left', style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
            ]),
          ])),
        ]),
      ),
    );
  }
}
