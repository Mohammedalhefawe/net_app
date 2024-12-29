import 'package:flutter/material.dart';

class CustomDropdownFormField extends FormField<ObjectDropdownFormField> {
  CustomDropdownFormField({
    super.key,
    required List<ObjectDropdownFormField> items,
    required void Function(ObjectDropdownFormField?) onChanged,
    String hintText = 'Select',
    String? valueText,
    Color fillColor = const Color(0xFFF8F6F1),
    void Function()? onTap,
    Icon? icon,
    super.validator,
  }) : super(
          builder: (FormFieldState<ObjectDropdownFormField> state) {
            return InkWell(
              onTap: onTap,
              child: Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                decoration: BoxDecoration(
                  color: fillColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: state.hasError ? Colors.red : Colors.transparent,
                  ),
                ),
                child: PopupMenuButton<ObjectDropdownFormField>(
                  onSelected: (value) {
                    state.didChange(value);
                    onChanged(value);
                  },
                  itemBuilder: (BuildContext context) {
                    return items.map((ObjectDropdownFormField value) {
                      return PopupMenuItem<ObjectDropdownFormField>(
                        value: value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(value.title),
                            if (value.subTitle != null)
                              Text(
                                "price : ${value.subTitle!} \$",
                                style: const TextStyle(
                                  color: Colors.black26,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  child: InkWell(
                    onTap: onTap,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          valueText ?? state.value?.title ?? hintText,
                          style: TextStyle(
                            color: valueText == null && state.value == null
                                ? Colors.black26
                                : Colors.black87,
                            fontSize: 15,
                          ),
                        ),
                        icon ??
                            const Icon(
                              Icons.expand_more,
                              color: Colors.black54,
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
}

class FilePickerField extends StatelessWidget {
  final String hintText;
  final void Function()? onTap;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const FilePickerField({
    super.key,
    required this.hintText,
    this.onTap,
    this.validator,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.black26,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        suffixIcon: const Icon(Icons.attach_file, color: Colors.black54),
        filled: true,
        fillColor: const Color(0xFFF8F6F1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class ObjectDropdownFormField {
  final String title;
  final String? subTitle;
  final String id;
  ObjectDropdownFormField({
    required this.title,
    this.subTitle,
    required this.id,
  });
}
