import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('pt')
  ];

  /// No description provided for @appName.
  ///
  /// In pt, this message translates to:
  /// **'ShopTem'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In pt, this message translates to:
  /// **'Início'**
  String get home;

  /// No description provided for @purchased.
  ///
  /// In pt, this message translates to:
  /// **'Compras'**
  String get purchased;

  /// No description provided for @shopCart.
  ///
  /// In pt, this message translates to:
  /// **'Carrinho'**
  String get shopCart;

  /// No description provided for @settings.
  ///
  /// In pt, this message translates to:
  /// **'Ajustes'**
  String get settings;

  /// No description provided for @favorite.
  ///
  /// In pt, this message translates to:
  /// **'Favoritos'**
  String get favorite;

  /// No description provided for @favoriteDialog.
  ///
  /// In pt, this message translates to:
  /// **'Remover dos Favoritos'**
  String get favoriteDialog;

  /// No description provided for @noFav.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum item favorito.'**
  String get noFav;

  /// No description provided for @yes.
  ///
  /// In pt, this message translates to:
  /// **'Sim'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In pt, this message translates to:
  /// **'Não'**
  String get no;

  /// No description provided for @removedFav.
  ///
  /// In pt, this message translates to:
  /// **'Produto removido dos favoritos!'**
  String get removedFav;

  /// No description provided for @ok.
  ///
  /// In pt, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @noProduct.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum produto encontrado'**
  String get noProduct;

  /// No description provided for @human.
  ///
  /// In pt, this message translates to:
  /// **'Humano'**
  String get human;

  /// No description provided for @cancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In pt, this message translates to:
  /// **'Apagar'**
  String get delete;

  /// No description provided for @noConnection.
  ///
  /// In pt, this message translates to:
  /// **'Sem conexão com a Terra'**
  String get noConnection;

  /// No description provided for @noConnectionSub.
  ///
  /// In pt, this message translates to:
  /// **'Verifique se você realmente e um humano'**
  String get noConnectionSub;

  /// No description provided for @noResult.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum resultado encontrado'**
  String get noResult;

  /// No description provided for @about.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get about;

  /// No description provided for @copyright.
  ///
  /// In pt, this message translates to:
  /// **'Todos os direitos reservados'**
  String get copyright;

  /// No description provided for @appDesc.
  ///
  /// In pt, this message translates to:
  /// **'Sua Loja'**
  String get appDesc;

  /// No description provided for @version.
  ///
  /// In pt, this message translates to:
  /// **'Versão'**
  String get version;

  /// No description provided for @privacy.
  ///
  /// In pt, this message translates to:
  /// **'Política de Privacidade'**
  String get privacy;

  /// No description provided for @privacySub.
  ///
  /// In pt, this message translates to:
  /// **'Termos que garantem a sua privacidade'**
  String get privacySub;

  /// No description provided for @sourceCode.
  ///
  /// In pt, this message translates to:
  /// **'Código Fonte'**
  String get sourceCode;

  /// No description provided for @sourceCodeSub.
  ///
  /// In pt, this message translates to:
  /// **'Projeto disponível no GitHub'**
  String get sourceCodeSub;

  /// No description provided for @openSource.
  ///
  /// In pt, this message translates to:
  /// **'Licenças de Código Aberto'**
  String get openSource;

  /// No description provided for @openSourceSub.
  ///
  /// In pt, this message translates to:
  /// **'Softwares de terceiros usados na construção do app'**
  String get openSourceSub;

  /// No description provided for @theme.
  ///
  /// In pt, this message translates to:
  /// **'Tema'**
  String get theme;

  /// No description provided for @themeSub.
  ///
  /// In pt, this message translates to:
  /// **'Escolha o tema que mais combina com você'**
  String get themeSub;

  /// No description provided for @themeSelect.
  ///
  /// In pt, this message translates to:
  /// **'Escolha o Tema'**
  String get themeSelect;

  /// No description provided for @darkMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo Escuro'**
  String get darkMode;

  /// No description provided for @lightMode.
  ///
  /// In pt, this message translates to:
  /// **'Modo Claro'**
  String get lightMode;

  /// No description provided for @systemMode.
  ///
  /// In pt, this message translates to:
  /// **'Padrão do Sistema'**
  String get systemMode;

  /// No description provided for @update.
  ///
  /// In pt, this message translates to:
  /// **'Atualizações'**
  String get update;

  /// No description provided for @updateSub.
  ///
  /// In pt, this message translates to:
  /// **'Toque para buscar por novas versões do app'**
  String get updateSub;

  /// No description provided for @support.
  ///
  /// In pt, this message translates to:
  /// **'Suporte'**
  String get support;

  /// No description provided for @supportSub.
  ///
  /// In pt, this message translates to:
  /// **'Encontrou um bug ou deseja sugerir algo?'**
  String get supportSub;

  /// No description provided for @review.
  ///
  /// In pt, this message translates to:
  /// **'Avalie o App'**
  String get review;

  /// No description provided for @reviewSub.
  ///
  /// In pt, this message translates to:
  /// **'Faça uma avaliação na loja de apps'**
  String get reviewSub;

  /// No description provided for @aboutSub.
  ///
  /// In pt, this message translates to:
  /// **'Um pouco mais sobre o app'**
  String get aboutSub;

  /// No description provided for @searchFor.
  ///
  /// In pt, this message translates to:
  /// **'Procurar por...'**
  String get searchFor;

  /// No description provided for @newUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Nova versão disponível'**
  String get newUpdate;

  /// No description provided for @news.
  ///
  /// In pt, this message translates to:
  /// **'Novidades:'**
  String get news;

  /// No description provided for @after.
  ///
  /// In pt, this message translates to:
  /// **'DEPOIS'**
  String get after;

  /// No description provided for @download.
  ///
  /// In pt, this message translates to:
  /// **'BAIXAR'**
  String get download;

  /// No description provided for @noUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma atualização disponível'**
  String get noUpdate;

  /// No description provided for @noUpdateSub.
  ///
  /// In pt, this message translates to:
  /// **'Tudo em dias parceiro 🤠'**
  String get noUpdateSub;

  /// No description provided for @removedFavorite.
  ///
  /// In pt, this message translates to:
  /// **'Produto Removido'**
  String get removedFavorite;

  /// No description provided for @addFavorite.
  ///
  /// In pt, this message translates to:
  /// **'Produto Salvo'**
  String get addFavorite;

  /// No description provided for @top.
  ///
  /// In pt, this message translates to:
  /// **'Destaque'**
  String get top;

  /// No description provided for @homeLogin.
  ///
  /// In pt, this message translates to:
  /// **'Bem vindo ao nosso app, aproveite'**
  String get homeLogin;

  /// No description provided for @googleLogin.
  ///
  /// In pt, this message translates to:
  /// **'Entrar com Google'**
  String get googleLogin;

  /// No description provided for @desconect.
  ///
  /// In pt, this message translates to:
  /// **'Desconectar'**
  String get desconect;

  /// No description provided for @alreadyReviewed.
  ///
  /// In pt, this message translates to:
  /// **'Você já avaliou o app'**
  String get alreadyReviewed;

  /// No description provided for @save.
  ///
  /// In pt, this message translates to:
  /// **'Salvar'**
  String get save;

  /// No description provided for @cpf.
  ///
  /// In pt, this message translates to:
  /// **'CPF'**
  String get cpf;

  /// No description provided for @cpfYou.
  ///
  /// In pt, this message translates to:
  /// **'Seu CPF'**
  String get cpfYou;

  /// No description provided for @email.
  ///
  /// In pt, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @emailYou.
  ///
  /// In pt, this message translates to:
  /// **'Seu Email'**
  String get emailYou;

  /// No description provided for @name.
  ///
  /// In pt, this message translates to:
  /// **'Nome'**
  String get name;

  /// No description provided for @nameYou.
  ///
  /// In pt, this message translates to:
  /// **'Seu Nome'**
  String get nameYou;

  /// No description provided for @address.
  ///
  /// In pt, this message translates to:
  /// **'Endereço'**
  String get address;

  /// No description provided for @addressYou.
  ///
  /// In pt, this message translates to:
  /// **'Seu Endereço'**
  String get addressYou;

  /// No description provided for @edit.
  ///
  /// In pt, this message translates to:
  /// **'Editar Informações'**
  String get edit;

  /// No description provided for @accontYou.
  ///
  /// In pt, this message translates to:
  /// **'Gerenciar Conta'**
  String get accontYou;

  /// No description provided for @outOfStock.
  ///
  /// In pt, this message translates to:
  /// **'Esgotado'**
  String get outOfStock;

  /// No description provided for @removeFavProduct.
  ///
  /// In pt, this message translates to:
  /// **'Produto removido dos favoritos!'**
  String get removeFavProduct;

  /// No description provided for @addFavProduct.
  ///
  /// In pt, this message translates to:
  /// **'Produto adicionado aos favoritos!'**
  String get addFavProduct;

  /// No description provided for @outOfStockSub.
  ///
  /// In pt, this message translates to:
  /// **'Produto fora de estoque'**
  String get outOfStockSub;

  /// No description provided for @addCartSub.
  ///
  /// In pt, this message translates to:
  /// **'Selecione a cor e o tamanho antes de adicionar ao carrinho!'**
  String get addCartSub;

  /// No description provided for @addCart.
  ///
  /// In pt, this message translates to:
  /// **'Produto adicionado ao carrinho!'**
  String get addCart;

  /// No description provided for @cart.
  ///
  /// In pt, this message translates to:
  /// **'Carrinho de Compras'**
  String get cart;

  /// No description provided for @noProductCart.
  ///
  /// In pt, this message translates to:
  /// **'Seu carrinho está vazio'**
  String get noProductCart;

  /// No description provided for @buy.
  ///
  /// In pt, this message translates to:
  /// **'COMPRAR AGORA'**
  String get buy;

  /// No description provided for @buyOrders.
  ///
  /// In pt, this message translates to:
  /// **'Finalizar Pedido'**
  String get buyOrders;

  /// No description provided for @buyOrderSub.
  ///
  /// In pt, this message translates to:
  /// **'Finalizar'**
  String get buyOrderSub;

  /// No description provided for @detailsProduct.
  ///
  /// In pt, this message translates to:
  /// **'Detalhes do Pedido'**
  String get detailsProduct;

  /// No description provided for @myOrders.
  ///
  /// In pt, this message translates to:
  /// **'Minhas Compras'**
  String get myOrders;

  /// No description provided for @errorOrders.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar pedidos.'**
  String get errorOrders;

  /// No description provided for @noOrders.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma compra realizada ainda'**
  String get noOrders;

  /// No description provided for @errorUpdate.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível verificar atualizações.'**
  String get errorUpdate;

  /// No description provided for @error.
  ///
  /// In pt, this message translates to:
  /// **'Erro'**
  String get error;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
