# Security Policy

## Supported Versions

Only the latest published version of BBServices receives security fixes.

| Version | Supported |
| ------- | --------- |
| 4.x     | Yes       |
| < 4.0   | No        |

## Reporting a Vulnerability

**Please do not open a public GitHub issue for security vulnerabilities.**

Report vulnerabilities by emailing **developement@bigbearstudios.co.uk** with the subject line `[bbservices] Security Vulnerability`.

Include as much of the following as possible:

- A description of the vulnerability and its potential impact
- Steps to reproduce or a minimal proof-of-concept
- The version(s) of BBServices affected
- Any suggested mitigation or fix

You can expect an acknowledgement within **5 business days**. We will aim to release a fix within **30 days** of a confirmed report, depending on severity and complexity.

## Disclosure Policy

We follow a coordinated disclosure process:

1. You report the vulnerability privately.
2. We confirm receipt and begin investigation.
3. We develop and test a fix.
4. We publish a patched release and credit you in the changelog (unless you prefer to remain anonymous).
5. You are free to publish details after the fix has been released.

## Scope

BBServices is a lightweight service object framework with no built-in network I/O, database access, or external system integrations. Security issues in consuming applications that arise from misuse of the library (e.g. passing unsanitised user input to `on_run`) are outside scope — those are the responsibility of the consuming application.

Issues that are in scope include:

- Vulnerabilities in the gem itself that could affect any consuming application
- Dependency vulnerabilities introduced by the gem's declared dependencies

## Security Considerations for Consumers

When building services with BBServices, keep the following in mind:

- **Input validation** — BBServices does not validate or sanitise parameters passed to `initialize`. Validate and sanitise all user-supplied data before passing it into a service.
- **Error exposure** — `service.error` and `service.errors` return raw exception objects. Avoid surfacing these directly to end users in production.
- **Exception propagation** — `run!` re-raises exceptions after recording them. Ensure your application handles these exceptions at an appropriate boundary to avoid leaking internal details.
