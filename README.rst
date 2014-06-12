###################################
Testing scipy-stack install on OS X
###################################

This repo is for testing the scipy stack on MacOS X for a wide range of Python
versions.  The repo runs tests on Mac OS 10.9 as provided by the Travis-CI `Mac
environment <http://about.travis-ci.org/docs/user/osx-ci-environment/>`_.

Most of the code came from the `Matplotlib OSX testing
<https://github.com/matplotlib/mpl_mac_testing>`_ repository, written by Matt
Terry.

Testing matrix:

+---------------+----------------+------------------------------+--------------+
| Python Source | Python Version |   virtual environment [#VE]_ |  32/64 bits  |
+===============+================+==============================+==============+
| python.org_   | 2.7.6          |   No                         |  64          |
+---------------+----------------+------------------------------+--------------+
| python.org_   | 2.7.6          |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+
| python.org_   | 2.7.6          |   No                         |  32          |
+---------------+----------------+------------------------------+--------------+
| python.org_   | 3.3.5          |   No                         |  64          |
+---------------+----------------+------------------------------+--------------+
| python.org_   | 3.3.5          |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+
| python.org_   | 3.3.5          |   No                         |  32          |
+---------------+----------------+------------------------------+--------------+
| python.org_   | 3.4.1          |   No                         |  64          |
+---------------+----------------+------------------------------+--------------+
| python.org_   | 3.4.1          |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+
| python.org_   | 3.4.1          |   No                         |  32          |
+---------------+----------------+------------------------------+--------------+
| system        | 2.7            |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+
| brew_         | 2.7            |   No                         |  64          |
+---------------+----------------+------------------------------+--------------+
| brew_         | 2.7            |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+
| brew_         | 3.4            |   No                         |  64          |
+---------------+----------------+------------------------------+--------------+
| brew_         | 3.4            |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+
| Macports_     | 2.7            |   No                         |  64          |
+---------------+----------------+------------------------------+--------------+
| Macports_     | 2.7            |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+
| Macports_     | 3.3            |   No                         |  64          |
+---------------+----------------+------------------------------+--------------+
| Macports_     | 3.3            |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+
| Macports_     | 3.4            |   No                         |  64          |
+---------------+----------------+------------------------------+--------------+
| Macports_     | 3.4            |   virtualenv                 |  64          |
+---------------+----------------+------------------------------+--------------+

We don't test system python without a virtualenv, because system python has a
special path
``/System/Library/Frameworks/Python.framework/Versions/2.7/Extras/lib/python``
that is above standard user and system site-packages in ``sys.path``. This
directory has versions of numpy, scipy and matplotlib.  A pip install of any of
these packages will install the package below the ``Extras/lib/python``
directory on ``sys.path``, so won't get picked up.  It so happens that the
matplotlib in ``Extras/lib/python`` on 10.9 fails lots of tests due to missing
PIL, so tests on system python, without virtualenv, will always fail, and in any
case won't test the newly installed numpy, scipy, matplotlib.

.. _python.org: http://python.org/download/
.. _brew: brew.sh
.. _Macports: www.macports.org
.. [#VE] "virtualenv" identifies the classic virtual environment library
   available to Python 2 and beyond.  "pyvenv" identifies the virtual
   environment library included in the standard library starting with Python
   3.3.
