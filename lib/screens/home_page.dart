import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sqlite_database_practice/controller/note_controller.dart';
import 'package:sqlite_database_practice/service/theme_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  /// getting the controller object here

  final noteController = Get.find<NoteController>();

  final titleController = TextEditingController();

  final descController = TextEditingController();

  final themeService = Get.find<ThemeService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notes",
          style: TextStyle(color: Colors.black,),
        ),
        backgroundColor: Colors.tealAccent,
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if(value=="theme"){
                themeService.toggleTheme();
                Get.snackbar("Alert", "Theme is changed.",barBlur: 20, colorText: Colors.black);
              }else if(value=="exit"){
                exitAlertDialogBox();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: "theme",
                  child: Row(children: [
                    const Text("Theme"),
                    const Expanded(child: SizedBox()),
                    Obx(() => Icon(themeService.isDarkTheme.value?Icons.dark_mode:Icons.light_mode))
                  ],)),
              const PopupMenuItem(
                  value: "exit",
                  child: Row(children: [
                    Text("Exit"),
                    Expanded(child: SizedBox()),
                    Icon(Icons.exit_to_app)
                  ],)),
          ],)
        ],
      ),
      body:RefreshIndicator(
        onRefresh: ()async {
          noteController.updateListNotes();
        },
        child: Obx(
            ()=> noteController.listOfNotes.isNotEmpty
              ? ListView.builder(
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => showBottomWidget(
                          context: context,
                          isEdit: true,
                          serialNo: noteController.listOfNotes[index].serialNo,
                          title: noteController.listOfNotes[index].title,
                          desc: noteController.listOfNotes[index].desc),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 10.r),
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.r, vertical: 10.r),
                        decoration: BoxDecoration(
                            color: Colors.lightBlueAccent.shade100,
                            borderRadius: BorderRadius.circular(12.r)),
                        child: Row(
                          children: [
                            Icon(
                              Icons.library_books_rounded,
                              color: Colors.yellow,
                              size: 40.r,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: 8.r, left: 8.r, right: 8.r),
                                    child: Text(noteController.listOfNotes[index].title??"",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17.sp),),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.r),
                                    child: Text(noteController.listOfNotes[index].desc??"",style: TextStyle(fontSize: 15.sp),textAlign: TextAlign.justify,),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      deleteAlertDialogBox(noteController.listOfNotes[index].serialNo!);
                                    },
                                    icon:const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    )),
                                IconButton(onPressed: ()async{
                                  SharePlus.instance.share(
                                      ShareParams(text: "This is my notes : Title: ${noteController.listOfNotes[index].title} Description: ${noteController.listOfNotes[index].desc}")
                                  );
                                }, icon: const Icon(Icons.share,color: Colors.black,))
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount: noteController.getNotesList().length,
                )
              : const Center(child: Text("No Notes yet")),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showBottomWidget(context: context, isEdit: false);
        },
        tooltip: 'Add Notes',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future showBottomWidget(
      {required BuildContext context,
      required bool isEdit,
      int? serialNo,
      String? title,
      String? desc}) {
    titleController.text = title ?? "";
    descController.text = desc ?? "";
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: 500.h,
          padding: EdgeInsets.all(10.r),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r)),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Note",
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    label: const Text("Title"),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(color: Colors.lightBlue, width: 2.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(color: Colors.purpleAccent, width: 2.r),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextField(
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  controller: descController,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    labelText: "Description",
                    alignLabelWithHint: true,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(color: Colors.lightBlue, width: 2.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      borderSide:
                          BorderSide(color: Colors.purpleAccent, width: 2.r),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: ElevatedButton(
                        onPressed: () async {
                          String? title = titleController.text;
                          String? desc = descController.text;
                          if (isEdit) {
                            bool isEdited = await noteController.editNotes(
                                mTitle: title,
                                mDesc: desc,
                                serialNo: serialNo!);
                            if (isEdited) {
                              Navigator.pop(context);
                            }
                          } else {
                            if (title.isNotEmpty && desc.isNotEmpty) {
                              bool isAdded = await noteController.addNote(
                                  mTitle: title, mDesc: desc);
                              if (isAdded) {
                                Navigator.pop(context);
                              }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "please add Title and Description");
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                            backgroundColor: Colors.green),
                        child: const Text(
                          "Save Note",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                            backgroundColor: Colors.green),
                        child:const Text(
                          "cancel",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void exitAlertDialogBox(){
    Get.dialog(
        AlertDialog(
          title: const Text("Alert !"),
          content: const Text("Are sure want exit from the app ?"),
          actions: [
            TextButton(onPressed: (){
              Get.back();
            }, child: const Text("No")),
            TextButton(onPressed: (){
              SystemNavigator.pop();
              Get.back();
            }, child: const Text("Yes"))
          ],
        )
    );
  }

  void deleteAlertDialogBox(int? serialNo){
    Get.dialog(
      AlertDialog(
        title: const Text("Alert !"),
        content: const Text("Are you sure want to delete note ?"),
        actions: [
          TextButton(onPressed: (){
            Get.back();
          }, child: const Text("No")),
          TextButton(onPressed: ()async{
            bool isDelete=await noteController.deleteNote(serialNo!);
            if(isDelete){
              Get.back();
            }
            }, child: const Text("Yes"))
        ],
      )
    );
  }
}
