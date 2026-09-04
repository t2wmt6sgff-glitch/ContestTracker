# CONTESTTRACKER_CONTEXT.md

> Expediente de contexto histórico, funcional y técnico de Contest Tracker.
>
> Fecha de consolidación: 4 de septiembre de 2026.
>
> Este documento migra a un entorno local de Codex el contexto conservado en las instrucciones personalizadas del proyecto de ChatGPT, la memoria de conversaciones anteriores y el repositorio GitHub.
>
> No sustituye al código como fuente del comportamiento implementado. Cuando existe una contradicción, se documenta expresamente.

---

## 1. Autoridad y criterios de interpretación

### 1.1. Orden de autoridad

Para interpretar el proyecto debe usarse este orden:

1. Instrucciones personalizadas actuales del proyecto de ChatGPT ContestTracker.
2. Decisiones explícitas posteriores del usuario.
3. Código actual del repositorio.
4. Pruebas manuales que el usuario haya confirmado.
5. Historial y memoria de los chats del proyecto.
6. README, CONTRIBUTING y documentación del repositorio.
7. `AGENTS.md` y los documentos añadidos por la pull request #1.

`AGENTS.md` y la documentación de la pull request #1 fueron una primera aproximación incompleta. No tienen autoridad para:

- cambiar el producto;
- sustituir instrucciones históricas;
- declarar aprobada una web;
- convertir un backend opcional en parte de la hoja de ruta;
- cambiar la distribución acordada;
- reabrir como pendientes funciones ya implementadas;
- alterar la forma de trabajar solicitada por el usuario.

### 1.2. Etiquetas usadas

- **FUNCIONAL:** presente en el código actual o confirmado históricamente como operativo.
- **TERMINADO:** confirmado por pruebas manuales o por una versión estable publicada.
- **PROBLEMA CONOCIDO:** fallo reproducido o limitación confirmada.
- **RIESGO:** posibilidad detectada mediante inspección del código, sin reproducción confirmada.
- **DEUDA TÉCNICA:** código mejorable que no justifica por sí solo una reescritura.
- **DECISIÓN:** instrucción o elección aprobada por el usuario.
- **DECISIÓN PROVISIONAL:** propuesta discutida pero no aprobada definitivamente.
- **PENDIENTE:** trabajo futuro acordado.
- **IDEA:** posibilidad no comprometida.
- **LAGUNA:** información no disponible o pendiente de confirmar.
- **CONTRADICCIÓN:** dos fuentes conservadas dicen cosas incompatibles.

### 1.3. Fuentes abreviadas

- **[IP]** Instrucciones personalizadas del proyecto ContestTracker.
- **[CH]** Chats históricos o memoria resumida del proyecto.
- **[R]** Código actual de `main`.
- **[REL]** Release pública `0.3`.
- **[PR1]** Pull request #1 y documentos que introdujo.
- **[PR2]** Pull request #2, restauración del directorio de recursos.
- **[AUD]** Auditoría estática realizada el 4 de septiembre de 2026.

### 1.4. Límites de acceso

Durante esta consolidación se pudo consultar:

- las instrucciones personalizadas actuales incluidas en el proyecto de ChatGPT;
- la memoria resumida de los chats históricos;
- fragmentos recuperados mediante búsqueda de contexto personal;
- el árbol y los archivos actuales del repositorio mediante la conexión de GitHub;
- la release `0.3`;
- la pull request #1;
- el historial de commits disponible.

No se pudo consultar como transcripción completa cada conversación histórica. Algunos chats solo están disponibles mediante resúmenes, fragmentos conservados o mensajes finales. Cuando falta el texto exacto de una decisión, se indica como laguna y no se completa por inferencia.

---

## 2. Identidad del producto

### 2.1. Nombre

**Contest Tracker** en el nombre visible de la aplicación y en el repositorio.

En algunos documentos aparece escrito como `ContestTracker`. Ambos nombres se refieren al mismo proyecto.

### 2.2. Objetivo

Contest Tracker es una aplicación nativa orientada a pianistas que preparan concursos de piano.

Su objetivo es permitir que una persona pueda:

- registrar concursos;
- consultar fechas, lugares, notas y cuentas atrás;
- dividir cada concurso en fases;
- organizar el repertorio de cada fase;
- mantener una biblioteca local de obras;
- descubrir obras mediante Open Opus;
- conservar los datos después de cerrar y volver a abrir la aplicación.

La aplicación debe seguir siendo comprensible, estable y útil sin conexión para sus funciones principales.

### 2.3. Problema que resuelve

Un pianista que prepara concursos necesita relacionar:

- el concurso;
- su fecha;
- sus fases;
- las obras exigidas o elegidas;
- las decisiones de repertorio todavía pendientes.

Las aplicaciones genéricas de tareas y calendario no representan directamente esta estructura.

### 2.4. Usuarios

#### Usuario prioritario

El primer usuario real es el propio creador del proyecto: un pianista joven que prepara repertorio y participa en concursos.

Este usuario tiene prioridad frente a posibles usuarios hipotéticos. No se deben añadir sistemas sociales, multiusuario o empresariales sin una necesidad real.

#### Usuarios posibles

También podrían utilizar la aplicación:

- otros pianistas;
- profesores;
- familiares que ayudan a organizar concursos y repertorio.

Estos usuarios posibles no justifican todavía cuentas, colaboración o backend.

---

## 3. Principios de producto

### 3.1. Principios decididos

Contest Tracker prioriza:

- simplicidad;
- estabilidad;
- código comprensible;
- desarrollo progresivo;
- buena experiencia en iPad;
- persistencia fiable;
- funcionamiento local y offline;
- accesibilidad;
- ausencia de regresiones;
- aprendizaje de Swift durante el desarrollo.

Cada función debe integrarse con la arquitectura existente antes de proponer una arquitectura nueva.

### 3.2. Límites de producto

No se debe convertir todavía en un gestor completo de práctica.

Permanecen fuera del alcance actual:

- simulacros;
- estadísticas;
- inteligencia artificial;
- recomendaciones automáticas;
- cuentas;
- sincronización;
- iCloud;
- backend;
- grabación o análisis de audio;
- gestión de partituras;
- funciones sociales;
- colaboración multiusuario;
- catálogo masivo propio de obras;
- importación de miles de obras.

### 3.3. Forma de trabajar solicitada

Antes de implementar un cambio:

1. Explicar brevemente qué se va a construir.
2. Explicar por qué encaja en el producto.
3. Indicar los archivos afectados.
4. Proporcionar solo el código necesario.
5. Explicar cómo probarlo.
6. Esperar la confirmación del usuario.

Secuencia obligatoria:

**implementar → ejecutar → probar → confirmar → continuar**

No deben encadenarse automáticamente varias funciones o versiones.

---

## 4. Estado actual verificable

### 4.1. Versión

**TERMINADO:** `0.3 Stable`.

La release fue publicada el 23 de agosto de 2026:

- Nombre: `Contest Tracker 0.3 Stable`.
- Etiqueta: `0.3`.
- Commit base de la release: `510c06a`.
- Artefacto publicado: `Contest.Tracker.0.3.Swift.Package.zip`.
- SHA-256 declarado por GitHub: `45747ab0587d84cea69a734b4dfaa53989e226fd639e248d3a8d240b267b18ef`.

