/*
 * Primio / JH-256 kernel implementation.
 *
 * ==========================(LICENSE BEGIN)============================
 *
 * Copyright (c) 2007-2010  Projet RNRT SAPHIR
 * Copyright (c) 2014  phm
 * Copyright (c) 2014  teknohog
 * Changes and optimizations by srcxxx
 * 
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 * 
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * ===========================(LICENSE END)=============================
 *
 * @author   Thomas Pornin <thomas.pornin@cryptolog.com>
 * @author   phm <phm@inbox.com>
 * @author   srcxxx <srcxxx@gmail.com>
 */

#ifndef PRIMIO_CL
#define PRIMIO_CL

#if __ENDIAN_LITTLE__
    //all ok
#else
    this file was optimized for little endian architectures and will not work on your device!
#endif

#if __ENDIAN_LITTLE__
#define SPH_LITTLE_ENDIAN 1
#else
#define SPH_BIG_ENDIAN 1
#endif

#ifndef __OPENCL_VERSION__
typedef unsigned long long sph_u64;
typedef long long sph_s64;
#else
typedef unsigned long sph_u64;
typedef long sph_s64;
#endif

#define SPH_C64(x)    ((sph_u64)(x ## UL))
#define SPH_T64(x)    (x)

#include "jh.cl"

__constant static const sph_u64 pad_start = 0x80;
__constant static const sph_u64 pad_end = 0x8002000000000000;

__attribute__((reqd_work_group_size(WORKSIZE, 1, 1)))
__kernel void search(__global unsigned char* block, volatile __global uint* output, const ulong target)
{
    uint gid = get_global_id(0);

    sph_u64 tmp;

   // jh256

sph_u64 h0h =	C64e(0xeb98a3412c20d3eb), h0l = C64e(0x92cdbe7b9cb245c1),
	h1h = C64e(0x1c93519160d4c7fa), h1l = C64e(0x260082d67e508a03),
	h2h = C64e(0xa4239e267726b945), h2l = C64e(0xe0fb1a48d41a9477),
	h3h = C64e(0xcdb5ab26026b177a), h3l = C64e(0x56f024420fff2fa8);

sph_u64 h4h = 	C64e(0x71a396897f2e4d75), h4l = C64e(0x1d144908f77de262),
	h5h = C64e(0x277695f776248f94), h5l = C64e(0x87d5b6574780296c),
	h6h = C64e(0x5c5e272dac8e0d6c), h6l = C64e(0x518450c657057a0f),
	h7h = C64e(0x7be4d367702412ea), h7l = C64e(0x89e3ab13d31cd769);

sph_u64 data[10];

data[0] = (*(const __global sph_u64 *) (block));     
data[1] = (*(const __global sph_u64 *) (block + 8)); 
data[2] = (*(const __global sph_u64 *) (block + 16));
data[3] = (*(const __global sph_u64 *) (block + 24));
data[4] = (*(const __global sph_u64 *) (block + 32));
data[5] = (*(const __global sph_u64 *) (block + 40));
data[6] = (*(const __global sph_u64 *) (block + 48));
data[7] = (*(const __global sph_u64 *) (block + 56));
data[8] = (*(const __global sph_u64 *) (block + 64));
data[9] = ((sph_u64) gid << 32) | (((*(const __global sph_u64 *) (block + 72))) & 0x00000000FFFFFFFF);

	// unroll the 3-stage loop for a little speedup

           h0h ^= data[0];
           h0l ^= data[1];
           h1h ^= data[2];
           h1l ^= data[3];
           h2h ^= data[4];
           h2l ^= data[5];
           h3h ^= data[6];
           h3l ^= data[7];
        E8;   
           h4h ^= data[0];
           h4l ^= data[1];
           h5h ^= data[2];
           h5l ^= data[3];
           h6h ^= data[4];
           h6l ^= data[5];
           h7h ^= data[6];
           h7l ^= data[7];

           h0h ^= data[8];  
           h0l ^= data[9];  
           h1h ^= pad_start;
        E8;   
           h4h ^= data[8];  
           h4l ^= data[9];  
           h5h ^= pad_start;

	   h3l ^= pad_end;
        E8;   
	   h7l ^= pad_end;	   

    if (h7l <= target)
        output[output[0xFF]++] = as_uint(as_uchar4(gid).wzyx);
}

#endif // PRIMIO_CL

















