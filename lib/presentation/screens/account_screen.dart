// // lib/presentation/screens/account_screen.dart

// import 'package:flutter/material.dart';

// class AccountScreen extends StatelessWidget {
//   const AccountScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const SizedBox(height: 20),
//           const Text(
//             "Account",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 30),

//           // Edit Profile Button
//           ElevatedButton.icon(
//             onPressed: () {
//               // Navigate to Edit Profile screen
//               Navigator.pushNamed(context, '/edit-profile');
//             },
//             icon: const Icon(Icons.edit),
//             label: const Text("Edit Profile"),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: Colors.indigo,
//               foregroundColor: Color.fromARGB(255, 219, 216, 216),
//             ),
//           ),
//           const SizedBox(height: 16),

//           // Saved Address Button
//           ElevatedButton.icon(
//             onPressed: () {
//               // Navigate to Saved Address screen
//               Navigator.pushNamed(context, '/saved-address');
//             },
//             icon: const Icon(Icons.location_on),
//             label: const Text("Saved Address"),
//             style: ElevatedButton.styleFrom(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               backgroundColor: Colors.indigo,
//               foregroundColor: Color.fromARGB(255, 219, 216, 216),
//             ),
//           ),

//           const SizedBox(height: 30),

//           // Optional: You can add more account options here
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

String getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'US';

    final parts = name.trim().split(' ');

    if (parts.length == 1) {
      return parts[0].substring(0, 2).toUpperCase();
    }

    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.userName ?? 'User';
    final initials = getInitials(name);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),

          /// 👤 PROFILE ICON
          Center(
            child: CircleAvatar(
              radius: 36,
              backgroundColor: Colors.indigo,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// USER NAME
          Center(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 30),

          /// Edit Profile
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/edit-profile');
            },
            icon: const Icon(Icons.edit),
            label: const Text("Edit Profile"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),

          const SizedBox(height: 16),

          /// Saved Address
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/saved-address');
            },
            icon: const Icon(Icons.location_on),
            label: const Text("Saved Address"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
