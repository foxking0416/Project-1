
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

cudaError_t addWithCuda(float *c, const float *a, const float *b, unsigned int size);
void serialMat_Mult(const float *a, const float *b, float *c, unsigned int width);
void serialMat_Add(const float *a, const float *b, float *c, unsigned int width);
void serialMat_Sub(const float *a, const float *b, float *c, unsigned int width);

__global__ void mat_add (const float *Md, const float *Nd, float *c, int width)
{
	int i = threadIdx.x;
	int j = threadIdx.y;
    c[j*width + i] = Md[j*width + i] + Nd[j*width + i];
}

__global__ void mat_sub (const float *Md, const float *Nd,float *c,  int width)
{
	int i = threadIdx.x;
	int j = threadIdx.y;
    c[j*width + i] = Md[j*width + i] - Nd[j*width + i];
}

__global__ void mat_mult (const float *Md, const float *Nd, float *c, int width)
{
    int i = threadIdx.x;
	int j = threadIdx.y;


	float value = 0;
	for(int k = 0; k < width; ++k){

		float MdElement = Md[j * width + k];
		float NdElement = Nd[k * width + i];

		value +=  MdElement * NdElement;

	}
	c[j*width + i] = value;
}

int main()
{
    const int arraySize = 25;
	const float a[arraySize] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24};
	const float b[arraySize] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24};
    float c[arraySize] = { 0 };
	float d[arraySize] = { 0 };
	float e[arraySize] = { 0 };

   //const int arraySize = 5;
   //const float a[arraySize][arraySize] = { {1, 2, 3, 4, 6},    {6, 1, 5, 3, 8},    {2, 6, 4, 9, 9},    {1, 3, 8, 3, 4},    {5, 7, 8, 2, 5} };
   //const float b[arraySize][arraySize] = { {3, 5, 0, 8, 7},    {2, 2, 4, 8, 3},    {0, 2, 5, 1, 2},    {1, 4, 0, 5, 1},    {3, 4, 8, 2, 3} };
   // float c[arraySize][arraySize] = { 0 };


	serialMat_Add(a, b, c, 5);
	serialMat_Sub(a, b, d, 5);
	serialMat_Mult(a, b, e, 5);
    // Add vectors in parallel.
    //cudaError_t cudaStatus = addWithCuda(a, b, c, arraySize);
    //if (cudaStatus != cudaSuccess) {
    //    fprintf(stderr, "addWithCuda failed!");
    //    return 1;
    //}

    printf("�u 0,  1,  2,  3,  4�U   �u 0,  1,  2,  3,  4�U\n"
		   "�U 5,  6,  7,  8,  9�U   �U 5,  6,  7,  8,  9�U\n"
	       "�U10, 11, 12, 13, 14�U + �U10, 11, 12, 13, 14�U\n"
	       "�U15, 16, 17, 18, 19�U   �U15, 16, 17, 18, 19�U\n"
	       "�U20, 21, 22, 23, 24�v   �U20, 21, 22, 23, 24�v\n"
		   "= \n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n", 
		   c[0],  c[1],  c[2],  c[3],  c[4], 
		   c[5],  c[6],  c[7],  c[8],  c[9],
		   c[10], c[11], c[12], c[13], c[14], 
		   c[15], c[16], c[17], c[18], c[19],
		   c[20], c[21], c[22], c[23], c[24]);

	printf("�u 0,  1,  2,  3,  4�U   �u 0,  1,  2,  3,  4�U\n"
		   "�U 5,  6,  7,  8,  9�U   �U 5,  6,  7,  8,  9�U\n"
	       "�U10, 11, 12, 13, 14�U - �U10, 11, 12, 13, 14�U\n"
	       "�U15, 16, 17, 18, 19�U   �U15, 16, 17, 18, 19�U\n"
	       "�U20, 21, 22, 23, 24�v   �U20, 21, 22, 23, 24�v\n"
		   "= \n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n", 
		   d[0],  d[1],  d[2],  d[3],  d[4], 
		   d[5],  d[6],  d[7],  d[8],  d[9],
		   d[10], d[11], d[12], d[13], d[14], 
		   d[15], d[16], d[17], d[18], d[19],
		   d[20], d[21], d[22], d[23], d[24]);

	printf("�u 0,  1,  2,  3,  4�U   �u 0,  1,  2,  3,  4�U\n"
		   "�U 5,  6,  7,  8,  9�U   �U 5,  6,  7,  8,  9�U\n"
	       "�U10, 11, 12, 13, 14�U * �U10, 11, 12, 13, 14�U\n"
	       "�U15, 16, 17, 18, 19�U   �U15, 16, 17, 18, 19�U\n"
	       "�U20, 21, 22, 23, 24�v   �U20, 21, 22, 23, 24�v\n"
		   "= \n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n{%.2f,%.2f,%.2f,%.2f,%.2f}\n", 
		   e[0],  e[1],  e[2],  e[3],  e[4], 
		   e[5],  e[6],  e[7],  e[8],  e[9],
		   e[10], e[11], e[12], e[13], e[14], 
		   e[15], e[16], e[17], e[18], e[19],
		   e[20], e[21], e[22], e[23], e[24]);

    // cudaDeviceReset must be called before exiting in order for profiling and
    // tracing tools such as Nsight and Visual Profiler to show complete traces.
    //cudaStatus = cudaDeviceReset();
    //if (cudaStatus != cudaSuccess) {
    //    fprintf(stderr, "cudaDeviceReset failed!");
    //    return 1;
    //}

	int i;
	scanf("%d", &i);
    return 0;
}


