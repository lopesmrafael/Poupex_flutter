import 'package:flutter/material.dart';
import '../Pages/HomePage.dart';

class TermsDialog extends StatelessWidget {
  const TermsDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 400),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'TERMOS DE USO',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF327355),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _getTermsText(),
                  style: const TextStyle(fontSize: 12, height: 1.4),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('NEGAR'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3EA860),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('ACEITAR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getTermsText() {
    return '''TERMO DE USO DO SISTEMA "POUPEX"

Este Termo de Uso ("Termo") é um acordo legal entre você, o(a) usuário(a) do sistema "POUPEX", e os desenvolvedores do Projeto "POUPEX" (doravante denominado "POUPEX" ou "Nós"), um sistema pensado para gestão financeira pessoal.

Ao acessar ou utilizar o "POUPEX", você manifesta sua concordância integral com este Termo de Uso, com a Política de Privacidade e com a Lei Geral de Proteção de Dados Pessoais (LGPD – Lei nº 13.709/2018). Se você não concordar com estes termos, não deverá utilizar o sistema.

CLÁUSULA PRIMEIRA – DAS CONDIÇÕES GERAIS DE USO

O "POUPEX" é destinado ao controle e gestão de finanças pessoais, oferecendo funcionalidades de acompanhamento de receitas, despesas, metas financeiras e relatórios.

CLÁUSULA SEGUNDA – DA COLETA E USO DE DADOS PESSOAIS

O usuário declara estar ciente da coleta e uso dos seguintes dados pelo "POUPEX", que visam exclusivamente o funcionamento da aplicação:

• Nome completo - para identificação do usuário
• E-mail - para autenticação e comunicação
• Telefone - para contato e recuperação de conta
• Dados financeiros - para cálculos e relatórios

CLÁUSULA TERCEIRA – FINALIDADE DA COLETA

A coleta dos dados mencionados tem finalidades específicas e essenciais para a operação do "POUPEX" e a conformidade com a LGPD:

• Autenticação e controle de acesso
• Personalização da experiência do usuário
• Geração de relatórios financeiros
• Comunicação sobre atualizações do sistema

CLÁUSULA QUARTA – VEDAÇÕES DO USO

O usuário compromete-se a não utilizar o "POUPEX" para qualquer finalidade ilícita ou que viole este Termo de Uso, incluindo:

• Carregar conteúdo ilegal, difamatório, obsceno ou prejudicial.
• Acessar, alterar ou danificar contas de outros usuários.
• Violar direitos de propriedade intelectual ou outros direitos de terceiros.

CLÁUSULA QUINTA – ACEITAÇÃO IMPLÍCITA

O uso do Sistema "POUPEX" implica em concordância integral e incondicional com este Termo de Uso.

CLÁUSULA SEXTA – DA PROTEÇÃO DOS DADOS

O "POUPEX" compromete-se a adotar medidas técnicas e administrativas em conformidade com a LGPD:

• Criptografia dos arquivos armazenados.
• Banco de dados seguro, com autenticação robusta e acesso restrito.
• Políticas de segurança da informação e plano de resposta a incidentes.

CLÁUSULA SÉTIMA – DO COMPARTILHAMENTO DE DADOS

Os dados armazenados não serão compartilhados com terceiros, exceto:

• Quando autorizado expressamente pelo titular.
• Mediante obrigação legal ou ordem judicial.
• Para auxílio técnico restrito e necessário.

CLÁUSULA OITAVA – DOS DIREITOS DO TITULAR DOS DADOS

Em conformidade com a LGPD, o sistema deve permitir ao usuário exercer seus direitos, incluindo:

• Exclusão da conta e dos arquivos.
• Revogação do consentimento a qualquer momento.
• Solicitação de informações sobre o uso de seus dados.

CLÁUSULA NONA – DA RESPONSABILIDADE NA EXATIDÃO DOS DADOS

O usuário é responsável pela exatidão, veracidade e atualização dos dados fornecidos.

O "POUPEX" não se responsabiliza por inconsistências inseridas pelo usuário.

CLÁUSULA DÉCIMA – DA TRANSPARÊNCIA

O "POUPEX" garante a transparência sobre o tratamento dos dados pessoais.

Os direitos dos usuários serão atendidos em até 48 horas para confirmação e até 15 dias para demandas complexas.

CLÁUSULA DÉCIMA PRIMEIRA – DO TRATAMENTO DE DADOS DE CRIANÇAS E ADOLESCENTES

O "POUPEX" observa as disposições do art. 14 da LGPD, quando aplicáveis, quanto ao tratamento de dados de crianças e adolescentes.

CLÁUSULA DÉCIMA SEGUNDA – DISPOSIÇÕES GERAIS

O presente Termo pode ser atualizado periodicamente para refletir mudanças legais ou operacionais.

Este Termo é regido pela legislação brasileira e pela LGPD.''';
  }
}