import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:livestock/data_model/customer_data.dart';

class CustomerForm extends HookWidget {
  final Color primaryColor;
  final void Function(CustomerData) onNext;

  const CustomerForm({super.key, required this.primaryColor, required this.onNext});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>(), []);
    final TextEditingController nameController = useTextEditingController();
    final ValueNotifier<IndustrialNature> industrialNature =
        useValueNotifier<IndustrialNature>(IndustrialNature.values.first);
    final ValueNotifier<Location> location = useValueNotifier<Location>(Location.values.first);
    final TextEditingController contactController = useTextEditingController();
    final ValueNotifier<bool> agree = useValueNotifier<bool>(false);
    final ValueNotifier<String> errorText = useValueNotifier<String>('');

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Expanded(child: Text('貴賓姓名')),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '不可為空';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('貴公司產業性質')),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Theme.of(context).colorScheme.outline)),
                      child: ValueListenableBuilder<IndustrialNature>(
                        valueListenable: industrialNature,
                        builder: (context, industrialNatureValue, __) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<IndustrialNature>(
                              value: industrialNatureValue,
                              items: IndustrialNature.values
                                  .map((e) => DropdownMenuItem<IndustrialNature>(
                                        value: e,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(e.name),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) => industrialNature.value = value!,
                              isDense: true,
                              isExpanded: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('公司(牧場)區域位置')),
                Expanded(
                  flex: 4,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Theme.of(context).colorScheme.outline)),
                      child: ValueListenableBuilder<Location>(
                        valueListenable: location,
                        builder: (context, locationValue, __) {
                          return DropdownButtonHideUnderline(
                            child: DropdownButton<Location>(
                              value: locationValue,
                              items: Location.values
                                  .map((e) => DropdownMenuItem<Location>(
                                        value: e,
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 10),
                                          child: Text(e.name),
                                        ),
                                      ))
                                  .toList(),
                              onChanged: (value) => location.value = value!,
                              isDense: true,
                              isExpanded: true,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Expanded(child: Text('聯絡資訊')),
                Expanded(
                  flex: 4,
                  child: TextFormField(
                    controller: contactController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return '不可為空';
                      }

                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: agree,
                  builder: (context, agreeValue, __) {
                    return Checkbox(
                      value: agreeValue,
                      onChanged: (value) => agree.value = value!,
                    );
                  },
                ),
                const Text('我同意將個資提供給主辦方作為管理此活動及通知此用'),
              ],
            ),
            ValueListenableBuilder<String>(
              valueListenable: errorText,
              builder: (context, text, __) {
                return Text(
                  text,
                  style: TextStyle(color: Theme.of(context).inputDecorationTheme.errorStyle?.color ?? Colors.red),
                );
              },
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size(200, 60),
                elevation: 4,
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
              onPressed: () {
                errorText.value = '';
                if (formKey.currentState!.validate()) {
                  if (!agree.value) {
                    errorText.value = '請勾選同意以繼續進行下一步。';
                    return;
                  }

                  onNext(CustomerData(
                      name: nameController.text,
                      industrialNature: industrialNature.value,
                      location: location.value,
                      contactInformation: contactController.text));
                }
              },
              child: const Text(
                '參加',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
