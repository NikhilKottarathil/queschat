import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/authentication/app_data.dart';
import 'package:queschat/components/popups/show_custom_bottom_sheet.dart';
import 'package:queschat/components/shimmer_widget.dart';
import 'package:queschat/components/user_contact_views.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/firebase_dynamic_link.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/function/time_conversions.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_cubit.dart';
import 'package:queschat/home/message/message_room/add_members/add_members_to_message_room_view.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_member_contact_view.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:queschat/uicomponents/appbars.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';
import 'package:share_plus/share_plus.dart';

class MessageRoomIconView extends StatelessWidget {


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: appBarWithBackButton(context: context, titleString: 'Edit',tailActions: [
       if( context
            .read<MessageRoomCubit>().userRole!='user')
        IconButton(onPressed: (){
          context
              .read<MessageRoomCubit>()
              .changeGroupIcon(context);
        }, icon: Icon(Icons.edit,color: AppColors.IconColor,))
      ]),
      body: BlocListener<MessageRoomCubit, MessageRoomState>(
        listener: (context, state) async {
          if (state is ErrorMessageState) {
            showSnackBar(context, state.e);
          }
        },
        child: BlocBuilder<MessageRoomCubit, MessageRoomState>(
            builder: (context, state) {
              return Center(child: Image.network(context.read<MessageRoomCubit>().chatRoomModel.imageUrl,));
            }),
      ),
    );
  }
}
