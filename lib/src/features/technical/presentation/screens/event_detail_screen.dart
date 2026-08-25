import 'package:flutter/material.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../models/fiber_event.dart';
import '../../models/technical_comment.dart';
import '../widgets/event_detail_app_bar.dart';
import '../widgets/event_detail_body.dart';
import '../widgets/add_comment_bottom_bar.dart';
import '../widgets/add_technical_note_modal.dart';

class EventDetailScreen extends StatefulWidget {
  final FiberEvent event;

  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  late List<TechnicalComment> _comments;

  @override
  void initState() {
    super.initState();
    // Dummy comments for the UI
    _comments = [
      const TechnicalComment(
        userName: 'Ing. Carlos Mendoza',
        userRole: 'Técnico Líder Cuadrilla Sur',
        userAvatar: '',
        timeAgo: '12 min',
        exactTime: '12:35 PM',
        content:
            'Llegada a sitio confirmada en Km 14.2. Se observa máquina retroexcavadora de obra vial que enganchó la tubería buffer #01. Iniciamos corte limpio e instalación de manga termocontráctil de 48 hilos.',
      ),
      const TechnicalComment(
        userName: 'Roberto Solís',
        userRole: 'Despacho NOC Tuxtla',
        userAvatar: '',
        timeAgo: '25 min',
        exactTime: '11:52 AM',
        content:
            'Alerta notificada a clientes corporativos del segmento San Cristóbal - Tuxtla. Se habilitó ventana de mantenimiento de emergencia de 120 minutos.',
      ),
      const TechnicalComment(
        userName: 'Ana Laura Gómez',
        userRole: 'Cuadrilla Apoyo de Campo',
        userAvatar: '',
        timeAgo: '43 min',
        exactTime: '11:37 AM',
        content:
            'Saliendo del almacén Central TGZ con la fusionadora de alineación con núcleo Fujikura 70S y 2 bobinas de hilo monomodo G.652.D.',
      ),
    ];
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddTechnicalNoteModal(
          eventId: widget.event.id,
          onSave: (content) {
            setState(() {
              _comments.insert(
                0,
                TechnicalComment(
                  userName: 'Carlos Mendoza',
                  userRole: 'Técnico en Campo',
                  userAvatar: '',
                  timeAgo: 'Justo ahora',
                  exactTime: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                  content: content,
                ),
              );
            });
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      currentTab: AppTab.eventos,
      onTabSelected: _onTabSelected,
      appBar: EventDetailAppBar(
        folio: widget.event.id,
        onBack: () => Navigator.pop(context),
      ),
      body: Stack(
        children: [
          EventDetailBody(
            event: widget.event,
            comments: _comments,
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
  }
}
