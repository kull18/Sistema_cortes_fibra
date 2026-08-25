import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../core/widgets/connectivity_badge.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/home_provider.dart';
import '../providers/notifications_provider.dart';
import '../widgets/notification_item_card.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/entities/fiber_event.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsProvider>().loadNotifications();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onNotificationTap(NotificationEntity notification) {
    if (!notification.isRead) {
      context.read<NotificationsProvider>().markAsRead(notification.id);
      context.read<HomeProvider>().fetchUnreadCount(silent: true);
    }

    if (notification.relatedEventId != null) {
      Navigator.of(context).pushNamed(
        AppRoutes.eventDetail,
        arguments: FiberEvent(
          id: 'EV-${notification.relatedEventId}',
          title: '',
          description: '',
          originPrefix: '',
          destinationPrefix: '',
          kmReference: '',
          location: '',
          timeLabel: '',
          reporterName: '',
          status: FiberEventStatus.pendiente,
        ),
      );
    }
  }

  String _getIconForType(NotificationType type) {
    switch (type) {
      case NotificationType.eventCreated:
        return 'ic_alarm.svg';
      case NotificationType.eventComment:
        return 'ic_paperclip.svg';
      case NotificationType.eventStatusChanged:
        return 'ic_bolt.svg';
      default:
        return 'ic_bell.svg';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes} min';
    if (diff.inHours < 24) return '${diff.inHours} h';
    if (diff.inDays == 1) return 'Ayer';
    return '${date.day}/${date.month}';
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final homeProvider = context.watch<HomeProvider>();

    return Consumer<NotificationsProvider>(
      builder: (context, provider, child) {
        final filteredNotifications = provider.notifications.where((n) {
          final query = _searchController.text.toLowerCase();
          final matchesSearch = n.title.toLowerCase().contains(query) ||
              n.body.toLowerCase().contains(query);

          if (!matchesSearch) return false;
          if (_selectedFilterIndex == 1) return !n.isRead;
          if (_selectedFilterIndex == 2) return n.type == NotificationType.eventCreated;
          return true;
        }).toList();

        final unreadCount = provider.notifications.where((n) => !n.isRead).length;

        return AppScaffold(
          isScrollable: false, // FIJO: Evita el error de "Vertical viewport was given unbounded height"
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.background,
              child: SafeArea(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back_ios_new, size: 20, color: AppColors.textPrimary),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Notificaciones',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Avisos y Telemetría NOC',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const ConnectivityBadge(),
                    const SizedBox(width: 12),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/ic_bell.svg',
                          width: 24,
                          height: 24,
                          colorFilter: const ColorFilter.mode(AppColors.textPrimary, BlendMode.srcIn),
                        ),
                        if (homeProvider.unreadCount > 0)
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: AppColors.statusRed,
                                shape: BoxShape.circle,
                              ),
                              constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                              child: Text(
                                '${homeProvider.unreadCount}',
                                style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    UserAvatar(
                      imageUrl: user?.profilePhotoUrl,
                      size: 32,
                      showStatusDot: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
          currentTab: null,
          onTabSelected: (tab) {},
          padding: const EdgeInsets.symmetric(horizontal: 16),
          body: RefreshIndicator(
            onRefresh: provider.loadNotifications,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(), // Necesario para que RefreshIndicator funcione con listas cortas
              padding: const EdgeInsets.only(bottom: 32),
              children: [
                const SizedBox(height: 16),
                _buildSummaryCard(provider.notifications.length, unreadCount),
                const SizedBox(height: 20),
                _buildSearchBar(),
                const SizedBox(height: 16),
                _buildFilterChips(provider.notifications.length, unreadCount, provider.notifications.where((n) => n.type == NotificationType.eventCreated).length),
                const SizedBox(height: 20),
                if (provider.isLoading && provider.notifications.isEmpty)
                  const Center(child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: CircularProgressIndicator(),
                  ))
                else if (provider.error != null && provider.notifications.isEmpty)
                  Center(child: Text(provider.error!))
                else if (filteredNotifications.isEmpty)
                    const Center(child: Padding(
                      padding: EdgeInsets.all(40.0),
                      child: Text('No hay notificaciones'),
                    ))
                  else
                    ...filteredNotifications.map((n) => NotificationItemCard(
                      id: n.relatedEventId != null ? 'EV-${n.relatedEventId}' : 'NOT-${n.id}',
                      time: _formatDate(n.createdAt),
                      title: n.title,
                      description: n.body,
                      location: n.type == NotificationType.eventCreated ? 'Nuevo Evento' : 'Aviso NOC',
                      icon: _getIconForType(n.type),
                      isUnread: !n.isRead,
                      onMarkAsRead: () {
                        provider.markAsRead(n.id);
                        homeProvider.fetchUnreadCount(silent: true);
                      },
                      onView: () => _onNotificationTap(n),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(int total, int unread) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.borderSubtle.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SvgPicture.asset(
                  'assets/icons/ic_bell.svg',
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(AppColors.primaryBlue, BlendMode.srcIn),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Avisos Técnicos de Red', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('Monitoreo NOC - Fibra Óptica', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ),
              if (unread > 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: AppColors.statusRed.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                  child: Text('$unread sin leer', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.statusRed)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: $total avisos', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              Row(
                children: const [
                  Icon(Icons.done_all, size: 16, color: AppColors.primaryBlue),
                  SizedBox(width: 4),
                  Text('Marcar todas leídas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      onChanged: (val) => setState(() {}),
      decoration: InputDecoration(
        hintText: 'Buscar por folio, tramo o descripción...',
        hintStyle: const TextStyle(fontSize: 13, color: AppColors.placeholder),
        prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.placeholder),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.borderSubtle.withOpacity(0.3))),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppColors.borderSubtle.withOpacity(0.3))),
      ),
    );
  }

  Widget _buildFilterChips(int total, int unread, int cuts) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('Todas ($total)', 0),
          const SizedBox(width: 8),
          _buildFilterChip('No leídas ($unread)', 1),
          const SizedBox(width: 8),
          _buildFilterChip('Cortes de Fibra ($cuts)', 2),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int index) {
    bool isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilterIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppColors.primaryBlue : AppColors.borderSubtle.withOpacity(0.3)),
        ),
        child: Text(
          label,
          style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Colors.white : AppColors.textSecondary),
        ),
      ),
    );
  }
}