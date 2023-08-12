sudo apt install libstdc++-12-dev

https://repo.radeon.com/amdgpu-install/
https://repo.radeon.com/amdgpu-install/5.4.2/ubuntu/jammy/amdgpu-install_5.4.50402-1_all.deb

sudo apt-get install ./amdgpu-install_5.4.50402-1_all.deb

amdgpu-install --usecase=rcom,hip,mllib --no-dkms
