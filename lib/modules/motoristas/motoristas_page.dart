import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/drawer/posto_app_drawer.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/menu_icon_button_widget.dart';
import 'package:posto360/modules/core/domain/ui/widgets/loading/card_loading_widget.dart';
import 'package:posto360/modules/dash/widgets/card_chamados_widget.dart';
import 'package:posto360/modules/dash/widgets/card_procedimentos_widget.dart';
import 'package:posto360/modules/dash/widgets/profile_card_widget.dart';
import 'package:posto360/modules/motoristas/widgets/filial_card_widget.dart';
import './motoristas_controller.dart';

class MotoristasPage extends GetView<MotoristasController> {
  const MotoristasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: PreferredSize(
        preferredSize: CustomAppBar.preferredSizeFor(),
        child: Obx(
          () => CustomAppBar(
            title: controller.currentTab == 0 ? 'Início' : 'Carregamentos',
            leading: MenuIconButtonWidget(
              onPressed: () {
                controller.scaffoldKey.currentState?.openDrawer();
              },
            ),
            actions: [],
          ),
        ),
      ),
      drawer: PostoAppDrawer(
        autheticatedUser: Get.find<AuthService>().getUser()!,
        onSavePhoto: controller.onSavePhoto,
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentTab,
          children: [_buildInicioTab(), _buildCarregamentosTab()],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentTab,
          onTap: controller.changeTab,
          selectedItemColor: PostoAppUiConfigurations.blueMediumColor,
          unselectedItemColor: PostoAppUiConfigurations.darkGreyColor,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Início',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_shipping_outlined),
              activeIcon: Icon(Icons.local_shipping),
              label: 'Carregamentos',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInicioTab() {
    return RefreshIndicator.noSpinner(
      onRefresh: controller.onRefresh,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: ListView(
          children: [
            const SizedBox(height: 8),
            CardLoadingWidget(
              isLoading: controller.isLoading,
              height: 80,
              initDelay: 50,
              child: ProfileCardWidget(
                photoUrl: controller.photoUrl,
                nome: controller.nameUser,
                tipoUsuario: controller.autheticatedUser.tipoUsuario,
              ),
            ),
            const SizedBox(height: 26),
            CardLoadingWidget(
              isLoading: controller.isLoading,
              height: 160,
              initDelay: 180,
              child: CardProcedimentosWidget(
                onPressed: () {
                  Get.toNamed('/procedimentos');
                },
              ),
            ),
            const SizedBox(height: 17),
            CardLoadingWidget(
              isLoading: controller.isLoading,
              height: 160,
              initDelay: 210,
              child: CardChamadosWidget(
                onPressed: () {
                  Get.toNamed('/chamados');
                },
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildCarregamentosTab() {
    if (controller.isLoading) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Center(
          child: SizedBox(
            width: 35,
            height: 35,
            child: CircularProgressIndicator(
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
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
