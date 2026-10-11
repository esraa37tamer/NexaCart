from pathlib import Path
import re, sys

root = Path(__file__).resolve().parents[1]
required = [
    'pubspec.yaml',
    'lib/main.dart',
    'lib/app.dart',
    'lib/core/navigation/app_router_delegate.dart',
    'lib/core/navigation/app_route_parser.dart',
    'lib/features/auth/presentation/pages/login_screen.dart',
    'lib/features/auth/presentation/pages/signup_screen.dart',
    'lib/features/products/presentation/pages/products_screen.dart',
    'lib/features/products/presentation/pages/product_detail_screen.dart',
    'lib/features/cart/presentation/pages/cart_screen.dart',
    'lib/features/favorites/presentation/pages/favorites_screen.dart',
    'lib/features/orders/presentation/pages/order_history_screen.dart',
    'assets/images/app_icon.png',
    'assets/images/nexacart_splash.gif',
]
errors=[]
for rel in required:
    if not (root/rel).exists(): errors.append(f'Missing required file: {rel}')

# Verify relative/package local imports resolve.
lib=root/'lib'
for f in lib.rglob('*.dart'):
    text=f.read_text(encoding='utf-8')
    for match in re.finditer(r"import\s+'([^']+)'", text):
        imp=match.group(1)
        if imp.startswith('package:nexacart/'):
            target=lib/imp[len('package:nexacart/'):]
        elif imp.startswith('.'):
            target=(f.parent/imp).resolve()
        else:
            continue
        if not target.exists(): errors.append(f'{f.relative_to(root)} -> missing import {imp}')

pub=(root/'pubspec.yaml').read_text(encoding='utf-8')
for token in ['flutter_bloc:', 'dio:', 'realm:', 'firebase_core:', 'firebase_auth:', 'get_it:', 'google_sign_in:', 'flutter_facebook_auth:', 'shared_preferences:']:
    if token not in pub: errors.append(f'Missing dependency {token}')

android=(root/'android/app/build.gradle.kts').read_text(encoding='utf-8')
for token in ['compileSdk = 37', 'targetSdk = 36', 'minSdk = 24', 'JavaVersion.VERSION_17']:
    if token not in android: errors.append(f'Android SDK config missing: {token}')

if errors:
    print('STATIC CHECK FAILED')
    print('\n'.join(f'- {e}' for e in errors))
    sys.exit(1)
# Guard against UI regressions that previously exposed implementation details.
all_dart = '\n'.join(f.read_text(encoding='utf-8') for f in lib.rglob('*.dart'))
for forbidden in ['student@nexacart.dev', "hintText:'Realm session'", 'Text(\'Realm session\')']:
    if forbidden in all_dart:
        errors.append(f'Forbidden demo/internal UI text found: {forbidden}')

if errors:
    print('STATIC CHECK FAILED')
    print('\n'.join(f'- {e}' for e in errors))
    sys.exit(1)

print('STATIC CHECK PASSED')
print(f'Dart files checked: {len(list(lib.rglob("*.dart")))}')
print('Required screens, architecture files, dependencies and SDK settings are present.')
