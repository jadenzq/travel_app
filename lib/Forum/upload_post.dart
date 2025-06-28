// Choose either 1 --> 1

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:travel_app/Models/country.dart';
import 'package:travel_app/Models/post.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class UploadPost extends StatefulWidget {
  final void Function(Post newPost) onPostUploaded;
  final String currentUserName;
  final String currentUserImage;

  const UploadPost({
    super.key,
    required this.onPostUploaded,
    required this.currentUserName,
    required this.currentUserImage,
  });

  @override
  State<UploadPost> createState() => _UploadPostState();
}

class _UploadPostState extends State<UploadPost> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final TextEditingController _countrySearchController = TextEditingController();
  final FocusNode _countryFocusNode = FocusNode();
  final TextEditingController _stateSearchController = TextEditingController();
  final FocusNode _stateFocusNode = FocusNode();

  bool _isImagePost = true;
  List<XFile>? _selectedImages = [];
  XFile? _selectedVideo;
  XFile? _selectedVideoThumbnail;
  Uint8List? _generatedVideoThumbnailBytes;

  bool _isLoading = false;

  late String _authorName;
  late String _authorImage;

  List<Country> _allCountries = [];
  List<Country> _filteredCountries = [];
  Country? _selectedCountryObject;

  List<String> _allStatesForSelectedCountry = [];
  List<String> _filteredStates = [];
  String? _selectedState;


  double _notificationOpacity = 0.0;
  String _notificationMessage = '';
  Timer? _notificationTimer;

  @override
  void initState() {
    super.initState();
    _authorName = widget.currentUserName;
    _authorImage = widget.currentUserImage;
    _loadCountriesData();

    _countrySearchController.addListener(_filterCountries);
    _stateSearchController.addListener(_filterStates);

    _countryFocusNode.addListener(() {
      if (!_countryFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _filteredCountries = [];
            if (_selectedCountryObject == null && _countrySearchController.text.isNotEmpty) {
              _countrySearchController.clear();
            }
          });
        });
      }
    });

    _stateFocusNode.addListener(() {
      if (!_stateFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 200), () {
          setState(() {
            _filteredStates = [];
            if (_selectedState == null && _stateSearchController.text.isNotEmpty) {
              _stateSearchController.clear();
            }
          });
        });
      }
    });
  }

  Future<void> _loadCountriesData() async {
    try {
      final String response = await rootBundle.loadString('assets/countries+states.json');
      final List<dynamic> data = json.decode(response);
      setState(() {
        _allCountries = data.map((e) => Country.fromJson(e as Map<String, dynamic>)).toList();
        _filteredCountries = List.from(_allCountries);
      });
    } 
    catch (e) {
      _showCustomNotification('Error loading country data: $e');
      developer.log('Error loading countries+states.json: $e');
    }
  }

  void _filterCountries() {
    final query = _countrySearchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredCountries = List.from(_allCountries);
      } 
      else {
        _filteredCountries = _allCountries
            .where((country) => country.name.toLowerCase().contains(query))
            .toList();
      }

      if (_selectedCountryObject != null && !(_selectedCountryObject!.name.toLowerCase().contains(query))) {
        _selectedCountryObject = null;
        _countrySearchController.text = ''; 
        _clearStates(); 
      }
    });
  }

  void _filterStates() {
    final query = _stateSearchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredStates = List.from(_allStatesForSelectedCountry);
      } 
      else {
        _filteredStates = _allStatesForSelectedCountry
            .where((state) => state.toLowerCase().contains(query))
            .toList();
      }
      
      if (_selectedState != null && !(_selectedState!.toLowerCase().contains(query))) {
        _selectedState = null;
        _stateSearchController.text = '';
      }
    });
  }

  void _selectCountry(Country country) {
    setState(() {
      _selectedCountryObject = country;
      _countrySearchController.text = country.name;
      _filteredCountries = [];
      _allStatesForSelectedCountry = country.states;
      _clearStates();
      _countryFocusNode.unfocus();
    });
  }

  void _selectState(String state) {
    setState(() {
      _selectedState = state;
      _stateSearchController.text = state;
      _filteredStates = [];
      _stateFocusNode.unfocus();
    });
  }

  void _clearStates() {
    setState(() {
      _selectedState = null;
      _stateSearchController.clear();
      _filteredStates = [];
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();

    _countrySearchController.dispose();
    _countryFocusNode.dispose();
    _stateSearchController.dispose();
    _stateFocusNode.dispose();

    _notificationTimer?.cancel();
    
    super.dispose();
  }

  void _showCustomNotification(String message) {
    setState(() {
      _notificationMessage = message;
      _notificationOpacity = 1.0;
    });

    _notificationTimer?.cancel();
    _notificationTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _notificationOpacity = 0.0;
        });

      }
    });
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile>? images = await ImagePicker().pickMultiImage();
      if (images != null && images.isNotEmpty) {
        setState(() {
          _selectedImages ??= [];
          _selectedImages!.addAll(images);
        });
      }
    } catch (e) {
      _showCustomNotification('Failed to pick images: $e');
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages!.removeAt(index);
      if (_selectedImages!.isEmpty) {
        _selectedImages = null;
      }
    });
  }

  void _onReorderImages(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final XFile item = _selectedImages!.removeAt(oldIndex);
      _selectedImages!.insert(newIndex, item);
    });
  }

  Future<void> _pickVideo() async {
    try {
      final XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
      if (video != null) {
        setState(() {
          _selectedVideo = video;

          _generatedVideoThumbnail(video.path);
        });
      }
    } catch (e) {
      _showCustomNotification('Failed to pick video: $e');
    }
  }

  void _removeVideo() {
    setState(() {
      _selectedVideo = null;
      _generatedVideoThumbnailBytes = null;
    });
  }

  Future<void> _pickVideoThumbnail() async {
    try {
      final XFile? thumbnail = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (thumbnail != null) {
        setState(() {
          _selectedVideoThumbnail = thumbnail;
        });
      }
    } catch (e) {
      _showCustomNotification('Failed to pick thumbnail: $e');
    }
  }

  void _removeVideoThumbnail() {
    setState(() {
      _selectedVideoThumbnail = null;
    });
  }


  Future<void> _generatedVideoThumbnail(String videoPath) async {
    try {
      final thumbnailBytes = await VideoThumbnail.thumbnailData(
        video: videoPath,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 150,
        quality: 75,
      );

      setState(() {
        _generatedVideoThumbnailBytes = thumbnailBytes;
      });
    } catch (e) {
      _showCustomNotification('Failed to generate video thumbnail: $e');
      setState(() {
        _generatedVideoThumbnailBytes = null;
      });
    }
  }

  void _uploadPost() {
    if (_formKey.currentState!.validate()) {
      if (_isImagePost && (_selectedImages == null || _selectedImages!.isEmpty)) {
        _showCustomNotification('Please select at least one image.');
        return;
      } 
      
      else if (!_isImagePost) {
        if (_selectedVideo == null) {
          _showCustomNotification('Please select a video.');
          return;
        }

        if (_selectedVideoThumbnail == null && _generatedVideoThumbnailBytes == null) {
          _showCustomNotification('Video thumbnail is still generating. Please wait or select a custom thumbnail.');
          return;
        }
      }

      if (_selectedCountryObject == null) {
        _showCustomNotification('Please select a country.');
        return;
      }

      if (_selectedCountryObject!.states.isNotEmpty && _selectedState == null) {
        _showCustomNotification('Please select a state.');
        return;
      }

      setState(() {
        _isLoading = true;
      });

      Future.delayed(const Duration(seconds: 2), () async {
        List<String> mediaPaths = [];
        if (_isImagePost && _selectedImages != null) {
          mediaPaths = _selectedImages!.map((e) => e.path).toList();
        } else if (!_isImagePost && _selectedVideo != null) {
          String thumbnailPathToUse;

          if (_selectedVideoThumbnail != null) {
            thumbnailPathToUse = _selectedVideoThumbnail!.path;
          } else if (_generatedVideoThumbnailBytes != null) {
            final tempDir = await getTemporaryDirectory();
            final tempThumbnailFile = File('${tempDir.path}/generated_thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg');
            await tempThumbnailFile.writeAsBytes(_generatedVideoThumbnailBytes!);
            thumbnailPathToUse = tempThumbnailFile.path;
          } else {
            thumbnailPathToUse = '';
          }

          mediaPaths = [thumbnailPathToUse, _selectedVideo!.path];
        }

        String location = _selectedCountryObject!.name;
        if (_selectedState != null && _selectedState!.isNotEmpty) {
          location = '$_selectedState, $location';
        }

        final newPost = Post(
          title: _titleController.text,
          content: _contentController.text,
          views: "0",
          media: mediaPaths,
          authorName: _authorName,
          authorImage: _authorImage,
          location: location,
          isVideo: !_isImagePost,
        );

        widget.onPostUploaded(newPost);

        setState(() {
          _isLoading = false;
        });

        _showCustomNotification('Post uploaded successfully!');
        Navigator.of(context).pop('Post uploaded successfully!');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: Text(
          'Upload New Experience',
          style: GoogleFonts.ubuntu(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SizedBox.expand(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Color.fromARGB(54, 0, 0, 0),
                                blurRadius: 5,
                                offset: Offset(0, 6),
                              ),
                            ],
                          ),
                          child: ToggleButtons(
                            isSelected: [_isImagePost, !_isImagePost],
                            onPressed: (int index) {
                              setState(() {
                                _isImagePost = index == 0;
                                _selectedImages = null;
                                _selectedVideo = null;
                                _selectedVideoThumbnail = null;
                                _generatedVideoThumbnailBytes = null;
                                _notificationTimer?.cancel();
                                _notificationOpacity = 0.0;
                              });
                            },
                            borderRadius: BorderRadius.circular(12),
                            selectedColor: Colors.white,
                            fillColor: const Color(0xff41729f),
                            color: Colors.black,
                            constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 32) / 2 - 4),
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Image Post',
                                  style: GoogleFonts.ubuntu(fontSize: 16),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  'Video Post',
                                  style: GoogleFonts.ubuntu(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              
                      const SizedBox(height: 20),
              
                      TextFormField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: 'Title',
                          hintText: 'Enter post title',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
              
                      const SizedBox(height: 15),
              
                      TextFormField(
                        controller: _contentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Content',
                          hintText: 'Share your experience here...',
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some content';
                          }
                          return null;
                        },
                      ),
              
                      const SizedBox(height: 15),
              
                      TextFormField(
                        controller: _countrySearchController,
                        focusNode: _countryFocusNode,
                        readOnly: _allCountries.isEmpty,
                        onTap: () {
                          if (_countrySearchController.text.isEmpty) {
                            setState(() {
                              _filteredCountries = List.from(_allCountries);
                            });
                          }
                        },
                        decoration: InputDecoration(
                          labelText: 'Country',
                          hintText: _allCountries.isEmpty ? 'Loading countries...' : 'Search or select country',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: _selectedCountryObject != null
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _selectedCountryObject = null;
                                      _countrySearchController.clear();
                                      _filteredCountries = List.from(_allCountries);
                                      _clearStates();
                                    });
                                  },
                                )
                              : null,
                        ),
                        validator: (value) {
                          if (_selectedCountryObject == null) {
                            return 'Please select a country';
                          }
                          return null;
                        },
                      ),

                      if (_countryFocusNode.hasFocus && _filteredCountries.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(
                            maxHeight: 6 * 48.0, 
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _filteredCountries.length,
                            itemBuilder: (context, index) {
                              final country = _filteredCountries[index];
                              return ListTile(
                                title: Text(country.name, style: GoogleFonts.ubuntu()),
                                onTap: () => _selectCountry(country),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 15),

                      if (_selectedCountryObject != null && _allStatesForSelectedCountry.isNotEmpty)
                        TextFormField(
                          controller: _stateSearchController,
                          focusNode: _stateFocusNode,
                          readOnly: _allStatesForSelectedCountry.isEmpty, 
                          onTap: () {
                            if (_stateSearchController.text.isEmpty) {
                              setState(() {
                                _filteredStates = List.from(_allStatesForSelectedCountry);
                              });
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'State',
                            hintText: 'Search or select state',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: _selectedState != null
                                ? IconButton(
                                    icon: const Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _selectedState = null;
                                        _stateSearchController.clear();
                                        _filteredStates = List.from(_allStatesForSelectedCountry);
                                      });
                                    },
                                  )
                                : null,
                          ),
                          validator: (value) {
                            if (_selectedState == null && _selectedCountryObject!.states.isNotEmpty) {
                              return 'Please select a state';
                            }
                            return null;
                          },
                        ),

                      if (_stateFocusNode.hasFocus && _filteredStates.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          constraints: BoxConstraints(
                            maxHeight: 6 * 48.0,
                          ),
                          child: ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemCount: _filteredStates.length,
                            itemBuilder: (context, index) {
                              final state = _filteredStates[index];
                              return ListTile(
                                title: Text(state, style: GoogleFonts.ubuntu()),
                                onTap: () => _selectState(state),
                              );
                            },
                          ),
                        ),
                      if (_selectedCountryObject != null && _allStatesForSelectedCountry.isEmpty)
                        const SizedBox(height: 0),
              
                      const SizedBox(height: 20),
              
                      Text(
                        _isImagePost ? 'Upload Images:' : 'Upload Video and Thumbnail:',
                        style: GoogleFonts.ubuntu(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
              
                      const SizedBox(height: 10),
              
                      if (_isImagePost)
                        Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _pickImages,
                              icon: const Icon(Icons.photo_library, color: Colors.white),
                              label: Text(
                                'Select Images',
                                style: GoogleFonts.ubuntu(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff41729f),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
              
                            const SizedBox(height: 10),
              
                            if (_selectedImages != null && _selectedImages!.isNotEmpty)
                              SizedBox(
                                height: 100,
                                child: ReorderableListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _selectedImages!.length,
                                  onReorder: _onReorderImages,
                                  itemBuilder: (context, index) {
                                    final imageFile = _selectedImages![index];
                                    return ReorderableDelayedDragStartListener(
                                      key: ValueKey(imageFile.path),
                                      index: index,
                                      child: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: Stack(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(12),
                                              child: Image.file(
                                                File(_selectedImages![index].path),
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 100,
                                              ),
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () => _removeImage(index),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.black.withOpacity(0.5),
                                                    borderRadius: const BorderRadius.only(
                                                      topRight: Radius.circular(12),
                                                      bottomLeft: Radius.circular(8),
                                                    ),
                                                  ),
                                                  padding: const EdgeInsets.all(4),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                          ],
                        )
                      else
                        Column(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _pickVideo,
                              icon: const Icon(Icons.videocam, color: Colors.white),
                              label: Text(
                                'Select Video',
                                style: GoogleFonts.ubuntu(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff41729f),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
                            const SizedBox(height: 10),
              
                            if (_selectedVideo != null) ...[
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Video Preview:',
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Stack(
                                children: [
                                  _generatedVideoThumbnailBytes != null
                                      ? ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.memory(
                                            _generatedVideoThumbnailBytes!,
                                            fit: BoxFit.cover,
                                            width: 150,
                                            height: 100,
                                          ),
                                        )
                                      : Container(
                                          height: 100,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Center(
                                            child: _selectedVideo != null
                                                ? const CircularProgressIndicator(
                                                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xff41729f)),
                                                  )
                                                : const Icon(Icons.video_file, size: 50, color: Colors.grey),
                                          ),
                                        ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _removeVideo,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(8),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],
              
                            ElevatedButton.icon(
                              onPressed: _pickVideoThumbnail,
                              icon: const Icon(Icons.image, color: Colors.white),
                              label: Text(
                                'Select Video Thumbnail (Optional)',
                                style: GoogleFonts.ubuntu(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff41729f),
                                minimumSize: const Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            ),
              
                            const SizedBox(height: 10),
              
                            if (_selectedVideoThumbnail != null)
                              Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      File(_selectedVideoThumbnail!.path),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 100,
                                    ),
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _removeVideoThumbnail,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(12),
                                            bottomLeft: Radius.circular(8),
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
              
                      const SizedBox(height: 30),
              
                      _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xff41729f)),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _uploadPost,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff2d4059),
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Text(
                                'Upload Post',
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      
                    ],
                  ),
                ),
              ),
        
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
                bottom: _notificationOpacity > 0 ? 20 : -100,
                left: 20,
                right: 20,
                child: AnimatedOpacity(
                  opacity: _notificationOpacity,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          _notificationMessage,
                          style: GoogleFonts.ubuntu(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Choose either 1 --> 2

// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer' as developer;
// import 'dart:io';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:travel_app/Models/country.dart';
// import 'package:travel_app/Models/post.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

// class UploadPost extends StatefulWidget {
//   final void Function(Post newPost) onPostUploaded;
//   final String currentUserName;
//   final String currentUserImage;

//   const UploadPost({
//     super.key,
//     required this.onPostUploaded,
//     required this.currentUserName,
//     required this.currentUserImage,
//   });

//   @override
//   State<UploadPost> createState() => _UploadPostState();
// }

// class _UploadPostState extends State<UploadPost> {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _contentController = TextEditingController();

//   final TextEditingController _countrySearchController = TextEditingController();
//   final FocusNode _countryFocusNode = FocusNode();
//   OverlayEntry? _countryOverlayEntry;

//   final TextEditingController _stateSearchController = TextEditingController();
//   final FocusNode _stateFocusNode = FocusNode();
//   OverlayEntry? _stateOverlayEntry;

//   bool _isImagePost = true;
//   List<XFile>? _selectedImages = [];
//   XFile? _selectedVideo;
//   XFile? _selectedVideoThumbnail;
//   Uint8List? _generatedVideoThumbnailBytes;

//   bool _isLoading = false;

//   late String _authorName;
//   late String _authorImage;

//   List<Country> _allCountries = [];
//   List<Country> _filteredCountries = [];
//   Country? _selectedCountryObject;

//   List<String> _allStatesForSelectedCountry = [];
//   List<String> _filteredStates = [];
//   String? _selectedState;

//   double _notificationOpacity = 0.0;
//   String _notificationMessage = '';
//   Timer? _notificationTimer;

//   @override
//   void initState() {
//     super.initState();
//     _authorName = widget.currentUserName;
//     _authorImage = widget.currentUserImage;
//     _loadCountriesData();

//     _countrySearchController.addListener(_filterCountries);
//     _stateSearchController.addListener(_filterStates);

//     _countryFocusNode.addListener(() {
//       if (_countryFocusNode.hasFocus) {
//         if (_countrySearchController.text.isEmpty) {
//           _filterCountries(); // Show all countries when focused
//         }
//         _showCountryOverlay();
//       } else {
//         Future.delayed(const Duration(milliseconds: 200), () {
//           if (!_countryFocusNode.hasFocus) {
//             _removeCountryOverlay();
//             if (_selectedCountryObject == null && _countrySearchController.text.isNotEmpty) {
//               _countrySearchController.clear();
//             }
//           }
//         });
//       }
//     });

//     _stateFocusNode.addListener(() {
//       if (_stateFocusNode.hasFocus) {
//         if (_stateSearchController.text.isEmpty) {
//           _filterStates(); // Show all states when focused
//         }
//         _showStateOverlay();
//       } else {
//         Future.delayed(const Duration(milliseconds: 200), () {
//           if (!_stateFocusNode.hasFocus) {
//             _removeStateOverlay();
//             if (_selectedState == null && _stateSearchController.text.isNotEmpty) {
//               _stateSearchController.clear();
//             }
//           }
//         });
//       }
//     });
//   }

//   Future<void> _loadCountriesData() async {
//     try {
//       final String response = await rootBundle.loadString('assets/countries+states.json');
//       final List<dynamic> data = json.decode(response);
//       setState(() {
//         _allCountries = data.map((e) => Country.fromJson(e as Map<String, dynamic>)).toList();
//         _filteredCountries = List.from(_allCountries);
//       });
//     } catch (e) {
//       _showCustomNotification('Error loading country data: $e');
//       developer.log('Error loading countries+states.json: $e');
//     }
//   }

//   void _filterCountries() {
//     final query = _countrySearchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _filteredCountries = List.from(_allCountries);
//       } else {
//         _filteredCountries = _allCountries
//             .where((country) => country.name.toLowerCase().contains(query))
//             .toList();
//       }

//       if (_selectedCountryObject != null && !(_selectedCountryObject!.name.toLowerCase().contains(query))) {
//         _selectedCountryObject = null;
//         _countrySearchController.text = '';
//         _clearStates();
//       }
//     });
//     _countryOverlayEntry?.markNeedsBuild();
//   }

//   void _filterStates() {
//     final query = _stateSearchController.text.toLowerCase();
//     setState(() {
//       if (query.isEmpty) {
//         _filteredStates = List.from(_allStatesForSelectedCountry);
//       } else {
//         _filteredStates = _allStatesForSelectedCountry
//             .where((state) => state.toLowerCase().contains(query))
//             .toList();
//       }

//       if (_selectedState != null && !(_selectedState!.toLowerCase().contains(query))) {
//         _selectedState = null;
//         _stateSearchController.text = '';
//       }
//     });
//     _stateOverlayEntry?.markNeedsBuild();
//   }

//   void _selectCountry(Country country) {
//     setState(() {
//       _selectedCountryObject = country;
//       _countrySearchController.text = country.name;
//       _filteredCountries = [];
//       _allStatesForSelectedCountry = country.states;
//       _clearStates();
//       _countryFocusNode.unfocus();
//     });
//     _removeCountryOverlay();
//   }

//   void _selectState(String state) {
//     setState(() {
//       _selectedState = state;
//       _stateSearchController.text = state;
//       _filteredStates = [];
//       _stateFocusNode.unfocus();
//     });
//     _removeStateOverlay();
//   }

//   void _clearStates() {
//     setState(() {
//       _selectedState = null;
//       _stateSearchController.clear();
//       _filteredStates = [];
//     });
//   }

//   void _showCountryOverlay() {
//     if (_countryOverlayEntry != null) return;

//     // Find the render box of the country text field to get its position and size
//     final RenderBox countryTextFieldRenderBox = _countryFocusNode.context!.findRenderObject() as RenderBox;
//     final Rect countryTextFieldRect = countryTextFieldRenderBox.localToGlobal(Offset.zero) & countryTextFieldRenderBox.size;

//     _countryOverlayEntry = OverlayEntry(
//       builder: (context) => Stack(
//         children: [
//           // Transparent GestureDetector to capture taps outside the dropdown
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: _dismissOverlays,
//               behavior: HitTestBehavior.translucent, // Ensures it captures taps
//             ),
//           ),
//           Positioned(
//             top: countryTextFieldRect.bottom + 8, // Position below the text field
//             left: countryTextFieldRect.left,
//             width: countryTextFieldRect.width,
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16), // Match padding of the text field
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 constraints: BoxConstraints(
//                   maxHeight: 6 * 48.0,
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   itemCount: _filteredCountries.length,
//                   itemBuilder: (context, index) {
//                     final country = _filteredCountries[index];
//                     return ListTile(
//                       title: Text(country.name, style: GoogleFonts.ubuntu()),
//                       onTap: () => _selectCountry(country),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//     Overlay.of(context).insert(_countryOverlayEntry!);
//   }

//   void _removeCountryOverlay() {
//     _countryOverlayEntry?.remove();
//     _countryOverlayEntry = null;
//   }

//   void _showStateOverlay() {
//     if (_stateOverlayEntry != null) return;

//     // Find the render box of the state text field to get its position and size
//     final RenderBox stateTextFieldRenderBox = _stateFocusNode.context!.findRenderObject() as RenderBox;
//     final Rect stateTextFieldRect = stateTextFieldRenderBox.localToGlobal(Offset.zero) & stateTextFieldRenderBox.size;

//     _stateOverlayEntry = OverlayEntry(
//       builder: (context) => Stack(
//         children: [
//           // Transparent GestureDetector to capture taps outside the dropdown
//           Positioned.fill(
//             child: GestureDetector(
//               onTap: _dismissOverlays,
//               behavior: HitTestBehavior.translucent, // Ensures it captures taps
//             ),
//           ),
//           Positioned(
//             top: stateTextFieldRect.bottom + 8, // Position below the text field
//             left: stateTextFieldRect.left,
//             width: stateTextFieldRect.width,
//             child: Material(
//               color: Colors.transparent,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(horizontal: 16), // Match padding of the text field
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 4,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 constraints: BoxConstraints(
//                   maxHeight: 6 * 48.0,
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   padding: EdgeInsets.zero,
//                   itemCount: _filteredStates.length,
//                   itemBuilder: (context, index) {
//                     final state = _filteredStates[index];
//                     return ListTile(
//                       title: Text(state, style: GoogleFonts.ubuntu()),
//                       onTap: () => _selectState(state),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//     Overlay.of(context).insert(_stateOverlayEntry!);
//   }

//   void _removeStateOverlay() {
//     _stateOverlayEntry?.remove();
//     _stateOverlayEntry = null;
//   }

//   void _dismissOverlays() {
//     if (_countryOverlayEntry != null || _stateOverlayEntry != null) {
//       FocusScope.of(context).unfocus();
//       _removeCountryOverlay();
//       _removeStateOverlay();
//     }
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _contentController.dispose();

//     _countrySearchController.dispose();
//     _countryFocusNode.dispose();
//     _stateSearchController.dispose();
//     _stateFocusNode.dispose();

//     _notificationTimer?.cancel();
//     _removeCountryOverlay(); // Ensure overlays are removed on dispose
//     _removeStateOverlay(); // Ensure overlays are removed on dispose

//     super.dispose();
//   }

//   void _showCustomNotification(String message) {
//     setState(() {
//       _notificationMessage = message;
//       _notificationOpacity = 1.0;
//     });

//     _notificationTimer?.cancel();
//     _notificationTimer = Timer(const Duration(seconds: 2), () {
//       if (mounted) {
//         setState(() {
//           _notificationOpacity = 0.0;
//         });
//       }
//     });
//   }

//   Future<void> _pickImages() async {
//     _dismissOverlays();
//     try {
//       final List<XFile>? images = await ImagePicker().pickMultiImage();
//       if (images != null && images.isNotEmpty) {
//         setState(() {
//           _selectedImages ??= [];
//           _selectedImages!.addAll(images);
//         });
//       }
//     } catch (e) {
//       _showCustomNotification('Failed to pick images: $e');
//     }
//   }

//   void _removeImage(int index) {
//     setState(() {
//       _selectedImages!.removeAt(index);
//       if (_selectedImages!.isEmpty) {
//         _selectedImages = null;
//       }
//     });
//   }

//   void _onReorderImages(int oldIndex, int newIndex) {
//     setState(() {
//       if (newIndex > oldIndex) {
//         newIndex -= 1;
//       }
//       final XFile item = _selectedImages!.removeAt(oldIndex);
//       _selectedImages!.insert(newIndex, item);
//     });
//   }

//   Future<void> _pickVideo() async {
//     _dismissOverlays();
//     try {
//       final XFile? video = await ImagePicker().pickVideo(source: ImageSource.gallery);
//       if (video != null) {
//         setState(() {
//           _selectedVideo = video;

//           _generatedVideoThumbnail(video.path);
//         });
//       }
//     } catch (e) {
//       _showCustomNotification('Failed to pick video: $e');
//     }
//   }

//   void _removeVideo() {
//     setState(() {
//       _selectedVideo = null;
//       _generatedVideoThumbnailBytes = null;
//     });
//   }

//   Future<void> _pickVideoThumbnail() async {
//     _dismissOverlays();
//     try {
//       final XFile? thumbnail = await ImagePicker().pickImage(source: ImageSource.gallery);
//       if (thumbnail != null) {
//         setState(() {
//           _selectedVideoThumbnail = thumbnail;
//         });
//       }
//     } catch (e) {
//       _showCustomNotification('Failed to pick thumbnail: $e');
//     }
//   }

//   void _removeVideoThumbnail() {
//     setState(() {
//       _selectedVideoThumbnail = null;
//     });
//   }

//   Future<void> _generatedVideoThumbnail(String videoPath) async {
//     try {
//       final thumbnailBytes = await VideoThumbnail.thumbnailData(
//         video: videoPath,
//         imageFormat: ImageFormat.JPEG,
//         maxWidth: 150,
//         quality: 75,
//       );

//       setState(() {
//         _generatedVideoThumbnailBytes = thumbnailBytes;
//       });
//     } catch (e) {
//       _showCustomNotification('Failed to generate video thumbnail: $e');
//       setState(() {
//         _generatedVideoThumbnailBytes = null;
//       });
//     }
//   }

//   void _uploadPost() {
//     _dismissOverlays();
//     if (_formKey.currentState!.validate()) {
//       if (_isImagePost && (_selectedImages == null || _selectedImages!.isEmpty)) {
//         _showCustomNotification('Please select at least one image.');
//         return;
//       } else if (!_isImagePost) {
//         if (_selectedVideo == null) {
//           _showCustomNotification('Please select a video.');
//           return;
//         }

//         if (_selectedVideoThumbnail == null && _generatedVideoThumbnailBytes == null) {
//           _showCustomNotification('Video thumbnail is still generating. Please wait or select a custom thumbnail.');
//           return;
//         }
//       }

//       if (_selectedCountryObject == null) {
//         _showCustomNotification('Please select a country.');
//         return;
//       }

//       if (_selectedCountryObject!.states.isNotEmpty && _selectedState == null) {
//         _showCustomNotification('Please select a state.');
//         return;
//       }

//       setState(() {
//         _isLoading = true;
//       });

//       Future.delayed(const Duration(seconds: 2), () async {
//         List<String> mediaPaths = [];
//         if (_isImagePost && _selectedImages != null) {
//           mediaPaths = _selectedImages!.map((e) => e.path).toList();
//         } else if (!_isImagePost && _selectedVideo != null) {
//           String thumbnailPathToUse;

//           if (_selectedVideoThumbnail != null) {
//             thumbnailPathToUse = _selectedVideoThumbnail!.path;
//           } else if (_generatedVideoThumbnailBytes != null) {
//             final tempDir = await getTemporaryDirectory();
//             final tempThumbnailFile = File('${tempDir.path}/generated_thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg');
//             await tempThumbnailFile.writeAsBytes(_generatedVideoThumbnailBytes!);
//             thumbnailPathToUse = tempThumbnailFile.path;
//           } else {
//             thumbnailPathToUse = '';
//           }

//           mediaPaths = [thumbnailPathToUse, _selectedVideo!.path];
//         }

//         String location = _selectedCountryObject!.name;
//         if (_selectedState != null && _selectedState!.isNotEmpty) {
//           location = '$_selectedState, $location';
//         }

//         final newPost = Post(
//           title: _titleController.text,
//           content: _contentController.text,
//           views: "0",
//           media: mediaPaths,
//           authorName: _authorName,
//           authorImage: _authorImage,
//           location: location,
//           isVideo: !_isImagePost,
//         );

//         widget.onPostUploaded(newPost);

//         setState(() {
//           _isLoading = false;
//         });

//         _showCustomNotification('Post uploaded successfully!');
//         Navigator.of(context).pop('Post uploaded successfully!');
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff5f5f5),
//       appBar: AppBar(
//         title: Text(
//           'Upload New Experience',
//           style: GoogleFonts.ubuntu(
//             fontWeight: FontWeight.w600,
//             fontSize: 20,
//             color: Colors.black,
//           ),
//         ),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             _dismissOverlays();
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: SizedBox.expand( // Removed the GestureDetector here
//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: const [
//                             BoxShadow(
//                               color: Color.fromARGB(54, 0, 0, 0),
//                               blurRadius: 5,
//                               offset: Offset(0, 6),
//                             ),
//                           ],
//                         ),
//                         child: ToggleButtons(
//                           isSelected: [_isImagePost, !_isImagePost],
//                           onPressed: (int index) {
//                             _dismissOverlays();
//                             setState(() {
//                               _isImagePost = index == 0;
//                               _selectedImages = null;
//                               _selectedVideo = null;
//                               _selectedVideoThumbnail = null;
//                               _generatedVideoThumbnailBytes = null;
//                               _notificationTimer?.cancel();
//                               _notificationOpacity = 0.0;
//                             });
//                           },
//                           borderRadius: BorderRadius.circular(12),
//                           selectedColor: Colors.white,
//                           fillColor: const Color(0xff41729f),
//                           color: Colors.black,
//                           constraints: BoxConstraints.expand(width: (MediaQuery.of(context).size.width - 32) / 2 - 4),
//                           children: <Widget>[
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16),
//                               child: Text(
//                                 'Image Post',
//                                 style: GoogleFonts.ubuntu(fontSize: 16),
//                               ),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 16),
//                               child: Text(
//                                 'Video Post',
//                                 style: GoogleFonts.ubuntu(fontSize: 16),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     TextFormField(
//                       controller: _titleController,
//                       decoration: InputDecoration(
//                         labelText: 'Title',
//                         hintText: 'Enter post title',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter a title';
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 15),

//                     TextFormField(
//                       controller: _contentController,
//                       maxLines: 5,
//                       decoration: InputDecoration(
//                         labelText: 'Content',
//                         hintText: 'Share your experience here...',
//                         alignLabelWithHint: true,
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter some content';
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 15),

