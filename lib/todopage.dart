import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'about_page.dart';

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
                todos.add({
                    'title': text,
                    'isDone': false,
                    'deadline': selectedDate.toIso8601String(),
                    'kategori': selectedKategori,                
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
        return todos
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
            initialDate: selectedDate,
            firstDate: DateTime.now(),
            lastDate: DateTime(2101),
        );
        if (picked != null) {
            setState(() {
                selectedDate = picked;
            });
        }
    }

    void editTodo(int index) {
        final todo = todos[index];
        final TextEditingController editController = TextEditingController(text: todo['title']);
        DateTime editDate = DateTime.parse(todo['deadline']);
        String editKategori= todo['kategori'];

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                title: const Text('Edit Agenda'),
                content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        TextField(
                            controller: editController,
                            decoration: const InputDecoration(labelText: 'Agenda'),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                            value: editKategori,
                            decoration: const InputDecoration(labelText:'Kategori'),
                            items: kategoriList.map((kategori) => DropdownMenuItem(
                                value: kategori,
                                child: Text(kategori),
                            )).toList(),
                            onChanged: (value) {
                                if (value != null) {
                                    editKategori = value;
                                }
                            },
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                            onPressed: () async {
                                final picked = await showDatePicker(
                                    context: context,
                                    initialDate: editDate,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                );
                                if (picked != null) {
                                    setState(() {
                                        editDate = picked;
                                    });
                                }
                        },
                        icon: const Icon(Icons.calendar_today),
                        label: Text(DateFormat.yMd().format(editDate)),
                        ),
                    ],
                ),
                actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                    ),
                    ElevatedButton(
                        onPressed: () {
                            setState(() {
                                todos[index]['title'] = editController.text.trim();
                                todos[index]['kategori'] = editKategori;
                                todos[index]['deadline'] = editDate.toIso8601String();
                            });
                            saveTodos();
                            Navigator.pop(context);
                        },
                        child: const Text('Simpan'),
                    ),
                ],
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Scaffold(
            appBar: AppBar(
                title: const Text(
                    'Agenda',
                    style: TextStyle(fontFamily: 'Tagesschrift'),
                    ),
                actions: [
                    IconButton(
                        icon: const Icon(Icons.brightness_6),
                        onPressed: widget.onToggleTheme,
                    ),

                    IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const AboutPage()),
                            );
                        },
                    ),
                ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                    children: [
                        TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                labelText: 'Cari Agenda',
                                labelStyle: TextStyle(fontFamily: 'Tagesschrift'),
                                prefixIcon: Icon(Icons.search),
                                border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                                setState(() {
                                    searchQuery = value;
                                });
                            },
                        ),
                        const SizedBox(height: 8),
                        TextField(
                            controller: controller,
                            decoration: const InputDecoration(
                                labelText: 'Tambah Agenda',
                                labelStyle: TextStyle(fontFamily: 'Tagesschrift'),
                                border: OutlineInputBorder(),
                            ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                            children: [
                                Expanded(
                                    child: DropdownButtonFormField<String>(
                                        value: selectedKategori,
                                        decoration: const InputDecoration(
                                            labelText: 'Kategori',
                                            labelStyle: TextStyle(fontFamily: 'Tagesschrift'),
                                            border: OutlineInputBorder(),
                                        ),
                                        items: kategoriList
                                            .map((kategori) => DropdownMenuItem(
                                                value: kategori,
                                                child: Text(kategori),
                                            ))
                                            .toList(),
                                        onChanged: (value) {
                                            if (value != null) {
                                                setState(() {
                                                    selectedKategori = value;
                                                });
                                            }
                                        },
                                    ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                    onPressed: () => pickDate(context),
                                    icon: const Icon(Icons.calendar_today),
                                    label: Text(DateFormat.yMd().format(selectedDate)),
                                ),
                            ],
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                            onPressed: addTodo,
                            icon: const Icon(Icons.add),
                            label: const Text(
                                'Tambah',
                                style: TextStyle(fontFamily: 'Tagesschrift'),
                                ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                            child: filteredTodos.isEmpty
                                ? const Center(child: Text(
                                    'Belum ada agenda',
                                    style: TextStyle(fontFamily: 'Tagesschrift'),
                                    ),)
                                : ListView.builder(
                                    itemCount: filteredTodos.length,
                                    itemBuilder: (context, index) {
                                        final todo = filteredTodos[index];
                                        final realIndex = todos.indexOf(todo);
                                        return Card(
                                            color: isDark ? Colors.grey[800] : Colors.white,
                                            child: ListTile(
                                                title: Text(
                                                    todo['title'],
                                                    style: TextStyle(
                                                        fontFamily: 'Tagesschrift',
                                                        decoration: todo['isDone']
                                                            ? TextDecoration.lineThrough
                                                            : TextDecoration.none,
                                                    ),
                                                ),
                                                subtitle: Text(
                                                    '${todo["kategori"]} - Deadline: ${DateFormat.yMd().format(DateTime.parse(todo["deadline"]))}',
                                                ),
                                                leading: Checkbox(
                                                    value: todo['isDone'],
                                                    onChanged: (value) => toggleDone(realIndex),
                                                ),
                                                trailing: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                        IconButton(
                                                            icon: const Icon(Icons.edit),
                                                            onPressed: () => editTodo(realIndex),
                                                        ),
                                                        IconButton(
                                                            icon: const Icon(Icons.delete),
                                                            onPressed: () => removeTodo(realIndex),
                                                        ),
                                                    ],
                                                ),
                                            ),
                                        );
                                    },
                                ),
                        ),
                    ],
                ),
            ),
        );
    }
}