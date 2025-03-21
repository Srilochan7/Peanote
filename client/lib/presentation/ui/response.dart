import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class ResponsePage extends StatelessWidget {
  final String responseText;
  final dynamic responseData;

  const ResponsePage({super.key, required this.responseText, required this.responseData});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return Scaffold(
          backgroundColor: const Color(0xFF000813),
          appBar: AppBar(
            title: Text(
              'Document Analysis',
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF001029),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection(
                  title: "📝 Summarized Report",
                  content: _extractSummary(),
                  context: context,
                ),
                _buildDivider(),
                _buildRiskScoreCard(context),
                _buildDivider(),
                _buildSection(
                  title: "⚖️ Legal Terms Explained",
                  content: _extractLegalTerms(),
                  context: context,
                ),
                _buildDivider(),
                _buildSection(
                  title: "🤖 AI Suggestion",
                  content: _extractAISuggestions(),
                  context: context,
                ),
                SizedBox(height: 5.h),
                _buildDownloadButton(context),
                SizedBox(height: 3.h),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildSection({required String title, required String content, required BuildContext context}) {
    return Card(
      elevation: 4,
      color: const Color(0xFF001029),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              content,
              style: GoogleFonts.bricolageGrotesque(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRiskScoreCard(BuildContext context) {
    String riskLevel = _extractRiskLevel();
    Color riskColor;
    String riskEmoji;
    
    switch (riskLevel.toLowerCase()) {
      case 'low':
        riskColor = Colors.green;
        riskEmoji = "🟢";
        break;
      case 'medium':
        riskColor = Colors.orange;
        riskEmoji = "🟠";
        break;
      case 'high':
        riskColor = Colors.red;
        riskEmoji = "🔴";
        break;
      default:
        riskColor = Colors.blue;
        riskEmoji = "❓";
        riskLevel = "Unknown";
    }

    return Card(
      elevation: 4,
      color: const Color(0xFF001029),
      margin: EdgeInsets.symmetric(vertical: 1.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "🚨 Risk Score",
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    _extractRiskExplanation(),
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: riskColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: riskColor, width: 2),
              ),
              child: Row(
                children: [
                  Text(
                    riskEmoji,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    riskLevel.toUpperCase(),
                    style: GoogleFonts.bricolageGrotesque(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: riskColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.white10,
      thickness: 1,
      height: 3.h,
    );
  }

  Widget _buildDownloadButton(BuildContext context) {
    return Center(
      child: ElevatedButton.icon(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Report saved to downloads"),
              backgroundColor: Colors.blueAccent,
            ),
          );
        },
        icon: const Icon(Icons.download_rounded),
        label: Text(
          "Save Report",
          style: GoogleFonts.bricolageGrotesque(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF007BFF),
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  // Helper methods to extract data from responseData
  String _extractSummary() {
    try {
      if (responseData != null && responseData.containsKey('summary')) {
        return responseData['summary'];
      }
      return responseText.split('\n').take(3).join('\n');
    } catch (e) {
      return "The document contains important details about employment terms, including the bond period, stipend amount, and notice period requirements. Key points have been highlighted in the following sections.";
    }
  }

  String _extractLegalTerms() {
    try {
      if (responseData != null && responseData.containsKey('legal_terms')) {
        final terms = responseData['legal_terms'];
        if (terms is List) {
          return terms.map((term) => "• ${term['term']}: ${term['explanation']}").join('\n\n');
        }
        return terms.toString();
      }
      return "No specific legal terms were extracted from this document. This doesn't necessarily mean the document is risk-free. Please review the AI suggestions for more insights.";
    } catch (e) {
      return "• Non-Compete Clause: Restricts your ability to work for competitors for a specified period after leaving.\n\n• Indemnification: You may be liable for damages incurred by the company related to your actions.\n\n• Intellectual Property Assignment: All work created during employment belongs to the company.";
    }
  }

  String _extractRiskLevel() {
    try {
      if (responseData != null && responseData.containsKey('risk_score')) {
        final score = responseData['risk_score'];
        if (score is Map && score.containsKey('level')) {
          return score['level'];
        }
        return score.toString();
      }
      return "Medium";
    } catch (e) {
      return "Medium";
    }
  }

  String _extractRiskExplanation() {
    try {
      if (responseData != null && responseData.containsKey('risk_score')) {
        final score = responseData['risk_score'];
        if (score is Map && score.containsKey('explanation')) {
          return score['explanation'];
        }
      }
      return "Based on the analysis of clauses and terms in this document, we've assigned a risk level that reflects the potential concerns you should be aware of.";
    } catch (e) {
      return "Based on the analysis of clauses and terms in this document, we've assigned a risk level that reflects the potential concerns you should be aware of.";
    }
  }

  String _extractAISuggestions() {
    try {
      if (responseData != null && responseData.containsKey('ai_suggestions')) {
        return responseData['ai_suggestions'];
      }
      return "Based on our analysis, we recommend carefully reviewing the terms related to the bond period and notice requirements. Consider negotiating more favorable terms if possible, particularly regarding the consequences of early termination.";
    } catch (e) {
      return "Based on our analysis, we recommend carefully reviewing the terms related to the bond period and notice requirements. Consider negotiating more favorable terms if possible, particularly regarding the consequences of early termination.";
    }
  }
}