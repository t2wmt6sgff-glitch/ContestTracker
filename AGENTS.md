# AGENTS.md

## Alcance

Este archivo contiene únicamente reglas técnicas para Codex. No sustituye las instrucciones, la memoria, las fuentes ni las decisiones de producto del proyecto histórico de ChatGPT «ContestTracker».

Cuando falte contexto de producto, no lo inventes: consulta `docs/CONTESTTRACKER_CONTEXT.md` si existe o pide un brief procedente del proyecto histórico.

## Proyecto nativo

- El código de la aplicación está en `SwiftPlayground/` y conserva la estructura generada por Swift Playgrounds.
- `SwiftPlayground/Package.swift` se genera automáticamente; no lo edites manualmente.
- El deployment target mínimo es iPadOS 17.6.
- Los entornos nativos disponibles son Swift Playgrounds en iPad y Xcode 16.2 en el Mac.
- Windows y los agentes sin herramientas de Apple pueden inspeccionar y editar el código, pero no deben afirmar que la app compila o se ejecuta.

## Forma de trabajar

- Lee `README.md`, `CONTRIBUTING.md` y los archivos afectados antes de modificar código.
- Mantén cada cambio técnico limitado a un solo resultado comprobable.
- Evita reescrituras amplias y dependencias nuevas salvo necesidad demostrada.
- No conviertas riesgos detectados por inspección en errores confirmados sin reproducirlos.
- Informa por separado de la inspección estática, la compilación, la ejecución en simulador y la prueba en dispositivo.
- No añadas certificados, perfiles de aprovisionamiento, claves, datos privados ni archivos de firma al repositorio.

## SwiftData

- Antes de modificar un `@Model`, una relación o el `ModelContainer`, analiza la compatibilidad con datos existentes y la posible necesidad de migración.
- Los cambios de persistencia deben probarse creando o modificando datos, cerrando completamente la app, volviéndola a abrir y comprobando el resultado.
- No cambies modelos como parte colateral de una tarea de interfaz.

## Pull requests

Explica qué cambia, por qué, cómo se verificó y si afecta a persistencia o datos existentes. No mezcles funcionalidades independientes.
