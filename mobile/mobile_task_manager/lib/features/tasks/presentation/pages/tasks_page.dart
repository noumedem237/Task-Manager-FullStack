import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../../data/models/task_model.dart';
import '../controllers/tasks_controller.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final _titleController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _titleController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TasksController>();
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F2),
      appBar: AppBar(
        title: const Text('Mes tâches'),
        backgroundColor: AppTheme.orange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            tooltip: 'Actualiser',
            onPressed: controller.load,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Se déconnecter',
            onPressed: auth.logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.tasks.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.orange),
          );
        }

        return RefreshIndicator(
          color: AppTheme.orange,
          onRefresh: controller.load,
          child: ListView.builder(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 32),
            itemCount: controller.tasks.length + 2,
            itemBuilder: (context, index) {
              if (index == 0) return _creationForm(controller);
              if (index == 1) return _sectionHeader(controller);
              final task = controller.tasks[index - 2];
              return _dismissibleTask(controller, task);
            },
          ),
        );
      }),
    );
  }

  Widget _creationForm(TasksController controller) => Card(
        color: Colors.white,
        elevation: 2,
        shadowColor: AppTheme.orange.withValues(alpha: 0.20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Ajouter une tâche',
                style: TextStyle(
                  color: Color(0xFF6B2C00),
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _titleController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.done,
                maxLength: 150,
                onSubmitted: (_) => _create(controller),
                decoration: InputDecoration(
                  hintText: 'Que devez-vous faire ?',
                  counterText: '',
                  filled: true,
                  fillColor: const Color(0xFFFFF4EA),
                  prefixIcon: const Icon(Icons.edit_outlined, color: AppTheme.orange),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: controller.isSaving.value ? null : () => _create(controller),
                icon: controller.isSaving.value
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: Text(controller.isSaving.value ? 'Ajout en cours…' : 'Ajouter la tâche'),
              ),
              if (controller.error.value.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(controller.error.value, style: const TextStyle(color: Colors.red)),
              ],
            ],
          ),
        ),
      );

  Widget _sectionHeader(TasksController controller) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 24, 4, 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Mes tâches', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            Text('${controller.tasks.length}', style: const TextStyle(color: AppTheme.orange, fontWeight: FontWeight.w800)),
          ],
        ),
      );

  Widget _dismissibleTask(TasksController controller, TaskModel task) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Dismissible(
          key: ValueKey(task.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24),
            decoration: BoxDecoration(color: const Color(0xFFC94B16), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.delete_outline, color: Colors.white),
          ),
          confirmDismiss: (_) => _confirmAndDelete(controller, task.id),
          child: Card(
            color: Colors.white,
            elevation: 1,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              leading: IconButton(
                tooltip: 'Marquer comme terminée',
                onPressed: controller.isSaving.value ? null : () => controller.toggleCompletion(task),
                icon: Icon(
                  task.status == TaskStatus.done ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: AppTheme.orange,
                ),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  decoration: task.status == TaskStatus.done ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: task.description?.isNotEmpty == true ? Text(task.description!) : null,
              trailing: IconButton(
                tooltip: 'Supprimer',
                icon: const Icon(Icons.delete_outline, color: Color(0xFFC94B16)),
                onPressed: () => _confirmAndDelete(controller, task.id),
              ),
            ),
          ),
        ),
      );

  Future<void> _create(TasksController controller) async {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      Get.snackbar('Titre requis', 'Saisissez une tâche avant de l’ajouter.');
      _focusNode.requestFocus();
      return;
    }
    final created = await controller.create(title, '', TaskStatus.todo);
    if (created) {
      _titleController.clear();
      _focusNode.requestFocus();
    }
  }

  Future<bool> _confirmAndDelete(TasksController controller, int id) async {
    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Supprimer cette tâche ?'),
        content: const Text('Cette action est définitive.'),
        actions: [
          TextButton(onPressed: () => Get.back(result: false), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.orange, foregroundColor: Colors.white),
            onPressed: () => Get.back(result: true),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
    if (confirmed != true) return false;
    final deleted = await controller.delete(id);
    if (!deleted) Get.snackbar('Suppression impossible', controller.error.value);
    // The controller already removes the item after DELETE succeeds. Returning
    // false avoids Dismissible attempting a second removal during its animation.
    return false;
  }
}
