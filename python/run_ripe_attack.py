'''
Runs a single RIPE attack in Python.

@author: Marcela S. Melara
'''

# Originally developed by Nick Nikiforakis to assist the automated testing
# using the RIPE evaluation tool
#
# Released under the MIT license (see file named LICENSE)
#
# This program is part the paper titled
# RIPE: Runtime Intrusion Prevention Evaluator
# Authored by: John Wilander, Nick Nikiforakis, Yves Younan,
#              Mariam Kamkar and Wouter Joosen
# Published in the proceedings of ACSAC 2011, Orlando, Florida
#
# Please cite accordingly.

from ripe_attack_generator import generate_attack
import sys

BASE_ATTACK_PARAMS = 5

if __name__ == '__main__':
    if len(sys.argv) < BASE_ATTACK_PARAMS*2:
        print("Usage: python [-t <technique>]")
        exit(-1)

    generate_attack(" ".join(sys.argv))
