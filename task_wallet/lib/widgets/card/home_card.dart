import 'package:flutter/material.dart';
import 'package:task_wallet/widgets/card/home_card_state.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeCard extends StatelessWidget {
  const HomeCard({
    super.key,
    required this.state,
  });

  final HomeCardState state;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage(
              placeholder: MemoryImage(kTransparentImage),
              image: NetworkImage(state.imageUrl),
              height: 250,
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
                  builder: (context) => state.screen,
                ));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 54, 54, 54),
                padding: const EdgeInsets.all(15),
              ),
              child: Text(
                state.buttonLabel,
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
