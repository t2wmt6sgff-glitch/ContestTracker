# AGENTS.md

## Alcance y autoridad

Este archivo contiene reglas técnicas para agentes. El código actual es la fuente de verdad del comportamiento implementado; `docs/CONTESTTRACKER_CONTEXT.md` conserva historia, decisiones y riesgos. Si difieren, no inventes una conciliación: indica la contradicción.

## Proyecto nativo

- La raíz del repositorio es el contenido del documento `ContestTracker.swiftpm` enlazado a Working Copy.
- No crear `Sources/ContestTracker/` ni convertir el paquete en una estructura Xcode convencional.
- No editar `Package.swift` salvo necesidad real y autorización explícita.
- El deployment target declarado en `Package.swift` es iOS 17.6.
- El entorno normal es iPad + Swift Playground + Working Copy + GitHub. Xcode es opcional para tareas avanzadas, no un requisito para desarrollar, exportar IPA ni publicar si existe acceso a App Store Connect desde Swift Playground.
- No añadir certificados, perfiles, claves, datos privados ni archivos de firma al repositorio.

## Forma de trabajar

- Lee los archivos afectados y el workflow antes de modificar código.
- Mantén cada cambio enfocado y explica su impacto sobre SwiftData, persistencia o datos existentes.
- No confundas type-check, compilación completa, ejecución y prueba manual en iPad.
- El workflow actual solo ejecuta type-check para `arm64-apple-ios17.6-simulator`.
- Trabaja mediante rama y Pull Request salvo que el usuario ordene explícitamente trabajar en `main`.

## SwiftData

- Antes de modificar un `@Model`, una relación o el `ModelContainer`, analiza compatibilidad y posible migración.
- Las modificaciones de persistencia deben probarse creando o editando datos, cerrando por completo la app, reabriéndola y comprobando el resultado.
- No borres el almacén como solución predeterminada.

## Producto y arquitectura

- Mantén SwiftUI, SwiftData, URLSession, Open Opus y las integraciones EventKit existentes.
- No introducir MVVM completo, repositories, inyección de dependencias compleja ni dependencias externas sin justificación concreta.
- Las obras guardadas deben seguir funcionando offline.
- No incrementes versiones automáticamente.