void serialMat_Add(const float *a, const float *b, float *c, unsigned int width){
	for(int i = 0; i < width; ++i){
		for(int j = 0; j < width; ++j){
			c[i*width+j] = a[i*width+j] + b[i*width+j];
		}
	}
}

void serialMat_Sub(const float *a, const float *b, float *c, unsigned int width){
	for(int i = 0; i < width; ++i){
		for(int j = 0; j < width; ++j){
			c[i*width+j] = a[i*width+j] - b[i*width+j];
		}
	}
}

void serialMat_Mult(const float *a, const float *b, float *c, unsigned int width){
	for(int i = 0; i < width; ++i){
		for(int j = 0; j < width; ++j){
			float sum = 0;
			for(int k = 0 ;k < width; ++k){
				float m = a[i * width + k];
				float n = b[k * width + j];
				sum += m*n;
			}
			c[i*width+j] = sum;
		}
	}
}

// Helper function for using CUDA to add vectors in parallel.
cudaError_t addWithCuda(const float *a, const float *b, float *c, unsigned int size)
{
    float *dev_a = 0;
    float *dev_b = 0;
    float *dev_c = 0;
    cudaError_t cudaStatus;

	//size = 25;

    // Allocate GPU buffers for three vectors (two input, one output)    .
    cudaStatus = cudaMalloc((void**)&dev_a, size * sizeof(float));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    cudaStatus = cudaMalloc((void**)&dev_b, size * sizeof(float));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

	cudaStatus = cudaMalloc((void**)&dev_c, size * sizeof(float));
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMalloc failed!");
        goto Error;
    }

    // Copy input vectors from host memory to GPU buffers.
    cudaStatus = cudaMemcpy(dev_a, a, size * sizeof(float), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    cudaStatus = cudaMemcpy(dev_b, b, size * sizeof(float), cudaMemcpyHostToDevice);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

    // Launch a kernel on the GPU with one thread for each element.
	dim3 threadPerBlock(5, 5);
    mat_mult <<<1, threadPerBlock>>>(dev_a, dev_b, dev_c, 5);

    // Check for any errors launching the kernel
    cudaStatus = cudaGetLastError();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "addKernel launch failed: %s\n", cudaGetErrorString(cudaStatus));
        goto Error;
    }
    
    // cudaDeviceSynchronize waits for the kernel to finish, and returns
    // any errors encountered during the launch.
    cudaStatus = cudaDeviceSynchronize();
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaDeviceSynchronize returned error code %d after launching addKernel!\n", cudaStatus);
        goto Error;
    }

    // Copy output vector from GPU buffer to host memory.
    cudaStatus = cudaMemcpy(c, dev_c, size * sizeof(float), cudaMemcpyDeviceToHost);
    if (cudaStatus != cudaSuccess) {
        fprintf(stderr, "cudaMemcpy failed!");
        goto Error;
    }

Error:
    cudaFree(dev_c);
    cudaFree(dev_a);
    cudaFree(dev_b);
    
    return cudaStatus;
}