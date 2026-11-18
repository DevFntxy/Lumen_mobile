import 'package:flutter_test/flutter_test.dart';

// ignore_for_file: avoid_relative_lib_imports
import '../lib/core/errors/app_failure.dart';
import '../lib/features/skills/models/skill_tree.dart';

void main() {
  test('requiere prerequisitos y descuenta el coste de la mejora', () {
    final tree = SkillTree.demo();

    expect(
      () => tree.upgrade('overload'),
      throwsA(isA<RuleFailure>()),
    );

    final withImpact = tree.upgrade('impact');
    expect(withImpact.levelOf('impact'), 1);
    expect(withImpact.points, 5);
    final withOverload = withImpact.upgrade('overload');
    expect(withOverload.levelOf('overload'), 1);
    expect(withOverload.points, 3);
  });

  test('reasignar devuelve los puntos invertidos', () {
    final tree = SkillTree.demo().upgrade('impact').upgrade('overload');
    final reset = tree.respec();

    expect(reset.points, 6);
    expect(reset.pointsSpent, 0);
    expect(reset.levelOf('impact'), 0);
  });
}