Fuente: [release 0.3](https://github.com/t2wmt6sgff-glitch/ContestTracker/releases/tag/0.3).

La rama `main` consultada posteriormente está en `e9b9328`, después de fusionar documentación y restaurar el directorio `Resources`. Esos cambios posteriores no introdujeron nuevas funciones de producto.

### 4.2. Aplicación y navegación principal

**FUNCIONAL [R]:**

La raíz usa un `TabView` con dos secciones:

- `Concursos`, icono `trophy`;
- `Obras`, icono `music.note.list`.

Cada sección usa su propio `NavigationStack`.

### 4.3. Concursos

**FUNCIONAL [R][REL][CH]:**

- Crear concursos.
- Editar concursos.
- Eliminar concursos con confirmación.
- Guardar nombre, fecha, lugar y notas.
- Consultar una vista de detalle.
- Mostrar una cuenta atrás.
- Distinguir concursos próximos y terminados.
- Atenuar visualmente los terminados.
- Mostrar el resumen `n fases · m obras`.
- Archivar o “descartar” concursos finalizados.
- Consultar concursos archivados.
- Recuperar concursos archivados.
- Eliminar concursos archivados.
- Editar concursos archivados.
- Mostrar estados vacíos.
- Persistir concursos con SwiftData.

#### Flujo actual de la lista

La implementación actual clasifica:

- **Próximos:** concursos cuya fecha es hoy o posterior.
- **Terminados:** concursos cuya fecha es anterior al día actual.
- **Archivados:** concursos asociados a un registro `ContestArchive`.

En el menú contextual:

- un concurso próximo ofrece `Editar` y `Eliminar`;
- un concurso terminado ofrece `Editar` y `Descartar`;
- un concurso archivado ofrece `Editar`, `Recuperar` y `Eliminar`.

#### Contradicción sobre “Hoy”

La release `0.3` afirma que existen las categorías `Próximos`, `Hoy` y `Finalizados`.

El código actual de `ContentView.swift` solo crea secciones visibles llamadas:

- `Próximos`;
- `Terminados`.

Los concursos del día actual se incluyen dentro de `Próximos` y muestran `Hoy` en la cuenta atrás.

Por tanto, una sección independiente `Hoy` no está presente en el código actual. No debe afirmarse que existe sin volver a implementarla o localizar una versión distinta del archivo.

### 4.4. Fases

**FUNCIONAL [R][REL][CH]:**

- Cada concurso puede contener varias fases.
- Las fases tienen nombre y orden.
- Se pueden añadir desde el detalle del concurso.
- Se pueden eliminar.
- Se ordenan mediante su propiedad `order`.
- La eliminación del concurso usa una relación en cascada sobre sus fases.
- Cada fase tiene su propia vista de detalle.
- La vista de fase muestra el repertorio asignado.
- Si no hay obras, aparece un estado vacío.
- Desde una fase se pueden añadir obras guardadas.
- Una obra ya asignada a esa fase queda deshabilitada para impedir una segunda asignación.
- Se puede quitar una obra de una fase mediante gesto lateral o menú contextual.

### 4.5. Elementos provisionales

**FUNCIONAL [R][CH]:**

Una fase puede contener un elemento provisional cuando todavía no se ha elegido la obra exacta.

Ejemplo de uso:

- `Obra española`;
- estado visible `Por decidir`.

Un elemento provisional puede:

- añadirse desde `AddWorkToPhaseView`;
- mostrarse con icono de interrogación;
- abrir un selector de obras;
- convertirse en una obra real;
- eliminarse de la fase.

Al seleccionar una obra:

- `musicWork` recibe la obra;
- `placeholder` pasa a `nil`.

La selección impide elegir una obra que ya esté presente en la misma fase.

### 4.6. Biblioteca de obras

**FUNCIONAL [R][REL][CH]:**

- Añadir una obra mediante Open Opus.
- Añadir una obra manualmente.
- Guardar las obras localmente.
- Buscar entre las obras guardadas.
- Buscar por título, compositor, subtítulo o catálogo.
- Agrupar las obras por compositor.
- Usar `Sin compositor` cuando ese campo está vacío.
- Abrir el detalle de una obra.
- Editar una obra.
- Eliminarla con confirmación.
- Editar mediante gesto lateral.
- Editar o eliminar mediante menú contextual.
- Mostrar la fuente como `Open Opus` o `Añadida manualmente`.
- Acceder directamente a un vídeo de YouTube cuando existe.

Aunque una instrucción histórica proponía “editar obras manuales”, el código actual permite editar también los datos visibles de las obras procedentes de Open Opus.

### 4.7. Open Opus

**FUNCIONAL [R][REL][CH]:**

- API base: `https://api.openopus.org`.
- Endpoint usado: `/omnisearch/{consulta}/0.json`.
- Consulta con `URLSession`.
- Tiempo de espera de 15 segundos.
- Decodificación con `JSONDecoder`.
- Resultados agrupados por compositor.
- Uso de `composer.id` para evitar repetir la cabecera del mismo compositor.
- Soporte para resultados que solo contienen compositor y no obra.
- Selección de obras.
- Guardado local de la información seleccionada.
- Prevención de duplicados de Open Opus mediante `openOpusID`.
- Diferenciación entre error y búsqueda sin resultados.
- Flujo de reintento según el estado conservado en los chats.
- Los identificadores de Open Opus se conservan internamente y no se muestran en la interfaz.

#### Decisión sobre el catálogo

Open Opus sirve como sistema de descubrimiento. Después de añadir una obra, la aplicación almacena los datos necesarios localmente.

No se debe depender de Open Opus para abrir, buscar o mostrar las obras ya guardadas.

#### Decisión sobre `work/dump.json`

**DECISIÓN [IP][CH]:**

No descargar ni incorporar `work/dump.json`.

Durante el desarrollo se intentó manejar ese archivo, que contiene una cantidad masiva de datos. Swift Playgrounds quedó bloqueado al abrirlo y terminaba cerrándose. El archivo fue eliminado.

La solución aprobada es usar solicitudes reales a la API y persistir únicamente las obras seleccionadas.

### 4.8. Vídeos de YouTube

**FUNCIONAL [R][REL]:**

Cada obra puede almacenar una URL opcional de YouTube.

Desde el detalle se puede:

- añadir un enlace;
- abrir el vídeo;
- cambiar el enlace;
- eliminarlo con confirmación.

La validación acepta estos hosts:

- `youtube.com`;
- `www.youtube.com`;
- `m.youtube.com`;
- `youtu.be`;
- `www.youtu.be`.

No se descarga el vídeo ni se incrusta un reproductor propio. El enlace se abre mediante el sistema.

### 4.9. Persistencia

**TERMINADO HISTÓRICAMENTE [REL][CH]:**

La release `0.3` declara que sobreviven al cierre y reapertura:

- concursos;
- fases;
- repertorio;
- obras;
- información de archivado.

El contenedor actual usa:

```swift
ModelConfiguration(isStoredInMemoryOnly: false)
```

y registra:

- `Contest`;
- `MusicWork`;
- `ContestPhase`;
- `ContestRepertoireItem`;
- `ContestArchive`.

#### Alcance de la verificación

La persistencia fue un problema real durante el desarrollo y se corrigió antes de declarar `0.3 Stable`.

No hay evidencia de una ejecución nueva en Swift Playgrounds, Xcode o iPad realizada durante la auditoría del 4 de septiembre. La auditoría reciente fue estática. Esto no invalida las pruebas históricas, pero Codex debe distinguir:

- prueba histórica de la release;
- inspección estática actual;
- nueva ejecución después de un cambio.

---

## 5. Arquitectura actual

### 5.1. Tecnologías

- Swift.
- SwiftUI.
- SwiftData.
- Foundation.
- URLSession.
- Swift Playgrounds.
- Proyecto `.swiftpm`.
- API externa Open Opus.

No hay dependencias externas declaradas.

### 5.2. Arquitectura deliberadamente ligera

**DECISIÓN [IP][R]:**

No introducir automáticamente:

- MVVM completo;
- repositorios;
- inyección de dependencias compleja;
- capas de servicios innecesarias;
- frameworks externos;
- una base de datos remota;
- una reescritura general.

Se permite extraer código cuando exista repetición o complejidad real, pero cada abstracción debe resolver un problema concreto.

### 5.3. Estructura observada

```text
ContestTracker/
├── .gitignore
├── AGENTS.md
├── CONTRIBUTING.md
├── LICENSE
├── README.md
├── SwiftPlayground/
│   ├── AddWorkToPhaseView.swift
│   ├── ContentPhase.swift
│   ├── ContentPhaseDetailView.swift
│   ├── ContentView.swift
│   ├── Contest.swift
│   ├── ContestArchive.swift
│   ├── ContestDetailView.swift
│   ├── ContestFormView.swift
│   ├── ContestRepertoireItem.swift
│   ├── ContestTrackerApp.swift
│   ├── MusicSearchView.swift
│   ├── MusicWork.swift
│   ├── MusicWorkDetailView.swift
│   ├── MusicWorkEditView.swift
│   ├── OpenOpusAPI.swift
│   ├── OpenOpusModels.swift
│   ├── Package.swift
│   ├── Resources/
│   │   └── README.txt
│   ├── WorksView.swift
│   └── YouTubeVideoView.swift
└── docs/
    ├── DECISIONS.md
    ├── PRODUCT_CONTEXT.md
    └── ROADMAP.md
```

Los archivos Swift se mantienen directamente dentro del paquete `SwiftPlayground/`.

No crear una estructura tradicional como:

```text
Sources/ContestTracker/
```

Swift Playgrounds dio problemas al colocar los archivos de Open Opus dentro de una carpeta `Music/`. Por eso permanecen en el nivel principal del paquete.

### 5.4. `Package.swift`

El archivo declara:

- `swift-tools-version: 5.9`;
- plataforma mínima `.iOS("17.6")`;
- nombre visible `Contest Tracker`;
- `displayVersion: "0.3"`;
- `bundleVersion: "1"`;
- categoría musical;
- soporte declarado para iPad y iPhone;
- orientaciones vertical y horizontal;
- `Resources` como recurso procesado.

El propio archivo indica que lo genera Swift Playgrounds y que no debe editarse a mano.

#### LAGUNA: soporte de iPhone

El producto está diseñado y probado principalmente para iPad. Sin embargo, `Package.swift` declara `.pad` y `.phone`.

No existe una decisión histórica recuperada que confirme si el soporte de iPhone es intencionado. No debe eliminarse ni prometerse compatibilidad completa con iPhone sin consultar al usuario.

---

## 6. Modelos conocidos

### 6.1. `Contest`

Modelo SwiftData:

```swift
@Model
final class Contest {
    var name: String
    var date: Date
    var location: String
    var notes: String

    @Relationship(deleteRule: .cascade)
    var phases: [ContestPhase]
}
```

Responsabilidad:

- información básica de un concurso;
- propiedad de sus fases;
- eliminación en cascada de fases.

No tiene un UUID propio declarado. El sistema de archivado usa su `persistentModelID`.

### 6.2. `ContestPhase`

El archivo se llama actualmente `ContentPhase.swift`, pero la clase es `ContestPhase`.

```swift
@Model
final class ContestPhase {
    var id: UUID
    var name: String
    var order: Int

    @Relationship(deleteRule: .cascade)
    var repertoireItems: [ContestRepertoireItem]
}
```

Responsabilidad:

- representar una fase;
- mantener su orden;
- poseer los elementos de repertorio;
- eliminarlos en cascada al eliminar la fase.

El nombre de archivo `ContentPhase.swift` parece una errata histórica. Renombrarlo no es una prioridad funcional y no debe mezclarse con otro cambio.

### 6.3. `ContestRepertoireItem`

```swift
@Model
final class ContestRepertoireItem {
    var id: UUID
    var musicWork: MusicWork?
    var placeholder: String?
}
```

Representa dos estados:

- obra decidida: `musicWork != nil`, `placeholder == nil`;
- elemento provisional: `musicWork == nil`, `placeholder` contiene texto.

El modelo no impone formalmente que solo una propiedad tenga valor.

### 6.4. `MusicWork`

```swift
@Model
final class MusicWork {
    var id: UUID
    var openOpusID: String?

    var title: String
    var subtitle: String
    var composer: String
    var catalogue: String
    var genre: String

    var isManual: Bool
    var youtubeURL: String?
}
```

Reglas conocidas:

- `title` es el único campo obligatorio en los formularios.
- `openOpusID` identifica internamente las obras importadas.
- `isManual` conserva el origen.
- `youtubeURL` es opcional.
- Los datos se guardan localmente.
- No se muestran identificadores técnicos al usuario.

### 6.5. `ContestArchive`

```swift
@Model
final class ContestArchive {
    var contestID: String
}
```

Guarda una representación textual del identificador persistente del concurso.

No contiene una relación SwiftData directa con `Contest`.

### 6.6. Modelos de red de Open Opus

Tipos `Decodable`:

- `OpenOpusResponse`;
- `OpenOpusStatus`;
- `OpenOpusRequest`;
- `OpenOpusSearchResult`;
- `OpenOpusComposer`;
- `OpenOpusWork`.

Son modelos de transporte, no modelos SwiftData.

`OpenOpusSearchResult` puede contener:

- un compositor;
- una obra opcional.

---

## 7. Flujos de interfaz acordados o implementados

### 7.1. Crear un concurso

1. Abrir `Concursos`.
2. Pulsar `+`.
3. Introducir nombre.
4. Elegir fecha.
5. Añadir lugar y notas opcionales.
6. Guardar.
7. El concurso aparece en la lista correspondiente.

Cancelar no debe crear ni modificar datos.

### 7.2. Editar un concurso

1. Mantener pulsada su tarjeta.
2. Elegir `Editar`.
3. Modificar los campos.
4. Guardar.

La edición modifica el modelo existente. No debe crear un segundo concurso.

### 7.3. Eliminar o archivar un concurso

- Los concursos próximos se eliminan mediante confirmación.
- Los terminados se descartan y pasan a Archivados.
- Desde Archivados pueden recuperarse o eliminarse.
- El archivado no debe destruir las fases ni el repertorio.

### 7.4. Añadir fases

1. Abrir un concurso.
2. Añadir una fase mediante su nombre.
3. Calcular `order` usando el mayor orden actual más uno.
4. Insertar la fase y asociarla al concurso.
5. Abrir la fase para gestionar su repertorio.

### 7.5. Añadir una obra a la biblioteca

Desde `Obras`:

1. Pulsar `+`.
2. Buscar en Open Opus o elegir el alta manual.
3. Seleccionar una obra o completar el formulario.
4. Guardarla como `MusicWork`.
5. Volver a la biblioteca.

Las obras guardadas deben seguir disponibles sin conexión.

### 7.6. Añadir repertorio a una fase

Implementación actual:

1. Abrir el concurso.
2. Abrir una fase.
3. Pulsar `Añadir obra`.
4. Buscar entre las obras ya guardadas.
5. Elegir una obra que todavía no esté en esa fase.
6. Crear un `ContestRepertoireItem`.
7. Mantener el selector abierto para permitir más incorporaciones.

También se puede añadir un elemento provisional.

### 7.7. Resolver un elemento provisional

1. Pulsar el elemento marcado `Por decidir`.
2. Buscar entre las obras guardadas.
3. Elegir una obra no asignada ya a la fase.
4. Sustituir el texto provisional por la referencia a `MusicWork`.

### 7.8. Flujo aún incompleto

Desde una fase no se puede actualmente:

- buscar una obra nueva en Open Opus;
- crear una obra manual nueva;
- guardarla en la biblioteca;
- asignarla inmediatamente a la fase.

El usuario debe salir del flujo, ir a `Obras`, crear la obra y regresar a la fase.

Esta es la próxima mejora vertical válida identificada.

---

## 8. Decisiones y motivos

### 8.1. Persistencia local con SwiftData

**DECISIÓN:**

Los datos principales se guardan en el dispositivo con SwiftData.

Motivos:

- pocos usuarios previstos;
- uso personal;
- ausencia de cuentas;
- funcionamiento offline;
- menor complejidad;
- integración nativa con SwiftUI;
- no depender de servidores.

### 8.2. Sin backend

**DECISIÓN VIGENTE [IP][REL][CH]:**

Contest Tracker no tendrá backend en su alcance actual.

También se excluyen:

- cuentas;
- autenticación;
- servidores propios;
- sincronización;
- iCloud.

La pull request #1 reformuló esta decisión como “backend opcional si aparece una necesidad”. Esa formulación no sustituye la decisión histórica. Cualquier reconsideración necesita una petición explícita del usuario.

### 8.3. Open Opus solo para descubrimiento

**DECISIÓN:**

Open Opus complementa la aplicación, pero no es su almacenamiento principal.

Motivos:

- conservar acceso offline;
- evitar depender de la disponibilidad de la API;
- guardar solo lo que el usuario necesita;
- impedir que el proyecto cargue una base de datos masiva.

### 8.4. Arquitectura ligera

**DECISIÓN:**

No introducir patrones complejos sin necesidad.

Motivos:

- el proyecto se desarrolla mientras el usuario aprende Swift;
- debe poder entenderse y modificarse desde Swift Playgrounds;
- tiene pocos usuarios;
- una arquitectura mayor aumentaría el riesgo de errores y migraciones.

### 8.5. Compatibilidad mínima

**DECISIÓN:**

Deployment target mínimo: **iPadOS 17.6**.

No usar APIs exclusivas de iPadOS 26 o posteriores salvo justificación y aprobación.

La apariencia del sistema puede cambiar al ejecutar la misma aplicación en versiones más recientes de iPadOS. Una apariencia tipo Liquid Glass observada en el iPad no implica que el código utilice APIs exclusivas de esa versión.

### 8.6. Versionado

**DECISIÓN:**

El usuario decide siempre el número de versión.

Convención histórica:

- `V0.x.x.x`: cambio concreto;
- `V0.x.x`: conjunto de cambios que forman una funcionalidad;
- `V0.x`: actualización significativa.

Durante el desarrollo de `0.3` se usaron nombres como:

- `V0.3 beta 1`;
- `V0.3 beta 2`;
- `V0.3 beta 3`;
- `V0.3 beta 4`;
- `0.3 Stable`.

No se deben sustituir por `0.3.1`, `0.3.2`, etc. sin que el usuario lo decida.

Codex nunca incrementará una versión automáticamente.

### 8.7. Distribución

**DECISIÓN HISTÓRICA [IP][CH][REL]:**

- El proyecto es open-source.
- No se publicará mediante App Store Connect en el alcance actual.
- Se pretende generar un `.ipa` para instalarlo directamente en el iPad.
- La release `0.3` publicó el paquete Swift, no un canal universal de instalación.
- Se esperan pocos usuarios.

#### Contradicción con PR #1

La pull request #1 declaró que una futura web/PWA debía ser el canal público principal y que el IPA sería solo un artefacto técnico.

Esa decisión no aparece aprobada en las instrucciones históricas y posteriormente el usuario indicó que la PR #1 simplificaba o contradecía el contexto real. Por tanto:

- la distribución por IPA sigue siendo la decisión histórica;
- la web no debe considerarse el canal público decidido;
- no debe diseñarse una estrategia de distribución web sin una nueva decisión.

### 8.8. Calendario, recordatorios y notificaciones

**NO DECIDIDO:**

No se ha recuperado una decisión aprobada para implementar:

- integración con Apple Calendar;
- EventKit;
- recordatorios;
- notificaciones locales;
- sincronización con calendarios externos.

La pull request #1 los colocó en una hoja de ruta posterior. Esa inclusión es una propuesta de la PR, no un compromiso del producto.

Antes de implementarlos habría que decidir:

- qué fecha genera un evento o aviso;
- si la aplicación crea eventos o solo exporta;
- cómo se editan o eliminan;
- qué ocurre si se deniegan permisos;
- si se necesita una relación persistente con el identificador externo.

### 8.9. Web o PWA

**NO DECIDIDO / FUERA DEL TRABAJO ACTUAL:**

Las instrucciones históricas describen una aplicación nativa para iPad y no incluyen una web.

La PR #1 añadió una futura PWA como superficie pública. El usuario corrigió después que esa PR no debía sustituir decisiones previas ni diseñar todavía backend o web.

Codex debe tratar la web como una idea no aprobada hasta recibir una decisión explícita.

---

## 9. Bugs y problemas conocidos

### 9.1. Persistencia del archivado

**PROBLEMA HISTÓRICO CORREGIDO [CH][R]:**

En una versión anterior:

- archivar funcionaba mientras la aplicación permanecía abierta;
- después de cerrarla y volverla a abrir, el concurso regresaba de Archivados a Finalizados.

La intención del usuario fue insistir hasta conseguir persistencia indefinida.

La solución actual:

- guarda un `ContestArchive`;
- normaliza la representación de `persistentModelID`;
- conserva compatibilidad con identificadores antiguos que incluyan `<...>`;
- ejecuta `modelContext.save()` explícitamente al archivar.

La release `0.3` declara la persistencia corregida.

### 9.2. Teclado virtual de Swift Playgrounds

**PROBLEMA CONOCIDO [IP][CH]:**

En algunos `TextField` de Swift Playgrounds:

- aparece el cursor;
- es posible pegar;
- el teclado virtual no introduce caracteres correctamente.

No crear un teclado personalizado para resolverlo.

Debe comprobarse en ejecución real y, posteriormente, en Xcode. Puede ser una limitación del entorno de Playgrounds.

### 9.3. Preview inconsistente

**PROBLEMA CONOCIDO [IP][CH]:**

La preview puede mostrar un estado diferente al ejecutar la aplicación, por ejemplo una lista vacía aunque la ejecución funcione.

No invertir trabajo en la preview salvo que el fallo también afecte a la aplicación ejecutada.

### 9.4. Archivos dentro de `Music/`

**PROBLEMA CONOCIDO [IP][CH]:**

Mover determinados archivos Swift a una carpeta `Music/` provocó problemas de pertenencia al target, incluyendo mensajes equivalentes a “not in a target”.

Los archivos de Open Opus permanecen en el nivel principal del paquete.

### 9.5. `work/dump.json`

**PROBLEMA HISTÓRICO RESUELTO:**

El archivo bloqueaba Swift Playgrounds al abrir el proyecto. Fue eliminado. No debe volver a añadirse.

### 9.6. Directorio `Resources`

**PROBLEMA DEL REPOSITORIO CORREGIDO [PR2]:**

`Package.swift` declaraba `Resources` como recurso procesado, pero el directorio no estaba presente después de una reorganización.

La pull request #2 restauró:

```text
SwiftPlayground/Resources/README.txt
```

No se registraron cambios funcionales.

---

## 10. Riesgos y deuda técnica observados

Estos puntos proceden de inspección estática. No todos son bugs reproducidos.

### 10.1. Identidad del archivado

`ContestArchive` guarda `persistentModelID` como texto analizado mediante caracteres `<` y `>`.

**RIESGO:**

- depende de una representación textual interna;
- podría cambiar entre versiones;
- obliga a mantener compatibilidad con formatos previos;
- no existe una relación SwiftData directa.

No cambiarlo sin una estrategia de migración y pruebas con datos existentes.

### 10.2. Estados inválidos de `ContestRepertoireItem`

El modelo permite:

- `musicWork == nil` y `placeholder == nil`;
- `musicWork != nil` y `placeholder != nil`.

La interfaz espera que exista exactamente uno.

**RIESGO:**

Pueden aparecer elementos invisibles o ambiguos si una operación queda incompleta.

### 10.3. Eliminación de una obra asignada

`MusicWork` puede eliminarse desde la biblioteca mientras existe un `ContestRepertoireItem` que la referencia.

No se ha recuperado una regla explícita sobre qué debe ocurrir:

- impedir la eliminación;
- pedir confirmación ampliada;
- eliminar las asignaciones;
- convertirlas en provisionales;
- dejar la referencia a `nil`.

**LAGUNA DE PRODUCTO Y RIESGO DE INTEGRIDAD.**

### 10.4. Guardados implícitos

Muchas operaciones confían en el autoguardado de SwiftData.

El archivado sí llama a `modelContext.save()` y muestra errores solo en consola.

**RIESGO:**

- guardado parcial;
- errores no visibles para el usuario;
- diferencias de comportamiento entre ejecución normal, cierre forzado y depuración.

No añadir llamadas indiscriminadas a `save()` sin entender las relaciones y el flujo.

### 10.5. Recuperación del `ModelContainer`

Si la creación del contenedor falla, la aplicación ejecuta:

```swift
fatalError("No se pudo crear el ModelContainer: \(error)")
```

**RIESGO:**

La app se cierra sin una ruta de recuperación, diagnóstico visible o exportación.

No implementar un borrado automático del almacén. Una recuperación incorrecta podría destruir datos del usuario.

### 10.6. Duplicados manuales

La prevención conocida de duplicados usa `openOpusID`.

Las obras manuales no tienen un identificador externo y pueden repetirse.

Esto puede ser aceptable, porque dos entradas con títulos parecidos podrían ser intencionadas. No debe crearse una comparación automática por título y compositor sin definir antes las reglas.

### 10.7. Duplicación de vistas de edición

`WorksView.swift` contiene una vista privada `EditWorkView`, mientras existe también `MusicWorkEditView.swift`.

Ambas editan prácticamente los mismos campos.

**DEUDA TÉCNICA:**

- posible divergencia futura;
- dos implementaciones para una misma función;
- mayor coste de mantenimiento.

Puede consolidarse en una tarea técnica pequeña, pero no debe mezclarse con la siguiente función de producto si aumenta el riesgo.

### 10.8. Registro completo de respuestas de Open Opus

`OpenOpusAPI.swift` imprime el JSON completo recibido:

```swift
print("===== OPEN OPUS JSON =====")
print(rawJSON)
```

**DEUDA TÉCNICA:**

- ruido en consola;
- salida muy grande;
- posible impacto durante búsquedas;
- comportamiento de depuración presente en la versión estable.

Eliminar este registro sería un cambio pequeño, pero debe probarse separado de cambios funcionales.

### 10.9. Nombre de archivo `ContentPhase.swift`

La clase se llama `ContestPhase`, pero el archivo se llama `ContentPhase.swift`.

Es una inconsistencia nominal. No afecta por sí sola al funcionamiento.

### 10.10. Catálogo de Open Opus

`OpenOpusWork` no contiene una propiedad específica de catálogo. La aplicación conserva título, subtítulo y género devueltos por la API, pero no se ha verificado que pueda completar siempre `catalogue`.

No inventar catálogos a partir del título sin una regla aprobada.

### 10.11. Verificación nativa pendiente tras la migración

La auditoría del 4 de septiembre fue estática.

Queda pendiente comprobar el estado actual en:

- Swift Playgrounds;
- el Xcode disponible;
- un iPad físico;
- cierre y reapertura;
- reinicio del dispositivo si se quiere una prueba más fuerte.

---

## 11. Pruebas realizadas y evidencia disponible

### 11.1. Pruebas históricas confirmadas

Según los chats y la release:

- creación y edición de concursos;
- persistencia de concursos;
- creación de obras manuales;
- búsqueda Open Opus;
- agrupación por compositor;
- varias obras del mismo compositor en resultados;
- búsqueda sin resultados;
- errores de conexión;
- persistencia de `MusicWork`;
- archivo y recuperación de concursos;
- persistencia después de cerrar y reabrir;
- detalle, edición y eliminación de obras;
- asociación de vídeos de YouTube;
- fases y repertorio;
- elementos provisionales.

### 11.2. Prueba específica del buscador

Se comprobó una búsqueda como `arabesque`.

El problema original era que el compositor aparecía repetido por cada obra. Se corrigió agrupando por compositor.

Después se comprobó que la agrupación no limitara a una sola obra por compositor: un compositor puede mostrar varias coincidencias dentro de su sección.

### 11.3. Pruebas no demostradas en la auditoría reciente

No se ejecutaron durante la revisión del 4 de septiembre:

- compilación en Swift Playgrounds;
- compilación en Xcode;
- simulador;
- dispositivo físico;
- VoiceOver;
- Dynamic Type;
- todas las orientaciones;
- migración de un almacén antiguo;
- eliminación de una obra asignada;
- fallo deliberado del `ModelContainer`.

Codex debe describir honestamente el tipo de comprobación realizado y no llamar “prueba” a una inspección estática.

---

## 12. Ideas futuras y compromisos

### 12.1. Funciones que ya no deben presentarse como futuras

Las instrucciones conservadas más antiguas describían V0.2.8 y V0.2.9 como futuras. El repositorio y la release muestran que muchas de esas propuestas ya se implementaron en `0.3 Stable`.

Ya existen:

- mejora visual de Obras;
- búsqueda local;
- detalle de obra;
- edición;
- eliminación con confirmación;
- distinción manual/Open Opus;
- estados vacíos;
- prevención de duplicados por `openOpusID`;
- gestión de errores;
- navegación mejorada;
- fases;
- asignación de repertorio;
- elementos provisionales;
- vídeos de YouTube;
- persistencia local.

No deben planificarse otra vez como si faltaran.

### 12.2. Estados de preparación

**DECISIÓN PROVISIONAL HISTÓRICA:**

Se propusieron:

- `Sin empezar`;
- `En preparación`;
- `Preparada`;
- `Lista para concurso`.

No constan en los modelos actuales ni existe confirmación de que sus significados, transiciones o ubicación en la interfaz hayan sido aprobados.

No implementarlos hasta volver a definir su propósito.

### 12.3. Gestor avanzado de práctica

**FUERA DE ALCANCE:**

No añadir todavía:

- tiempos de práctica;
- rachas;
- objetivos diarios;
- estadísticas;
- grabaciones;
- evaluación automática;
- recomendaciones.

### 12.4. Web

**IDEA NO APROBADA:**

La PR #1 propone una futura web/PWA. El contexto histórico no la confirma como compromiso.

### 12.5. Backend

**FUERA DE ALCANCE ACTUAL:**

No elegir proveedor ni preparar sincronización.

### 12.6. Calendario y recordatorios

**IDEA NO APROBADA:**

La PR #1 menciona EventKit, UserNotifications y planificación local. No existe una decisión de producto suficiente para implementarlos.

### 12.7. Accesibilidad

**PRINCIPIO APLICABLE Y TRABAJO CONTINUO:**

La aplicación ya incorpora varias etiquetas de accesibilidad y textos descriptivos.

Queda razonablemente pendiente revisar:

- VoiceOver;
- Dynamic Type;
- contraste;
- tamaños táctiles;
- orientaciones;
- textos truncados.

Esta revisión no implica rediseñar toda la interfaz.

---

## 13. Cronología resumida

### 18 de agosto de 2026 — Base inicial

- Estado identificado como `V0.1`.
- Creación de concursos.
- Estado vacío inicial.
- Uso de SwiftUI y SwiftData.
- Problemas de teclado virtual en Swift Playgrounds.
- Preview diferente de la ejecución real.
- Siguiente intención: editar concursos mediante pulsación prolongada.

Fuente histórica: chat **“Diseñar Contest Tracker V1”**.

### 19 de agosto de 2026 — Edición y Open Opus

- Trabajo sobre edición de concursos existentes.
- Investigación de una base de datos musical.
- Elección de Open Opus.
- Revisión del repositorio y documentación de Open Opus.
- Intento de usar `work/dump.json`.
- Swift Playgrounds quedó bloqueado por el archivo.
- Eliminación del dump.
- Adopción de consultas por API.

Fuente histórica: chat **“Editar concursos existentes”**.

### 19 de agosto de 2026 — V0.2.6

- Open Opus operativo.
- Uso de `omnisearch`.
- Agrupación por compositor.
- Identificadores ocultos en interfaz.
- Verificación de que un compositor puede mostrar varias obras.
- `V0.2.6` declarada terminada.

Fuente histórica: chat **“Preparar catálogo musical”**.

### 19 de agosto de 2026 — V0.2.7

- Buscador musical completo.
- Selección y alta de obras.
- Alta manual.
- Integración con `WorksView`.
- Persistencia de `MusicWork`.
- `V0.2.7` declarada terminada.
- Se propone que la siguiente fase mejore la calidad de vida de Obras.

Fuente histórica: chat **“Revisar buscador musical”**.

### 20 de agosto de 2026 — Pulido de Obras

- Búsqueda local.
- Detalle, edición y eliminación.
- Revisión de estados vacíos.
- Debate sobre distinguir obras manuales y de Open Opus.
- Corrección de la nomenclatura: usar `V0.3 beta 1`, no `0.3.1`.
- El usuario mantiene el control de las versiones.

Fuente histórica: chat **“Análisis de búsqueda local”**.

### 21 de agosto de 2026 — Fases, archivado y persistencia

- Desarrollo de fases y repertorio.
- Incorporación de concursos archivados.
- Aparición de un fallo: el archivado duraba solo durante la sesión.
- Se localizaron cambios problemáticos en versiones recientes de `ContestsView.swift` y `Contest.swift`.
- Al deshacer esas versiones, la aplicación volvía a funcionar.

Fuentes históricas:

- **“Revisión visual obras”**.
- **“Contexto Contest Tracker”**.

### 22 de agosto de 2026 — Persistencia indefinida

- El usuario decide no abandonar el problema.
- Objetivo explícito: convertir la persistencia temporal en persistencia que sobreviva indefinidamente.
- Preparación de un repositorio GitHub para dejar de intercambiar archivos manualmente.
- Repositorio establecido: `t2wmt6sgff-glitch/ContestTracker`.

Fuente histórica: chat **“Contexto Contest Tracker”**.

### 23 de agosto de 2026 — Repositorio y `0.3 Stable`

- Creación inicial del repositorio.
- Incorporación del paquete Swift.
- Reorganización de los archivos bajo `SwiftPlayground/`.
- Ajustes de persistencia y `ContentView`.
- Publicación de `Contest Tracker 0.3 Stable`.
- La release declara concursos, fases, repertorio, Open Opus, YouTube y persistencia local como estables.

Fuentes:

- historial Git;
- [release 0.3](https://github.com/t2wmt6sgff-glitch/ContestTracker/releases/tag/0.3).

### 4 de septiembre de 2026 — Preparación inicial para Codex

- Creación de documentación en la rama `codex/workflow-foundation`.
- PR #1: `docs: preparar ContestTracker para trabajar con Codex`.
- PR #2: restauración de `SwiftPlayground/Resources`.
- Ambas PR quedaron fusionadas.
- El usuario corrigió el rumbo: las instrucciones del proyecto son más completas y tienen autoridad sobre `AGENTS.md`.
- Auditoría estática del código.
- Identificación del siguiente recorrido vertical que todavía aporta valor.

Fuentes:

- [pull request #1](https://github.com/t2wmt6sgff-glitch/ContestTracker/pull/1);
- historial Git;
- chat **“Brief primer recorrido vertical”**.

---

## 14. Fuentes relevantes y dato aportado

### 14.1. Instrucciones personalizadas actuales

Aportan:

- rol esperado de ChatGPT/Codex;
- entorno;
- arquitectura;
- deployment target;
- restricciones;
- flujo progresivo;
- clasificación de estados;
- hoja de ruta histórica;
- prohibición de inventar código no disponible;
- prioridad de estabilidad y comprensión.

Limitación: una parte del bloque conserva un estado anterior a `0.3 Stable`, por lo que debe cruzarse con el repositorio y los chats posteriores.

### 14.2. Chat “Diseñar Contest Tracker V1” — 18 de agosto

Aporta:

- V0.1;
- creación inicial de concursos;
- estado vacío;
- problemas de teclado y preview;
- decisión de que el usuario controla el versionado;
- distribución fuera de App Store mediante IPA.

Acceso disponible: resumen y fragmentos, no transcripción completa.

### 14.3. Chat “Editar concursos existentes” — 19 de agosto

Aporta:

- edición por pulsación prolongada;
- investigación de Open Opus;
- rechazo práctico del dump completo;
- uso de la documentación oficial de Open Opus.

Acceso disponible: resumen y fragmentos.

### 14.4. Chat “Preparar catálogo musical” — 19 de agosto

Aporta:

- Open Opus funcional;
- agrupación por compositor;
- comprobación de varias obras por compositor;
- cierre de V0.2.6.

Acceso disponible: resumen y fragmentos.

### 14.5. Chat “Revisar buscador musical” — 19 de agosto

Aporta:

- código y comportamiento de `MusicSearchView`;
- cierre de V0.2.7;
- propuestas para mejorar Obras.

Acceso disponible: resumen y fragmentos.

### 14.6. Chat “Análisis de búsqueda local” — 20 de agosto

Aporta:

- búsqueda local;
- pulido de Obras;
- nomenclatura de betas;
- hoja de ruta que desembocaría en 0.3.

Acceso disponible: resumen y fragmentos.

### 14.7. Chat “Revisión visual obras” — 21 de agosto

Aporta:

- estado de `ContentView`;
- fases;
- contexto de `0.3 beta 2`;
- regla de que el usuario decide siempre el número de versión.

Acceso disponible: resumen y fragmentos.

### 14.8. Chat “Contexto Contest Tracker” — 22 de agosto

Aporta:

- fallo histórico de persistencia del archivado;
- decisión de insistir hasta resolverlo;
- creación del repositorio;
- archivos implicados en regresiones previas.

Acceso disponible: resumen y fragmentos.

### 14.9. Chat “Continuación Contest Tracker” — 24 de agosto

Aporta:

- compatibilidad real del Mac disponible;
- conversación sobre Xcode 16.2;
- deployment target 17.6;
- diferencia entre APIs usadas y apariencia del sistema.

Acceso disponible: resumen y fragmentos.

### 14.10. Chat “Brief primer recorrido vertical” — 4 de septiembre

Aporta:

- auditoría estática del repositorio;
- corrección de autoridad respecto a `AGENTS.md`;
- funciones que ya estaban hechas;
- próxima entrega válida;
- ausencia de ejecución reciente.

Acceso disponible: fragmentos recuperados y memoria del proyecto.

### 14.11. Repositorio

Repositorio:

[github.com/t2wmt6sgff-glitch/ContestTracker](https://github.com/t2wmt6sgff-glitch/ContestTracker)

Aporta:

- código actual;
- modelos;
- navegación;
- estructura;
- documentación;
- historial;
- release estable.

### 14.12. README

[README.md](https://github.com/t2wmt6sgff-glitch/ContestTracker/blob/main/README.md)

Aporta:

- objetivo general;
- filosofía;
- arquitectura ligera;
- tecnologías;
- privacidad;
- uso de Open Opus;
- compatibilidad;
- licencia GPL-3.0.

### 14.13. CONTRIBUTING

[CONTRIBUTING.md](https://github.com/t2wmt6sgff-glitch/ContestTracker/blob/main/CONTRIBUTING.md)

Aporta:

- principios de contribución;
- cautela con SwiftData;
- compatibilidad;
- pruebas;
- cambios pequeños;
- requisitos de pull requests.

### 14.14. Release `0.3`

[Contest Tracker 0.3 Stable](https://github.com/t2wmt6sgff-glitch/ContestTracker/releases/tag/0.3)

Aporta:

- estado estable;
- fecha;
- funciones publicadas;
- persistencia declarada;
- artefacto del paquete;
- punto de referencia del proyecto.

### 14.15. Pull request #1

[PR #1: preparar ContestTracker para trabajar con Codex](https://github.com/t2wmt6sgff-glitch/ContestTracker/pull/1)

Aporta:

- primer `AGENTS.md`;
- documentación sobre producto, decisiones y hoja de ruta;
- intención de migrar el flujo a Codex.

Limitación:

- simplifica el contexto;
- reabre trabajo ya realizado;
- introduce web/PWA, calendario y backend opcional sin autoridad suficiente;
- no debe prevalecer sobre este expediente ni sobre las instrucciones personalizadas.

---

## 15. Contradicciones y lagunas

### 15.1. Estado de versión

- Las instrucciones conservadas dicen que la versión terminada es V0.2.7 y que V0.2.8 es la siguiente.
- La release y el código confirman `0.3 Stable`.

**Resolución:** usar `0.3 Stable` como estado actual. Conservar la hoja de ruta anterior solo como historia.

### 15.2. Xcode 15.4 frente a Xcode 16.2

- Un bloque de instrucciones antiguas menciona Xcode 15.4.
- Conversaciones posteriores confirman que Xcode 16.2 es la versión más reciente que puede ejecutar el MacBook Air 2019.
- La PR #1 también usa Xcode 16.2.

**Resolución provisional:** considerar Xcode 16.2 como entorno disponible más reciente, pero mantener compatibilidad con iPadOS 17.6 y evitar APIs innecesariamente modernas.

Codex no debe afirmar que una compilación pasó en Xcode 16.2 hasta ejecutarla realmente allí.

### 15.3. iPadOS actual

- Las instrucciones del proyecto mencionan iPadOS 26.
- El contexto posterior sitúa el dispositivo en iPadOS 27 beta.

**Resolución:** el sistema instalado puede cambiar; el deployment target sigue siendo iPadOS 17.6. El código no debe depender del sistema más reciente.

### 15.4. Sección “Hoy”

- La release afirma que existe una sección `Hoy`.
- El código actual incluye hoy dentro de `Próximos`.

**Resolución:** documentar el comportamiento del código actual. Preguntar al usuario antes de separar de nuevo la sección.

### 15.5. Web/PWA

- PR #1 la declara canal público futuro.
- El contexto autorizado no la incluye y el usuario pidió no diseñar web todavía.

**Resolución:** idea no aprobada.

### 15.6. Backend

- Instrucciones históricas: no habrá backend.
- PR #1: backend opcional si aparece un caso de uso.

**Resolución:** no backend en el alcance vigente. Requiere una nueva decisión explícita para reconsiderarlo.

### 15.7. Calendario y recordatorios

Solo aparecen en la documentación de PR #1. No consta una aprobación histórica.

**Resolución:** no comprometidos.

### 15.8. Eliminación de obras asignadas

No se conoce el comportamiento deseado ni se ha recuperado una prueba.

**Pendiente de decisión.**

### 15.9. Soporte de iPhone

Declarado técnicamente en `Package.swift`, pero no confirmado como objetivo de producto.

**Pendiente de decisión.**

### 15.10. Pruebas actuales

Existe evidencia histórica de funcionamiento, pero no una ejecución nueva después de la migración a Codex.

**Pendiente:** repetir una prueba de línea base antes de cambios relevantes.

### 15.11. Contenido completo de chats

No fue posible acceder a todas las conversaciones como transcripciones completas.

Este expediente no inventa:

- decisiones que no aparezcan en los resúmenes;
- razones que no estén documentadas;
- resultados exactos de pruebas no conservadas;
- versiones intermedias completas del código.

---

## 16. Instrucciones técnicas para Codex

### 16.1. Antes de cambiar código

Codex debe:

1. Leer este archivo.
2. Leer `README.md` y `CONTRIBUTING.md`.
3. Inspeccionar los archivos actuales afectados.
4. No asumir que un fragmento histórico coincide con `main`.
5. Revisar el historial si una conducta parece contradictoria.
6. Explicar el cambio y sus riesgos.
7. Mantener el cambio enfocado.

### 16.2. Compatibilidad

Comprobar siempre:

- deployment target iPadOS 17.6;
- Swift Playgrounds;
- Xcode 16.2 como entorno disponible más reciente, pendiente de prueba real;
- ausencia de APIs exclusivas de sistemas recientes;
- orientaciones de iPad;
- Dynamic Type y VoiceOver cuando cambie la interfaz.

### 16.3. SwiftData

Tratar como alto riesgo cualquier cambio en:

- propiedades de `@Model`;
- relaciones;
- reglas de borrado;
- opcionalidad;
- nombres de tipos;
- tipos almacenados;
- `ModelContainer`.

Antes de cambiar modelos:

- explicar el impacto;
- definir si hace falta migración;
- preservar datos existentes;
- probar cierre y reapertura;
- no usar como solución predeterminada borrar el almacén.

### 16.4. Estructura

- Mantener el paquete dentro de `SwiftPlayground/`.
- No crear `Sources/ContestTracker/`.
- No mover automáticamente los Swift de Open Opus a `Music/`.
- No editar `Package.swift` a mano salvo necesidad real y autorización.
- Mantener `Resources/` mientras siga declarado.
- No renombrar archivos o modelos dentro de una tarea funcional sin necesidad.

### 16.5. Arquitectura

- Reutilizar vistas y modelos existentes.
- No introducir MVVM completo.
- No crear repositorios ni inyección de dependencias compleja.
- No añadir dependencias externas sin justificar mantenimiento, licencia, tamaño y compatibilidad.
- No reescribir una vista completa para cambiar un flujo pequeño.
- Evitar lógica duplicada cuando pueda consolidarse sin ampliar el alcance.

### 16.6. Open Opus

- Usar `https://api.openopus.org`.
- Mantener `omnisearch`.
- No descargar `work/dump.json`.
- Tratar Open Opus como descubrimiento.
- Guardar localmente las obras seleccionadas.
- Reutilizar `openOpusID`.
- No mostrar identificadores en la interfaz.
- Diferenciar:
  - cargando;
  - error de conexión;
  - error HTTP o decodificación;
  - búsqueda sin resultados;
  - obra ya guardada.
- Las obras guardadas deben seguir disponibles sin red.

### 16.7. Versiones

- No modificar `displayVersion` ni `bundleVersion` salvo petición.
- No inventar el siguiente número.
- No llamar a una tarea `0.3.1`, `0.4` o similar por iniciativa propia.
- No marcar una función como terminada antes de que el usuario confirme la prueba manual.

### 16.8. Informes de verificación

Indicar cuál de estas acciones se realizó:

- inspección estática;
- compilación;
- ejecución en Swift Playgrounds;
- simulador;
- ejecución en iPad;
- cierre y reapertura;
- reinicio;
- prueba con red;
- prueba sin red.

No escribir “funciona” si solo se revisó el código.

### 16.9. Seguridad y privacidad

No incorporar al repositorio:

- certificados;
- perfiles de aprovisionamiento;
- claves privadas;
- datos personales;
- API keys;
- datos reales de concursos sin autorización.

Open Opus no requiere convertirse en un almacén remoto del usuario.

### 16.10. Comunicación con el usuario

- Explicar el propósito antes del código.
- Proporcionar solo los archivos o fragmentos necesarios.
- Si falta el contenido actual de un archivo, leerlo del repositorio o pedirlo.
- No inventar código.
- No avanzar al siguiente paso sin la prueba y confirmación solicitadas.
- Mantener términos visibles en español salvo decisión contraria.
- Mantener identificadores de código en inglés convencional.

---

## 17. Primera tarea de implementación que no repite trabajo

### Nombre funcional

**Crear una obra desde una fase y asignarla inmediatamente**

### Problema

`AddWorkToPhaseView` solo permite:

- elegir una obra ya guardada;
- añadir un elemento provisional.

Si la obra todavía no existe, el usuario debe:

1. cerrar el selector;
2. salir de la fase;
3. abrir `Obras`;
4. crear o buscar la obra;
5. regresar al concurso;
6. abrir otra vez la fase;
7. asignarla.

La biblioteca, Open Opus y el alta manual ya existen. Falta conectarlos con el flujo de la fase.

### Objetivo

Desde `ContestPhaseDetailView` y `AddWorkToPhaseView`, permitir:

- buscar una obra nueva en Open Opus;
- crear una obra manual;
- guardarla una sola vez en la biblioteca;
- crear un único `ContestRepertoireItem`;
- asignarla inmediatamente a la fase;
- regresar al detalle de la fase;
- cancelar sin dejar datos parciales.

### Archivos inicialmente afectados

Probables:

- `SwiftPlayground/AddWorkToPhaseView.swift`;
- `SwiftPlayground/MusicSearchView.swift`.

Solo si resulta necesario:

- `SwiftPlayground/ContentPhaseDetailView.swift`.

No debería requerir cambios en:

- modelos SwiftData;
- `ContestTrackerApp.swift`;
- `Package.swift`;
- Open Opus API;
- `ModelContainer`.

### Enfoque recomendado

Añadir a `MusicSearchView` un modo reutilizable o una devolución opcional de la obra creada/seleccionada.

Debe conservarse el flujo actual desde `WorksView`:

- desde Obras, guardar y cerrar;
- desde una fase, guardar, asignar y volver a la fase.

No crear otra copia completa del buscador.

### Reglas funcionales

1. Una obra nueva de Open Opus se identifica por `openOpusID`.
2. Si ya existe una obra con ese `openOpusID`, se reutiliza.
3. No debe crearse un segundo `MusicWork` para la misma obra de Open Opus.
4. La misma obra no puede añadirse dos veces a la misma fase.
5. Crear una obra manual desde la fase debe añadirla también a la biblioteca.
6. Cancelar el formulario manual no crea nada.
7. Cancelar la búsqueda no crea nada.
8. Si guardar la obra falla, no debe quedar un `ContestRepertoireItem` sin obra.
9. Los datos guardados deben sobrevivir al cierre y reapertura.
10. Las obras ya guardadas deben seguir funcionando sin conexión.
11. El comportamiento actual de `WorksView` no debe cambiar.
12. Los elementos provisionales deben seguir funcionando.

### Criterios de aceptación

- **CA-01:** desde una fase se puede seleccionar una obra ya guardada.
- **CA-02:** desde una fase se puede abrir la búsqueda de Open Opus.
- **CA-03:** seleccionar una obra nueva crea un solo `MusicWork`.
- **CA-04:** esa obra queda asignada a la fase.
- **CA-05:** la obra aparece también en la biblioteca.
- **CA-06:** si el `openOpusID` ya existe, se reutiliza la obra guardada.
- **CA-07:** no se duplica dentro de la fase.
- **CA-08:** se puede crear una obra manual y asignarla.
- **CA-09:** cancelar no altera la biblioteca ni la fase.
- **CA-10:** un error de red no crea datos parciales.
- **CA-11:** después de cerrar y abrir la app, permanecen la obra y la asignación.
- **CA-12:** concursos, archivado, obras existentes, vídeos y elementos provisionales no sufren regresiones.

### Prueba manual mínima

1. Crear un concurso de prueba.
2. Añadir una fase.
3. Crear desde la fase una obra manual.
4. Comprobar que aparece en la fase y en Obras.
5. Buscar desde la fase una obra de Open Opus.
6. Añadirla.
7. Intentar añadirla de nuevo.
8. Confirmar que no se duplica.
9. Cerrar completamente la aplicación.
10. Abrirla de nuevo.
11. Comprobar concurso, fase, obra manual, obra de Open Opus y asignaciones.
12. Repetir la apertura de la biblioteca sin conexión.
13. Confirmar que los datos guardados siguen visibles.

### Fuera del alcance de esta tarea

- nuevos estados de preparación;
- calendario;
- recordatorios;
- notificaciones;
- web;
- backend;
- cuentas;
- sincronización;
- rediseño general;
- cambios de modelos;
- cambios de versión;
- resolver la eliminación de obras asignadas;
- consolidar todas las vistas duplicadas de edición;
- modificar el sistema de archivado.

### Definición de completado

La tarea solo estará terminada cuando:

- el recorrido esté implementado;
- compile en un entorno compatible;
- se ejecute;
- el usuario complete las pruebas manuales;
- la persistencia se confirme después de cerrar y reabrir;
- no haya regresiones observadas;
- el usuario decida si el cambio justifica una nueva versión.

