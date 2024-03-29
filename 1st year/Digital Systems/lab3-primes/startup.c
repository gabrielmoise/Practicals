// startup.c
// Copyright (c) 2018 J. M. Spivey

#include "hardware.h"

void system_init(void);

void null(void) { }

void phos_init(void);
#pragma weak phos_init = null

void init(void);

void phos_start(void);
#pragma weak phos_start = null

extern unsigned __data_start[], __data_end[],
     __bss_start[], __bss_end[], __etext[], __stack[];

/* __reset -- the system starts here */
void __reset(void) {
     unsigned *p, *q;

     /* Make sure all RAM banks are powered on */
     POWER_RAMON |= BIT(0) | BIT(1);

     /* Copy data segment and zero out bss */
     p = __data_start; q = __etext;
     while (p < __data_end) *p++ = *q++;
     p = __bss_start;
     while (p < __bss_end) *p++ = 0;

     /* Initialise the scheduler */
     phos_init();

     /* Let the program initialise itself */
     init();

     /* Start the scheduler */
     phos_start();

     /* If there is no scheduler, spin */
     while (1) pause();
}


/* NVIC SETUP FUNCTIONS */

/* On Cortex-M0, only the top two bits of each interrupt priority are
   implemented, so setting the priority to 0xff has the same effect as
   setting it to 0xc0.  Smaller numbers correspond to more urgency. */

/* set_priority -- set priority for an IRQ to a value [0..0xff] */
void set_priority(int irq, unsigned prio) {
     if (irq < 0)
          SET_BYTE(SCB_SHPR[(irq+8) >> 2], irq & 0x3, prio);
     else
          SET_BYTE(NVIC_IPR[irq >> 2], irq & 0x3, prio);
}
     
void enable_irq(int irq) {
     NVIC_ISER[0] = BIT(irq);
}

void disable_irq(int irq) {
     NVIC_ICER[0] = BIT(irq);
}

void clear_pending(int irq) {
     NVIC_ICPR[0] = BIT(irq);
}


/*  INTERRUPT VECTORS */

/* We use GCC features to define each handler name as an alias for the
   wrap_surprise() function if it is not defined elsewhere.
   Applications can subsitute their own definitions for surprise() or
   for individual handler names like uart_handler(). */

void spin(void) {
     int n;

     intr_disable();

     /* Flash the seven stars of death */
     GPIO_DIR = 0xfff0;
     while (1) {
          GPIO_OUT = 0x4000;
          for (n = 1000000; n > 0; n--) {
               nop(); nop(); nop();
          }
          GPIO_OUT = 0;
          for (n = 200000; n > 0; n--) {
               nop(); nop(); nop();
          }
     }          
}

void default_handler(void);
#pragma weak default_handler = spin

static void wrap_default(void) {
     default_handler();
}

void nmi_handler(void);
#pragma weak nmi_handler = wrap_default

void hardfault_handler(void);
#pragma weak hardfault_handler = wrap_default

void svc_handler(void);
#pragma weak svc_handler = wrap_default

void pendsv_handler(void);
#pragma weak pendsv_handler = wrap_default

void systick_handler(void);
#pragma weak systick_handler = wrap_default

void uart_handler(void);
#pragma weak uart_handler = wrap_default

void timer0_handler(void);
#pragma weak timer0_handler = wrap_default

void timer1_handler(void);
#pragma weak timer1_handler = wrap_default

void timer2_handler(void);
#pragma weak timer2_handler = wrap_default

void power_clock_handler(void);
#pragma weak power_clock_handler = wrap_default

void radio_handler(void);
#pragma weak radio_handler = wrap_default

void spi0_twi0_handler(void);
#pragma weak spi0_twi0_handler = wrap_default

void spi1_twi1_handler(void);
#pragma weak spi1_twi1_handler = wrap_default

void gpiote_handler(void);
#pragma weak gpiote_handler = wrap_default

void adc_handler(void);
#pragma weak adc_handler = wrap_default

void rtc0_handler(void);
#pragma weak rtc0_handler = wrap_default

void temp_handler(void);
#pragma weak temp_handler = wrap_default

void rng_handler(void);
#pragma weak rng_handler = wrap_default

void ecb_handler(void);
#pragma weak ecb_handler = wrap_default

void ccm_aar_handler(void);
#pragma weak ccm_aar_handler = wrap_default

void wdt_handler(void);
#pragma weak wdt_handler = wrap_default

void rtc1_handler(void);
#pragma weak rtc1_handler = wrap_default

void qdec_handler(void);
#pragma weak qdec_handler = wrap_default

void lpcomp_handler(void);
#pragma weak lpcomp_handler = wrap_default

void swi0_handler(void);
#pragma weak swi0_handler = wrap_default

void swi1_handler(void);
#pragma weak swi1_handler = wrap_default

void swi2_handler(void);
#pragma weak swi2_handler = wrap_default

void swi3_handler(void);
#pragma weak swi3_handler = wrap_default

void swi4_handler(void);
#pragma weak swi4_handler = wrap_default

void swi5_handler(void);
#pragma weak swi5_handler = wrap_default

typedef void (*handler)(void);

// Entries filled with default_handler are unused by the hardware.  Getting
// such an interrupt would be a real surprise!

handler __vectors[] __attribute((section(".vectors"))) = {
    (handler) __stack,          // -16
    __reset,
    nmi_handler,
    hardfault_handler,
    default_handler,            // -12
    default_handler,
    default_handler,
    default_handler,
    default_handler,           // -8
    default_handler,
    default_handler,
    svc_handler,
    default_handler,           // -4
    default_handler,
    pendsv_handler,
    systick_handler,
    
    /* external interrupts */
    power_clock_handler,        //  0
    radio_handler,
    uart_handler,
    spi0_twi0_handler,
    spi1_twi1_handler,          //  4
    default_handler,
    gpiote_handler,
    adc_handler,
    timer0_handler,             //  8
    timer1_handler,
    timer2_handler,
    rtc0_handler,
    temp_handler,               // 12
    rng_handler,
    ecb_handler,
    ccm_aar_handler,
    wdt_handler,                // 16
    rtc1_handler,
    qdec_handler,
    lpcomp_handler,
    swi0_handler,               // 20
    swi1_handler,
    swi2_handler,
    swi3_handler,
    swi4_handler,               // 24
    swi5_handler,
    default_handler,
    default_handler,
    default_handler,            // 28
    default_handler,
    default_handler,
    default_handler
};
