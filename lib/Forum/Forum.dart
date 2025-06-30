import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Experiences',
                  style: GoogleFonts.ubuntu(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
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
