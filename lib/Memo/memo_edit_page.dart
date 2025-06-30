import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travel_app/Map/location_list_tile.dart';
import 'package:travel_app/Map/map_page.dart';
import 'package:travel_app/Models/autocomplete_prediction.dart';
import 'package:travel_app/Models/memo_item.dart';
import 'package:travel_app/Models/place_autocomplete_response.dart';
import 'package:travel_app/Utilities/network_utility.dart';

class MemoEditPage extends StatefulWidget {
  final MemoItem? initialMemo;

  const MemoEditPage({this.initialMemo});

  @override
  _MemoEditPageState createState() => _MemoEditPageState();
}

class _MemoEditPageState extends State<MemoEditPage> {
  late TextEditingController _titleController;
  late QuillController _quillController;
  final FocusNode _editorFocusNode = FocusNode();
  final ImagePicker _picker = ImagePicker();
  List<String> _imagePaths = [];
  bool _showToolbar = false;
  List<AutocompletePrediction> savedLocations = [];
  List<AutocompletePrediction> placePredictions = [];

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController(
      text: widget.initialMemo?.title ?? '',
    );
    _imagePaths = List.from(widget.initialMemo?.imagePaths ?? []);

    final Document doc =
        widget.initialMemo != null
            ? Document.fromJson(jsonDecode(widget.initialMemo!.content))
            : Document();

    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );

    savedLocations = widget.initialMemo?.savedLocations ?? [];
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
    final contentJson = jsonEncode(
      _quillController.document.toDelta().toJson(),
    );

    if (title.isNotEmpty) {
      final newMemo = MemoItem(
        title: title,
        content: contentJson,
        date: DateTime.now(),
        imagePaths: _imagePaths,
        savedLocations: savedLocations,
      );
      Navigator.pop(context, newMemo);
    } else {
      return;
    }
  }

  void placeAutocomplete(String query, StateSetter setModalState) async {
    Uri uri = Uri.https("places.googleapis.com", "v1/places:autocomplete", {
      "key": "AIzaSyCLxYn-Dgp1r1Qp2HbIubEc-egYC1_xb9E",
    });

    String? response = await NetworkUtility.postRequest(
      uri,
      body: <String, String>{"input": query},
    );

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.placePredictions != null) {
        setState(() {
          placePredictions = result.placePredictions!;
        });
        // To reflect placePrediction changes in the UI of the Bottom Sheet Modal
        setModalState(() {});
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _quillController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialMemo != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Memo' : 'New Memo',
          style: GoogleFonts.ubuntu(fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: Colors.black),
            onPressed: _saveMemo,
            tooltip: 'Save',
          ),
        ],
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: TextField(
                controller: _titleController,
                style: GoogleFonts.ubuntu(fontSize: 28),
                decoration: InputDecoration(
                  // labelText: 'Title',
                  hint: Text(
                    "Write your title here...",
                    style: GoogleFonts.ubuntu(
                      fontSize: 28,
                      color: const Color.fromARGB(255, 209, 209, 209),
                    ),
                  ),
                  labelStyle: GoogleFonts.ubuntu(fontSize: 28),
                  border: InputBorder.none,
                ),
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            if (_showToolbar)
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const Divider(
                      height: 10,
                      thickness: 1,
                      color: Color.fromARGB(255, 221, 221, 221),
                    ),
                    QuillSimpleToolbar(
                      controller: _quillController,
                      config: const QuillSimpleToolbarConfig(
                        showFontSize: true,
                        showColorButton: true,
                        showAlignmentButtons: true,
                      ),
                    ),
                    const Divider(
                      height: 10,
                      thickness: 1,
                      color: Color.fromARGB(255, 221, 221, 221),
                    ),
                  ],
                ),
              ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            SliverToBoxAdapter(
              child: ListView(
                padding: EdgeInsets.all(0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  QuillEditor.basic(
                    controller: _quillController,
                    focusNode: _editorFocusNode,
                    scrollController: ScrollController(),
                    config: const QuillEditorConfig(
                      // readOnly: false,
                      autoFocus: false,
                      placeholder: 'Write your content here...',
                      // expands: true,
                      padding: EdgeInsets.symmetric(vertical: 10),
                      scrollable: false,
                    ),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 30)),
            // Saved Location
            SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Saved Places",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  if (savedLocations.isNotEmpty)
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    MapPage(savedLocations: savedLocations),
                          ),
                        );
                      },
                      label: Text("See in Map"),
                      icon: Icon(Icons.map_outlined),
                    ),
                ],
              ),
            ),
            SliverToBoxAdapter(child: const SizedBox(height: 12)),
            savedLocations.isEmpty
                ? SliverToBoxAdapter(child: Text("No saved places yet..."))
                : SliverList.separated(
                  itemCount: savedLocations.length,
                  itemBuilder: (context, index) {
                    return LocationListTile(
                      locationName:
                          savedLocations[index].structuredFormat!.mainText!,
                      locationAddress:
                          savedLocations[index].structuredFormat!.secondaryText,
                      press: () {
                        setState(() {
                          savedLocations.remove(savedLocations[index]);
                        });
                      },
                      isSaved: true,
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 10,
                      thickness: 1,
                      color: Color.fromARGB(255, 221, 221, 221),
                    );
                  },
                ),
            SliverToBoxAdapter(child: const SizedBox(height: 30)),
            if (_imagePaths.isNotEmpty)
              SliverToBoxAdapter(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _imagePaths.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder:
                                    (_) => Dialog(
                                      backgroundColor: Colors.black,
                                      child: GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: InteractiveViewer(
                                          child: Image.file(
                                            File(_imagePaths[index]),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                              );
                            },
                            child: Image.file(
                              File(_imagePaths[index]),
                              fit: BoxFit.cover,
                            ),
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
                              padding: const EdgeInsets.all(2),
                              color: Colors.black54,
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: const Icon(Icons.edit), onPressed: () {}),
              IconButton(
                icon: const Icon(Icons.location_on),
                onPressed: () {
                  placePredictions = []; // Clear the previous placePredictions
                  showModalBottomSheet(
                    backgroundColor: Colors.white,
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return _searchLocationBottomSheetModal(
                            context,
                            setModalState,
                          );
                        },
                      );
                    },
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.text_fields),
                onPressed: () {
                  setState(() {
                    _showToolbar = !_showToolbar;
                  });
                },
              ),
              IconButton(icon: const Icon(Icons.image), onPressed: _pickImages),
              IconButton(icon: const Icon(Icons.attach_file), onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _searchLocationBottomSheetModal(
    BuildContext context,
    StateSetter setModalState,
  ) {
    return SizedBox(
      height: 800,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Place Suggestions",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
                IconButton(
                  iconSize: 40,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 12),
            Form(
              child: TextFormField(
                onChanged: (value) {
                  placeAutocomplete(value, setModalState);
                },
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: "Start typing to place suggestion...",
                  hintStyle: GoogleFonts.ubuntu(
                    color: const Color.fromARGB(255, 176, 176, 176),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Icon(Icons.location_on),
                  ),
                ),
              ),
            ),
            SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              itemCount: placePredictions.length,
              separatorBuilder:
                  (context, index) => const Divider(
                    height: 10,
                    thickness: 1,
                    color: Color.fromARGB(255, 221, 221, 221),
                  ),
              itemBuilder:
                  (context, index) => LocationListTile(
                    locationName:
                        placePredictions[index].structuredFormat!.mainText!,
                    locationAddress:
                        placePredictions[index].structuredFormat!.secondaryText,
                    press: () {
                      bool isAlreadySaved =
                          savedLocations.indexWhere(
                                    (sl) =>
                                        sl.placeId ==
                                        placePredictions[index].placeId,
                                  ) !=
                                  -1
                              ? true
                              : false;

                      // Do not save when the location already exist
                      if (isAlreadySaved == true) {
                        return;
                      }

                      setState(() {
                        savedLocations.add(placePredictions[index]);
                        placePredictions.removeWhere(
                          (p) => p.placeId == placePredictions[index].placeId,
                        );
                      });
                      setModalState(() {});
                    },
                    isSaved: false,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
