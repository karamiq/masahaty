



// ignore_for_file: camel_case_types, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:masahaty/core/constants/constants.dart';

import 'package:flutter_gen/gen_l10n/app_localization.dart';

class showSelectionBottomSheet extends StatefulWidget {
  const showSelectionBottomSheet({super.key, required this.originalList});
  final Map<String, String> originalList;
  @override
  _showSelectionBottomSheetState createState() => _showSelectionBottomSheetState();
}

class _showSelectionBottomSheetState extends State<showSelectionBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  late Map<String, String> _filteredCountries;
  @override
  void initState() {
    super.initState();
    _filteredCountries = widget.originalList;
  }

  void _filterCountries(String query) {
    setState(() {
    _filteredCountries = Map.fromEntries(
      widget.originalList.entries.where((entry) =>
          entry.key.toLowerCase().contains(query.toLowerCase()) ||
          entry.value.toLowerCase().contains(query.toLowerCase())),
    );
  });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.originalList.length > 4 ? 650 : 250,
      decoration: BoxDecoration(
        color:  CustomColorsTheme.scaffoldBackGroundColor,
      ),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: CustomPageTheme.meduimPadding,),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 207, 207, 207),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 5,
              width: 80,
            ),
          ),
          SizedBox(height: CustomPageTheme.meduimPadding,),
          Container(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: AppLocalizations.of(context)!.search,
                prefixIcon: Icon(Icons.search,color: CustomColorsTheme.headLineColor,),
                contentPadding: EdgeInsets.symmetric(horizontal:20, vertical: 10)
              ),
              onChanged: _filterCountries,
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (BuildContext context, int index) {
                var key = _filteredCountries.keys.elementAt(index);
                var value = _filteredCountries.values.elementAt(index);
                return ListTile(
                  title: Text(key),
                  onTap: () {
                    // Handle country selection
                    Navigator.pop(context, value);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
 

 Future<dynamic> callCustomBottomSheet ({required Map<String,String> list, required BuildContext context}) async {
  final  result = await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return showSelectionBottomSheet(originalList: list,);
      },
    );  
        return result;
}