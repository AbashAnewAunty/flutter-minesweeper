import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:group_button/group_button.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/utils/app_tracking_requester.dart';
import 'package:minesweeper/view_model/start_page_view_model.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late final GroupButtonController _groupButtonController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<StartPageViewModel>();
    _groupButtonController = GroupButtonController(selectedIndex: viewModel.difficulty.index);

    // build完了後処理
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // ATTダイアログ
      await AppTrackingRequester.instance.requestPermission();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.blueGrey,
      child: SafeArea(
        child: ColoredBox(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.blueGrey, width: 2),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Text(
                  "Mine Cleaner",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text("choose difficulty and tap Quick Play !"),
              const SizedBox(height: 10),
              _quickPlayButton(context),
              const SizedBox(height: 60),
              GroupButton(
                buttons: const ["Easy", "Normal", "Hard"],
                controller: _groupButtonController,
                onSelected: (text, index, isSelected) async {
                  final startPageViewModel = context.read<StartPageViewModel>();
                  final Difficulty difficulty = Difficulty.values.toList().elementAt(index);
                  await startPageViewModel.setDifficulty(difficulty);
                },
                options: const GroupButtonOptions(groupingType: GroupingType.column),
                buttonBuilder: (isSelected, text, context) {
                  return Container(
                    constraints: BoxConstraints(maxWidth: isSelected ? 200 : 150),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blueGrey : Colors.transparent,
                      borderRadius: BorderRadius.circular(isSelected ? 8 : 5),
                      border: Border.all(
                        width: 2,
                        color: isSelected ? Colors.blueGrey : Colors.blueGrey,
                      ),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Text(
                          text,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.blueGrey,
                            fontSize: isSelected ? 18 : 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _quickPlayButton(BuildContext context) {
    return InkWell(
      onTap: () => GoRouter.of(context).go("/home/game"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7.5),
        decoration: BoxDecoration(
          color: Colors.blueGrey,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(128),
              blurRadius: 2,
              spreadRadius: 2,
              offset: const Offset(5, 5),
            ),
          ],
        ),
        child: const Text(
          "Quick Play",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
