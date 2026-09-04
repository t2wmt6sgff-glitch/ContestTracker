# Hoja de ruta

Esta hoja de ruta ordena resultados, no fechas. Cada fase comienza cuando la anterior deja una base estable; se pueden investigar fases futuras sin mezclar su implementación.

## Ahora — Fundamentos y línea base

- [ ] Confirmar que el paquete actual abre y ejecuta en Swift Playgrounds y Xcode 16.2.
- [ ] Documentar fallos de compilación, persistencia y navegación reproducibles.
- [ ] Crear una copia de datos de prueba y comprobar que sobreviven al cierre y reapertura.
- [ ] Revisar la estructura actual sin reescribirla.
- [ ] Establecer un flujo corto: issue o tarea, rama, cambio enfocado, prueba, pull request.

**Salida:** línea base reproducible y una primera tarea de producto lista para implementar.

## Siguiente — Experiencia principal estable

- [ ] Definir los tres a cinco recorridos esenciales del usuario.
- [ ] Corregir bloqueos o pérdidas de datos en esos recorridos.
- [ ] Unificar navegación, estados vacíos, errores y confirmaciones.
- [ ] Revisar accesibilidad, tamaño de texto y orientaciones de iPad.
- [ ] Crear un sistema visual pequeño: color, tipografía, espaciado y componentes recurrentes.

**Salida:** versión nativa coherente y fiable para el uso diario.

## Después — Planificación local

- [ ] Modelar fechas y próximos hitos sin romper datos existentes.
- [ ] Añadir notificaciones locales con permisos y estados de error claros.
- [ ] Evaluar EventKit para exportar o enlazar eventos; no duplicar calendarios sin necesidad.
- [ ] Diseñar recuperación y edición de recordatorios creados por la app.

**Salida:** el usuario entiende qué viene después y puede recibir avisos sin backend.

## Web pública

- [ ] Definir qué parte del producto aporta valor en navegador.
- [ ] Diseñar la web como PWA responsive, no como copia literal de la interfaz de iPad.
- [ ] Elegir tecnología según las restricciones reales del hosting familiar.
- [ ] Implementar un MVP local-first y preparar despliegue reproducible.
- [ ] Añadir analítica o telemetría sólo con una decisión de privacidad.

**Salida:** una versión web instalable y accesible mediante URL.

## Backend y sincronización — Sólo con necesidad validada

- [ ] Escribir las historias de usuario que requieren servidor.
- [ ] Decidir si habrá cuentas y qué datos se sincronizan.
- [ ] Definir comportamiento offline, conflictos, exportación y borrado.
- [ ] Comparar coste y mantenimiento antes de escoger proveedor.
- [ ] Prototipar con datos no sensibles y una ruta de salida documentada.

**Salida:** backend mínimo con una razón verificable, o decisión explícita de no construirlo todavía.

## Ideas aparcadas

No se incorporan al trabajo activo sin prioridad explícita:

- Funciones sociales.
- Colaboración multiusuario.
- Catálogo masivo propio de obras.
- Sustituir SwiftData por una arquitectura remota.
- Automatización de distribución pública de IPA.
