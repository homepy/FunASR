
# macos
brew install onnxruntime ffmpeg openssl


#conda create -n py39 python=3.9
#conda activate py39
#conda install pytorch==1.13.1 torchvision==0.14.1 torchaudio==0.13.1 pytorch-cuda=11.7 -c pytorch -c nvidia

conda create -n py311  python=3.11
conda activate py311
conda install pytorch==2.5.1 torchvision==0.20.1 torchaudio==2.5.1 pytorch-cuda=12.4 -c pytorch -c nvidia
pip install funasr humanfriendly websockets
cmake  -DCMAKE_BUILD_TYPE=release .. -DONNXRUNTIME_DIR=$(brew --prefix onnxruntime)  -DFFMPEG_DIR=$(brew --prefix ffmpeg)  -DOPENSSL_ROOT_DIR=$(brew --prefix openssl)
cmake  -DCMAKE_BUILD_TYPE=release .. -DONNXRUNTIME_DIR=$(brew --prefix onnxruntime)  -DFFMPEG_DIR=$(brew --prefix ffmpeg)  -DOPENSSL_ROOT_DIR=$(brew --prefix openssl)
make -j 4


# ubuntu
cmake  -DCMAKE_BUILD_TYPE=release .. -DONNXRUNTIME_DIR=/root/shared-nvme/funasr-deps/onnxruntime-linux-x64-1.14.0 -DFFMPEG_DIR=/root/shared-nvme/funasr-deps/ffmpeg-master-latest-linux64-gpl-shared  -DGPU=ON  -DCMAKE_INSTALL_PREFIX=/root/shared-nvme/funasr1

cmake  -DCMAKE_BUILD_TYPE=release .. -DONNXRUNTIME_DIR=/root/shared-nvme/funasr-deps/onnxruntime-linux-x64-1.14.0 -DFFMPEG_DIR=/root/shared-nvme/funasr-deps/ffmpeg-master-latest-linux64-gpl-shared  -DGPU=ON  -DCMAKE_INSTALL_PREFIX=/root/shared-nvme/funasr-py311-torch251


make -j 8
make install

# pytorch1
export LD_LIBRARY_PATH=/root/shared-nvme/funasr-py39-torch131/lib:/root/shared-nvme/funasr-deps/ffmpeg-master-latest-linux64-gpl-shared/lib:/root/shared-nvme/funasr-deps/onnxruntime-linux-x64-1.14.0/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/root/.conda/envs/py39/lib/python3.9/site-packages/torch/lib:$LD_LIBRARY_PATH

export MODELSCOPE_CACHE=/root/shared-nvme/cache/

/root/shared-nvme/funasr-py39-torch131/bin/funasr-wss-server \
  --gpu  \
  --listen-ip "0.0.0.0" --port 8090  \
  --io-thread-num 2 --decoder-thread-num 4 --model-thread-num 1 \
  --download-model-dir "/root/shared-nvme/cache/models" \
  --model-dir "/root/shared-nvme/cache/models/iic/speech_paraformer-large_asr_nat-zh-cn-16k-common-vocab8404-pytorch"  --model-revision "v2.0.5" --quantize false  --bladedisc false  \
  --vad-dir "/root/shared-nvme/cache/models/iic/speech_fsmn_vad_zh-cn-16k-common-pytorch"  --vad-revision "v2.0.4"  --vad-quant false  \
  --punc-dir "" --punc-revision "" \
  --itn-dir "" --itn-revision "" \
  --lm-dir "" --lm-revision "" \
  --hotword "" &


# pytorch2
export LD_LIBRARY_PATH=/root/shared-nvme/funasr-py311-torch251/lib:/root/shared-nvme/funasr-deps/ffmpeg-master-latest-linux64-gpl-shared/lib:/root/shared-nvme/funasr-deps/onnxruntime-linux-x64-1.14.0/lib:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/root/.conda/envs/py311/lib/python3.11/site-packages/torch/lib:$LD_LIBRARY_PATH


export MODELSCOPE_CACHE=/root/shared-nvme/cache/


/root/shared-nvme/funasr-py311-torch251/bin/funasr-wss-server \
  --gpu  \
  --listen-ip "0.0.0.0" --port 8090  \
  --io-thread-num 2 --decoder-thread-num 4 --model-thread-num 1 \
  --download-model-dir "/root/shared-nvme/cache/models" \
  --model-dir "/root/shared-nvme/cache/models/iic/speech_paraformer-large_asr_nat-zh-cn-16k-common-vocab8404-pytorch"  --model-revision "v2.0.5" --quantize false  --bladedisc false  \
  --vad-dir "/root/shared-nvme/cache/models/iic/speech_fsmn_vad_zh-cn-16k-common-pytorch"  --vad-revision "v2.0.4"  --vad-quant false  \
  --punc-dir "" --punc-revision "" \
  --itn-dir "" --itn-revision "" \
  --lm-dir "" --lm-revision "" \
  --hotword "" &


  python3 ./funasr_wss_client.py  --host localhost --port 8090 --audio_in "/root/shared-nvme/FunASR/audio/asr_example.wav" --audio_fs 16000 --chunk_size "5, 10, 5" --chunk_interval "10" --mode "offline" --ssl 0 --use_itn 0
  python3 ./funasr_wss_client.py  --host localhost --port 8090 --audio_in "/root/shared-nvme/FunASR/audio/8k16bit.pcm" --audio_fs 8000 --chunk_size "5, 10, 5" --chunk_interval "10" --mode "offline" --ssl 0 --use_itn 0


  /root/shared-nvme/funasr-py311-torch251/bin/vtcc-funasr-wss-server   --gpu    --listen-ip "0.0.0.0" --port 8090    --io-thread-num 2 --decoder-thread-num 4 --model-thread-num 1   --download-model-dir "/root/shared-nvme/cache/models"   --model-dir "/root/shared-nvme/cache/models/iic/speech_paraformer-large_asr_nat-zh-cn-16k-common-vocab8404-pytorch"  --model-revision "v2.0.5" --quantize false  --bladedisc false    --vad-dir "/root/shared-nvme/cache/models/iic/speech_fsmn_vad_zh-cn-16k-common-pytorch"  --vad-revision "v2.0.4"  --vad-quant false    --punc-dir "" --punc-revision ""   --itn-dir "" --itn-revision ""   --lm-dir "" --lm-revision ""   --hotword "" &