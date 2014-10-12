""" Run scipy tests """
from __future__ import print_function

import sys

from distutils.version import LooseVersion

import numpy
import scipy

EXCLUDE_TESTS = []

if (LooseVersion(numpy.__version__) >= '1.9' and
    LooseVersion(scipy.__version__) <= '1.4.0'):
    EXCLUDE_TESTS += [
        # https://github.com/scipy/scipy/issues/3853
        'test_no_64',
        'test_resiliency_all_32',
        'test_resiliency_all_64',
        'test_resiliency_limit_10',
        'test_resiliency_random',
        'test_ufunc_object_array',
        'test_unary_ufunc_overrides',
        'test_binary_ufunc_overrides',
    ]

extra_argv = ['--exclude=' + regex for regex in EXCLUDE_TESTS]

res = scipy.test(extra_argv = extra_argv)

sys.exit(not res.wasSuccessful())
