// repositories/meta_financeira_repository.dart
import 'dart:async';
import '../Model/meta_financeira.dart';


// Repository abstrato (interface)
abstract class MetaFinanceiraRepository {
  // CRUD básico
  Future<MetaFinanceira> criar(CriarMetaFinanceiraDto dto);
  Future<MetaFinanceira?> buscarPorId(String id);
  Future<List<MetaFinanceira>> listarTodas();
  Future<MetaFinanceira> atualizar(MetaFinanceira meta);
  Future<void> deletar(String id);


  // Operações específicas
  Future<MetaFinanceira> atualizarProgresso(AtualizarProgressoDto dto);
  Future<List<MetaFinanceira>> buscarPorStatus(StatusMeta status);
  Future<List<MetaFinanceira>> buscarPorCategoria(CategoriaMeta categoria);
  Future<List<MetaFinanceira>> buscarAtivas();
  Future<List<MetaFinanceira>> buscarVencidas();
  Future<List<MetaFinanceira>> buscarPorPeriodo(DateTime inicio, DateTime fim);


  // Estatísticas
  Future<Map<String, dynamic>> obterEstatisticas();
  Future<double> calcularTotalEconomizado();
  Future<double> calcularTotalMetas();


  // Stream para mudanças em tempo real
  Stream<List<MetaFinanceira>> observarMetas();
  Stream<MetaFinanceira?> observarMeta(String id);
}
 
