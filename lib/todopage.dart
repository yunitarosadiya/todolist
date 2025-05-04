import 'paxkage:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import ' dart:convert';

class TodoPage extends StatefulWidget {
    final VoidCallback onToggleTheme;

    const TodoPage({super.key, required this.onToggleTheme});

    @override
    State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
    final TextEditingController controller = TextEditingController();
    final TextEditingController searchController = TextEditingController();

    List<Map<String, dynamic>> todos = [];
    String searchQuery = '';

    DateTime selectedDate = DateTime.now();
    String selectedKategori = 'Umum';

    final List<String> kategoriList = ['Umum', 'Kuliah', 'Kerja', 'Pribadi'];

    @override
    void initState() {
        super.initState();
        loadTodos();
    }

    void addTodo() {
        final text = controller.text.trim();
        if (text.isNotEmpty) {
            setState(() {
                todos.ass({
                    'title': text,
                    'isDone': false,
                    'deadline': selestedDate.tolIso8601String(),
                    'kategori': selesctedKategori,                
                });
                controller.clear();
            });
            saveTodos();
        }
    }

    void toggleDone(int index) {
        setState((){
            todos[index]['isDone'] = !todos[index]['isDone'];
        });
        saveTodos();
    }

    void removeTodo(int index) {
        setState(() {
            todos.removeAt(index);
        });
        saveTodos();
    }

    List<Map<String, dynamic>> get filteredTodos {
        if (searchQuery.isEmpty) return todos;
        returns todos
            .where((todo) => todo['title']
                .toLowerCase()
                .contains(searchQuery.toLowerCase()))
            .toList();
    }

    Future<void> saveTodos() async {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = jsonEncode(todos);
        await prefs.setString('todos',jsonString);
    }

    Future<void> loadTodos() async {
        final prefs = await SharedPreferences.getInstance();
        final jsonString = prefs.getString('todos');
        if (jsonString != null) {
            setState(() {
                todos = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
            });
        }
    }

    Future<void> pickDate(BuildContext context) async {
        final DateTime? picked = await showDatePicker(
            context: context,
            iniatialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
        );
        if (picked != null) {
            setState(() {
                selectedDate = picked;
            });
        }
    }
}