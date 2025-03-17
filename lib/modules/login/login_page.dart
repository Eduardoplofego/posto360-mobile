import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/posto_app_text_form_field.dart';
import './login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Stack(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Image.asset('assets/images/executives.png')],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: context.height * .65,
                          width: context.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              Container(
                                height: 5,
                                width: 120,
                                color: PostoAppUiConfigurations.greyColor,
                              ),
                              const SizedBox(height: 27),
                              Image.asset(
                                'assets/images/logo.png',
                                width: context.width * .4,
                              ),
                              const SizedBox(height: 27),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Bem-vindo a ',
                                    style: PostoAppUiConfigurations.textNormal,
                                  ),
                                  Text(
                                    'Posto 360 👋',
                                    style: PostoAppUiConfigurations.textBold,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Entre e tenha uma experiência incrível!',
                                style: PostoAppUiConfigurations.textNormal
                                    .copyWith(color: Colors.grey, fontSize: 18),
                              ),
                              const SizedBox(height: 28),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Form(
                                  child: Column(
                                    children: [
                                      PostoAppTextFormField(
                                        label: 'Digite o seu e-mail',
                                        obscureText: false,
                                      ),
                                      const SizedBox(height: 14),
                                      PostoAppTextFormField(
                                        label: 'Senha',
                                        obscureText: true,
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        height: 48,
                                        width: context.width,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          child: Text(
                                            'Entrar',
                                            style: PostoAppUiConfigurations
                                                .textNormal
                                                .copyWith(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 21),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  'Esqueceu sua senha?',
                                  style: PostoAppUiConfigurations.textNormal
                                      .copyWith(
                                        fontSize: 16,
                                        color:
                                            PostoAppUiConfigurations
                                                .blueLightColor,
                                        decoration: TextDecoration.underline,
                                      ),
                                ),
                              ),
                              Spacer(),
                              Text('©Posto360'),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
