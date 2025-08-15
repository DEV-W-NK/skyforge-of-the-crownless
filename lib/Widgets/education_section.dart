import 'package:flutter/material.dart';
import 'package:portifolio/Theme/ds3_pallet.dart';

class EducationSection extends StatelessWidget {
  final List<Education> educationList;

  const EducationSection({Key? key, required this.educationList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: educationList.map((edu) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: CyberpunkColors.primaryOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.school,
                  color: CyberpunkColors.primaryOrange,
                  size: 28,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      edu.degree,
                      style: TextStyle(
                        color: CyberpunkColors.primaryOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      edu.institution,
                      style: TextStyle(
                        color: CyberpunkColors.screenTeal,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      edu.period,
                      style: TextStyle(
                        color: CyberpunkColors.mediumGray,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class Education {
  final String degree;
  final String institution;
  final String period;

  Education({
    required this.degree,
    required this.institution,
    required this.period,
  });
}
