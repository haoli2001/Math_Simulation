TARGET  := OUT
SOURCE  := main.cpp mpi_manage.cpp sim_lib.cpp socketFunctions.cpp
OBJS	:= $(SOURCE: %.cpp=%.o)
LIBS    := -lstdc++ -lpthread

CC  := mpicxx

$(TARGET):$(OBJS)
	$(CC) -o $(TARGET) $(OBJS) $(LIBS) 

$(OBJS):$(SOURCE)
	$(CC) -g -c $(OBJS) $(SOURCE)

clean:
	rm -rf *.o OUT