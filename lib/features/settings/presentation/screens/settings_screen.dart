import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:tv_app/core/dependencies/dependencies.dart';
import 'package:tv_app/core/design_system/theme/colors.dart';
import 'package:tv_app/core/design_system/widgets/fields/text_field_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/error_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/indicators/loading_indicator_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/bottom_app_bar_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_header_widget.dart';
import 'package:tv_app/core/design_system/widgets/layouts/main_scaffold_widget.dart';
import 'package:tv_app/core/design_system/widgets/texts/header_text_widget.dart';
import 'package:tv_app/core/navigation/services/dialogs_service.dart';
import 'package:tv_app/features/settings/domain/enums/auth_method_type_enum.dart';
import 'package:tv_app/features/settings/presentation/widgets/auth_method_selector_widget.dart';
import 'package:tv_app/features/settings/state/auth_method/auth_method_cubit.dart';
import 'package:tv_app/features/settings/state/auth_method/auth_method_state.dart';
import 'package:tv_app/features/settings/state/update_auth_method/update_auth_method_cubit.dart';
import 'package:tv_app/features/settings/state/update_auth_method/update_auth_method_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _pinController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _hasDeviceAuthentication = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _hasDeviceAuthentication =
          await getIt<LocalAuthentication>().isDeviceSupported();
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UIMainScaffold(
      canPop: false,
      mainHeader: const UIMainHeader(
        height: 134,
        child: UIHeaderText(
          'Settings',
          fontSize: 32,
        ),
      ),
      body: Form(
        key: _formKey,
        child: BlocBuilder<AuthMethodCubit, AuthMethodState>(
          builder: (
            BuildContext context,
            AuthMethodState state,
          ) {
            if (state is AuthMethodLoadedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _pinController.text = state.authPin ?? '';
              });

              return ListView(
                padding: const EdgeInsets.only(
                  top: 156,
                  left: 20,
                  right: 20,
                  bottom: 100,
                ),
                physics: const BouncingScrollPhysics(),
                children: [
                  AuthMethodCardSelector(
                    title: 'Enable Pin Authentication',
                    text: 'Authenticate with a pin number.',
                    isSelected:
                        state.authMethodTypes.contains(AuthMethodType.pin),
                    onSelected: () {
                      if (!state.authMethodTypes.contains(AuthMethodType.pin)) {
                        if (_formKey.currentState?.validate() ?? false) {
                          _updateAuthMethod(
                            authMethodTypes: [
                              AuthMethodType.pin,
                              ...state.authMethodTypes,
                            ],
                          );
                        }
                      } else {
                        _updateAuthMethod(
                          authMethodTypes: state.authMethodTypes
                              .where((e) => e != AuthMethodType.pin)
                              .toList(),
                        );
                      }
                    },
                    content: Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: UITextField(
                        controller: _pinController,
                        label: 'PIN (4 Digits)',
                        isRequired: true,
                        minLenght: 4,
                        maxLength: 4,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        primaryColor: AppColors.purple,
                      ),
                    ),
                  ),
                  if (_hasDeviceAuthentication &&
                      state.authMethodTypes.contains(AuthMethodType.pin)) ...[
                    const SizedBox(height: 12),
                    AuthMethodCardSelector(
                      title: 'Enable Device Authentication',
                        text:
                            'Authenticate with your device biometrics authentication.',
                        isSelected: state.authMethodTypes
                            .contains(AuthMethodType.device),
                        onSelected: () {
                          if (!state.authMethodTypes
                              .contains(AuthMethodType.device)) {
                            _updateAuthMethod(
                              authMethodTypes: [
                                AuthMethodType.device,
                                ...state.authMethodTypes,
                              ],
                            );
                          } else {
                            _updateAuthMethod(
                              authMethodTypes: state.authMethodTypes
                                  .where((e) => e != AuthMethodType.device)
                                  .toList(),
                            );
                          }
                        }),
                  ],
                ],
              );
            }
            if (state is AuthMethodErrorState) {
              return Center(
                child: UIErrorIndicator(
                  errorText: 'Failed to load auth methods.',
                  onPressed: context.read<AuthMethodCubit>().getAuthMethod,
                  color: AppColors.purple,
                ),
              );
            }
            return const Center(
              child: UILoadingIndicator(
                color: AppColors.purple,
              ),
            );
          },
        ),
      ),
      bottomAppBar: const UIBottomAppBar(
        currentTab: TabType.settings,
      ),
    );
  }

  Future<void> _updateAuthMethod({
    required List<AuthMethodType> authMethodTypes,
  }) async {
    if (!authMethodTypes.contains(AuthMethodType.pin)) {
      _pinController.clear();
    }
    UpdateAuthMethodState updateAuthMethodState =
        await context.read<UpdateAuthMethodCubit>().updateAuthMethod(
              authMethodTypes: authMethodTypes,
              authPin: _pinController.text.isEmpty ? null : _pinController.text,
            );

    if (updateAuthMethodState is UpdateAuthMethodErrorState) {
      getIt<AppDialogsService>().showErrorDialog(
        text: 'Failed to update authentication method.',
      );
    }
  }
}