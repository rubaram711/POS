// import 'package:country_currency_pickers/country.dart';
// import 'package:country_currency_pickers/country_picker_dropdown.dart';
// import 'package:country_currency_pickers/utils/utils.dart';
import 'package:country_currency_pickers/country.dart';
import 'package:country_currency_pickers/country_picker_dropdown.dart';
import 'package:country_currency_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../Backend/get_countries.dart';
import '../../const/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


class ReusableTextField extends StatefulWidget {
  const ReusableTextField({
    super.key,
    required this.onChangedFunc,
    required this.validationFunc,
    required this.hint,
    required this.isPasswordField,
    this.isEnable = true,
    this.maxLines=1,
    required this.textEditingController,
  });
  final Function onChangedFunc;
  final Function validationFunc;
  final String hint;
  final bool isPasswordField;
  final bool isEnable;
  final int maxLines;
  final TextEditingController textEditingController;
  @override
  State<ReusableTextField> createState() => _ReusableTextFieldState();
}

class _ReusableTextFieldState extends State<ReusableTextField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: widget.isEnable,
      maxLines: widget.maxLines,
      cursorColor: Colors.black,
      obscureText: widget.isPasswordField ? !showPassword : false,
      decoration: InputDecoration(
        hintText: widget.hint,
        // labelStyle: TextStyle(
        //   color: kBasicColor
        // ),
        // filled: true,
        // fillColor: Colors.white,
        suffixIcon: widget.isPasswordField
            ? IconButton(
                onPressed: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
                icon: Icon(
                  showPassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                  size: 23,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 25, 5),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black.withAlpha((0.1 * 255).toInt()), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: Colors.black.withAlpha((0.1 * 255).toInt()), width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(6)),
        ),
        errorStyle: const TextStyle(
          fontSize: 10.0,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
      ),
      validator: (value) {
        return widget.validationFunc(value);
      },
      onChanged: (value) => widget.onChangedFunc(value),
    );
  }
}

class ReusableNumberField extends StatefulWidget {
  const ReusableNumberField({
    super.key,
    required this.onChangedFunc,
    required this.validationFunc,
    required this.hint,
    required this.isPasswordField,
    this.isEnable = true,
    this.isCentered = false,
    required this.textEditingController,
  });
  final Function onChangedFunc;
  final Function validationFunc;
  final String hint;
  final bool isPasswordField;
  final bool isEnable;
  final bool isCentered;
  final TextEditingController textEditingController;
  @override
  State<ReusableNumberField> createState() => _ReusableNumberFieldState();
}

class _ReusableNumberFieldState extends State<ReusableNumberField> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        enabled: widget.isEnable,
        cursorColor: Colors.black,
        controller: widget.textEditingController,
        textAlign:widget.isCentered? TextAlign.center:TextAlign.left,
        obscureText: widget.isPasswordField ? !showPassword : false,
        decoration: InputDecoration(
          hintText: widget.hint,
          // labelStyle: TextStyle(
          //   color: kBasicColor
          // ),
          // filled: true,
          // fillColor: Colors.white,
          suffixIcon: widget.isPasswordField
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },
                  icon: Icon(
                    showPassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                    size: 23,
                  ),
                )
              : null,
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 25, 5),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black.withAlpha((0.1 * 255).toInt()), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Colors.black.withAlpha((0.1 * 255).toInt()), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(6)),
          ),
          errorStyle: const TextStyle(
            fontSize: 10.0,
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(6)),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
        ),
        validator: (value) {
          return widget.validationFunc(value);
        },
        onChanged: (value) => widget.onChangedFunc(value),
        keyboardType: const TextInputType.numberWithOptions(
          decimal: false,
          signed: true,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
          // WhitelistingTextInputFormatter.digitsOnly
        ]);
  }
}

class ReusableSearchTextField extends StatefulWidget {
  const ReusableSearchTextField(
      {super.key,
      required this.onChangedFunc,
      required this.validationFunc,
      required this.hint, required this.textEditingController});
  final Function onChangedFunc;
  final Function validationFunc;
  final String hint;
  final TextEditingController textEditingController;
  @override
  State<ReusableSearchTextField> createState() =>
      _ReusableSearchTextFieldState();
}

