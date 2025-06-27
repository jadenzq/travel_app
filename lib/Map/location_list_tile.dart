import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    super.key,
    required this.locationName,
    required this.locationAddress,
    required this.isSaved,
    required this.press,
  });

  final String locationName;
  final String? locationAddress;
  final bool isSaved;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: isSaved == true ? null : press,
      horizontalTitleGap: 10.0,
      leading: Icon(Icons.location_on),
      title: Text(locationName, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        (locationAddress != null) ? locationAddress! : "",
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      trailing:
          isSaved == true
              ? IconButton(
                onPressed: press,
                icon: Icon(Icons.delete_forever_rounded, color: Colors.red),
              )
              : null,
    );
  }
}
