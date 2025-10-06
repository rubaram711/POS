import 'package:flutter/material.dart';
import 'package:pos_project/const/colors.dart';



class ReusableDropDownMenu extends StatefulWidget {
  const ReusableDropDownMenu(
      {super.key,
      required this.list,
      required this.text,
      required this.hint,
      required this.onSelected,
      this.controller,
      required this.validationFunc,
      this.radius = 0, required this.rowWidth, required this.textFieldWidth});
  final List<String> list;
  final String text;
  final String hint;
  final Function onSelected;
  final TextEditingController? controller;
  final Function validationFunc;
  final double radius;
  final double rowWidth;
  final double textFieldWidth;
  @override
  State<ReusableDropDownMenu> createState() => _ReusableDropDownMenuState();
}

class _ReusableDropDownMenuState extends State<ReusableDropDownMenu> {
  String? dropDownValue;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.rowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: widget.rowWidth - widget.textFieldWidth, child: Text(widget.text)),
          SizedBox(
            width: widget.textFieldWidth,
            child: DropdownButtonFormField<String>(
              // autovalidateMode: AutovalidateMode.always,
              value: dropDownValue,
              decoration: InputDecoration(
                hintText: widget.hint,
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
              items: widget.list.map(
                (String label) {
                  return DropdownMenuItem<String>(
                    value: label,
                    child: Text(
                      label,
                    ),
                  );
                },
              ).toList(),
              hint: Text(widget.hint),
              onChanged: (String? value) {
                setState(() {
                  dropDownValue = value;
                });
                widget.onSelected(value);
              },
              validator: (value) {
              return widget.validationFunc(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}




class ReusableDropDownMenuWithSearch extends StatefulWidget {
  const ReusableDropDownMenuWithSearch(
      {super.key,
        required this.list,
        required this.text,
        required this.hint,
        required this.onSelected,
        required this.controller,
        required this.validationFunc,
        this.radius = 9,
        required this.rowWidth,
        required this.textFieldWidth, required this.clickableOptionText, required this.isThereClickableOption, required this.onTappedClickableOption});
  final List<String> list;
  final String text;
  final String hint;
  final Function onSelected;
  final TextEditingController controller;
  final Function validationFunc;
  final double radius;
  final double rowWidth;
  final double textFieldWidth;
  final String clickableOptionText;
  final bool isThereClickableOption;
  final Function onTappedClickableOption;
  @override
  State<ReusableDropDownMenuWithSearch> createState() =>
      _ReusableDropDownMenuWithSearchState();
}
class _ReusableDropDownMenuWithSearchState
    extends State<ReusableDropDownMenuWithSearch> {
  List<String> _filteredOptions = [];

  @override
  void initState() {
    super.initState();
    _filteredOptions = widget.list;
    widget.controller.addListener(_handleSearch);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_handleSearch);
    super.dispose();
  }

  // void _handleSearch() {
  //   final filter = widget.controller.text.toLowerCase();
  //   setState(() {
  //     // Filter the list based on the user's input
  //     _filteredOptions = widget.list
  //         .where((option) => option.toLowerCase().contains(filter))
  //         .toList();
  //
  //     // If no options match or always add the clickable option at the end
  //     if (widget.isThereClickableOption) {
  //       if (_filteredOptions.isEmpty || !_filteredOptions.contains(widget.clickableOptionText)) {
  //         _filteredOptions.add(widget.clickableOptionText);
  //       }
  //     }
  //   });
  // }
  void _handleSearch() {
    final filter = widget.controller.text.toLowerCase();

    final List<String> filtered = widget.list
        .where((option) =>
    option.toLowerCase().contains(filter) &&
        option != widget.clickableOptionText)
        .toList();

    if (widget.isThereClickableOption) {
      filtered.add(widget.clickableOptionText);
    }

    setState(() {
      _filteredOptions = filtered;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.rowWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: widget.rowWidth - widget.textFieldWidth,
              child: Text(widget.text)),
          FormField<String>(
            builder: (FormFieldState<String> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownMenu<String>(
                    width: widget.textFieldWidth,
                    enableSearch: true,
                    controller: widget.controller,
                    hintText: widget.hint,
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: const TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                      contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: state.hasError ? Colors.red : Primary.primary.withAlpha((0.2 * 255).toInt()), width: 1),
                        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                        borderRadius: BorderRadius.all(Radius.circular(widget.radius)),
                      ),
                    ),
                    menuHeight: 250,
                    dropdownMenuEntries: _filteredOptions.map<DropdownMenuEntry<String>>((String option) {
                      if (option == widget.clickableOptionText) {
                        return DropdownMenuEntry<String>(
                          value: option,
                          label: "",
                          labelWidget: GestureDetector(
                            onTap: () {
                              widget.onTappedClickableOption();
                            },
                            child: Text(
                              option,
                              style: TextStyle(color: Primary.primary, decoration: TextDecoration.underline),
                            ),
                          ),
                        );
                      } else {
                        return DropdownMenuEntry<String>(
                          value: option,
                          label: option,
                        );
                      }
                    }).toList(),
                    onSelected: (String? val) {
                      if (val != widget.clickableOptionText) {
                        state.didChange(val);
                        widget.onSelected(val);
                        state.validate();
                      }
                    },
                  ),
                  // DropdownMenu<String>(
                  //   width: widget.textFieldWidth,
                  //   // requestFocusOnTap: false,
                  //   enableSearch: true,
                  //   controller: widget.controller,
                  //   hintText: widget.hint,
                  //   inputDecorationTheme: InputDecorationTheme(
                  //     // filled: true,
                  //     hintStyle: const TextStyle(
                  //         color: Colors.grey, fontStyle: FontStyle.italic),
                  //     contentPadding: const EdgeInsets.fromLTRB(20, 0, 25, 5),
                  //     // outlineBorder: BorderSide(color: Colors.black,),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //           color: state.hasError
                  //               ? Colors.red
                  //               : Primary.primary.withAlpha((0.2 * 255).toInt()),
                  //           width: 1),
                  //       borderRadius:
                  //           BorderRadius.all(Radius.circular(widget.radius)),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderSide: BorderSide(
                  //           color: Primary.primary.withAlpha((0.4 * 255).toInt()), width: 2),
                  //       borderRadius:
                  //           BorderRadius.all(Radius.circular(widget.radius)),
                  //     ),
                  //   ),
                  //   // menuStyle: ,
                  //   menuHeight: 250,
                  //   // dropdownMenuEntries: widget.list
                  //   //     .map<DropdownMenuEntry<String>>((String option) {
                  //   //   return DropdownMenuEntry<String>(
                  //   //     value: option,
                  //   //     label: option,
                  //   //   );
                  //   // }).toList(),
                  //   dropdownMenuEntries: _filteredOptions.map<DropdownMenuEntry<String>>(
                  //         (String option) {
                  //       if (option == "ClickableOption") {
                  //         return DropdownMenuEntry<String>(
                  //           value: "ClickableOption",
                  //           label: "",
                  //           labelWidget: GestureDetector(
                  //             onTap: () {
                  //               widget.onTappedClickableOption();
                  //             },
                  //             child: Text(
                  //               widget.clickableOptionText,
                  //               style: TextStyle(
                  //                   color: Colors.green,
                  //                   decoration: TextDecoration.underline),
                  //             ),
                  //           ),
                  //         );
                  //       }
                  //       return DropdownMenuEntry<String>(
                  //         value: option,
                  //         label: option,
                  //       );
                  //     },
                  //   ).toList(),
                  //   // dropdownMenuEntries: widget.isThereClickableOption
                  //   // ?[
                  //   //   ...widget.list.map<DropdownMenuEntry<String>>(
                  //   //     (String option) {
                  //   //       return DropdownMenuEntry<String>(
                  //   //         value: option,
                  //   //         label: option,
                  //   //       );
                  //   //     },
                  //   //   ),
                  //   //   DropdownMenuEntry<String>(
                  //   //     value: "ClickableOption",
                  //   //     label: "",
                  //   //     labelWidget: GestureDetector(
                  //   //       onTap: () {
                  //   //         widget.onTappedClickableOption();
                  //   //       },
                  //   //       child: Text(
                  //   //         widget.clickableOptionText,
                  //   //         style: TextStyle(color: Primary.primary,decoration:TextDecoration.underline),
                  //   //       ),
                  //   //     ),
                  //   //   ),
                  //   // ]: widget.list
                  //   //     .map<DropdownMenuEntry<String>>((String option) {
                  //   //   return DropdownMenuEntry<String>(
                  //   //     value: option,
                  //   //     label: option,
                  //   //   );
                  //   // }).toList(),
                  //   enableFilter: true,
                  //   onSelected: (String? val) {
                  //     if(val!='ClickableOption'){
                  //     state.didChange(val);
                  //     widget.onSelected(val);
                  //     state.validate();}
                  //   },
                  // ),
                  if (state.hasError)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 25),
                      child: Text(
                        state.errorText ?? '',
                        style: const TextStyle(color: Colors.red, fontSize: 10),
                      ),
                    ),
                ],
              );
            },
            validator: (value) {
              return widget.validationFunc(value);
            },
          ),
        ],
      ),
    );
  }
}