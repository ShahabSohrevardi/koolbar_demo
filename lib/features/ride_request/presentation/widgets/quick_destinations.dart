import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koolbar_demo/design_system/colors.dart';
import 'package:koolbar_demo/features/ride_request/navigation/navigation_impl.dart';

class QuickDestinations extends StatelessWidget {
  const QuickDestinations({super.key});

  @override
  Widget build(BuildContext context) {
    var items=[];
    return SizedBox(
          height: 58,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: .symmetric(horizontal: 15),
            children: [
              Padding(
                padding: const .only(right: 5),
                child: ActionChip(
                  label: Text("New"),
                  shape: const StadiumBorder(),
                  avatar: Icon(Icons.add_rounded),
                  onPressed: () {
                    context.router.pushNewSavedLocation();
                  },
                ),
              ),
              ...List.generate(items.length, (index) {
                final item = items[index];
                return Padding(
                  padding: const .symmetric(horizontal: 5),
                  child: ActionChip(
                    avatar: Icon(
                      item.$1,
                      color: index == 1
                          ? KoolbarColors.primary
                          : const Color(0xFFD9E5FA),
                      size: 22,
                    ),
                    label: Text(
                      item.$2,
                      style: const TextStyle(
                        color: Color(0xFFD9E5FA),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    backgroundColor: KoolbarColors.surfaceRaised,
                    side: const BorderSide(color: KoolbarColors.border),
                    shape: const StadiumBorder(),
                    onPressed: () {},
                  ),
                );
              }),
            ],
          ),
        );
  }
}
