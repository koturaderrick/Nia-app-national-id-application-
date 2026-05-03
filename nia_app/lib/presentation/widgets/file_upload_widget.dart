import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/theme/app_theme.dart';

enum UploadType { image, document }

class FileUploadWidget extends StatelessWidget {
  final String label;
  final String? filePath;
  final UploadType uploadType;
  final void Function(String path) onFilePicked;
  final VoidCallback? onClear;

  const FileUploadWidget({
    super.key,
    required this.label,
    required this.filePath,
    required this.uploadType,
    required this.onFilePicked,
    this.onClear,
  });

  Future<void> _pickImage(BuildContext context) async {
    final picker = ImagePicker();
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppTheme.primaryColor),
              title: const Text('Take Photo'),
              onTap: () async {
                Navigator.pop(context);
                final file =
                    await picker.pickImage(source: ImageSource.camera);
                if (file != null) onFilePicked(file.path);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.photo_library, color: AppTheme.primaryColor),
              title: const Text('Choose from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                final file =
                    await picker.pickImage(source: ImageSource.gallery);
                if (file != null) onFilePicked(file.path);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDocument(BuildContext context) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.single.path != null) {
      onFilePicked(result.files.single.path!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFile = filePath != null && filePath!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => uploadType == UploadType.image
              ? _pickImage(context)
              : _pickDocument(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: hasFile
                    ? AppTheme.successColor
                    : AppTheme.dividerColor,
                width: hasFile ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: hasFile
                ? Row(
                    children: [
                      _buildPreview(),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _fileName(filePath!),
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close,
                            color: AppTheme.errorColor, size: 20),
                        onPressed: onClear,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Icon(
                        uploadType == UploadType.image
                            ? Icons.add_a_photo_outlined
                            : Icons.upload_file_outlined,
                        size: 36,
                        color: AppTheme.primaryColor,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        uploadType == UploadType.image
                            ? 'Tap to upload photo'
                            : 'Tap to upload PDF or image',
                        style: TextStyle(
                          color: AppTheme.primaryColor.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview() {
    if (uploadType == UploadType.image && filePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.file(
          File(filePath!),
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.image,
            color: AppTheme.primaryColor,
          ),
        ),
      );
    }
    return const Icon(Icons.insert_drive_file,
        color: AppTheme.primaryColor, size: 32);
  }

  String _fileName(String path) {
    return path.split('/').last.split('\\').last;
  }
}
