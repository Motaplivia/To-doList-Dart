# Lista de Tarefas - Dart

Uma aplicação simples de lista de tarefas feita em Dart com interface moderna e funcionalidades avançadas.

## ✨ Funcionalidades

- ✅ **Adicionar tarefa** com título e descrição
- ✅ **Marcar tarefa como concluída** com checkbox
- ✅ **Editar tarefa** em modo inline
- ✅ **Remover tarefa**
- ✅ **Contador de tarefas pendentes**
- ✅ **Interface responsiva** para mobile
- ✅ **Design moderno** com tema rosa

## 🚀 Como Executar

1. **Instalar dependências:**
   ```bash
   dart pub get
   ```

2. **Compilar e executar:**
   ```bash
   ./run.sh
   ```

3. **Acesse:** `http://localhost:8080`

## 📁 Estrutura do Projeto

```
├── lib/
│   └── main.dart          # Código principal em Dart
├── web/
│   ├── index.html         # Interface HTML + CSS
│   └── main.dart.js       # JavaScript compilado
├── pubspec.yaml           # Configuração do projeto
├── run.sh                 # Script de execução
└── README.md              # Documentação
```

## 🧠 Principais Funções e Classes

### 📦 **Importações Utilizadas**
```dart
import 'dart:html';  // Manipulação do DOM
```

### 🎯 **Funções Principais**

#### **`main()`** - Função de Inicialização
```dart
void main() {
  // Aguarda o DOM estar pronto
  document.addEventListener('DOMContentLoaded', (event) {
    // Inicializa a aplicação
  });
}
```

#### **`updateList()`** - Atualização da Interface
```dart
void updateList() {
  // Atualiza a lista de tarefas
  // Gerencia modo de edição
  // Atualiza contador de pendentes
}
```

### 🏗️ **Classes e Elementos DOM**

#### **Elementos de Entrada**
```dart
InputElement taskTitleInput      // Campo de título
TextAreaElement taskDescriptionInput  // Campo de descrição
ButtonElement addButton          // Botão adicionar
```

#### **Elementos de Lista**
```dart
UListElement taskList            // Lista de tarefas
LIElement li                     // Item individual da lista
DivElement taskContent           // Conteúdo da tarefa
```

#### **Elementos de Controle**
```dart
InputElement checkbox            // Checkbox para marcar concluída
ButtonElement editButton         // Botão editar
ButtonElement removeButton       // Botão remover
ButtonElement saveButton         // Botão salvar (modo edição)
ButtonElement cancelButton       // Botão cancelar (modo edição)
```

#### **Elementos de Interface**
```dart
DivElement countSpan             // Contador de pendentes
DivElement emptyState            // Estado vazio
SpanElement icon                 // Ícones Font Awesome
```

### 📊 **Estruturas de Dados**

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

#### **Controle de Edição**
```dart
int editingIndex = -1;  // Índice da tarefa sendo editada
```

### 🎨 **Classes CSS Utilizadas**

#### **Layout Principal**
```css
.container          /* Container principal */
.input-group        /* Grupo de entrada */
.task-content       /* Conteúdo da tarefa */
.button-group       /* Grupo de botões */
```

#### **Estados das Tarefas**
```css
.completed          /* Tarefa concluída */
.task-checkbox      /* Checkbox personalizado */
.task-title         /* Título da tarefa */
.task-description   /* Descrição da tarefa */
```

#### **Botões de Ação**
```css
.add-button         /* Botão adicionar */
.edit-btn           /* Botão editar (verde) */
.remove-btn         /* Botão remover (rosa) */
.save-btn           /* Botão salvar (verde) */
.cancel-btn         /* Botão cancelar (rosa) */
```

#### **Campos de Edição**
```css
.edit-title-input       /* Campo de título editável */
.edit-description-input /* Campo de descrição editável */
```

### 🔄 **Event Listeners**

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

### 🎯 **Funcionalidades Avançadas**

#### **Modo de Edição Inline**
- ✅ Campos editáveis aparecem no lugar do texto
- ✅ Botões "Salvar" e "Cancelar" substituem "Editar" e "Remover"
- ✅ Validação de título obrigatório
- ✅ Foco automático no campo de título

#### **Gerenciamento de Estado**
- ✅ Controle de qual tarefa está sendo editada
- ✅ Ajuste automático de índices ao remover tarefas
- ✅ Preservação do estado de edição

#### **Interface Responsiva**
- ✅ Layout adaptável para mobile
- ✅ Botões reorganizados em telas pequenas
- ✅ Tamanho de fonte otimizado para evitar zoom

## 🎮 Como Usar

1. **Adicionar Tarefa:**
   - Digite o título no campo "Título da tarefa"
   - Opcional: adicione uma descrição
   - Clique em "Adicionar Tarefa" ou pressione Enter

2. **Marcar como Concluída:**
   - Clique no checkbox ao lado da tarefa
   - A tarefa ficará riscada e com opacidade reduzida

3. **Editar Tarefa:**
   - Clique no botão "Editar" (verde)
   - Os campos ficam editáveis inline
   - Clique "Salvar" para confirmar ou "Cancelar" para descartar

4. **Remover Tarefa:**
   - Clique no botão "Remover" (rosa)
   - A tarefa é removida imediatamente

## 🛠️ Tecnologias Utilizadas

- **Dart** - Linguagem principal
- **HTML5** - Estrutura da página
- **CSS3** - Estilização com gradientes e animações
- **JavaScript** - Compilado a partir do Dart
- **Font Awesome** - Ícones
- **Python HTTP Server** - Servidor local para desenvolvimento

## 📱 Compatibilidade

- ✅ Chrome, Firefox, Safari, Edge
- ✅ Dispositivos móveis (responsivo)
- ✅ Navegadores modernos com suporte a ES6+ 