import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../services/api_service.dart';
import '../widgets/result_card.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  String? _result;
  String? _error;
  PlatformFile? _selectedFile;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result != null) {
        setState(() {
          _selectedFile = result.files.first;
          _error = null;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to pick file: $e';
      });
      _animController.forward(from: 0);
    }
  }

  void _clearFile() {
    setState(() {
      _selectedFile = null;
    });
  }

  Future<void> _analyzeReport() async {
    if (_selectedFile == null) {
      setState(() {
        _error = 'Please upload a medical report first.';
        _result = null;
      });
      _animController.forward(from: 0);
      return;
    }

    setState(() {
      _isLoading = true;
      _error = null;
      _result = null;
    });

    try {
      final result = await _apiService.analyzeReport(
        file: _selectedFile,
      );
      setState(() {
        _result = result;
        _isLoading = false;
      });
      _animController.forward(from: 0);
    } catch (e) {
      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
      _animController.forward(from: 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF1DB954).withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.biotech_rounded,
                color: Color(0xFF1DB954),
                size: 22,
              ),
            ),
            const SizedBox(width: 10),
            const Text('Report Analyzer'),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header subtitle ─────────────────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1DB954).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xFF1DB954).withOpacity(0.15),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: const Color(0xFF1DB954).withOpacity(0.7),
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Text(
                        'Upload your medical report or lab results below and get an AI-powered plain-English explanation.',
                        style: TextStyle(
                          color: Color(0xFF8FA3B0),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── File Selection Area ─────────────────────
              if (_selectedFile != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2D4059).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF1DB954).withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.insert_drive_file_rounded, color: Color(0xFF1DB954), size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedFile!.name,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Color(0xFF8FA3B0), size: 20),
                        onPressed: _clearFile,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),
              if (_selectedFile != null) const SizedBox(height: 16),

              // ── Buttons ──────────────────────────
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: _buildUploadButton(),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: _buildAnalyzeButton(),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Loading Indicator ───────────────────────
              if (_isLoading) _buildLoadingIndicator(),

              // ── Result / Error ──────────────────────────
              if (_result != null)
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ResultCard(text: _result!),
                  ),
                ),

              if (_error != null)
                SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: _buildErrorCard(),
                  ),
                ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnalyzeButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: _isLoading
            ? null
            : const LinearGradient(
                colors: [Color(0xFF1DB954), Color(0xFF1AA34A)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
        color: _isLoading ? const Color(0xFF2D4059) : null,
        boxShadow: _isLoading
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF1DB954).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _analyzeReport,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isLoading ? Icons.hourglass_top_rounded : Icons.auto_awesome_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  _isLoading ? 'Analyzing...' : 'Analyze Report',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFF1DB954).withOpacity(0.8),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Analyzing your report...',
            style: TextStyle(
              color: Color(0xFF8FA3B0),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'This may take a few seconds',
            style: TextStyle(
              color: Color(0xFF5A6B7A),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1520),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFCF6679).withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline_rounded,
                color: const Color(0xFFCF6679).withOpacity(0.8),
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Something went wrong',
                style: TextStyle(
                  color: Color(0xFFCF6679),
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            _error!,
            style: const TextStyle(
              color: Color(0xFFB0A0A5),
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 40,
            child: OutlinedButton.icon(
              onPressed: _analyzeReport,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFCF6679),
                side: const BorderSide(color: Color(0xFFCF6679), width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xFF2D4059),
        border: Border.all(
          color: const Color(0xFF8FA3B0).withOpacity(0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : _pickFile,
          borderRadius: BorderRadius.circular(16),
          child: const Center(
            child: Icon(
              Icons.upload_file_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
