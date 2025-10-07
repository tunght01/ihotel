import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ihostel/app/app.dart';
import 'package:ihostel/app/data/models/ez_user/ez_user.dart';
import 'package:ihostel/assets_gen/assets.gen.dart';
import 'package:ihostel/feature/link_account/link_account.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:scan/scan.dart';

class LinkAccountPage extends StatefulWidget {
  const LinkAccountPage({super.key});

  static const routeName = 'link_account';

  @override
  State<LinkAccountPage> createState() => _LinkAccountPageState();
}

class _LinkAccountPageState extends BasePageState<LinkAccountPage, LinkAccountCubit> with WidgetsBindingObserver {
  final GlobalKey _qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? _qrController;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _checkPermissionCamera(context);
    super.initState();
  }

  @override
  void dispose() {
    _qrController?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        _qrController?.pauseCamera();
      case AppLifecycleState.resumed:
        _checkPermissionCamera(null, false);
        _qrController?.resumeCamera();
      case _:
    }
  }

  Future<void> _checkPermissionCamera([BuildContext? context, bool request = true]) async {
    final result = await QrScannerHelper.requestPermissionCamera(context, request);
    bloc.onHasScannerQr(result);
  }

  @override
  Widget buildPage(BuildContext context, AppState appState) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: EzAppBar(
        title: const Text('Liên kết tài khoản'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.share_outlined, size: 24),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(bottom: Dimens.paddingSafeArea),
        margin: const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyScaffold),
        child: EzButton.primaryFilled(
          title: 'Cấp quyền truy cập',
          isEnabled: true,
          onPressed: () => context.pop(
            EzUser(
              id: '0DjmqvCiNCUUXfIEssQ5bXfPstg2',
              firstName: 'Thảo Nhi',
              phone: '5151515789',
            ),
          ),
        ),
      ),
      body: BlocBuilder<LinkAccountCubit, LinkAccountState>(
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.paddingBodyScaffold),
                sliver: SliverList.list(
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 300,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Visibility(
                            visible: state.hasScannerQr,
                            child: QRView(
                              key: _qrKey,
                              onQRViewCreated: _onQRViewCreated,
                              onPermissionSet: (ctrl, p) {
                                if (!p) {
                                  ctrl
                                    ..pauseCamera()
                                    ..stopCamera()
                                    ..dispose();
                                }
                              },
                              overlay: QrScannerOverlayShape(
                                cutOutSize: size.width * 0.4,
                                borderColor: AppColors.current.background,
                                borderLength: 20,
                                borderRadius: 6,
                                borderWidth: 6,
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !state.hasScannerQr,
                            child: Container(
                              height: 300,
                              width: size.width,
                              color: Colors.black,
                              child: Center(
                                child: EzRippleEffect(
                                  borderRadius: BorderRadius.circular(5),
                                  onPressed: () => _checkPermissionCamera(context),
                                  child: Text(
                                    'Quyền sử dụng camera đã bị từ chối.\n'
                                    'Cấp lại quyền tại đây.',
                                    textAlign: TextAlign.center,
                                    style: EzTextStyles.s11.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: false,
                            child: Positioned(
                              top: 15,
                              child: InkWell(
                                onTap: () => {
                                  _qrController?.resumeCamera(),
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    'Thử lại',
                                    textAlign: TextAlign.center,
                                    style: EzTextStyles.s11.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 15,
                            child: InkWell(
                              onTap: _pickImageFromGallery,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Assets.images.icGallery.svg(width: 15, height: 15),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Chọn mã QR từ thư viện',
                                      textAlign: TextAlign.center,
                                      style: EzTextStyles.s11.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Dimens.d15.verticalSpace,
                    EzTextField(
                      title: 'Tên',
                      hint: 'Nhập tên',
                    ),
                    Dimens.d15.verticalSpace,
                    EzTextField(
                      title: 'Email',
                      hint: 'Email',
                      value: state.result.$1,
                    ),
                    Dimens.d15.verticalSpace,
                    EzTextField(
                      title: 'Mã người dùng Ihostel',
                      hint: 'Mã người dùng',
                      value: state.result.$2,
                    ),
                    Dimens.d15.verticalSpace,
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _onQRViewCreated(QRViewController controller) async {
    _qrController = controller;
    controller.scannedDataStream.listen((scanData) async {
      try {
        await _qrController?.pauseCamera();
        final text = scanData.code ?? '';
        await bloc.updateResult(text);
      } catch (e) {
        if (mounted) {}
      }
    });
  }

  Future<void> _pickImageFromGallery() async {
    final image = await _pickImage();
    if (image != null && mounted) {
      try {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: image.path,
          maxWidth: 400,
          maxHeight: 400,
          uiSettings: [
            AndroidUiSettings(
              activeControlsWidgetColor: Theme.of(context).colorScheme.primary,
              toolbarTitle: '',
              toolbarColor: AppColors.current.background,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.square,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            ),
            IOSUiSettings(
              title: '',
              rectWidth: 4000,
              rectHeight: 4000,
              rectX: MediaQuery.of(context).size.width / 2,
              rectY: MediaQuery.of(context).size.width / 2,
              aspectRatioLockEnabled: true,
              resetButtonHidden: true,
              aspectRatioPresets: [
                CropAspectRatioPreset.square,
              ],
            ),
          ],
        );

        if (croppedFile != null) {
          var isScanCode = true;
          final text = await Scan.parse(croppedFile.path) ?? '';
          if (text.isNotEmpty && text.contains('/')) {
            if (mounted && isScanCode) {
              try {
                await bloc.updateResult(text);
              } catch (_) {}
              isScanCode = false;
            }
          } else {
            isScanCode = true;
          }
        }
      } catch (_) {}
    }
  }

  Future<XFile?> _pickImage() async {
    try {
      final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      return imageFile;
    } catch (_) {
      if (mounted) {
        await showAlert(
          context,
          content: 'Bạn chưa cung cấp quyền để mở thư viện ảnh. Vui lòng đi đến cài đặt để thêm quyền.',
          title: 'Cảnh báo',
          actions: ['Đến cài đặt', 'Hủy'],
          onActionButtonTapped: (index) {
            if (index == 0) {
              openAppSettings();
            }
          },
        );
      }
      return null;
    }
  }
}