//                     TextFormField(
//                       controller: _countrySearchController,
//                       focusNode: _countryFocusNode,
//                       readOnly: _allCountries.isEmpty,
//                       onTap: () {
//                         if (_countrySearchController.text.isEmpty) {
//                           setState(() {
//                             _filteredCountries = List.from(_allCountries);
//                           });
//                         }
//                         _showCountryOverlay();
//                       },
//                       decoration: InputDecoration(
//                         labelText: 'Country',
//                         hintText: _allCountries.isEmpty ? 'Loading countries...' : 'Search or select country',
//                         border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                         filled: true,
//                         fillColor: Colors.white,
//                         suffixIcon: _selectedCountryObject != null
//                             ? IconButton(
//                                 icon: const Icon(Icons.clear),
//                                 onPressed: () {
//                                   setState(() {
//                                     _selectedCountryObject = null;
//                                     _countrySearchController.clear();
//                                     _filteredCountries = List.from(_allCountries);
//                                     _clearStates();
//                                   });
//                                   _removeCountryOverlay();
//                                 },
//                               )
//                             : null,
//                       ),
//                       validator: (value) {
//                         if (_selectedCountryObject == null) {
//                           return 'Please select a country';
//                         }
//                         return null;
//                       },
//                     ),

//                     const SizedBox(height: 15),

