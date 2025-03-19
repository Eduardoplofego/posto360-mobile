import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/posto_app_text_form_field.dart';
import 'package:validatorless/validatorless.dart';
import './login_controller.dart';

class LoginPage extends GetView<LoginController> {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();
  final _loginEC = TextEditingController(
    text: 'augustopereiradesouza@gmail.com',
  );
  final _passwordEC = TextEditingController(text: '123456');

  Future<void> _onLogin() async {
    final formValid = _formKey.currentState?.validate() ?? false;

    if (formValid) {
      controller.login(email: _loginEC.text, password: _passwordEC.text);
    }
  }

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
                          // height: context.height * .65,
                          width: context.width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
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
                                        style:
                                            PostoAppUiConfigurations.textNormal,
                                      ),
                                      Text(
                                        'Posto 360 👋',
                                        style:
                                            PostoAppUiConfigurations.textBold,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Entre e tenha uma experiência incrível!',
                                    style: PostoAppUiConfigurations.textNormal
                                        .copyWith(
                                          color: Colors.grey,
                                          fontSize: 18,
                                        ),
                                  ),
                                  const SizedBox(height: 28),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    child: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          PostoAppTextFormField(
                                            label: 'Digite o seu e-mail',
                                            obscureText: false,
                                            controller: _loginEC,
                                            validator: Validatorless.multiple([
                                              Validatorless.email(
                                                'E-mail incorreto',
                                              ),
                                              Validatorless.required(
                                                'E-mail é obrigatório',
                                              ),
                                            ]),
                                          ),
                                          const SizedBox(height: 14),
                                          PostoAppTextFormField(
                                            label: 'Senha',
                                            obscureText: true,
                                            controller: _passwordEC,
                                            validator: Validatorless.multiple([
                                              Validatorless.required(
                                                'Senha obirgatória',
                                              ),
                                            ]),
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                            height: 48,
                                            width: context.width,
                                            child: ElevatedButton(
                                              onPressed: _onLogin,
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
                                          const SizedBox(height: 21),
                                          TextButton(
                                            onPressed: () {},
                                            child: Text(
                                              'Esqueceu sua senha?',
                                              style: PostoAppUiConfigurations
                                                  .textNormal
                                                  .copyWith(
                                                    fontSize: 16,
                                                    color:
                                                        PostoAppUiConfigurations
                                                            .blueLightColor,
                                                    decoration:
                                                        TextDecoration
                                                            .underline,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  bottom: 22,
                                  top: 60,
                                ),
                                child: Text('©Posto360'),
                              ),
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
