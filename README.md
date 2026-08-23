# Contest Tracker

Contest Tracker es una aplicación nativa para iPadOS diseñada para pianistas que preparan concursos de piano.

Su objetivo es proporcionar una herramienta sencilla para organizar concursos, fases y repertorio, manteniendo la información de forma local en el dispositivo.

El proyecto está desarrollado con Swift, SwiftUI y SwiftData, y está pensado para ofrecer una experiencia sencilla, estable y adecuada para iPad.

## Características

Contest Tracker está orientado a la gestión de:

- Concursos de piano.
- Fases de concursos.
- Obras musicales.
- Repertorio asociado a concursos.
- Información y planificación relacionada con la participación en concursos.

Las funcionalidades de la aplicación evolucionarán progresivamente durante el desarrollo del proyecto.

## Filosofía del proyecto

Contest Tracker prioriza:

- Simplicidad.
- Estabilidad.
- Código comprensible.
- Buena experiencia de usuario.
- Persistencia fiable de los datos.
- Funcionamiento local y offline siempre que sea posible.
- Desarrollo progresivo.
- Accesibilidad.
- Compatibilidad con distintas generaciones de iPadOS.

El proyecto evita añadir complejidad técnica cuando una solución más sencilla puede resolver correctamente el mismo problema.

## Tecnología

Contest Tracker utiliza principalmente:

- Swift
- SwiftUI
- SwiftData
- URLSession
- Swift Playgrounds

El proyecto está desarrollado como un paquete `.swiftpm`.

El objetivo mínimo de compatibilidad es:

**iPadOS 17.6 o posterior**

El desarrollo puede realizarse desde Swift Playgrounds y, posteriormente, desde Xcode.

## Arquitectura

La arquitectura de Contest Tracker está deliberadamente orientada a mantener el proyecto sencillo.

La aplicación utiliza SwiftUI para la interfaz y SwiftData para la persistencia local.

No se introducen patrones arquitectónicos, capas de abstracción, dependencias o frameworks adicionales salvo que exista una necesidad técnica real.

En particular, el proyecto evita introducir automáticamente:

- MVVM completo.
- Repositories.
- Dependency Injection compleja.
- Capas de servicios innecesarias.
- Frameworks externos sin una justificación clara.

La arquitectura puede evolucionar si las necesidades del proyecto cambian, pero cualquier aumento de complejidad debe estar justificado.

## Datos y privacidad

Contest Tracker está diseñado como una aplicación local.

La aplicación no requiere:

- Cuentas de usuario.
- Backend propio.
- Servidores propios.
- Autenticación.
- iCloud.
- Bases de datos remotas.

Los datos creados por el usuario se almacenan localmente en el dispositivo.

Las funcionalidades que necesiten acceso a Internet pueden utilizar servicios externos cuando sea necesario para proporcionar una determinada función, pero estos servicios no constituyen el sistema principal de almacenamiento de Contest Tracker.

## Open Opus

Contest Tracker puede utilizar Open Opus como fuente para descubrir información sobre obras musicales.

Open Opus se utiliza como servicio de consulta y descubrimiento. La información necesaria de una obra puede almacenarse localmente después de que el usuario la añada a Contest Tracker.

El proyecto no incorpora una copia completa de la base de datos de Open Opus.

API:

https://api.openopus.org

## Desarrollo

Contest Tracker se desarrolla de forma incremental.

Los cambios importantes se realizan procurando:

1. Mantener un estado funcional.
2. Realizar cambios pequeños y controlados.
3. Probar los cambios en el dispositivo.
4. Evitar regresiones.
5. Mantener la persistencia de los datos.
6. Documentar las decisiones técnicas importantes cuando sea necesario.

Los cambios que afecten a los modelos de SwiftData deben tratarse con especial cuidado, ya que pueden afectar a datos existentes.

## Compatibilidad

El proyecto tiene como objetivo funcionar en iPadOS 17.6 y versiones posteriores compatibles.

Las APIs exclusivas de versiones recientes de iPadOS no deben utilizarse cuando exista una alternativa compatible con el deployment target, salvo que exista una razón clara para hacerlo.

También se tiene en cuenta la compatibilidad futura con versiones de Xcode utilizadas para desarrollar y mantener el proyecto.

## Código abierto

Contest Tracker es un proyecto de código abierto.

Las contribuciones, correcciones, propuestas y mejoras son bienvenidas siempre que sean coherentes con los objetivos y la arquitectura del proyecto.

Antes de realizar cambios importantes, consulta `CONTRIBUTING.md`.

## Licencia

Contest Tracker se distribuye bajo los términos de la **GNU General Public License v3.0**.

Puedes consultar el texto completo de la licencia en el archivo `LICENSE`.

## Proyecto

Contest Tracker está desarrollado como un proyecto independiente y no depende de un servicio online para funcionar como gestor local de concursos y repertorio.

El proyecto evoluciona progresivamente con el objetivo de convertirse en una herramienta útil para pianistas que preparan concursos.