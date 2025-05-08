import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Section
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('Assets/images/jit.jpg'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                ),
                const SizedBox(height: 20),
                // Title and Rating
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Jimma University Institute of Technology',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                        const Icon(Icons.star, color: Colors.yellow, size: 18),
                        const Icon(Icons.star_border, color: Colors.yellow, size: 18),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Location
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.black54, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      'Jimma - Oromia - Gabriel',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Description
                Text(
                  'Jimma Institute of Technology (JIT) is a prominent engineering and technology institute and a part of Jimma University. Established in 1997, the institute began with three departments: Civil Engineering, Electrical Engineering, and Mechanical Engineering. Over time, it has expanded to include more programs and facilities.',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                // Student Count
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.black54, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      'Students: 3000',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Academic Time
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.black54, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      'Nov - June',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Review
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.yellow, size: 18),
                    const SizedBox(width: 5),
                    Text(
                      '4.5 Stars',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}