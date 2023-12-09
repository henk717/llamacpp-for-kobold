#!/bin/bash
if [ ! -f "bin/micromamba" ]; then
	wget -qO- https://anaconda.org/conda-forge/micromamba/1.5.3/download/linux-64/micromamba-1.5.3-0.tar.bz2 | tar -xvj bin/micromamba
fi

if [[ ! -f "conda/envs/linux/bin/python" || $1 == "rebuild" ]]; then
	bin/micromamba create --no-shortcuts -r conda -n linux -f environment.yaml -y
	bin/micromamba create --no-shortcuts -r conda -n linux -f environment.yaml -y
	bin/micromamba run -r conda -n linux make clean
fi

bin/micromamba run -r conda -n linux make LLAMA_OPENBLAS=1 LLAMA_CLBLAST=1 LLAMA_CUBLAS=1 LLAMA_PORTABLE=1

if [[ $1 == "rebuild" ]]; then
	echo Rebuild complete, you can now try to launch Koboldcpp.
else
	bin/micromamba run -r conda -n linux python koboldcpp.py $*
fi