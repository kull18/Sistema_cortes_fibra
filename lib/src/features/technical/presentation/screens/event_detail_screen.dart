import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final FiberEvent event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventDetailProvider>().loadEventDetail(widget.event.id);
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddTechnicalNoteModal(
          eventId: widget.event.id,
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

  @override
  Widget build(BuildContext context) {
    return Consumer<EventDetailProvider>(
      builder: (context, provider, child) {
        final currentEvent = provider.event ?? widget.event;

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
