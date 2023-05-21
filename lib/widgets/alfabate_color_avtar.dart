import 'package:flutter/material.dart';
import 'package:pchat/widgets/app_text.dart';

class AlphabateUserAvatar extends StatelessWidget {
  final Color color;
  final double redius;
  final String userName;
  final String imageUrl;
  const AlphabateUserAvatar(
      {super.key,
      required this.color,
      required this.userName,
      required this.imageUrl,
      this.redius = 20});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: color,
      radius: redius,
      backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
      child: imageUrl.isEmpty
          ? userName.isNotEmpty
              ? AppText(
                  color: Colors.white,
                  text: userName[0].toUpperCase(),
                  fontSize: redius,
                )
              : Icon(
                  Icons.person,
                  color: Colors.white,
                  size: redius,
                )
          : null,
    );
  }
}
