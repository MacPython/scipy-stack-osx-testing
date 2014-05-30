echo "python $PYTHON"
which $PYTHON

echo "pip $PIP"
which $PIP

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
    $PYTHON -c "import sys; import ${pkg}; sys.exit(not ${pkg}.test().wasSuccessful())"
    if [ $? -ne 0 ] ; then RET=1; fi
done

$PYTHON -c "import sys; import matplotlib; sys.exit(not matplotlib.test())"
if [ $? -ne 0 ] ; then RET=1; fi

if [ -z "$VENV" -a "${TEST}" != "macpython" ]; then
    BIN_PREFIX=''
else # pip always installs next to Python in virtualenvs, and for macpython
    PY_PREFIX=`$PYTHON -c 'import sys; print(sys.prefix)'`
    BIN_PREFIX="${PY_PREFIX}/bin/"
fi

${BIN_PREFIX}iptest
if [ $? -ne 0 ] ; then RET=1; fi

${BIN_PREFIX}nosetests pandas -A "not slow"
if [ $? -ne 0 ] ; then RET=1; fi

$PYTHON -c "import sys; import sympy; sys.exit(not sympy.test('/basic', '/util'))"
if [ $? -ne 0 ] ; then RET=1; fi

echo "done testing scipy stack"

# Set the return code
(exit $RET)

