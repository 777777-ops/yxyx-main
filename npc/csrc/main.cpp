#include "Vtop.h"
#include "verilated.h"
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
#include <nvboard.h>
#include <iostream>


// 将整数转换为4位有符号补码
int to_4bit_signed(int val) {
    // 对于4位有符号数，范围是-8到7
    if (val < 0) {
        // 负数的补码表示
        return (16 + val) & 0xF;  // 或者使用 (~(-val) + 1) & 0xF
    } else {
        return val & 0xF;
    }
}

// 将4位补码转换为有符号整数（用于C++计算）
int from_4bit_signed(int val) {
    val &= 0xF;  // 确保只有4位
    if (val & 0x8) {  // 如果是负数（最高位为1）
        return val - 16;  // 或者使用 -(~val + 1)
    } else {
        return val;
    }
}

bool test_result(Vtop* top, int a, int b, int sel) {
    // 设置输入，保留补码表示
    top->a = to_4bit_signed(a);
    top->b = to_4bit_signed(b);
    top->sel = sel;
    
    // 计算期望结果
    int expected_result = 0;
    int a_signed = from_4bit_signed(top->a);
    int b_signed = from_4bit_signed(top->b);
    
    switch (sel) {
        case 0: // 加法 a + b
            expected_result = to_4bit_signed(a_signed + b_signed);
            break;
            
        case 1: // 减法 a - b
            expected_result = to_4bit_signed(a_signed - b_signed);
            break;
            
        case 2: // 取反 ~a
            expected_result = (~top->a) & 0xF;
            break;
            
        case 3: // 与 a & b
            expected_result = (top->a & top->b) & 0xF;
            break;
            
        case 4: // 或 a | b
            expected_result = (top->a | top->b) & 0xF;
            break;
            
        case 5: // 异或 a ^ b
            expected_result = (top->a ^ top->b) & 0xF;
            break;
            
        case 6: // 比较（小于），result是a-b的结果
            expected_result = to_4bit_signed(a_signed - b_signed);
            break;
            
        case 7: // 比较（相等），result是a-b的结果
            expected_result = to_4bit_signed(a_signed - b_signed);
            break;
    }
    
    // 计算时钟边沿
    top->eval();
    
    // 获取实际结果
    int actual_result = top->result;
    
    // 验证结果
    if (actual_result != expected_result) {
        // 显示有符号值便于调试
        int actual_signed = from_4bit_signed(actual_result);
        int expected_signed = from_4bit_signed(expected_result);
        
        std::cout << "FAIL: sel=" << sel 
                  << ", a=" << a_signed << "(0x" << std::hex << (int)top->a << ")"
                  << ", b=" << b_signed << "(0x" << std::hex << (int)top->b << ")"
                  << ", expected=" << expected_signed << "(0x" << std::hex << expected_result << ")"
                  << ", actual=" << actual_signed << "(0x" << std::hex << actual_result << ")"
                  << std::dec << std::endl;
        return false;
    }
    
    return true;
}

int main(int argc, char** argv) {
    // 初始化Verilator
    Verilated::commandArgs(argc, argv);
    
    // 创建模块实例
    Vtop* top = new Vtop;
    
    int total_tests = 0;
    int passed_tests = 0;
    bool all_passed = true;
    
    std::cout << "Starting test..." << std::endl;
    
    // 遍历所有测试用例
    for (int sel = 0; sel < 8; sel++) {
        for (int a_val = -8; a_val <= 7; a_val++) {
            for (int b_val = -8; b_val <= 7; b_val++) {
                total_tests++;
                
                if (!test_result(top, a_val, b_val, sel)) {
                    all_passed = false;
                    // 可以选择继续测试或立即退出
                    // return 1; // 立即退出
                } else {
                    passed_tests++;
                }
            }
        }
    }
    
    std::cout << "\nTest Summary:" << std::endl;
    std::cout << "Total tests: " << total_tests << std::endl;
    std::cout << "Passed tests: " << passed_tests << std::endl;
    std::cout << "Failed tests: " << (total_tests - passed_tests) << std::endl;
    
    if (all_passed) {
        std::cout << "✓ All tests passed!" << std::endl;
    } else {
        std::cout << "✗ Some tests failed!" << std::endl;
    }
    
    // 清理
    delete top;
    
    return all_passed ? 0 : 1;
}

/*
void nvboard_bind_all_pins(Vtop* top);

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

*/
