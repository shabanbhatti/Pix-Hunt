import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pix_hunt_project/Controllers/auth%20riverpod/auth_riverpod.dart';
import 'package:pix_hunt_project/Controllers/cloud%20db%20Riverpod/user_db_riverpod.dart';
import 'package:pix_hunt_project/Pages/update%20email%20page/Widgets/row_textfield_widget.dart';
import 'package:pix_hunt_project/Utils/custom_snack_bar.dart';
import 'package:pix_hunt_project/Widgets/custom_app_bar.dart';

class UpdateNamePage extends ConsumerStatefulWidget {
  const UpdateNamePage({super.key});
  static const pageName = '/update_name';

  @override
  ConsumerState<UpdateNamePage> createState() => _UpdateNamePageState();
}

class _UpdateNamePageState extends ConsumerState<UpdateNamePage> {
  TextEditingController nameController = TextEditingController();

  GlobalKey<FormState> nameKey = GlobalKey<FormState>();

@override
  void initState() {
    super.initState();
    getName();
  }

  void getName()async{

WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  var userDb= ref.watch(userDbProvider);

if (userDb is LoadedSuccessfulyUserDb) {
  var name= userDb.auth.name??'';
  nameController.text=name;
}

},);
  }


  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('UPDATE name BUILD CALLED');
ref.listen(authProvider('update_name'), (previous, next) {
  if (next is AuthLoadedSuccessfuly) {
    snackbar(context, 'Name updated successfully');
    Navigator.pop(context);
  }
},);
    return Scaffold(
      appBar: customAppBar('Update name'),
      body: SafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              RowTextfieldWidget(
                controller: nameController,
                title: 'name',

                formKey: nameKey,
                isObscure: false,
              ),

              Padding(
                padding: EdgeInsets.only(top: 50),
                child: _updateButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _updateButton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        var mqSize = Size(constraints.maxWidth, constraints.maxHeight);
        return SizedBox(
          width: mqSize.width * 0.87,
          child: Consumer(
            builder: (context, ref, child) {
              var myRef = ref.watch(authProvider('update_name'));
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: ()async {
                  
                  var nameValidate = nameKey.currentState!.validate();

                  if (nameValidate) {
                  await  ref
                        .read(authProvider('update_name').notifier)
                        .updateName(nameController.text);
                        await ref.read(userDbProvider.notifier).fetchUserDbData();
                  }
                },
                child:
                    (myRef is AuthLoading)
                        ? CupertinoActivityIndicator(color: Colors.white)
                        : Text('Update', style: TextStyle(color: Colors.white)),
              );
            },
          ),
        );
      },
    );
  }
}
