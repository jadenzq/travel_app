import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(MaterialApp(
  home: Memo(),
  theme: ThemeData(
    textTheme: GoogleFonts.ubuntuTextTheme(),
  ),
));

class MemoItem {
  final String title;
  final String content;
  final DateTime date;
  final List<String> imagePaths;

  MemoItem({
    required this.title,
    required this.content,
    required this.date,
    this.imagePaths = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'imagePaths': imagePaths,
    };
  }

  factory MemoItem.fromJson(Map<String, dynamic> json) {
    return MemoItem(
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      imagePaths: List<String>.from(json['imagePaths'] ?? []),
    );
  }

  MemoItem copyWith({
    String? title,
    String? content,
    DateTime? date,
    List<String>? imagePaths,
  }) {
    return MemoItem(
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      imagePaths: imagePaths ?? this.imagePaths,
    );
  }
}

class Memo extends StatefulWidget {
  @override
  _MemoListPageState createState() => _MemoListPageState();
}

class _MemoListPageState extends State<Memo> {
  List<MemoItem> _memos = [];

  @override
  void initState() {
    super.initState();
    _loadMemos();
  }

  Future<void> _loadMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? memosJson = prefs.getString('memos');
    if (memosJson != null) {
      final List<dynamic> decoded = jsonDecode(memosJson);
      setState(() {
        _memos = decoded.map((item) => MemoItem.fromJson(item)).toList();
      });
    }
  }

  Future<void> _saveMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final String memosJson =
        jsonEncode(_memos.map((memo) => memo.toJson()).toList());
    await prefs.setString('memos', memosJson);
  }

  void _navigateToAddMemo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MemoEditPage()),
    );

    if (result != null && result is MemoItem) {
      setState(() {
        _memos.add(result);
      });
      await _saveMemos();
    }
  }

  void _navigateToEditMemo(int index) async {
    final originalMemo = _memos[index];

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoEditPage(initialMemo: originalMemo),
      ),
    );

    if (result != null && result is MemoItem) {
      setState(() {
        _memos[index] = result;
      });
      await _saveMemos();
    }
  }

  void _deleteMemo(int index) async {
    setState(() {
      _memos.removeAt(index);
    });
    await _saveMemos();
  }

  String formatDateTime(DateTime date) {
    return '${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)} '
        '${_twoDigits(date.hour)}:${_twoDigits(date.minute)}';
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Memo List',style: GoogleFonts.ubuntu(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Color(0xff41729f),
      ),
      body: _memos.isEmpty
          ? Center(child: Text('No memos yet',style: GoogleFonts.ubuntu()))
          : ListView.builder(
              itemCount: _memos.length,
              itemBuilder: (context, index) {
                final memo = _memos[index];
                return Dismissible(
                  key: Key('${memo.title}-$index'),
                  onDismissed: (_) => _deleteMemo(index),
                  background: Container(
                    color: Colors.redAccent,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    child: ListTile(
                      leading: (memo.imagePaths.isNotEmpty)
                          ? Image.file(
                              File(memo.imagePaths.first),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : null,
                      title: Text(memo.title,style: GoogleFonts.ubuntu(fontSize: 24)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memo.content,
                            style: GoogleFonts.ubuntu(fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            formatDateTime(memo.date),
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () => _navigateToEditMemo(index),
                      trailing: IconButton(
                        icon: Icon(Icons.delete,color: Colors.red),
                        onPressed: () => _deleteMemo(index),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddMemo,
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Color(0xff41729f),
      ),
    );
  }
}

class MemoEditPage extends StatefulWidget {
  final MemoItem? initialMemo;

  const MemoEditPage({this.initialMemo});

  @override
  _MemoEditPageState createState() => _MemoEditPageState();
}

class _MemoEditPageState extends State<MemoEditPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  List<String> _imagePaths = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialMemo?.title ?? '');
    _contentController = TextEditingController(text: widget.initialMemo?.content ?? '');
    _imagePaths = List.from(widget.initialMemo?.imagePaths ?? []);
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage(imageQuality: 70);
    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        _imagePaths.addAll(pickedFiles.map((e) => e.path));
        if (_imagePaths.length > 9) {
          _imagePaths = _imagePaths.sublist(0, 9);
        }
      });
    }
  }

  void _saveMemo() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isNotEmpty || content.isNotEmpty) {
      final newMemo = MemoItem(
        title: title,
        content: content,
        date: DateTime.now(),
        imagePaths: _imagePaths,
      );
      Navigator.pop(context, newMemo);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialMemo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Memo' : 'New Memo',style: GoogleFonts.ubuntu(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Color(0xff41729f),
        actions: [
          IconButton(
            icon: Icon(Icons.check,color: Colors.black,),
            onPressed: _saveMemo,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_imagePaths.isNotEmpty)
              Container(
                height: 200,
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: _imagePaths.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: Image.file(
                            File(_imagePaths[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imagePaths.removeAt(index);
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(2),
                              color: Colors.black54,
                              child: Icon(Icons.close, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            SizedBox(height: 12),
            TextField(
              controller: _titleController,
              style: GoogleFonts.ubuntu(fontSize: 28),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: GoogleFonts.ubuntu(fontSize: 28),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                style: GoogleFonts.ubuntu(fontSize: 16),
                decoration: InputDecoration(
                  labelText: 'Content',
                  labelStyle: GoogleFonts.ubuntu(fontSize: 16),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: null,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
              IconButton(icon: Icon(Icons.check_circle_outline), onPressed: () {}),
              IconButton(icon: Icon(Icons.format_align_left), onPressed: () {}),
              IconButton(icon: Icon(Icons.image), onPressed: _pickImages),
              IconButton(icon: Icon(Icons.attach_file), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}