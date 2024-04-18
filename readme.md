# 数学仿真评估大样本
## 运行环境
windows 10 <br>
Ubuntu 22.04.2 LTS <br>
## 依赖
MSMPI v10.1.3<br>
MPICH v3.4.1<br>
## 安装
### MSMPI安装
安装地址在 https://www.microsoft.com/en-us/download/details.aspx?id=105289<br>
visual studio 配置mpi教程 https://blog.csdn.net/Jacamox/article/details/112563361<br>
### MPICH安装
安装地址在 https://www.mpich.org/downloads/<br>
安装教程 https://zhuanlan.zhihu.com/p/356705583
## 编译器
### windows
MSVC 2017<br>
**注意**使用mingw即g++链接MSMPI时会出错，可能是微软专门屏蔽了mingw的链接。  
### linux
mpicxx（即gcc version 11.4.0），mpicxx只是包装了一下，gcc10也可以运行。
## 编译
### windows
#### visual studio
如果使用visual studio直接按照教程进行编译。<br>
#### vscode + cmake  
在vscode中，cmake首先 ctrl+shift+p 打开命令面板，输入cmake:Select a Kit，选择Visual Studio Professional 2017 Release - amd64。  <br>
再使用cmake进行编译，编译命令为  
```
    cd ./build
    cmake ../
    cmake --build .
```
### linux
makefile已经写好了，直接```make```即可。注意编译前```make clean```一下。
## 运行
下面的**5**是示例，具体为需要开启进程的数量，鲲鹏版本是```make run```会开启三个节点的所有进程，具体参考相关的文档。
### windows
#### visual studio
visula studio 直接windows调试器运行只有单进程，多进程运行找到编译好的exe文件，在cmd中运行，命令为：
```
mpiexe -n 5 Math_Simulation.exe
```
#### vscode + cmake  
编译链接后的exe文件在./buid/Debug下，运行命令为
```
	cd ./Debug
    mpiexec -n 5 Math_Simulation.exe

``` 
### linux
linux下也是命令行运行
```
mpiexec -n 5 ./OUT
```
## 端口连接
本机连接使用回环IP地址:127.0.0.1  <br>
与服务器连接直接写服务器IP地址即可。<br>
端口号：4000<br>
### 本机端口连接测试
在windows下，使用netstat查看端口连接情况  
```
netstat -ano | findstr "4000"
```
如果输出的有
```
TCP    0.0.0.0:4000           0.0.0.0:0              LISTENING       28008
```
0.0.0.0:4000表示本机连接4000端口，LISTENING表示监听。<br>  
如果输出为空，表示没有连接4000端口。  <br>
28008为进程ID，可以查看对应进程  <br>
```
tasklist /FI "PID eq 28008"
```
如果输出为空，表示没有对应进程。
## 一些bug
在socketFunction.cpp中：
```
    int accept_client(int sockfd)
        {
	        std::cout << "[debug]" << "accept_client" << std::endl;
	        int new_fd;
	        int sin_size = sizeof(struct sockaddr_in);
	        printf("waiting for connect\n");
	        std::cout << "waiting for connect\n";
    #ifdef linux
	        new_fd = accept(sockfd, (struct sockaddr *)&their_addr, (socklen_t *)&sin_size);
    #endif
    #ifdef _UNIX
	        new_fd = accept(sockfd, (struct sockaddr *)&their_addr, (socklen_t *)&sin_size);
    #endif
    #ifdef __WINDOWS_
	        new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &sin_size);
    #endif
    #ifdef _WIN32
	        new_fd = accept(sockfd, (struct sockaddr *)&their_addr, &sin_size);
    #endif
	        printf("connected\n");
	        if (new_fd == SOCKET_ERROR) {
		        int error = WSAGetLastError();
		        printf("accept failed with error: %d\n", error);
		        return -1;
	        }
	        else {
		        printf("new_fd:%d", new_fd);
	        }
	        return new_fd;
            }
```

如果直接运行编译好的exe，不使用mpiexec，正常运行可以打印**waiting for connect**如下图：
![socket_bug_normal](/image/socket_bug_normal.jpg "socket_bug_normal")
而如果使用mpiexec,打印不了**waiting for connect**如下图：
![socket_bug_mpi](/image/socket_bug_mpi.jpg "socket_bug_mpi")

**上面的bug解决方案**
* 首先必须使用MSVC编译器，GCC编译器问题是链接不了mpi，其次windows下连接后才会print"waiting for connect"，甚至在发送想定表之后才会打印该信息，并且和connected一起打印，原因不明。<br>    
* Mingw安装时建议不要选择win32，选择posix，否则std成员例如mutex，thread都找不到！  <br>

