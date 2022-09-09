import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:fuodz/models/product_category.dart';
import 'package:fuodz/models/service.dart';
import 'package:fuodz/requests/product.request.dart';
import 'package:fuodz/requests/service.request.dart';
import 'package:fuodz/requests/vendor.request.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/view_models/base.view_model.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class NewServiceViewModel extends MyBaseViewModel {
  //
  NewServiceViewModel(BuildContext context) {
    this.viewContext = context;
  }

  //
  ServiceRequest serviceRequest = ServiceRequest();
  ProductRequest productRequest = ProductRequest();
  VendorRequest vendorRequest = VendorRequest();
  Service service;
  List<ProductCategory> categories = [];
  List<File> selectedPhotos;

  void initialise() {
    fetchVendorTypeCategories();
  }

  //
  fetchVendorTypeCategories() async {
    setBusyForObject(categories, true);

    try {
      categories = await productRequest.getProductCategories(
        vendorTypeId:
            (await AuthServices.getCurrentVendor(force: true)).vendorType.id,
      );
      clearErrors();
    } catch (error) {
      print("Categories Error ==> $error");
      setError(error);
    }

    setBusyForObject(categories, false);
  }

  //
  onImagesSelected(List<File> files) {
    selectedPhotos = files;
    notifyListeners();
  }

  //
  processNewService() async {
    if (formBuilderKey.currentState.saveAndValidate() &&
        validateSelectedPhotos()) {
      //
      setBusy(true);

      try {
        final apiResponse = await serviceRequest.newService(
          data: formBuilderKey.currentState.value,
          photos: selectedPhotos,
        );
        
        //show dialog to present state
        CoolAlert.show(
            context: viewContext,
            type: apiResponse.allGood
                ? CoolAlertType.success
                : CoolAlertType.error,
            title: "New Service".tr(),
            text: apiResponse.message,
            onConfirmBtnTap: () {
              viewContext.pop();
              if (apiResponse.allGood) {
                viewContext.pop(true);
              }
            });
        clearErrors();
      } catch (error) {
        print("new service Error ==> $error");
        setError(error);
      }

      setBusy(false);
    }
  }

  bool validateSelectedPhotos() {
    if (selectedPhotos == null || selectedPhotos.isEmpty) {
      CoolAlert.show(
        context: viewContext,
        type: CoolAlertType.warning,
        title: "Update Service".tr(),
        text: "Please select at least one photo for service".tr(),
      );
      return false;
    }
    return true;
  }
}