class _ReusableSearchTextFieldState extends State<ReusableSearchTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: Colors.black,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: const TextStyle(
          fontStyle: FontStyle.italic,
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Primary.primary, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(9)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Primary.primary, width: 1),
          borderRadius: const BorderRadius.all(Radius.circular(9)),
        ),
        errorStyle: const TextStyle(
          fontSize: 10.0,
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(9)),
          borderSide: BorderSide(width: 1, color: Colors.red),
        ),
      ),
      // validator: (value) {
      //   return widget.validationFunc(value);
      // },
      onChanged: (value) => widget.onChangedFunc(value),
    );
  }
}

class DialogTextFieldWithoutText extends StatelessWidget {
  const DialogTextFieldWithoutText({
    super.key,
    required this.onIconClickedFunc,
    required this.onChangedFunc,
    required this.validationFunc,
    required this.textFieldWidth,
    required this.textEditingController,
    this.hint = '',
    this.radius = 9, required this.onCloseIconClickedFunc,
    this.isHasCloseIcon=false
  });
  final Function onCloseIconClickedFunc;
  final Function onIconClickedFunc;
  final Function onChangedFunc;
  final Function validationFunc;
  final String hint;
  final double radius;
  final double textFieldWidth;
  final TextEditingController textEditingController;
  final bool isHasCloseIcon;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: textFieldWidth,
      child: TextFormField(
        cursorColor: Colors.black,
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          suffixIcon:  hint=='search_with_close'.tr || isHasCloseIcon ?IconButton(
              onPressed: (){
                onCloseIconClickedFunc();
              },
              icon: const Icon(Icons.close,size: 20,))
              // : hint!='scan_barcode'.tr
              // ?const Icon(Icons.search,size: 20,)
             :null,
          prefixIcon: hint=='scan_barcode'.tr?IconButton(
            onPressed: (){
              onIconClickedFunc();
            },
              icon: const Icon(CupertinoIcons.barcode,size: 20,)):null,
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
            borderRadius:   BorderRadius.all(Radius.circular(radius)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
            borderRadius:   BorderRadius.all(Radius.circular(radius)),
          ),
          errorStyle: const TextStyle(
            fontSize: 10.0,
          ),
          focusedErrorBorder:   OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
        ),
        // validator: (value) {
        //   return widget.validationFunc(value);
        // },
        onChanged: (value) => onChangedFunc(value),
      ),
    );
  }
}

class DialogDateTextField extends StatefulWidget {
  const DialogDateTextField(
      {super.key,
      required this.onChangedFunc,
      required this.validationFunc,
      required this.text,
      required this.textFieldWidth,
      required this.textEditingController,
      required this.onDateSelected});
  final Function onChangedFunc;
  final Function onDateSelected;
  final Function validationFunc;
  final String text;
  final double textFieldWidth;
  final TextEditingController textEditingController;
  @override
  State<DialogDateTextField> createState() => _DialogDateTextFieldState();
}

class _DialogDateTextFieldState extends State<DialogDateTextField> {
  DateTime selectedDate = DateTime.now();
  bool isDateSelected = false;
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        isDateSelected = true;
        widget.onDateSelected(DateFormat('yyyy-MM-dd').format(selectedDate));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.textFieldWidth,
      child: TextFormField(
        cursorColor: Colors.black,
        controller: widget.textEditingController,
        decoration: InputDecoration(
          hintText:
              isDateSelected ? DateFormat('yyyy-MM-dd').format(selectedDate) : widget.text, //todo format
          suffixIcon: Icon(Icons.calendar_month, color: Primary.primary),
          contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(9)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
            borderRadius: const BorderRadius.all(Radius.circular(9)),
          ),
          errorStyle: const TextStyle(
            fontSize: 10.0,
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(9)),
            borderSide: BorderSide(width: 1, color: Colors.red),
          ),
        ),
        onTap: () {
          _selectDate(context);
        },
        onChanged: (value) => widget.onChangedFunc(value),
      ),
    );
  }
}

