//P3 arq 2019-2020
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

#include "arqo3.h"

void compute(tipo **matrix, tipo **matrix2,  tipo **matrixres, int n);


int main( int argc, char *argv[])
{

    int n;
	tipo **m=NULL, **m2=NULL, **mr=NULL;
	struct timeval fin,ini;

	printf("Word size: %ld bits\n",8*sizeof(tipo));

	if( argc!=2 )
	{
		printf("Error: ./%s <matrix size>\n", argv[0]);
		return -1;
	}
	n=atoi(argv[1]);
	m=generateMatrix(n);
	if( !m )
	{
		return -1;
	}
	m2=generateMatrix(n);
    if ( !m2 )
    {
        freeMatrix(m);
        return -1;
    }
	mr=generateEmptyMatrix(n);
    if ( !mr )
    {
        freeMatrix(m);
        freeMatrix(m2);
        return -1;
    }

	
	gettimeofday(&ini,NULL);

	/* Main computation */
	compute(m, m2, mr, n);
	/* End of computation */
	

	gettimeofday(&fin,NULL);
	printf("Execution time: %f\n", ((fin.tv_sec*1000000+fin.tv_usec)-(ini.tv_sec*1000000+ini.tv_usec))*1.0/1000000.0);
	


	freeMatrix(m);
	freeMatrix(m2);
	freeMatrix(mr);
	return 0;

}

void compute(tipo **matrix, tipo **matrix2,  tipo **matrixres, int n)
{
	tipo sum=0;
	int i,j, z;
	
	for(i=0;i<n;i++)
	{
	
        sum=0;
		for(j=0;j<n;j++)
		{
			for (z=0; z<n; z++)
			{
				sum += matrix[i][z] * matrix[z][i];
			}
			
			matrixres[i][j] = sum;
		}
	}
}