main_run修改为生成随机数，记住前端的结构体中的应为float，和后端保持一致。<br>

## 后端MPI运行逻辑
首先为ConfigStruct和ResultStruct注册MPI可以通信的数据类型，所有进程都注册此MPI数据类型。
```
	MPI_Datatype MPI_CONFIG, MPI_RESULT;
	commit_new_type(MPI_CONFIG, MPI_RESULT);
```
然后ID=0为主进程，其余进程都是从进程，主进程负责分配任务，从进程负责计算。<br>
主进程首先创建socket监听4000端口，等待连接。
```
	init_socket();
	int sockfd = create_socket();
	bind_listen(sockfd, port);
	int newSockfd = accept_client(sockfd);
```
根据收到的Frame中的command命令不同，操作不同，数据帧格式如下：
```
	struct Frame
	{
		CommCommand command;
		int length;
		char data[1024];
	};
```
一般流程如下：<br>
1. 接收Frame中的command，command命令为```CONFIG_DATA```,为配置数据，这里接收的是想定表中有多少行,并根据这个长度开辟len个ConfigStruct即main_run的输入配置,紧随其后就是发送想定表数据，这里为len个ConfigStruct，不是Frame格式，而是直接发送。
```
		case(CommCommand::CONFIG_DATA): {
			cout<<"[debug] recv config_data"<<endl;
			int len = frame.length;
			calcuInfo.configsNum=len;
			if(configs){
				delete configs;
				configs=nullptr;
			}
				
			configs = new ConfigStruct[len];
			recv_data(newSockfd, (char*)configs, len * sizeof(ConfigStruct));//接收想定表数据，len个ConfigStruct即len行。
			break;
		}
```
2. 收到```CALCU```命令是创建calcuthread线程开始给从进程分配计算任务并接收结果。
```
		case(CommCommand::CALCU): {
			//配置并开始
			cout<<"[debug] recv CALCU"<<endl;
			calcuInfo.configs = configs;
			calcuInfo.MPI_CONFIG = MPI_CONFIG;
			calcuInfo.MPI_RESULT = MPI_RESULT;
			calcuInfo.procNum = procNum;//当前进程数量
			calcuInfo.socketfd = newSockfd;
			calcuInfo.socketMutex = &socketMutex;
#ifdef linux
			//开始执行计算线程，当计算线程正在执行时，则先关闭线程后再重新执行
			if (calcThread != 0 && pthread_kill(calcThread, 0) == 0)
			{
				pthread_cancel(calcThread);
				pthread_join(calcThread, NULL);
				printf("restart");
			}
			pthread_create(&calcThread, NULL, calcThreadFunction, (void*)&calcuInfo);
#endif // linux
#ifdef _WINDOWS_
			//开始执行计算线程，当计算线程正在执行时，则先关闭线程后再重新执行
			if (calcThread.joinable())
			{
    			// 如果线程已经启动，先等待它完成
   				 calcThread.join();
			}
    		calcThread = thread(calcThreadFunction, &calcuInfo);
#endif
			break;
		}
```
3. 计算线程开始执行，首先为从进程分配任务，然后等待结果并回传结果给上位机。
```
void* calcThreadFunction(void *argv) {
	CalcuInfo calcuInfo = *(CalcuInfo*)argv;
	ConfigStruct sendBuf;

	ResultStruct* results = new ResultStruct[calcuInfo.configsNum];

	unsigned int sendIdx = 0;
	unsigned int recvIdx = 0;

	unsigned int taskNum = calcuInfo.configsNum;	//本次需要计算的任务数量
	printf("[calcThreadFun]: start calculate %d tasks\n", taskNum);
	if (calcuInfo.procNum == 1) {
		printf("[WARNING]only master process is alive,please check!\n");
		goto EXIT;
	}
	if (calcuInfo.procNum > 1)
	{
		while (true)
		{
			if (sendIdx < taskNum)
			{
				//向请求队列下发任务
				sendBuf = calcuInfo.configs[sendIdx];
				sendBuf.command = ProcStatus::START_TO_CALCU;
				printf("[calcThreadFun]: calculate the result %d/%d,\t\t\n", calcuInfo.configs[sendIdx].idx, calcuInfo.configsNum);
				send_Task(sendBuf, calcuInfo.MPI_CONFIG, calcuInfo.MPI_RESULT);
				sendIdx++;
			}
			else
			{
				//当前轮次所有条目计算完成后，向所有进程发送结束信号，并等待接收其计算结果
				recv_CurRoundAllResults(calcuInfo.procNum, results, taskNum, calcuInfo.MPI_CONFIG, calcuInfo.MPI_RESULT, calcuInfo.socketfd,calcuInfo.socketMutex);
				break;
			}
		}
	}

EXIT:
	delete results;
	return nullptr;
}
```
* 首先判断进程数量，如果为1，则说明只有主进程存活，没有从进程，直接退出。<br>
* 如果进程数量大于1，则开始分配任务，其中的进程状态信息是```ProcStatus::START_TO_CALCU```,当接收到从进程的计算请求时，就会发送一条任务给请求的从进程，逻辑如下：
```
void send_Task(ConfigStruct sendBuf, MPI_Datatype& MPI_CONFIG, MPI_Datatype& MPI_RESULT)
{
	MPI_Status status;
	ConfigStruct recvBuf;
	MPI_Recv(&recvBuf, 1, MPI_CONFIG, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, &status);	//接收从进程计算请求
	MPI_Ssend(&sendBuf, 1, MPI_CONFIG, status.MPI_SOURCE, 0, MPI_COMM_WORLD);
}
```
* 从进程的逻辑为无限循环，空闲时即没有接收到东西时会一直给主进程发送```ProcStatus::READY_FOR_CALCU```请求，当接收到主进程的```ProcStatus::START_TO_CALCU```时，就会开始计算，计算完成后，当前条次的的结果并不会直接发送给主进程，而是保存在```results```中，然后break出来发送```ProcStatus::READY_FOR_CALCU```请求。
```
void slave(int myid, char* hostname, MPI_Datatype& MPI_CONFIG, MPI_Datatype& MPI_RESULT)
{
	printf("this is slave!\n");
	ConfigStruct sendBuf;
	ConfigStruct recvBuf;
	vector<ResultStruct>results;
	unsigned int resultNum = 0;
	while (true)
	{
		sendBuf.command = ProcStatus::READY_FOR_CALCU;
		MPI_Ssend(&sendBuf, 1, MPI_CONFIG, 0, 0, MPI_COMM_WORLD);	//向主进程发送计算请求
		MPI_Recv(&recvBuf, 1, MPI_CONFIG, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);	//接收主进程命令
		//printf("recvBuf.command = %d\n", recvBuf.command);
		switch (recvBuf.command)
		{
		case ProcStatus::OVER:
		{
			//向主进程回传结果
			sendBuf.command = ProcStatus::SLAVEPROCESS_EXIT;
			if (!results.empty())
			{
				printf("send %d results,\t\tPID= %d\n", results.size(), myid);
				MPI_Ssend(&results[0], results.size(), MPI_RESULT, 0, 0, MPI_COMM_WORLD);
				results.clear();
			}
			else
				MPI_Ssend(&sendBuf, 1, MPI_RESULT, 0, 0, MPI_COMM_WORLD);
			break;
		}

		case ProcStatus::START_TO_CALCU:
		{
			//开始计算...
			ResultStruct output;
			//printf("before calculate the %dth result,\t\tPID= %d\n", recvBuf.idx, myid);
			main_run(recvBuf.arg, recvBuf.idx, &output);	//用户自定义计算模型入口
			output.idx = recvBuf.idx;	//输出序号一定要和输入序号对应
			results.push_back(output);

			//printf("计算第%d条结果\t\t进程ID: %d\n", recvBuf.idx, myid);
			break;
		}
		case ProcStatus::EXIT:
		{
			//退出
			return;
		}
		}

	}
}
```
* calcthread发送完所有条次的计算任务后，进入```recv_CurRoundAllResults```函数，如下：
```
/**
 * @brief 接收当前轮次的所有结果
 *
 * 从指定的进程数开始，接收所有从进程的计算结果，并将其存储在给定的结果数组中。
 * 接收完所有进程的结果后，将结果发回上位机。
 *
 * @param procNum 进程数
 * @param results 结果数组
 * @param resultsLen 结果数组长度
 * @param MPI_CONFIG MPI_Datatype 类型，表示配置信息的 MPI 数据类型
 * @param MPI_RESULT MPI_Datatype 类型，表示结果的 MPI 数据类型
 * @param socketfd 套接字文件描述符
 * @param socketMutex 互斥锁指针，用于在发送结果时加锁
 */
void recv_CurRoundAllResults(int procNum, ResultStruct* results, int resultsLen, MPI_Datatype& MPI_CONFIG, MPI_Datatype& MPI_RESULT, int socketfd, std::mutex* socketMutex)
{
	MPI_Status status;
	ConfigStruct sendBuf;
	ConfigStruct recvBuf;
	int resultBufOffset = 0;
	//接收所有从进程结果
	for (int i = 1; i < procNum; i++)
	{
		MPI_Recv(&recvBuf, 1, MPI_CONFIG, i, 0, MPI_COMM_WORLD, &status);	//接收从进程计算请求
		sendBuf.command = ProcStatus::OVER;
		MPI_Ssend(&sendBuf, 1, MPI_CONFIG, status.MPI_SOURCE, 0, MPI_COMM_WORLD);

		MPI_Probe(status.MPI_SOURCE, status.MPI_TAG, MPI_COMM_WORLD, &status);
		int recvNumPerProc = 0;
		MPI_Get_count(&status, MPI_RESULT, &recvNumPerProc);//获取从进程发送过来的数据长度,即结果个数

		MPI_Recv(results + resultBufOffset, recvNumPerProc, MPI_RESULT, status.MPI_SOURCE, 0, MPI_COMM_WORLD, &status);
		resultBufOffset += recvNumPerProc;
		printf("recv %d from process %d\n", recvNumPerProc, status.MPI_SOURCE);
	}


	//收到所有进程的结果后，将结果发回上位机。计算结束，返回
	//将收到的乱序结果数据排序
	printf("[DEBUG]:master ready to write result!\n");
	ResultStruct* tmp_results = new ResultStruct[resultsLen];
	printf("[DEBUG]:master new complete!,configs.size = %d\n", resultsLen);
	for (int i = 0; i < resultsLen; i++)
	{
		int orderIdx = results[i].idx;
		printf("[DEBUG]:results[%d].idx = %d\n", i, results[i].idx);
		tmp_results[orderIdx] = results[i];
	}
	
	//向上位机发送结果时加锁，避免两个线程同时发送socket数据，产生影响
	socketMutex->lock();
	int sendedLength = 0;
	Frame frame;
	printf("master send result to client\n");
	while (true)
	{
		frame.command = CommCommand::RESULT;
		if (sendedLength + 1024 < resultsLen * sizeof(ResultStruct))
		{
			memcpy(frame.data, (char*)tmp_results + sendedLength, 1024);
			frame.length = 1024;
			send_frame(socketfd, (char*)&frame, sizeof(Frame));
			sendedLength += 1024;
		}
		else
		{
			std::cout<<"[debug] sizeof(ResStruct)="<<sizeof(ResultStruct)<<" res len="<<resultsLen<<std::endl;
			memcpy(frame.data, (char*)tmp_results + sendedLength, resultsLen * sizeof(ResultStruct) - sendedLength);
			frame.length = resultsLen * sizeof(ResultStruct) - sendedLength;
			send_frame(socketfd, (char*)&frame, sizeof(Frame));
			break;
		}
	}
	socketMutex->unlock();

	delete tmp_results;
}
```
* 主进程的calcthread首先会向从进程发送```ProcStatus::OVER```命令，表示当前轮次计算结束。然后从每个从进程中接收结果，并存储在```results```数组中。最后将结果重新排序发送回上位机。
4. 注意的是，进入计算状态只是calcthread在工作，主线程仍然在循环监听socket。<br>
5. 退出逻辑：<br>
	* 收到socket中```CommCommand::EXIT```命令后，会调用
```
/**
 * @brief 结束所有进程
 *
 * 在 MPI 通信中，该函数用于结束所有从进程。
 *
 * @param procNum 进程数
 * @param MPI_CONFIG MPI 数据类型，表示配置信息
 * @param MPI_RESULT MPI 数据类型，表示结果信息
 */
void exit_AllProcess(int procNum, MPI_Datatype& MPI_CONFIG, MPI_Datatype& MPI_RESULT)
{
	unsigned int exitNum = 0;
	MPI_Status status;
	ConfigStruct sendBuf;
	ConfigStruct recvBuf;
	while (true)
	{
		MPI_Recv(&recvBuf, 1, MPI_CONFIG, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, &status);	//接收从进程计算请求
		ConfigStruct sendBuf;
		sendBuf.command = ProcStatus::EXIT;
		MPI_Ssend(&sendBuf, 1, MPI_CONFIG, status.MPI_SOURCE, 0, MPI_COMM_WORLD);
		exitNum++;

		//向所有从进程发送完结束命令，函数返回
		if (exitNum == procNum - 1)
			return;
	}
}
```
* 向所有从进程发送```ProcStatus::EXIT```命令，从进程结束，主进程发送完毕后也会结束退出。