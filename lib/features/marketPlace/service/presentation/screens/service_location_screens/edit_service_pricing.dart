import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:yelpax_pro/config/routes/router.dart';
import 'package:yelpax_pro/features/authentication/presentation/controllers/auth_user_controller.dart';
import 'package:yelpax_pro/features/marketPlace/service/data/models/professional_services_model.dart';
import 'package:yelpax_pro/features/marketPlace/service/presentation/controllers/service_controller.dart';
import 'package:yelpax_pro/shared/widgets/custom_input.dart';

class EditServicePricing extends StatefulWidget {
  const EditServicePricing({super.key, this.service});
  final ProfessionalServicesModel? service;
  @override
  State<EditServicePricing> createState() => _EditServicePricingState();
}

class _EditServicePricingState extends State<EditServicePricing> {
  final _formKey = GlobalKey<FormState>();


@override
  void initState() {
    super.initState();
    // Defer loading to after the first frame so that any notifyListeners
    // called by the controller doesn't happen during the widget build.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) loadServiceData();
    });
  }

  Future<void> loadServiceData() async {
    final serviceController = Provider.of<ServiceController>(
      context,
      listen: false,
    );

    // If no service was provided (adding new pricing), do nothing.
    if (widget.service == null) return;

    Logger().d(
      "Loading service data for editing ${widget.service!.proServiceEntity.maximumPrice}",
    );

    // Use controller helper to populate fields and notify listeners
    serviceController.loadPricingFromProfessionalService(widget.service!);
  }
  @override
  Widget build(BuildContext context) {
    final serviceController = Provider.of<ServiceController>(context);
    final authController = Provider.of<AuthUserController>(
      context,
      listen: false,
    );



    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Service Pricing"),
        centerTitle: true,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Pricing Range Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pricing Range',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomInputField(
                        hintText: 'Maximum Price',
                        controller: serviceController.maxPriceController,
                        inputType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter maximum price'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      CustomInputField(
                        hintText: 'Minimum Price',
                        controller: serviceController.minPriceController,
                        inputType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter minimum price'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Description Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.description,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomInputField(
                        hintText: 'Description',
                        controller: serviceController.descriptionController,
                        inputType: TextInputType.multiline,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter description'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Pricing Type Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.category,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Pricing Type',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: serviceController.selectedPricingType,
                        hint: const Text('Select Pricing Type'),
                        items: serviceController.pricingTypes
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            serviceController.setSelectedPricingType(value),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          prefixIcon: Icon(
                            Icons.arrow_drop_down,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        validator: (value) =>
                            value == null ? "Select a pricing type" : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Experience Section
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.task,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Experience',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      CustomInputField(
                        hintText: 'Completed Tasks',
                        controller: serviceController.completedTasksController,
                        inputType: TextInputType.number,
                        validator: (value) => value == null || value.isEmpty
                            ? 'Enter completed tasks'
                            : null,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              /// Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final res = await serviceController.savePricing(
                        authController.professionalId.value,
                        serviceController.selectedService!.id,
                      );

                      if (res == true) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                "Service pricing updated successfully",
                              ),
                            ),
                          );
                          // Log service questions and any embedded answers before navigating
                          try {
                            Logger().d(
                              'Navigating to edit questions for service: ${widget.service?.professionalServiceId}',
                            );
                            for (final q
                                in widget.service?.questionEntities ?? []) {
                              try {
                                final dynamic dq = q as dynamic;
                                Logger().d(
                                  ' question ${q.id} answer property (dynamic): ${dq.answer}',
                                );
                              } catch (e) {
                                Logger().d(
                                  ' question ${q.id} no dynamic answer property: $e',
                                );
                              }
                            }
                          } catch (e) {
                            Logger().d(
                              'Error logging service question answers before navigation: $e',
                            );
                          }

                          Navigator.pushNamed(
                            context,
                            AppRouter.edit_service_question_form,
                            arguments: widget.service,
                          );
                        }
                      } else {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Failed to update service pricing"),
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Save Pricing"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
