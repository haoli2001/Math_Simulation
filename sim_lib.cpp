#include "sim_lib.h"
#include<iostream>
#include <random>

//main_run函数为最终调用代码
int main_run(float* config, int idx, ResultStruct* result) {
	std::random_device rd;
	std::default_random_engine engine(rd());
	std::uniform_int_distribution<int> intDist(1, 100); // 生成范围在 1 到 100 之间的随机整数
	std::uniform_real_distribution<double> realDist(0.0, 100.0); // 生成范围在 0.0 到 100.0 之间的随机浮点数
	ResultStruct res;
	res.idx = idx;
	//计算
	result->idx = idx;
	
	
	result -> arg_int[0] = intDist(engine);
	result -> arg_int[1] = intDist(engine);
	result -> arg_int[2] = intDist(engine);
	result -> arg_float[0] = realDist(engine);
	result -> arg_float[1] = realDist(engine);
	result -> arg_float[2] = realDist(engine);
	result -> arg_float[3] = realDist(engine);
	return 0;
}