class ReusableInputNumberField extends StatefulWidget {
  const ReusableInputNumberField(
      {super.key,
      required this.onChangedFunc,
      required this.validationFunc,
      required this.text,
      required this.textFieldWidth,
      required this.rowWidth,
      required this.controller});
  final Function onChangedFunc;
  final Function validationFunc;
  final String text;
  final double textFieldWidth;
  final double rowWidth;
  final TextEditingController controller;
  @override
  State<ReusableInputNumberField> createState() =>
      _ReusableInputNumberFieldState();
}

class _ReusableInputNumberFieldState extends State<ReusableInputNumberField> {
  @override
  void initState() {
    widget.controller.text = "0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        // width: widget.rowWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.text,
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                SizedBox(
                  width: widget.textFieldWidth,
                  child: TextFormField(
                    // textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 10),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(9)),
                      ),
                      errorStyle: const TextStyle(
                        fontSize: 10.0,
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        borderSide: BorderSide(width: 1, color: Colors.red),
                      ),
                    ),
                    validator: (value) {
                      return widget.validationFunc(value);
                    },
                    controller: widget.controller,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
                      // WhitelistingTextInputFormatter.digitsOnly
                    ],
                  ),
                ),
                SizedBox(
                  height: 38.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        child: const Icon(
                          Icons.arrow_drop_up,
                          size: 18.0,
                        ),
                        onTap: () {
                          int currentValue = int.parse(widget.controller.text);
                          setState(() {
                            currentValue++;
                            widget.controller.text =
                                (currentValue).toString(); // incrementing value
                          });
                        },
                      ),
                      InkWell(
                        child: const Icon(
                          Icons.arrow_drop_down,
                          size: 18.0,
                        ),
                        onTap: () {
                          int currentValue = int.parse(widget.controller.text);
                          setState(() {
                            currentValue--;
                            widget.controller.text =
                                (currentValue > 0 ? currentValue : 0)
                                    .toString(); // decrementing value
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

class PriceTextField extends StatelessWidget {
  const PriceTextField({
    super.key,
    required this.onChangedFunc,
    required this.textFieldWidth,
    required this.textEditingController,
    this.hint = '',
    this.radius = 0,
  });
  final Function onChangedFunc;
  final String hint;
  final double radius;
  final double textFieldWidth;
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: textFieldWidth,
      child: TextFormField(
        cursorColor: Colors.black,
        controller: textEditingController,
        decoration: InputDecoration(
          enabled: false,
          hintText: hint,
          hintStyle: const TextStyle(fontSize: 14, color: Colors.black87),
          // contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
          enabledBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
            borderRadius:   BorderRadius.all(Radius.circular(radius)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
            BorderSide(color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
            borderRadius:   BorderRadius.all(Radius.circular(radius)),
          ),
          errorStyle: const TextStyle(
            fontSize: 10.0,
          ),
          focusedErrorBorder:   OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            borderSide: const BorderSide(width: 1, color: Colors.red),
          ),
        ),
        // validator: (value) {
        //   return widget.validationFunc(value);
        // },
        onChanged: (value) => onChangedFunc(value),
      ),
    );
  }
}



class ReusableDialogTextField extends StatelessWidget {
  const ReusableDialogTextField({
    super.key,
    // required this.onChangedFunc,
    required this.validationFunc,
    required this.text,
    required this.rowWidth,
    required this.textFieldWidth,
    required this.textEditingController,
    this.hint = '',
  });
  // final Function onChangedFunc;
  final Function validationFunc;
  final String text;
  final String hint;
  final double rowWidth;
  final double textFieldWidth;
  final TextEditingController textEditingController;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // width: rowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: rowWidth - textFieldWidth, child: Text(text)),
          SizedBox(
            width: textFieldWidth,
            child: TextFormField(
              cursorColor: Colors.black,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    const TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                  borderRadius: const BorderRadius.all(Radius.circular(9)),
                ),
                errorStyle: const TextStyle(
                  fontSize: 10.0,
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                  borderSide: BorderSide(width: 1, color: Colors.red),
                ),
              ),
              validator: (value) {
                return validationFunc(value);
              },
              // onChanged: (value) => onChangedFunc(value),
            ),
          ),
        ],
      ),
    );
  }
}


