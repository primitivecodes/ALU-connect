import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../models/mock_data.dart';

class LaunchpadProvider extends ChangeNotifier {
  final List<IdeaModel> _ideas = List.from(MockData.ideas);
  String _filter = 'All';

  List<IdeaModel> get allIdeas => _ideas;
  String get filter => _filter;
  List<IdeaModel> get filteredIdeas =>
      _filter == 'All' ? _ideas : _ideas.where((i) => i.domain == _filter).toList();

  final List<String> filters = [
    'All', 'AgriTech', 'HealthTech', 'EdTech', 'FinTech', 'CleanTech'
  ];

  void setFilter(String f) { _filter = f; notifyListeners(); }

  void toggleBack(String ideaId) {
    final idx = _ideas.indexWhere((i) => i.id == ideaId);
    if (idx != -1) {
      _ideas[idx].isBacked = !_ideas[idx].isBacked;
      _ideas[idx].isBacked
          ? _ideas[idx].backerCount++
          : _ideas[idx].backerCount--;
      notifyListeners();
    }
  }

  void addIdea(IdeaModel idea) {
    _ideas.insert(0, idea);
    notifyListeners();
  }
}
