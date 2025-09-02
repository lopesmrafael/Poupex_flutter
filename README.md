# Poupe X
<!-- Substitua pelo nome do projeto -->

## Descrição
Muitas pessoas gastam dinheiro ao longo do mês sem perceber para onde ele está indo. No final do mês, elas se surpreendem ao ver que gastaram mais do que o previsto e não conseguem economizar por falta de planejamento. O aplicativo vai fazer o planejamento financeiro do cliente, listar gastos fixos, variáveis, o quanto ela quer economizar e quanto economizou. Dando ao usuário a opção de gerenciar suas finanças pessoais de maneira eficaz.

<!-- Escreva aqui um resumo do projeto, sua finalidade e principais funcionalidades -->

## Integrantes
<!-- Liste todos os integrantes do grupo no formato Nome - Matrícula -->
- Rafael Lopes Monteiro - 22301518
- Luis Otavio Galdino Costa - 22301500
- Davi Navarro Silva - 22301208
- Igor Lima - 22301402

## Estrutura de Diretórios
<!-- Mostre a estrutura básica do projeto -->
```
projeto/
├── lib/               # Código-fonte principal
├── docs/              # Documentação
├── test/              # Testes automatizados
└── README.md          # Arquivo de descrição do projeto
```

## Como Executar o Projeto

### 📋 1. Pré-requisitos

Antes de começar, certifique-se de ter o ambiente configurado com os seguintes itens:

🧰 Linguagens e Ferramentas

Flutter SDK
 (versão 3.13.0 ou superior)

Dart (instalado com o Flutter)

Firebase CLI: npm install -g firebase-tools

Android Studio, VSCode ou outro editor compatível

Emulador Android/iOS ou dispositivo físico

📦 Dependências principais (em pubspec.yaml)

firebase_core

firebase_auth

cloud_firestore

provider (ou outro gerenciador de estado, como get, se usado)

flutter_dotenv (se utilizar variáveis de ambiente)

🗃️ Banco de Dados

Cloud Firestore (Firebase)

### ⚙️ 2. Instalação
# Clone o repositório
git clone [https://github.com/seu-usuario/poupex_flutter.git](https://github.com/lopesmrafael/Poupex_flutter.git)

# Acesse a pasta do projeto
cd poupex_flutter

# Instale as dependências do Flutter
flutter pub get

### ▶️ 3. Execução
🔐 Configuração do Firebase

Crie um projeto no Firebase Console
.

Ative os seguintes serviços:

Authentication (método de e-mail/senha)

Cloud Firestore

Adicione o arquivo google-services.json (Android) e/ou GoogleService-Info.plist (iOS) nas pastas correspondentes:

android/app/google-services.json

ios/Runner/GoogleService-Info.plist

🚀 Rodando o app
# Execute em um emulador ou dispositivo físico
flutter run


💡 Para rodar no navegador (modo web), use:

flutter run -d chrome

### 🌐 4. Acesso
🔗 Acesso local (em modo web)

URL: http://localhost:5000 (ao rodar via Chrome)

👤 Credenciais de teste

Usuário: admin@example.com

Senha: admin123

Ou crie uma conta nova diretamente pelo app.

🧱 Estrutura (MVC Simplificado)
lib/
├── models/         # Modelos de dados
├── views/          # Telas e Widgets
├── controllers/    # Lógica de controle
├── services/       # Integrações com Firebase e APIs
├── main.dart       # Ponto de entrada da aplicação

✅ Funcionalidades

 Cadastro e login de usuários

 Integração com Firebase Auth

 Gravação e leitura em tempo real com Cloud Firestore

 Estrutura MVC para melhor organização

 Interface responsiva

📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo LICENSE
 para mais detalhes.

## Observações
<!-- Coloque aqui informações adicionais, como problemas conhecidos, melhorias futuras ou instruções extras -->
README_updated.md
Exibindo README_updated.md…
