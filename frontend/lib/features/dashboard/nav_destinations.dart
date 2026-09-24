import 'package:flutter/widgets.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class NavDestination {
  const NavDestination({
    required this.label,
    required this.path,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final String label;
  final String path;
  final IconData icon;
  final String title;
  final String subtitle;
}

const _addressesSubtitle =
    'Keep track of your addresses,  location updates. Edit, Delete, Update '
    'and see all your saved addresses';

const navDestinations = [
  // The design's dashboard header reads "Invite & Earn" with this subtitle; kept verbatim
  NavDestination(
    label: 'Dashboard',
    path: '/dashboard',
    icon: LucideIcons.layoutDashboard,
    title: 'Invite & Earn',
    subtitle: _addressesSubtitle,
  ),
  NavDestination(
    label: 'Shipments',
    path: '/shipments',
    icon: LucideIcons.ship,
    title: 'Shipments',
    subtitle: 'Track, manage and pay for every shipment in one place',
  ),
  NavDestination(
    label: 'Our Services',
    path: '/services',
    icon: LucideIcons.globe,
    title: 'Our Services',
    subtitle: 'Explore the shipping services available from Nigeria',
  ),
  NavDestination(
    label: 'Notifications',
    path: '/notifications',
    icon: LucideIcons.bell,
    title: 'Notifications',
    subtitle: 'Updates on your shipments, payments and account',
  ),
  NavDestination(
    label: 'Wallet',
    path: '/wallet',
    icon: LucideIcons.creditCard,
    title: 'Wallet',
    subtitle: 'Fund your wallet and review your transactions',
  ),
  NavDestination(
    label: 'My Addresses',
    path: '/addresses',
    icon: LucideIcons.locateFixed,
    title: 'My Addresses',
    subtitle: _addressesSubtitle,
  ),
  NavDestination(
    label: 'Invite & Earn',
    path: '/invite',
    icon: LucideIcons.badgeDollarSign,
    title: 'Invite & Earn',
    subtitle: 'Invite friends to Myafrimall and earn when they ship',
  ),
  NavDestination(
    label: 'Help Center',
    path: '/help',
    icon: LucideIcons.handHelping,
    title: 'Help Center',
    subtitle: 'Find answers or get in touch with our support team',
  ),
];

NavDestination destinationFor(String location) => navDestinations.firstWhere(
  (destination) => location.startsWith(destination.path),
  orElse: () => navDestinations.first,
);
