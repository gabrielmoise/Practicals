// lab4-phos/today.c
// Copyright (c) 2018 J. M. Spivey

#include "phos.h"
#include "lib.h"
#include <string.h>

#define MAY (USER + 0)
#define FARAGE (USER + 1)

void put_string(char *s) {
    for (char *p = s; *p != '\0'; p++)
        serial_putc(*p);
}

char *slogan[] = {
    "no deal is better than a bad deal\n",
    "BREXIT MEANS BREXIT!\n"
};

void process(int arg) {
    message m;

    while (1) {
        if (arg == 1) receive(MAY, &m);

        put_string(slogan[arg]);
        
        if (arg == 0) {
            sendrec(FARAGE, &m);
        } else {
            send(MAY, &m);
        }
    }
}


void init(void) {
    serial_init();
    start(MAY, "May", process, 0, STACK);
    start(FARAGE, "Farage", process, 1, STACK);
}
