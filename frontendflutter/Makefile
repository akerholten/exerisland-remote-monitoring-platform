
.PHONY: run
run:
	flutter run -d chrome --web-port 3000

.PHONY: upgrade
upgrade:
	flutter upgrade

.PHONY: doctor
doctor:
	flutter doctor -v

.PHONY: tools
tools:
	flutter pub run build_runner build --delete-conflicting-outputs

.PHONY: build
build:
	rm -r build; flutter build web

.PHONY: debug-release
debug-release:
	rm -r build; flutter run -d chrome --web-port 3000 --profile --verbose;
