// lab4-phos/today.c
// Copyright (c) 2018 J. M. Spivey

#include "phos.h"
#include "lib.h"
#include <string.h>

#define MAY (USER + 0)
#define FARAGE (USER + 1)
#define PRESENTER (USER + 2)

void put_string(char *s) {
    for (char *p = s; *p != '\0'; p++)
        serial_putc(*p);
}

char *slogan[] = {
    "no deal is better than a bad deal\n",
    "BREXIT MEANS BREXIT!\n"
};

void process(int n) {
    message m;

    while (1) {
        receive(PRESENTER, &m);
        put_string(slogan[n]);
        send(PRESENTER, &m);
    }
}

void presenter_task(int arg) {
    int now = 0, id;
    message m;

    while (1) {
        if (now == 0) 
            id = FARAGE;
        else
            id = MAY;

        sendrec(id, &m);
        now ^= 1;
    }
}

void init(void) {
    serial_init();
    start(MAY, "May", process, 0, STACK);
    start(FARAGE, "Farage", process, 1, STACK);
    start(PRESENTER, "Presenter", presenter_task, 0, STACK);
}
