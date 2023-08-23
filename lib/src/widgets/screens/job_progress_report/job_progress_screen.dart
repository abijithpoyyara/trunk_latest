import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/job_progress/job_progress_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/job_progress/job_progress_viewmodel.dart';
import 'package:redstars/src/widgets/screens/job_progress_report/partials/progress_flow_tile.dart';

import 'job_progress_detail_screen.dart';

class JobProgressScreen extends StatelessWidget {
  const JobProgressScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme  style= BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return BaseView<AppState, JobProgressViewModel>(
        init: (store, context) => store.dispatch(getJobProgressConfigs()),
        converter: (store) => JobProgressViewModel.fromStore(store),
        appBar: BaseAppBar(title: Text("Job Progress Report")),
        builder: (context, viewModel) {
          return Container(
            color:themeData.primaryColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     "Process Flows",
                //     style: BaseTheme.of(context).title.copyWith(color: ),
                //   ),
                // ),
                Expanded(
                  child: GridView.builder(
                      padding: EdgeInsets.all(8),
                      shrinkWrap: true,
                      itemCount: viewModel.processFlows?.length ?? 0,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        mainAxisSpacing: 16.0,
                        crossAxisSpacing: 4.0,
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, pos) {
                        var process = viewModel.processFlows[pos];

                        return ProgressFlowTile(
                            position: pos,
                            primaryTitle: "${process.description} ",
                            count: 0,
                            primaryIcon: Icons.view_agenda,
                            onClick: () {
                              // viewModel.onProcessFlowSelected(process);
                              BaseNavigate(
                                  context,
                                  JobProgressDetailScreen(
                                    process: process,
                                  ));
                            });
                      }),
                ),
              ],
            ),
          );
        });
  }
}
