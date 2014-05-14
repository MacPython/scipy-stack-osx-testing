echo "python $PYTHON"
which $PYTHON

echo "pip $PIP"
which $PIP

echo "sanity checks"
$PYTHON -c "import sys; print('\n'.join(sys.path))"
for pkg in numpy scipy matplotlib IPython pandas sympy nose
do
    $PYTHON -c "import ${pkg}; print(${pkg}.__version__, ${pkg}.__file__)"
done

echo "unit tests"
for pkg in numpy scipy
do
    $PYTHON -c "import sys; import ${pkg}; sys.exit(not ${pkg}.test().wasSuccessful())"
done
$PYTHON -c "import sys; import matplotlib; sys.exit(not matplotlib.test())"
PYPREFIX=`$PYTHON -c 'import sys; print(sys.prefix)'`
if [ -z "$VENV" -a "${TEST}" != "macpython" ]; then
    BIN_PREFIX=''
else # pip always installs next to Python in virtualenvs, and for macpython
    PYPREFIX=`$PYTHON -c 'import sys; print(sys.prefix)'`
    BIN_PREFIX="${PY_PREFIX}/bin/"
fi
${BIN_PREFIX}iptest
${BIN_PREFIX}nosetests pandas -e test_fred_multi -e test_fred_parts
$PYTHON -c "import sys; import sympy; sys.exit(not sympy.test('/basic', '/util'))"

echo "done testing scipy stack"