//                     if (_selectedCountryObject != null && _allStatesForSelectedCountry.isNotEmpty)
//                       TextFormField(
//                         controller: _stateSearchController,
//                         focusNode: _stateFocusNode,
//                         readOnly: _allStatesForSelectedCountry.isEmpty,
//                         onTap: () {
//                           if (_stateSearchController.text.isEmpty) {
//                             setState(() {
//                               _filteredStates = List.from(_allStatesForSelectedCountry);
//                             });
//                           }
//                           _showStateOverlay();
//                         },
//                         decoration: InputDecoration(
//                           labelText: 'State',
//                           hintText: 'Search or select state',
//                           border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//                           filled: true,
//                           fillColor: Colors.white,
//                           suffixIcon: _selectedState != null
//                               ? IconButton(
//                                   icon: const Icon(Icons.clear),
//                                   onPressed: () {
//                                     setState(() {
//                                       _selectedState = null;
//                                       _stateSearchController.clear();
//                                       _filteredStates = List.from(_allStatesForSelectedCountry);
//                                     });
//                                     _removeStateOverlay();
//                                   },
//                                 )
//                               : null,
//                         ),
//                         validator: (value) {
//                           if (_selectedState == null && _selectedCountryObject!.states.isNotEmpty) {
//                             return 'Please select a state';
//                           }
//                           return null;
//                         },
//                       ),
//                     if (_selectedCountryObject != null && _allStatesForSelectedCountry.isEmpty)
//                       const SizedBox(height: 0),

