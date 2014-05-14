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
for pkg in numpy scipy matplotlib
do
    $PYTHON -c "import sys; import ${pkg}; sys.exit(not ${pkg}.test().wasSuccessful())"
done
PYPREFIX=`$PYTHON -c 'import sys; print(sys.prefix)'`
$PYPREFIX/bin/iptest
$PYPREFIX/bin/nosetests pandas -e test_fred_multi -e test_fred_parts
$PYTHON -c "import sys; import sympy; sys.exit(not sympy.test('/basic', '/util'))"

echo "done testing scipy stack"
