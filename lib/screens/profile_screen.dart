import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:file_picker/file_picker.dart';

import '../database/database_helper.dart';
import '../widgets/profile_card.dart';
import '../widgets/dialogs/about_me_dialog.dart';
import '../widgets/dialogs/work_exp_dialog.dart';
import '../widgets/dialogs/education_dialog.dart';
import '../widgets/dialogs/skills_dialog.dart';
import '../widgets/dialogs/languages_dialog.dart';
import '../widgets/dialogs/appreciation_dialog.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  String _name = 'Bùi Minh Trọng';
  String _email = '6451071081@st.utc2.edu.vn';

  String aboutMeText =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lectus id commodo egestas metus interdum dolor.';

  List<Map<String, String>> workExperiences = [
    {
      'role': 'Manager',
      'company': 'Amazon Inc',
      'period': 'Jan 2015 - Feb 2022 · 5 Years',
    }
  ];

  List<Map<String, String>> educations = [
    {
      'degree': 'Information Technology',
      'school': 'University of Oxford',
      'period': 'Sep 2010 - Aug 2013 · 5 Years',
    }
  ];

  List<String> skills = [
    'Leadership',
    'Teamwork',
    'Visioner',
    'Target oriented',
    'Consistent',
    'Good communication',
    'English',
    'Problem Solving',
    'Creativity',
    'Adaptability',
  ];
  bool showAllSkills = false;

  List<String> languages = [
    'English',
    'German',
    'Spanish',
    'Mandarin',
    'Italy',
    'Vietnamese',
    'Japanese',
  ];
  bool showAllLanguages = false;

  List<Map<String, String>> appreciations = [
    {
      'title': 'Wireless Symposium (RWS)',
      'awarder': 'Young Scientist',
      'year': '2014',
    }
  ];

  List<Map<String, String>> resumes = [
    {
      'fileName': 'Jamet kudasi - CV - UI/UX Designer',
      'fileSize': '867 Kb',
      'uploadTime': '14 Feb 2022 at 11:30 am',
    }
  ];

  bool get hasAboutMe => aboutMeText.isNotEmpty;
  bool get hasWorkExperience => workExperiences.isNotEmpty;
  bool get hasEducation => educations.isNotEmpty;
  bool get hasSkills => skills.isNotEmpty;
  bool get hasLanguage => languages.isNotEmpty;
  bool get hasAppreciation => appreciations.isNotEmpty;
  bool get hasResume => resumes.isNotEmpty;

  // Format thời gian upload file theo dạng: "14 Feb 2022 at 11:30 am"
  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    String day = dt.day.toString();
    String month = months[dt.month - 1];
    String year = dt.year.toString();
    
    int hour = dt.hour;
    String ampm = 'am';
    if (hour >= 12) {
      ampm = 'pm';
      if (hour > 12) hour -= 12;
    }
    if (hour == 0) hour = 12;
    
    String minute = dt.minute.toString().padLeft(2, '0');
    
    return '$day $month $year at $hour:$minute $ampm';
  }

  // Chọn file resume bằng thư viện file_picker
  Future<void> _pickResumeFile() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.name.isNotEmpty) {
        final file = result.files.single;
        final name = file.name;
        final bytes = file.size;
        
        // Quy đổi kích thước file
        String sizeStr = '';
        if (bytes < 1024) {
          sizeStr = '$bytes B';
        } else if (bytes < 1024 * 1024) {
          sizeStr = '${(bytes / 1024).toStringAsFixed(1)} Kb';
        } else {
          sizeStr = '${(bytes / (1024 * 1024)).toStringAsFixed(1)} Mb';
        }
        
        final timeStr = _formatDateTime(DateTime.now());
        
        setState(() {
          resumes.add({
            'fileName': name,
            'fileSize': sizeStr,
            'uploadTime': timeStr,
          });
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Uploaded resume: $name'),
              backgroundColor: const Color(0xFFFF9228),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick file: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<void> _showAboutMeDialog() async {
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AboutMeDialog(initialText: aboutMeText),
    );
    if (result != null) {
      setState(() {
        aboutMeText = result;
      });
    }
  }

  Future<void> _showWorkExperienceDialog({int? index}) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => WorkExpDialog(
        initialData: index != null ? workExperiences[index] : null,
      ),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          workExperiences[index] = result;
        } else {
          workExperiences.add(result);
        }
      });
    }
  }

  Future<void> _showEducationDialog({int? index}) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => EducationDialog(
        initialData: index != null ? educations[index] : null,
      ),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          educations[index] = result;
        } else {
          educations.add(result);
        }
      });
    }
  }

  Future<void> _showSkillDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => SkillsDialog(initialSkills: skills),
    );
    if (result != null) {
      setState(() {
        skills = result;
      });
    }
  }

  Future<void> _showLanguageDialog() async {
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => LanguagesDialog(initialLanguages: languages),
    );
    if (result != null) {
      setState(() {
        languages = result;
      });
    }
  }

  Future<void> _showAppreciationDialog({int? index}) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) => AppreciationDialog(
        initialData: index != null ? appreciations[index] : null,
      ),
    );
    if (result != null) {
      setState(() {
        if (index != null) {
          appreciations[index] = result;
        } else {
          appreciations.add(result);
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    try {
      final dbHelper = DatabaseHelper.instance;
      final profile = await dbHelper.getProfile();
      final dbWorkExperiences = await dbHelper.getWorkExperiences();
      final dbEducations = await dbHelper.getEducations();
      final dbSkills = await dbHelper.getSkills();
      final dbLanguages = await dbHelper.getLanguages();
      final dbAppreciations = await dbHelper.getAppreciations();
      final dbResumes = await dbHelper.getResumes();

      setState(() {
        _name = profile['name'] ?? 'Bùi Minh Trọng';
        _email = profile['email'] ?? '6451071081@st.utc2.edu.vn';
        aboutMeText = profile['about_me'] ?? '';
        workExperiences = dbWorkExperiences;
        educations = dbEducations;
        skills = dbSkills;
        languages = dbLanguages;
        appreciations = dbAppreciations;
        resumes = dbResumes;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E5E5),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF130160),
                ),
              )
            : Column(
                children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.maybePop(context),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF130160),
                      size: 24,
                    ),
                  ),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      color: Color(0xFF130160),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 24),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFDCB02),
                                width: 4,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withAlpha((0.05 * 255).round()),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/logo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) => const Center(
                                  child: Icon(Icons.broken_image, color: Colors.grey),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _name,
                            style: const TextStyle(
                              color: Color(0xFF130160),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _email,
                            style: TextStyle(
                              color: const Color(0xFF130160).withAlpha((0.6 * 255).round()),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    ProfileCard(
                      title: 'About me',
                      svgIconPath: 'assets/icons/about.svg',
                      headerAction: GestureDetector(
                        onTap: _showAboutMeDialog,
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFFFF9228),
                          size: 20,
                        ),
                      ),
                      contentWidget: hasAboutMe
                          ? Text(
                              aboutMeText,
                              style: TextStyle(
                                color: const Color(0xFF130160).withAlpha((0.7 * 255).round()),
                                fontSize: 14,
                                height: 1.4,
                              ),
                            )
                          : Text(
                              'Tap the edit icon to write about yourself.',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),

                    ProfileCard(
                      title: 'Work experience',
                      svgIconPath: 'assets/icons/work.svg',
                      headerAction: GestureDetector(
                        onTap: () => _showWorkExperienceDialog(),
                        child: SvgPicture.asset(
                          'assets/icons/add.svg',
                          width: 24,
                          height: 24,
                          placeholderBuilder: (context) => const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFFFF9228),
                            size: 24,
                          ),
                        ),
                      ),
                      contentWidget: hasWorkExperience
                          ? Column(
                              children: List.generate(workExperiences.length, (index) {
                                final exp = workExperiences[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index == workExperiences.length - 1 ? 0 : 12,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              exp['role'] ?? '',
                                              style: const TextStyle(
                                                color: Color(0xFF130160),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              exp['company'] ?? '',
                                              style: const TextStyle(
                                                color: Color(0xFF130160),
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              exp['period'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xFF130160).withAlpha((0.5 * 255).round()),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _showWorkExperienceDialog(index: index),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          color: Color(0xFFFF9228),
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            )
                          : Text(
                              'Tap + to add work experience.',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),

                    ProfileCard(
                      title: 'Education',
                      svgIconPath: 'assets/icons/edu.svg',
                      headerAction: GestureDetector(
                        onTap: () => _showEducationDialog(),
                        child: SvgPicture.asset(
                          'assets/icons/add.svg',
                          width: 24,
                          height: 24,
                          placeholderBuilder: (context) => const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFFFF9228),
                            size: 24,
                          ),
                        ),
                      ),
                      contentWidget: hasEducation
                          ? Column(
                              children: List.generate(educations.length, (index) {
                                final edu = educations[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index == educations.length - 1 ? 0 : 12,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              edu['degree'] ?? '',
                                              style: const TextStyle(
                                                color: Color(0xFF130160),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              edu['school'] ?? '',
                                              style: const TextStyle(
                                                color: Color(0xFF130160),
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              edu['period'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xFF130160).withAlpha((0.5 * 255).round()),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _showEducationDialog(index: index),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          color: Color(0xFFFF9228),
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            )
                          : Text(
                              'Tap + to add education.',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),

                    ProfileCard(
                      title: 'Skill',
                      svgIconPath: 'assets/icons/skill.svg',
                      headerAction: GestureDetector(
                        onTap: _showSkillDialog,
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFFFF9228),
                          size: 20,
                        ),
                      ),
                      contentWidget: hasSkills
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      ...(showAllSkills ? skills : skills.take(5)).map((skill) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F3F3),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            skill,
                                            style: const TextStyle(
                                              color: Color(0xFF130160),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }),
                                      if (!showAllSkills && skills.length > 5)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F3F3),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '+${skills.length - 5} more',
                                            style: const TextStyle(
                                              color: Color(0xFF130160),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (skills.length > 5) ...[
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showAllSkills = !showAllSkills;
                                      });
                                    },
                                    child: Text(
                                      showAllSkills ? 'See less' : 'See more',
                                      style: const TextStyle(
                                        color: Color(0xFF130160),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : Text(
                              'Tap the edit icon to add skills.',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),

                    ProfileCard(
                      title: 'Language',
                      svgIconPath: 'assets/icons/language.svg',
                      headerAction: GestureDetector(
                        onTap: _showLanguageDialog,
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFFFF9228),
                          size: 20,
                        ),
                      ),
                      contentWidget: hasLanguage
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      ...(showAllLanguages ? languages : languages.take(5)).map((lang) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F3F3),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            lang,
                                            style: const TextStyle(
                                              color: Color(0xFF130160),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      }),
                                      if (!showAllLanguages && languages.length > 5)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3F3F3),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            '+${languages.length - 5} more',
                                            style: const TextStyle(
                                              color: Color(0xFF130160),
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (languages.length > 5) ...[
                                  const SizedBox(height: 12),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showAllLanguages = !showAllLanguages;
                                      });
                                    },
                                    child: Text(
                                      showAllLanguages ? 'See less' : 'See more',
                                      style: const TextStyle(
                                        color: Color(0xFF130160),
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            )
                          : Text(
                              'Tap the edit icon to add languages.',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),

                    ProfileCard(
                      title: 'Appreciation',
                      svgIconPath: 'assets/icons/appre.svg',
                      headerAction: GestureDetector(
                        onTap: () => _showAppreciationDialog(),
                        child: SvgPicture.asset(
                          'assets/icons/add.svg',
                          width: 24,
                          height: 24,
                          placeholderBuilder: (context) => const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFFFF9228),
                            size: 24,
                          ),
                        ),
                      ),
                      contentWidget: hasAppreciation
                          ? Column(
                              children: List.generate(appreciations.length, (index) {
                                final app = appreciations[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index == appreciations.length - 1 ? 0 : 12,
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              app['title'] ?? '',
                                              style: const TextStyle(
                                                color: Color(0xFF130160),
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              app['awarder'] ?? '',
                                              style: const TextStyle(
                                                color: Color(0xFF130160),
                                                fontSize: 13,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              app['year'] ?? '',
                                              style: TextStyle(
                                                color: const Color(0xFF130160).withAlpha((0.5 * 255).round()),
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => _showAppreciationDialog(index: index),
                                        child: const Icon(
                                          Icons.edit_outlined,
                                          color: Color(0xFFFF9228),
                                          size: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            )
                          : Text(
                              'Tap + to add awards/appreciations.',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),

                    ProfileCard(
                      title: 'Resume',
                      svgIconPath: 'assets/icons/resume.svg',
                      headerAction: GestureDetector(
                        onTap: _pickResumeFile,
                        child: SvgPicture.asset(
                          'assets/icons/add.svg',
                          width: 24,
                          height: 24,
                          placeholderBuilder: (context) => const Icon(
                            Icons.add_circle_outline,
                            color: Color(0xFFFF9228),
                            size: 24,
                          ),
                        ),
                      ),
                      contentWidget: hasResume
                          ? Column(
                              children: List.generate(resumes.length, (index) {
                                final res = resumes[index];
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: index == resumes.length - 1 ? 0 : 12,
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFECEB),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Center(
                                          child: Icon(
                                            Icons.picture_as_pdf_rounded,
                                            color: Colors.red,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              res['fileName'] ?? '',
                                              style: const TextStyle(
                                                color: Color(0xFF130160),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '${res['fileSize']} - ${res['uploadTime']}',
                                              style: TextStyle(
                                                color: const Color(0xFF130160).withAlpha((0.5 * 255).round()),
                                                fontSize: 11,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            resumes.removeAt(index);
                                          });
                                        },
                                        child: const Icon(
                                          Icons.delete_outline_rounded,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            )
                          : Text(
                              'Tap + to upload a resume PDF.',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF130160),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () async {
                    final messenger = ScaffoldMessenger.of(context);
                    setState(() {
                      _isLoading = true;
                    });
                    try {
                      await DatabaseHelper.instance.saveAllProfileData(
                        name: _name,
                        email: _email,
                        aboutMe: aboutMeText,
                        workExperiences: workExperiences,
                        educations: educations,
                        skills: skills,
                        languages: languages,
                        appreciations: appreciations,
                        resumes: resumes,
                      );
                      if (mounted) {
                        messenger.showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: Color(0xFFFF9228),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Failed to update profile: $e'),
                            backgroundColor: Colors.red,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                        });
                      }
                    }
                  },
                  child: const Text(
                    'UPDATE',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
