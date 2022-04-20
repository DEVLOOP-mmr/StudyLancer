import 'package:elite_counsel/models/catalog.dart';
import 'package:flutter/material.dart';

class ItemWidget extends StatelessWidget {
  final Item item;
  const ItemWidget({Key key, @required this.item})
      : assert(item != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        tileColor: const Color(0xffF3F3F3),
        onTap: () {
          print("${item.name} pressed");
        },
        leading: Image.asset(item.image),
        title: Text(
          item.name,
          style: const TextStyle(color: Color(0xff000000), fontSize: 16),
        ),
        subtitle: Text(
          item.desc,
          style: const TextStyle(color: Color(0xff666666), fontSize: 10),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              item.place,
              style: const TextStyle(
                color: Color(0xff2061E0),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              item.time,
              style: const TextStyle(
                color: Color(0xff2061E0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
