import 'package:flutter/material.dart';
import 'package:pchat/widgets/alfabate_color_avtar.dart';
import 'app_text.dart';

class GroupUserTile extends StatelessWidget {
  final Function()? onTileTap;
  final Widget? trailing;
  final Color bgColor;
  final String name;
  final String dissception;
  final String photoUrl;

  final String indexKey;
  const GroupUserTile({
    super.key,
    this.onTileTap,
    required this.indexKey,
    required this.name,
    required this.dissception,
    required this.photoUrl,
    this.trailing,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTileTap,
        leading: Hero(
            tag: indexKey,
            child: AlphabateUserAvatar(
              color: bgColor,
              imageUrl: photoUrl,
              userName: name,
            )),
        title: AppText(text: name),
        subtitle: AppText(text: dissception),
        trailing: trailing);
  }
}
