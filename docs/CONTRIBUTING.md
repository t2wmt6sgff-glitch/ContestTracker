# Contribuir a Contest Tracker

Gracias por tu interés en contribuir a Contest Tracker.

Contest Tracker es un proyecto de código abierto cuyo objetivo es proporcionar una herramienta sencilla y estable para pianistas que preparan concursos.

Las contribuciones pueden incluir correcciones de errores, mejoras de accesibilidad, mejoras de interfaz, nuevas funcionalidades, documentación y propuestas técnicas.

## Antes de contribuir

Antes de realizar cambios importantes, familiarízate con:

- La estructura actual del proyecto.
- La arquitectura utilizada.
- Las decisiones técnicas existentes.
- Las restricciones de compatibilidad.
- Los problemas conocidos.

No es necesario introducir una arquitectura nueva para cada funcionalidad.

Una solución sencilla y coherente con el proyecto suele ser preferible a una solución más compleja.

## Principios de desarrollo

Las contribuciones deberían respetar los siguientes principios:

- Mantener el código comprensible.
- Evitar sobreingeniería.
- Priorizar la estabilidad.
- Mantener los cambios enfocados.
- Evitar dependencias innecesarias.
- Mantener una buena experiencia de usuario en iPad.
- Considerar la accesibilidad.
- Evitar regresiones.
- Mantener la compatibilidad establecida por el proyecto.

Cuando dos soluciones resuelven correctamente el mismo problema, se debería preferir la que introduzca menos complejidad.

## Arquitectura

Contest Tracker utiliza una arquitectura deliberadamente ligera.

No se deben introducir automáticamente:

- MVVM completo.
- Repository patterns.
- Dependency Injection compleja.
- Capas de servicios innecesarias.
- Frameworks externos.
- Abstracciones adicionales.

Estas herramientas pueden utilizarse cuando exista una necesidad técnica real, pero no deben añadirse únicamente por seguir un patrón arquitectónico.

Los cambios deben integrarse con la estructura existente del proyecto siempre que sea razonable.

## SwiftUI

Las interfaces deben diseñarse teniendo en cuenta que Contest Tracker es una aplicación nativa para iPadOS.

Los cambios de interfaz deberían considerar:

- Tamaño de pantalla.
- Navegación de iPadOS.
- Orientación.
- Espacio disponible.
- Interacción táctil.
- Legibilidad.
- Accesibilidad.
- Compatibilidad con diferentes tamaños de texto.

La interfaz debe priorizar la claridad frente a la cantidad de elementos mostrados.

## SwiftData

Los modelos de SwiftData requieren especial cuidado.

Antes de modificar un modelo `@Model`, una relación o el `ModelContainer`, se debe analizar el posible impacto sobre los datos existentes.

Los cambios de esquema pueden afectar a bases de datos ya creadas por versiones anteriores de la aplicación.

Antes de realizar cambios importantes en SwiftData:

1. Identifica exactamente qué cambia.
2. Comprueba qué datos existentes pueden verse afectados.
3. Determina si puede ser necesaria una migración.
4. Conserva un estado funcional anterior.
5. Realiza pruebas de persistencia.
6. Comprueba el comportamiento después de cerrar y volver a abrir la aplicación.

No se debe asumir que un cambio de modelo es inocuo.

La persistencia correcta de los datos tiene prioridad sobre la incorporación rápida de nuevas funcionalidades.

## Compatibilidad

Las contribuciones deben respetar el deployment target establecido por el proyecto.

Actualmente el objetivo mínimo es:

**iPadOS 17.6**

No se deben utilizar APIs exclusivas de versiones posteriores cuando exista una alternativa compatible, salvo que exista una justificación clara.

También debe tenerse en cuenta la compatibilidad con las herramientas de desarrollo utilizadas para mantener el proyecto.

## Dependencias

No deben añadirse dependencias externas sin una necesidad clara.

Antes de incorporar una dependencia nueva se debería considerar:

- Si la funcionalidad puede implementarse de forma sencilla con las APIs existentes.
- El mantenimiento futuro de la dependencia.
- Su compatibilidad con iPadOS.
- Su licencia.
- El impacto que tendrá sobre el tamaño y la complejidad del proyecto.

## Cambios en los datos

Cualquier cambio que pueda modificar, eliminar o transformar datos existentes debe tratarse como un cambio de alto riesgo.

Esto incluye especialmente:

- Cambios en modelos SwiftData.
- Cambios en relaciones.
- Cambios en identificadores.
- Cambios en el `ModelContainer`.
- Cambios en mecanismos de persistencia.

Estos cambios deben probarse cuidadosamente antes de considerarse terminados.

## Pruebas

Los cambios deben probarse en el entorno real de desarrollo siempre que sea posible.

Las pruebas deberían comprobar tanto el comportamiento inmediato como el comportamiento después de:

1. Ejecutar la aplicación.
2. Modificar datos.
3. Salir de una sección.
4. Volver a entrar.
5. Cerrar la aplicación.
6. Volver a abrirla.
7. Comprobar que los datos siguen presentes.

Las funcionalidades relacionadas con persistencia no deberían considerarse terminadas únicamente porque funcionan mientras la aplicación permanece abierta.

## Pull Requests

Una Pull Request debería explicar brevemente:

- Qué problema resuelve.
- Qué se ha cambiado.
- Por qué se ha elegido esa solución.
- Cómo se ha probado.
- Si afecta a la persistencia o a datos existentes.

Se prefieren cambios pequeños y enfocados.

Una Pull Request que mezcle múltiples funcionalidades independientes debería dividirse cuando sea razonable.

## Issues

Al informar de un problema, incluye cuando sea posible:

- Versión de Contest Tracker.
- Modelo de iPad.
- Versión de iPadOS.
- Pasos para reproducir el problema.
- Comportamiento esperado.
- Comportamiento observado.

Si el problema está relacionado con persistencia, indica también si ocurre después de cerrar y volver a abrir la aplicación.

## Documentación

La documentación debe mantenerse útil y estable.

No es necesario documentar cada pequeño cambio del proyecto.

El historial detallado de modificaciones se conserva mediante Git y sus commits.

La documentación debe centrarse principalmente en:

- Qué es el proyecto.
- Cómo funciona a nivel general.
- Cómo contribuir.
- Decisiones técnicas importantes.
- Información necesaria para desarrollar y mantener el proyecto.

## Filosofía

Contest Tracker se desarrolla progresivamente.

El objetivo no es añadir funcionalidades tan rápido como sea posible, sino construir una aplicación estable, comprensible y útil.

La simplicidad y la fiabilidad son características del proyecto, no limitaciones temporales.
