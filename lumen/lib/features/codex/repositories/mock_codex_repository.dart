import '../../../app/config/app_config.dart';
import '../../../core/mock/mock_data.dart';
import '../models/codex_entry.dart';
import 'codex_repository.dart';

class MockCodexRepository implements CodexRepository {
  MockCodexRepository({Duration? latency})
    : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;

  static const List<CodexEntry> _demoEntries = [
    CodexEntry(
      id: 'm4',
      name: 'M-4',
      avatarId: 'm4',
      description: 'Unidad principal vinculada al perfil del operador.',
      isUnlocked: true,
    ),
    CodexEntry(
      id: 'sentinel',
      name: 'Centinela',
      avatarId: 'sentinel',
      description: 'Registro de unidad centinela identificado.',
      isUnlocked: true,
    ),
    CodexEntry(
      id: 'a7',
      name: 'A-7',
      avatarId: 'a7',
      description: 'Registro de unidad aliada identificado.',
      isUnlocked: true,
    ),
    CodexEntry(
      id: 'r5',
      name: 'R-5',
      description: 'Registro de unidad recuperado en una zona explorada.',
      isUnlocked: true,
    ),
    CodexEntry(
      id: 'scavenger',
      name: 'Carroñero',
      avatarId: 'scavenger',
      description: 'Registro de unidad de recuperación identificado.',
      isUnlocked: true,
    ),
    CodexEntry(
      id: 'c9',
      name: 'Registro cifrado',
      description: '',
      isUnlocked: false,
    ),
    CodexEntry(
      id: 'mk1',
      name: 'Registro cifrado',
      description: '',
      isUnlocked: false,
    ),
    CodexEntry(
      id: 'm41',
      name: 'Registro cifrado',
      description: '',
      isUnlocked: false,
    ),
    CodexEntry(
      id: 'unknown-1',
      name: 'Registro cifrado',
      description: '',
      isUnlocked: false,
    ),
    CodexEntry(
      id: 'unknown-2',
      name: 'Registro cifrado',
      description: '',
      isUnlocked: false,
    ),
    CodexEntry(
      id: 'unknown-3',
      name: 'Registro cifrado',
      description: '',
      isUnlocked: false,
    ),
    CodexEntry(
      id: 'unknown-4',
      name: 'Registro cifrado',
      description: '',
      isUnlocked: false,
    ),
  ];

  @override
  Future<List<CodexEntry>> fetchCharacters({required String userId}) async {
    await Future<void>.delayed(_latency);
    return userId == MockData.demoUserId ? _demoEntries : const [];
  }
}
