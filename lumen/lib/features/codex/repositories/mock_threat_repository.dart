import '../../../app/config/app_config.dart';
import '../../../core/mock/mock_data.dart';
import '../models/threat_entry.dart';
import 'threat_repository.dart';

class MockThreatRepository implements ThreatRepository {
  MockThreatRepository({Duration? latency})
      : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;

  static const _entries = [
    ThreatEntry(
      id: 'watcher',
      name: 'Dron de vigilancia',
      description: 'Unidad de patrulla ligera que alerta a otras amenazas.',
      kind: ThreatKind.enemy,
      avatarId: 'sentinel',
      isIdentified: true,
      weakness: 'Ataques eléctricos',
    ),
    ThreatEntry(
      id: 'scrapper',
      name: 'Carroñero mecánico',
      description: 'Recolecta piezas y protege su territorio.',
      kind: ThreatKind.enemy,
      avatarId: 'scavenger',
      isIdentified: true,
      weakness: 'Ataques por la espalda',
    ),
    ThreatEntry(
      id: 'damaged',
      name: 'Autómata defectuoso',
      description: 'Unidades inestables que reaccionan ante cualquier ruido.',
      kind: ThreatKind.enemy,
      avatarId: 'a7',
      isIdentified: false,
    ),
    ThreatEntry(
      id: 'overseer',
      name: 'Centinela del núcleo',
      description: 'Guardián de los accesos a la zona central.',
      kind: ThreatKind.boss,
      avatarId: 'sentinel',
      isIdentified: true,
      weakness: 'Núcleo expuesto tras su embestida',
    ),
    ThreatEntry(
      id: 'gardener',
      name: 'El Jardinero',
      description: 'Máquina de mantenimiento convertida en amenaza mayor.',
      kind: ThreatKind.boss,
      avatarId: 'scavenger',
      isIdentified: false,
    ),
    ThreatEntry(
      id: 'conductor',
      name: 'El Conductor',
      description: 'Una unidad pesada que domina los corredores industriales.',
      kind: ThreatKind.boss,
      avatarId: 'm4',
      isIdentified: false,
    ),
  ];

  @override
  Future<List<ThreatEntry>> fetchThreats({required String userId}) async {
    await Future<void>.delayed(_latency);
    return userId == MockData.demoUserId ? _entries : const [];
  }
}
