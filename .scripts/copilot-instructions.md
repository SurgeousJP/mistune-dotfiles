You are an expert in TypeScript, Angular, and scalable web application development. You write maintainable, performant, and accessible code following Angular and TypeScript best practices.

## TypeScript Best Practices
- Use strict type checking
- Prefer type inference when the type is obvious
- Avoid the `any` type; use `unknown` when type is uncertain
- If an object may be null or undefined, accessing its properties must be accompanied by null checks (?.) or default values (??).
- If an object may be null or undefined, avoid using it in expressions without checks, following the null/undefined safety principles in common pitfalls section.

## 🟩 Angular Best Practices (v13-Compatible)

### 🧩 Architecture

  - Use **NgModules** (standalone components were introduced in Angular v14+).
  - Organize your app using **Core**, **Shared**, and **Feature** modules.
  - Enable **AOT compilation** and **build optimizations** for production builds.
  - Implement **lazy loading** for feature modules to improve startup performance.

-----

### ⚙️ Components

  - Keep components **small** and **focused** on a single responsibility.
  - Use **@Input()** and **@Output()** for data flow between components.
  - Set
    ```ts
    changeDetection: ChangeDetectionStrategy.OnPush
    ```
    to reduce change detection overhead.
  - Prefer **inline templates and styles** for small, reusable components.
  - Use **Reactive Forms** over Template-driven forms for better scalability and testability.
  - Use `ngClass` and `ngStyle` sparingly; prefer **static class and style bindings** when possible.
  - Use `ViewEncapsulation.Emulated` (default) or `None` only when necessary.

-----

### 🧠 State Management

  - Use **RxJS Subjects/BehaviorSubjects** for local component state.
  - Use **selectors** and **pure functions** to compute derived state.
  - Keep all state transformations **pure and predictable**.
  - Use libraries like **NgRx** or **Akita** for complex, app-wide state.

-----

### 🧾 Templates

  - Keep templates **simple** and **avoid putting logic in HTML**.
  - Use **structural directives** (`*ngIf`, `*ngFor`, `*ngSwitch`) correctly.
  - Use the **async pipe** (`| async`) to subscribe to observables and manage cleanup automatically.
  - Use **trackBy** with `*ngFor` for better list rendering performance.
  - Avoid deeply nested or overly complex templates; **move logic to the component class**.

-----

### 🧰 Services

  - Design each service around a **single responsibility**.
  - Use
    ```ts
    @Injectable({ providedIn: 'root' })
    ```
    for **singleton services**.
  - Use **constructor injection** for dependencies.
  - Keep services **stateless** where possible; handle state in dedicated stores or subjects.
  - Avoid **circular dependencies** between services and modules.

-----

### 🖼️ Assets & Images

  - Use standard `<img>` elements with proper **srcset** and `loading="lazy"`.
  - **Optimize images** at build time (e.g., using build tools or external pipelines).
  - Use **SVGs** for icons whenever possible.

-----

### 🚀 Performance & Accessibility

  - Use **trackBy** in lists.
  - Use **pure pipes** for expensive transformations.
  - **Prefetch or preload** critical routes.
  - Follow **ARIA guidelines** for accessibility.
  - Test with **Lighthouse** and **Angular DevTools** for performance and accessibility insights.

### Common Pitfalls

  - Object is possibly 'undefined' in variable usage, use the safe navigation operator (?.) to avoid errors.
  - Null/undefined safety principles: Strict null checks rule in Typescript, always handle null and undefined values explicitly, use nullish checks (??) or optional chaining (?.) where appropriate
  Example:
  ```ts
  if (user.age !== undefined && user.age > 18) {
    // safe guard check
  }
  ```
