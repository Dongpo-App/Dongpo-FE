import 'package:dongpo_test/main.dart';
import 'package:dongpo_test/screens/login/social_login.dart';
import 'package:flutter/services.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'login_platform.dart';

class AppleKakaoNaverLogin implements SocialLogin {
  @override
  Future<String?> isKakaoLogin() async {
    try {
      // 카카오톡 실행 가능 여부 확인
      bool isInstalled = await isKakaoTalkInstalled();
      if (isInstalled) {
        try {
          // 카카오톡으로 로그인
          final oauthToken = await UserApi.instance.loginWithKakaoTalk();
          logger.d(
              "kakaoTalk login accessToken : ${oauthToken.accessToken.toString()}");
          return oauthToken.accessToken.toString();
        } catch (e) {
          logger.d("kakaoTalk login errer : $e");
          if (e is PlatformException && e.code == "CANCELED") {
            logger.d("e : $e");
            return null;
          }
          try {
            final kakaoToken = await UserApi.instance.loginWithKakaoAccount();
            logger.d(
                "kakaoAccount login accessToken : ${kakaoToken.accessToken}");
            return kakaoToken.accessToken.toString();
          } catch (e) {
            logger.d("e : $e");
            return null;
          }
        }
      } else {
        try {
          // 카카오톡 어플이 없는 경우 -> 카카오 계정으로 로그인 유도
          final kakaoToken = await UserApi.instance.loginWithKakaoAccount();
          logger
              .d("kakaoAccount login accessToken : ${kakaoToken.accessToken}");
          return kakaoToken.accessToken.toString();
        } catch (e) {
          logger.d("e : $e");
          return null;
        }
      }
    } catch (e) {
      logger.d("e : $e");
      return null;
    }
  }

  @override
  Future<String?> isNaverLogin() async {
    try {
      // 네이버 로그인 시도
      NaverLoginResult result = await FlutterNaverLogin.logIn();
      logger.d("naver login 결과 ${result.toString()}");
      NaverAccessToken token = await FlutterNaverLogin.currentAccessToken;
      logger.d("naver login accessToken : ${token.accessToken}");
      return token.accessToken.toString();
    } catch (e) {
      logger.d("naver login error : $e");
      return null;
    }
  }

  @override
  Future<Map<String, String>?> isAppleLogin() async {
    try {
      logger.d('애플로그인 요청 시작');
      // 애플 로그인 요청
      final AuthorizationCredentialAppleID appleCredential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      logger.d('애플로그인 완료');

      // 애플 로그인 성공 후, 받은 credential을 사용하여 필요한 처리 수행
      logger.d("Apple login userIdentifier: ${appleCredential.userIdentifier}");
      logger.d("Apple login identityToken: ${appleCredential.identityToken}");
      logger.d(
          "Apple login authorizationCode: ${appleCredential.authorizationCode}");

      // 받은 identityToken(토큰)을 서버로 보내어 검증하거나, 인증된 로그인 처리를 수행
      String? identityToken = appleCredential.identityToken;
      String? authorizationCode = appleCredential.authorizationCode;

      if (identityToken != null && authorizationCode != null) {
        return {
          "identityToken": identityToken,
          "authorizationCode": authorizationCode,
        };
      } else {
        logger.d("Apple login failed: No identity token");
        return null;
      }
    } catch (e) {
      logger.d("Apple login error: $e");
      return null;
    }
  }

  @override
  Future<bool> isLogout(LoginPlatform loginPlatform) async {
    switch (loginPlatform) {
      case LoginPlatform.kakao:
        try {
          // logout 실행 코드. SDK에서 토큰 삭제
          await UserApi.instance.unlink();
          logger.d("$loginPlatform : logout");
          return true;
        } catch (e) {
          logger.d("kakao logout error : $e");
          return false;
        }
      case LoginPlatform.naver:
        try {
          // logout 실행 코드. SDK에서 토큰 삭제
          await FlutterNaverLogin.logOut();
          logger.d("$loginPlatform : logout");
          return true;
        } catch (e) {
          logger.d("naver logout error : $e");
          return false;
        }
      case LoginPlatform.apple:
        try {
          // logout 실행 코드.
          // Apple은 logout이 없다.
          logger.d("$loginPlatform : logout");
          return true;
        } catch (e) {
          logger.d("apple logout error : $e");
          return false;
        }
      case LoginPlatform.none:
        logger.d("login Platform none!");
        return true;
    }
  }
}
