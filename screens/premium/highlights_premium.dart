import 'package:flutter/material.dart';

class HighlightsPremium extends StatelessWidget {
  final List<Map<String, String>> highlights;

  const HighlightsPremium({Key? key, required this.highlights})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the screen size for responsive design
    var screenSize = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading
        Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05), // 5% padding
          child: Center(
            child: Text(
              'Highlights',
              style: TextStyle(
                fontSize: 24 * (screenSize.width / 375), // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Highlights Section
        Padding(
          padding: EdgeInsets.all(screenSize.width * 0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _highlightContainer('1000+', 'Happy', 'Customers', screenSize),
              _highlightContainer(
                  '100+', 'Serviced in', 'Last 24h', screenSize),
            ],
          ),
        ),
        // Actual Highlights - classy circular images
        Padding(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Center(
            child: SizedBox(
              height: screenSize.width * 0.6,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: highlights.length,
                itemBuilder: (context, index) {
                  return _circularHighlight(highlights[index], screenSize);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _highlightContainer(
      String upperText, String middleText, String lowerText, var screenSize) {
    Color backgroundColor = Colors.brown;
    Color textColor = Colors.brown.shade200;
    return Container(
      width: screenSize.width * 0.40,
      height: screenSize.width * 0.40,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            upperText,
            style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(colors: <Color>[
                    Color(0xFFD7B38C),
                    Color(0xFF8B5B29),
                  ], begin: Alignment.centerLeft, end: Alignment.bottomRight)
                      .createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0))),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            middleText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            lowerText,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal,
              color: textColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _circularHighlight(Map<String, String> highlight, Size screenSize) {
    return Container(
      width: screenSize.width * 0.42,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipOval(
            child: Image.network(
              highlight['imageUrl'] ??
                  'https://via.placeholder.com/150', // Use placeholder if imageUrl is not available
              height: screenSize.width * 0.42,
              width: screenSize.width * 0.42,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: screenSize.width * 0.05),
          Text(
            highlight['title'] ?? 'Unknown Title', // Handle missing title
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
