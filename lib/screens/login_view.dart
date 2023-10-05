import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:zest_trade/screens/opt_view.dart';
import 'package:zest_trade/utils/app_constant.dart';
import 'package:zest_trade/utils/base_colors.dart';
import 'package:zest_trade/utils/base_images.dart';
import 'package:zest_trade/utils/extensions.dart';

class LoginView extends StatefulWidget {
  const LoginView({
    super.key,
  });

  @override
  State<LoginView> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LoginView> {
  String? _countryDialCode;
  TextEditingController numberController = TextEditingController();

  @override
  void initState() {
    _countryDialCode = CountryCode.fromCountryCode('IN').dialCode;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: BaseColors.SKY_BLUE,
        body: Container(
          width: size.width,
          decoration: const BoxDecoration(
              image: DecorationImage(
            image: AssetImage(
              BaseImages.COVER_IMAGE,
            ),
            fit: BoxFit.cover,
          )),
          child: Stack(
            // alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                top: -20,
                left: 0,
                right: 0,
                child: Image.asset(
                  BaseImages.ON_BR_ONE,
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  height: size.height / 1.6,
                  width: size.width,
                  padding: const EdgeInsets.only(top: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: 30.0.toRadius, topRight: 30.0.toRadius),
                    color: BaseColors.WHITE.withOpacity(.5),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: 30.0.toRadius, topRight: 30.0.toRadius),
                        color: BaseColors.WHITE),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        21.0.toVSB,
                        const Text(
                          BaseStrings.mobileNumber,
                          style: TextStyle(
                              fontSize: 16,
                              color: BaseColors.GRAY,
                              fontFamily: BaseFonts.popins_regular),
                        ),
                        phoneNumber,
                        24.0.toVSB,
                        googleSignUp(size),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget get phoneNumber => Row(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: BaseColors.GRAY_1))),
              child: const CountryCodePicker(
                onChanged: print,
                initialSelection: 'IN',
                favorite: ['+91', 'IN'],
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                alignLeft: false,
                // showDropDownButton: true,
                textStyle: TextStyle(
                    color: BaseColors.GRAY,
                    fontFamily: BaseFonts.popins_regular,
                    fontSize: 16),
                enabled: false,
              ),
            ),
          ),
          10.0.toHSB,
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.only(top: 2),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: BaseColors.GRAY_1,
                  ),
                ),
              ),
              child: TextFormField(
                controller: numberController,
                decoration: const InputDecoration(
                  hintText: 'Enter phone number',
                  counterText: '',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                keyboardType: TextInputType.number,
                validator: (er) {
                  if (er == null) {
                    return 'Please Enter valid number';
                  }
                  return null;
                },
                maxLength: 10,
              ),
            ),
          ),
        ],
      );

  Widget googleSignUp(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: 10.0.toAllBorderRadius,
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(61, 219, 147, 0.17))
            ],
          ),
          child: MaterialButton(
            onPressed: () {
              setState(() {
                if (numberController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text("Alert!").toCenter,
                      content: const Text("Phone number should not be empty"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child:
                              const Text("Ok", style: TextStyle(fontSize: 18)),
                        ),
                      ],
                    ),
                  );
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const OTPVerificationView(),
                    ),
                  );
                }
              });
            },
            color: BaseColors.SKY_BLUE,
            height: 55.0,
            shape: OutlineInputBorder(
                borderRadius: 10.0.toAllBorderRadius,
                borderSide: const BorderSide(color: Colors.transparent)),
            child: const Text(
              'Sign Up',
              style: TextStyle(
                  color: BaseColors.WHITE,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontFamily: BaseFonts.popins_bold),
            ),
          ),
        ),
        30.0.toVSB,
        Row(
          children: [
            const Divider(
              color: BaseColors.GRAY_2,
            ).toExpanded,
            11.0.toHSB,
            const Text(BaseStrings.txtWith,
                style: TextStyle(
                    fontSize: 15.0,
                    color: BaseColors.BLACK,
                    fontFamily: BaseFonts.popins_regular)),
            11.0.toHSB,
            const Divider(
              color: BaseColors.GRAY_2,
            ).toExpanded,
          ],
        ),
        30.0.toVSB,
        Container(
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: 10.0.toAllBorderRadius,
            boxShadow: const [
              BoxShadow(color: Color.fromRGBO(246, 63, 46, 0.30))
            ],
          ),
          child: MaterialButton(
            onPressed: () {
              print("sfsdfsfd");
            },
            color: BaseColors.RED,
            height: 55.0,
            shape: OutlineInputBorder(
                borderRadius: 10.0.toAllBorderRadius,
                borderSide: const BorderSide(color: Colors.transparent)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  BaseImages.IC_GOOGLE,
                ),
                const Text(
                  'Google',
                  style: TextStyle(
                      color: BaseColors.WHITE,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: BaseFonts.popins_bold),
                ),
                const SizedBox(width: 50),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