//                     const SizedBox(height: 20),

//                     Text(
//                       _isImagePost ? 'Upload Images:' : 'Upload Video and Thumbnail:',
//                       style: GoogleFonts.ubuntu(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.black87,
//                       ),
//                     ),

//                     const SizedBox(height: 10),

//                     if (_isImagePost)
//                       Column(
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: _pickImages,
//                             icon: const Icon(Icons.photo_library, color: Colors.white),
//                             label: Text(
//                               'Select Images',
//                               style: GoogleFonts.ubuntu(color: Colors.white),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xff41729f),
//                               minimumSize: const Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             ),
//                           ),

//                           const SizedBox(height: 10),

//                           if (_selectedImages != null && _selectedImages!.isNotEmpty)
//                             SizedBox(
//                               height: 100,
//                               child: ReorderableListView.builder(
//                                 scrollDirection: Axis.horizontal,
//                                 itemCount: _selectedImages!.length,
//                                 onReorder: _onReorderImages,
//                                 itemBuilder: (context, index) {
//                                   final imageFile = _selectedImages![index];
//                                   return ReorderableDelayedDragStartListener(
//                                     key: ValueKey(imageFile.path),
//                                     index: index,
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(right: 8.0),
//                                       child: Stack(
//                                         children: [
//                                           ClipRRect(
//                                             borderRadius: BorderRadius.circular(12),
//                                             child: Image.file(
//                                               File(_selectedImages![index].path),
//                                               fit: BoxFit.cover,
//                                               width: 100,
//                                               height: 100,
//                                             ),
//                                           ),
//                                           Positioned(
//                                             top: 0,
//                                             right: 0,
//                                             child: GestureDetector(
//                                               onTap: () => _removeImage(index),
//                                               child: Container(
//                                                 decoration: BoxDecoration(
//                                                   color: Colors.black.withOpacity(0.5),
//                                                   borderRadius: const BorderRadius.only(
//                                                     topRight: Radius.circular(12),
//                                                     bottomLeft: Radius.circular(8),
//                                                   ),
//                                                 ),
//                                                 padding: const EdgeInsets.all(4),
//                                                 child: const Icon(
//                                                   Icons.close,
//                                                   color: Colors.white,
//                                                   size: 18,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   );
//                                 },
//                               ),
//                             ),
//                         ],
//                       )
//                     else
//                       Column(
//                         children: [
//                           ElevatedButton.icon(
//                             onPressed: _pickVideo,
//                             icon: const Icon(Icons.videocam, color: Colors.white),
//                             label: Text(
//                               'Select Video',
//                               style: GoogleFonts.ubuntu(color: Colors.white),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xff41729f),
//                               minimumSize: const Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             ),
//                           ),
//                           const SizedBox(height: 10),

