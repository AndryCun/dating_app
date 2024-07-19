import 'package:dating_app/models/post.dart';
import 'package:dating_app/screens/add_post_screen.dart';
import 'package:dating_app/screens/favorite_screen.dart';
import 'package:dating_app/screens/profile_screen.dart';
import 'package:dating_app/services/post_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  final String userId; 

  const HomeScreen({super.key, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddPostScreen()),
      );
    } else if (index == 1) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FavoriteScreen()),  // Ganti dengan nama layar FavoriteScreen yang sesuai
    );
    
    } else if (index == 4) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfileScreen()),  // Ganti dengan nama layar FavoriteScreen yang sesuai
    );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
      ),
      body: const PostListScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: Colors.pinkAccent),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, color: Colors.pinkAccent),
            label: 'Likes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, color: Colors.pinkAccent),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message, color: Colors.pinkAccent),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.pinkAccent),
            label: 'Profile',
          ),
        ],
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.pinkAccent[100],
        showUnselectedLabels: true,
      ),
    );
  }
}

class PostListScreen extends StatelessWidget {
  const PostListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Post>>(
        stream: PostService.getPostList(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              List<Post> posts = snapshot.data ?? [];
              return ListView.builder(
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return Card(
                    child: InkWell(
                      onTap: () {
                        // Handle post tap, e.g., navigate to detail page or edit page
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: Image.network(
                                post.imageUrl!,
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                                width: double.infinity,
                                height: 150,
                              ),
                            ),
                          
                          ListTile(
                            title: Text(post.title),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(post.description),
                                if (post.latitude != null && post.longitude != null)
                                  GestureDetector(
                                    onTap: () {
                                      _launchGoogleMaps(post.latitude!, post.longitude!);
                                    },
                                    child: Row(
                                      children: [
                                        Icon(Icons.location_on, color: Colors.blue),
                                        SizedBox(width: 5),
                                        Text('View Location'),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
  icon: Icon(
    post.isLiked ? Icons.favorite : Icons.favorite_border,
    color: post.isLiked ? Colors.red : null,
  ),
  onPressed: () {
    bool newLiked = !post.isLiked;
    Post updatedPost = post.copyWith(isLiked: newLiked);
    PostService.updatePost(updatedPost); 
    
    if (newLiked) {
      PostService.addToFavorites(post); 
      
    } else {
      // Jika tidak disukai, hapus dari favorite screen
      PostService.removeFromFavorites(post); // Misalkan ada fungsi untuk menghapus dari favorites
    }
  },
),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Confirm Delete'),
                                          content: Text('Are you sure you want to delete \'${post.title}\'?'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('Delete'),
                                              onPressed: () {
                                                PostService.deletePost(post.id!);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
          }
        },
      ),
    );
  }

  Future<void> _launchGoogleMaps(double latitude, double longitude) async {
    final Uri googleMapsUri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunch(googleMapsUri.toString())) {
      await launch(googleMapsUri.toString());
    } else {
      throw 'Could not launch $googleMapsUri';
    }
  }
}