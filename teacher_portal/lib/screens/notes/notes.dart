import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class NotesWidget extends StatefulWidget {
  const NotesWidget({super.key});

  @override
  _NotesWidgetState createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _searchTagController = TextEditingController();
  List<Map<String, dynamic>> notes = [];

  final String apiUrl = dotenv.env['IPv4'] ?? '';
  final String apiPort = dotenv.env['API_PORT'] ?? '8000';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Load all notes when View Notes tab is selected
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        loadAllNotes();
      }
    });
  }

  // Save new note to the server
  Future<void> saveNote() async {
    if (_noteController.text.isEmpty || _tagController.text.isEmpty || _nameController.text.isEmpty) return;

    final response = await http.post(
      Uri.parse('$apiUrl:$apiPort/notes/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "name": _nameController.text,
        "tag": _tagController.text,
        "content": _noteController.text,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Note saved')));
      _noteController.clear();
      _tagController.clear();
      _nameController.clear();
    }
  }

  // Load all notes from the server
  Future<void> loadAllNotes() async {
    final response = await http.get(Uri.parse('$apiUrl:$apiPort/notes/'));
    if (response.statusCode == 200) {
      setState(() {
        notes = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    }
  }

  // Search notes by tag
  Future<void> searchNotes(String tag) async {
    final response = await http.get(
      Uri.parse('$apiUrl:$apiPort/notes/search?tag=${tag.trim()}'),
    );
    if (response.statusCode == 200) {
      setState(() {
        notes = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'Write Note'),
            Tab(text: 'View Notes'),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 17, 84, 185),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Write Note Tab
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text("Create a Note", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Note Name', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tagController,
                      decoration: const InputDecoration(labelText: 'Tag', border: OutlineInputBorder()),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _noteController,
                      decoration: const InputDecoration(labelText: 'Note', border: OutlineInputBorder()),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: saveNote,
                      icon: const Icon(Icons.save),
                      label: const Text('Save Note'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 17, 84, 185),
                        foregroundColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),

          // View Notes Tab
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchTagController,
                  onChanged: (value) {
                    if (value.trim().isEmpty) {
                      loadAllNotes(); // Reload all notes when input is cleared
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Search by Tag',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => searchNotes(_searchTagController.text),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: notes.isEmpty
                      ? const Center(child: Text('No notes found.'))
                      : ListView.builder(
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return ExpansionTile(
                              title: Text(note['name']),
                              subtitle: Text('Tag: ${note['tag']}'),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(note['content']),
                                )
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _noteController.dispose();
    _tagController.dispose();
    _nameController.dispose();
    _searchTagController.dispose();
    super.dispose();
  }
}
