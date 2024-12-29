import 'package:flutter/material.dart';
import 'package:web1/class/statusrequest.dart';

class HandlingDataView extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;
  final void Function()? onPressed;

  const HandlingDataView(
      {super.key,
      required this.statusRequest,
      required this.widget,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Expanded(
            flex: 3,
            child: Container(
              color: Colors.white,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      // color: .primaryColor,
                      )
                ],
              ),
            ),
          )
        : widget;
  }
}

class HandlingDataRequest extends StatelessWidget {
  final StatusRequest statusRequest;
  final Widget widget;

  const HandlingDataRequest(
      {super.key, required this.statusRequest, required this.widget});

  @override
  Widget build(BuildContext context) {
    return statusRequest == StatusRequest.loading
        ? Expanded(
            flex: 3,
            child: Container(
                color: Colors.white,
                child: const Center(
                  child: CircularProgressIndicator(
                      // color: AppColor.primaryColor,
                      ),
                )),
          )
        : widget;
  }
}
