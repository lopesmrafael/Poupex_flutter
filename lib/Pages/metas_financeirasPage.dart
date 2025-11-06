import 'package:flutter/material.dart';
import '../repository/meta_financeira_repository_simple.dart';
import '../repository/theme_manager.dart';
import '../repository/achievement_system.dart';

class MetasFinanceirasScreen extends StatefulWidget {
  const MetasFinanceirasScreen({Key? key}) : super(key: key);

  @override
  State<MetasFinanceirasScreen> createState() => _MetasFinanceirasScreenState();
}

class _MetasFinanceirasScreenState extends State<MetasFinanceirasScreen> {
  final MetaFinanceiraRepositorySimple _repository = MetaFinanceiraRepositorySimple();
  final AchievementSystem _achievementSystem = AchievementSystem();
  List<Map<String, dynamic>> _metas = [];
  String? _statusSelecionado;

  @override
  void initState() {
    super.initState();
    _carregarMetas();
  }

  void _carregarMetas() async {
    try {
      final metas = await _repository.listarMetas();
      setState(() {
        _metas = metas;
      });
    } catch (e) {
      // Ignora erro se não conseguir carregar
    }
  }

  // Abre formulário para cadastrar nova meta
  void _abrirFormulario() {
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController valorController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              backgroundColor: const Color(0xFF3D8361),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: const Text(
                "Cadastrar Meta",
                style: TextStyle(color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Título",
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  TextField(
                    controller: valorController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: "Valor (R\$)",
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Dropdown para status
                  DropdownButtonFormField<String>(
                    dropdownColor: const Color(0xFF1B4332),
                    value: _statusSelecionado,
                    decoration: const InputDecoration(
                      labelText: "Status",
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white70)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                    ),
                    items: [
                      "Planejada",
                      "Prioridade Baixa",
                      "Prioridade Média",
                      "Prioridade Alta",
                    ].map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              margin: const EdgeInsets.only(right: 8),
                              decoration: BoxDecoration(
                                color: _getStatusColor(status),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Text(status, style: const TextStyle(color: Colors.white)),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setStateDialog(() {
                        _statusSelecionado = value;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancelar", style: TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    if (tituloController.text.isNotEmpty &&
                        valorController.text.isNotEmpty &&
                        _statusSelecionado != null) {
                      try {
                        await _repository.criarMeta(
                          titulo: tituloController.text,
                          valor: double.tryParse(valorController.text) ?? 0,
                          status: _statusSelecionado!,
                        );
                        _carregarMetas();
                        
                        // Verificar conquistas
                        final novasConquistas = await _achievementSystem.verificarMeta();
                        
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Meta criada com sucesso!')),
                        );
                        
                        // Mostrar conquistas desbloqueadas
                        for (String conquistaId in novasConquistas) {
                          final conquista = AchievementSystem.conquistas[conquistaId];
                          if (conquista != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🏆 Conquista: ${conquista['titulo']}! +${conquista['pontos']} pontos'),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 3),
                              ),
                            );
                          }
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Erro: $e')),
                        );
                      }
                    }
                  },
                  child: const Text("Salvar"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "planejada":
        return Colors.blue;
      case "prioridade baixa":
        return Colors.orange;
      case "prioridade média":
        return Colors.amber;
      case "prioridade alta":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeManager.backgroundColor,
      appBar: AppBar(
        backgroundColor: ThemeManager.appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ThemeManager.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Metas Financeiras',
          style: TextStyle(
            color: ThemeManager.textColor,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Botão cadastrar meta
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _abrirFormulario,
              child: const Text(
                "Cadastrar Meta",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Lista de Metas
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _metas.length,
              itemBuilder: (context, index) {
                final meta = _metas[index];
                return _buildMetaItem(
                  meta["titulo"] ?? '',
                  "R\$ ${meta['valor']?.toStringAsFixed(2) ?? '0.00'}",
                  meta["status"] ?? 'Planejada',
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem(String titulo, String valor, String status) {
    final cor = _getStatusColor(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ThemeManager.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título + Valor
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titulo,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                valor,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Status colorido
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: cor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
