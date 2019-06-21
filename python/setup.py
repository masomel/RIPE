''' Build Python wrapper for RIPE benchmark

@author Marcela S. Melara
'''

from distutils.core import setup, Extension

module1 = Extension('ripe_attack_generator_py',
                    include_dirs = ['source'],
                    libraries = ['ripe64'],
                    library_dirs = ['/home/pyronia/cpython/RIPE/build'],
                    sources = ['python/ripe_attack_generator_py.c'],
)

setup (name = 'RIPE for Python',
       version = '0.1',
       description = 'Python wrapper for the RIPE security benchmark',
ext_modules = [module1])
