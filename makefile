#!/bin/make
.PHONY: install uninstall debpackage

PREFIX = /usr
VERSION = 0.2

LIB_SRC_DIR = Scanner
LIB_DIR = ${PREFIX}/lib/perl5
LIB_INSTALL_DIR = ${LIB_DIR}/${LIB_SRC_DIR}

BIN_DIR = ${PREFIX}/bin

LIBS = ${LIB_SRC_DIR}/Basic.pm ${LIB_SRC_DIR}/Tiff.pm
EXECS = pdfscan

install: ${LIBS} ${EXECS} ${LIB_INSTALL_DIR}
	#Place the scanner files in the lib dir
	cp ${LIBS} ${LIB_INSTALL_DIR}
	#Now copy the executables to the bin dir
	cp ${EXECS} ${BIN_DIR}
	chmod +x ${addprefix ${BIN_DIR}/,${EXECS}}

uninstall: 
	-rm -f ${addprefix ${LIB_DIR}/,${LIBS}}
	-rmdir --ignore-fail-on-non-empty ${LIB_INSTALL_DIR}
	-rm -f ${addprefix ${BIN_DIR}/,${EXECS}}
	
PACKAGE_BUILD_DIR = pdfscan-${VERSION}
debpackage: ${LIBS} ${EXECS}
	mkdir ${PACKAGE_BUILD_DIR}
	mkdir ${PACKAGE_BUILD_DIR}/Scanner
	cp ${LIBS} ${PACKAGE_BUILD_DIR}/Scanner
	cp ${EXECS} ${PACKAGE_BUILD_DIR}
	mkdir ${PACKAGE_BUILD_DIR}/debian


#Make the lib directory if it doesnt already exist
${LIB_INSTALL_DIR}:
	mkdir -p ${LIB_INSTALL_DIR}