//                           if (_selectedVideo != null) ...[
//                             Align(
//                               alignment: Alignment.centerLeft,
//                               child: Text(
//                                 'Video Preview:',
//                                 style: GoogleFonts.ubuntu(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w500,
//                                   color: Colors.black87,
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Stack(
//                               children: [
//                                 _generatedVideoThumbnailBytes != null
//                                     ? ClipRRect(
//                                         borderRadius: BorderRadius.circular(12),
//                                         child: Image.memory(
//                                           _generatedVideoThumbnailBytes!,
//                                           fit: BoxFit.cover,
//                                           width: 150,
//                                           height: 100,
//                                         ),
//                                       )
//                                     : Container(
//                                         height: 100,
//                                         width: 150,
//                                         decoration: BoxDecoration(
//                                           color: Colors.grey[200],
//                                           borderRadius: BorderRadius.circular(12),
//                                         ),
//                                         child: Center(
//                                           child: _selectedVideo != null
//                                               ? const CircularProgressIndicator(
//                                                   valueColor: AlwaysStoppedAnimation<Color>(Color(0xff41729f)),
//                                                 )
//                                               : const Icon(Icons.video_file, size: 50, color: Colors.grey),
//                                         ),
//                                       ),
//                                 Positioned(
//                                   top: 0,
//                                   right: 0,
//                                   child: GestureDetector(
//                                     onTap: _removeVideo,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.black.withOpacity(0.5),
//                                         borderRadius: const BorderRadius.only(
//                                           topRight: Radius.circular(12),
//                                           bottomLeft: Radius.circular(8),
//                                         ),
//                                       ),
//                                       padding: const EdgeInsets.all(4),
//                                       child: const Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size: 18,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 20),
//                           ],

//                           ElevatedButton.icon(
//                             onPressed: _pickVideoThumbnail,
//                             icon: const Icon(Icons.image, color: Colors.white),
//                             label: Text(
//                               'Select Video Thumbnail (Optional)',
//                               style: GoogleFonts.ubuntu(color: Colors.white),
//                             ),
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xff41729f),
//                               minimumSize: const Size(double.infinity, 50),
//                               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                             ),
//                           ),

