import 'package:flutter/material.dart';
import 'package:travel_app/Forum/forum_grids.dart';

class Forum extends StatefulWidget 
{
  const Forum({super.key});
  @override
  State<Forum> createState() => _ForumState();
}

class _ForumState extends State<Forum>
{
  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              children: [
                Text(
                  'Experiences',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20
                  ),
                ),
              ],
            ),
          ),
          ExperienceGrids()
        ],
      ),
    );
  }
}
