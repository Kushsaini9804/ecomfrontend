import 'package:flutter/material.dart';
import '../../core/services/api_service.dart';

class SavedAddressScreen extends StatefulWidget {
  final bool isSelecting;
  const SavedAddressScreen({super.key, this.isSelecting = false});

  @override
  State<SavedAddressScreen> createState() => _SavedAddressScreenState();
}

class _SavedAddressScreenState extends State<SavedAddressScreen> {
  List<Map<String, dynamic>> addresses = [];

  final _formKey = GlobalKey<FormState>();

  // Controllers for all fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _addressLineController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();

  Map<String, dynamic>? editingAddress;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _addressLineController.dispose();
    _landmarkController.dispose();
    super.dispose();
  }

  Future<void> _fetchAddresses() async {
    try {
      final res = await ApiService.get('/address');
      setState(() {
        addresses = List<Map<String, dynamic>>.from(res['data'] ?? []);
      });
    } catch (e) {
      debugPrint("Fetch addresses error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load addresses')),
      );
    }
  }

  void _showAddressForm({Map<String, dynamic>? address}) {
    if (address != null) {
      _fullNameController.text = address['fullName'] ?? '';
      _phoneController.text = address['phone'] ?? '';
      _pincodeController.text = address['pincode'] ?? '';
      _cityController.text = address['city'] ?? '';
      _stateController.text = address['state'] ?? '';
      _addressLineController.text = address['addressLine'] ?? '';
      _landmarkController.text = address['landmark'] ?? '';
      editingAddress = address;
    } else {
      _fullNameController.clear();
      _phoneController.clear();
      _pincodeController.clear();
      _cityController.clear();
      _stateController.clear();
      _addressLineController.clear();
      _landmarkController.clear();
      editingAddress = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildField(_fullNameController, 'Full Name *'),
                _buildField(_phoneController, 'Phone *', keyboardType: TextInputType.phone),
                _buildField(_pincodeController, 'Pincode *', keyboardType: TextInputType.number),
                _buildField(_cityController, 'City *'),
                _buildField(_stateController, 'State *'),
                _buildField(_addressLineController, 'Flat, House no., Building *'),
                _buildField(_landmarkController, 'Landmark (Optional)'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Color.fromARGB(255, 219, 216, 216),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(editingAddress == null ? 'Add Address' : 'Update Address'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label,
      {TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        validator: (v) => label.contains('*') && (v == null || v.isEmpty) ? 'Required' : null,
      ),
    );
  }

  Future<void> _saveAddress() async {
  if (!_formKey.currentState!.validate()) return;

  final newAddress = {
    'fullName': _fullNameController.text.trim(),
    'phone': _phoneController.text.trim(),
    'pincode': _pincodeController.text.trim(),
    'city': _cityController.text.trim(),
    'state': _stateController.text.trim(),
    'addressLine': _addressLineController.text.trim(),
    'landmark': _landmarkController.text.trim(),
  };

  try {
    if (editingAddress == null) {
      await ApiService.post('/address', newAddress);
    } else {
      await ApiService.put(
        '/address/${editingAddress!['_id']}',
        body: newAddress,
      );
    }

    Navigator.of(context).pop();
    _fetchAddresses();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Address saved successfully!')),
    );
  } catch (e) {
    debugPrint('Save address error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Failed to save address')),
    );
  }
}
  

  Future<void> _deleteAddress(String addressId) async {
    try {
      await ApiService.delete('/address/$addressId');
      _fetchAddresses();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address deleted')),
      );
    } catch (e) {
      debugPrint('Delete address error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete address')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Saved Addresses"),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: addresses.isEmpty
          ? const Center(child: Text('No saved addresses yet'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final addr = addresses[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      "${addr['fullName'] ?? ''} (${addr['phone'] ?? ''})\n"
                      "${addr['addressLine'] ?? ''}, ${addr['city'] ?? ''}, ${addr['state'] ?? ''} - ${addr['pincode'] ?? ''}\n"
                      "${addr['landmark'] ?? ''}",
                      style: const TextStyle(height: 1.3),
                    ),
                    onTap: widget.isSelecting
                        ? () => Navigator.pop(context, addr)
                        : null,
                    trailing: SizedBox(
                      width: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.indigo),
                            onPressed: () => _showAddressForm(address: addr),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteAddress(addr['_id']),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Color.fromARGB(255, 219, 216, 216),
        onPressed: () => _showAddressForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
