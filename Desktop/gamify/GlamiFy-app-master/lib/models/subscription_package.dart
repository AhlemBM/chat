class SubscriptionPackage {
  final String title;
  final int maxReservations;
  final double monthlyPrice;
  final double yearlyPrice;
  final int includedBusinessAccounts;
  final int includedStaffAccounts;
  final double additionalStaffPrice;
  final bool isContactUs;
  final bool isPremium;
  final List<String> features;
  final bool hasFreeTrial;

  SubscriptionPackage({
    required this.title,
    required this.maxReservations,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.includedBusinessAccounts,
    required this.includedStaffAccounts,
    required this.additionalStaffPrice,
    required this.isContactUs,
    required this.isPremium,
    required this.features,
    this.hasFreeTrial = false,
  });

  double getPrice(bool isMonthly) {
    return isMonthly ? monthlyPrice : yearlyPrice;
  }

  double getYearlySavingsPercentage() {
    double monthlyTotal = monthlyPrice * 12;
    double yearlySavings = monthlyTotal - yearlyPrice;
    return (yearlySavings / monthlyTotal) * 100;
  }

  static final List<SubscriptionPackage> monthlyPackages = [
    SubscriptionPackage(
      title: 'Starter',
      maxReservations: 30,
      monthlyPrice: 29.99,
      yearlyPrice: 287.90,
      includedBusinessAccounts: 1,
      includedStaffAccounts: 2,
      additionalStaffPrice: 5.99,
      isContactUs: false,
      isPremium: false,
      hasFreeTrial: true,
      features: [
        'First 30 days free',
        'Up to 30 reservations/month',
        '1 Business account',
        '2 Staff accounts',
        'Basic analytics',
        'Email support',
      ],
    ),
    SubscriptionPackage(
      title: 'Basic',
      maxReservations: 50,
      monthlyPrice: 39.99,
      yearlyPrice: 383.90,
      includedBusinessAccounts: 1,
      includedStaffAccounts: 3,
      additionalStaffPrice: 5.99,
      isContactUs: false,
      isPremium: false,
      features: [
        'Up to 50 reservations/month',
        '1 Business account',
        '3 Staff accounts',
        'Basic analytics',
        'Email & chat support',
      ],
    ),
    SubscriptionPackage(
      title: 'Premium',
      maxReservations: 100,
      monthlyPrice: 49.99,
      yearlyPrice: 479.90,
      includedBusinessAccounts: 2,
      includedStaffAccounts: 5,
      additionalStaffPrice: 4.99,
      isContactUs: false,
      isPremium: true,
      hasFreeTrial: true,
      features: [
        'First 30 days free',
        'Up to 100 reservations/month',
        '2 Business accounts',
        '5 Staff accounts',
        'Advanced analytics',
        'Priority email & chat support',
        'Custom branding',
        'API access',
      ],
    ),
    SubscriptionPackage(
      title: 'Unlimited',
      maxReservations: -1,
      monthlyPrice: 99.99,
      yearlyPrice: 959.90,
      includedBusinessAccounts: -1,
      includedStaffAccounts: -1,
      additionalStaffPrice: 3.99,
      isContactUs: true,
      isPremium: false,
      features: [
        'Unlimited reservations',
        'Unlimited business accounts',
        'Unlimited staff accounts',
        'Enterprise analytics',
        '24/7 Priority support',
        'Custom branding',
        'API access',
        'Dedicated account manager',
        'Custom integration support',
      ],
    ),
  ];

  static final List<SubscriptionPackage> yearlyPackages = [
    SubscriptionPackage(
      title: 'Basic',
      maxReservations: 50,
      monthlyPrice: 39.99,
      yearlyPrice: 383.90,
      includedBusinessAccounts: 1,
      includedStaffAccounts: 3,
      additionalStaffPrice: 5.99,
      isContactUs: false,
      isPremium: false,
      hasFreeTrial: true,
      features: [
        'First 30 days free',
        'Up to 50 reservations/month',
        '1 Business account',
        '3 Staff accounts',
        'Basic analytics',
        'Email & chat support',
        '20% yearly discount',
      ],
    ),
    SubscriptionPackage(
      title: 'Premium',
      maxReservations: 100,
      monthlyPrice: 49.99,
      yearlyPrice: 479.90,
      includedBusinessAccounts: 2,
      includedStaffAccounts: 5,
      additionalStaffPrice: 4.99,
      isContactUs: false,
      isPremium: true,
      hasFreeTrial: true,
      features: [
        'First 30 days free',
        'Up to 100 reservations/month',
        '2 Business accounts',
        '5 Staff accounts',
        'Advanced analytics',
        'Priority email & chat support',
        'Custom branding',
        'API access',
        '20% yearly discount',
      ],
    ),
    SubscriptionPackage(
      title: 'Unlimited',
      maxReservations: -1,
      monthlyPrice: 99.99,
      yearlyPrice: 959.90,
      includedBusinessAccounts: -1,
      includedStaffAccounts: -1,
      additionalStaffPrice: 3.99,
      isContactUs: true,
      isPremium: false,
      hasFreeTrial: true,
      features: [
        'First 30 days free',
        'Unlimited reservations',
        'Unlimited business accounts',
        'Unlimited staff accounts',
        'Enterprise analytics',
        '24/7 Priority support',
        'Custom branding',
        'API access',
        'Dedicated account manager',
        'Custom integration support',
        '20% yearly discount',
      ],
    ),
  ];

  static List<SubscriptionPackage> getPackages(bool isMonthly) {
    return isMonthly ? monthlyPackages : yearlyPackages;
  }
}
