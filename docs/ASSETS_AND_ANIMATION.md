# Assets and animation map

| Purpose | Path | Runtime? | How to regenerate |
|---|---|---:|---|
| Main logo / app icon | `assets/images/app_icon.png` | Yes | `dart run flutter_launcher_icons` |
| Native launch image | `assets/images/native_splash_mark.png` | Yes, native pre-Flutter splash | `dart run flutter_native_splash:create` |
| Old splash GIF | `assets/images/nexacart_splash.gif` | No | Kept only as optional reference |
| UI concept images | `assets/design_reference/` | No | Design reference only |

## Runtime animations

- Splash: fade + scale + halo in `features/splash/presentation/splash_screen.dart`.
- Navigation: 260 ms fade/slide in `core/navigation/animated_page.dart`.
- Favorite heart: `AnimatedSwitcher` + `ScaleTransition` in `product_card.dart` and Product Details.
- Product card entrance: subtle `TweenAnimationBuilder` scale.

The interactive application never uses a complete screen image as a substitute for widgets or logic.

`assets/images/splash_logo.png` is retained as the original full-size logo artwork. The native splash now uses the padded `native_splash_mark.png` so the OS splash mask/frame has breathing room and does not visually clash with the icon's own rounded tile.
