# 💰 POUPEX - Aplicativo de Gestão Financeira

## 📱 Sobre o Projeto

O **POUPEX** é um aplicativo Flutter completo para gestão financeira pessoal, desenvolvido com arquitetura moderna e backend robusto. O app oferece controle total das finanças pessoais com interface intuitiva e funcionalidades profissionais.

## 🎯 Funcionalidades Principais

### 🔐 **Sistema de Autenticação Completo**
- **Login** com validações robustas (email válido, senha mínima)
- **Cadastro** com verificação de usuários duplicados
- **Redefinição de senha** funcional
- **Logout** com limpeza de dados
- **Persistência de sessão** durante uso do app
- **Validações** de campos obrigatórios

### 🏠 **Tela Principal (HomePage)**
- **Menu em grid** com 8 funcionalidades principais
- **Navegação intuitiva** entre todos os módulos
- **Design responsivo** e moderno
- **Botões funcionais** de configurações e perfil

### 📊 **Dashboard Financeiro**
- **Resumo financeiro** em tempo real
- **Gráficos interativos** com fl_chart
- **Cards dinâmicos** de receitas e despesas
- **Saldo atual** calculado automaticamente
- **Dados sincronizados** com movimentações

### 💸 **Controle de Movimentações**
- **Cadastro** de receitas e despesas
- **Histórico completo** de transações
- **Cálculos automáticos** de totais
- **Validações** de entrada
- **Persistência** durante sessão
- **Ordenação** por data

### 🎯 **Metas Financeiras**
- **CRUD completo** de metas
- **Status coloridos** por prioridade (Planejada, Baixa, Média, Alta)
- **Acompanhamento** de progresso
- **Validações** de campos
- **Interface** intuitiva para cadastro

### 📅 **Calendário Financeiro**
- **Eventos financeiros** organizados por data
- **Interface** visual atrativa
- **Navegação** por meses
- **Categorização** de eventos

### 💡 **Dicas Financeiras**
- **Biblioteca** de dicas educativas
- **Fallback** para dados locais
- **Interface** visual com ícones
- **Carregamento** assíncrono
- **Conteúdo** educativo sobre finanças

### 💰 **Orçamento Mensal**
- **Gestão completa** de orçamentos
- **Categorias** (Renda, Gastos Fixos, Variáveis)
- **Cálculos automáticos** de totais
- **Persistência mensal** de dados
- **Validações** de tipos numéricos

### 🏆 **Sistema de Recompensas**
- **Pontuação** por ações no app
- **Interface** de recompensas
- **Histórico** de pontos
- **Gamificação** da experiência

### 📈 **Relatórios Financeiros**
- **Análises** de gastos
- **Interface** preparada para gráficos
- **Exportação** de dados

### 🔧 **Configurações Funcionais**
- **Notificações** - Toggle ativo/inativo
- **Modo Escuro** - Alternância de tema
- **Biometria** - Configuração de login
- **Moeda** - Seleção (BRL, USD, EUR)
- **Exportar Dados** - Simulação de download
- **Limpar Cache** - Limpeza de dados
- **Logout** - Saída com confirmação

### 👤 **Perfil Completo**
- **Avatar** com iniciais do usuário
- **Informações pessoais** (nome, email, telefone)
- **Resumo financeiro** dinâmico
- **Estatísticas reais** (transações, metas, pontos)
- **Dados da conta** (membro desde, último acesso)

## 🏗️ Arquitetura do Projeto

### 📁 **Estrutura de Pastas Detalhada**

```
lib/
├── 📁 Model/                           # Modelos de dados
│   ├── meta_financeira.dart           # Modelo completo de metas
│   ├── financial_event.dart           # Eventos do calendário
│   ├── MenuItem.dart                  # Itens do menu principal
│   ├── reward.dart                    # Sistema de recompensas
│   └── dicas_item.dart               # Modelo de dicas financeiras
│
├── 📁 Pages/                          # Telas do aplicativo
│   ├── 🔐 LoginPage.dart             # Tela de login funcional
│   ├── 🔐 CadastroPage.dart          # Cadastro com validações
│   ├── 🔐 redefinirSenhaPage.dart    # Redefinir senha
│   ├── 🏠 HomePage.dart              # Menu principal
│   ├── 📊 DashboardFinanPage.dart    # Dashboard com gráficos
│   ├── 💸 CadastroMovimentacao.dart  # Movimentações financeiras
│   ├── 🎯 metas_financeirasPage.dart # Gestão de metas
│   ├── 📅 CalendarioFinanceiroPage.dart # Calendário
│   ├── 💡 dicas_de_financas.dart     # Dicas educativas
│   ├── 🏆 reward_page.dart           # Sistema de recompensas
│   ├── 💰 orcamentoMensalPage.dart   # Orçamento mensal
│   ├── 📈 relatorioFinanceiroPage.dart # Relatórios
│   ├── ⚙️ ConfiguracoesPage.dart     # Configurações funcionais
│   └── 👤 PerfilPage.dart            # Perfil do usuário
│
├── 📁 repository/                     # Camada de dados (Backend)
│   ├── 🔐 auth_repository.dart       # Autenticação robusta
│   ├── 📊 data_manager.dart          # Gerenciador central
│   ├── ⚙️ config_repository.dart     # Configurações
│   ├── 💸 movimentacao_repository.dart # Movimentações
│   ├── 🎯 meta_financeira_repository_simple.dart # Metas
│   ├── 💰 orcamento_repository_simple.dart # Orçamentos
│   ├── 📅 calendar_repository.dart   # Calendário
│   ├── 🏆 reward_repository.dart     # Recompensas
│   └── 💡 dicas_repository.dart      # Dicas financeiras
│
├── 📁 Widget/                         # Componentes reutilizáveis
│   ├── MenuCard.dart                 # Cards do menu
│   ├── calendar_widget.dart          # Widget do calendário
│   └── reward_card.dart              # Cards de recompensa
│
└── main.dart                         # Ponto de entrada
```

