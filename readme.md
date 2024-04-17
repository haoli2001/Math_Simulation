# 数学仿真评估大样本
## 运行环境
windows 10
## 依赖
MSMPI v10.1.3
## 安装
安装地址在 https://www.microsoft.com/en-us/download/details.aspx?id=105289<br>
visual studio 配置mpi教程 https://blog.csdn.net/Jacamox/article/details/112563361<br>
## 编译器
MSVC 2017
**注意**使用mingw即g++链接MSMPI时会出错，可能是微软专门屏蔽了mingw的链接。  
## 编译
如果使用visual studio直接按照教程进行编译。<br>  
在vscode中，cmake首先 ctrl+shift+p 打开命令面板，输入cmake:Select a Kit，选择Visual Studio Professional 2017 Release - amd64。  <br>
再使用cmake进行编译，编译命令为  
```
    cd ./build
    cmake ../
    cmake --build .
```
编译链接后的exe文件在./buid/Debug下，运行命令为
```
    cd ./Debug
    mpiexec -n 5 Math_Simulation.exe

```
## 端口连接
本机连接4000端口的话应该使用回环IP地址:127.0.0.1  
### 端口连接测试
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
* 使用MSVC编译器，GCC编译器链接不了mpi，其次windows下连接后才会print"waiting for connect"，甚至在发送想定表之后才会打印该信息，并且和connected一起打印，原因不明。<br>    
* Mingw安装时建议不要选择win32，选择posix，否则std成员例如mutex，thread都找不到！  <br>

当前版本的bug是，计算结束回传结果已经发送了，但是界面端接收不到，甚至没有触发recv，原因不明。  

