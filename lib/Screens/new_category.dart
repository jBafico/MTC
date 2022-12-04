import 'package:flutter/material.dart';
import 'package:maneja_tus_cuentas/Model/Category.dart';
import 'package:maneja_tus_cuentas/Services/auth.dart';

import '../../Services/database.dart';

class NewCategory extends StatefulWidget {
  const NewCategory({Key? key}) : super(key: key);

  @override
  State<NewCategory> createState() => _NewCategoryState();
}

class _NewCategoryState extends State<NewCategory> {
  final TextEditingController _nameController = TextEditingController();

  String _message = "";

  IconData _icon = Icons.ac_unit;

  final DatabaseService _databaseService =
      DatabaseService(uid: AuthService().currentUser!.uid);

  @override
  initState() {
    super.initState();
  }

  Future _showIconPickerDialog() async {
    IconData iconPicked = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text(
            'Elegir un icono',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: IconPicker(),
        );
      },
    );

    setState(() {
      _icon = iconPicked;
    });
  }

  Future _createCategory() async {
    if (_nameController.text.isEmpty) {
      _message = "Por favor, rellene todos los campos";
      return;
    }

    try {
      var category = Category(
          name: _nameController.text,
          iconCode: _icon.codePoint,
          colorValue: Colors.blue.value);

      _databaseService.updateCategory(category);

      Navigator.pop(context);

      _message = 'Categoria creada con exito';
    } on Exception {
      _message = 'Error al crear la categoria';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Crear categoria',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 36),
              ),
            ),

            // Nombre
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Nombre',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Field to change name
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _nameController,
              ),
            ),

            // Icon
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Icono',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Icon selector
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(_icon),
                onPressed: _showIconPickerDialog,
              ),
            ),

            // Color
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Color',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Color selector
            // TODO : hacer esto

            // Button to save changes
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  await _createCategory();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_message),
                      ),
                    );
                  }
                },
                child: const Text('Crear'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IconPicker extends StatelessWidget {
  static List<IconData> icons = [
    Icons.access_time,
    Icons.accessibility_new,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.airline_seat_individual_suite,
    Icons.airplanemode_active,
    Icons.airport_shuttle,
    Icons.album,
    Icons.alternate_email,
    Icons.archive,
    Icons.assessment,
    Icons.assignment,
    Icons.attach_money,
    Icons.audiotrack,
    Icons.autorenew,
    Icons.beach_access,
    Icons.brightness_3,
    Icons.brush,
    Icons.bug_report,
    Icons.build,
    Icons.business,
    Icons.business_center,
    Icons.cake,
    Icons.camera_alt,
    Icons.casino,
    Icons.child_care,
    Icons.child_friendly,
    Icons.code,
    Icons.color_lens,
    Icons.computer,
    Icons.confirmation_number,
    Icons.content_cut,
    Icons.create,
    Icons.delete,
    Icons.desktop_windows,
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.directions_bus,
    Icons.directions_car,
    Icons.directions_run,
    Icons.directions_subway,
    Icons.email,
    Icons.enhanced_encryption,
    Icons.equalizer,
    Icons.euro_symbol,
    Icons.ev_station,
    Icons.explore,
    Icons.exposure,
    Icons.extension,
    Icons.face,
    Icons.fastfood,
    Icons.favorite,
    Icons.filter_frames,
    Icons.filter_hdr,
    Icons.filter_vintage,
    Icons.fitness_center,
    Icons.flight,
    Icons.format_paint,
    Icons.free_breakfast,
    Icons.gavel,
    Icons.grade,
    Icons.group,
    Icons.headset,
    Icons.home,
    Icons.hot_tub,
    Icons.hotel,
    Icons.image,
    Icons.kitchen,
    Icons.laptop,
    Icons.local_activity,
    Icons.local_bar,
    Icons.local_cafe,
    Icons.local_car_wash,
    Icons.local_convenience_store,
    Icons.local_dining,
    Icons.local_drink,
    Icons.local_florist,
    Icons.local_gas_station,
    Icons.local_grocery_store,
    Icons.local_hospital,
    Icons.local_hotel,
    Icons.local_laundry_service,
    Icons.local_library,
    Icons.local_mall,
    Icons.local_movies,
    Icons.local_offer,
    Icons.local_parking,
    Icons.local_pharmacy,
    Icons.local_phone,
    Icons.local_pizza,
    Icons.local_play,
    Icons.local_post_office,
    Icons.local_printshop,
    Icons.local_see,
    Icons.local_shipping,
    Icons.local_taxi,
    Icons.location_city,
    Icons.pets,
    Icons.poll,
    Icons.pool,
    Icons.pregnant_woman,
    Icons.restaurant,
    Icons.restaurant_menu,
    Icons.router,
    Icons.rowing,
    Icons.rss_feed,
    Icons.school,
    Icons.security,
    Icons.shopping_cart,
    Icons.store,
    Icons.store_mall_directory,
  ];

  const IconPicker({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: <Widget>[
        for (var icon in icons)
          GestureDetector(
            onTap: () => Navigator.pop(context, icon),
            child: Icon(icon),
          )
      ],
    );
  }
}
