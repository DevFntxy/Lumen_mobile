import '../../../core/errors/app_failure.dart';
import '../models/skill_tree.dart';
import 'skills_repository.dart';

class MockSkillsRepository implements SkillsRepository {
  final Map<String, SkillTree> _treesByUser = {};

  SkillTree _tree(String userId) {
    if (userId.trim().isEmpty) {
      throw const RuleFailure('Inicia sesión para consultar tus habilidades.');
    }
    return _treesByUser.putIfAbsent(userId, SkillTree.demo);
  }

  @override
  Future<SkillTree> fetchTree({required String userId}) async => _tree(userId);

  @override
  Future<SkillTree> upgrade({
    required String userId,
    required String skillId,
  }) async {
    final updated = _tree(userId).upgrade(skillId);
    _treesByUser[userId] = updated;
    return updated;
  }

  @override
  Future<SkillTree> respec({required String userId}) async {
    final updated = _tree(userId).respec();
    _treesByUser[userId] = updated;
    return updated;
  }
}
