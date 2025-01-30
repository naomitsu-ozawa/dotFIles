# COndaでllama.cppをビルドする方法
## 環境2025/01/30
- OS: Ubuntu
- Version: 24.04
## 準備
- Clone Repository.
```
git clone https://github.com/ggerganov/llama.cpp.git
or
ghq get https://github.com/ggerganov/llama.cpp.git
```
  
- Move to llama directory.
```
cd llama.cpp
```
  
- Create conda envs.
```
conda create -n build_test python=3.11
conda activate build_test
```
  
- Install cuda toolkit
```
conda install -c conda-forge cuda-toolkit
```
  
- Build llama.cpp
```
cmake -B build -DGGML_CUDA=ON
cmake --build build --config Release
```


