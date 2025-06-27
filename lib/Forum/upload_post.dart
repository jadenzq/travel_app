import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
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
  final TextEditingController _locationController = TextEditingController();

  bool _isImagePost = true;
  List<XFile>? _selectedImages = [];
  XFile? _selectedVideo;
  XFile? _selectedVideoThumbnail;
  Uint8List? _generatedVideoThumbnailBytes;

  bool _isLoading = false;

  late String _authorName;
  late String _authorImage;

  @override
  void initState() {
    super.initState();
    _authorName = widget.currentUserName;
    _authorImage = widget.currentUserImage;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _locationController.dispose();

    super.dispose();
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick images: $e')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick video: $e')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick thumbnail: $e')),
      );
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to generate video thumbnail: $e')),
      );
      developer.log('Error generating video thumbnail: $e');
      setState(() {
        _generatedVideoThumbnailBytes = null;
      });
    }
  }

  void _uploadPost() {
    if (_formKey.currentState!.validate()) {
      if (_isImagePost && (_selectedImages == null || _selectedImages!.isEmpty)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one image.')),
        );
        return;
      } 
      
      else if (!_isImagePost) {
        if (_selectedVideo == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select a video.')),
          );
          return;
        }

        if (_selectedVideoThumbnail == null && _generatedVideoThumbnailBytes == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video thumbnail is still generating. Please wait or select a custom thumbnail.')),
          );
          return;
        }
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

        final newPost = Post(
          title: _titleController.text,
          content: _contentController.text,
          views: "0",
          media: mediaPaths,
          authorName: _authorName,
          authorImage: _authorImage,
          location: _locationController.text,
          isVideo: !_isImagePost,
        );

        widget.onPostUploaded(newPost);

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post uploaded successfully!')),
        );
        Navigator.of(context).pop();
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
      body: SingleChildScrollView(
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
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                  hintText: 'e.g., Paris, France',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),

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
    );
  }
}
