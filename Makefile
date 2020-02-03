build: flutter-build pwa-build cp-manifest

flutter-build:
	flutter build web

pwa-build:
	dart2js -o ./build/web/pwa.dart.js ./web/pwa.dart

cp-all:
	cp -R ./web/launcher-icon/ ./build/web/launcher-icon/ && \
	cp ./web/manifest.json ./build/web/manifest.json && \
	cp ./web/favicon.ico ./build/web/favicon.ico

