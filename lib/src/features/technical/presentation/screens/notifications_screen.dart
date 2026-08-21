import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/user_avatar.dart';
import '../../../../core/widgets/connectivity_badge.dart';
import '../widgets/notification_item_card.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _selectedFilterIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      // Custom Top Bar for this screen as it has a back button
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
                        child: const Text(
                          '3',
                          style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                const UserAvatar(
                  imageUrl: null,
                  size: 32,
                  showStatusDot: true,
                ),
              ],
            ),
          ),
        ),
      ),
      currentTab: null,
      onTabSelected: (tab) {
        // Handle navigation
      },
      padding: const EdgeInsets.symmetric(horizontal: 16),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Summary Card
          Container(
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
                          Text(
                            'Avisos Técnicos de Red',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            'Monitoreo NOC - Fibra Óptica Regional',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.statusRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: AppColors.statusRed,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '3 sin leer',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.statusRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total: 8 avisos',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: const [
                          Icon(Icons.done_all, size: 16, color: AppColors.primaryBlue),
                          SizedBox(width: 4),
                          Text(
                            'Marcar todas leídas',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Search Bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Buscar por folio, tramo o descripción...',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.placeholder),
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.placeholder),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderSubtle.withOpacity(0.3)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.borderSubtle.withOpacity(0.3)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Todas (8)', 0),
                const SizedBox(width: 8),
                _buildFilterChip('No leídas (3)', 1),
                const SizedBox(width: 8),
                _buildFilterChip('Cortes de Fibra (1)', 2),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Notifications List
          const NotificationItemCard(
            id: 'INC-2025-8874',
            time: '11:35 AM',
            title: 'Alarma Crítica: Corte Físico Detectado',
            description: 'OTDR detecta caída total de señal (-28.5 dB) en tramo TGZ-01 — SCH-02 (Km 14.2). Cañón del...',
            location: 'TGZ — SCH (Km 14.2)',
            icon: 'ic_bolt.svg',
            isUnread: true,
          ),
          const NotificationItemCard(
            id: 'EV-2025-8992',
            time: '11:15 AM',
            title: 'Asignación de Cuadrilla Prioritaria',
            description: 'Se te ha asignado la atención de la incidencia #EV-8992 por Despacho NOC Tuxtla. Requiere...',
            location: 'Cuadrilla Sur #04',
            icon: 'ic_hard_hat.svg',
            isUnread: true,
          ),
          const NotificationItemCard(
            id: 'MNT-2025-014',
            time: '10:30 AM',
            title: 'Mantenimiento Programado SCH-02',
            description: 'Inicio de ventana de pruebas en distribuidor óptico Central San Cristóbal. Hilos #01-#12',
            location: 'Nodo SCH-02',
            icon: 'ic_hard_hat.svg',
            isUnread: true,
          ),
          const NotificationItemCard(
            id: 'INC-2025-8884',
            time: 'Ayer, 18:45',
            title: 'Empalme Finalizado y Señal Restablecida',
            description: 'Cuadrilla #02 confirmó cierre de fusionado en tramo SCL-01 Km 41.8. Potencia óptica...',
            location: 'TGZ — SCL (Km 41.8)',
            icon: 'ic_bolt.svg',
            isUnread: false,
          ),
          const NotificationItemCard(
            id: 'SYS-GPS-09',
            time: 'Ayer, 14:15',
            title: 'Calibración de Precisión GPS en Campo',
            description: 'La telemetría de ubicación de alta precisión (±0.1m) ha sido actualizada para la zona Tuxtla -',
            location: 'Cobertura GPS Regional',
            icon: 'ic_hard_hat.svg',
            isUnread: false,
          ),
          const SizedBox(height: 32),
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
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : AppColors.borderSubtle.withOpacity(0.3),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