//                           const SizedBox(height: 10),

//                           if (_selectedVideoThumbnail != null)
//                             Stack(
//                               children: [
//                                 ClipRRect(
//                                   borderRadius: BorderRadius.circular(12),
//                                   child: Image.file(
//                                     File(_selectedVideoThumbnail!.path),
//                                     fit: BoxFit.cover,
//                                     width: 150,
//                                     height: 100,
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 0,
//                                   right: 0,
//                                   child: GestureDetector(
//                                     onTap: _removeVideoThumbnail,
//                                     child: Container(
//                                       decoration: BoxDecoration(
//                                         color: Colors.black.withOpacity(0.5),
//                                         borderRadius: const BorderRadius.only(
//                                           topRight: Radius.circular(12),
//                                           bottomLeft: Radius.circular(8),
//                                         ),
//                                       ),
//                                       padding: const EdgeInsets.all(4),
//                                       child: const Icon(
//                                         Icons.close,
//                                         color: Colors.white,
//                                         size: 18,
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),

//                     const SizedBox(height: 30),

//                     _isLoading
//                         ? const Center(
//                             child: CircularProgressIndicator(
//                               valueColor: AlwaysStoppedAnimation<Color>(Color(0xff41729f)),
//                             ),
//                           )
//                         : ElevatedButton(
//                             onPressed: _uploadPost,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xff2d4059),
//                               minimumSize: const Size(double.infinity, 55),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20),
//                               ),
//                             ),
//                             child: Text(
//                               'Upload Post',
//                               style: GoogleFonts.ubuntu(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.white,
//                               ),
//                             ),
//                           ),
//                   ],
//                 ),
//               ),
//             ),

//             AnimatedPositioned(
//               duration: const Duration(milliseconds: 400),
//               curve: Curves.easeInOut,
//               bottom: _notificationOpacity > 0 ? 20 : -100,
//               left: 20,
//               right: 20,
//               child: AnimatedOpacity(
//                 opacity: _notificationOpacity,
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 child: Material(
//                   color: Colors.transparent,
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                     decoration: BoxDecoration(
//                       color: Colors.black87,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.3),
//                           spreadRadius: 2,
//                           blurRadius: 5,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Text(
//                         _notificationMessage,
//                         style: GoogleFonts.ubuntu(
//                           color: Colors.white,
//                           fontSize: 16,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
