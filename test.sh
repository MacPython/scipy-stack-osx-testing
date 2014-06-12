echo "python $PYTHON"
which $PYTHON

echo "pip $PIP"
which $PIP

PYTHON_TEST="$ARCH $PYTHON"

# Return code
RET=0

echo "sanity checks"
$PYTHON -c "import sys; print('\n'.join(sys.path))"
if [ $? -ne 0 ] ; then RET=1; fi
RET=`expr $RET + $?`
for pkg in numpy scipy matplotlib IPython pandas sympy nose
do
    $PYTHON -c "import ${pkg}; print(${pkg}.__version__, ${pkg}.__file__)"
    if [ $? -ne 0 ] ; then RET=1; fi
done

echo "unit tests"
for pkg in numpy scipy
do
    $PYTHON_TEST -c "import sys; import ${pkg}; sys.exit(not ${pkg}.test().wasSuccessful())"
    if [ $? -ne 0 ] ; then RET=1; fi
done

# Matplotlib testing
# Miss out known fails for Python 3.4
# https://github.com/matplotlib/matplotlib/pull/2981
$PYTHON_TEST ../mpl_tests.py -e test_override_builtins
if [ $? -ne 0 ] ; then RET=1; fi

if [ -z "$VENV" -a "${TEST}" != "macpython" ]; then
    BIN_PREFIX=''
else # pip always installs next to Python in virtualenvs, and for macpython
    PY_PREFIX=`$PYTHON_TEST -c 'import sys; print(sys.prefix)'`
    BIN_PREFIX="${PY_PREFIX}/bin/"
fi

${BIN_PREFIX}iptest
if [ $? -ne 0 ] ; then RET=1; fi

# Exclude failing + fixed-in-trunk test test_range_slice_outofbounds
# https://github.com/pydata/pandas/issues/7289
# Exclude dict order tests
# https://github.com/pydata/pandas/issues/7293
# Don't run slow tests otherwise travis will sometimes hit 50 minute timeout
${BIN_PREFIX}nosetests pandas -A "not slow" \
    -e test_range_slice_outofbounds \
    -e test_dict_complex -e test_dict_numpy_complex
if [ $? -ne 0 ] ; then RET=1; fi

$PYTHON_TEST -c "import sys; import sympy; sys.exit(not sympy.test('/basic', '/util'))"
if [ $? -ne 0 ] ; then RET=1; fi

echo "done testing scipy stack"

# Set the return code
(exit $RET)

