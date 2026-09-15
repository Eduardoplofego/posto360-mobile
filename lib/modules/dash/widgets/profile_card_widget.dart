import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/extra/point_widget.dart';

/// Recebe os dados prontos em vez de ler de um controller, porque nem todo
/// perfil que exibe esse card tem um DashController por tras (o motorista nao
/// tem). Quem chama e responsavel por manter a reatividade.
class ProfileCardWidget extends StatelessWidget {
  final String photoUrl;
  final String nome;
  final String tipoUsuario;

  const ProfileCardWidget({
    super.key,
    required this.photoUrl,
    required this.nome,
    required this.tipoUsuario,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing: 10,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey.shade200,
                    child: Image.network(
                      photoUrl,
                      cacheHeight: 60,
                      cacheWidth: 60,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }

                        return Center(
                          child: CircularProgressIndicator(
                            color: Colors.grey.shade200,
                          ),
                        );
                      },
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        PointWidget(),
                        const SizedBox(width: 6),
                        SizedBox(
                          width: constraints.maxWidth - 94,
                          child: Text(
                            nome,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 16,
                              color: PostoAppUiConfigurations.textDarkColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      tipoUsuario,
                      style: TextStyle(
                        fontSize: 12,
                        color: PostoAppUiConfigurations.darkGreyColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
