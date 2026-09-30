import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:koolbar_demo/design_system/colors.dart';
import 'package:koolbar_demo/features/ride_request/domain/entities.dart';
import 'package:koolbar_demo/features/ride_request/navigation/navigation_impl.dart';

class QuickDestinations extends StatelessWidget {
  final List<SavedLocationEntity>? locations;
  final void Function(double latitude, double longitude) onDestinationSelect;
  final void Function() onNewDestinationClicked;

  const QuickDestinations({
    super.key,
    required this.locations,
    required this.onDestinationSelect,
    required this.onNewDestinationClicked,
  });

  @override
  Widget build(BuildContext context) {
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
              onPressed: onNewDestinationClicked,
            ),
          ),
          ...List.generate(locations?.length ?? 0, (index) {
            final item = locations![index];
            return Padding(
              padding: const .symmetric(horizontal: 5),
              child: ActionChip(
                avatar: item.iconCodePoint == null
                    ? Container()
                    : Icon(
                        Icons.home,
                        color: index == 1
                            ? KoolbarColors.primary
                            : const Color(0xFFD9E5FA),
                        size: 22,
                      ),
                label: Text(
                  item.name,
                  style: const TextStyle(
                    color: Color(0xFFD9E5FA),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: KoolbarColors.surfaceRaised,
                side: const BorderSide(color: KoolbarColors.border),
                shape: const StadiumBorder(),
                onPressed: () {
                  onDestinationSelect(item.latitude, item.longitude);
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
