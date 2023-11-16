import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:minesweeper/constant.dart';
import 'package:minesweeper/view_model/start_page_view_model.dart';
import 'package:provider/provider.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late final GroupButtonController _groupButtonController;

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<StartPageViewModel>();
    _groupButtonController =
        GroupButtonController(selectedIndex: viewModel.difficulty.index);
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
              const Text(
                "Minesweeper",
                style: TextStyle(fontSize: 22),
              ),
              const SizedBox(height: 5),
              const Text("choose difficulty and tap Quick Play !"),
              const SizedBox(height: 10),
              _quickPlayButton(context),
              const SizedBox(height: 20),
              GroupButton(
                buttons: const ["Easy", "Normal", "Hard"],
                controller: _groupButtonController,
                onSelected: (text, index, isSelected) async {
                  final startPageViewModel = context.read<StartPageViewModel>();
                  final Difficulty difficulty =
                      Difficulty.values.toList().elementAt(index);
                  await startPageViewModel.setDifficulty(difficulty);
                },
                options:
                    const GroupButtonOptions(groupingType: GroupingType.column),
                buttonBuilder: (isSelected, text, context) {
                  return Container(
                    constraints:
                        BoxConstraints(maxWidth: isSelected ? 200 : 150),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.redAccent : Colors.grey,
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
                            color: Colors.white,
                            fontSize: isSelected ? 18 : 14,
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
    return ElevatedButton(
      onPressed: () => Navigator.of(context).pushNamed("/game"),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
      child: const Text("Quick Play", style: TextStyle(fontSize: 18)),
    );
  }
}
