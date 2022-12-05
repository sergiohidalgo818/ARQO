CC = gcc
LIBS = -lgomp -lm
LIB_DIR =  
FLAGS = -g -Wall -D_GNU_SOURCE -fopenmp

.PHONY: clean all

all: pescalar_par2 

pescalar_par2: pescalar_par2.c arqo4.c
	$(CC) $(FLAGS) $(LIB_DIR) -o $@ $^ $(LIBS)

clean:
	rm -f *.o *~ pescalar_par2 
	
clear:
	rm -f *.o *~
