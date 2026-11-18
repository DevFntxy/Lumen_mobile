import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_failure.dart';
import '../../auth/providers/auth_providers.dart';
import '../models/skill_tree.dart';
import '../repositories/mock_skills_repository.dart';
import '../repositories/skills_repository.dart';

final skillsRepositoryProvider = Provider<SkillsRepository>(
  (ref) => MockSkillsRepository(),
);

final skillsControllerProvider =
    AsyncNotifierProvider<SkillsController, SkillTree>(
  SkillsController.new,
);

class SkillsController extends AsyncNotifier<SkillTree> {
  SkillsRepository get _repository => ref.read(skillsRepositoryProvider);

  String get _userId {
    final id = ref.read(authControllerProvider).user?.id;
    if (id == null) {
      throw const RuleFailure('Inicia sesión para consultar tus habilidades.');
    }
    return id;
  }

  @override
  Future<SkillTree> build() async {
    final userId = ref.watch(authControllerProvider.select((s) => s.user?.id));
    if (userId == null) {
      throw const RuleFailure('Inicia sesión para consultar tus habilidades.');
    }
    return _repository.fetchTree(userId: userId);
  }

  Future<void> upgrade(String skillId) async {
    final updated = await _repository.upgrade(
      userId: _userId,
      skillId: skillId,
    );
    state = AsyncData(updated);
  }

  Future<void> respec() async {
    final updated = await _repository.respec(userId: _userId);
    state = AsyncData(updated);
  }
}
