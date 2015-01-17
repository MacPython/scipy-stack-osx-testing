echo "python $PYTHON"
which $PYTHON_EXE

echo "pip $PIP_CMD"
which $PIP_CMD

PYTHON_TEST="$ARCH $PYTHON_EXE"

# Return code
RET=0

echo "sanity checks"
$PYTHON_EXE -c "import sys; print('\n'.join(sys.path))"
if [ $? -ne 0 ] ; then RET=1; fi
RET=`expr $RET + $?`
for pkg in numpy scipy matplotlib IPython pandas sympy nose
do
    $PYTHON_EXE -c "import ${pkg}; print(${pkg}.__version__, ${pkg}.__file__)"
    if [ $? -ne 0 ] ; then RET=1; fi
done

# Markupsafe
nosetests markupsafe
if [ $? -ne 0 ] ; then RET=1; fi

# Tornado
$PYTHON_TEST -m tornado.test.runtests
if [ $? -ne 0 ] ; then RET=1; fi

echo "unit tests"
# Numpy
if [ "$ARCH" == "arch -i386" ]; then
    # Travis machines have gcc version of gfortran; f2py needs flags for i386
    export LDFLAGS="-Wall -undefined dynamic_lookup -bundle -m32"
    export FARCH='-m32'
fi
$PYTHON_TEST -c "import sys; import numpy; sys.exit(not numpy.test().wasSuccessful())"
if [ $? -ne 0 ] ; then RET=1; fi
# Scipy
$PYTHON_TEST ../scipy_tests.py
if [ $? -ne 0 ] ; then RET=1; fi

# Matplotlib testing
# increase number of open files allowed for tests
# https://github.com/matplotlib/matplotlib/issues/3315
ulimit -n 4096
# Miss out known fails for Python 3.4
# https://github.com/matplotlib/matplotlib/pull/2981
$PYTHON_TEST ../mpl_tests.py -e test_override_builtins
if [ $? -ne 0 ] ; then RET=1; fi

iptest
if [ $? -ne 0 ] ; then RET=1; fi

# Exclude failing + fixed-in-trunk tests
# Error in test_fred fixed by f6f84db
# Error in test_clipboard known
# https://groups.google.com/d/msg/pydata/AzMPFAE9bhw/hs4H516gS4YJ
# Error in datetime parsing apparently addressed by 0621f9f
# dateindex conversion discussed on MPL issues; known fail for mpl 1.4.0
# Don't run slow tests otherwise travis will sometimes hit 50 minute timeout
$ARCH nosetests pandas -A "not slow" \
    -e test_clipboard \
    -e test_fred \
    -e test_replace_datetime \
    -e test_dateindex_conversion
if [ $? -ne 0 ] ; then RET=1; fi

$PYTHON_TEST -c "import sys; import sympy; sys.exit(not sympy.test('/basic', '/util'))"
if [ $? -ne 0 ] ; then RET=1; fi
$PYTHON_TEST -c "import sys; import statsmodels; sys.exit(not statsmodels.test().wasSuccessful())"
if [ $? -ne 0 ] ; then RET=1; fi

echo "done testing scipy stack"

# Set the return code
(exit $RET)

