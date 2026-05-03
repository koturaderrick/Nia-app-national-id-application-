import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/validators.dart';
import '../../../domain/entities/application.dart';
import '../../blocs/application/application_bloc.dart';
import '../../blocs/application/application_event.dart';
import '../../blocs/application/application_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/loading_overlay.dart';
import '../../widgets/file_upload_widget.dart';

class ApplicationFormScreen extends StatefulWidget {
  const ApplicationFormScreen({super.key});

  @override
  State<ApplicationFormScreen> createState() => _ApplicationFormScreenState();
}

class _ApplicationFormScreenState extends State<ApplicationFormScreen> {
  final _formKey = GlobalKey<FormState>();

  // Field controllers
  final _fullNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _districtController = TextEditingController();
  final _subCountyController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nextOfKinNameController = TextEditingController();
  final _nextOfKinPhoneController = TextEditingController();
  final _nextOfKinRelationController = TextEditingController();

  String? _selectedGender;
  String? _selectedDistrict;
  String? _photoPath;
  String? _lcLetterPath;


  @override
  void dispose() {
    _fullNameController.dispose();
    _dobController.dispose();
    _districtController.dispose();
    _subCountyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _nextOfKinNameController.dispose();
    _nextOfKinPhoneController.dispose();
    _nextOfKinRelationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(1995),
      firstDate: DateTime(1920),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: AppTheme.primaryColor),
        ),
        child: child!,
      ),
    );
    if (date != null) {
      setState(() {

        _dobController.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_photoPath == null) {
        _showError('Please upload your passport photo.');
        return;
      }
      if (_lcLetterPath == null) {
        _showError('Please upload your LC letter.');
        return;
      }
      final application = Application(
        fullName: _fullNameController.text.trim(),
        dateOfBirth: _dobController.text,
        gender: _selectedGender!,
        district: _selectedDistrict!,
        subCounty: _subCountyController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        nextOfKinName: _nextOfKinNameController.text.trim(),
        nextOfKinPhone: _nextOfKinPhoneController.text.trim(),
        nextOfKinRelationship: _nextOfKinRelationController.text.trim(),
        photoPath: _photoPath,
        lcLetterPath: _lcLetterPath,
      );
      context
          .read<ApplicationBloc>()
          .add(ApplicationSubmitRequested(application));
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ApplicationBloc, ApplicationState>(
      listener: (context, state) {
        if (state is ApplicationSubmitSuccess) {
          Navigator.pushReplacementNamed(
            context,
            '/success',
            arguments: state.trackingNumber,
          );
        } else if (state is ApplicationError) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        final isLoading = state is ApplicationLoading;
        return LoadingOverlay(
          isLoading: isLoading,
          message: 'Submitting your application...',
          child: Scaffold(
            appBar: AppBar(
              title: const Text('New Application'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    context.read<AuthBloc>().add(const AuthLogoutRequested());
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                ),
              ],
            ),
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTrackingBanner(),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'Personal Information',
                      icon: Icons.person_outline,
                      children: [
                        CustomTextField(
                          controller: _fullNameController,
                          label: 'Full Name',
                          hint: 'As on birth certificate',
                          prefixIcon: Icons.person_outline,
                          validator: Validators.validateFullName,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _dobController,
                          label: 'Date of Birth',
                          hint: 'DD/MM/YYYY',
                          prefixIcon: Icons.calendar_today_outlined,
                          readOnly: true,
                          onTap: _pickDate,
                          validator: Validators.validateDateOfBirth,
                        ),
                        const SizedBox(height: 14),
                        _buildGenderDropdown(),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'Location Details',
                      icon: Icons.location_on_outlined,
                      children: [
                        _buildDistrictDropdown(),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _subCountyController,
                          label: 'Sub-County / Parish',
                          hint: 'e.g., Nakawa',
                          prefixIcon: Icons.map_outlined,
                          validator: (v) =>
                              Validators.validateRequired(v, 'Sub-county'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'Contact Information',
                      icon: Icons.contact_phone_outlined,
                      children: [
                        CustomTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          hint: '+256 700 000 000',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: Validators.validatePhone,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          hint: 'your@email.com',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'Next of Kin',
                      icon: Icons.people_outline,
                      children: [
                        CustomTextField(
                          controller: _nextOfKinNameController,
                          label: 'Next of Kin Name',
                          hint: 'Full name',
                          prefixIcon: Icons.person_outline,
                          validator: Validators.validateFullName,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _nextOfKinPhoneController,
                          label: 'Next of Kin Phone',
                          hint: '+256 700 000 000',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: Validators.validatePhone,
                        ),
                        const SizedBox(height: 14),
                        CustomTextField(
                          controller: _nextOfKinRelationController,
                          label: 'Relationship',
                          hint: 'e.g., Father, Spouse, Sibling',
                          prefixIcon: Icons.family_restroom,
                          validator: (v) =>
                              Validators.validateRequired(v, 'Relationship'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      title: 'Documents',
                      icon: Icons.upload_file_outlined,
                      children: [
                        FileUploadWidget(
                          label: 'Passport Photo *',
                          filePath: _photoPath,
                          uploadType: UploadType.image,
                          onFilePicked: (path) =>
                              setState(() => _photoPath = path),
                          onClear: () => setState(() => _photoPath = null),
                        ),
                        const SizedBox(height: 14),
                        FileUploadWidget(
                          label: 'LC Letter (Image or PDF) *',
                          filePath: _lcLetterPath,
                          uploadType: UploadType.document,
                          onFilePicked: (path) =>
                              setState(() => _lcLetterPath = path),
                          onClear: () => setState(() => _lcLetterPath = null),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Submit Application',
                      onPressed: isLoading ? null : _submit,
                      isLoading: isLoading,
                      icon: Icons.send_outlined,
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: 'Track Existing Application',
                      onPressed: () =>
                          Navigator.pushNamed(context, '/tracking'),
                      isOutlined: true,
                      icon: Icons.search,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrackingBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withAlpha((0.08 * 255).toInt()),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.primaryColor.withAlpha((0.2 * 255).toInt())),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Fill all fields marked with * accurately. Incorrect info may cause rejection.',
              style: TextStyle(
                color: AppTheme.primaryColor.withAlpha((0.85 * 255).toInt()),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withAlpha((0.1 * 255).toInt()),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(icon, color: AppTheme.primaryColor, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const Divider(),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedGender,
      decoration: const InputDecoration(
        labelText: 'Gender',
        prefixIcon: Icon(Icons.wc, color: AppTheme.primaryColor, size: 20),
      ),
      items: AppConstants.genderOptions
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: (value) => setState(() => _selectedGender = value),
      validator: (v) => v == null ? 'Please select your gender' : null,
    );
  }

  Widget _buildDistrictDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedDistrict,
      decoration: const InputDecoration(
        labelText: 'District',
        prefixIcon:
            Icon(Icons.location_city, color: AppTheme.primaryColor, size: 20),
      ),
      items: AppConstants.districts
          .map((d) => DropdownMenuItem(value: d, child: Text(d)))
          .toList(),
      onChanged: (value) => setState(() => _selectedDistrict = value),
      validator: (v) => v == null ? 'Please select your district' : null,
      isExpanded: true,
    );
  }
}
