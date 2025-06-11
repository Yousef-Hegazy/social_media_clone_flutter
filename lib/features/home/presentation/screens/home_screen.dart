import 'package:flutter/material.dart';
import 'package:social_media_clean/features/home/presentation/widgets/home_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home"),
        actionsPadding: EdgeInsets.symmetric(horizontal: 10),
        // actions: [
        //   BlocBuilder<AuthCubit, AuthState>(
        //     builder: (ctx, state) {
        //       return IconButton(
        //         onPressed: ctx.read<AuthCubit>().logout,
        //         icon: SizedBox(
        //           width: 20,
        //           height: 20,
        //           child: state is AuthLoading
        //               ? CircularProgressIndicator.adaptive(strokeWidth: 2)
        //               : Icon(Icons.logout),
        //         ),
        //       );
        //     },
        //   ),
        // ],
      ),
      drawer: HomeDrawer(),
    );
  }
}
