import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth_platform_interface/src/method_channel/method_channel_firebase_auth.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:mockito/mockito.dart';

import '../mock.dart';

Map<String, dynamic> kMockUser1 = <String, dynamic>{
  'isAnonymous': true,
  'emailVerified': false,
  'displayName': 'displayName',
};
void main() {
  setupFirebaseAuthMocks();

  FirebaseAuth? auth;

  const Map<String, dynamic> kMockIdTokenResult = <String, dynamic>{
    'token': '12345',
    'expirationTimestamp': 123456,
    'authTimestamp': 1234567,
    'issuedAtTimestamp': 12345678,
    'signInProvider': 'password',
    'claims': <dynamic, dynamic>{
      'claim1': 'value1',
    },
  };

  final int kMockCreationTimestamp =
      DateTime.now().subtract(const Duration(days: 2)).millisecondsSinceEpoch;
  final int kMockLastSignInTimestamp =
      DateTime.now().subtract(const Duration(days: 1)).millisecondsSinceEpoch;

  Map<String, dynamic> kMockUser = <String, dynamic>{
    'isAnonymous': true,
    'emailVerified': false,
    'uid': '42',
    'displayName': 'displayName',
    'metadata': <String, int>{
      'creationTime': kMockCreationTimestamp,
      'lastSignInTime': kMockLastSignInTimestamp,
    },
    'providerData': <Map<String, String>>[
      <String, String>{
        'providerId': 'firebase',
        'uid': '12345',
        'displayName': 'Flutter Test User',
        'photoURL': 'http://www.example.com/',
        'email': 'test@example.com',
      },
    ],
  };

  MockUserPlatform? mockUserPlatform;
  MockUserCredentialPlatform? mockUserCredPlatform;

  AdditionalUserInfo mockAdditionalInfo = AdditionalUserInfo(
    isNewUser: false,
    username: 'flutterUser',
    providerId: 'testProvider',
    profile: <String, dynamic>{'foo': 'bar'},
  );

  EmailAuthCredential mockCredential =
      EmailAuthProvider.credential(email: 'test', password: 'test')
          as EmailAuthCredential;

  var mockAuthPlatform = MockFirebaseAuth();

  group('$User', () {
    Map<String, dynamic>? user;
    var testCount = 0;

    setUp(() async {
      FirebaseAuthPlatform.instance = mockAuthPlatform = MockFirebaseAuth();

      final app = await Firebase.initializeApp(
        name: '$testCount',
        options: const FirebaseOptions(
          apiKey: '',
          appId: '',
          messagingSenderId: '',
          projectId: '',
        ),
      );

      auth = FirebaseAuth.instanceFor(app: app);

      user = kMockUser;

      mockUserPlatform = MockUserPlatform(mockAuthPlatform, user!);

      mockUserCredPlatform = MockUserCredentialPlatform(
        FirebaseAuthPlatform.instance,
        mockAdditionalInfo,
        mockCredential,
        mockUserPlatform!,
      );

      when(mockAuthPlatform.signInAnonymously()).thenAnswer(
          (_) => Future<UserCredentialPlatform>.value(mockUserCredPlatform));

      when(mockAuthPlatform.currentUser).thenReturn(mockUserPlatform);

      when(mockAuthPlatform.delegateFor(
        app: anyNamed('app'),
      )).thenAnswer((_) => mockAuthPlatform);

      when(mockAuthPlatform.setInitialValues(
        currentUser: anyNamed('currentUser'),
        languageCode: anyNamed('languageCode'),
      )).thenAnswer((_) => mockAuthPlatform);

      MethodChannelFirebaseAuth.channel.setMockMethodCallHandler((call) async {
        switch (call.method) {
          default:
            return <String, dynamic>{'user': user};
        }
      });
    });

    tearDown(() => testCount++);

    setUp(() async {
      user = kMockUser;
      await auth!.signInAnonymously();
    });

    test('delete()', () async {
      when(mockUserPlatform!.delete()).thenAnswer((i) async {});

      await auth!.currentUser!.delete();

      verify(mockUserPlatform!.delete());
    });

    test('getIdToken()', () async {
      when(mockUserPlatform!.getIdToken(any)).thenAnswer((_) async => 'token');

      final token = await auth!.currentUser!.getIdToken(true);

      verify(mockUserPlatform!.getIdToken(true));
      expect(token, isA<String>());
    });

    test('getIdTokenResult()', () async {
      when(mockUserPlatform!.getIdTokenResult(any))
          .thenAnswer((_) async => IdTokenResult(kMockIdTokenResult));

      final idTokenResult = await auth!.currentUser!.getIdTokenResult(true);

      verify(mockUserPlatform!.getIdTokenResult(true));
      expect(idTokenResult, isA<IdTokenResult>());
    });

    test('sendEmailVerification()', () async {
      when(mockUserPlatform!.sendEmailVerification(any))
          .thenAnswer((i) async {});

      final ActionCodeSettings actionCodeSettings =
          ActionCodeSettings(url: 'test');

      await auth!.currentUser!.sendEmailVerification(actionCodeSettings);

      verify(mockUserPlatform!.sendEmailVerification(actionCodeSettings));
    });

    group('updatePassword()', () {
      test('should call updatePassword()', () async {
        when(mockUserPlatform!.updatePassword(any)).thenAnswer((i) async {});

        const String newPassword = 'newPassword';

        await auth!.currentUser!.updatePassword(newPassword);

        verify(mockUserPlatform!.updatePassword(newPassword));
      });
    });
  });
}

class MockFirebaseAuthPlatformBase = TestFirebaseAuthPlatform
    with MockPlatformInterfaceMixin;

