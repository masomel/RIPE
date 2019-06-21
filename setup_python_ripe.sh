#!/bin/bash

make RIPE_MODE=LIB ripe_lib
python python/setup.py build
mv build/lib.*/ripe_attack_generator_py.so python/
