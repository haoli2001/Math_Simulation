cmake_minimum_required(VERSION 3.10.0)
project(Math_Simulation VERSION 0.1.0 LANGUAGES CXX)

include(CTest)
enable_testing()

set(SRC_LIST main.cpp getopt.cpp mpi_manage.cpp sim_lib.cpp socketFunctions.cpp)
add_executable(Math_Simulation ${SRC_LIST})

set(CPACK_PROJECT_NAME ${PROJECT_NAME})
set(CPACK_PROJECT_VERSION ${PROJECT_VERSION})

# 添加MS-MPI头文件路径
include_directories("C:/Program Files (x86)/Microsoft SDKs/MPI/Include")
include_directories("C:/Program Files (x86)/Microsoft SDKs/MPI/Include/x64")

# 添加MS-MPI库文件路径
link_directories("C:/Program Files (x86)/Microsoft SDKs/MPI/Lib/x64")

# 链接MS-MPI库
target_link_libraries(Math_Simulation msmpi.lib)

include(CPack)