# PencaGol - Aplicación de Pencas de Fútbol

Una aplicación móvil moderna desarrollada en Flutter para gestionar pencas de fútbol, especialmente diseñada para el Mundial 2026.

## 🚀 Características

### Pantallas Implementadas

- **LoginPage**: Pantalla de inicio de sesión con logo animado y validación de formularios
- **HomePage**: Pantalla principal con próximos partidos y accesos rápidos
- **RankingPage**: Tabla de posiciones con filtros por grupo
- **AdminPage**: Panel de administración con pestañas para gestión de pencas, resultados y usuarios

### Diseño y UX

- **Material 3**: Implementación completa del sistema de diseño Material 3
- **Tema Personalizado**: Colores verde césped (#2E7D32) y dorado (#FFD700)
- **Animaciones**: Transiciones suaves entre pantallas y elementos interactivos
- **Responsive**: Diseño adaptativo para diferentes tamaños de pantalla
- **Accesibilidad**: Feedback háptico y navegación intuitiva

### Funcionalidades

- ✅ Autenticación de usuarios
- ✅ Visualización de próximos partidos del Mundial 2026
- ✅ Sistema de ranking con filtros por grupo
- ✅ Panel de administración completo
- ✅ Gestión de resultados de partidos
- ✅ Creación de nuevas pencas
- ✅ Interfaz moderna y minimalista

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo móvil
- **Material 3**: Sistema de diseño de Google
- **Dart**: Lenguaje de programación
- **Animaciones**: PageRouteBuilder y AnimationController

## 📱 Pantallas

### LoginPage
- Logo animado de PencaGol
- Campos de usuario y contraseña con validación
- Botón de registro (funcionalidad próxima)
- Diseño con gradiente verde

### HomePage
- AppBar con navegación
- Saludo de bienvenida
- Accesos rápidos (Mis Pronósticos, Resultados, Mi Grupo, Ranking)
- Lista de próximos partidos con banderas y detalles

### RankingPage
- Filtros por grupo
- Tabla de posiciones con avatares
- Usuario actual resaltado
- Animaciones de entrada

### AdminPage
- Pestañas para diferentes funciones
- Creación de nuevas pencas
- Gestión de resultados de partidos
- Administración de usuarios

## 🎨 Paleta de Colores

- **Verde Principal**: #2E7D32 (Verde césped)
- **Verde Claro**: #4CAF50
- **Verde Oscuro**: #1B5E20
- **Dorado**: #FFD700
- **Negro**: #212121
- **Blanco**: #FFFFFF
- **Gris Claro**: #F5F5F5

## 🚀 Instalación y Ejecución

1. Asegúrate de tener Flutter instalado en tu sistema
2. Clona el repositorio
3. Navega al directorio del proyecto
4. Ejecuta `flutter pub get` para instalar las dependencias
5. Ejecuta `flutter run` para iniciar la aplicación

```bash
git clone <repository-url>
cd penca_gol
flutter pub get
flutter run
```

## 📁 Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── theme/
│   └── app_theme.dart       # Configuración del tema personalizado
├── screens/
│   ├── login_page.dart      # Pantalla de inicio de sesión
│   ├── home_page.dart       # Pantalla principal
│   ├── ranking_page.dart    # Tabla de posiciones
│   └── admin_page.dart      # Panel de administración
├── models/
│   ├── match_model.dart     # Modelo de datos para partidos
│   └── user_model.dart      # Modelo de datos para usuarios
├── widgets/
│   ├── match_card.dart      # Tarjeta de partido
│   ├── quick_access_card.dart # Tarjeta de acceso rápido
│   ├── ranking_item.dart    # Elemento del ranking
│   ├── admin_section_card.dart # Tarjeta de sección admin
│   └── match_result_card.dart # Tarjeta de resultado
└── utils/
    └── page_transitions.dart # Transiciones personalizadas
```

## 🔮 Próximas Funcionalidades

- [ ] Sistema de registro de usuarios
- [ ] Base de datos para persistencia
- [ ] Notificaciones push
- [ ] Sistema de predicciones
- [ ] Chat de grupo
- [ ] Estadísticas detalladas
- [ ] Modo offline
- [ ] Integración con APIs de fútbol

## 👥 Contribución

Este es un prototipo inicial de PencaGol. Las contribuciones son bienvenidas para mejorar la funcionalidad y el diseño.

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo LICENSE para más detalles.

---

**PencaGol** - ¡Haz que cada partido cuente! ⚽
