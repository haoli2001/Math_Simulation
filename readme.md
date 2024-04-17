# 数学仿真评估大样本
## 运行环境
windows 10
## 依赖
MSMPI
## 编译器
MSVC 2017
**注意**使用mingw即g++链接MSVC时会出错
## 编译
这里使用的是cmake进行编译，编译命令为
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

解决方案
使用MSVC编译器，GCC编译器链接不了mpi，其次windows下连接后才会print"waiting for connect"，原因不明。
Mingw安装时建议不要选择win32，选择posix，否则std成员例如mutex，thread都找不到！


