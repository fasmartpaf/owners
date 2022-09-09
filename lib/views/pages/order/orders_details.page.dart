import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:fuodz/constants/app_colors.dart';
import 'package:fuodz/constants/app_ui_settings.dart';
import 'package:fuodz/extensions/dynamic.dart';
import 'package:fuodz/models/order.dart';
import 'package:fuodz/constants/app_strings.dart';
import 'package:fuodz/utils/ui_spacer.dart';
import 'package:fuodz/view_models/order_details.vm.dart';
import 'package:fuodz/views/pages/order/widgets/order_actions.dart';
import 'package:fuodz/views/pages/order/widgets/order_address.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_attachment.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_details_items.view.dart';
import 'package:fuodz/views/pages/order/widgets/order_status.view.dart';
import 'package:fuodz/widgets/base.page.dart';
import 'package:fuodz/widgets/busy_indicator.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/cards/order_summary.dart';
import 'package:fuodz/widgets/currency_hstack.dart';
import 'package:stacked/stacked.dart';
import 'package:ticketview/ticketview.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({this.order, Key key}) : super(key: key);

  //
  final Order order;

  @override
  Widget build(BuildContext context) {
    //
    return ViewModelBuilder<OrderDetailsViewModel>.reactive(
      viewModelBuilder: () => OrderDetailsViewModel(context, order),
      onModelReady: (vm) => vm.initialise(),
      builder: (context, vm, child) {
        return BasePage(
          title: "Order Details".tr(),
          showAppBar: true,
          showLeadingAction: true,
          onBackPressed: vm.onBackPressed,
          isLoading: vm.isBusy,
          body: vm.isBusy
              ? BusyIndicator().centered()
              : TicketView(
                  triangleAxis: Axis.vertical,
                  contentPadding: EdgeInsets.zero,
                  drawTriangle: true,
                  trianglePos: 0.49,
                  contentBackgroundColor: context.backgroundColor,
                  child: VStack(
                    [
                      //code & total amount
                      HStack(
                        [
                          //
                          VStack(
                            [
                              "Code".tr().text.gray500.medium.sm.make(),
                              "#${vm.order.code}".text.medium.xl.make(),
                            ],
                          ).expand(),
                          //total amount
                          CurrencyHStack(
                            [
                              AppStrings.currencySymbol.text.medium.lg
                                  .make()
                                  .px4(),
                              (vm.order.total ?? 0.00)
                                  .currencyValueFormat()
                                  .text
                                  .medium
                                  .xl2
                                  .make(),
                            ],
                          ),
                        ],
                      ),
                      UiSpacer.verticalSpace(),

                      //show package delivery addresses
                      OrderAddressView(vm),
                      //
                      OrderAttachmentView(vm),

                      //status
                      OrderStatusView(vm),

                      //driver
                      vm.order.driver != null
                          ? HStack(
                              [
                                //
                                VStack(
                                  [
                                    "Driver".tr().text.gray500.medium.sm.make(),
                                    (vm.order.driver.name ?? "")
                                        .text
                                        .medium
                                        .xl
                                        .make()
                                        .pOnly(bottom: Vx.dp20),
                                  ],
                                ).expand(),
                                //call
                                CustomButton(
                                  icon: FlutterIcons.phone_call_fea,
                                  iconColor: Colors.white,
                                  color: AppColor.primaryColor,
                                  shapeRadius: Vx.dp20,
                                  onPressed: vm.callDriver,
                                ).wh(Vx.dp64, Vx.dp40).p12(),
                              ],
                            )
                          : UiSpacer.emptySpace(),

                      //chat
                      if (vm.order.canChatDriver)
                        Visibility(
                          visible: AppUISettings.canDriverChat,
                          child: CustomButton(
                            icon: FlutterIcons.chat_ent,
                            iconColor: Colors.white,
                            title: "Chat with driver".tr(),
                            color: AppColor.primaryColor,
                            onPressed: vm.chatDriver,
                          ).h(Vx.dp48).pOnly(top: Vx.dp12, bottom: Vx.dp20),
                        )
                      else
                        UiSpacer.emptySpace(),

                      //customer
                      HStack(
                        [
                          //
                          VStack(
                            [
                              "Customer".tr().text.gray500.medium.sm.make(),
                              vm.order.user.name
                                  .allWordsCapitilize()
                                  .text
                                  .medium
                                  .xl
                                  .make()
                                  .pOnly(bottom: Vx.dp20),
                            ],
                          ).expand(),
                          //call
                          vm.order.canChatCustomer
                              ? CustomButton(
                                  icon: FlutterIcons.phone_call_fea,
                                  iconColor: Colors.white,
                                  color: AppColor.primaryColor,
                                  shapeRadius: Vx.dp20,
                                  onPressed: vm.callCustomer,
                                ).wh(Vx.dp64, Vx.dp40).p12()
                              : UiSpacer.emptySpace(),
                        ],
                      ),
                      if (vm.order.canChatCustomer)
                        Visibility(
                          visible: AppUISettings.canCustomerChat,
                          child: CustomButton(
                            icon: FlutterIcons.chat_ent,
                            iconColor: Colors.white,
                            title: "Chat with customer".tr(),
                            color: AppColor.primaryColor,
                            onPressed: vm.chatCustomer,
                          ).h(Vx.dp48).pOnly(top: Vx.dp12, bottom: Vx.dp20),
                        )
                      else
                        UiSpacer.emptySpace(),

                      //recipient
                      // RecipientInfo(
                      //   callRecipient: vm.callRecipient,
                      //   order: vm.order,
                      // ),

                      //note
                      "Note".tr().text.gray500.medium.sm.make(),
                      (vm.order.note)
                          .text
                          .medium
                          .xl
                          .italic
                          .make()
                          .pOnly(bottom: Vx.dp20),

                      UiSpacer.verticalSpace(),
                      UiSpacer.verticalSpace(),

                      // either products/package details
                      OrderDetailsItemsView(vm),

                      //order summary
                      OrderSummary(
                        subTotal: vm.order.subTotal,
                        driverTrip: vm.order.tip,
                        discount: vm.order.discount,
                        deliveryFee: vm.order.deliveryFee,
                        tax: vm.order.tax,
                        vendorTax: vm.order.taxRate.toString(),
                        total: vm.order.total,
                      ).pOnly(top: Vx.dp20, bottom: Vx.dp56),
                    ],
                  ).p20(),
                )
                  .p20()
                  .pOnly(bottom: context.percentHeight * 20)
                  .scrollVertical()
                  .box
                  .color(AppColor.primaryColor)
                  .make(),

          //fab printing
          fab: Platform.isAndroid
              ? FloatingActionButton.extended(
                  onPressed: vm.printOrder,
                  label: "Print".text.white.make(),
                  backgroundColor: AppColor.primaryColor,
                  icon: Icon(
                    FlutterIcons.print_faw,
                    color: Colors.white,
                  ),
                )
              : null,
          //bottomsheet
          bottomSheet: vm.order.canShowActions
              ? OrderActions(
                  order: vm.order,
                  canChatCustomer: vm.order.canChatCustomer,
                  busy: vm.isBusy || vm.busy(vm.order),
                  onEditPressed: vm.changeOrderStatus,
                  onAssignPressed: vm.assignOrder,
                  onCancelledPressed: vm.processOrderCancellation,
                )
              : null,
        );
      },
    );
  }
}
