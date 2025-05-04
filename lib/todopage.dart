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

    
}