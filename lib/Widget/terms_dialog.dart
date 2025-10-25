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
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
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

  static String _getTermsText() {
    return '''
🧾 TERMO DE USO, POLÍTICA DE PRIVACIDADE E CONSENTIMENTO PARA TRATAMENTO DE DADOS PESSOAIS – POUPEX

Última atualização: 24 de outubro de 2025

O presente documento reúne o Termo de Uso, a Política de Privacidade e o Termo de Consentimento para Tratamento de Dados Pessoais do sistema POUPEX, aplicativo de gestão financeira pessoal, desenvolvido com base na Lei nº 13.709/2018 – Lei Geral de Proteção de Dados Pessoais (LGPD) e nas normas ISO/IEC 27001, 27701 e 29100.

Ao utilizar o sistema POUPEX, o(a) usuário(a) declara que leu, compreendeu e concorda integralmente com as disposições deste documento, autorizando expressamente o tratamento de seus dados pessoais conforme aqui descrito.

📘 1. CONDIÇÕES GERAIS DE USO

O POUPEX é um aplicativo multiplataforma, desenvolvido em Flutter, destinado ao controle e organização das finanças pessoais. O sistema oferece, entre outras, as seguintes funcionalidades:

• Controle de receitas e despesas;
• Definição e acompanhamento de metas financeiras;
• Dashboard e relatórios interativos;
• Gestão de orçamentos mensais;
• Dicas financeiras e sistema de recompensas;
• Configurações personalizadas e login seguro.

O uso do aplicativo é pessoal, intransferível e não comercial, sendo vedada qualquer forma de uso indevido, redistribuição ou exploração ilícita.

🔒 2. COLETA E TRATAMENTO DE DADOS PESSOAIS

O titular autoriza expressamente o tratamento dos seguintes dados pessoais pelo POUPEX, conforme a LGPD:

• Nome completo: identificação do usuário;
• E-mail: autenticação e comunicação;
• Telefone (opcional): recuperação de conta;
• Dados financeiros: controle de receitas, despesas e metas;
• Preferências: tema, moeda e notificações.

⚠️ Observação: mesmo que o sistema não colete dados sensíveis diretamente, tais informações podem estar contidas nos dados inseridos pelo usuário. O POUPEX aplica medidas reforçadas de segurança, em conformidade com a LGPD e normas ISO/IEC 27701 e 29100.

🎯 3. FINALIDADES DO TRATAMENTO

Os dados pessoais serão utilizados exclusivamente para:

• Autenticação e controle de acesso;
• Geração de relatórios e gráficos;
• Personalização da experiência;
• Armazenamento e sincronização de movimentações;
• Comunicação operacional e suporte;
• Auditoria e prevenção de incidentes.

⚙️ 4. BASE LEGAL

O tratamento se fundamenta em:

• Consentimento do titular (art. 7º, I);
• Execução de contrato (art. 7º, V);
• Cumprimento de obrigação legal (art. 7º, II);
• Legítimo interesse (art. 7º, IX).

🚫 5. USOS PROIBIDOS

É vedado ao usuário:

• Inserir conteúdo ilegal, ofensivo ou difamatório;
• Violar direitos de terceiros;
• Manipular ou redistribuir o código do app;
• Acessar dados de outros usuários;
• Usar o sistema para fins comerciais não autorizados.

🧱 6. SEGURANÇA E GOVERNANÇA

O POUPEX aplica boas práticas de segurança e privacidade, incluindo:

• Criptografia;
• Controle de acesso restrito;
• Logs e auditorias internas;
• Anonimização de dados;
• Políticas de confidencialidade e resposta a incidentes.

🤝 7. COMPARTILHAMENTO DE DADOS

Os dados não serão compartilhados com terceiros, salvo:

• Autorização expressa do titular;
• Obrigações legais;
• Suporte técnico sob confidencialidade.

👤 8. DIREITOS DO TITULAR

O titular pode solicitar:

• Confirmação da existência de tratamento;
• Acesso, correção ou exclusão de dados;
• Portabilidade;
• Revogação do consentimento;
• Informações sobre compartilhamento.

🧾 9. CONTROLADOR E ENCARREGADO (DPO)

Controlador: Projeto POUPEX
Encarregado (DPO): [Nome do responsável]
E-mail: [contato@poupex.com]
Telefone: [opcional]

👶 10. DADOS DE CRIANÇAS E ADOLESCENTES

• Dados de menores de 12 anos: apenas com consentimento dos pais;
• Dados de adolescentes: sempre no melhor interesse do titular;
• Medidas reforçadas: criptografia, controle de acesso e monitoramento.

📞 11. CANAL DE COMUNICAÇÃO

Contato oficial:
E-mail: [contato@poupex.com]
Telefone: [opcional]

🔄 12. ATUALIZAÇÕES

Este documento poderá ser atualizado periodicamente, conforme alterações legais ou técnicas.

⚖️ 13. LEGISLAÇÃO E FORO

Regido pela legislação brasileira, especialmente a LGPD (Lei nº 13.709/2018). Foro: comarca do domicílio do titular.

Ao usar o POUPEX, o usuário confirma seu consentimento livre, informado e inequívoco com este Termo de Uso, Política de Privacidade e Consentimento para Tratamento de Dados.
''';
  }
}
