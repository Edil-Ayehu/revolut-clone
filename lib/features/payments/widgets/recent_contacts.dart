import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/models/contact.dart';

class RecentContacts extends StatelessWidget {
  const RecentContacts({super.key});

  @override
  Widget build(BuildContext context) {
    final contacts = _getMockContacts();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Contacts',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all contacts
              },
              child: const Text('View all'),
            ),
          ],
        ),
        const SizedBox(height: AppConstants.paddingM),
        
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: contacts.length + 1, // +1 for "Add Contact" button
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddContactButton(context);
              }
              
              final contact = contacts[index - 1];
              return _buildContactItem(context, contact);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddContactButton(BuildContext context) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: AppConstants.paddingM),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusXL),
              border: Border.all(
                color: AppColors.primary,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Icon(
              Icons.add,
              color: AppColors.primary,
              size: AppConstants.iconL,
            ),
          ),
          const SizedBox(height: AppConstants.paddingS),
          Text(
            'Add',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(BuildContext context, Contact contact) {
    return Container(
      width: 70,
      margin: const EdgeInsets.only(right: AppConstants.paddingM),
      child: GestureDetector(
        onTap: () {
          // TODO: Handle contact selection for quick payment
        },
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  backgroundImage: contact.avatar != null 
                      ? NetworkImage(contact.avatar!)
                      : null,
                  child: contact.avatar == null
                      ? Text(
                          contact.initials,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.textOnPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                if (contact.isFavorite)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: AppColors.surface,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.star,
                        color: AppColors.textOnPrimary,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              contact.name.split(' ').first,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  List<Contact> _getMockContacts() {
    return [
      Contact(
        id: '1',
        name: 'Alice Johnson',
        email: 'alice@example.com',
        isFavorite: true,
        lastTransactionDate: DateTime.now().subtract(const Duration(days: 1)),
        lastTransactionAmount: 25.50,
      ),
      Contact(
        id: '2',
        name: 'Bob Smith',
        phone: '+1234567890',
        lastTransactionDate: DateTime.now().subtract(const Duration(days: 3)),
        lastTransactionAmount: 100.00,
      ),
      Contact(
        id: '3',
        name: 'Charlie Brown',
        email: 'charlie@example.com',
        isFavorite: true,
        lastTransactionDate: DateTime.now().subtract(const Duration(days: 5)),
        lastTransactionAmount: 75.25,
      ),
      Contact(
        id: '4',
        name: 'Diana Prince',
        phone: '+0987654321',
        lastTransactionDate: DateTime.now().subtract(const Duration(days: 7)),
        lastTransactionAmount: 200.00,
      ),
      Contact(
        id: '5',
        name: 'Edward Wilson',
        email: 'edward@example.com',
        lastTransactionDate: DateTime.now().subtract(const Duration(days: 10)),
        lastTransactionAmount: 50.00,
      ),
    ];
  }
}
