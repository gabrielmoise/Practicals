// lab2-gpio/heart.c
// Copyright (c) 2018 J. M. Spivey

#include "hardware.h"

/* delay -- pause for n microseconds */
void delay(unsigned n) {
    unsigned t = n << 1;
    while (t > 0) {
        // 500nsec per iteration at 16MHz
        nop(); nop(); nop();
        t--;
    }
}

static const unsigned heart[] = {
    0x28f0, 0x5e00, 0x8060
};
     
static const unsigned small[] = {
    0x2df0, 0x5fb0, 0x8af0
};

/* show -- display three rows of a picture n times */
void show(const unsigned *img, int n) {
    while (n-- > 0) {
        // Takes 15msec per iteration
        for (int p = 0; p < 3; p++) {
            GPIO_OUT = img[p];
            delay(5000);
        }
    }
}

//-------------------

int min(int x, int y) {if (x < y) return x; return y;}
int max(int x, int y) {if (x < y) return y; return x;}

int buttonA() {
    return (GPIO_IN & BIT(BUTTON_A)) == 0;
}

int buttonB() {
    return (GPIO_IN & BIT(BUTTON_B)) == 0;
}

int def_row[25] = {1, 2, 1, 2, 1,
                   3, 3, 3, 3, 3,
                   2, 1, 2, 3, 2,
                   1, 1, 1, 1, 1,
                   3, 2, 3, 2, 3};

int def_column[25] = {1, 4, 2, 5, 3,
                      4, 5, 6, 7, 8,
                      2, 9, 3, 9, 1,
                      8, 7, 6, 5, 4,
                      3, 7, 1, 6, 2};

int get_conf(int row, int col) {
    return (col << 4) | (row << 13);
}

void get_image(char* source, unsigned* dest) {
    int i;
    unsigned c[3];

    c[0] = c[1] = c[2] = 0;
    for (i = 0; i < 25; i++) {
        if (source[i] == '0')
            c[ def_row[i] - 1 ] |= 1 << (def_column[i] - 1);
    }

    dest[0] = get_conf(1, c[0]);
    dest[1] = get_conf(2, c[1]);
    dest[2] = get_conf(4, c[2]);
}

void rot_down(char* data) {
    int i, j;
    char aux[5];

    for (i = 0; i < 5; i++) aux[i] = data[20 + i];
    for (i = 19; i >= 0; i--) data[i + 5] = data[i];
    for (i = 0; i < 5; i++) data[i] = aux[i];
}

void rot_right(char* data) {
    int i, j;
    char aux[5];

    for (i = 0; i < 5; i++) aux[i] = data[4 + 5 * i];
    for (i = 24; i >= 0; i--) 
        if (i % 5 != 0)
            data[i] = data[i - 1];
    for (i = 0; i < 5; i++) data[5 * i] = aux[i];
}

void moving_star() {
    unsigned im[3];
    char big[25] = "0000000100011100010000000";

    while (1) {
        if (buttonA()) rot_down(big);
        if (buttonB()) rot_right(big);
        get_image(big, im);
        show(im, 10);
    }
}

void catch_point() {
    unsigned im[3];
    char empty[25] = "0000000000000000000000000";

    int x, y, target_x, target_y, dir, changed;
    x = y = 0;
    target_x = target_y = 4;
    dir = changed = 0;

    while (1) {
        if (x == target_x && y == target_y) {
            target_x = (x ^ (x << 1)) % 5;
            target_y = (y ^ (y << 1)) % 5;

            if (x == target_x && y == target_y) {
                target_x = (x + 3) % 5;
                target_y = (y + 4) % 5;
            }
        }

        int bA = buttonA();
        int bB = buttonB();

        if (bA && bB) {
            if (changed == 0) {
                dir ^= 1;
                changed = 1;
            }
        } else {
            if (bB) {
                if (dir) x = min(4, x + 1);
                else     y = min(4, y + 1);
                changed = 0;
            }

            if (bA) {
                if (dir) x = max(0, x - 1);
                else     y = max(0, y - 1);
                changed = 0;
            }
        }

        empty[x * 5 + y] = '1';
        empty[target_x * 5 + target_y] = '1';

        get_image(empty, im);
        show(im, 5);

        empty[target_x * 5 + target_y] = '0';
        get_image(empty, im);
        show(im, 5);

        empty[x * 5 + y] = '0';
        empty[target_x * 5 + target_y] = '0';
    }
}



void init(void) {
    GPIO_DIR = 0xfff0;
    GPIO_PINCNF[BUTTON_A] = 0;
    GPIO_PINCNF[BUTTON_B] = 0;

    //moving_star();
    catch_point();
}
