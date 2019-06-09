// lab3-primes/primes.c
// Copyright (c) 2018 J. M. Spivey

#include "hardware.h"
#include "lib.h"
#include <stdarg.h>

#ifdef INTERRUPT

#define NBUF 8192

static volatile int txidle;       // Whether UART is idle
static volatile int bufcnt = 0;   // Number of chars in buffer
static unsigned bufin = 0;        // Index of first free slot
static unsigned bufout = 0;       // Index of first occupied slot
static volatile char txbuf[NBUF]; // The buffer
#else
static int txinit;                // UART ready to transmit first char
#endif

/* serial_init -- set up UART connection to host */
void serial_init(void) {
    UART_ENABLE = 0;

    GPIO_DIRSET = BIT(USB_TX);
    GPIO_DIRCLR = BIT(USB_RX);
    SET_FIELD(GPIO_PINCNF[USB_TX], GPIO_PINCNF_PULL, GPIO_Pullup);
    SET_FIELD(GPIO_PINCNF[USB_RX], GPIO_PINCNF_PULL, GPIO_Pullup);

    UART_BAUDRATE = UART_BAUD_9600;     // 9600 baud
    UART_CONFIG = 0;                    // format 8N1
    UART_PSELTXD = USB_TX;              // choose pins
    UART_PSELRXD = USB_RX;
    UART_ENABLE = UART_Enabled;
    UART_STARTTX = 1;
    UART_STARTRX = 1;
    UART_RXDRDY = 0;
    UART_TXDRDY = 0;

#ifdef INTERRUPT
    // Interrupt for transmit only
    UART_INTENSET = BIT(UART_INT_TXDRDY);
    set_priority(UART_IRQ, 3);
    enable_irq(UART_IRQ);
    txidle = 1;
#else
    txinit = 1;
#endif
}

#ifdef INTERRUPT

int max_buffer_size = 0;

void uart_handler(void) {
    if (UART_TXDRDY) {
        UART_TXDRDY = 0;
        if (bufcnt == 0)
            txidle = 1;
        else {
            UART_TXD = txbuf[bufout];
            bufcnt--;
            bufout = (bufout+1) % NBUF;
        }
    }
}

/* serial_putc -- send output character */
void serial_putc(char ch) {
    while (bufcnt == NBUF) pause();

    intr_disable();
    if (txidle) {
        intr_enable();
        txidle = 0;
        UART_TXD = ch; 
    } else {
        txbuf[bufin] = ch;
        bufcnt++;
        if (bufcnt > max_buffer_size) max_buffer_size = bufcnt;
        bufin = (bufin+1) % NBUF;
    }
    intr_enable();
}

#else

/* serial_putc -- send output character */
// Normal version
void serial_putc(char ch) {
    if (! txinit) {
        while (! UART_TXDRDY) { }
    }
    txinit = 0;
    UART_TXDRDY = 0;
    UART_TXD = ch;
}

// Question 1
/*void serial_putc(char ch) {
    txinit = 0;
    UART_TXDRDY = 0;
    UART_TXD = ch;
    if (! txinit) {
        while (! UART_TXDRDY) { }
    }
}*/
#endif

// ----- some code ----------------

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

// ----- timer handler -------------

void init_timer(void) {
    TIMER1_STOP = 1;
    TIMER1_MODE = TIMER_Timer_Mode;
    TIMER1_BITMODE = TIMER_16Bit;
    TIMER1_PRESCALER = 4;      // 1MHz = 16MHz / 2^4
    TIMER1_CLEAR = 1;
    TIMER1_CC[0] = 1000;
    TIMER1_SHORTS = BIT(TIMER_COMPARE0_CLEAR);
    TIMER1_INTENSET = BIT(TIMER_INTEN_COMPARE0);
    TIMER1_START = 1;
    set_priority(TIMER1_IRQ, 3);
    enable_irq(TIMER1_IRQ);
}

void new_milli();

void timer1_handler(void) {
    if (TIMER1_COMPARE[0]) {
        new_milli();
        TIMER1_COMPARE[0] = 0;
    }
}

int millis = 0;
char image[25] = "0000000000000000000000000";
int pos = 0;
int ready = 0;
int row = 0;
int blink = 0;

void new_milli() {
    millis += 1;

    if (millis % 5 != 0) return;

    int bA = buttonA();
    int bB = buttonB();

    if (bA || bB) {
        if (bA && bB) {
            for (int i = 0; i < 25; i++) image[i] = '0';
            pos = 0;
            ready = 0;
            row = 0;
            blink = 0;
            return;
        }


        if (pos < 25 && ready) {
            if (bB) image[pos] = '1';
            else    image[pos] = '0';
            pos++;
        }
        ready = 0;
    } else {
        ready = 1;
    }

    if (++row == 3) {
        row = 0;
        if (++blink == 50) blink = 0;
    }

    if (pos < 25 && blink < 25) image[pos] = '1';
    
    unsigned data[3];
    get_image(image, data);
    GPIO_OUT = data[row];

    if (pos < 25) image[pos] = '0';
}




// -------------------------------

void serial_printf(char *fmt, ...) {
    va_list va;
    va_start(va, fmt);
    do_print(serial_putc, fmt, va);
    va_end(va);
}

int modulo(int a, int b) {
    int r = a;
    while (r >= b) r -= b;
    return r;
}

int prime(int n) {
    for (int k = 2; k * k <= n; k++) {
        if (modulo(n, k) == 0)
            return 0;
    }

    return 1;
}

#define MASK 0x0000fff0
#define LITE 0x00005fbf

void start_timer(void) {
    GPIO_DIRSET = MASK;
    GPIO_OUT = LITE;
    GPIO_PINCNF[BUTTON_A] = 0;
    GPIO_PINCNF[BUTTON_B] = 0;
}

void stop_timer(void) {
    GPIO_OUT = 0;
}

void init(void) {
    int n = 2, count = 0;

    serial_init();
    start_timer();
    init_timer();

    //n = 1000000;
    while (count < 500) {
        if (prime(n)) {
            count++;
            serial_printf("prime(%d) = %d\r\n", count, n);
        }
        n++;
    }
    
    stop_timer();


    #ifdef INTERRUPT
    while(txidle == 0) pause();
    serial_printf("Max buffer size: %d\r\n", max_buffer_size);
    #endif

    serial_printf("Total time: %d ms\r\n", millis);

}


// Comparison:
// interrupt version: 9579 ms
// poll version: 11591 ms
//
// 1. inverting the order in serial_putc => poll version: 12046 ms
// 2. Time comparison for different buffer size:
//    64: 9579
//    32: 9585
//    16: 9678
//     8:10004
//     4:10472
//     2:10913
//     1:11219
//     0: does not work
//     A smaller buffer increases significantly the time required for printing.
//
// 3. Maximum buffer count comparison:
//      64: 64
//     128: 128 
//     256: 256
//     512: 521
//    1024: 1024
//    2048: 2048
//    4096: 4096
//    8192: 6724 -- this is the first time when it never becomes full
//    However, the running time is not affected.
//
// 4. In both cases, the time needed to compute primes dominates the time needed to print them. Actually, it takes too much time even to run it. After about 20 second, I got that first 5 primes are:
//    1000003, 1000033, 1000037, 1000039, 1000081
//  5. If we do not use instructions "intr_enable" and "intr_disable", the program will still continue to work until the last lines of data:
//  --> e(6Mbuffer size: 6728
//  As you can observe, "e(6Mbuffer" appeared instead of "Max buffer size". 
//  Disabling interrupts only for the "else" branch leads to a correct solution since the other branch can not be affected by an interrupt.
//
//  
//
