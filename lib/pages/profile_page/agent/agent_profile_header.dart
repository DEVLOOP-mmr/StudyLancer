import 'dart:io';

import 'package:elite_counsel/bloc/home_bloc/home_bloc.dart';
import 'package:elite_counsel/bloc/home_bloc/home_state.dart';
import 'package:elite_counsel/bloc/profile_bloc.dart';
import 'package:elite_counsel/variables.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';

import '../../document_page/agent/agent_document_page.dart';

class AgentProfileHeader extends StatelessWidget {
  const AgentProfileHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.loadState == LoadState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is InitialHomeState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final agent = (state as AgentHomeState).agent;
        return Column(
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  void _showImagePicker(BuildContext context) async {
                    var bloc =
                        BlocProvider.of<HomeBloc>(context, listen: false);
                    var agent = (bloc.state as AgentHomeState).agent;
                    final result = await ImagePicker().pickImage(
                      imageQuality: 70,
                      maxWidth: 1440,
                      source: ImageSource.gallery,
                    );

                    if (result != null) {
                      final file = File(result.path);
                      final size = file.lengthSync();
                      final bytes = await result.readAsBytes();
                      final image = await decodeImageFromList(bytes);
                      final imageName = result.path.split('/').last;

                      try {
                        final reference =
                            FirebaseStorage.instance.ref(imageName);
                        await reference.putFile(file);
                        final uri = await reference.getDownloadURL();

                        agent.photo = uri;
                        bloc.emitNewAgent(agent);
                        ProfileBloc.setAgentProfile(agent).then(
                            (value) => bloc.getAgentHome(context: context));
                      } on FirebaseException catch (e) {
                        EasyLoading.showInfo(e.message);
                      }
                    } else {
                      // User canceled the picker
                    }
                  }

                  _showImagePicker(context);
                },
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  width: 133.0,
                  height: 133.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(agent.photo ??
                          "https://emailproleads.com/wp-content/uploads/2019/10/student-3500990_1920.jpg"),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff131618),
                        offset: Offset(-6, -5),
                        spreadRadius: 0,
                        blurRadius: 45.0,
                      ),
                    ],
                    border: Border.all(
                      width: 10,
                      color: const Color(0xff1C1F22),
                    ),
                    // color: Color(0xff1E2022),
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 100.0, vertical: 16),
              child: NeumorphicButton(
                padding: EdgeInsets.zero,
                child: Container(
                  color: const Color(0xff294A91),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      gradient: Variables.buttonGradient,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.insert_drive_file_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "My Documents",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const AgentDocumentPage();
                  }));
                },
                style: NeumorphicStyle(
                    border: const NeumorphicBorder(
                        isEnabled: true,
                        color: Variables.backgroundColor,
                        width: 2),
                    shadowLightColor: Colors.white.withOpacity(0.6),
                    // color: Color(0xff294A91),
                    boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(30))),
              ),
            ),
          ],
        );
      },
    );
  }
}
