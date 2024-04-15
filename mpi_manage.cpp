#ifdef _WIN32
#define _CRT_SECURE_NO_WARNINGS
#endif
#ifdef _WIN64
#define _CRT_SECURE_NO_WARNINGS
#endif
#include <mpi.h>
#include "mpi_manage.h"
#include "socketFunctions.h"
#include "comm.h"

void commit_new_type(MPI_Datatype &MPI_CONFIG, MPI_Datatype &MPI_RESULT)
{
	//为MPI注册自定义的configStruct数据类型
	int blocklens_array[CONFIG_TYPE_NUMS];
	MPI_Aint displs_array[CONFIG_TYPE_NUMS];//使用MPI_Aint，单个元素的存放空间可以放得下地址。
	MPI_Datatype old_type_array[CONFIG_TYPE_NUMS];

	ConfigStruct mydata;

	old_type_array[0] = MPI_INT;
	old_type_array[1] = MPI_FLOAT;
	blocklens_array[0] = CONFIG_INT_NUMS;
	blocklens_array[1] = CONFIG_FLOAT_NUMS;

	MPI_Get_address(&mydata.command, &displs_array[0]);//第一个int型相对于MPI_BOTTOM的偏移
	MPI_Get_address(&mydata.arg[0], &displs_array[1]);//第一个float型相对于MPI_BOTTOM的偏移
	displs_array[1] = displs_array[1] - displs_array[0];
	displs_array[0] = 0;
	//生成新的数据类型并提交
	MPI_Type_create_struct(CONFIG_TYPE_NUMS, blocklens_array, displs_array, old_type_array, &MPI_CONFIG);
	MPI_Type_commit(&MPI_CONFIG);

	/*
	MPI_Aint extent = 0;
	MPI_Aint lb = 0;
	MPI_Type_get_extent(MPI_CONFIG, &lb, &extent);
	printf("sizeof MPI_CONFIG:%d	sizeof configStruct:%d\n", extent, sizeof(ConfigStruct));
	*/



	//为MPI注册自定义的resultStruct数据类型
	int blocklens_array2[RESULT_TYPE_NUMS];
	MPI_Aint displs_array2[RESULT_TYPE_NUMS];//使用MPI_Aint，单个元素的存放空间可以放得下地址。
	MPI_Datatype old_type_array2[RESULT_TYPE_NUMS];

	ResultStruct result;

	old_type_array2[0] = MPI_INT;
	old_type_array2[1] = MPI_DOUBLE;
	blocklens_array2[0] = RESULT_INT_NUMS;
	blocklens_array2[1] = RESULT_FLOAT_NUMS;

	MPI_Get_address(&result.idx, &displs_array2[0]);//第一个int型相对于MPI_BOTTOM的偏移
	MPI_Get_address(&result.arg_float[0], &displs_array2[1]);//第一个float型相对于MPI_BOTTOM的偏移
	displs_array2[1] = displs_array2[1] - displs_array2[0];
	displs_array2[0] = 0;
	//生成新的数据类型并提交
	MPI_Type_create_struct(RESULT_TYPE_NUMS, blocklens_array2, displs_array2, old_type_array2, &MPI_RESULT);
	MPI_Type_commit(&MPI_RESULT);



	/*
	MPI_Type_get_extent(MPI_RESULT, &lb, &extent);
	printf("sizeof MPI_RESULT:%d	sizeof resultStruct:%d\n", extent, sizeof(ResultStruct));
	*/
}




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

void recv_CurRoundAllResults(int procNum, ResultStruct* results, int resultsLen, MPI_Datatype& MPI_CONFIG, MPI_Datatype& MPI_RESULT, int socketfd, std::mutex& socketMutex)
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
		MPI_Get_count(&status, MPI_RESULT, &recvNumPerProc);

		MPI_Recv(results + resultBufOffset, recvNumPerProc, MPI_RESULT, status.MPI_SOURCE, 0, MPI_COMM_WORLD, &status);
		resultBufOffset += recvNumPerProc;
	}


	//收到所有进程的结果后，将结果发回上位机。计算结束，返回
	//将收到的乱序结果数据排序
	//printf("[DEBUG]:master ready to write result!\n");
	ResultStruct* tmp_results = new ResultStruct[resultsLen];
	//printf("[DEBUG]:master new complete!,configs.size = %d\n", resultsLen);
	for (int i = 0; i < resultsLen; i++)
	{
		int orderIdx = results[i].idx;
		printf("[DEBUG]:results[%d].idx = %d\n", i, results[i].idx);
		tmp_results[orderIdx] = results[i];
	}
	
	socketMutex.lock();
	int sendedLength = 0;
	Frame frame;
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
			memcpy(frame.data, (char*)tmp_results + sendedLength, resultsLen * sizeof(ResultStruct) - sendedLength);
			frame.length = resultsLen * sizeof(ResultStruct) - sendedLength;
			send_frame(socketfd, (char*)&frame, sizeof(Frame));
			break;
		}
	}
	socketMutex.unlock();

	delete tmp_results;
}

void send_Task(ConfigStruct sendBuf, MPI_Datatype& MPI_CONFIG, MPI_Datatype& MPI_RESULT)
{
	MPI_Status status;
	ConfigStruct recvBuf;
	MPI_Recv(&recvBuf, 1, MPI_CONFIG, MPI_ANY_SOURCE, 0, MPI_COMM_WORLD, &status);	//接收从进程计算请求
	MPI_Ssend(&sendBuf, 1, MPI_CONFIG, status.MPI_SOURCE, 0, MPI_COMM_WORLD);
}

void send_Resource(int socketfd,std::mutex socketMutex) {
	Resource resource;
	//计算占用率...
	//code here
	//....
	
	Frame frame;
	frame.command = CommCommand::RESOURCE;
	frame.length = sizeof(resource);
	memcpy(frame.data, (char*)&resource, sizeof(resource));
	socketMutex.lock();
	send_frame(socketfd, (char*)&frame, sizeof(Frame));
	socketMutex.unlock();

}