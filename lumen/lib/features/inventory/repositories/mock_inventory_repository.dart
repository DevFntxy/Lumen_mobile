import '../../../app/config/app_config.dart';
import '../../../core/mock/mock_data.dart';
import '../models/inventory_item.dart';
import 'inventory_repository.dart';

class MockInventoryRepository implements InventoryRepository {
  MockInventoryRepository({Duration? latency})
    : _latency = latency ?? AppConfig.mockLatency;

  final Duration _latency;

  static const List<InventoryItem> _demoItems = [
    InventoryItem(
      id: 'wrench-x3',
      name: 'Llave de ajuste X-3',
      type: ItemType.weapon,
      description:
          'Herramienta de mantenimiento pesada, reconvertida en arma '
          'cuerpo a cuerpo.',
      quantity: 1,
      stats: [ItemStat('Daño', '45'), ItemStat('Crítico', '10%')],
    ),
    InventoryItem(
      id: 'energy-cell',
      name: 'Celda de energía',
      type: ItemType.consumable,
      description: 'Restablece la carga de M-4 al instante.',
      quantity: 8,
      capacity: 10,
      stats: [ItemStat('Recupera', '200')],
    ),
    InventoryItem(
      id: 'chassis-plate',
      name: 'Blindaje de chasis',
      type: ItemType.armor,
      description: 'Placas de aleación soldadas sobre el torso.',
      quantity: 1,
      stats: [ItemStat('Defensa', '60'), ItemStat('Evasión', '5%')],
    ),
    InventoryItem(
      id: 'blueprint-filter',
      name: 'Plano: filtro de aceite',
      type: ItemType.blueprint,
      description:
          'Esquema para fabricar un filtro que mejora la refrigeración.',
      quantity: 1,
      stats: [ItemStat('Uso', 'Fabricación')],
    ),
    InventoryItem(
      id: 'welding-torch',
      name: 'Soplete de soldar',
      type: ItemType.tool,
      description: 'Permite reparar estructuras y abrir compuertas selladas.',
      quantity: 1,
      stats: [ItemStat('Potencia', '15')],
    ),
    InventoryItem(
      id: 'blue-core',
      name: 'Núcleo azul',
      type: ItemType.component,
      description:
          'Componente raro que aún conserva carga. Sirve para '
          'fabricar mejoras avanzadas.',
      quantity: 1,
      stats: [ItemStat('Rareza', 'Raro')],
    ),
    InventoryItem(
      id: 'scrap',
      name: 'Chatarra',
      type: ItemType.currency,
      description:
          'Restos metálicos que los talleres de la ciudad aceptan '
          'como pago.',
      quantity: 450,
      capacity: 1000,
    ),
  ];

  @override
  Future<List<InventoryItem>> fetchItems({required String userId}) async {
    await Future<void>.delayed(_latency);
    return userId == MockData.demoUserId ? _demoItems : const [];
  }
}
