import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(const SafetyCoreApp());
}

class SafetyCoreApp extends StatelessWidget {
  const SafetyCoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safety Core AI',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar', 'SA'),
      supportedLocales: const [Locale('ar', 'SA'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF0F172A),
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        fontFamily: 'sans-serif',
      ),
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    HseDashboardScreen(),
    ObservationClosureScreen(),
    AboutAppScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF0284C7),
        unselectedItemColor: const Color(0xFF64748B),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'لوحة التحكم',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.verified_rounded),
            label: 'إغلاق الملاحظات',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info_outline_rounded),
            label: 'حول التطبيق',
          ),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// 1. شاشة لوحة المؤشرات الهندسية (HSE Dashboard)
// -------------------------------------------------------------
class HseDashboardScreen extends StatelessWidget {
  const HseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة مؤشرات السلامة | HSE Dashboard'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // شريط ساعات العمل الآمنة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.security, color: Color(0xFF38BDF8), size: 36),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'ساعات العمل الآمنة (Safe Man-Hours)',
                      style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '1,250,000 ساعة خالية من الحوادث',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // بطاقات مؤشرات الأداء القياسية
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  title: 'معدل الوقت الضائع (LTIFR)',
                  value: '0.00',
                  subtitle: 'معيار OSHA / ANSI Z16.1',
                  color: const Color(0xFF16A34A),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMetricCard(
                  title: 'معدل الحوادث الكلي (TRIR)',
                  value: '0.42',
                  subtitle: 'ضمن النطاق العالمي المقبول',
                  color: const Color(0xFF0284C7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // سجل الملاحظات المفتوحة
          const Text(
            'أحدث الملاحظات الميدانية المفتوحة',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 10),
          _buildObservationItem(
            code: 'HSE-CRIT-2026-01',
            hazard: 'سقالة عمل غير مكتملة دون حماية سقوط',
            location: 'القطاع السكني - مبنى B',
            riskLevel: 'عالي الخطورة (Critical)',
            riskColor: const Color(0xFFDC2626),
          ),
          _buildObservationItem(
            code: 'HSE-MED-2026-04',
            hazard: 'عدم ارتداء نظارات حماية أثناء أعمال التجليخ',
            location: 'ورشة النجارة والحدادة',
            riskLevel: 'متوسط الخطورة (Medium)',
            riskColor: const Color(0xFFD97706),
          ),
          _buildObservationItem(
            code: 'HSE-LOW-2026-09',
            hazard: 'تراكم مخلفات أخشاب في مسار الخروج',
            location: 'المدخل الجنوبي',
            riskLevel: 'منخفض الخطورة (Low)',
            riskColor: const Color(0xFF16A34A),
          ),
        ],
      ),
    );
  }

  static Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
        ],
      ),
    );
  }

  static Widget _buildObservationItem({
    required String code,
    required String hazard,
    required String location,
    required String riskLevel,
    required Color riskColor,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(code, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: riskColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    riskLevel,
                    style: TextStyle(color: riskColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(hazard, style: const TextStyle(fontSize: 13, color: Color(0xFF334155), fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: Color(0xFF94A3B8)),
                const SizedBox(width: 4),
                Text(location, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// -------------------------------------------------------------
// 2. شاشة إغلاق الملاحظة والتوقيع الرقمي الحي (Observation Closure)
// -------------------------------------------------------------
class ObservationClosureScreen extends StatefulWidget {
  const ObservationClosureScreen({super.key});

  @override
  State<ObservationClosureScreen> createState() => _ObservationClosureScreenState();
}

class _ObservationClosureScreenState extends State<ObservationClosureScreen> {
  final TextEditingController _actionController = TextEditingController(
    text: 'تم استكمال تركيب كافة الدرابزينات القياسية وتثبيت ألواح الحواف وتفعيل كرت السقالة الأخضر.',
  );
  final List<Offset?> _signaturePoints = [];

  void _clearSignature() {
    setState(() {
      _signaturePoints.clear();
    });
  }

  void _submitVerification() {
    if (_signaturePoints.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى توقيع مهندس السلامة المعتمد في اللوحة المخصصة قبل الاعتماد.'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تم اعتماد إغلاق الملاحظة وتوثيق التوقيع الرقمي بنجاح!'),
        backgroundColor: Color(0xFF16A34A),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إغلاق الملاحظة واعتماد الاستشاري'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // بطاقة كود الملاحظة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('كود السجل: HSE-CRIT-2026-01', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                SizedBox(height: 4),
                Text(
                  'المخالفة: عدم توفير وسائل حماية السقوط على منصة السقالة',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // مقارنة الصور قبل وبعد
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Text('صورة الرصد (قبل)', style: TextStyle(fontSize: 11, color: Color(0xFF475569))),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF16A34A)),
                  ),
                  child: const Center(
                    child: Text(
                      'صورة المعالجة (بعد)\n✓ تم التحقق',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Color(0xFF16A34A), fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // تفاصيل الإجراء التصحيحي
          const Text(
            'الإجراء التصحيحي المنفذ ميدانياً:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: _actionController,
            maxLines: 2,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // لوحة التوقيع الرقمي الحي
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'لوحة توقيع الاستشاري المعتمد:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              TextButton.icon(
                onPressed: _clearSignature,
                icon: const Icon(Icons.refresh, size: 16, color: Color(0xFFDC2626)),
                label: const Text('مسح', style: TextStyle(fontSize: 12, color: Color(0xFFDC2626))),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: GestureDetector(
              onPanUpdate: (details) {
                final RenderBox renderBox = context.findRenderObject() as RenderBox;
                final localPosition = details.localPosition;
                setState(() {
                  _signaturePoints.add(localPosition);
                });
              },
              onPanEnd: (_) => _signaturePoints.add(null),
              child: CustomPaint(
                painter: SignaturePainter(points: _signaturePoints),
                size: Size.infinite,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // زر الاعتماد النهائي
          ElevatedButton.icon(
            onPressed: _submitVerification,
            icon: const Icon(Icons.check_circle_outline),
            label: const Text('اعتماد إغلاق الملاحظة رسمياً', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF16A34A),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

class SignaturePainter extends CustomPainter {
  final List<Offset?> points;
  SignaturePainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF0F172A)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant SignaturePainter oldDelegate) => true;
}

// -------------------------------------------------------------
// 3. شاشة معلومات التطبيق والمصمم ودعم PayPal
// -------------------------------------------------------------
class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  Future<void> _openPayPal(BuildContext context) async {
    final Uri uri = Uri.parse('https://paypal.me/yagoupyo');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حول التطبيق | Safety Core AI'),
        backgroundColor: const Color(0xFF0F172A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Icon(Icons.health_and_safety_rounded, size: 68, color: Color(0xFF0284C7)),
            const SizedBox(height: 8),
            const Text(
              'Safety Core AI',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
            ),
            const SizedBox(height: 4),
            const Text('الإصدار الميداني 1.0.0', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
            const SizedBox(height: 20),

            // بطاقة المصمم
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('المصمم والمشرف الهندسي للنظام:', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11)),
                  SizedBox(height: 4),
                  Text(
                    'HSE Engineer: Yagoub Mohamed',
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Divider(color: Color(0xFF334155), height: 20),
                  Text(
                    'تطبيق متخصص لإدارة ومتابعة معايير السلامة والصحة المهنية وفق اشتراطات OSHA و ISO 45001.',
                    style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 11, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // زر الدعم عبر PayPal
            ElevatedButton.icon(
              onPressed: () => _openPayPal(context),
              icon: const Icon(Icons.favorite, color: Colors.redAccent),
              label: const Text('Support via PayPal (@yagoupyo)', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0070BA),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
