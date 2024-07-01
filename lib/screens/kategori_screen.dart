import 'package:flutter/material.dart';
import 'package:my_app/screens/kuliner_bykategori.dart';

class KategoriScreen extends StatelessWidget {
  const KategoriScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                buildCategory(
                  'Traditional Food',
                  'assets/images/tradisional.png',
                  context,
                  () => const KulinerByKategoriScreen(kategori: 'Tradisional'),
                ),
                buildCategory(
                  'Street Food',
                  'assets/images/street_food.png',
                  context,
                  () => const KulinerByKategoriScreen(kategori: 'StreetFood'),
                ),
                buildCategory(
                  'Asian Food',
                  'assets/images/sushi.png',
                  context,
                  () => const KulinerByKategoriScreen(kategori: 'AsianFood'),
                ),
                buildCategory(
                  'Western Food',
                  'assets/images/pizza2.jpeg',
                  context,
                  () => const KulinerByKategoriScreen(kategori: 'WesternFood'),
                ),
                buildCategory(
                  'Vegan Food',
                  'assets/images/vegan_food.png',
                  context,
                  () => const KulinerByKategoriScreen(kategori: 'VeganFood'),
                ),
                buildCategory(
                  'Dessert',
                  'assets/images/dessert.jpeg',
                  context,
                  () => const KulinerByKategoriScreen(kategori: 'Dessert'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategory(String label, String imagePath, BuildContext context,
      Widget Function() pageBuilder) {
    return GestureDetector(
      onTap: () {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => pageBuilder(),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        height: 150.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
