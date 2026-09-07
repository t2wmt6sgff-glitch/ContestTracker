# Contest Tracker

Contest Tracker es una aplicación nativa para iPadOS dirigida a pianistas que preparan concursos. Reúne concursos, fases, repertorio y plazos importantes en una herramienta local, sencilla y utilizable sin conexión para los datos ya guardados.

## Funciones actuales

### Concursos

- Crear, editar y eliminar concursos.
- Consultar fecha, lugar, notas, cuenta atrás y resumen de fases y obras.
- Separar automáticamente concursos próximos y finalizados.
- Archivar concursos finalizados, recuperarlos o eliminarlos definitivamente.
- Crear, editar y eliminar fases.
- Asignar repertorio a cada fase.

### Obras y repertorio

- Crear obras manualmente.
- Buscar obras ya guardadas en el dispositivo.
- Buscar y añadir obras mediante la API de Open Opus.
- Consultar, editar y eliminar obras.
- Reutilizar obras existentes al añadir repertorio a una fase para evitar duplicados innecesarios.
- Asociar un enlace de YouTube a una obra, abrirlo, modificarlo o eliminarlo.

Open Opus se usa únicamente para descubrir obras. Al añadir una obra, sus datos se guardan localmente y siguen disponibles sin conexión.

### Fechas, Calendario y Recordatorios

Cada concurso puede contener fechas importantes con título, fecha, hora opcional y notas. Se pueden crear, editar, eliminar, ordenar cronológicamente y consultar con su propia cuenta atrás.

Desde el detalle de un concurso o de una fecha importante se abre el editor nativo de Apple Calendar mediante EventKitUI. Las fechas sin hora se proponen como eventos de día completo.

Una fecha importante también puede crear o actualizar un recordatorio en Apple Reminders. Contest Tracker solicita el permiso del sistema y guarda el identificador del recordatorio para actualizar el mismo elemento en vez de crear duplicados. Eliminar una fecha importante no elimina automáticamente el recordatorio ya creado en Reminders.

### Persistencia

Los concursos, fases, repertorio, obras, archivado y fechas importantes se almacenan localmente con SwiftData. Las operaciones principales de fechas importantes guardan explícitamente el contexto para mejorar la fiabilidad, especialmente al ejecutar desde Swift Playground.

## Tecnología y arquitectura

- Swift y SwiftUI.
- SwiftData para almacenamiento local.
- URLSession y Open Opus API para búsqueda de obras.
- EventKit y EventKitUI para Calendar y Reminders.
- Sin backend, cuentas, iCloud ni servidores propios.

La arquitectura se mantiene deliberadamente ligera: no se introducen MVVM completo, repositories, inyección de dependencias compleja ni dependencias externas sin una necesidad demostrada.

## Desarrollo desde iPad

El flujo normal no requiere Mac ni Xcode:

```text
Swift Playground
      ↕
Working Copy
      ↕
GitHub
      ↓
GitHub Actions
Swift Playground
      ↓
Exportar IPA
      ↓
firma e instalación
```

El repositorio y el documento `ContestTracker.swiftpm` usado por Swift Playground están enlazados mediante Working Copy. Swift Playground guarda los cambios en ese documento; Working Copy permite revisar el diff, hacer commit y push. Después de fusionar una Pull Request, se cierra el proyecto en Swift Playground, se hace Pull en Working Copy y se vuelve a abrir el mismo documento para probar.

No actives Auto-Sync si quieres revisar manualmente cada commit y push.

### GitHub Actions

El workflow `.github/workflows/swift.yml` se ejecuta en push a `main`, Pull Requests hacia `main` y `workflow_dispatch`. Ejecuta `swiftc -typecheck` sobre los archivos Swift con el SDK de iOS Simulator y el target `arm64-apple-ios17.6-simulator`.

Esta comprobación valida el type-check; no es una compilación completa, no ejecuta la app y no sustituye la prueba manual en iPad.

## Exportar IPA

En **Ajustes → Desarrollo → Exportar IPA**, la app puede localizar el bundle `.app` que está ejecutando Swift Playground, crear `Payload`, empaquetarlo y mostrar el selector de archivos de iPadOS para guardar un `.ipa`.

La exportación se ha probado correctamente en iPad. Crear el archivo IPA no equivale a firmarlo ni instalarlo: iPadOS seguirá exigiendo una firma y un perfil de aprovisionamiento válidos para instalarlo fuera de Swift Playground.

No hace falta pertenecer al Apple Developer Program para desarrollar desde iPad ni para esta exportación local. La membresía sí es necesaria para publicar en App Store. Si en el futuro existe membresía, Swift Playground puede enviar la app directamente a App Store Connect; Xcode seguiría siendo opcional.

Xcode puede ser útil para depuración avanzada, Instruments o pruebas más complejas, pero no forma parte del flujo normal de desarrollo ni de exportación.

## Compatibilidad

El objetivo documentado del proyecto es **iPadOS 17.6 o posterior**. `Package.swift` declara actualmente `.iOS("17.6")`; no hay una discrepancia activa con iPadOS 18.2.

## Fuera de alcance actual

- Backend, cuentas, iCloud y sincronización entre dispositivos.
- Funciones sociales o multiusuario.
- Gestión completa de práctica, simulacros o estadísticas.
- IA, recomendaciones automáticas, audio, partituras y catálogo masivo propio de obras.

## Licencia

Contest Tracker se distribuye bajo la [GNU General Public License v3.0](../LICENSE).
