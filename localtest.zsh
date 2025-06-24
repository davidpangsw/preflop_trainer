
flutter build web --release --wasm \
&& cd ./build/web \
&& python3 -m http.server 8000