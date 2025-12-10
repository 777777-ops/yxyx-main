#include "Vtop.h"
#include "verilated.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <nvboard.h>

size_t arr[255]{0};

void nvboard_bind_all_pins(Vtop* top);


static void single_cycle(Vtop* top){
    top->clk = 0;top->eval();
    top->clk = 1;top->eval();
}

int main(int argc, char** argv) {
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
    Vtop* top = new Vtop{contextp};

    //接入nvboard
    nvboard_bind_all_pins(top);
    nvboard_init();

    int i = 0;
    while (true) {
        nvboard_update();
        single_cycle(top);
        printf("%d = %d,arr[%d] = %ld\n",i,top->led,top->led,arr[top->led]);
        arr[top->led] ++; i++;
        if(i == 511) break;
    }
    delete top;
    delete contextp;
    return 0;
}

