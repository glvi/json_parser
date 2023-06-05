#                                               -*- Autoconf -*-
# Process this file with autoconf to produce a configure script.

AC_PREREQ([2.71])
AC_INIT([Experimental JSON parser using Bison], [1.0], [info@glvi.de], [json], [https://github.com/glvi/json_parser/tree/main/bison/final])
AM_INIT_AUTOMAKE([foreign])
AC_CONFIG_SRCDIR([json.cc])
AC_CONFIG_HEADERS([config.h])

# Checks for programs.
: ${CXXFLAGS="-std=c++20"}
AC_PROG_CXX
AC_PROG_YACC
AC_PROG_LEX([noyywrap])
AM_PROG_LEX

# Checks for libraries.

# Checks for header files.

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADER_STDBOOL
AC_C_INLINE
AC_TYPE_SIZE_T
AC_TYPE_UINT16_T
AC_TYPE_UINT8_T
AC_CHECK_TYPES([ptrdiff_t])

# Checks for library functions.
AC_FUNC_ERROR_AT_LINE
AC_CHECK_FUNCS([strtoul])

AC_CONFIG_FILES([Makefile])
AC_OUTPUT
