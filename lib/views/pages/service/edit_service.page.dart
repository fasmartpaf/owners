import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/edit_service.vm.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/multiple_image_selector.dart';
import 'package:stacked/stacked.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EditServicePage extends StatelessWidget {
  const EditServicePage(this.service, {Key key}) : super(key: key);

  final Service service;
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<EditServiceViewModel>.reactive(
      viewModelBuilder: () => EditServiceViewModel(context, service),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          showAppBar: true,
          showLeadingAction: true,
          title: "Edit Service".tr(),
          body: FormBuilder(
            key: vm.formBuilderKey,
            child: VStack(
              [
                //categories
                vm.busy(vm.categories)
                    ? BusyIndicator().centered()
                    : VStack(
                        [
                          "Category".tr().text.make(),
                          FormBuilderDropdown(
                            name: "category_id",
                            initialValue: service.categoryId.toString(),
                            items: vm.categories
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: '${category.id}',
                                    child: Text('${category.name}'),
                                  ),
                                )
                                .toList(),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(context),
                            ]),
                          ),
                        ],
                      ),

                UiSpacer.verticalSpace(),

                //name
                FormBuilderTextField(
                  name: 'name',
                  initialValue: service.name,
                  decoration: InputDecoration(
                    labelText: 'Name'.tr(),
                  ),
                  onChanged: (value) {},
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                  keyboardType: TextInputType.number,
                ),
                UiSpacer.verticalSpace(),
                //description
                FormBuilderTextField(
                  name: 'description',
                  initialValue: service.description,
                  decoration: InputDecoration(
                    labelText: 'Description'.tr(),
                  ),
                  onChanged: (value) {},
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                  maxLines: 3,
                  textInputAction: TextInputAction.newline,
                ),
                UiSpacer.verticalSpace(),
                //image
                MultipleImageSelectorView(
                  photos: service.photos,
                  onImagesSelected: vm.onImagesSelected,
                ),
                UiSpacer.verticalSpace(),
                //pricing
                HStack(
                  [
                    //price
                    FormBuilderTextField(
                      name: 'price',
                      initialValue: service.price.toString(),
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
                      initialValue: service.discountPrice.toString(),
                      decoration: InputDecoration(
                        labelText: 'Discount Price'.tr(),
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
                  ],
                ),

                //checkbox
                HStack(
                  [
                    //Per hour
                    FormBuilderCheckbox(
                      initialValue: service.perHour == 1,
                      name: 'per_hour',
                      onChanged: (value) {},
                      valueTransformer: (value) => value ? 1 : 0,
                      title: "Per Hour".tr().text.make(),
                    ).expand(),
                    //Active
                    FormBuilderCheckbox(
                      initialValue: service.isActive == 1,
                      name: 'is_active',
                      onChanged: (value) {},
                      valueTransformer: (value) => value ? 1 : 0,
                      title: "Active".tr().text.make(),
                    ).expand(),
                  ],
                ),
                //

                //
                CustomButton(
                  title: "Save".tr(),
                  icon: FlutterIcons.save_fea,
                  loading: vm.isBusy,
                  onPressed: vm.processUpdateService,
                ).wFull(context).py12(),
                UiSpacer.verticalSpace(),
                UiSpacer.verticalSpace(),
              ],
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
