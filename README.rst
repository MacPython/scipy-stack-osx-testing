###################################
Testing scipy-stack install on OS X
###################################

This repo is for testing the scipy stack on MacOS X for a wide range of Python
versions.  The repo runs tests on Mac OS 10.9 as provided by the Travis-CI `Mac
environment <http://about.travis-ci.org/docs/user/osx-ci-environment/>`_.

Most of the code came from the `Matplotlib OSX testing
<https://github.com/matplotlib/mpl_mac_testing>`_ repository, written by Matt
Terry.

*************
Running tests
*************

You will need to be a member of the `scipy-stack-osx-testers <https://github.com/orgs/MacPython/teams/scipy-stack-testers>`_ in the `MacPython <https://github.com/MacPython>`_ github organization.

This gives you permission to trigger runs of the scipy-stack-osx-testing
matrix, by either:

* going to the `scipy-stack-osx-testing travis-ci page
  <https://travis-ci.org/MacPython/scipy-stack-osx-testing>`_ and pressing the
  rebuild button; or
* Making a new commit to https://github.com/MacPython/scipy-stack-osx-testing.

Of these two, the better way is to make a new commit, even if it is with::

    git commit --allow-empty

because this preserves the record of the previous builds for posterity, rather
than overwriting the last (as will happen with the 'rebuild' button on
travis-ci).

Triggering a build runs tests of the scipy stack against chosen candidate
wheels, for example release candidates.

For example, let's say you want to test a scipy release candidate, RC4.

You need to:

* build and upload the RC4 wheel to http://wheels.scikit-image.org;
* modify the scipy-stack-osx-testing ``.travis.yml`` to pick up the
  pre-release wheel rather than the standard released wheel;
* trigger the scipy-stack-osx-testing travis build using a commit to the repo.

For the scipy RC4 example, you would tag RC4, then trigger a build of that OSX
wheel via your OSX wheel building repo
(https://travis-ci.org/MacPython/scipy-wheels), check that the wheel reached
the rackspace container (http://wheels.scikit-image.org/), then check that
scipy-stack-osx-testing has lines like these at the top of ``.travis.yml``::

    # Rackspace container for bleeding edge builds
    - PRE_URL=http://wheels.scikit-image.org
    - NO_PRE=numpy # stuff that should be installed without --pre
    - PRE=scipy

You need the ``NO_PRE`` line for e.g. scipy to prevent pip installing a
development / pre-release version of numpy.

You can then trigger a build of this repo with by pushing a commit on
scipy-stack-osx-testing up to github.  This checks the RC against all the
standard scipy stack packages including numpy, matplotlib, pandas.

**************
Testing matrix
**************

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
