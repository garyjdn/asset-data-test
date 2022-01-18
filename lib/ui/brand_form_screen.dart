import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testapp/bloc/brand_form/brand_form_cubit.dart';
import 'package:testapp/bloc/brand_model/brand_model_cubit.dart';
import 'package:testapp/data/repositories/brand_repository.dart';

import '../bloc/manufacturer/manufacturer_cubit.dart';
import '../data/repositories/manufacturer_repository.dart';
import '../models/brand_model.dart';
import '../models/manufacturer.dart';

class BrandFormScreen extends StatelessWidget {
  const BrandFormScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final manufacturerRepository =
        RepositoryProvider.of<ManufacturerRepository>(context, listen: false);
    final brandRepository =
        RepositoryProvider.of<BrandRepository>(context, listen: false);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              ManufacturerCubit(manufacturerRepository: manufacturerRepository)
                ..fetchData(),
        ),
        BlocProvider<BrandFormCubit>(
          create: (context) => BrandFormCubit(brandRepository: brandRepository),
        ),
      ],
      child: BrandFormView(),
    );
  }
}

class BrandFormView extends StatefulWidget {
  const BrandFormView({Key? key}) : super(key: key);

  @override
  _BrandFormViewState createState() => _BrandFormViewState();
}

class _BrandFormViewState extends State<BrandFormView> {
  late List<BrandModel> _availableModels;
  String? _selectedManufacturer;
  String? _selectedModel;
  final _brandCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _availableModels = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Brand'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose Manufacturer',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              BlocBuilder<ManufacturerCubit, ManufacturerState>(
                builder: (context, state) {
                  if (state is ManufacturerLoadSuccess) {
                    return DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedManufacturer,
                      hint: const Text('Select Manufacture'),
                      items:
                          state.manufacturers.map((Manufacturer manufacturers) {
                        return DropdownMenuItem<String>(
                          value: manufacturers.guid,
                          child: Text(manufacturers.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        final manufacturer = state.manufacturers
                            .firstWhere((m) => m.guid == val);
                        setState(() {
                          _selectedManufacturer = manufacturer.guid;
                          _availableModels = manufacturer.models;
                        });
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              const SizedBox(height: 18),
              Text(
                'Choose Model',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              DropdownButton<String>(
                isExpanded: true,
                value: _selectedModel,
                hint: const Text('Select Model'),
                items: _availableModels.map((BrandModel model) {
                  return DropdownMenuItem<String>(
                    value: model.guid,
                    child: Text(model.name),
                  );
                }).toList(),
                onChanged: (val) {
                  final manufacturer =
                      _availableModels.firstWhere((m) => m.guid == val);
                  setState(() => _selectedModel = manufacturer.guid);
                },
              ),
              const SizedBox(height: 18),
              Text(
                'Brand',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _brandCtrl,
                decoration: const InputDecoration(
                  hintText: 'Enter Brand',
                ),
              ),
              const SizedBox(height: 30),
              BlocConsumer<BrandFormCubit, BrandFormState>(
                listener: (context, state) {
                  if (state is BrandFormSubmiteSuccess) {
                    final snackBar = SnackBar(
                      content: Text(
                          state.message ?? 'Brand was successfully created'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                builder: (context, state) {
                  if (state is BrandFormSubmitInProgress) {
                    return SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    width: double.infinity,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedManufacturer != null &&
                            _selectedModel != null) {
                          context.read<BrandFormCubit>().saveData(
                                guid: _selectedManufacturer!,
                                modelGuid: _selectedModel!,
                                brand: _brandCtrl.text,
                              );
                        }
                      },
                      child: const Text('Add'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
