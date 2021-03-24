#define MMIO_BASE 0xFE000000
#define GPIO_BASE (MMIO_BASE + 0x200000)
#define GPFSEL0 (GPIO_BASE + 0x00)
#define GPSET0 (GPIO_BASE + 0x1C)
#define GPCLR0 (GPIO_BASE + 0x28)

typedef unsigned long uint64_t;
typedef unsigned int uint32_t;

#define LED 16   // LED pin num
#define OUTPUT 1 // regster value for output

void set_high(uint64_t pin);
void set_low(uint64_t pin);
void set_function(uint64_t pin,uint32_t func);
void mmio_write(uint64_t reg, volatile uint32_t val);
void wait(uint64_t dur);

void main(){
  uint64_t dur;
  dur = 1000000;
  set_function(LED, OUTPUT);
  while(1){
    set_low(LED);
    wait(dur);
    set_high(LED);
    wait(dur);
  }
}

void set_high(uint64_t pin)
{
  if(pin <= 57)
    mmio_write(GPSET0 + (pin / 32) * 4,1 << (pin % 32));
}

void set_low(uint64_t pin)
{
  if(pin <= 57) 
    mmio_write(GPCLR0 + (pin / 32) * 4,1 << (pin % 32));
}

void set_function(uint64_t pin, uint32_t func)
{
  if(pin <= 57)
    mmio_write(GPFSEL0 + (pin / 10) * 4, OUTPUT << ((pin % 10) * 3));
}

void wait(uint64_t dur){
  while(dur-- > 0)
    asm(""); // if u delete this line, compiler will optimize your code and the generated kernel won't blink the led
}

void mmio_write(uint64_t reg, volatile uint32_t val)
{                                                   
  *(volatile uint32_t*)reg = val;                   
}                                                   

