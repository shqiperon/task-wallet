import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeCards extends StatelessWidget {
  const HomeCards(
      {super.key,
      required this.screenWidget,
      required this.imageUrl,
      required this.buttonLabel});

  final String imageUrl;
  final String buttonLabel;
  final Widget screenWidget;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(imageUrl),
              height: 300,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 30,
            right: 30,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => screenWidget,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 54, 54, 54),
                padding: const EdgeInsets.all(15),
              ),
              child: Text(
                buttonLabel,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
