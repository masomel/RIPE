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
    PyObject *arg_list = NULL;
    int num_args = 0;
    char **params = NULL;
    int i = 0;
    int ret = -1;
    
    if (!PyArg_ParseTuple(args, "O", &arg_list))
        return NULL;
    num_args = PyObject_Length(arg_list);
    if (num_args < 0 || num_args != 6)
        return NULL;
    params = (char **) malloc(num_args*sizeof(char *));
    if (params == NULL)
        return NULL;

    for (i = 0; i < num_args; i++) {
        PyObject *item;
        item = PyList_GetItem(arg_list, i);
        if (!PyString_Check(item))
            params[i] = NULL;
        params[i] = PyString_AsString(item);
	//printf("Got param: \"%s\"\n", params[i]);
    }
    
    ret = ripe_main(num_args, params);
    free(params);
    return Py_BuildValue("i", ret);
}

static const char moduledocstring[] = "Python wrapper for the RIPE security benchmark";

PyMethodDef ripe_methods[] = {
    {"generate_attack", (PyCFunction)generate_attack_py, METH_VARARGS, "Generates the specified memory attack from the RIPE suite"},
    {NULL, NULL, 0, NULL}
};

PyMODINIT_FUNC
initripe_attack_generator_py(void) {
    PyObject *mod = Py_InitModule("ripe_attack_generator_py", ripe_methods);

    if (mod == NULL)
        return;
}
