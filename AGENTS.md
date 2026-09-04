# AGENTS.md

## Mission

Build ContestTracker as a reliable, local-first product for pianists who prepare competitions. The native SwiftUI app and the future web app should share product concepts and user experience, but they do not have to share implementation code.

## Current constraints

- The native app lives in `SwiftPlayground/` as a Swift Playgrounds `.swiftpm` application.
- Keep the deployment target at iPadOS 17.6 unless a reviewed decision changes it.
- The project must remain usable without an account or network connection for its core contest, phase, work, and repertoire workflows.
- Xcode 16.2 on the available Mac is the final native build environment. Windows and cloud agents may edit and review Swift, but cannot claim a native build passed unless it was actually verified on a compatible Mac or in Swift Playgrounds.
- Public distribution of the product should be led by the future web/PWA experience. An IPA in GitHub is a development artifact, not a substitute for normal App Store distribution or signing.
- Do not edit `SwiftPlayground/Package.swift` by hand; Swift Playgrounds marks it as generated.

## How to work

1. Read `README.md`, `CONTRIBUTING.md`, and relevant files before changing code.
2. Keep each task and pull request focused on one outcome.
3. Preserve a working state. Avoid broad rewrites unless an accepted decision record justifies one.
4. Prefer Apple frameworks and simple solutions. Add a dependency only with a written reason covering maintenance, license, compatibility, and size.
5. Treat every SwiftData model or relationship change as high risk. Explain migration impact and verify persistence after relaunch.
6. For calendar and reminders, first evaluate local Apple integrations such as EventKit and UserNotifications. A backend is not the default.
7. Never add secrets, signing certificates, provisioning profiles, private user data, or API keys to the repository.
8. Record durable product or architecture decisions in `docs/DECISIONS.md`.
9. Update `docs/ROADMAP.md` only when priorities or completion state genuinely change.
10. Write user-facing copy and project documentation in Spanish unless the task requests another language. Code identifiers stay in conventional English.

## Definition of done

A change is done only when:

- The requested behavior is implemented and the relevant edge cases were considered.
- Existing data is preserved, or migration/reset consequences are explicitly documented.
- Accessibility and iPad layouts were considered for UI changes.
- Verification is reported honestly: distinguish code review, static inspection, Swift Playgrounds run, simulator run, and physical-device run.
- Documentation is updated when behavior, constraints, or decisions changed.
- The pull request explains what changed, why, how it was verified, and whether persistence is affected.

## Product boundaries

- Do not introduce accounts, sync, or a backend until a concrete user story requires them and a decision record defines data ownership, privacy, offline behavior, cost, and failure recovery.
- Do not make the future website a pixel-for-pixel port of the iPad UI. Preserve the same domain model and brand while designing for the web.
- Do not make App Store publication a prerequisite for useful progress. The native app can remain a personal/test distribution while the web becomes the public product.
