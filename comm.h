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
