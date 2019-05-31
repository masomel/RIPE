/**
 * Python wrapper for the RIPE security benchmark.
 *
 *@author Marcela S. Melara
 */

/* RIPE was originally developed by John Wilander (@johnwilander)
 * and was debugged and extended by Nick Nikiforakis (@nicknikiforakis)
 *
 * Released under the MIT license (see file named LICENSE)
 *
 * This program is part the paper titled
 * RIPE: Runtime Intrusion Prevention Evaluator
 * Authored by: John Wilander, Nick Nikiforakis, Yves Younan,
 *              Mariam Kamkar and Wouter Joosen
 * Published in the proceedings of ACSAC 2011, Orlando, Florida
 *
 * Please cite accordingly.
 */

#include <Python.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>

#include "ripe_attack_generator.h"

static PyObject * generate_attack_py(PyObject *self, PyObject *args) {
    const char *params;
    int num_params;
    int ret;

    if (!PyArg_ParseTuple(args, "s#", &params, &num_params))
        return NULL;
    ret = main(num_params/2, &params);
    return Py_BuildValue("i", ret);
}

static const char moduledocstring[] = "Python wrapper for the RIPE security benchmark";

PyMethodDef ripe_methods[] = {
    {"generate_attack", (PyCFunction)generate_attack_py, METH_VARARGS, "Generates the specified memory attack from the RIPE suite"},
    {NULL, NULL, 0, NULL}
};

PyMODINIT_FUNC
initripe_attack_generator(void) {
    PyObject *mod = Py_InitModule("ripe_attack_generator", ripe_methods);

    if (mod == NULL)
        return;
}
