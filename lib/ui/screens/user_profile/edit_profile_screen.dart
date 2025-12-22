import 'dart:io';
import 'package:Celes/data/models/user.dart';
import 'package:Celes/data/repositories/auth_repository.dart';
import 'package:Celes/ui/components/custom_button.dart';
import 'package:Celes/ui/components/custom_text_field.dart';
import 'package:Celes/ui/theme/theme.dart';
import 'package:Celes/utils/api_exception.dart';
import 'package:Celes/utils/custom_text.dart';
import 'package:Celes/utils/extensions/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = false;
  bool _isLoadingProfile = true;
  String? _selectedGender;
  String? _avatarUrl;
  int? _avatarId;
  File? _selectedImage;
  User? _currentUser;

  final List<String> _genders = ['male', 'female', 'other'];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoadingProfile = true);

    try {
      final response = await _authRepository.getProfile();
      if (response.success && response.data != null) {
        setState(() {
          _currentUser = response.data!;
          _nameController.text = response.data!.name;
          _emailController.text = response.data!.email;
          _phoneController.text = response.data!.phone;
          _dateOfBirthController.text = response.data!.dateOfBirth ?? '';
          _addressController.text = response.data!.address;
          _selectedGender = response.data!.gender;
          _avatarId = response.data!.avatarId;
          _avatarUrl = response.data!.avatarUrl;
        });
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingProfile = false);
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to pick image'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _showImagePickerDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.color.secondaryColor,
        title: CustomText(
          'Select Image Source',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: context.color.textColorDark,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: CustomText(
                'Gallery',
                color: context.color.textColorDark,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: CustomText(
                'Camera',
                color: context.color.textColorDark,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateOfBirthController.text.isNotEmpty
          ? DateFormat('yyyy-MM-dd').parse(_dateOfBirthController.text)
          : DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: context.color.territoryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleUpdateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      int? avatarId = _avatarId;

      // Upload image nếu có ảnh mới được chọn
      if (_selectedImage != null) {
        final uploadResponse = await _authRepository.uploadImage(
          _selectedImage!.path,
        );

        if (uploadResponse.success && uploadResponse.data != null) {
          avatarId = uploadResponse.data!['id'] as int?;
        } else {
          throw ApiException(
            code: 'UPLOAD_FAILED',
            message: 'Failed to upload image',
          );
        }
      }

      // Update profile
      final response = await _authRepository.updateProfile(
        name: _nameController.text.trim(),
        avatarId: avatarId,
        phone: _phoneController.text.trim(),
        dateOfBirth: _dateOfBirthController.text.trim().isNotEmpty
            ? _dateOfBirthController.text.trim()
            : null,
        gender: _selectedGender,
        address: _addressController.text.trim(),
      );

      if (response.success) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.green,
            ),
          );

          Navigator.of(context).pop(true); // Return true to indicate success
        }
      }
    } on ApiException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An error occurred. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.color.primaryColor,
      appBar: AppBar(
        backgroundColor: context.color.primaryColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: context.color.textColorDark,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          'Edit Profile',
          color: context.color.textColorDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
      ),
      body: _isLoadingProfile
          ? Center(
              child: CircularProgressIndicator(
                color: context.color.territoryColor,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      // Avatar Section
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: context.color.territoryColor,
                                  width: 3,
                                ),
                              ),
                              child: ClipOval(
                                child: _selectedImage != null
                                    ? Image.file(
                                        _selectedImage!,
                                        fit: BoxFit.cover,
                                      )
                                    : _avatarUrl != null
                                        ? CachedNetworkImage(
                                            imageUrl: _avatarUrl!,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(
                                              color:
                                                  context.color.territoryColor,
                                            ),
                                            errorWidget:
                                                (context, url, error) => Icon(
                                              Icons.person,
                                              size: 60,
                                              color:
                                                  context.color.textColorDark,
                                            ),
                                          )
                                        : Icon(
                                            Icons.person,
                                            size: 60,
                                            color: context.color.textColorDark,
                                          ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: _showImagePickerDialog,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: context.color.territoryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Name Field
                      CustomTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hintText: 'Enter your full name',
                        keyboardType: TextInputType.name,
                        colorType: TextFieldColorType.dark,
                        height: 62,
                        textColor: context.color.textColorDark,
                        borderColor:
                            context.color.textColorDark.withValues(alpha: 0.3),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Email Field (Read-only)
                      IgnorePointer(
                        child: CustomTextField(
                          controller: _emailController,
                          label: 'Email',
                          hintText: 'Enter your email',
                          keyboardType: TextInputType.emailAddress,
                          colorType: TextFieldColorType.dark,
                          height: 62,
                          textColor: context.color.textColorDark
                              .withValues(alpha: 0.6),
                          borderColor: context.color.textColorDark
                              .withValues(alpha: 0.3),
                          validator: null,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Phone Field
                      CustomTextField(
                        controller: _phoneController,
                        label: 'Phone Number',
                        hintText: 'Enter your phone number',
                        keyboardType: TextInputType.phone,
                        colorType: TextFieldColorType.dark,
                        height: 62,
                        textColor: context.color.textColorDark,
                        borderColor:
                            context.color.textColorDark.withValues(alpha: 0.3),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      // Date of Birth Field
                      GestureDetector(
                        onTap: _selectDate,
                        child: AbsorbPointer(
                          child: CustomTextField(
                            controller: _dateOfBirthController,
                            label: 'Date of Birth',
                            hintText: 'Select your date of birth',
                            keyboardType: TextInputType.datetime,
                            colorType: TextFieldColorType.dark,
                            height: 62,
                            textColor: context.color.textColorDark,
                            borderColor: context.color.textColorDark
                                .withValues(alpha: 0.3),
                            validator: null,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Gender Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          color: context.color.secondaryColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: context.color.textColorDark
                                .withValues(alpha: 0.3),
                            width: 1.2,
                          ),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: _selectedGender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            labelStyle: TextStyle(
                              fontSize: 10,
                              color: context.color.textColorDark
                                  .withValues(alpha: 0.6),
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.only(top: 20),
                          ),
                          items: _genders.map((String gender) {
                            return DropdownMenuItem<String>(
                              value: gender,
                              child: Text(
                                gender[0].toUpperCase() + gender.substring(1),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: context.color.textColorDark,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              _selectedGender = value;
                            });
                          },
                          dropdownColor: context.color.secondaryColor,
                          style: TextStyle(
                            color: context.color.textColorDark,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Address Field
                      CustomTextField(
                        controller: _addressController,
                        label: 'Address',
                        hintText: 'Enter your address',
                        keyboardType: TextInputType.streetAddress,
                        colorType: TextFieldColorType.dark,
                        height: 62,
                        textColor: context.color.textColorDark,
                        borderColor:
                            context.color.textColorDark.withValues(alpha: 0.3),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 32),

                      // Update Button
                      CustomButton(
                        label: _isLoading ? 'Updating...' : 'Update Profile',
                        onPressed: _isLoading ? () {} : _handleUpdateProfile,
                        colorType: ButtonColorType.territory,
                        height: 56,
                        borderRadius: 10,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        textColor: Colors.white,
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
