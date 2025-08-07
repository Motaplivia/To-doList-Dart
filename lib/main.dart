import 'dart:html';
import 'dart:convert';

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
    final paginationContainer = querySelector('#paginationContainer') as DivElement?;
    
    if (taskTitleInput == null || addButton == null || taskList == null || countSpan == null || emptyState == null || paginationContainer == null) {
      print('Erro: Elementos não encontrados!');
      return;
    }
    
    print('Elementos encontrados!');
    
    List<Map<String, dynamic>> tasks = [];
    int editingIndex = -1; // Índice da tarefa sendo editada (-1 = nenhuma)
    
    // Variáveis de paginação
    int currentPage = 1;
    int itemsPerPage = 5;
    
    // Função para salvar tarefas no localStorage
    void saveTasksToStorage() {
      try {
        final tasksJson = jsonEncode(tasks);
        window.localStorage['todo_tasks'] = tasksJson;
        print('Tarefas salvas no localStorage: ${tasks.length} tarefas');
      } catch (e) {
        print('Erro ao salvar tarefas: $e');
      }
    }
    
    // Função para carregar tarefas do localStorage
    void loadTasksFromStorage() {
      try {
        final tasksJson = window.localStorage['todo_tasks'];
        if (tasksJson != null && tasksJson.isNotEmpty) {
          final List<dynamic> tasksList = jsonDecode(tasksJson);
          tasks = tasksList.map((task) => Map<String, dynamic>.from(task)).toList();
          print('Tarefas carregadas do localStorage: ${tasks.length} tarefas');
        } else {
          print('Nenhuma tarefa encontrada no localStorage');
        }
      } catch (e) {
        print('Erro ao carregar tarefas: $e');
        tasks = []; // Reset para lista vazia em caso de erro
      }
    }
    
    // Função para calcular o total de páginas
    int getTotalPages() {
      return (tasks.length / itemsPerPage).ceil();
    }
    
    // Função para obter tarefas da página atual
    List<Map<String, dynamic>> getCurrentPageTasks() {
      int startIndex = (currentPage - 1) * itemsPerPage;
      int endIndex = startIndex + itemsPerPage;
      if (endIndex > tasks.length) {
        endIndex = tasks.length;
      }
      return tasks.sublist(startIndex, endIndex);
    }
    
    // Declarar funções como late para evitar dependência circular
    late void Function() updateList;
    late void Function() updatePagination;
    
    // Função para atualizar a paginação
    updatePagination = () {
      paginationContainer!.children.clear();
      
      int totalPages = getTotalPages();
      
      if (totalPages <= 1) {
        paginationContainer!.style.display = 'none';
        return;
      }
      
      paginationContainer!.style.display = 'flex';
      
      // Botão anterior
      final prevButton = ButtonElement()
        ..text = '‹'
        ..className = 'pagination-btn'
        ..disabled = currentPage == 1;
      
      prevButton.addEventListener('click', (event) {
        if (currentPage > 1) {
          currentPage--;
          updateList();
        }
      });
      
      paginationContainer!.append(prevButton);
      
      // Números das páginas
      for (int i = 1; i <= totalPages; i++) {
        final pageButton = ButtonElement()
          ..text = '$i'
          ..className = 'pagination-btn';
        
        if (i == currentPage) {
          pageButton.className += ' active';
        }
        
        pageButton.addEventListener('click', (event) {
          currentPage = i;
          updateList();
        });
        
        paginationContainer!.append(pageButton);
      }
      
      // Botão próximo
      final nextButton = ButtonElement()
        ..text = '›'
        ..className = 'pagination-btn'
        ..disabled = currentPage == totalPages;
      
      nextButton.addEventListener('click', (event) {
        if (currentPage < totalPages) {
          currentPage++;
          updateList();
        }
      });
      
      paginationContainer!.append(nextButton);
    };
    
    // Função para atualizar a lista
    updateList = () {
      if (tasks.isEmpty) {
        taskList!.style.display = 'none';
        emptyState!.style.display = 'block';
        paginationContainer!.style.display = 'none';
      } else {
        taskList!.style.display = 'block';
        emptyState!.style.display = 'none';
        
        // Ajustar página atual se necessário
        int totalPages = getTotalPages();
        if (currentPage > totalPages && totalPages > 0) {
          currentPage = totalPages;
        }
        
        // Obter tarefas da página atual
        List<Map<String, dynamic>> currentPageTasks = getCurrentPageTasks();
        
        taskList!.children.clear();
        for (int i = 0; i < currentPageTasks.length; i++) {
          final task = currentPageTasks[i];
          final globalIndex = (currentPage - 1) * itemsPerPage + i;
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
            tasks[globalIndex]['completed'] = checkbox.checked;
            saveTasksToStorage(); // Salvar após alteração
            updateList();
          });
          
          final taskContent = DivElement()
            ..className = 'task-content';
          
          if (editingIndex == globalIndex) {
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
                  tasks[globalIndex]['title'] = newTitle;
                  tasks[globalIndex]['description'] = newDescription;
                  saveTasksToStorage(); // Salvar após edição
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
                editingIndex = globalIndex; // Entrar no modo de edição
                updateList();
              });
            
            // Botão remover
            final removeButton = ButtonElement()
              ..text = 'Remover'
              ..className = 'remove-btn'
              ..onClick.listen((_) {
                tasks.removeAt(globalIndex);
                saveTasksToStorage(); // Salvar após remoção
                if (editingIndex == globalIndex) {
                  editingIndex = -1; // Sair do modo de edição se estava editando
                } else if (editingIndex > globalIndex) {
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
      
      // Atualizar paginação
      updatePagination();
    };
    
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
        
        // Ir para a última página quando adicionar uma nova tarefa
        currentPage = getTotalPages();
        
        saveTasksToStorage(); // Salvar após adicionar
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
    
    // Carregar tarefas do localStorage na inicialização
    loadTasksFromStorage();
    
    // Inicializar
    updateList();
    print('Aplicação inicializada com sucesso!');
  });
} 