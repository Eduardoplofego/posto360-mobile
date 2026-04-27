import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:posto360/modules/avaliacoes/avaliacoes_routers.dart';
import 'package:posto360/modules/core/domain/bindings/application_bindings.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_theme.dart';
import 'package:posto360/modules/campanhas/campanhas_routers.dart';
import 'package:posto360/modules/checklist/checklists_routers.dart';
import 'package:posto360/modules/aulas/cursos_routers.dart';
import 'package:posto360/modules/dash/dashboard_routers.dart';
import 'package:posto360/modules/fechamento-caixa/fechamento_caixa_routers.dart';
import 'package:posto360/modules/login/login_routers.dart';
import 'package:posto360/modules/core/routers/splash_routers.dart';
import 'package:posto360/modules/registro_pontos/registro_pontos_routers.dart';

class PostoApp extends StatelessWidget {
  const PostoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Posto 360',
      debugShowCheckedModeBanner: false,
      theme: PostoAppTheme.theme,
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        MonthYearPickerLocalizations.delegate,
      ],
      initialBinding: ApplicationBindings(),
      getPages: [
        ...SplashRouters.routes,
        ...LoginRouters.routes,
        ...DashboardRouters.routes,
        ...CampanhasRouters.routes,
        ...CursosRouters.routes,
        ...ChecklistsRouters.routes,
        ...FechamentoCaixaRouters.routes,
        ...RegistroPontosRouters.routes,
        ...AvaliacoesRouters.routes,
      ],
    );
  }
}
