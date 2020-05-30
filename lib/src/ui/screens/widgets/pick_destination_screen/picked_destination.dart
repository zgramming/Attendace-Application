import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/absen_provider.dart';
import '../../../../function/common_function.dart';

class PickedDestination extends StatelessWidget {
  const PickedDestination({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Widget : PickDestinationScreen/PickedDestination.dart  | Rebuild !");

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        color: colorPallete.white,
        boxShadow: [
          BoxShadow(color: Colors.black87, blurRadius: 3),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Lokasi Absen',
            style: appTheme.headline6(context).copyWith(fontFamily: "Righteous", fontSize: 18),
          ),
          Consumer<AbsenProvider>(builder: (_, listDestinasi, __) {
            print("Widget : PickDestinationScreen/PickedDestination.dart | Consumer | Rebuild !");

            final selectedDestinasi =
                listDestinasi.listDestinasi.where((element) => element.status == "t").toList();
            return ListView.builder(
              itemCount: selectedDestinasi.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print("Listviewbuilder Picked Destination Rebuild");
                final value = selectedDestinasi[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      ShowImageNetwork(
                        imageUrl: value.image == null
                            ? "https://flutter.io/images/catalog-widget-placeholder.png"
                            : "${appConfig.baseImageApiUrl}/destinasi/${value.image}",
                        fit: BoxFit.cover,
                        isCircle: true,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: ListTile(
                            title: Text(
                              value.namaDestinasi,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  appTheme.subtitle2(context).copyWith(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              value.keterangan ?? "-",
                              style: appTheme.caption(context),
                            ),
                            trailing: InkWell(
                              onTap: () => _openGoogleMap(value.latitude, value.longitude),
                              child: CircleAvatar(
                                child: Icon(FontAwesomeIcons.mapMarkerAlt),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          })
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
      ),
    );
  }

  void _openGoogleMap(double latitude, double longitude) async {
    try {
      await commonF.openGoogleMap(latitude, longitude);
    } catch (e) {
      globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
    }
  }
}