## 🔧 Backend Robusto

### 🏗️ **Arquitetura em Camadas**

```
📱 UI Layer (Pages)
    ↕️ Comunicação
🏪 Repository Layer (Business Logic)
    ↕️ Gerenciamento
📊 DataManager (Storage Central)
    ↕️ Persistência
💾 In-Memory Storage (Dados da Sessão)
```

### 🔐 **AuthRepository - Autenticação Profissional**
```dart
✅ Validação de email (formato @)
✅ Senha mínima de 6 caracteres
✅ Verificação de usuários duplicados
✅ Persistência de usuários cadastrados
✅ Gestão de sessão completa
✅ Atualização de perfil
✅ Logout com limpeza de dados
```

### 📊 **DataManager - Gerenciador Central**
```dart
✅ Storage centralizado de todos os dados
✅ Sincronização entre repositories
✅ Cálculo de estatísticas em tempo real
✅ Limpeza de dados por usuário
✅ Performance otimizada com cache
✅ Validações de usuário logado
```

### ⚙️ **ConfigRepository - Configurações Funcionais**
```dart
✅ Notificações (ativar/desativar)
✅ Modo escuro (tema claro/escuro)
✅ Biometria (login biométrico)
✅ Moeda (BRL, USD, EUR)
✅ Persistência de configurações
✅ Feedback visual de mudanças
```

### 💸 **MovimentacaoRepository - Transações**
```dart
✅ CRUD completo de movimentações
✅ Cálculo automático de resumo financeiro
✅ Validações de entrada
✅ Ordenação por data
✅ Categorização de transações
```

### 🎯 **MetaFinanceiraRepository - Metas**
```dart
✅ Criação de metas com validações
✅ Status coloridos por prioridade
✅ Acompanhamento de progresso
✅ Listagem ordenada por data
✅ Exclusão de metas
```

### 💰 **OrcamentoRepository - Orçamentos**
```dart
✅ Gestão de orçamentos mensais
✅ Categorias (Renda, Fixos, Variáveis)
✅ Cálculos precisos de totais
✅ Persistência por mês/ano
✅ Validações de tipos numéricos
```

## 📊 Dados e Estatísticas

### 🔄 **Fluxo de Dados em Tempo Real**
- **Movimentações** → **Dashboard** (gráficos atualizados)
- **Metas** → **Perfil** (contador de metas)
- **Transações** → **Estatísticas** (totais calculados)
- **Configurações** → **Interface** (preferências aplicadas)

### 📈 **Estatísticas Calculadas Automaticamente**
```dart
✅ Total de receitas
✅ Total de despesas  
✅ Saldo atual (receitas - despesas)
✅ Número de transações
✅ Número de metas ativas
✅ Total de pontos acumulados
```

## 🎨 Design e Interface

### 🎨 **Paleta de Cores Consistente**
- **Verde Principal**: `#54A781` (Fundo principal)
- **Verde Escuro**: `#327355` (AppBar e elementos)
- **Verde Botão**: `#3EA860` (Botões secundários)
- **Branco**: `#FFFFFF` (Texto e campos)

### 📱 **Componentes Visuais**
- **Cards arredondados** com sombras suaves
- **Ícones consistentes** em todas as páginas
- **Gráficos interativos** com fl_chart
- **Animações fluidas** entre telas
- **Design responsivo** para diferentes tamanhos
- **Feedback visual** em todas as ações

## 🚀 Como Executar

### 📋 **Pré-requisitos**
- Flutter SDK 3.8.1+
- Dart 3.0+
- Android Studio / VS Code

### 🔧 **Instalação e Execução**

