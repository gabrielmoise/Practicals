// lib.h
// Copyright (c) 2018 J. M. Spivey

#include <stdarg.h>

#define NULL ((void *) 0)

/* do_print -- the device-independent guts of printf */
void do_print(void (*putch)(char), const char *fmt, va_list va);

/* sprintf -- print to string buffer */
int sprintf(char *buf, const char *fmt, ...);

/* atoi -- convert decimal string to int */
int atoi(char *p);

/* xtou -- convert hex string to unsigned */
unsigned xtou(char *p);
