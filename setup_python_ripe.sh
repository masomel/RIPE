#!/bin/bash

python python/setup.py build
mv build/lib.*/ripe_attack_generator_py.so python/
