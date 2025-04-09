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
#include "loop_functions.h"

void sub_func(din_t I[N], dout_t O[N], dsel_t limit) {
  int i;
  dout_t accum=0;
  
  SUM:for (i=0;i<limit; i++) {
      accum += I[i];
      O[i] = accum;
  }
}

void loop_functions(din_t A[N], din_t B[N], dout_t X[N], dout_t Y[N]) {  
#pragma HLS INTERFACE m_axi port = A depth=32 offset = slave bundle = a_port
#pragma HLS INTERFACE m_axi port = B depth=32 offset = slave bundle = b_port
#pragma HLS INTERFACE m_axi port = X depth=32 offset = slave bundle = c_port
#pragma HLS INTERFACE m_axi port = Y depth=32 offset = slave bundle = d_port
#pragma HLS interface s_axilite register port=return
#pragma HLS RealProbe

  din_t A_buff[N];
  din_t B_buff[N];
  dout_t X_buff[N];
  dout_t Y_buff[N];

  memcpy(&A_buff[0], const_cast<din_t*>(A), sizeof(din_t) * N);
  memcpy(&B_buff[0], const_cast<din_t*>(B), sizeof(din_t) * N);

  dout_t X_accum=0;
  dout_t Y_accum=0;
  int i,j;
  
  sub_func(A_buff,X_buff,(dsel_t)(N-1));
  sub_func(B_buff,Y_buff,(dsel_t)(N-1));

  memcpy(const_cast<dout_t*>(X), const_cast<dout_t*>(&X_buff[0]), sizeof(dout_t) * N);
  memcpy(const_cast<dout_t*>(Y), const_cast<dout_t*>(&Y_buff[0]), sizeof(dout_t) * N);

}
