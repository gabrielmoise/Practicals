// lab4-phos/heart.c
// Copyright (c) 2018 J. M. Spivey

#include "hardware.h"
#include "phos.h"

static void setup_timer(void) {
    message m;
    m.m_type = REGISTER;
    m.m_i1 = 5;                 // 5 msec per tick
    m.m_i2 = 1;                 // repeating
    send(TIMER, &m);
}

static void tick(void) {
    message m;
    receive(TIMER, &m);
    assert(m.m_type == PING);
}

static const unsigned heart[] = {
    0x28f0, 0x5e00, 0x8060
};
     
static const unsigned small[] = {
    0x2df0, 0x5fb0, 0x8af0
};

/* show -- display three rows of a picture n times */
static void show(const unsigned *img, int n) {
    while (n-- > 0) {
        // Takes 15msec per iteration
        for (int p = 0; p < 3; p++) {
            GPIO_OUT = img[p];
            tick();
        }
    }
}


//
// ----------- random generator ------------

#define RNG 173
#define NEW_RNG 1773
#define maxbuf 100

void rng_task(int arg) {
    static int rng_buf[maxbuf];
    int rng_size = 0;
    message m;

    RNG_STOP = 1;
    RNG_INTENSET = 1;
    RNG_START = 1;
    connect(RNG_IRQ);
    enable_irq(RNG_IRQ);

    while(1) {
        if (rng_size == 0)
            receive(HARDWARE, &m);
        else
            receive(ANY, &m);

        if (m.m_type == INTERRUPT) {
            if (RNG_VALRDY) {
                if (rng_size < maxbuf) rng_buf[rng_size++] = RNG_VALUE; 
                RNG_VALRDY = 0;
            }

            clear_pending(RNG_IRQ);
            enable_irq(RNG_IRQ);
            continue;
        }

        if (m.m_type == NEW_RNG) {
            m.m_i1 = rng_buf[--rng_size];
            send(m.m_sender, &m);
            continue;
        }

        panic("wrong message in RNG\n");
    }
}

void rng_init() {
    start(RNG, "Random", rng_task, 0, STACK); 
}

unsigned random_int() {
    unsigned answer = 0;
    message m;
    for (int i = 0; i < 4; i++) {
        m.m_type = NEW_RNG;
        sendrec(RNG, &m);
        answer = (answer << 8) | m.m_i1; 
    }
    return answer;
}

int roll() {
    while (1) {
        unsigned v = random_int();
        if (v < 4) continue;
        return 1 + (v % 6);
    } 
}

// ----------------------------------------------------



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


int buttonA() {
    return (GPIO_IN & BIT(BUTTON_A)) == 0;
}

int buttonB() {
     return (GPIO_IN & BIT(BUTTON_B)) == 0;
}


#define ROLL (USER + 5)

void roll_task(int arg) {
    static char* lib[] = {
        "00000000000010000000000000",
        "00000000000101000000000000",
        "00001000000010000000100000",
        "00000010100000001010000000",
        "00000010100010001010000000",
        "01010000000101000000010100"
    }; 

    unsigned im[3];

    setup_timer();

    while (1) {
        if (buttonA() || buttonB()) {
            int r = roll();
            serial_printf("Roll: %d\n", r);
            get_image(lib[r - 1], &im);
            show(im, 100); 
        } 
        GPIO_OUT = 0;
       
    }
}

void init(void) {
    GPIO_DIRSET = 0xfff0;
    GPIO_PINCNF[BUTTON_A] = 0;
    GPIO_PINCNF[BUTTON_B] = 0;

    serial_init();
    timer_init();
    rng_init();

    start(ROLL, "Roll", roll_task, 0, STACK);
}
