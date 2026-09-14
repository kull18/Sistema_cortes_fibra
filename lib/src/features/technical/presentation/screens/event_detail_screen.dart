import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sistema_cortes_fibra/src/core/app_routes.dart';
import 'package:sistema_cortes_fibra/src/core/theme/theme_extensions.dart';
import 'package:sistema_cortes_fibra/src/features/technical/domain/entities/fiber_event.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/event_detail_app_bar.dart';
import '../widgets/event_detail_body.dart';
import '../widgets/add_comment_bottom_bar.dart';
import '../widgets/add_technical_note_modal.dart';
import '../providers/event_detail_provider.dart';

class EventDetailScreen extends StatefulWidget {
  final FiberEvent? event;
  final int? eventId;

  const EventDetailScreen({
    super.key,
    this.event,
    this.eventId,
  });

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final idToLoad = widget.event?.id ?? (widget.eventId != null ? widget.eventId.toString() : null);
      if (idToLoad != null) {
        context.read<EventDetailProvider>().loadEventDetail(idToLoad);
      }
    });
  }

  void _onTabSelected(AppTab tab) {
    if (tab == AppTab.eventos) return;

    switch (tab) {
      case AppTab.inicio:
        Navigator.of(context).pushReplacementNamed('/home');
        break;
      case AppTab.eventos:
        break;
      case AppTab.perfil:
        Navigator.of(context).pushReplacementNamed('/perfil');
        break;
      case AppTab.reportar:
        Navigator.of(context).pushNamed('/reportar-evento');
        break;
      case AppTab.centrales:
        Navigator.of(context).pushReplacementNamed('/centrales');
        break;
    }
  }

  void _showAddCommentSheet() {
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    final currentEventId = context.read<EventDetailProvider>().event?.id ?? widget.event?.id ?? 'EV-${widget.eventId}';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddTechnicalNoteModal(
          eventId: currentEventId,
          userName: user?.fullName ?? 'Técnico',
          technicianCode: user?.technicianCode ?? 'N/A',
          avatarUrl: user?.profilePhotoUrl,
          onSave: (content) async {
            final provider = context.read<EventDetailProvider>();
            final success = await provider.addComment(content);
            
            if (!mounted) return false;

            if (success) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Comentario agregado correctamente'),
                  backgroundColor: Colors.green,
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(provider.error ?? 'Error al agregar comentario'),
                  backgroundColor: Colors.red,
                ),
              );
            }
            return success;
          },
        ),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context, String errorMessage) {
    final colors = context.colors;
    final isUnauthorized = errorMessage.contains('Inicia sesión');

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: const Text('Detalle de Evento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                isUnauthorized ? Icons.lock_outline : Icons.error_outline,
                size: 64,
                color: isUnauthorized ? colors.primaryBlue : colors.statusRed,
              ),
              const SizedBox(height: 16),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (isUnauthorized) {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                  } else {
                    final idToLoad = widget.event?.id ?? (widget.eventId != null ? widget.eventId.toString() : null);
                    if (idToLoad != null) {
                      context.read<EventDetailProvider>().loadEventDetail(idToLoad);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: Text(isUnauthorized ? 'Iniciar Sesión' : 'Reintentar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EventDetailProvider>(
      builder: (context, provider, child) {
        if (provider.error != null && provider.event == null && widget.event == null) {
          return _buildErrorView(context, provider.error!);
        }

        final currentEvent = provider.event ?? widget.event;

        if (currentEvent == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detalle de Evento')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return AppScaffold(
          currentTab: AppTab.eventos,
          onTabSelected: _onTabSelected,
          appBar: EventDetailAppBar(
            folio: currentEvent.id,
            onBack: () => Navigator.pop(context),
          ),
          body: provider.isLoading && provider.event == null
              ? const Center(child: CircularProgressIndicator())
              : Stack(
                  children: [
                    EventDetailBody(
                      event: currentEvent,
                      photos: provider.photos,
                      comments: provider.comments,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: AddCommentBottomBar(
                        onAddComment: _showAddCommentSheet,
                      ),
                    ),
                  ],
                ),
          isScrollable: false,
          padding: EdgeInsets.zero,
        );
      },
    );
  }
}
