// follower_like_rating.dart
import 'package:flutter/material.dart';

class FollowerLikeRatingPage extends StatelessWidget {
  final String followers;
  final String likesCount;
  final String rating;
  final Color bodyColor;

  const FollowerLikeRatingPage({
    super.key,
    required this.followers,
    required this.likesCount,
    required this.rating,
    required this.bodyColor,
  });

  @override
  Widget build(BuildContext context) {
    Color textColor = Colors.brown.shade200;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bodyColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            // Followers Section
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_alt_outlined,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(followers,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 4),
                Text('Followers', style: TextStyle(color: textColor)),
              ],
            ),
            const SizedBox(height: 20),

            // Likes Section
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.thumb_up_outlined, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(likesCount,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 4),
                Text('Likes', style: TextStyle(color: textColor)),
              ],
            ),
            const SizedBox(height: 20),

            // Rating Section
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.star_border_outlined, size: 40, color: Colors.white),
                const SizedBox(height: 8),
                Text(rating,
                    style: TextStyle(color: Colors.white, fontSize: 20)),
                const SizedBox(height: 4),
                Text('Rating', style: TextStyle(color: textColor)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildButton('Like', context),
                _buildButton('Follow', context),
                _buildButton('Rate Now', context),
              ],
            ),
            const SizedBox(height: 30),
            // a rectangular sklyit badge
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color.fromARGB(255, 177, 169, 143), // Light color
                    Color.fromARGB(255, 105, 79, 2), // Darker color
                  ],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Aligns content size to minimum
                children: [
                  const Icon(
                    Icons.star_outline,
                    color: Colors.brown,
                    size: 20.0,
                  ),
                  const SizedBox(width: 8), // Space between icon and text
                  const Text(
                    'Sklyit Verified',
                    style: TextStyle(
                      color: Colors.brown,
                      fontWeight: FontWeight.bold,
                      fontSize: 16, // Increase font size for better visibility
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Add your button action here
        print('$title button pressed');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: bodyColor, // White text color
        side: BorderSide(color: Colors.white), // White border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30), // Rounded corners
        ),
      ),
      child: Text(title),
    );
  }
}
