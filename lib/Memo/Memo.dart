import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(home: Memo()));

class MemoItem {
  final String title;
  final String content;
  final DateTime date;
  final String? imagePath;

  MemoItem({
    required this.title,
    required this.content,
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'date': date.toIso8601String(),
      'imagePath': imagePath,
    };
  }

  factory MemoItem.fromJson(Map<String, dynamic> json) {
    return MemoItem(
      title: json['title'],
      content: json['content'],
      date: DateTime.parse(json['date']),
      imagePath: json['imagePath'],
    );
  }

  MemoItem copyWith({
    String? title,
    String? content,
    DateTime? date,
    String? imagePath,
  }) {
    return MemoItem(
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
      imagePath: imagePath ?? this.imagePath,
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
        title: Text('Memo List'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: _memos.isEmpty
          ? Center(child: Text('No memos yet'))
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
                      leading: memo.imagePath != null
                          ? Image.file(
                              File(memo.imagePath!),
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            )
                          : null,
                      title: Text(memo.title),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memo.content,
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
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteMemo(index),
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddMemo,
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
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
  String? _imagePath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _titleController =
        TextEditingController(text: widget.initialMemo?.title ?? '');
    _contentController =
        TextEditingController(text: widget.initialMemo?.content ?? '');
    _imagePath = widget.initialMemo?.imagePath;
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 70);

    if (pickedFile != null) {
      setState(() {
        _imagePath = pickedFile.path;
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
        imagePath: _imagePath,
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
        title: Text(isEditing ? 'Edit Memo' : 'New Memo'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveMemo,
            tooltip: 'Save',
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.multiline,
                minLines: 10,
                maxLines: null,
              ),
            ),
            SizedBox(height: 12),
            if (_imagePath != null)
              Container(
                height: 180,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                ),
                child: Image.file(File(_imagePath!), fit: BoxFit.cover),
              ),
            TextButton.icon(
              icon: Icon(Icons.image),
              label: Text('Pick Image'),
              onPressed: _pickImage,
            ),
          ],
        ),
      ),
    );
  }
}