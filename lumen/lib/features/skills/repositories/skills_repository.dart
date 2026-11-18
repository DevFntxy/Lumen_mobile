import '../models/skill_tree.dart';

abstract interface class SkillsRepository {
  Future<SkillTree> fetchTree({required String userId});

  Future<SkillTree> upgrade({
    required String userId,
    required String skillId,
  });

  Future<SkillTree> respec({required String userId});
}
