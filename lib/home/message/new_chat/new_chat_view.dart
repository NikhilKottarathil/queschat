import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:queschat/components/custom_progress_indicator.dart';
import 'package:queschat/components/user_contact_views.dart';
import 'package:queschat/constants/styles.dart';
import 'package:queschat/home/message/new_chat/new_chat_cubit.dart';
import 'package:queschat/home/message/new_chat/new_chat_state.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_cubit.dart';
import 'package:queschat/home/message/new_group_and_channel/new_group_view_select_users.dart';
import 'package:queschat/router/app_router.dart';
import 'package:queschat/uicomponents/custom_ui_widgets.dart';


class NewChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    bool isSearchPressed = false;
    print('pageBuild');

    return BlocListener<NewChatCubit, NewChatState>(
      listener: (context, state) {
        // if (state is Authenticated) {
        //   Navigator.pushReplacementNamed(context, '/home');
        //
        // } else if (state is Unauthenticated) {
        //   Navigator.pushReplacementNamed(context, '/login');
        // }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: .5,
          shadowColor: AppColors.ShadowColor,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: BlocBuilder<NewChatCubit, NewChatState>(
              // buildWhen: (previousState, state) {
              //   return state is SearchPressed || state  is InitialState ||state is SearchCleared ;
              // },
              builder: (BuildContext context, NewChatState state) {
            if (state is SearchPressed) {
              isSearchPressed = true;
            } else if (state is SearchCleared) {
              isSearchPressed = false;
            }
            return !isSearchPressed
                ? Row(
                    children: [
                      IconButton(
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        icon:
                            Icon(Icons.arrow_back, color: AppColors.IconColor),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Text(
                          'Select Contact',
                          style: TextStyles.heading2TextPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: AppColors.IconColor),
                        onPressed: () {
                          context.read<NewChatCubit>().searchPressed();
                        },
                      ),
                    ],
                  )
                : Row(
                    children: [
                      IconButton(
                        constraints: BoxConstraints(),
                        padding: EdgeInsets.all(0),
                        icon:
                            Icon(Icons.arrow_back, color: AppColors.IconColor),
                        onPressed: () {
                          context.read<NewChatCubit>().searchUsers('');

                          context.read<NewChatCubit>().searchCleared();
                        },
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        child: TextField(
                          keyboardType: TextInputType.text,
                          style: TextStyles.bodyTextPrimary,
                          onChanged: (value) {
                            context.read<NewChatCubit>().searchUsers(value);
                          },
                          decoration: new InputDecoration(
                            hintText: 'Search...',
                            border: InputBorder.none,
                            hintStyle:
                               TextStyles.bodyTextSecondary,
                          ),
                        ),
                      ),
                    ],
                  );
          }),
          iconTheme: IconThemeData(color: AppColors.IconColor),
        ),
        body: BlocBuilder<NewChatCubit, NewChatState>(

          buildWhen: (previousState, state) {
            return state is LoadList || state  is InitialState ;
          },
            builder: (BuildContext context, NewChatState state) {
          if (state is InitialState) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Reading your contact please wait',style: TextStyles.subTitle2TextSecondary,),
                SizedBox(height: 20,),
                CustomProgressIndicator(),
              ],
            );
          } else if (state is LoadList){
            return Column(
              children: [
                FlatButtonWithIcon(Icon(Icons.group_add,color: AppColors.IconColor,size: 26,),"New Group",(){
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => NewGroupCubit(authRepo: authRepository,isGroupOrChannel: 'group'),
                      child: NewGroupViewSelectUsers(),
                    ),
                  ));
                }),
                FlatButtonWithIcon(Image.asset('images/channel_nav_icon.png',color: AppColors.IconColor,width: 24,height: 24,scale: 1),"New Channel",(){

                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (context) => NewGroupCubit(authRepo: authRepository,isGroupOrChannel: 'channel'),
                      child: NewGroupViewSelectUsers(),
                    ),
                  ));
                }),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  padding: EdgeInsets.only(left: 20,top: 8,bottom: 8),
                  color: AppColors.StatusBar,

                  width: MediaQuery.of(context).size.width,
                  child: Text("Sorted by name",textAlign: TextAlign.start,style: TextStyle(color: AppColors.TextTertiary,fontSize: 16),),
                ),
                Flexible(

                  child: ListView(
                    padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                    children: state.items.toSet().map((item) {
                      return userContactView(item, context);
                    }).toList(),
                  ),
                ),
              ],
            );
          }
          return CustomProgressIndicator();
        }),
      ),
    );
  }
}
