// import 'package:flutter/material.dart';
// import 'package:freshman_guide/clubManager/features/presentation/fourthScreen.dart';

// class PostClubScreen extends StatefulWidget {
//   const PostClubScreen({super.key});

//   @override
//   State<PostClubScreen> createState() => _PostClubScreenState();
// }

// class _PostClubScreenState extends State<PostClubScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _descriptionController = TextEditingController();
//   final _contentController = TextEditingController();

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _contentController.dispose();
//     super.dispose();
//   }

//   void _submitForm() {
//     if (_formKey.currentState!.validate()) {
//       // Form is valid, simulate successful submission
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text('Success'),
//           content: const Text('Post submitted successfully!'),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text('OK'),
//             ),
//           ],
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 400),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   // Header
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           IconButton(
//                               icon: const Icon(Icons.arrow_back),
//                               onPressed: () => Navigator.pop(context)),
//                           const Text(
//                             '9:41 AM',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           IconButton(
//                             icon: const Icon(Icons.notifications),
//                             onPressed: () {
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                         const NotificationsScreen()),
//                               );
//                             },
//                           ),
//                           IconButton(
//                               icon: const Icon(Icons.menu), onPressed: () {}),
//                         ],
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16.0),
//                   // Image Upload Placeholder
//                   GestureDetector(
//                     onTap: () {
//                       // Placeholder for image picker (not functional as per request)
//                     },
//                     child: Container(
//                       height: 150,
//                       width: 300,
//                       color: Colors.grey[300],
//                       child: const Center(child: Text('Add your resource')),
//                     ),
//                   ),
//                   const SizedBox(height: 16.0),
//                   // Form Fields
//                   DropdownButtonFormField<String>(
//                     decoration: InputDecoration(
//                       labelText: 'Category',
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(8.0),
//                       ),
//                     ),
//                     items: const [
//                       DropdownMenuItem(
//                           value: 'your title', child: Text('your title')),
//                     ],
//                     onChanged: (value) {},
//                   ),
//                   const SizedBox(height: 16.0),
//                   _buildTextFormField(
//                     controller: _descriptionController,
//                     label: 'add one line description',
//                     validator: (value) => value == null || value.isEmpty
//                         ? 'Please enter a description'
//                         : null,
//                   ),
//                   const SizedBox(height: 16.0),
//                   _buildTextFormField(
//                     controller: _contentController,
//                     label: 'Your Content Here',
//                     validator: (value) => value == null || value.isEmpty
//                         ? 'Please enter content'
//                         : null,
//                     maxLines: 5,
//                   ),
//                   const Spacer(),
//                   // Buttons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Expanded(
//                         child: OutlinedButton(
//                           onPressed: () => Navigator.pop(context),
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: Colors.grey),
//                             padding: const EdgeInsets.symmetric(vertical: 16.0),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                           ),
//                           child: const Text('Discard'),
//                         ),
//                       ),
//                       const SizedBox(width: 16.0),
//                       Expanded(
//                         child: ElevatedButton(
//                           onPressed: _submitForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF87CEEB),
//                             foregroundColor: Colors.white,
//                             padding: const EdgeInsets.symmetric(vertical: 16.0),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                           ),
//                           child: const Text('Publish'),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTextFormField({
//     required TextEditingController controller,
//     required String label,
//     required String? Function(String?) validator,
//     int? maxLines,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: TextFormField(
//         controller: controller,
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: label,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           errorStyle: const TextStyle(color: Colors.red),
//         ),
//         validator: validator,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:freshman_guide/clubManager/features/providers/club_provider.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freshman_guide/clubManager/features/presentation/fourthScreen.dart';

class PostClubScreen extends StatefulWidget {
  final String? clubId; // Optional clubId passed when navigating to this screen

  const PostClubScreen({super.key, this.clubId});

  @override
  State<PostClubScreen> createState() => _PostClubScreenState();
}

class _PostClubScreenState extends State<PostClubScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _submitForm(BuildContext context) {
    final clubProvider = Provider.of<ClubProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      // Simulate successful post submission
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Post submitted successfully!'),
          actions: [
            TextButton(
              onPressed: () async {
                // Add user to club if clubId is provided
                if (widget.clubId != null &&
                    FirebaseAuth.instance.currentUser != null) {
                  try {
                    await clubProvider.addMember(
                      uid: FirebaseAuth.instance.currentUser!.uid,
                      clubId: widget.clubId!,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Joined club successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error joining club: $e')),
                    );
                  }
                }
                Navigator.pop(context); // Close dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  void _leaveClub(BuildContext context) async {
    final clubProvider = Provider.of<ClubProvider>(context, listen: false);
    if (widget.clubId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No club selected')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Leave Club'),
        content: const Text('Are you sure you want to leave this club?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await clubProvider.leaveClub(widget.clubId!);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Left club successfully!')),
                );
                Navigator.pop(context); // Close dialog
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error leaving club: $e')),
                );
              }
            },
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clubProvider = Provider.of<ClubProvider>(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () => Navigator.pop(context),
                          ),
                          const Text(
                            '9:41 AM',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.notifications),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.menu),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Image Upload Placeholder
                  GestureDetector(
                    onTap: () {
                      // Placeholder for image picker
                    },
                    child: Container(
                      height: 150,
                      width: 300,
                      color: Colors.grey[300],
                      child: const Center(child: Text('Add your resource')),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  // Form Fields
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'your title',
                        child: Text('your title'),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextFormField(
                    controller: _descriptionController,
                    label: 'add one line description',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter a description'
                        : null,
                  ),
                  const SizedBox(height: 16.0),
                  _buildTextFormField(
                    controller: _contentController,
                    label: 'Your Content Here',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter content'
                        : null,
                    maxLines: 5,
                  ),
                  // Loading Indicator
                  if (clubProvider.isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(),
                    ),
                  // Error Message
                  if (clubProvider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        clubProvider.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const Spacer(),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Discard'),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _submitForm(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF87CEEB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          child: const Text('Publish'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  // Leave Club Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: widget.clubId != null
                          ? () => _leaveClub(context)
                          : null,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'Leave Club',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    int? maxLines,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          errorStyle: const TextStyle(color: Colors.red),
        ),
        validator: validator,
      ),
    );
  }
}
