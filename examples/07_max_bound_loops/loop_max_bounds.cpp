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
#include "loop_max_bounds.h"

void loop_max_bounds(din_t A[N], dsel_t w1dth, dout_t* result) {  
#pragma HLS INTERFACE m_axi port = A depth=32 offset = slave bundle = a_port
#pragma HLS interface s_axilite port=w1dth
#pragma HLS interface s_axilite port=result
#pragma HLS INTERFACE s_axilite register port=return
#pragma HLS RealProbe

  din_t A_buff[N];
  memcpy(&A_buff[0], const_cast<din_t*>(A), sizeof(din_t) * N);

  dout_t out_accum=0;
  dsel_t x;
  
  LOOP_X:for (x=0;x<N-1; x++) 
  {
    if (x<w1dth) 
    {
      out_accum += A[x];
    }
  }

  *result = out_accum;
}
