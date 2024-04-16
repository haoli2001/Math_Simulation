#ifndef SIM_LIB_H
#define SIM_LIB_H

#define CONFIG_TYPE_NUMS 2
#define CONFIG_INT_NUMS 2
#define CONFIG_FLOAT_NUMS 14
//#define CONFIG_CHAR_NUMS 20
#define RESULT_TYPE_NUMS 2
#define RESULT_INT_NUMS 4
#define RESULT_FLOAT_NUMS 4
//#define RESULT_CHAR_NUMS 20
enum class ProcStatus//服务器状态管理端口
{
	MANAGE_CONNECT_SUCCESS = 0,          //管理端口连接成功
	MANAGE_CONNECT_FAIL = 1,              //管理端口连接失败
	READY_FOR_CALCU = 2,                   //准备计算
	CALCU_ING = 3,                          //正在计算
	CALCU_OVER = 4,                        //计算结束
	EXIT = 5                                //退出
};

//仿真输入参数
struct ConfigStruct
{
	ProcStatus command;
	int idx;
	int arg_int[3];//用户仿真模型的输入
	float arg[3];
};

//仿真输出参数
struct ResultStruct
{
	int idx;
	int arg_int[3];
	double arg_float[4];
};

int main_run(float* config, int idx, ResultStruct* result);

#endif // !SIM_LIB_H
