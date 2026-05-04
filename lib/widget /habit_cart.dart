import 'package:flutter/material.dart';

class HabitCard extends StatelessWidget {
  final String name;
  final bool isDone;
  final int streak;
  final VoidCallback onCheck;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const HabitCard({
    super.key,
    required this.name,
    required this.isDone,
    required this.streak,
    required this.onCheck,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildCheckButton(),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    decoration: isDone ? TextDecoration.lineThrough : null,
                    color: isDone ? Colors.grey : const Color(0xFF1A1C1E),
                  ),
                ),
                Text(
                  "Série : $streak jours",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          _buildMenu(),
        ],
      ),
    );
  }

  Widget _buildCheckButton() {
    return GestureDetector(
      onTap: onCheck,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: isDone ? const Color(0xFF6C63FF) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isDone ? const Color(0xFF6C63FF) : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: isDone
            ? const Icon(Icons.check, color: Colors.white, size: 20)
            : null,
      ),
    );
  }

  Widget _buildMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.grey),
      onSelected: (value) {
        if (value == 'edit') onEdit();
        if (value == 'delete') onDelete();
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text("Modifier")),
        const PopupMenuItem(
          value: 'delete',
          child: Text("Supprimer", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }
}
