import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Model/product/product_model.dart';
import '../../../ViewModel/Bloc/seller_products_screen_bloc/seller_products_screen_bloc.dart';
import '../../../config/enums/enums.dart';

class AddProductSheet extends StatefulWidget {
  const AddProductSheet({
    super.key,
  });

  @override
  State<AddProductSheet> createState() => _AddProductSheetState();
}

class _AddProductSheetState extends State<AddProductSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _salePriceController = TextEditingController();
  final _costPriceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _quantityController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  // Local state that will be managed by the widget
  List<File> _selectedImageFiles = [];
  List<String> _selectedImageUrls = [];

  @override
  void dispose() {
    _nameController.dispose();
    _salePriceController.dispose();
    _costPriceController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  // State update methods using setState (local UI state)
  void _updateImages({
    List<File>? files,
    List<String>? urls,
  }) {
    setState(() {
      if (files != null) _selectedImageFiles = files;
      if (urls != null) _selectedImageUrls = urls;
    });
  }

  void _addImageFiles(List<File> newFiles) {
    final updatedFiles = List<File>.from(_selectedImageFiles)..addAll(newFiles);
    _updateImages(files: updatedFiles);
  }

  void _addImageFile(File file) {
    final updatedFiles = List<File>.from(_selectedImageFiles)..add(file);
    _updateImages(files: updatedFiles);
  }

  void _addImageUrl(String url) {
    final updatedUrls = List<String>.from(_selectedImageUrls)..add(url);
    _updateImages(urls: updatedUrls);
  }

  void _removeImageFile(int index) {
    final updatedFiles = List<File>.from(_selectedImageFiles)..removeAt(index);
    _updateImages(files: updatedFiles);
  }

  void _removeImageUrl(int index) {
    final updatedUrls = List<String>.from(_selectedImageUrls)..removeAt(index);
    _updateImages(urls: updatedUrls);
  }

  void _clearAllImages() {
    _updateImages(files: [], urls: []);
  }

  // Updated: Take multiple photos (one at a time, but can take multiple)
  Future<void> _takeMultiplePhotos() async {
    try {
      // Show a dialog to choose between single photo or multiple photos
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    'Take Photos',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.camera, color: Colors.green),
                  title: const Text('Take Single Photo'),
                  subtitle: const Text('Capture one photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _takeSinglePhoto();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt, color: Colors.blue),
                  title: const Text('Take Multiple Photos'),
                  subtitle: const Text('Take photos one by one'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _takeMultiplePhotosSequentially();
                  },
                ),
                const SizedBox(height: 12),
              ],
            ),
          );
        },
      );
    } catch (e) {
      _showSnackBar('Error: $e', Colors.red);
    }
  }

  // Take a single photo
  Future<void> _takeSinglePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        _addImageFile(File(photo.path));
        _showSnackBar('Photo added successfully!', Colors.green);
      }
    } catch (e) {
      _showSnackBar('Error taking photo: $e', Colors.red);
    }
  }

  // Take multiple photos sequentially
  Future<void> _takeMultiplePhotosSequentially() async {
    bool continueAdding = true;

    while (continueAdding && _selectedImageFiles.length + _selectedImageUrls.length < 10) {
      try {
        final XFile? photo = await _picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 1024,
          maxHeight: 1024,
          imageQuality: 85,
        );

        if (photo != null) {
          _addImageFile(File(photo.path));
          _showSnackBar('Photo added! (${_selectedImageFiles.length}/${10 - _selectedImageUrls.length} images)', Colors.green);

          // Ask if user wants to add another photo
          final shouldContinue = await _showAddMoreDialog();
          if (!shouldContinue) {
            continueAdding = false;
          }
        } else {
          continueAdding = false;
        }
      } catch (e) {
        _showSnackBar('Error taking photo: $e', Colors.red);
        continueAdding = false;
      }
    }

    if (_selectedImageFiles.length + _selectedImageUrls.length >= 10) {
      _showSnackBar('Maximum 10 images reached!', Colors.orange);
    }
  }

  // Show dialog to ask if user wants to add more photos
  Future<bool> _showAddMoreDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Another Photo?'),
          content: const Text('Do you want to take another photo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  Future<void> _pickMultipleImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        final remainingSlots = 10 - (_selectedImageFiles.length + _selectedImageUrls.length);
        final filesToAdd = pickedFiles.take(remainingSlots).toList();

        if (filesToAdd.length < pickedFiles.length) {
          _showSnackBar('Only ${filesToAdd.length} images added (max 10)', Colors.orange);
        }

        final newFiles = filesToAdd.map((file) => File(file.path)).toList();
        _addImageFiles(newFiles);
      }
    } catch (e) {
      _showSnackBar('Error picking images: $e', Colors.red);
    }
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Add Images',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.green),
                title: const Text('Take Photos'),
                subtitle: const Text('Capture single or multiple photos'),
                onTap: () {
                  Navigator.pop(context);
                  _takeMultiplePhotos();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.blue),
                title: const Text('Choose from Gallery'),
                subtitle: const Text('Select multiple images from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickMultipleImages();
                },
              ),
              ListTile(
                leading: const Icon(Icons.link, color: Colors.purple),
                title: const Text('Add Image URL'),
                subtitle: const Text('Add image from web URL'),
                onTap: () {
                  Navigator.pop(context);
                  _showImageUrlDialog();
                },
              ),
              if (_selectedImageFiles.isNotEmpty || _selectedImageUrls.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.delete_sweep, color: Colors.red),
                  title: const Text('Remove All Images'),
                  onTap: () {
                    _clearAllImages();
                    Navigator.pop(context);
                  },
                ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _showImageUrlDialog() {
    final urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Image URL'),
          content: TextField(
            controller: urlController,
            decoration: const InputDecoration(
              hintText: 'https://example.com/image.jpg',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (urlController.text.isNotEmpty) {
                  _addImageUrl(urlController.text);
                }
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedImageFiles.isEmpty && _selectedImageUrls.isEmpty) {
        _showSnackBar('Please add at least one product image', Colors.orange);
        return;
      }

      // Parse values
      final double salePrice = double.parse(_salePriceController.text);
      final double costPrice = _costPriceController.text.isNotEmpty
          ? double.parse(_costPriceController.text)
          : salePrice * 0.7;
      final int quantity = _quantityController.text.isNotEmpty
          ? int.parse(_quantityController.text)
          : 20;

      final product = ProductModel(
        productId: DateTime.now().millisecondsSinceEpoch.toString(),
        sellerId: 'current_seller_id', // Will be replaced by actual seller ID from auth
        name: _nameController.text,
        description: _descriptionController.text,
        category: _categoryController.text,
        salePrice: salePrice,
        costPrice: costPrice,
        quantity: quantity,
        imageUrls: _selectedImageUrls,
      );

      // Dispatch AddProduct event to BLoC
      context.read<ProductsBloc>().add(
        AddProduct(
          product: product,
          imageFiles: _selectedImageFiles,
          imageUrls: _selectedImageUrls,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalImages = _selectedImageFiles.length + _selectedImageUrls.length;

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Add New Product',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Multiple Images Picker Section
                    _buildImagePickerSection(totalImages),
                    const SizedBox(height: 24),

                    // Product Name
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name *',
                        hintText: 'Enter product name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.shopping_bag_outlined),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter product name';
                        }
                        if (value.length < 3) {
                          return 'Product name must be at least 3 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    SizedBox(
                      width: double.infinity,
                      child: DropdownMenuFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                        dropdownMenuEntries: const [
                          DropdownMenuEntry(value: ProductCategory.electronics, label: "Electronics"),
                          DropdownMenuEntry(value: ProductCategory.food, label: "Food"),
                          DropdownMenuEntry(value: ProductCategory.dairy, label: "Dairy"),
                          DropdownMenuEntry(value: ProductCategory.KitchenAccessories, label: "Kitchen Accessories"),
                          DropdownMenuEntry(value: ProductCategory.utensils, label: "Utensils"),
                          DropdownMenuEntry(value: ProductCategory.HomeAccessories, label: "Home Accessories"),
                        ],
                        controller: _categoryController,
                        label: const Text("Category *"),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Sale Price
                    TextFormField(
                      controller: _salePriceController,
                      decoration: const InputDecoration(
                        labelText: 'Sale Price *',
                        hintText: 'Enter selling price',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                        prefixText: '\$ ',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter sale price';
                        }
                        final price = double.tryParse(value);
                        if (price == null) {
                          return 'Please enter a valid number';
                        }
                        if (price <= 0) {
                          return 'Price must be greater than 0';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Cost Price (Optional)
                    TextFormField(
                      controller: _costPriceController,
                      decoration: const InputDecoration(
                        labelText: 'Cost Price (Optional)',
                        hintText: 'Enter cost price',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.attach_money),
                        prefixText: '\$ ',
                        helperText: 'Leave empty to auto-calculate at 30% margin',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Quantity
                    TextFormField(
                      controller: _quantityController,
                      decoration: const InputDecoration(
                        labelText: 'Quantity *',
                        hintText: 'Enter stock quantity',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.inventory_2_outlined),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter quantity';
                        }
                        final qty = int.tryParse(value);
                        if (qty == null) {
                          return 'Please enter a valid number';
                        }
                        if (qty < 0) {
                          return 'Quantity cannot be negative';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description *',
                        hintText: 'Enter product description',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      maxLines: 4,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter description';
                        }
                        if (value.length < 10) {
                          return 'Description must be at least 10 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Submit Button
                    BlocConsumer<ProductsBloc, ProductsState>(
                      listener: (context, state) {
                        if (state.status == ProductScreenStatus.added) {
                          _showSnackBar('Product added successfully!', Colors.green);
                        } else if (state.status == ProductScreenStatus.error && state.errorMessage != null) {
                          _showSnackBar(state.errorMessage!, Colors.red);
                        }
                      },
                      builder: (context, state) {
                        final isUploading = state.status == ProductScreenStatus.adding;

                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isUploading ? null : _submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isUploading
                                ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                                : const Text(
                              'Add Product',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePickerSection(int totalImages) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Product Images',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _showImagePickerDialog,
              icon: const Icon(Icons.add_photo_alternate),
              label: const Text('Add Images'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (totalImages == 0)
          Container(
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: InkWell(
              onTap: _showImagePickerDialog,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap to add images',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'You can add up to 10 images',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: totalImages,
              itemBuilder: (context, index) {
                final isFileImage = index < _selectedImageFiles.length;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Stack(
                    children: [
                      Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: isFileImage
                              ? Image.file(
                            _selectedImageFiles[index],
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          )
                              : Image.network(
                            _selectedImageUrls[index - _selectedImageFiles.length],
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.broken_image),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: CircleAvatar(
                          backgroundColor: Colors.black54,
                          radius: 16,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 16, color: Colors.white),
                            onPressed: () {
                              if (isFileImage) {
                                _removeImageFile(index);
                              } else {
                                _removeImageUrl(index - _selectedImageFiles.length);
                              }
                            },
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 8),
        Text(
          '$totalImages/10 images added',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}