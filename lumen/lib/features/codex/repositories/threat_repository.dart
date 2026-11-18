import '../models/threat_entry.dart';

abstract interface class ThreatRepository {
  Future<List<ThreatEntry>> fetchThreats({required String userId});
}
