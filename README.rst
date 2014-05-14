Testing Scipy stack wheel install on MacOS X on Travis-CI
---------------------------------------------------------

This repo will facilitate building and testing the scipy stack
on MacOS X for a wide range of installation methods and Python versions.  The
repo tests on Mac OS 10.9 as provided by the Travis-CI
`Mac environment <http://about.travis-ci.org/docs/user/osx-ci-environment/>`_
Mac OS X testing environment.

Unless denoted otherwise, Python dependencies are auto-installed by pip.

Testing matrix:

+---------------+----------------+------------------------------+
| Python Source | Python Version |   virtual environment [#VE]_ |
+===============+================+==============================+
| `python.org`_ | 2.7.6          |   No                         |
+---------------+----------------+------------------------------+
| `python.org`_ | 3.3.5          |   No                         |
+---------------+----------------+------------------------------+
| `python.org`_ | 3.4.0          |   No                         |
+---------------+----------------+------------------------------+
| system        | 2.7            |   No                         |
+---------------+----------------+------------------------------+
| system        | 2.7            |   virtualenv                 |
+---------------+----------------+------------------------------+
| brew_         | 2.7            |   No                         |
+---------------+----------------+------------------------------+
| brew_         | 2.7            |   virtualenv                 |
+---------------+----------------+------------------------------+
| brew_         | 3.3            |   No                         |
+---------------+----------------+------------------------------+
| brew_         | 3.3            |   virtualenv                 |
+---------------+----------------+------------------------------+
| Macports_     | 2.6            |   No                         |
+---------------+----------------+------------------------------+
| Macports_     | 2.6            |   virtualenv                 |
+---------------+----------------+------------------------------+
| Macports_     | 2.7            |   No                         |
+---------------+----------------+------------------------------+
| Macports_     | 2.7            |   virtualenv                 |
+---------------+----------------+------------------------------+
| Macports_     | 3.2            |   No                         |
+---------------+----------------+------------------------------+
| Macports_     | 3.2            |   virtualenv                 |
+---------------+----------------+------------------------------+
| Macports_     | 3.3            |   No                         |
+---------------+----------------+------------------------------+
| Macports_     | 3.3            |   virtualenv                 |
+---------------+----------------+------------------------------+

.. _python.org: http://python.org/download/
.. _brew: brew.sh
.. _Macports: www.macports.org
.. _`1.6.2 source`: http://sourceforge.net/projects/libpng/files/libpng16/1.6.3/
.. _`2.5.0.1 source`: http://sourceforge.net/projects/freetype/files/freetype2/2.5.0/
.. _`1.7.1 binary installer`: http://sourceforge.net/projects/numpy/files/NumPy/1.7.1/

.. [#DU] The latest python-dateutil (2.1) fails to install on Python 3.3.

.. [#VE] "virtualenv" identifies the classic virtual environment library
   available to Python 2 and beyond.  "pyvenv" identifies the virtual
   environment library included in the standard library starting with Python
   3.3.

At present, we install a minimal set of backends.  Backend testing coverage
will expand as the repo matures.
