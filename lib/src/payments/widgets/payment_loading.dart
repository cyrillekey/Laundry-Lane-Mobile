import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:laundrylane/models/order_pay_response.dart';

import 'package:laundrylane/src/apis/mutations.dart';
import 'package:laundrylane/src/home/home.dart';
import 'package:laundrylane/src/orders/order_details.dart';
import 'package:laundrylane/widgets/progress_button.dart';
import 'package:laundrylane/widgets/quarter_spinner.dart';

class CompletePaymentModal extends StatefulWidget {
  const CompletePaymentModal({
    super.key,
    required this.orderId,
    this.cardId,
    this.phone,
    required this.paymentMethod,
  });
  final int orderId;
  final int? cardId;
  final String? phone;
  final String paymentMethod;

  @override
  State<CompletePaymentModal> createState() => _CompletePaymentModalState();
}

class _CompletePaymentModalState extends State<CompletePaymentModal> {
  PaymentStatus paymentStatus = PaymentStatus.pending;
  @override
  void initState() {
    makePayment();
    super.initState();
  }

  void makePayment() async {
    final response = await payForOrder(
      orderId: widget.orderId,
      paymentMethod: widget.paymentMethod,
      phone: widget.phone,
      cardId: widget.cardId,
    );
    if (response.success == true) {
      paymentStatus = response.status!;
    } else {
      paymentStatus = response.status ?? PaymentStatus.failed;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.18),
          Builder(
            builder: (context) {
              switch (paymentStatus) {
                case PaymentStatus.successfull:
                  return SuccessfullPayment();
                case PaymentStatus.failed:
                  return const FailedPayment();
                case PaymentStatus.cancelled:
                  return const CancelledPayment();
                case PaymentStatus.pending:
                  return PendingPayment();
              }
            },
          ),
          Spacer(),
          ProgressButton(
            label:
                paymentStatus == PaymentStatus.pending
                    ? "Waiting for payment..."
                    : PaymentStatus.failed == paymentStatus
                    ? "Retry Payment"
                    : "Done",
            onPress: () {
              if (paymentStatus == PaymentStatus.pending) {
                return;
              }
              if (paymentStatus == PaymentStatus.failed ||
                  paymentStatus == PaymentStatus.cancelled) {
                paymentStatus = PaymentStatus.pending;
                setState(() {});
                makePayment();
              }
              if (paymentStatus == PaymentStatus.successfull) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  OrderDetails.routeName,
                  ModalRoute.withName(HomePage.routeName),
                  arguments: widget.orderId,
                );
              }
            },
            disabled: paymentStatus == PaymentStatus.pending,
            size: Size(MediaQuery.of(context).size.width, 64),
            borderRadius: 20,
            backgroundColor:
                paymentStatus == PaymentStatus.failed ||
                        paymentStatus == PaymentStatus.cancelled
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary,
            textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color:
                  paymentStatus == PaymentStatus.failed ||
                          paymentStatus == PaymentStatus.cancelled
                      ? Theme.of(context).colorScheme.onError
                      : Theme.of(context).colorScheme.onPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class PendingPayment extends StatelessWidget {
  const PendingPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        QuarterSpinner(
          size: MediaQuery.of(context).size.height * .12,
          strokeWidth: 8,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .04),
        Text(
          "Completing your payment",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        Text(
          "Please wait while we validate and complete your payment",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class FailedPayment extends StatelessWidget {
  const FailedPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          TablerIcons.alert_triangle,
          size: MediaQuery.of(context).size.height * .12,
          color: Theme.of(context).colorScheme.error,
        ),
        SizedBox(height: MediaQuery.of(context).size.height * .04),
        Text(
          "Payment Failed!",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        Text(
          "Your order payment has failed. Please try again to complete the payment",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class CancelledPayment extends StatelessWidget {
  const CancelledPayment({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SuccessfullPayment extends StatefulWidget {
  const SuccessfullPayment({super.key});

  @override
  State<SuccessfullPayment> createState() => _SuccessfullPaymentState();
}

class _SuccessfullPaymentState extends State<SuccessfullPayment> {
  late ConfettiController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ConfettiController(duration: const Duration(seconds: 10));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _controller.play();
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        ConfettiWidget(
          confettiController: _controller,
          numberOfParticles: 20,
          shouldLoop: false,
          blastDirectionality: BlastDirectionality.explosive,
          colors: const [
            Colors.green,
            Colors.blue,
            Colors.pink,
            Colors.orange,
            Colors.purple,
          ],
          child: Icon(
            Icons.check_circle_rounded,
            size: 82,
            color: Colors.green,
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * .025),
        Text(
          "Payment successful",
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: 20),
        Text(
          "Your transaction has been completed successfully",
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
