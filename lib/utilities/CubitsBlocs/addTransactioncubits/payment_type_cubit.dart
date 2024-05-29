import 'package:finance_app/utilities/constants.dart';
import 'package:finance_app/widgets/icon_text_combined.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../payment_types.dart';

abstract class PaymentTypeState {}

class PaymentTypeSelected extends PaymentTypeState {
  final Map<String, dynamic> paymentType;
  PaymentTypeSelected(this.paymentType);
}

class PaymentTypeError extends PaymentTypeState {
  final String message;
  PaymentTypeError(this.message);
}

class PaymentTypeCubit extends Cubit<PaymentTypeState> {
  PaymentTypeCubit()
      : super(PaymentTypeSelected({
          'iconData': Icons.credit_card_outlined,
          'iconColor': kColorGrey1,
          'inputText': 'Card',
        }));

  Future<void> showOptions(BuildContext context) async {
    final selectedPaymentType =
        await showModalBottomSheet<Map<String, dynamic>>(
      elevation: 0,
      backgroundColor: kColorWhite,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: ListView(
            children: paymentTypes.map((paymentType) {
              return ListTile(
                splashColor: kColorLightBlueSecondary,
                onTap: () {
                  Navigator.of(context).pop(paymentType);
                },
                title: IconTextCombined(
                  iconData: paymentType['iconData'],
                  iconColor: paymentType['iconColor'],
                  inputText: paymentType['inputText'],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
    if (selectedPaymentType != null) {
      selectPaymentType(selectedPaymentType);
    }
  }

  void selectPaymentType(Map<String, dynamic> paymentType) {
    try {
      emit(PaymentTypeSelected(paymentType));
    } catch (e) {
      emit(PaymentTypeError('Error selecting payment type: $e'));
    }
  }

  void clearPaymentType() {
    emit(PaymentTypeSelected({
      'iconData': Icons.credit_card_outlined,
      'iconColor': kColorGrey1,
      'inputText': 'Card',
    }));
  }
}
