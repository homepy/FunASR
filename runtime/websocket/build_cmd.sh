
brew install onnxruntime ffmpeg openssl
cmake  -DCMAKE_BUILD_TYPE=release .. -DONNXRUNTIME_DIR=$(brew --prefix onnxruntime)  -DFFMPEG_DIR=$(brew --prefix ffmpeg)  -DOPENSSL_ROOT_DIR=$(brew --prefix openssl)
cmake  -DCMAKE_BUILD_TYPE=release .. -DONNXRUNTIME_DIR=$(brew --prefix onnxruntime)  -DFFMPEG_DIR=$(brew --prefix ffmpeg)  -DOPENSSL_ROOT_DIR=$(brew --prefix openssl)
make -j 4