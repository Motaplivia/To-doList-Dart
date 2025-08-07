# To-Do List em Dart

Uma aplicação simples de lista de tarefas desenvolvida em Dart para web.

<img width="479" height="920" alt="Image" src="https://github.com/user-attachments/assets/1ab57ac8-73c1-418e-9be5-86f2420f13f5" />

## Funcionalidades

- ✅ Adicionar tarefas com título e descrição
- ✅ Editar tarefas existentes
- ✅ Marcar tarefas como concluídas
- ✅ Remover tarefas
- ✅ Paginação - 5 tarefas por página
- ✅ Persistência de dados em localStorage
- ✅ Interface responsiva e moderna
- ✅ Design com gradientes e animações

## Estrutura do Projeto

```
To-doList-Dart/
├── lib/
│   └── main.dart          # Lógica principal da aplicação
├── web/
│   ├── index.html         # Interface HTML
│   ├── style.css          # Estilos CSS
│   └── main.dart.js       # JavaScript compilado
├── pubspec.yaml           # Configurações do projeto
└── README.md             # Documentação
```

## Tecnologias

- **Dart** - Linguagem de programação
- **HTML5** - Estrutura da página
- **CSS3** - Estilização e animações
- **localStorage** - Persistência de dados
- **Font Awesome** - Ícones

## Principais Funções e Classes

### 🔧 **Funções de Persistência**

#### **`saveTasksToStorage()`**
```dart
void saveTasksToStorage() {
  final tasksJson = jsonEncode(tasks);
  window.localStorage['todo_tasks'] = tasksJson;
}
```
- **Função:** Salva a lista de tarefas no localStorage
- **Chamada:** Após adicionar, editar, remover ou marcar tarefa
- **Tratamento:** Try-catch para tratamento de erros

#### **`loadTasksFromStorage()`**
```dart
void loadTasksFromStorage() {
  final tasksJson = window.localStorage['todo_tasks'];
  if (tasksJson != null) {
    final List<dynamic> tasksList = jsonDecode(tasksJson);
    tasks = tasksList.map((task) => Map<String, dynamic>.from(task)).toList();
  }
}
```
- **Função:** Carrega tarefas do localStorage na inicialização
- **Execução:** Chamada automaticamente ao iniciar a aplicação
- **Fallback:** Lista vazia em caso de erro

### 📊 **Funções de Paginação**

#### **`getTotalPages()`**
```dart
int getTotalPages() {
  return (tasks.length / itemsPerPage).ceil();
}
```
- **Função:** Calcula o número total de páginas
- **Retorno:** Número inteiro de páginas necessárias
- **Uso:** Para gerar botões de paginação

#### **`getCurrentPageTasks()`**
```dart
List<Map<String, dynamic>> getCurrentPageTasks() {
  int startIndex = (currentPage - 1) * itemsPerPage;
  int endIndex = startIndex + itemsPerPage;
  return tasks.sublist(startIndex, endIndex);
}
```
- **Função:** Obtém tarefas da página atual
- **Retorno:** Lista de tarefas da página específica
- **Uso:** Para renderizar apenas tarefas visíveis

### 🎨 **Funções de Interface**

#### **`updateList()`**
```dart
void updateList() {
  // Renderiza lista de tarefas
  // Atualiza contador de pendentes
  // Chama updatePagination()
}
```
- **Função:** Atualiza toda a interface da lista
- **Responsabilidades:**
  - Renderiza tarefas da página atual
  - Gerencia modo de edição
  - Atualiza contador de pendentes
  - Chama paginação

#### **`updatePagination()`**
```dart
void updatePagination() {
  // Cria botões de navegação
  // Gerencia estados ativo/desabilitado
  // Adiciona event listeners
}
```
- **Função:** Cria e atualiza controles de paginação
- **Elementos:** Botões anterior, números, próximo
- **Estados:** Ativo, desabilitado, hover

### 🏗️ **Classes e Elementos DOM**

#### **Elementos de Entrada**
```dart
InputElement taskTitleInput        // Campo de título
TextAreaElement taskDescriptionInput  // Campo de descrição
ButtonElement addButton            // Botão adicionar
```

#### **Elementos de Lista**
```dart
UListElement taskList              // Lista de tarefas
LIElement li                       // Item individual
DivElement taskContent             // Conteúdo da tarefa
```

#### **Elementos de Controle**
```dart
InputElement checkbox              // Checkbox para marcar
ButtonElement editButton           // Botão editar
ButtonElement removeButton         // Botão remover
ButtonElement saveButton           // Botão salvar
ButtonElement cancelButton         // Botão cancelar
```

#### **Elementos de Interface**
```dart
DivElement countSpan               // Contador de pendentes
DivElement emptyState              // Estado vazio
DivElement paginationContainer     // Container de paginação
SpanElement icon                   // Ícones Font Awesome
```

### 📋 **Estruturas de Dados**

#### **Lista de Tarefas**
```dart
List<Map<String, dynamic>> tasks = [
  {
    'title': 'Título da tarefa',
    'description': 'Descrição da tarefa',
    'completed': false
  }
];
```

#### **Controle de Estado**
```dart
int editingIndex = -1;            // Índice da tarefa sendo editada
int currentPage = 1;              // Página atual
int itemsPerPage = 5;             // Itens por página
```

### 🎯 **Event Listeners**

#### **Eventos de Clique**
```dart
addButton.addEventListener('click', ...)      // Adicionar tarefa
editButton.onClick.listen(...)                // Entrar modo edição
removeButton.onClick.listen(...)              // Remover tarefa
saveButton.onClick.listen(...)                // Salvar edição
cancelButton.onClick.listen(...)              // Cancelar edição
```

#### **Eventos de Teclado**
```dart
taskTitleInput.addEventListener('keypress', ...)  // Enter para adicionar
```

#### **Eventos de Mudança**
```dart
checkbox.addEventListener('change', ...)      // Marcar como concluída
```

### 🔄 **Fluxo de Dados**

1. **Inicialização:** `loadTasksFromStorage()` → `updateList()`
2. **Adicionar:** Validação → Adiciona → `saveTasksToStorage()` → `updateList()`
3. **Editar:** `editingIndex = globalIndex` → `updateList()` → Modo edição
4. **Salvar:** Validação → Atualiza → `saveTasksToStorage()` → `updateList()`
5. **Remover:** Remove → `saveTasksToStorage()` → `updateList()`
6. **Marcar:** Atualiza → `saveTasksToStorage()` → `updateList()`


## Como Executar

1. **Instalar dependências:**
   ```bash
   dart pub get
   ```

2. **Compilar o projeto:**
   ```bash
   dart compile js lib/main.dart -o web/main.dart.js
   ```

3. **Executar o servidor:**
   ```bash
   python -m http.server 8080 --directory web
   ```

4. **Acessar no navegador:**
   ```
   http://localhost:8080
   ```
