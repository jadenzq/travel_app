import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:travel_app/Memo/memo_edit_page.dart';
import 'package:travel_app/Models/memo_item.dart';

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

  // Retrieve memo json from local storage, convert all json memo to MemoItem and save into `_memos` list
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

  // Convert the `_memos` list into json list and store inside local storage
  Future<void> _saveMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final String memosJson = jsonEncode(
      _memos.map((memo) => memo.toJson()).toList(),
    );
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
        title: Text('Memo List', style: GoogleFonts.ubuntu(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body:
          _memos.isEmpty
              ? Center(child: Text('No memos yet', style: GoogleFonts.ubuntu()))
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
                        minTileHeight: 100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(10),
                        ),
                        tileColor: Colors.white,
                        leading:
                            (memo.imagePaths.isNotEmpty)
                                ? Image.file(
                                  File(memo.imagePaths.first),
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                )
                                : null,
                        title: Text(
                          memo.title,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: GoogleFonts.ubuntu(fontSize: 24),
                        ),
                        // subtitle: Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Text(
                        //       memo.content,
                        //       style: GoogleFonts.ubuntu(fontSize: 16),
                        //       maxLines: 1,
                        //       overflow: TextOverflow.ellipsis,
                        //     ),
                        //     SizedBox(height: 4),
                        //     Text(
                        //       formatDateTime(memo.date),
                        //       style: TextStyle(
                        //         fontSize: 12,
                        //         color: Colors.grey,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        onTap: () => _navigateToEditMemo(index),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
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
