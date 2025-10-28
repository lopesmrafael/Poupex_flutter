import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'poupex.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Tabela de usuários
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        displayName TEXT NOT NULL,
        telefone TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    // Tabela de movimentações
    await db.execute('''
      CREATE TABLE movimentacoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        descricao TEXT NOT NULL,
        valor REAL NOT NULL,
        tipo TEXT NOT NULL,
        categoria TEXT NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Tabela de metas
    await db.execute('''
      CREATE TABLE metas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        titulo TEXT NOT NULL,
        valor REAL NOT NULL,
        status TEXT NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Tabela de orçamentos
    await db.execute('''
      CREATE TABLE orcamentos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        mes INTEGER NOT NULL,
        ano INTEGER NOT NULL,
        categoria TEXT NOT NULL,
        valor REAL NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Tabela de configurações
    await db.execute('''
      CREATE TABLE configuracoes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        notificacoes INTEGER DEFAULT 1,
        modoEscuro INTEGER DEFAULT 0,
        biometria INTEGER DEFAULT 0,
        moeda TEXT DEFAULT 'BRL',
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');

    // Tabela de pontos
    await db.execute('''
      CREATE TABLE pontos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        pontos INTEGER NOT NULL,
        motivo TEXT NOT NULL,
        data TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  // Métodos para usuários
  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateUser(int id, Map<String, dynamic> user) async {
    final db = await database;
    return await db.update('users', user, where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para movimentações
  Future<int> insertMovimentacao(Map<String, dynamic> movimentacao) async {
    final db = await database;
    return await db.insert('movimentacoes', movimentacao);
  }

  Future<List<Map<String, dynamic>>> getMovimentacoes(int userId) async {
    final db = await database;
    return await db.query(
      'movimentacoes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'data DESC',
    );
  }

  Future<Map<String, double>> getResumoFinanceiro(int userId) async {
    final db = await database;
    final receitas = await db.rawQuery(
      'SELECT SUM(valor) as total FROM movimentacoes WHERE userId = ? AND tipo = "receita"',
      [userId],
    );
    final despesas = await db.rawQuery(
      'SELECT SUM(valor) as total FROM movimentacoes WHERE userId = ? AND tipo = "despesa"',
      [userId],
    );

    double totalReceitas = (receitas.first['total'] as double?) ?? 0.0;
    double totalDespesas = (despesas.first['total'] as double?) ?? 0.0;

    return {
      'receitas': totalReceitas,
      'despesas': totalDespesas,
      'saldo': totalReceitas - totalDespesas,
    };
  }

  // Métodos para metas
  Future<int> insertMeta(Map<String, dynamic> meta) async {
    final db = await database;
    return await db.insert('metas', meta);
  }

  Future<List<Map<String, dynamic>>> getMetas(int userId) async {
    final db = await database;
    return await db.query(
      'metas',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'data DESC',
    );
  }

  Future<int> deleteMeta(int id) async {
    final db = await database;
    return await db.delete('metas', where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para orçamentos
  Future<int> insertOrcamento(Map<String, dynamic> orcamento) async {
    final db = await database;
    return await db.insert('orcamentos', orcamento);
  }

  Future<List<Map<String, dynamic>>> getOrcamentos(int userId, int mes, int ano) async {
    final db = await database;
    return await db.query(
      'orcamentos',
      where: 'userId = ? AND mes = ? AND ano = ?',
      whereArgs: [userId, mes, ano],
    );
  }

  Future<int> updateOrcamento(int id, Map<String, dynamic> orcamento) async {
    final db = await database;
    return await db.update('orcamentos', orcamento, where: 'id = ?', whereArgs: [id]);
  }

  // Métodos para configurações
  Future<int> insertConfig(Map<String, dynamic> config) async {
    final db = await database;
    return await db.insert('configuracoes', config);
  }

  Future<Map<String, dynamic>?> getConfig(int userId) async {
    final db = await database;
    final result = await db.query(
      'configuracoes',
      where: 'userId = ?',
      whereArgs: [userId],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updateConfig(int userId, Map<String, dynamic> config) async {
    final db = await database;
    return await db.update('configuracoes', config, where: 'userId = ?', whereArgs: [userId]);
  }

  // Métodos para pontos
  Future<int> insertPontos(Map<String, dynamic> pontos) async {
    final db = await database;
    return await db.insert('pontos', pontos);
  }

  Future<int> getTotalPontos(int userId) async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(pontos) as total FROM pontos WHERE userId = ?',
      [userId],
    );
    return (result.first['total'] as int?) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getHistoricoPontos(int userId) async {
    final db = await database;
    return await db.query(
      'pontos',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'data DESC',
    );
  }

  // Método para estatísticas
  Future<Map<String, dynamic>> getEstatisticas(int userId) async {
    final db = await database;
    
    final movimentacoes = await db.rawQuery(
      'SELECT COUNT(*) as total FROM movimentacoes WHERE userId = ?',
      [userId],
    );
    
    final metas = await db.rawQuery(
      'SELECT COUNT(*) as total FROM metas WHERE userId = ?',
      [userId],
    );
    
    final resumo = await getResumoFinanceiro(userId);
    final pontos = await getTotalPontos(userId);
    
    return {
      'totalMovimentacoes': movimentacoes.first['total'] as int,
      'totalMetas': metas.first['total'] as int,
      'totalReceitas': resumo['receitas'],
      'totalDespesas': resumo['despesas'],
      'saldo': resumo['saldo'],
      'totalPontos': pontos,
    };
  }

  // Método para limpar dados do usuário
  Future<void> clearUserData(int userId) async {
    final db = await database;
    await db.delete('movimentacoes', where: 'userId = ?', whereArgs: [userId]);
    await db.delete('metas', where: 'userId = ?', whereArgs: [userId]);
    await db.delete('orcamentos', where: 'userId = ?', whereArgs: [userId]);
    await db.delete('pontos', where: 'userId = ?', whereArgs: [userId]);
  }
}