class PhoneTextField extends StatefulWidget {
  const PhoneTextField({
    super.key,
    required this.onChangedFunc,
    required this.validationFunc,
    required this.text,
    required this.rowWidth,
    required this.textFieldWidth,
    required this.textEditingController,
    this.hint = '',
    required this.onCodeSelected,
  });
  final Function onChangedFunc;
  final Function validationFunc;
  final Function onCodeSelected;
  final String text;
  final String hint;
  final double rowWidth;
  final double textFieldWidth;
  final TextEditingController textEditingController;

  @override
  State<PhoneTextField> createState() => _PhoneTextFieldState();
}

class _PhoneTextFieldState extends State<PhoneTextField> {
  List<String> countriesNamesList=[];
  bool isCountriesFetched = false;
  getCountriesFromBack() async {
    var p = await getCountries();
    setState(() {
      for (var c in p) {
        countriesNamesList.add('${c['country']}');
      }
      isCountriesFetched = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.rowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(widget.text),
          SizedBox(
            width: widget.textFieldWidth,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(9),
                    border: Border.all(
                        color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                  ),
                  width: widget.textFieldWidth * 0.45,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 2, vertical: 10),
                  child: CountryPickerDropdown(
                    initialValue: 'lb',
                    itemBuilder: _buildDropdownItem,
                    onValuePicked: (Country? country) {
                      widget.onCodeSelected("+${country!.phoneCode}");
                    },
                  ),
                ),
                SizedBox(
                  width: widget.textFieldWidth * 0.54,
                  child: TextFormField(
                    cursorColor: Colors.black,
                    controller: widget.textEditingController,
                    decoration: InputDecoration(
                      hintText: widget.hint,
                      hintStyle: const TextStyle(
                          fontSize: 14, fontStyle: FontStyle.italic),
                      contentPadding: const EdgeInsets.fromLTRB(10, 0, 25, 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(9)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                        borderRadius:
                        const BorderRadius.all(Radius.circular(9)),
                      ),
                      errorStyle: const TextStyle(
                        fontSize: 10.0,
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        borderSide: BorderSide(width: 1, color: Colors.red),
                      ),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: true,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      // WhitelistingTextInputFormatter.digitsOnly
                    ],
                    validator: (value) {
                      return widget.validationFunc(value);
                    },
                    onChanged: (value) => widget.onChangedFunc(value),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(Country country) => SizedBox(
    width: widget.textFieldWidth * 0.3,
    child: Row(
      children: <Widget>[
        SizedBox(
            width: widget.textFieldWidth * 0.1,
            child: CountryPickerUtils.getDefaultFlagImage(country)),
        // SizedBox(
        //   width: 3.0,
        // ),
        // Text("+${country.phoneCode}(${country.isoCode})"),
        SizedBox(
            width: widget.textFieldWidth * 0.2,
            child: Text(
              "+${country.phoneCode}",
              style: const TextStyle(fontSize: 13),
            )),
      ],
    ),
  );

// _buildCountryPickerDropdown(bool filtered) => Row(
//   children: <Widget>[
//     CountryPickerDropdown(
//       initialValue: 'AR',
//       itemBuilder: _buildDropdownItem,
//       itemFilter: filtered
//           ? (c) => ['AR', 'DE', 'GB', 'CN'].contains(c.isoCode)
//           : null,
//       onValuePicked: (Country? country) {
//         print("${country?.name}");
//       },
//     ),
//     const SizedBox(
//       width: 8.0,
//     ),
//     const Expanded(
//       child: TextField(
//         decoration: InputDecoration(labelText: "Phone"),
//       ),
//     )
//   ],
// );
}