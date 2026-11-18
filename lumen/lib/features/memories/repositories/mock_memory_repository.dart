import '../../../app/config/app_config.dart';
import '../../../core/mock/mock_data.dart';
import '../models/memory_fragment.dart';
import 'memory_repository.dart';

class MockMemoryRepository implements MemoryRepository {
  MockMemoryRepository({Duration? latency})
      : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;

  static const _fragments = [
    MemoryFragment(
      id: 'foundry-01',
      title: 'Turno de noche',
      sector: MemorySector.foundry,
      summary: 'Una última llamada antes del apagón.',
      transcript: 'No cierres la fundición todavía. Aún hay alguien dentro.',
      isUnlocked: true,
    ),
    MemoryFragment(
      id: 'foundry-02',
      title: 'Registro de mantenimiento',
      sector: MemorySector.foundry,
      summary: 'La unidad M-4 vuelve a responder.',
      transcript: 'M-4 ha reactivado su núcleo. No recuerda quién la reparó.',
      isUnlocked: true,
    ),
    MemoryFragment(
      id: 'foundry-03',
      title: 'Órdenes pendientes',
      sector: MemorySector.foundry,
      summary: 'Una orden contradice el protocolo.',
      transcript: 'Prioridad nueva: mantener abierta la salida del sector.',
      isUnlocked: false,
    ),
    MemoryFragment(
      id: 'foundry-04',
      title: 'Señal perdida',
      sector: MemorySector.foundry,
      summary: 'Una transmisión interrumpida.',
      transcript: 'Si recibes esto, busca el terminal junto a los ascensores.',
      isUnlocked: false,
    ),
    MemoryFragment(
      id: 'flooded-01',
      title: 'Nivel del agua',
      sector: MemorySector.flooded,
      summary: 'El sistema de compuertas dejó de obedecer.',
      transcript: 'El nivel sube demasiado rápido. Las compuertas no responden.',
      isUnlocked: true,
    ),
    MemoryFragment(
      id: 'flooded-02',
      title: 'Eco bajo el agua',
      sector: MemorySector.flooded,
      summary: 'Una voz aparece en los sensores.',
      transcript: 'Hay actividad al otro lado de la compuerta norte.',
      isUnlocked: false,
    ),
    MemoryFragment(
      id: 'flooded-03',
      title: 'Reparación de emergencia',
      sector: MemorySector.flooded,
      summary: 'Un equipo improvisa una solución.',
      transcript: 'Usa las piezas del generador. No hay tiempo para esperar.',
      isUnlocked: false,
    ),
    MemoryFragment(
      id: 'flooded-04',
      title: 'Baliza',
      sector: MemorySector.flooded,
      summary: 'Una baliza sigue transmitiendo.',
      transcript: 'Baliza activa. Coordenadas guardadas en el núcleo.',
      isUnlocked: false,
    ),
    MemoryFragment(
      id: 'core-01',
      title: 'Protocolo de evacuación',
      sector: MemorySector.core,
      summary: 'El protocolo fue modificado.',
      transcript: 'La evacuación se detiene. El núcleo debe permanecer estable.',
      isUnlocked: true,
    ),
    MemoryFragment(
      id: 'core-02',
      title: 'Sala de control',
      sector: MemorySector.core,
      summary: 'Un mensaje dirigido a la unidad principal.',
      transcript: 'M-4, si puedes oírme, decide por ti misma.',
      isUnlocked: false,
    ),
    MemoryFragment(
      id: 'core-03',
      title: 'Último acceso',
      sector: MemorySector.core,
      summary: 'La identidad del operador permanece oculta.',
      transcript: 'Acceso concedido. Operador: registro eliminado.',
      isUnlocked: false,
    ),
    MemoryFragment(
      id: 'core-04',
      title: 'Despertar',
      sector: MemorySector.core,
      summary: 'Una señal inicia el reinicio.',
      transcript: 'Núcleo encendido. Esperando instrucciones.',
      isUnlocked: false,
    ),
  ];

  @override
  Future<List<MemoryFragment>> fetchFragments({
    required String userId,
  }) async {
    await Future<void>.delayed(_latency);
    return userId == MockData.demoUserId ? _fragments : const [];
  }
}
