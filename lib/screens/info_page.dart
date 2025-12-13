import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background
      appBar: AppBar(
        title: const Text('關於我們'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black, // Dark text for title
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Team 17
            const Text(
              'Team 17',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.black87,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 4,
              width: 100,
              color: Colors.orangeAccent,
            ),
            const SizedBox(height: 40),

            // Professor Section (Right Aligned)
            Align(
              alignment: Alignment.centerRight,
              child: _buildNameCard(
                name: 'Advisor: 陳煥',
                role: 'Professor',
                color: Colors.teal,
                alignment: CrossAxisAlignment.end,
              ),
            ),
            const SizedBox(height: 40),

            // Members Section (Staggered)
            _buildMemberItem('洪靖倫', 0, Colors.blueAccent),
            _buildMemberItem('羅雅馨', 1, Colors.pinkAccent),
            _buildMemberItem('楊竣博', 2, Colors.purpleAccent),
            _buildMemberItem('林智堅', 3, Colors.deepOrangeAccent, imagePath: 'assets/images/zhijian.jpg'),
            
             const SizedBox(height: 40),
             const Center(child: Text("Designed with Flutter", style: TextStyle(color: Colors.grey))),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberItem(String name, int index, Color color, {String? imagePath}) {
    bool isLeft = index % 2 == 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Align(
        alignment: isLeft ? Alignment.centerLeft : Alignment.centerRight,
        child: _buildNameCard(
          name: name, 
          role: 'Member', 
          color: color, 
          alignment: isLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          imagePath: imagePath,
        ),
      ),
    );
  }

  Widget _buildNameCard({
    required String name,
    required String role,
    required Color color,
    required CrossAxisAlignment alignment,
    String? imagePath,
  }) {
    // Determine content order based on alignment
    // Left alignment: Image -> Text
    // Right alignment: Text -> Image
    final bool isLeft = alignment == CrossAxisAlignment.start;
    
    Widget imageWidget = imagePath != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: Image.asset(
              imagePath,
              width: 60, // Slightly smaller to fit gracefully
              height: 60,
              fit: BoxFit.cover,
            ),
          )
        : const SizedBox.shrink();

    Widget textColumn = Column(
      crossAxisAlignment: alignment,
      children: [
        Text(role.toUpperCase(),
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey[400])),
        const SizedBox(height: 4),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ],
    );

    return Container(
      // width: 200, // Remove fixed width to allow Row to expand naturally or use constraints
      constraints: const BoxConstraints(minWidth: 180),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border(
           left: isLeft ? BorderSide(color: color, width: 4) : BorderSide.none,
           right: !isLeft ? BorderSide(color: color, width: 4) : BorderSide.none,
        )
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Wrap content
        children: [
          if (imagePath != null && isLeft) ...[
            imageWidget,
            const SizedBox(width: 12),
          ],
          textColumn,
          if (imagePath != null && !isLeft) ...[
             const SizedBox(width: 12),
             imageWidget,
          ],
        ],
      ),
    );
  }
}
