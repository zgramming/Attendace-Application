import 'package:network/network.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_template/global_template.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../providers/absen_provider.dart';
import '../../../../providers/user_provider.dart';

class ListDestination extends StatelessWidget {
  const ListDestination({
    Key key,
    @required this.result,
  }) : super(key: key);

  final DestinasiModel result;
  static const sizeIcon = 14.0;
  @override
  Widget build(BuildContext context) {
    print("Widget : PickDestinationScreen/ListDestination.dart  | Rebuild !");

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: ShowImageNetwork(
          imageUrl: result.image == null
              ? "https://flutter.io/images/catalog-widget-placeholder.png"
              : "${appConfig.baseImageApiUrl}/destinasi/${result.image}",
          fit: BoxFit.cover,
          isCircle: true,
          imageCircleRadius: 30,
        ),
        title: Text(
          result.namaDestinasi,
          style: appTheme.subtitle2(context).copyWith(fontWeight: FontWeight.bold),
        ),
        trailing: Wrap(
          spacing: 5,
          children: [
            InkWell(
              onTap: () => _destinationUpdateStatus(context, result.idDestinasi),
              child: CircleAvatar(
                radius: ListDestination.sizeIcon,
                backgroundColor: colorPallete.green,
                foregroundColor: colorPallete.white,
                child: Icon(FontAwesomeIcons.check, size: ListDestination.sizeIcon),
              ),
            ),
            InkWell(
              onTap: () => _destinationDelete(context, result.idDestinasi),
              child: CircleAvatar(
                radius: ListDestination.sizeIcon,
                foregroundColor: colorPallete.white,
                backgroundColor: colorPallete.red,
                child: Icon(FontAwesomeIcons.trash, size: ListDestination.sizeIcon),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _destinationUpdateStatus(BuildContext context, String idDestinasi) async {
    final absenProvider = context.read<AbsenProvider>();
    final globalProvider = context.read<GlobalProvider>();
    final userProvider = context.read<UserProvider>();
    try {
      globalProvider.setLoading(true);
      final result = await absenProvider.destinationUpdateStatus(
        idDestinasi: idDestinasi,
        idUser: userProvider.user.idUser,
      );
      globalProvider.setLoading(false);
      globalF.showToast(message: result, isSuccess: true);
    } catch (e) {
      globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
      globalProvider.setLoading(false);
    }
  }

  void _destinationDelete(BuildContext context, String idDestinasi) async {
    final absenProvider = context.read<AbsenProvider>();
    final globalProvider = context.read<GlobalProvider>();
    try {
      globalProvider.setLoading(true);
      print("Proses Hapus");
      final result = await absenProvider.destinationDelete(idDestinasi);
      print("Selesai Hapus");
      globalProvider.setLoading(false);
      globalF.showToast(message: result, isSuccess: true);
    } catch (e) {
      globalF.showToast(message: e.toString(), isError: true, isLongDuration: true);
    }
  }
}
