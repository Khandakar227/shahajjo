import 'package:flutter/material.dart';

class VoteWidget extends StatefulWidget {
  const VoteWidget({super.key, required this.incidentId});
  final String incidentId;
  @override
  _VoteWidgetState createState() => _VoteWidgetState();
}

class _VoteWidgetState extends State<VoteWidget> {
  int voteCount = 1; // Current vote count
  bool isUpvoted = true;
  bool isDownvoted = false;

  void _handleUpvote() {
    setState(() {
      if (isUpvoted) {
        // If already upvoted, remove upvote
        voteCount--;
        isUpvoted = false;
      } else {
        // Add upvote
        voteCount += isDownvoted ? 2 : 1;
        isUpvoted = true;
        isDownvoted = false;
      }
    });
  }

  void _handleDownvote() {
    setState(() {
      if (isDownvoted) {
        // If already downvoted, remove downvote
        voteCount++;
        isDownvoted = false;
      } else {
        // Add downvote
        voteCount -= isUpvoted ? 2 : 1;
        isDownvoted = true;
        isUpvoted = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Upvote Button
        IconButton(
          icon: Icon(
            Icons.arrow_upward,
            color: isUpvoted ? Colors.green : Colors.grey,
          ),
          onPressed: _handleUpvote,
        ),
        // Vote Count Display
        Text(
          '$voteCount',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        // Downvote Button
        IconButton(
          icon: Icon(
            Icons.arrow_downward,
            color: isDownvoted ? Colors.red : Colors.grey,
          ),
          onPressed: _handleDownvote,
        ),
      ],
    );
  }
}