```bash
# 1. Clone o repositório
git clone [url-do-repositorio]
cd poupex-flutter

# 2. Instale as dependências
flutter pub get

# 3. Execute o aplicativo
flutter run
```

### 🧪 **Como Testar Todas as Funcionalidades**

#### 1. **Autenticação**
```
✅ Login: Use qualquer email válido + senha (mín. 6 chars)
✅ Cadastro: Preencha todos os campos obrigatórios
✅ Redefinir: Digite email válido para simular envio
```

#### 2. **Movimentações Financeiras**
```
✅ Cadastre receitas (valores positivos)
✅ Cadastre despesas (valores negativos)
✅ Veja totais atualizados no Dashboard
✅ Histórico ordenado por data
```

#### 3. **Metas Financeiras**
```
✅ Clique "Cadastrar Meta"
✅ Preencha título, valor e status
✅ Veja metas com cores por prioridade
✅ Dados persistem entre navegações
```

#### 4. **Orçamento Mensal**
```
✅ Adicione rendas, gastos fixos e variáveis
✅ Clique "Confirmar" para salvar
✅ Veja totais calculados automaticamente
✅ Dados salvos por mês/ano
```

#### 5. **Configurações**
```
✅ Toggle notificações (feedback visual)
✅ Ative/desative modo escuro
✅ Configure biometria
✅ Altere moeda (BRL/USD/EUR)
✅ Teste logout com confirmação
```

#### 6. **Perfil**
```
✅ Veja dados reais do usuário
✅ Estatísticas dinâmicas atualizadas
✅ Resumo financeiro em tempo real
✅ Contadores de transações e metas
```

## 📦 Dependências Principais

```yaml
dependencies:
  flutter: sdk
  firebase_core: ^3.6.0          # Preparado para Firebase
  cloud_firestore: ^5.4.4        # Banco de dados (futuro)
  firebase_auth: ^5.3.1          # Autenticação (futuro)
  fl_chart: ^0.69.0              # Gráficos funcionais
  flutter_multi_formatter: ^2.3.0 # Máscaras de input
  sqflite: ^2.4.2                # Banco local (futuro)
  cupertino_icons: ^1.0.8        # Ícones iOS
```

## 🛡️ Validações e Segurança

### ✅ **Validações Implementadas**
- **Email**: Formato válido obrigatório
- **Senha**: Mínimo 6 caracteres
- **Campos obrigatórios**: Verificação em todos os formulários
- **Usuário logado**: Verificação antes de operações
- **Tipos numéricos**: Validação em valores monetários
- **Duplicatas**: Prevenção de usuários duplicados

### 🔒 **Segurança**
- **Sessão**: Gestão segura de login/logout
- **Dados**: Isolamento por usuário
- **Validações**: Em todas as camadas
- **Sanitização**: Limpeza de dados de entrada

## ⚡ Performance e Otimizações

### 🚀 **Otimizações Implementadas**
- **Lazy loading** de dados
- **Cache inteligente** no DataManager
- **Sincronização eficiente** entre repositories
- **Cálculos otimizados** de estatísticas
- **Garbage collection** automático
- **Carregamento assíncrono** em todas as páginas

## 🔄 Estados do Projeto

### ✅ **Atual (Totalmente Funcional)**
- ✅ **10+ páginas** totalmente funcionais
- ✅ **Backend robusto** com validações
- ✅ **Dados persistentes** durante sessão
- ✅ **Configurações** funcionais
- ✅ **Estatísticas** em tempo real
- ✅ **Interface** responsiva e moderna
- ✅ **Navegação** fluida entre módulos
- ✅ **Validações** em todas as operações

### 🔄 **Próximos Passos (Opcional)**
- 🔥 **Firebase** real para produção
- 💾 **SQLite** para persistência local
- 🔄 **Sincronização** offline
- 🧪 **Testes** unitários e integração
- 📊 **Analytics** de uso
- 🔔 **Notificações** push reais

## 🤝 Contribuição

1. Fork o projeto
2. Crie uma branch para sua feature
3. Commit suas mudanças
4. Push para a branch
5. Abra um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

---

## ✨ **RESULTADO FINAL**

**🎉 APLICATIVO TOTALMENTE FUNCIONAL COM:**
- ✅ **Arquitetura profissional** em camadas
- ✅ **Backend robusto** com validações
- ✅ **10+ páginas** interligadas e funcionais
- ✅ **Sistema de autenticação** completo
- ✅ **Gestão financeira** completa
- ✅ **Configurações** funcionais
- ✅ **Dados persistentes** na sessão
- ✅ **Interface moderna** e responsiva
- ✅ **Performance otimizada**
- ✅ **Código limpo** e manutenível

**O POUPEX é um aplicativo de gestão financeira completo e profissional!** 🚀💰

---

**Desenvolvido com ❤️ usando Flutter**