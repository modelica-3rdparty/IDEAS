########################################################################################
# Makefile for the regression tests that are run on travis - based on IBPSA version
########################################################################################
ROOT = ../../../..

test-documentation:
	(cd $(ROOT)/IDEAS; python3.6 ../bin/runUnitTests.py --validate-html-only)

test-experiment-setup:
	(cd $(ROOT)/IDEAS; python3.6 ../bin/runUnitTests.py --validate-experiment-setup)

test-autogenerated-files:
	# Check for package.order to be up to date
	(cd  $(ROOT)/IDEAS; \
	  python -c 'import buildingspy.development.refactor as r; \
	  r.write_package_order(".", recursive=True)'; \
	  git diff --exit-code . )

test-dymola:
	(cd $(ROOT)/IDEAS && python3.6 ../bin/runUnitTests.py --batch --single-package $(PACKAGE) --tool dymola)

test-jmodelica:
	(cd $(ROOT)/IDEAS && python3.6 ../bin/runUnitTests.py --batch --single-package $(PACKAGE) --tool jmodelica)
