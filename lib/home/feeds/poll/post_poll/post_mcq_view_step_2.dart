// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:queschat/authentication/form_submitting_status.dart';
// import 'package:queschat/components/custom_progress_indicator.dart';
// import 'package:queschat/components/custom_radio_button.dart';
// import 'package:queschat/components/key_value_radio_item.dart';
// import 'package:queschat/components/option_text_field.dart';
// import 'package:queschat/constants/styles.dart';
// import 'package:queschat/function/show_snack_bar.dart';
// import 'package:queschat/home/feeds/feeds_repo.dart';
// import 'package:queschat/home/feeds/post_a_mcq/post_mcq_bloc.dart';
// import 'package:queschat/home/feeds/post_a_mcq/post_mcq_event.dart';
// import 'package:queschat/home/feeds/post_a_mcq/post_mcq_state.dart';
// import 'package:queschat/models/radio_model.dart';
// import 'package:queschat/uicomponents/appbars.dart';
// import 'package:queschat/uicomponents/custom_ui_widgets.dart';
//
// class PostAMCQViewStep2 extends StatefulWidget {
//   @override
//   _PostAMCQViewStep2State createState() => _PostAMCQViewStep2State();
// }
//
// class _PostAMCQViewStep2State extends State<PostAMCQViewStep2>
//     with SingleTickerProviderStateMixin {
//   List<RadioModel> radioData = new List<RadioModel>();
//   final _formKey = GlobalKey<FormState>();
//
//   FeedRepository feedRepo;
//   TabController tabController;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     tabController = TabController(length: 2, vsync: this, initialIndex: 0);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     feedRepo = new FeedRepository();
//     if (radioData.isEmpty) {
//       radioData.add(new RadioModel(isSelected: false, text: "A"));
//       radioData.add(new RadioModel(isSelected: false, text: "B"));
//       radioData.add(new RadioModel(isSelected: false, text: "C"));
//       radioData.add(new RadioModel(isSelected: false, text: "D"));
//     }
//     // create: (context) => PostMcqBloc(feedRepo: feedRepo),
//
//     return Scaffold(
//       appBar:
//           appBarWithBackButton(context: context, titleString: "Post a Poll"),
//       body: BlocListener<PostMcqBloc, PostMcqState>(
//         listener: (context, state) {
//           final formStatus = state.formSubmissionStatus;
//           if (formStatus is SubmissionFailed) {
//             showSnackBar(context, formStatus.exception);
//           }
//           if (formStatus is SubmissionSuccess) {
//             // context.read<FeedsBloc>().add(UserAddedNewFeed(id: formStatus.id));
//             context.read<PostMcqBloc>().add(ClearAllFields());
//
//             Navigator.pop(context);
//             Navigator.pop(context);
//           }
//         },
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return Stack(
//               children: [
//                 SingleChildScrollView(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                         minWidth: constraints.maxWidth,
//                         minHeight: constraints.maxHeight),
//                     child: IntrinsicHeight(
//                       child: Padding(
//                         padding: EdgeInsets.all(20),
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text('Number of options',style: TextStyles.mediumMediumTextSecondary,),
//
//                               SizedBox(height: 8,),
//                               BlocBuilder<PostMcqBloc, PostMcqState>(
//                                   builder: (context, state) {
//                                 return Padding(
//                                     padding: EdgeInsets.fromLTRB(0, 10.0, 0, 0),
//                                     child: Wrap(
//                                       children: List.generate(
//                                         context
//                                             .read<PostMcqBloc>()
//                                             .optionNumbers
//                                             .length,
//                                         (index) => GestureDetector(
//                                           onTap: (){
//                                             context
//                                                 .read<PostMcqBloc>().add(NumberOfOptionChanged(index: index));
//                                           },
//                                           child: KeyValueRadioItem(context
//                                               .read<PostMcqBloc>()
//                                               .optionNumbers[index]),
//                                         ),
//                                       ),
//                                     ));
//                               }),
//                               SizedBox(height: 18,),
//                               SizedBox(height: 18,),
//
//                               // Text('Choose Option',style: TextStyles.mediumMediumTextSecondary,),
//                               Container(
//                                 margin: EdgeInsets.only(top: 10),
//                                 decoration: BoxDecoration(
//                                   color: AppColors.ShadowColor,
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 padding: EdgeInsets.all(2),
//                                 child: new TabBar(
//                                     indicatorColor: Colors.grey,
//                                     labelStyle: TextStyle(
//                                         fontSize: 14,
//                                         fontWeight: FontWeight.w600),
//                                     indicator: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius: BorderRadius.circular(10),
//                                         boxShadow: [
//                                           BoxShadow(
//                                             color: AppColors.ShadowColor,
//                                           )
//                                         ]),
//                                     onTap: (index) {
//                                       context
//                                           .read<PostMcqBloc>()
//                                           .add(ChooseOptionType());
//                                     },
//                                     controller: tabController,
//                                     labelColor: AppColors.PrimaryColor,
//                                     unselectedLabelColor:
//                                         AppColors.TextTertiary,
//                                     tabs: <Tab>[
//                                       new Tab(text: "Text"),
//                                       new Tab(text: "Image"),
//                                     ]),
//                               ),
//                               BlocBuilder<PostMcqBloc, PostMcqState>(
//                                   builder: (context, state) {
//                                 return Padding(
//                                   padding: const EdgeInsets.only(
//                                       bottom: 14, top: 14),
//                                   child: Column(
//                                     children: [
//                                       Visibility(
//                                         visible: !state.isImageOptions,
//                                         child: Column(
//                                           children: [
//                                             OptionTextField(
//                                               hint: 'Enter first option here',
//                                               optionKey: "A",
//                                               text: state.optionA,
//                                               textInputType:
//                                                   TextInputType.multiline,
//                                               validator: (value) {
//                                                 return state
//                                                     .optionAValidationText;
//                                               },
//                                               onChange: (value) {
//                                                 context.read<PostMcqBloc>().add(
//                                                       OptionAChanged(
//                                                           optionA: value),
//                                                     );
//                                               },
//                                             ),
//                                             OptionTextField(
//                                               hint: 'Enter second option here',
//                                               optionKey: "B",
//                                               text: state.optionB,
//                                               validator: (value) {
//                                                 return state
//                                                     .optionBValidationText;
//                                               },
//                                               onChange: (value) {
//                                                 context.read<PostMcqBloc>().add(
//                                                       OptionBChanged(
//                                                           optionB: value),
//                                                     );
//                                               },
//                                             ),
//                                             Visibility(
//                                               visible: context.read<PostMcqBloc>().optionNumbers[2].isSelected || context.read<PostMcqBloc>().optionNumbers[1].isSelected,
//                                               child: OptionTextField(
//                                                 hint: 'Enter third option here',
//                                                 optionKey: "C",
//                                                 text: state.optionC,
//                                                 validator: (value) {
//                                                   return state
//                                                       .optionCValidationText;
//                                                 },
//                                                 onChange: (value) {
//                                                   context.read<PostMcqBloc>().add(
//                                                         OptionCChanged(
//                                                             optionC: value),
//                                                       );
//                                                 },
//                                               ),
//                                             ),
//                                             Visibility(
//                                               visible: context.read<PostMcqBloc>().optionNumbers[2].isSelected ,
//                                               child: OptionTextField(
//                                                 hint: 'Enter fourth option here',
//                                                 optionKey: "D",
//                                                 text: state.optionD,
//                                                 validator: (value) {
//                                                   return state
//                                                       .optionDValidationText;
//                                                 },
//                                                 onChange: (value) {
//                                                   context.read<PostMcqBloc>().add(
//                                                         OptionDChanged(
//                                                             optionD: value),
//                                                       );
//                                                 },
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       Visibility(
//                                           visible: state.isImageOptions,
//                                           child: Column(
//                                             children: [
//                                               Row(
//                                                 children: [
//                                                   Expanded(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         context
//                                                             .read<PostMcqBloc>()
//                                                             .add(
//                                                                 SelectOptionAImage(
//                                                                     context));
//                                                       },
//                                                       child: Container(
//                                                           padding:
//                                                               EdgeInsets.all(5),
//                                                           height: 100,
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color:
//                                                                 AppColors.White,
//                                                             boxShadow: [
//                                                               BoxShadow(
//                                                                 color: Colors
//                                                                     .grey
//                                                                     .shade200,
//                                                                 offset: Offset(
//                                                                     0.5, 0.5),
//                                                                 spreadRadius: 1,
//                                                                 blurRadius: 2,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           child: Row(
//                                                             children: [
//                                                               Text(
//                                                                 'A :',
//                                                                 style: TextStyles
//                                                                     .smallRegularTextSecondary,
//                                                               ),
//                                                               Expanded(
//                                                                 child: Center(
//                                                                   child: state.optionAImage ==
//                                                                           null
//                                                                       ? Icon(
//                                                                           Icons
//                                                                               .add_photo_alternate_outlined,
//                                                                           color: AppColors
//                                                                               .IconColor)
//                                                                       : Image
//                                                                           .file(
//                                                                           state
//                                                                               .optionAImage,
//                                                                           fit: BoxFit
//                                                                               .scaleDown,
//                                                                         ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           )),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 14,
//                                                   ),
//                                                   Expanded(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         context
//                                                             .read<PostMcqBloc>()
//                                                             .add(
//                                                                 SelectOptionBImage(
//                                                                     context));
//                                                       },
//                                                       child: Container(
//                                                           height: 100,
//                                                           padding:
//                                                               EdgeInsets.all(5),
//                                                           decoration:
//                                                               BoxDecoration(
//                                                             color:
//                                                                 AppColors.White,
//                                                             boxShadow: [
//                                                               BoxShadow(
//                                                                 color: Colors
//                                                                     .grey
//                                                                     .shade200,
//                                                                 offset: Offset(
//                                                                     0.5, 0.5),
//                                                                 spreadRadius: 1,
//                                                                 blurRadius: 2,
//                                                               ),
//                                                             ],
//                                                           ),
//                                                           child: Row(
//                                                             children: [
//                                                               Text(
//                                                                 'B :',
//                                                                 style: TextStyles
//                                                                     .smallRegularTextSecondary,
//                                                               ),
//                                                               Expanded(
//                                                                 child: Center(
//                                                                   child: state.optionBImage ==
//                                                                           null
//                                                                       ? Icon(
//                                                                           Icons
//                                                                               .add_photo_alternate_outlined,
//                                                                           color: AppColors
//                                                                               .IconColor)
//                                                                       : Image
//                                                                           .file(
//                                                                           state
//                                                                               .optionBImage,
//                                                                           fit: BoxFit
//                                                                               .scaleDown,
//                                                                         ),
//                                                                 ),
//                                                               ),
//                                                             ],
//                                                           )),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                               SizedBox(
//                                                 height: 14,
//                                               ),
//                                               Row(
//                                                 children: [
//                                                   Expanded(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         context
//                                                             .read<PostMcqBloc>()
//                                                             .add(
//                                                                 SelectOptionCImage(
//                                                                     context));
//                                                       },
//                                                       child: Container(
//                                                         height: 100,
//                                                         padding:
//                                                             EdgeInsets.all(5),
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           color:
//                                                               AppColors.White,
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey
//                                                                   .shade200,
//                                                               offset: Offset(
//                                                                   0.5, 0.5),
//                                                               spreadRadius: 1,
//                                                               blurRadius: 2,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         child: Row(
//                                                           children: [
//                                                             Text(
//                                                               'C :',
//                                                               style: TextStyles
//                                                                   .smallRegularTextSecondary,
//                                                             ),
//                                                             Expanded(
//                                                               child: Center(
//                                                                 child: state.optionCImage ==
//                                                                         null
//                                                                     ? Icon(
//                                                                         Icons
//                                                                             .add_photo_alternate_outlined,
//                                                                         color: AppColors
//                                                                             .IconColor)
//                                                                     : Image
//                                                                         .file(
//                                                                         state
//                                                                             .optionCImage,
//                                                                         fit: BoxFit
//                                                                             .scaleDown,
//                                                                       ),
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   SizedBox(
//                                                     width: 14,
//                                                   ),
//                                                   Expanded(
//                                                     child: InkWell(
//                                                       onTap: () {
//                                                         context
//                                                             .read<PostMcqBloc>()
//                                                             .add(
//                                                                 SelectOptionDImage(
//                                                                     context));
//                                                       },
//                                                       child: Container(
//                                                         height: 100,
//                                                         padding:
//                                                             EdgeInsets.all(5),
//                                                         decoration:
//                                                             BoxDecoration(
//                                                           color:
//                                                               AppColors.White,
//                                                           boxShadow: [
//                                                             BoxShadow(
//                                                               color: Colors.grey
//                                                                   .shade200,
//                                                               offset: Offset(
//                                                                   0.5, 0.5),
//                                                               spreadRadius: 1,
//                                                               blurRadius: 2,
//                                                             ),
//                                                           ],
//                                                         ),
//                                                         child: Row(
//                                                           children: [
//                                                             Text(
//                                                               'D :',
//                                                               style: TextStyles
//                                                                   .smallRegularTextSecondary,
//                                                             ),
//                                                             Expanded(
//                                                               child: Center(
//                                                                   child: state.optionDImage ==
//                                                                           null
//                                                                       ? Icon(
//                                                                           Icons
//                                                                               .add_photo_alternate_outlined,
//                                                                           color: AppColors
//                                                                               .IconColor)
//                                                                       : Image
//                                                                           .file(
//                                                                           state
//                                                                               .optionDImage,
//                                                                           fit: BoxFit
//                                                                               .scaleDown,
//                                                                         )),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               )
//                                             ],
//                                           ))
//                                     ],
//                                   ),
//                                 );
//                               }),
//                               Row(
//                                 children: [
//                                   Text("Select Correct Answer : \t"),
//                                   BlocBuilder<PostMcqBloc, PostMcqState>(
//                                     builder: (context, state) {
//                                       for (int i = 0; i < 4; i++) {
//                                         RadioModel radioModel = radioData[i];
//                                         radioModel.isSelected = false;
//                                         if (radioModel.text ==
//                                             state.correctOption) {
//                                           radioModel.isSelected = true;
//                                           radioData[i] = radioModel;
//                                         }
//                                       }
//                                       return Container(
//                                         height: 40,
//                                         width:
//                                             MediaQuery.of(context).size.width *
//                                                 .5,
//                                         child: ListView.builder(
//                                             shrinkWrap: true,
//                                             itemCount: radioData.length,
//                                             scrollDirection: Axis.horizontal,
//                                             itemBuilder: (BuildContext context,
//                                                 int index) {
//                                               return CustomRadioButton(
//                                                 optionKey:
//                                                     radioData[index].text,
//                                                 isSelected:
//                                                     radioData[index].isSelected,
//                                                 function: () {
//                                                   context
//                                                       .read<PostMcqBloc>()
//                                                       .add(CorrectOptionChanged(
//                                                           correctOption:
//                                                               radioData[index]
//                                                                   .text));
//                                                 },
//                                               );
//                                             }),
//                                       );
//                                     },
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(
//                                 height: 100,
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: Padding(
//                     padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//                     child: BlocBuilder<PostMcqBloc, PostMcqState>(
//                       builder: (context, state) {
//                         return state.formSubmissionStatus is FormSubmitting
//                             ? CustomProgressIndicator()
//                             : CustomButton(
//                                 text: "POST",
//                                 action: () async {
//                                   if (!state.isImageOptions) {
//                                     context
//                                         .read<PostMcqBloc>()
//                                         .add(PostMcqSubmitted());
//                                   } else {
//                                     if (state.question == null ||
//                                         state.question == '') {
//                                       _formKey.currentState.validate();
//                                     } else {
//                                       if (state.optionAImage != null &&
//                                           state.optionBImage != null &&
//                                           state.optionCImage != null &&
//                                           state.optionDImage != null) {
//                                         context
//                                             .read<PostMcqBloc>()
//                                             .add(PostMcqSubmitted());
//                                       } else {
//                                         Exception e = Exception([
//                                           'Please Select Images for Option'
//                                         ]);
//                                         showSnackBar(context, e);
//                                       }
//                                     }
//                                   }
//                                 },
//                               );
//                       },
//                     ),
//                   ),
//                 )
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
