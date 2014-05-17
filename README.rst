Testing Scipy stack wheel install on MacOS X on Travis-CI
---------------------------------------------------------

This repo will facilitate building and testing the scipy stack on MacOS X for a
wide range of installation methods and Python versions.  The repo tests on Mac
OS 10.9 as provided by the Travis-CI `Mac environment
<http://about.travis-ci.org/docs/user/osx-ci-environment/>`_ Mac OS X testing
environment.

Unless otherwise noted, Python dependencies are auto-installed by pip.

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
| brew_         | 3.4            |   No                         |
+---------------+----------------+------------------------------+
| brew_         | 3.4            |   virtualenv                 |
+---------------+----------------+------------------------------+
| Macports_     | 2.7            |   No                         |
+---------------+----------------+------------------------------+
| Macports_     | 2.7            |   virtualenv                 |
+---------------+----------------+------------------------------+
| Macports_     | 3.3            |   No                         |
+---------------+----------------+------------------------------+
| Macports_     | 3.3            |   virtualenv                 |
+---------------+----------------+------------------------------+
| Macports_     | 3.4            |   No                         |
+---------------+----------------+------------------------------+
| Macports_     | 3.4            |   virtualenv                 |
+---------------+----------------+------------------------------+

.. _python.org: http://python.org/download/
.. _brew: brew.sh
.. _Macports: www.macports.org
.. [#VE] "virtualenv" identifies the classic virtual environment library
   available to Python 2 and beyond.  "pyvenv" identifies the virtual
   environment library included in the standard library starting with Python
   3.3.
