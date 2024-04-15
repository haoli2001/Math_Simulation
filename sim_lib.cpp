#include "sim_lib.h"
#include<iostream>

//main_run函数为最终调用代码
int main_run(float* config, int idx, ResultStruct* result) {
	ResultStruct res;
	res.idx = idx;
	//计算
	result->idx = idx;
	return 0;
}