import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:travel_app/Map/location_list_tile.dart";
import "package:travel_app/Map/map_page.dart";
import "package:travel_app/Models/autocomplete_prediction.dart";
import "package:travel_app/Models/location.dart";
import "package:travel_app/Models/place_autocomplete_response.dart";
import "package:travel_app/Utilities/network_utility.dart";

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  List<AutocompletePrediction> savedLocations = [];
  List<AutocompletePrediction> placePredictions = [];

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https("places.googleapis.com", "v1/places:autocomplete", {
      "key": "AIzaSyCLxYn-Dgp1r1Qp2HbIubEc-egYC1_xb9E",
    });

    String? response = await NetworkUtility.postRequest(
      uri,
      body: <String, String>{"input": query},
    );

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);

      if (result.placePredictions != null) {
        setState(() {
          placePredictions = result.placePredictions!;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomScrollView(
          slivers: [
            // Location search field
            SliverToBoxAdapter(
              child: Form(
                child: TextFormField(
                  onChanged: (value) {
                    placeAutocomplete(value);
                  },
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: "Search location",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Icon(Icons.location_on),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: const Divider(
                height: 20,
                thickness: 2,
                color: Color.fromARGB(255, 221, 221, 221),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Saved Places",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SliverList.separated(
              itemCount: savedLocations.length,
              itemBuilder: (context, index) {
                return LocationListTile(
                  locationName:
                      savedLocations[index].structuredFormat!.mainText!,
                  locationAddress:
                      savedLocations[index].structuredFormat!.secondaryText,
                  press: () {
                    setState(() {
                      savedLocations.remove(savedLocations[index]);
                    });
                  },
                  isSaved: true,
                );
              },
              separatorBuilder: (context, index) {
                return const Divider(
                  height: 10,
                  thickness: 1,
                  color: Color.fromARGB(255, 221, 221, 221),
                );
              },
            ),
            SliverToBoxAdapter(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff41729f),
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => MapPage(savedLocations: savedLocations),
                    ),
                  );
                },
                child: Text("See in Map"),
              ),
            ),
            SliverToBoxAdapter(
              child: const Divider(
                height: 20,
                thickness: 2,
                color: Color.fromARGB(255, 221, 221, 221),
              ),
            ),
            SliverToBoxAdapter(
              child: Text(
                "Places Suggestions",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SliverList.separated(
              itemCount: placePredictions.length,
              separatorBuilder:
                  (context, index) => const Divider(
                    height: 10,
                    thickness: 1,
                    color: Color.fromARGB(255, 221, 221, 221),
                  ),
              itemBuilder:
                  (context, index) => LocationListTile(
                    locationName:
                        placePredictions[index].structuredFormat!.mainText!,
                    locationAddress:
                        placePredictions[index].structuredFormat!.secondaryText,
                    press: () {
                      bool isAlreadySaved =
                          savedLocations.indexWhere(
                                    (sl) =>
                                        sl.placeId ==
                                        placePredictions[index].placeId,
                                  ) !=
                                  -1
                              ? true
                              : false;

                      // Do not save when the location already exist
                      if (isAlreadySaved == true) {
                        return;
                      }

                      setState(() {
                        savedLocations.add(placePredictions[index]);
                      });
                    },
                    isSaved: false,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
