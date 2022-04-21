import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/function/show_snack_bar.dart';
import 'package:queschat/home/message/message_room/message_room_cubit.dart';
import 'package:queschat/home/message/message_room/message_room_state.dart';
import 'package:queschat/uicomponents/appbars.dart';

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
