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
#include "mem_bottleneck_resolved.h"
 
dout_t mem_bottleneck_resolved(din_t mem[N]) {  
#pragma HLS INTERFACE m_axi port = mem depth=128 offset = slave bundle = a_port
#pragma HLS interface s_axilite register port=return
#pragma HLS RealProbe

  din_t A_buff[N];
  memcpy(&A_buff[0], const_cast<din_t*>(mem), sizeof(din_t) * N);


  din_t tmp0, tmp1, tmp2;
  dout_t sum=0;
  int i;
  
  tmp0 = A_buff[0];
  tmp1 = A_buff[1];
 SUM_LOOP:for (i = 2; i < N; i++) { 
    tmp2 = A_buff[i];
    sum += tmp2 + tmp1 + tmp0;
    tmp0 = tmp1;
    tmp1 = tmp2;
  } 
    
  return sum;
}
