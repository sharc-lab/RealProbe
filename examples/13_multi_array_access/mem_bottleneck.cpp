/*
 * Copyright 2020 Xilinx, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "mem_bottleneck.h"
 
dout_t array_mem_bottleneck(din_t mem[N]) {  
#pragma HLS INTERFACE m_axi port = mem depth=128 offset = slave bundle = a_port
#pragma HLS interface s_axilite register port=return
#pragma HLS RealProbe

  din_t A_buff[N];
  memcpy(&A_buff[0], const_cast<din_t*>(mem), sizeof(din_t) * N);

  dout_t sum=0;
  int i;
  
  SUM_LOOP:for(i=2;i<N;++i)
    sum += A_buff[i] + A_buff[i-1] + A_buff[i-2];
    
  return sum;
}
