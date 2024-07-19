import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dating_app/models/post.dart';
import 'package:dating_app/services/post_service.dart'; 

class AddPostScreen extends StatefulWidget {
  final Post? post;

  const AddPostScreen({super.key, this.post});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  XFile? _imageFile;
  double? _latitude;
  double? _longitude;

  @override
  void initState() {
    super.initState();
    if (widget.post != null) {
      _titleController.text = widget.post!.title;
      _descriptionController.text = widget.post!.description;
      _latitude = widget.post!.latitude;
      _longitude = widget.post!.longitude;
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _latitude = position.latitude;
      _longitude = position.longitude;
    });
  }

   @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Title', textAlign: TextAlign.start),
            TextField(controller: _titleController),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Description:'),
            ),
            TextField(controller: _descriptionController, maxLines: null),
            const Padding(
              padding: EdgeInsets.only(top: 20),
              child: Text('Image:'),
            ),
            SizedBox(height: 20.0),
            IconButton(
              onPressed: _getCurrentLocation,
              icon: Icon(Icons.map),
              tooltip: 'Tampilkan Lokasi Anda Skarang',
            ),
            if (_latitude != null && _longitude != null)
              Text('Location: $_latitude, $_longitude'),
            SizedBox(height: 20.0),
            Center(
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Text(_imageFile == null ? 'Pick Image' : 'Image Selected'),
              ),
            ),
            SizedBox(height: 5.0),
            _imageFile != null
                ? Image.network((_imageFile!.path))
                : Container(),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () async {
                String? urlimage;
                if (_imageFile != null) {
                  urlimage = await PostService.uploadImage(_imageFile!);
                } else {
                  urlimage = widget.post?.imageUrl;
                }

                Post post = Post(
                  id: widget.post?.id,
                  title: _titleController.text,
                  description: _descriptionController.text,
                  imageUrl: urlimage,
                  latitude: _latitude,
                  longitude: _longitude,
                  createdAt: widget.post?.createdAt,
                  // uid: user.uid,
                );

                try {
                  if (widget.post == null) {
                    await PostService.addPost(post);
                    // Clear Manual
                    _titleController.clear();
                    _descriptionController.clear();
                    setState(() {
                      _imageFile = null;
                      _latitude = null;
                      _longitude = null;
                    });
                  }
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('uploaded successfully')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to upload')),
                  );
                }
            
            },
              child: Text('Posting'),
            ),
            SizedBox(height: 40.0),
          ],
        ),
      ),
    );
  }
}
