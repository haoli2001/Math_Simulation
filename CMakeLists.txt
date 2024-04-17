cmake_minimum_required(VERSION 3.10.0)
project(Math_Simulation VERSION 0.1.0 LANGUAGES CXX)
#Set(CMAKE_CXX_COMPILER "D:/mingw/mingw64/bin/g++.exe")
message("C编译器路径: ${CMAKE_C_COMPILER}")
message("C++编译器路径: ${CMAKE_CXX_COMPILER}")
include(CTest)
enable_testing()

# 设置C++标准
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 设置源文件列表
set(SRC_LIST main.cpp mpi_manage.cpp sim_lib.cpp socketFunctions.cpp)
add_executable(Math_Simulation ${SRC_LIST})

# 设置CPack项目信息
set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

# 添加MS-MPI头文件路径
include_directories("C:/Program Files (x86)/Microsoft SDKs/MPI/Include")
include_directories("C:/Program Files (x86)/Microsoft SDKs/MPI/Include/x64")


# 添加MS-MPI库文件路径C:\Program Files (x86)\Microsoft SDKs\MPI\Lib\x64
link_directories("C:/Program Files (x86)/Microsoft SDKs/MPI/Lib/x64")

# 链接MS-MPI库
target_link_libraries(Math_Simulation "C:/Program Files (x86)/Microsoft SDKs/MPI/Lib/x64/msmpi.lib")

# 包含CPack模块以进行打包
include(CPack)