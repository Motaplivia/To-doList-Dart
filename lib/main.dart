import 'dart:html';

void main() {
  print('Iniciando aplicação...');
  
  // Aguardar o DOM estar pronto
  document.addEventListener('DOMContentLoaded', (event) {
    print('DOM carregado!');
    
    // Elementos da interface
    final taskTitleInput = querySelector('#taskTitle') as InputElement?;
    final taskDescriptionInput = querySelector('#taskDescription') as TextAreaElement?;
    final addButton = querySelector('#addButton') as ButtonElement?;
    final taskList = querySelector('#taskList') as UListElement?;
    final countSpan = querySelector('#count') as DivElement?;
    final emptyState = querySelector('#emptyState') as DivElement?;
    
    if (taskTitleInput == null || addButton == null || taskList == null || countSpan == null || emptyState == null) {
      print('Erro: Elementos não encontrados!');
      return;
    }
    
    print('Elementos encontrados!');
    
    List<Map<String, dynamic>> tasks = [];
    int editingIndex = -1; // Índice da tarefa sendo editada (-1 = nenhuma)
    
    // Função para atualizar a lista
    void updateList() {
      if (tasks.isEmpty) {
        taskList!.style.display = 'none';
        emptyState!.style.display = 'block';
      } else {
        taskList!.style.display = 'block';
        emptyState!.style.display = 'none';
        
        taskList!.children.clear();
        for (int i = 0; i < tasks.length; i++) {
          final task = tasks[i];
          final li = LIElement();
          
          // Adicionar classe se concluída
          if (task['completed'] == true) {
            li.className = 'completed';
          }
          
          // Checkbox para marcar como concluída
          final checkbox = InputElement()
            ..type = 'checkbox'
            ..className = 'task-checkbox'
            ..checked = task['completed'] == true;
          
          checkbox.addEventListener('change', (event) {
            tasks[i]['completed'] = checkbox.checked;
            updateList();
          });
          
          final taskContent = DivElement()
            ..className = 'task-content';
          
          if (editingIndex == i) {
            // Modo de edição
            final editTitleInput = InputElement()
              ..className = 'edit-title-input'
              ..value = task['title'] ?? '';
            
            final editDescriptionInput = TextAreaElement()
              ..className = 'edit-description-input'
              ..value = task['description'] ?? '';
            
            taskContent.append(editTitleInput);
            taskContent.append(editDescriptionInput);
            
            // Botões de ação no modo de edição
            final buttonGroup = DivElement()
              ..className = 'button-group';
            
            // Botão salvar
            final saveButton = ButtonElement()
              ..text = 'Salvar'
              ..className = 'save-btn'
              ..onClick.listen((_) {
                final newTitle = editTitleInput.value?.trim() ?? '';
                final newDescription = editDescriptionInput.value?.trim() ?? '';
                
                if (newTitle.isNotEmpty) {
                  tasks[i]['title'] = newTitle;
                  tasks[i]['description'] = newDescription;
                  editingIndex = -1; // Sair do modo de edição
                  updateList();
                } else {
                  window.alert('Por favor, insira um título para a tarefa.');
                }
              });
            
            // Botão cancelar
            final cancelButton = ButtonElement()
              ..text = 'Cancelar'
              ..className = 'cancel-btn'
              ..onClick.listen((_) {
                editingIndex = -1; // Sair do modo de edição
                updateList();
              });
            
            buttonGroup.append(saveButton);
            buttonGroup.append(cancelButton);
            
            li.append(checkbox);
            li.append(taskContent);
            li.append(buttonGroup);
            
            // Focar no campo de título
            editTitleInput.focus();
            
          } else {
            // Modo de visualização
            final taskTitle = DivElement()
              ..className = 'task-title'
              ..text = task['title'] ?? '';
            
            taskContent.append(taskTitle);
            
            if (task['description']?.isNotEmpty == true) {
              final taskDescription = DivElement()
                ..className = 'task-description'
                ..text = task['description'] ?? '';
              taskContent.append(taskDescription);
            }
            
            // Botões de ação no modo de visualização
            final buttonGroup = DivElement()
              ..className = 'button-group';
            
            // Botão editar
            final editButton = ButtonElement()
              ..text = 'Editar'
              ..className = 'edit-btn'
              ..onClick.listen((_) {
                editingIndex = i; // Entrar no modo de edição
                updateList();
              });
            
            // Botão remover
            final removeButton = ButtonElement()
              ..text = 'Remover'
              ..className = 'remove-btn'
              ..onClick.listen((_) {
                tasks.removeAt(i);
                if (editingIndex == i) {
                  editingIndex = -1; // Sair do modo de edição se estava editando
                } else if (editingIndex > i) {
                  editingIndex--; // Ajustar índice se necessário
                }
                updateList();
              });
            
            buttonGroup.append(editButton);
            buttonGroup.append(removeButton);
            
            li.append(checkbox);
            li.append(taskContent);
            li.append(buttonGroup);
          }
          
          taskList!.append(li);
        }
      }
      
      // Atualizar contador de tarefas pendentes
      final pendingCount = tasks.where((task) => task['completed'] != true).length;
      
      final icon = SpanElement()
        ..innerHtml = '<i class="fas fa-clock"></i>';
      countSpan!.children.clear();
      countSpan!.append(icon);
      countSpan!.append(Text(' Tarefas pendentes: $pendingCount'));
    }
    
    // Adicionar tarefa
    addButton!.addEventListener('click', (event) {
      final title = taskTitleInput!.value?.trim() ?? '';
      final description = taskDescriptionInput?.value?.trim() ?? '';
      
      print('Clicou no botão! Título: "$title"');
      
      if (title.isNotEmpty) {
        tasks.add({
          'title': title,
          'description': description,
          'completed': false,
        });
        taskTitleInput!.value = '';
        if (taskDescriptionInput != null) {
          taskDescriptionInput!.value = '';
        }
        updateList();
        print('Tarefa adicionada! Total: ${tasks.length}');
      } else {
        print('Título vazio!');
        window.alert('Por favor, insira um título para a tarefa.');
      }
    });
    
    // Enter para adicionar
    taskTitleInput!.addEventListener('keypress', (event) {
      if (event is KeyboardEvent && event.keyCode == 13) { // Enter
        addButton!.click();
      }
    });
    
    // Inicializar
    updateList();
    print('Aplicação inicializada com sucesso!');
  });
} 