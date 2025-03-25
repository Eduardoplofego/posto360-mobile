import 'package:flutter/material.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class SelectDateWidget extends StatelessWidget {
  final Function(DateTime) onChangePeriod;
  final bool withBackground;
  final bool extendBody;
  final String period;
  const SelectDateWidget({
    super.key,
    required this.onChangePeriod,
    this.withBackground = false,
    this.extendBody = false,
    required this.period,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: withBackground ? EdgeInsets.all(14) : null,
      decoration:
          withBackground
              ? BoxDecoration(
                color: PostoAppUiConfigurations.lightPurpleColor,
                borderRadius: BorderRadius.circular(10),
              )
              : null,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                Icons.calendar_month_outlined,
                color: PostoAppUiConfigurations.blueMediumColor,
                size: 22,
              ),
              const SizedBox(width: 5),
              Text(
                'Período: ',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
              ),
              Text(
                period,
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
              extendBody ? Spacer() : const SizedBox.shrink(),
              InkWell(
                onTap: () async {
                  final selected = await showMonthYearPicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2024),
                    lastDate: DateTime.now(),
                    locale: Locale('pt', 'BR'),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          primaryColor:
                              PostoAppUiConfigurations.blueMediumColor,
                          hintColor: PostoAppUiConfigurations.blueMediumColor,
                          colorScheme: ColorScheme.light(
                            primary: PostoAppUiConfigurations.blueMediumColor,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  PostoAppUiConfigurations.blueMediumColor,
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (selected != null) {
                    onChangePeriod(selected);
                  }
                },
                child: Icon(Icons.keyboard_arrow_right_outlined),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
