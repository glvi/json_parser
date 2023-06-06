# -*-  mode: autoconf; coding: utf-8; indent-tabs-mode: nil;  -*- vi:ai:et:sw=2:
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.71])
AC_INIT([Experimental JSON parser using Bison], [1.0], [info@glvi.de], [json], [https://github.com/glvi/json_parser/tree/main/bison/final])
AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_SRCDIR([src/json.cc])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
: ${CXXFLAGS="-std=c++20"}
AC_PROG_CXX
AC_PROG_YACC
AC_PROG_LEX([noyywrap])

# Checks for libraries.
# (none required)

# Checks for header files.
# (none required)

# Checks for typedefs, structures, and compiler characteristics.
# (none required)

# Checks for library functions.
# (none required)

AC_CONFIG_FILES([Makefile src/Makefile])
AC_OUTPUT