class MockUserPlatformBase = TestUserPlatform with MockPlatformInterfaceMixin;

class MockFirebaseAuth extends Mock
    with MockPlatformInterfaceMixin
    implements TestFirebaseAuthPlatform {
  @override
  Future<UserCredentialPlatform> signInAnonymously() {
    return super.noSuchMethod(
      Invocation.method(#signInAnonymously, const []),
      returnValue: neverEndingFuture<UserCredentialPlatform>(),
      returnValueForMissingStub: neverEndingFuture<UserCredentialPlatform>(),
    );
  }

  @override
  FirebaseAuthPlatform delegateFor({FirebaseApp? app}) {
    return super.noSuchMethod(
      Invocation.method(#delegateFor, const [], {#app: app}),
      returnValue: TestFirebaseAuthPlatform(),
      returnValueForMissingStub: TestFirebaseAuthPlatform(),
    );
  }

  @override
  FirebaseAuthPlatform setInitialValues({
    Map<String, dynamic>? currentUser,
    String? languageCode,
  }) {
    return super.noSuchMethod(
      Invocation.method(#setInitialValues, const [], {
        #currentUser: currentUser,
        #languageCode: languageCode,
      }),
      returnValue: TestFirebaseAuthPlatform(),
      returnValueForMissingStub: TestFirebaseAuthPlatform(),
    );
  }
}

class MockUserPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TestUserPlatform {
  MockUserPlatform(FirebaseAuthPlatform auth, Map<String, dynamic> _user) {
    TestUserPlatform(auth, _user);
  }

  @override
  @override
  @override
  Future<String> getIdToken(bool? forceRefresh) {
    return super.noSuchMethod(
      Invocation.method(#getIdToken, [forceRefresh]),
      returnValue: neverEndingFuture<String>(),
      returnValueForMissingStub: neverEndingFuture<String>(),
    );
  }

  @override
  Future<UserPlatform> unlink(String? providerId) {
    return super.noSuchMethod(
      Invocation.method(#unlink, [providerId]),
      returnValue: neverEndingFuture<UserPlatform>(),
      returnValueForMissingStub: neverEndingFuture<UserPlatform>(),
    );
  }

  @override
  Future<IdTokenResult> getIdTokenResult(bool? forceRefresh) {
    return super.noSuchMethod(
      Invocation.method(#getIdTokenResult, [forceRefresh]),
      returnValue: neverEndingFuture<IdTokenResult>(),
      returnValueForMissingStub: neverEndingFuture<IdTokenResult>(),
    );
  }

  @override
  Future<UserCredentialPlatform> reauthenticateWithCredential(
    AuthCredential? credential,
  ) {
    return super.noSuchMethod(
      Invocation.method(#reauthenticateWithCredential, [credential]),
      returnValue: neverEndingFuture<UserCredentialPlatform>(),
      returnValueForMissingStub: neverEndingFuture<UserCredentialPlatform>(),
    );
  }

  @override
  Future<void> sendEmailVerification(ActionCodeSettings? actionCodeSettings) {
    return super.noSuchMethod(
      Invocation.method(#sendEmailVerification, [actionCodeSettings]),
      returnValue: neverEndingFuture<void>(),
      returnValueForMissingStub: neverEndingFuture<void>(),
    );
  }

  @override
  Future<void> updateEmail(String? newEmail) {
    return super.noSuchMethod(
      Invocation.method(#updateEmail, [newEmail]),
      returnValue: neverEndingFuture<void>(),
      returnValueForMissingStub: neverEndingFuture<void>(),
    );
  }

  @override
  Future<void> updatePassword(String? newPassword) {
    return super.noSuchMethod(
      Invocation.method(#updatePassword, [newPassword]),
      returnValue: neverEndingFuture<void>(),
      returnValueForMissingStub: neverEndingFuture<void>(),
    );
  }

  @override
  Future<void> verifyBeforeUpdateEmail(
    String? newEmail, [
    ActionCodeSettings? actionCodeSettings,
  ]) {
    return super.noSuchMethod(
      Invocation.method(#verifyBeforeUpdateEmail, [
        newEmail,
        actionCodeSettings,
      ]),
      returnValue: neverEndingFuture<void>(),
      returnValueForMissingStub: neverEndingFuture<void>(),
    );
  }
}

class MockUserCredentialPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements TestUserCredentialPlatform {
  MockUserCredentialPlatform(
    FirebaseAuthPlatform auth,
    AdditionalUserInfo additionalUserInfo,
    AuthCredential credential,
    UserPlatform userPlatform,
  ) {
    TestUserCredentialPlatform(
      auth,
      additionalUserInfo,
      credential,
      userPlatform,
    );
  }
}

class TestFirebaseAuthPlatform extends FirebaseAuthPlatform {
  TestFirebaseAuthPlatform() : super();

  @override
  FirebaseAuthPlatform delegateFor({FirebaseApp? app}) => this;

  @override
  FirebaseAuthPlatform setInitialValues({
    Map<String, dynamic>? currentUser,
    String? languageCode,
  }) {
    return this;
  }
}

class TestUserPlatform extends UserPlatform {
  TestUserPlatform(FirebaseAuthPlatform auth, Map<String, dynamic> data)
      : super(auth, data);
}

class TestUserCredentialPlatform extends UserCredentialPlatform {
  TestUserCredentialPlatform(
    FirebaseAuthPlatform auth,
    AdditionalUserInfo additionalUserInfo,
    AuthCredential credential,
    UserPlatform userPlatform,
  ) : super(
            auth: auth,
            additionalUserInfo: additionalUserInfo,
            credential: credential,
            user: userPlatform);
}
