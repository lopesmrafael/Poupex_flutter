# Configuração do Firebase para o Projeto Poupex

## Pré-requisitos
1. Conta no Firebase Console (https://console.firebase.google.com)
2. Flutter CLI instalado
3. FlutterFire CLI instalado (`dart pub global activate flutterfire_cli`)

## Passos para Configuração

### 1. Criar Projeto no Firebase
1. Acesse o Firebase Console
2. Clique em "Adicionar projeto"
3. Digite o nome do projeto (ex: "poupex-app")
4. Configure o Google Analytics (opcional)
5. Clique em "Criar projeto"

### 2. Configurar Authentication
1. No console do Firebase, vá para "Authentication"
2. Clique em "Começar"
3. Na aba "Sign-in method", habilite:
   - Email/Password
   - Google (opcional)
   - Facebook (opcional)

### 3. Configurar Firestore Database
1. No console do Firebase, vá para "Firestore Database"
2. Clique em "Criar banco de dados"
3. **IMPORTANTE**: Escolha "Iniciar no modo de teste" 
4. Selecione a localização do servidor (us-central1 recomendado)
5. As regras de teste permitem acesso total por 30 dias

### 4. Configurar o Projeto Flutter

**Opção A - Com FlutterFire CLI (requer Git):**
1. No terminal, navegue até a pasta do projeto
2. Execute: `flutterfire configure`
3. Selecione o projeto Firebase criado
4. Selecione as plataformas (Android, iOS, Web, etc.)
5. O comando irá gerar o arquivo `firebase_options.dart` automaticamente

**Opção B - Configuração Manual (sem Git):**
1. No Firebase Console, vá para "Configurações do projeto"
2. Na aba "Geral", clique em "Adicionar app" e selecione a plataforma
3. Siga as instruções para cada plataforma:
   - **Android**: Baixe `google-services.json` e coloque em `android/app/`
   - **iOS**: Baixe `GoogleService-Info.plist` e adicione ao projeto iOS
   - **Web**: Copie as configurações do Firebase Config
4. Atualize manualmente o arquivo `firebase_options.dart` com suas configurações

### 5. Configurar Android (se necessário)
1. No Firebase Console, vá para "Configurações do projeto"
2. Na aba "Geral", adicione um app Android
3. Use o package name: `com.example.projeto_pity`
4. Baixe o arquivo `google-services.json`
5. Coloque o arquivo em `android/app/google-services.json`

### 6. Configurar iOS (se necessário)
1. No Firebase Console, adicione um app iOS
2. Use o bundle ID: `com.example.projetoPity`
3. Baixe o arquivo `GoogleService-Info.plist`
4. Adicione o arquivo ao projeto iOS no Xcode

## Estrutura do Banco de Dados Firestore

### Coleções Principais:
- `users/` - Dados dos usuários
  - `{userId}/movimentacoes/` - Movimentações financeiras
  - `{userId}/calendar_events/` - Eventos do calendário
  - `{userId}/metas_financeiras/` - Metas financeiras
  - `{userId}/orcamentos/` - Orçamentos mensais
  - `{userId}/pontos/` - Histórico de pontos
  - `{userId}/resgates/` - Resgates de recompensas

- `dicas_financeiras/` - Dicas financeiras globais

### Regras de Segurança:

**Para Teste (Atual):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // MODO DE TESTE - Permite acesso total
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**Para Produção (Futuro):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      match /{document=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    match /dicas_financeiras/{document} {
      allow read: if request.auth != null;
      allow write: if false;
    }
  }
}
```

## Comandos Úteis
- `flutter pub get` - Instalar dependências
- `flutterfire configure` - Reconfigurar Firebase
- `flutter clean` - Limpar cache do projeto
- `flutter run` - Executar o app

## Troubleshooting
1. **Erro "Unable to find git in your PATH"**: Use a configuração manual (Opção B) ou instale o Git
2. Se houver erro de "Firebase not initialized", verifique se `Firebase.initializeApp()` está sendo chamado no `main()`
3. Se houver erro de permissões, verifique as regras do Firestore
4. Para problemas de build, execute `flutter clean` e `flutter pub get`
5. **Configuração manual do firebase_options.dart**: Substitua os valores placeholder pelas suas configurações reais do Firebase Console