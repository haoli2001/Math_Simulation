#ifndef COMM
#define COMM
enum class CommCommand{
		CONFIG_DATA = 0,            //配置数据命令
		CALCU = 1,                   //计算命令
		STOP = 2,                    //暂停计算命令
		EXIT = 3,                     //退出命令
		RESOURCE = 4,               //请求服务器资源
		RESULT = 5,                  //回报计算结果命令
		STATUS = 6,                  //查询服务器状态命令
		YES = 7,
		NO = 8,
		ALIVE = 9                    //心跳检测命令
}

enum class ProcStatus//服务器状态管理端口
{
	MANAGE_CONNECT_SUCCESS = 0,          //管理端口连接成功
	MANAGE_CONNECT_FAIL = 1,              //管理端口连接失败
	READY_FOR_CALCU = 2,                   //准备计算
	CALCU_ING = 3,                          //正在计算
	CALCU_OVER = 4,                        //计算结束
	EXIT = 5                                //退出
};

struct Resource
{
	float cpu_usage_rate;
	float mem_usage_rate;
};

struct Frame
{
	CommCommand command;
	int length;
	char data[1024];
};
#endif // COMM
