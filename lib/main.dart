import 'package:flutter/material.dart';
import 'models/post.dart';
import 'services/api_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Post>> futurePosts;
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futurePosts = apiService.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Posts',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the heading bold
            color: Colors.white, // Change the text color to white
          ),
        ),
        backgroundColor: Colors.blue, // Change the AppBar background color
      ),
      body: FutureBuilder<List<Post>>(
        future: futurePosts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Failed to load posts. Please try again later.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red, // Error message in red color
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No posts available.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey, // No data message in grey color
                ),
              ),
            );
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.grey, // Divider color
                thickness: 1, // Divider thickness
              ),
              itemBuilder: (context, index) {
                Post post = snapshot.data![index];
                return ListTile(
                  title: Text(
                    post.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make title bold
                      color: Colors.black87, // Change title color to blue
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(post: post),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final Post post;

  DetailScreen({required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title,
          style: TextStyle(
            fontWeight: FontWeight.bold, // Make the title bold
            color: Colors.white, // Change the text color to white
          ),
        ),
        backgroundColor: Colors.blue, // Change the AppBar background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User ID: ${post.userId}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Make text bold
                color: Colors.black, // Change text color to blue
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Post ID: ${post.id}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Make text bold
                color: Colors.black, // Change text color to blue
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Title: ${post.title}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Make text bold
                color: Colors.black, // Change text color to blue
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Body: ${post.body}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold, // Make text bold
                color: Colors.black, // Change text color to blue
              ),
            ),
          ],
        ),
      ),
    );
  }
}