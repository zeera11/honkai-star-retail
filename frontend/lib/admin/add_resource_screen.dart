import 'dart:ui';
import 'dart:html' as html;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';


import '../core/app_colors.dart';
import '../core/app_theme.dart';
import '../core/app_fonts.dart';


import '../providers/settings_provider.dart';


import '../widgets/galaxy_ui_helper.dart';


import '../api/api.dart';


class AddResourceScreen extends StatefulWidget {
  const AddResourceScreen({super.key});


  @override
  State<AddResourceScreen> createState() => _AddResourceScreenState();
}


class _AddResourceScreenState extends State<AddResourceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  late TextEditingController _stockController;
  int _stock = 0;
  String _category = 'RESOURCE';
  String? _eventTag;
  String? _selectedImagePath;


  @override
  void initState() {
    super.initState();
    _stockController = TextEditingController(
      text: _stock.toString(),
    );
  }


  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final isDark = settings.isDarkMode;
    const accent = AppTheme.hsrCyan;


    return GalaxyScreenWrapper(
      useScroll: true,
      showBackButton: false,
      title: "ITEM CREATION",
      child: Stack(
        children: [
          // Atmosphere orbs
          Positioned(
            top: -180,
            right: -120,
            child: IgnorePointer(
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(isDark ? 0.12 : 0.06),
                      blurRadius: 180,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -220,
            left: -140,
            child: IgnorePointer(
              child: Container(
                width: 360,
                height: 360,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color:
                          AppTheme.hsrPurple.withOpacity(isDark ? 0.08 : 0.04),
                      blurRadius: 180,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTopBar(isDark, accent, settings),
                  const SizedBox(height: 22),
                  _buildHeroPanel(isDark, accent, settings),
                  const SizedBox(height: 22),
                  _buildMainPanel(isDark, accent, settings),
                ],
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 26,
            child: GestureDetector(
              onTap: _submit,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [AppTheme.hsrCyan, AppTheme.hsrPurple]
                        : [AppColors.lBlue, AppColors.lPurple],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accent.withOpacity(0.3),
                      blurRadius: 32,
                      spreadRadius: -6,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.sparkles,
                        color: Colors.white, size: 18),
                    const SizedBox(width: 12),
                    Text(
                      "SYNC TO IPC TERMINAL",
                      style: AppFonts.orbitron(
                        preset: settings.fontStyle,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 10.8,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTopBar(bool isDark, Color accent, SettingsProvider settings) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.04)
                : Colors.white.withOpacity(0.72),
            borderRadius: BorderRadius.circular(26),
            border: Border.all(color: accent.withOpacity(0.14)),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.hsrDanger.withOpacity(0.1),
                    border:
                        Border.all(color: AppTheme.hsrDanger.withOpacity(0.2)),
                  ),
                  child: const Icon(LucideIcons.x,
                      color: AppTheme.hsrDanger, size: 18),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 18,
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: accent,
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      accent.withOpacity(isDark ? 0.45 : 0.28),
                                  blurRadius: 10),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "NEW_INTERASTRAL_ITEM",
                            style: AppFonts.orbitron(
                              preset: settings.fontStyle,
                              color: accent.withOpacity(isDark ? 0.72 : 0.82),
                              fontSize: 8.5,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "CREATE AND SYNCHRONIZE NEW TERMINAL ENTRY",
                      style: GoogleFonts.exo2(
                        color: accent.withOpacity(0.7),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: accent.withOpacity(0.08),
                  border: Border.all(color: accent.withOpacity(0.16)),
                ),
                child: Icon(LucideIcons.database, color: accent, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildHeroPanel(bool isDark, Color accent, SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: accent.withOpacity(0.14)),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF10192F),
                  const Color(0xFF121F42),
                  const Color(0xFF0B1224)
                ]
              : [
                  Colors.white.withOpacity(0.95),
                  const Color(0xFFEFF5FF),
                  const Color(0xFFE6EEFF)
                ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ITEM INITIALIZATION",
                  style: AppFonts.orbitron(
                    preset: settings.fontStyle,
                    color: accent,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  "Register new resources and synchronize them directly into the IPC inventory network.",
                  style: GoogleFonts.exo2(
                    color: isDark
                        ? Colors.white.withOpacity(0.78)
                        : AppColors.lTextSub,
                    fontSize: 13,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 18),
          GestureDetector(
            onTap: _showImagePicker,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(colors: [
                  accent.withOpacity(0.18),
                  AppTheme.hsrPurple.withOpacity(0.08)
                ]),
                border: Border.all(color: accent.withOpacity(0.16)),
              ),
              child: _selectedImagePath != null
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: _selectedImagePath!.startsWith('assets/')
                          ? Image.asset(_selectedImagePath!, fit: BoxFit.contain)
                          : Image.network(
                              _selectedImagePath!.startsWith('http')
                                  ? _selectedImagePath!
                                  : '${Api.baseUrl}/$_selectedImagePath',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(LucideIcons.image, size: 28),
                            ),
                    )
                  : Icon(LucideIcons.imagePlus, color: accent, size: 28),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildMainPanel(bool isDark, Color accent, SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isDark
            ? Colors.white.withOpacity(0.04)
            : Colors.white.withOpacity(0.8),
        border: Border.all(color: accent.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("ITEM NAME", accent, settings),
          _buildField(
              controller: _nameController,
              hint: "Enter item name",
              isDark: isDark),
          _buildLabel("DESCRIPTION", accent, settings),
          _buildField(
              controller: _descController,
              hint: "Enter item description",
              isDark: isDark,
              maxLines: 3),
          _buildLabel("CLASSIFICATION", accent, settings),
          _buildCategorySelector(isDark, accent, settings),
          _buildLabel("EVENT CLASSIFICATION", accent, settings),
          _buildEventSelector(isDark, accent, settings),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("PRICE", accent, settings),
                    _buildField(
                        controller: _priceController,
                        hint: "0",
                        isDark: isDark,
                        isNumber: true),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("STOCK", accent, settings),
                    _buildStockCounter(isDark, accent, settings),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Widget _buildLabel(String text, Color accent, SettingsProvider settings) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 16),
      child: Text(
        text,
        style: AppFonts.orbitron(
          preset: settings.fontStyle,
          color: accent,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.8,
        ),
      ),
    );
  }


  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required bool isDark,
    int maxLines = 1,
    bool isNumber = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      style: GoogleFonts.exo2(
          color: isDark ? Colors.white : AppTheme.stellarText,
          fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.exo2(
            color: isDark ? Colors.white38 : AppColors.lTextSub),
        filled: true,
        fillColor: isDark
            ? Colors.black.withOpacity(0.16)
            : Colors.white.withOpacity(0.7),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none),
      ),
      validator: (v) => v == null || v.isEmpty ? "Required" : null,
    );
  }


  Widget _buildCategorySelector(
      bool isDark, Color accent, SettingsProvider settings) {
    final categories = ['RESOURCE', 'LIGHT CONE'];
    return Row(
      children: categories.map((cat) {
        final selected = _category == cat;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _category = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: selected
                    ? LinearGradient(colors: [
                        accent.withOpacity(0.16),
                        AppTheme.hsrPurple.withOpacity(0.08)
                      ])
                    : null,
                color: selected
                    ? null
                    : (isDark
                        ? Colors.white.withOpacity(0.03)
                        : Colors.white.withOpacity(0.65)),
                border: Border.all(
                    color: selected
                        ? accent.withOpacity(0.45)
                        : accent.withOpacity(0.1)),
              ),
              alignment: Alignment.center,
              child: Text(
                cat,
                style: AppFonts.orbitron(
                  preset: settings.fontStyle,
                  color: selected
                      ? accent
                      : (isDark ? Colors.white60 : AppColors.lTextSub),
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }


  Widget _buildEventSelector(
      bool isDark, Color accent, SettingsProvider settings) {
    final events = [
      {'label': 'REGULAR', 'value': null},
      {'label': 'AVENTURINE', 'value': 'aventurine'},
      {'label': 'FIREFLY', 'value': 'firefly'},
      {'label': 'JINGLIU', 'value': 'jingliu'},
      {'label': 'KAFKA', 'value': 'kafka'},
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: events.map((event) {
        final selected = _eventTag == event['value'];
        return GestureDetector(
          onTap: () => setState(() => _eventTag = event['value']),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: selected
                  ? LinearGradient(colors: [
                      accent.withOpacity(0.18),
                      AppTheme.hsrPurple.withOpacity(0.08)
                    ])
                  : null,
              color: selected
                  ? null
                  : (isDark
                      ? Colors.white.withOpacity(0.03)
                      : Colors.white.withOpacity(0.7)),
              border: Border.all(
                  color: selected
                      ? accent.withOpacity(0.45)
                      : accent.withOpacity(0.1)),
            ),
            child: Text(
              event['label'].toString(),
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: selected
                    ? accent
                    : (isDark ? Colors.white60 : AppColors.lTextSub),
                fontSize: 8,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }


  Widget _buildStockCounter(
      bool isDark, Color accent, SettingsProvider settings) {
    return Container(
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: isDark
            ? Colors.black.withOpacity(0.16)
            : Colors.white.withOpacity(0.7),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _stock = _stock > 0 ? _stock - 1 : 0;
                _stockController.text = _stock.toString();
              });
            },
            icon: Icon(LucideIcons.minus, color: accent, size: 16),
          ),
          Expanded(
            child: TextFormField(
              controller: _stockController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                color: isDark ? Colors.white : AppTheme.stellarText,
                fontWeight: FontWeight.w900,
                fontSize: 14,
              ),
              decoration: const InputDecoration(border: InputBorder.none),
              onChanged: (value) {
                _stock = int.tryParse(value) ?? 0;
              },
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _stock++;
                _stockController.text = _stock.toString();
              });
            },
            icon: Icon(LucideIcons.plus, color: accent, size: 16),
          ),
        ],
      ),
    );
  }


  Future<void> _pickAndUploadImage() async {
    final html.FileUploadInputElement input = html.FileUploadInputElement();
    input.accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final files = input.files;
      if (files != null && files.isNotEmpty) {
        final file = files[0];
        final reader = html.FileReader();
        reader.readAsArrayBuffer(file);
        reader.onLoadEnd.listen((e) async {
          final bytes = reader.result as List<int>;
          
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Uploading image..."),
              duration: Duration(seconds: 2),
            ),
          );

          try {
            final request = http.MultipartRequest('POST', Uri.parse('${Api.baseUrl}/items/upload'));
            
            if (Api.token != null) {
              request.headers['Authorization'] = 'Bearer ${Api.token}';
            }
            
            final multipartFile = http.MultipartFile.fromBytes(
              'image',
              bytes,
              filename: file.name,
              contentType: MediaType('image', file.type.split('/')[1]),
            );
            request.files.add(multipartFile);

            final response = await request.send();
            if (response.statusCode == 200) {
              final responseData = await response.stream.bytesToString();
              final decoded = jsonDecode(responseData);
              final String serverPath = decoded['image'] ?? '';
              
              setState(() {
                _selectedImagePath = serverPath;
              });
              
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Image uploaded successfully!")),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Upload failed. Status code: ${response.statusCode}")),
              );
            }
          } catch (uploadError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Error uploading image: $uploadError")),
            );
          }
        });
      }
    });
  }

  void _showImagePicker() {
    final settings = context.read<SettingsProvider>();
    final images = [
      'assets/images/new_item_1_trailblaze_exp.png',
      'assets/images/new_item_2_the_returning_trail.png',
      'assets/images/new_item_3_travelers_guide.png',
      'assets/images/new_item_4_first_voyage_blessigns.png',
      'assets/images/new_item_5_golden_companion_spirit.png',
      'assets/images/new_item_6_silver_companion_spirit.png',
      'assets/images/new_item_7_superimposer.png',
      'assets/images/new_item_8_lone_Stardust.png',
      'assets/images/new_item_9_journey_forever_peaceful.png',
      'assets/images/new_item_10_epoch_etched.png',
      'assets/images/new_item_11_see_you.png',
      'assets/images/new_item_12_woof_walktime.png',
    ];
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(28))),
      builder: (_) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Colors.white.withOpacity(0.96),
            const Color(0xFFF1F5FF)
          ]),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "SELECT ITEM VISUAL",
              style: AppFonts.orbitron(
                preset: settings.fontStyle,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 16),
            // Custom Upload Button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                _pickAndUploadImage();
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: const LinearGradient(
                    colors: [AppTheme.hsrCyan, AppTheme.hsrPurple],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.hsrCyan.withOpacity(0.24),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(LucideIcons.uploadCloud, color: Colors.white, size: 18),
                    const SizedBox(width: 12),
                    Text(
                      "UPLOAD REAL IMAGE (MULTER)",
                      style: AppFonts.orbitron(
                        preset: settings.fontStyle,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 9.6,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: Divider(color: AppTheme.hsrCyan.withOpacity(0.2))),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    "OR CHOOSE FROM TEMPLATES",
                    style: GoogleFonts.exo2(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.stellarText.withOpacity(0.5),
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: AppTheme.hsrCyan.withOpacity(0.2))),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (_, i) => GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedImagePath = images[i];
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 76,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      border:
                          Border.all(color: AppTheme.hsrCyan.withOpacity(0.2)),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(images[i], fit: BoxFit.contain)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Api.createItem({
          "name": _nameController.text,
          "type": _category,
          "description": _descController.text,
          "stock": _stock,
          "image": _selectedImagePath ?? "",
          "price": double.parse(_priceController.text),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Resource added successfully")),
      );
      Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add resource: $e")),
        );
      }
    }
  }
}