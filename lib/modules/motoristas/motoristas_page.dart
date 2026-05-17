import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/drawer/posto_app_drawer.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/menu_icon_button_widget.dart';
import 'package:posto360/modules/motoristas/widgets/filial_card_widget.dart';
import './motoristas_controller.dart';

class MotoristasPage extends GetView<MotoristasController> {
  const MotoristasPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Filiais',
        leading: MenuIconButtonWidget(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: const [],
      ),
      drawer: PostoAppDrawer(
        autheticatedUser: Get.find<AuthService>().getUser()!,
        onSavePhoto: controller.onSavePhoto,
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: SizedBox(
              width: 35,
              height: 35,
              child: CircularProgressIndicator(
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
          );
        }
        if (controller.hasError) {
          return _errorState(controller.errorMessage!);
        }
        if (!controller.hasFiliais) {
          return _emptyState();
        }
        return RefreshIndicator.noSpinner(
          onRefresh: controller.onRefresh,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemCount: controller.filiais.length,
            itemBuilder: (context, index) =>
                FilialCardWidget(filial: controller.filiais[index]),
          ),
        );
      }),
    );
  }

  Widget _errorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red.shade400,
            ),
            const SizedBox(height: 12),
            Text(
              'Não foi possível carregar',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: PostoAppUiConfigurations.textDarkColor,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: PostoAppUiConfigurations.greyColor,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: controller.onRefresh,
              icon: Icon(
                Icons.refresh,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
              label: Text(
                'Tentar novamente',
                style: TextStyle(
                  color: PostoAppUiConfigurations.blueMediumColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_gas_station_outlined,
              size: 64,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(height: 12),
            Text(
              'Nenhuma filial disponível no momento',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: PostoAppUiConfigurations.greyColor,
              ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: controller.onRefresh,
              icon: Icon(
                Icons.refresh,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
              label: Text(
                'Atualizar',
                style: TextStyle(
                  color: PostoAppUiConfigurations.blueMediumColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
