import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/aulas/domain/models/curso_procedimento_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

/// Abre o passo a passo no módulo de procedimentos.
///
/// A tela de detalhe carrega etapas e passos por conta própria a partir do id
/// da rota, então basta navegar: nada precisa ser passado por argumento.
void abrirProcedimentoDoCurso(int procedimentoId) {
  Get.toNamed('/procedimentos/$procedimentoId');
}

String tituloProcedimentosDoCurso(int quantidade) =>
    quantidade == 1 ? 'Procedimento do curso' : 'Procedimentos do curso';

/// Atalho compacto, para o card da lista de cursos.
///
/// Cabe ao lado das demais informações do card sem roubar a atenção do botão
/// de iniciar o curso.
class CursoProcedimentosResumo extends StatelessWidget {
  final List<CursoProcedimentoModel> procedimentos;

  const CursoProcedimentosResumo({super.key, required this.procedimentos});

  @override
  Widget build(BuildContext context) {
    if (procedimentos.isEmpty) return const SizedBox.shrink();

    // o card alinha os filhos pelo centro: sem largura fixa o bloco ficaria
    // centralizado, fora do prumo do resto das informações
    return SizedBox(
      width: Get.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Text(
            tituloProcedimentosDoCurso(procedimentos.length),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: PostoAppUiConfigurations.greyColor,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                procedimentos
                    .map((p) => _ProcedimentoChip(procedimento: p))
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _ProcedimentoChip extends StatelessWidget {
  final CursoProcedimentoModel procedimento;

  const _ProcedimentoChip({required this.procedimento});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => abrirProcedimentoDoCurso(procedimento.id),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: PostoAppUiConfigurations.lightPurpleColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.menu_book_outlined,
              size: 16,
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
            const SizedBox(width: 6),
            // o Wrap não limita a largura do filho: sem isso um nome longo
            // estoura o card em vez de cortar
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: Get.width * 0.5),
              child: Text(
                procedimento.nome.replaceAll('\n', ' ').trim(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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

/// Seção completa, para dentro da aula.
class CursoProcedimentosWidget extends StatelessWidget {
  final List<CursoProcedimentoModel> procedimentos;

  const CursoProcedimentosWidget({super.key, required this.procedimentos});

  @override
  Widget build(BuildContext context) {
    if (procedimentos.isEmpty) return const SizedBox.shrink();

    return Container(
      width: Get.width,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      margin: const EdgeInsets.only(top: 8),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tituloProcedimentosDoCurso(procedimentos.length),
            style: TextStyle(
              color: PostoAppUiConfigurations.textDarkColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ...procedimentos.map(
            (procedimento) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _ProcedimentoDoCursoItem(procedimento: procedimento),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProcedimentoDoCursoItem extends StatelessWidget {
  final CursoProcedimentoModel procedimento;

  const _ProcedimentoDoCursoItem({required this.procedimento});

  @override
  Widget build(BuildContext context) {
    final nome = procedimento.nome.replaceAll('\n', ' ').trim();
    final descricao = procedimento.descricao.trim();

    return InkWell(
      onTap: () => abrirProcedimentoDoCurso(procedimento.id),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: Get.width,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: PostoAppUiConfigurations.lightGreyBgColor,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          spacing: 14,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.menu_book_outlined,
                color: PostoAppUiConfigurations.blueMediumColor,
                size: 26,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    nome,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: PostoAppUiConfigurations.textDarkColor,
                      height: 1.25,
                    ),
                  ),
                  if (descricao.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      descricao,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
          ],
        ),
      ),
    );
  }
}
