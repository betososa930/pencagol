# 🔐 Guía de Configuración Multi-Provider Authentication - PencaGol

Tu app ahora soporta autenticación con **Google**, **Apple ID** y **Meta (Facebook)**. A continuación se detalla cómo completar la configuración en cada plataforma.

---

## 🌐 GOOGLE SIGN-IN (Ya configurado)

La autenticación con Google ya está funcionando gracias a tu configuración Firebase existente.

---

## 🍎 APPLE SIGN-IN (iOS)

### Requisitos:
- Xcode 13.0 o superior
- Apple Developer Account
- App registrada en Apple Developer Portal

### Pasos de configuración:

#### 1. Abrir Xcode y configurar capacidades:
```bash
open ios/Runner.xcworkspace
```

#### 2. En Xcode:
- Selecciona **Runner** en el Project Navigator
- Ve a **Signing & Capabilities**
- Haz clic en **+ Capability**
- Busca y agrega **Sign in with Apple**
- Asegúrate de que está habilitado para el target **Runner**

#### 3. Configuración automática en Info.plist (✅ YA HECHA):
- Se agregó la configuración de URLs y esquemas necesarios

---

## 📱 FACEBOOK SIGN-IN (iOS + Android)

### Requisitos:
- Meta Developer Account (https://developers.facebook.com)
- App registrada en Meta Apps Dashboard

### Pasos iOS:

#### 1. Abre Xcode:
```bash
open ios/Runner.xcworkspace
```

#### 2. En Xcode:
- Selecciona **Runner** en el Project Navigator
- Ve a **Signing & Capabilities**
- Haz clic en **+ Capability**
- Busca y agrega **Sign in with Apple** (necesario para Meta también)

#### 3. Configura el App ID de Facebook:
- En `ios/Runner/Info.plist` se han agregado las siguientes claves:
  - `FacebookAppID`: Tu Facebook App ID
  - `FacebookDisplayName`: "Penca Gol"
  - URLs configuradas para Facebook

**⚠️ IMPORTANTE:** Reemplaza `FacebookAppID` y `FacebookClientToken` con tus valores reales de Facebook

#### 4. Actualiza ios/Runner/Info.plist manualmente si es necesario:
```xml
<key>FacebookAppID</key>
<string>TU_FACEBOOK_APP_ID</string>
```

### Pasos Android:

#### 1. Obtén tu Facebook App ID y Client Token:
- Ve a https://developers.facebook.com/apps/
- Crea una nueva app o usa una existente
- En **Settings > Basic**, copia tu App ID

#### 2. Actualiza `android/app/src/main/res/values/strings.xml` (✅ PARCIALMENTE HECHA):

Reemplaza los placeholders con tus valores reales:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">Penca Gol</string>
    <!-- Replace with your Facebook App ID -->
    <string name="facebook_app_id">TU_FACEBOOK_APP_ID</string>
    <!-- Replace with your Facebook Client Token -->
    <string name="facebook_client_token">TU_FACEBOOK_CLIENT_TOKEN</string>
    <!-- Facebook Login Scheme -->
    <string name="fb_login_protocol_scheme">fbTU_FACEBOOK_APP_ID</string>
</resources>
```

#### 3. Obtén el hash de clave (Key Hash) para Android:
```bash
# Windows (PowerShell)
$JAVA_HOME = "C:\Program Files\Java\jdk-11.0.0"  # Ajusta a tu ruta
$cert_path = "$env:USERPROFILE\.android\debug.keystore"
keytool -exportcert -alias androiddebugkey -keystore $cert_path -storepass android -keypass android | openssl dgst -sha1 -binary | openssl enc -base64

# O usa esta alternativa:
cd C:\Repos\PencaGol\android
./gradlew signingReport
```

#### 4. Registra el Key Hash en Meta:
- Ve a https://developers.facebook.com/apps/
- Selecciona tu app
- Ve a **Settings > Basic > Key Hashes**
- Agrega el hash obtenido en el paso anterior

#### 5. Configura Android Manifest (✅ YA HECHO):
- Se han agregado las actividades de Facebook necesarias
- Se ha agregado la red queries para compatibilidad

---

## 📝 CÓDIGO DE USO

### AuthService (`lib/services/auth_service.dart`):

```dart
// Google Sign-In
await AuthService.instance.signInWithGoogle();

// Apple Sign-In
await AuthService.instance.signInWithApple();

// Meta/Facebook Sign-In
await AuthService.instance.signInWithMeta();

// Sign Out (cierra todas las sesiones)
await AuthService.instance.signOut();
```

### LoginPage (`lib/screens/login_page.dart`):

Los tres botones de login ya están implementados:
- **Botón Google** (Naranja)
- **Botón Apple** (Negro)
- **Botón Facebook** (Azul Facebook)

Cada botón dispara el método de autenticación correspondiente.

---

## 🧪 TESTING

### Prueba la app en emulador/dispositivo:

```bash
# Android
flutter run --no-dds

# iOS (después de configurar en Xcode)
flutter run -d iPhone --no-dds
```

### En la pantalla de login:
1. Presiona el botón de tu proveedor preferido
2. Sigue el flujo de autenticación
3. La app debe navegar automáticamente al Home si el login es exitoso
4. Se mostrará un snackbar si hay algún error

---

## 📋 LISTA DE VERIFICACIÓN (CHECKLIST)

### Google Sign-In:
- ✅ Dependencias agregadas
- ✅ AuthService configurado
- ✅ UI con botón implementado
- ✅ Firebase ya está en uso

### Apple Sign-In:
- ⚠️ Agregar "Sign in with Apple" capability en Xcode
- ✅ Dependencia agregada (sign_in_with_apple)
- ✅ AuthService configurado
- ✅ UI con botón implementado
- ⚠️ Verificar Info.plist tiene configuración correcta

### Facebook Sign-In:
- ⚠️ Obtener Facebook App ID y Client Token
- ✅ Dependencia agregada (flutter_facebook_auth)
- ✅ AuthService configurado
- ✅ UI con botón implementado
- ⚠️ **iOS**: Configurar en Xcode
- ⚠️ **Android**: Reemplazar placeholders en strings.xml
- ⚠️ **Android**: Registrar Key Hash en Facebook Dashboard

---

## ❌ TROUBLESHOOTING

### Error: "Sign in with Apple not available"
- Asegúrate de tener la capability habilitada en Xcode
- Verifica que estés en iOS 13.0 o superior

### Error: "Facebook SDK initialization error"
- Verifica que los IDs de Facebook sean correctos en strings.xml (Android) e Info.plist (iOS)
- Asegúrate de haber registrado el Key Hash en Facebook Dashboard

### El botón no responde
- Verifica que imports están correctos
- Ejecuta `flutter pub get` nuevamente
- Limpia el cache: `flutter clean && flutter pub get`

---

## 🔗 RECURSOS ÚTILES

- [Google Sign-In Documentation](https://firebase.flutter.dev/docs/auth/social/#google)
- [Apple Sign-In Documentation](https://pub.dev/packages/sign_in_with_apple)
- [Meta Login Documentation](https://pub.dev/packages/flutter_facebook_auth)
- [Firebase Auth Documentation](https://firebase.flutter.dev/docs/auth/overview)

---

**¡Listo!** Tu app ahora tiene autenticación multi-proveedor completamente configurada. 🚀
