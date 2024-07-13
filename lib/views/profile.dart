import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teach_app/core/colors.dart';
import 'package:teach_app/core/extensions.dart';
import 'package:teach_app/core/paddings_borders.dart';
import 'package:teach_app/models/learn_by_self_model.dart';
import 'package:teach_app/models/user_model.dart';
import 'package:teach_app/repositories/user_repository.dart';
import 'package:teach_app/views/global_widgets.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final List<Map<String, dynamic>> _statistics;
  late final UserModel _user;
  @override
  void initState() {
    _user = context.read<UserRepository>().user!;
    _statistics = [
      {"title": "Öğrenilen", "value": _user.learningWord?.length ?? 0},
      {"title": "Skor", "value": ((_user.learnedWord?.length ?? 0) + (_user.learningWord?.length ?? 0)) * 5},
      {"title": "Öğrenilmiş", "value": _user.learnedWord?.length ?? 0}
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: SizedBox(
            width: context.deviceWidth * 0.9,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Card(
                    elevation: 5,
                    child: Padding(
                      padding: PaddingConstant.paddingAll,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const CircleAvatar(
                                radius: 35,
                              ),
                              Expanded(
                                child: ListTile(
                                  title: const Text("Vahan Dağ"),
                                  subtitle: const Text("Seviye: B-1"),
                                  trailing: IconButton(
                                      onPressed: () {
                                        print(context.read<UserRepository>().user?.uid);
                                      },
                                      icon: const Icon(Icons.edit_square)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // _learnCard(context: context, title: "İstatistik", width: 125),
                  Column(
                    children: [
                      Text(
                        "İstatistiklerin",
                        style: context.textTheme.titleMedium,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ...List.generate(_statistics.length, (index) {
                            final statistic = _statistics[index];
                            return Container(
                                margin: PaddingConstant.paddingAllLow,
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                                        image: AssetImage("assets/images/backgrounds/bg-${index + 1}.webp")),
                                    borderRadius: BorderRadiusConstant.borderRadius),
                                height: context.deviceHeight * 0.2,
                                width: ((context.deviceWidth * 0.9) - (10 * _statistics.length)) / _statistics.length,
                                child: _statisticText(context, statistic["title"], statistic["value"]));
                          }),
                        ],
                      ),
                    ],
                  ),
                  Card(
                    margin: PaddingConstant.paddingVerticalHigh,
                    elevation: 5,
                    child: Column(
                      children: [
                        Padding(
                          padding: PaddingConstant.paddingAllHigh,
                          child: Text(
                            "İlerleyiş",
                            style: context.textTheme.titleMedium,
                          ),
                        ),
                        BarChartSample1()
                      ],
                    ),
                  ),
                  _learnCard(
                      wordList: _user.learningWord ?? [],
                      context: context,
                      title: "Öğreneceğim Kelimeler",
                      hasNoWordIcon: Icons.language_sharp,
                      hasNoWordText: "Hala öğrenmeye başlamadın mı?",
                      hasNoWordText2: "Hepsini bitirdin herhalde.."),
                  _learnCard(
                      wordList: _user.learnedWord ?? [],
                      context: context,
                      title: "Öğrendiğim Kelimeler",
                      hasNoWordIcon: Icons.deblur_rounded,
                      hasNoWordText: "Henüz hiç kelime öğrenmemişsin"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statisticText(BuildContext context, String text, int value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Text(
          text,
          style: context.textTheme.bodyMedium?.copyWith(color: Colors.white),
        ),
        Text(
          value == 0 ? value.toString() : "+ $value",
          style: context.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _learnCard(
      {required BuildContext context,
      required String title,
      double? width = 175,
      required String hasNoWordText,
      required List<WordByUserModel> wordList,
      String? hasNoWordText2,
      required IconData hasNoWordIcon}) {
    return Container(
      width: context.deviceWidth,
      margin: PaddingConstant.paddingVerticalHigh,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: PaddingConstant.paddingOnlyLeftHigh,
            child: Text(
              title,
              style: context.textTheme.titleMedium,
            ),
          ),
          Container(
              margin: PaddingConstant.paddingVertical,
              height: context.deviceHeight * 0.2,
              child: (wordList.isNotEmpty ?? false)
                  ? ListView.builder(
                      itemCount: wordList.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final word = wordList[index];
                        return Container(
                          margin: PaddingConstant.paddingHorizontal,
                          width: width,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              border: Border.all(width: 1.2, color: Colors.grey.shade700),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  colorFilter: const ColorFilter.mode(Colors.black45, BlendMode.color),
                                  image: NetworkImage(word.wordImageUrl ?? "")),
                              borderRadius: BorderRadiusConstant.borderRadiusMedium),
                          child: Text(
                            word.nativeWord?.toUpperCase() ?? "",
                            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        );
                      },
                    )
                  : userHasNoLearnWord(context: context, text: hasNoWordText, text2: hasNoWordText2, icon: hasNoWordIcon)),
        ],
      ),
    );
  }
}

class BarChartSample1 extends StatefulWidget {
  BarChartSample1({super.key});

  List<Color> get availableColors => const <Color>[
        AppColors.contentColorPurple,
        AppColors.contentColorYellow,
        AppColors.contentColorBlue,
        AppColors.contentColorOrange,
        AppColors.contentColorPink,
        AppColors.contentColorRed,
      ];

  final Color barBackgroundColor = AppColors.contentColorBlack.withOpacity(0.3);
  final Color barColor = AppColors.contentColorBlue;
  final Color touchedBarColor = AppColors.contentColorGreen;

  @override
  State<StatefulWidget> createState() => BarChartSample1State();
}

class BarChartSample1State extends State<BarChartSample1> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: BarChart(
          mainBarData(),
          swapAnimationDuration: animDuration,
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched ? BorderSide(color: widget.touchedBarColor) : null,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 11.5, // Günük hedef kelime sayısı
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, 5, isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, 6.5, isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, 5, isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, 7.5, isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, 9, isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, 11.5, isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, 6.5, isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipRoundedRadius: 10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Pazartesi';
                break;
              case 1:
                weekDay = 'Salı';
                break;
              case 2:
                weekDay = 'Çarşamba';
                break;
              case 3:
                weekDay = 'Perşembe';
                break;
              case 4:
                weekDay = 'Cuma';
                break;
              case 5:
                weekDay = 'Cumartesi';
                break;
              case 6:
                weekDay = 'Pazar';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white, //widget.touchedBarColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions || barTouchResponse == null || barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 35,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('Pzt', style: style);
        break;
      case 1:
        text = const Text('Salı', style: style);
        break;
      case 2:
        text = const Text('Çar', style: style);
        break;
      case 3:
        text = const Text('Per', style: style);
        break;
      case 4:
        text = const Text('Cuma', style: style);
        break;
      case 5:
        text = const Text('Cmt', style: style);
        break;
      case 6:
        text = const Text('Pz', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }
}
