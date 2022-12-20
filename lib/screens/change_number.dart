import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pickup_driver/services/firebase_services.dart';
import 'package:provider/provider.dart';

import '../services/providers.dart';
import '../widgets/widgets.dart';

class ChangeNumberScreen extends StatefulWidget {
  const ChangeNumberScreen({Key? key}) : super(key: key);

  @override
  State<ChangeNumberScreen> createState() => _ChangeNumberScreenState();
}

class _ChangeNumberScreenState extends State<ChangeNumberScreen> {

  FirebaseAuthentication authentication = FirebaseAuthentication();
  TextEditingController mobileNo = TextEditingController();
  TextEditingController confirmMobileNo = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade800,
        title: Text('Change Number'),
      ),
      body: SingleChildScrollView(
       child: Container(
         padding: EdgeInsets.all(8),
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Enter your old phone number'),
                  const SizedBox(height: 8,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: mobileNo,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required.';
                      }
                      if (value.length < 10) {
                        return 'Mobile number is less than 11 digits';
                      }
                      if (value.length > 10) {
                        return 'Mobile number is more than 11 digits';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        label: const Text('Mobile Number'),
                        prefix: const Text('+234'),
                        hintText: '8012345678',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blue.shade900))),
                    keyboardType: TextInputType.phone,
                    onChanged: (String value) =>
                        Provider.of<Providers>(context, listen: false)
                            .setMobileNoValue(value),
                  ),
                  const SizedBox(height: 16,),
                  const Text('Confirm your new phone number'),
                  const SizedBox(height: 8,),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: confirmMobileNo,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'This field is required.';
                      }
                      if( value != mobileNo.value.text){
                        return 'Phone numbers do not match';
                      }
                      if (value.length < 10) {
                        return 'Mobile number is less than 11 digits';
                      }
                      if (value.length > 10) {
                        return 'Mobile number is more than 11 digits';
                      }
                      return null;
                    },
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                        label: const Text('Mobile Number'),
                        prefix: const Text('+234'),
                        hintText: '8012345678',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.blue.shade900))),
                    keyboardType: TextInputType.phone,
                    onChanged: (String value) =>
                        Provider.of<Providers>(context, listen: false)
                            .setMobileNoValue(value),
                  ),
                  const SizedBox(height: 16,),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            const LoadingWidget().showLoadingWidget(context);
                            await authentication.changeNumber(context);
                          }
                        },
                        child: const Text('NEXT')),
                  ),
                ],
              ),
            ),
          ),
        )
      )
    );
  }
}
