#include "Vtop.h"
#include "verilated.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <nvboard.h>

void nvboard_bind_all_pins(Vtop* top);

/*
static void single_cycle(Vtop* top){
	top->clk = 0;top->eval(); 
	top->clk = 1;top->eval(); 
}
*/


int main(int argc, char** argv) {
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);
    Vtop* top = new Vtop{contextp};

    //接入nvboard
    nvboard_bind_all_pins(top);
    nvboard_init();

    while (true) {
        nvboard_update();
        top->eval();
        //single_cycle(top);
    }
    delete top;
    delete contextp;
    return 0;
}
