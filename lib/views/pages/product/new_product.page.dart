import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/new_products.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/multi_image_selector.dart';
import 'package:fuodz/widgets/custom_html.input.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NewProductPage extends StatelessWidget {
  const NewProductPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<NewProductViewModel>.reactive(
      viewModelBuilder: () => NewProductViewModel(context),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showLeadingAction: true,
          showAppBar: true,
          title: "New Product".tr(),
          body: SafeArea(
            top: true,
            bottom: false,
            child: FormBuilder(
              key: vm.formBuilderKey,
              child: VStack(
                [
                  //name
                  FormBuilderTextField(
                    name: 'name',
                    decoration: InputDecoration(
                      labelText: 'Name'.tr(),
                    ),
                    onChanged: (value) {},
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(context),
                    ]),
                  ),
                  UiSpacer.verticalSpace(),
                  //image
                  MultiImageSelectorView(
                    onImagesSelected: vm.onImagesSelected,
                  ),
                  UiSpacer.verticalSpace(),
                  //description
                  "Description".tr().text.make(),
                  CustomHtmlInput(quilController: vm.quilController),

                  UiSpacer.verticalSpace(),
                  //pricing
                  HStack(
                    [
                      //price
                      FormBuilderTextField(
                        name: 'price',
                        decoration: InputDecoration(
                          labelText: 'Price'.tr(),
                        ),
                        onChanged: (value) {},
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.numeric(context),
                        ]),
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //Discount price
                      FormBuilderTextField(
                        name: 'discount_price',
                        decoration: InputDecoration(
                          labelText: 'Discount Price'.tr(),
                        ),
                        onChanged: (value) {},
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ).expand(),
                    ],
                  ),
                  //
                  UiSpacer.verticalSpace(),
                  //packaging
                  HStack(
                    [
                      //Capacity
                      FormBuilderTextField(
                        name: 'capacity',
                        decoration: InputDecoration(
                          labelText: 'Capacity'.tr(),
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //unit
                      FormBuilderTextField(
                        name: 'unit',
                        decoration: InputDecoration(
                          labelText: 'Unit'.tr(),
                        ),
                        onChanged: (value) {},
                      ).expand(),
                    ],
                  ),
                  //
                  UiSpacer.verticalSpace(),
                  //pricing
                  HStack(
                    [
                      //package_count
                      FormBuilderTextField(
                        name: 'package_count',
                        decoration: InputDecoration(
                          labelText: 'Package Count'.tr(),
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                      ).expand(),
                      UiSpacer.horizontalSpace(),
                      //available_qty
                      FormBuilderTextField(
                        name: 'available_qty',
                        decoration: InputDecoration(
                          labelText: 'Available Qty'.tr(),
                        ),
                        onChanged: (value) {},
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ).expand(),
                    ],
                  ),
                  //
                  UiSpacer.verticalSpace(),
                  //deliverable
                  FormBuilderCheckbox(
                    initialValue: false,
                    name: 'deliverable',
                    onChanged: (value) {},
                    valueTransformer: (value) => value ? 1 : 0,
                    title: "Can be delivered".tr().text.make(),
                  ),
                  //Active
                  FormBuilderCheckbox(
                    initialValue: false,
                    name: 'is_active',
                    onChanged: (value) {},
                    valueTransformer: (value) => value ? 1 : 0,
                    title: "Active".tr().text.make(),
                  ),
                  //

                  //categories
                  vm.busy(vm.categories)
                      ? BusyIndicator().centered()
                      : FormBuilderFilterChip(
                          name: 'category_ids',
                          decoration: InputDecoration(
                            labelText: 'Category'.tr(),
                          ),
                          spacing: 5,
                          selectedColor: AppColor.primaryColor,
                          options: vm.categories
                              .map(
                                (category) => FormBuilderFieldOption(
                                  value: '${category.id}',
                                  child: '${category.name}'.text.make(),
                                ),
                              )
                              .toList(),
                          onChanged: vm.filterSubcategories,
                        ),
                  UiSpacer.verticalSpace(),
                  //subcategories
                  vm.busy(vm.subCategories)
                      ? BusyIndicator().centered()
                      : FormBuilderFilterChip(
                          name: 'sub_category_ids',
                          decoration: InputDecoration(
                            labelText: 'Sub-Category'.tr(),
                          ),
                          spacing: 5,
                          selectedColor: AppColor.primaryColor,
                          options: vm.subCategories
                              .map(
                                (category) => FormBuilderFieldOption(
                                  value: '${category.id}',
                                  child: '${category.name}'.text.make(),
                                ),
                              )
                              .toList(),
                        ),
                  UiSpacer.verticalSpace(),
                  //menus
                  vm.busy(vm.menus)
                      ? BusyIndicator().centered()
                      : FormBuilderFilterChip(
                          name: 'menu_ids',
                          decoration: InputDecoration(
                            labelText: 'Menus'.tr(),
                          ),
                          spacing: 5,
                          selectedColor: AppColor.primaryColor,
                          options: vm.menus
                              .map(
                                (menu) => FormBuilderFieldOption(
                                  value: '${menu.id}',
                                  child: '${menu.name}'.text.make(),
                                ),
                              )
                              .toList(),
                        ),
                  UiSpacer.verticalSpace(),
                  //
                  CustomButton(
                    title: "Save Product".tr(),
                    loading: vm.isBusy,
                    onPressed: vm.processNewProduct,
                  ).centered().py12(),
                ],
              ),
            )
                .p20()
                .scrollVertical()
                .pOnly(bottom: context.mq.viewInsets.bottom),
          ),
        );
      },
    );
  }
}
