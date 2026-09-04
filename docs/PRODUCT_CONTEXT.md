# Contexto de producto

## Problema

Los pianistas que preparan concursos necesitan relacionar fechas, fases, requisitos y repertorio sin perder de vista qué obra corresponde a cada fase y qué queda por preparar. Las herramientas genéricas de tareas y calendario no reflejan bien este modelo.

## Promesa

ContestTracker convierte la preparación de concursos en una vista clara y accionable: qué concursos importan, qué exige cada fase, qué repertorio está asignado y qué fechas requieren atención.

## Usuarios iniciales

- Pianista que prepara uno o varios concursos.
- Profesor o familiar que ayuda a planificar.
- En una fase posterior, otros pianistas que acceden desde la web.

El primer usuario real sigue siendo prioritario. No se construyen funciones sociales o multiusuario sin evidencia de que aportan valor.

## Superficies

### App nativa

La app SwiftUI es el entorno personal y local-first. Debe ser rápida, privada y útil sin conexión. La integración con calendario, notificaciones y archivos del dispositivo pertenece naturalmente aquí.

### Web futura

La web será la vía pública de acceso a ContestTracker y deberá poder instalarse como PWA cuando resulte útil. Compartirá lenguaje, marca y conceptos con la app, pero tendrá navegación y componentes adaptados al navegador.

### Backend opcional

Un backend sólo se incorpora para funciones que no pueden resolverse bien de forma local, por ejemplo sincronización entre dispositivos, recuperación de datos, colaboración o publicación centralizada. Antes de elegir tecnología se necesita una decisión explícita sobre cuentas, privacidad, coste y funcionamiento sin conexión.

## Principios de producto

- Local-first para los flujos principales.
- Datos del usuario bajo su control.
- Funciones pequeñas y completas antes que muchas funciones parciales.
- Accesibilidad y claridad visual desde el diseño inicial.
- Compatibilidad con iPadOS 17.6 y el entorno de Xcode 16.2 disponible.
- Evolución segura de SwiftData.
- La web no depende de que la app se publique en la App Store.

## Distribución

Un archivo IPA puede conservarse como artefacto de pruebas o desarrollo. Publicarlo en GitHub no elimina los requisitos de firma e instalación de iOS, por lo que no debe considerarse el canal público principal. La web/PWA será la opción pública cuando se construya.

## Métrica inicial de éxito

Una persona puede crear un concurso, dividirlo en fases, asignar repertorio, entender las próximas fechas y recuperar toda la información después de cerrar y volver a abrir la app.
