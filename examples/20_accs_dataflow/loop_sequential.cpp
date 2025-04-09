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
#include "loop_sequential.h"

void loop_sequential(din_t A[N], din_t B[N], dout_t X[N], dout_t Y[N], dsel_t xlimit, dsel_t ylimit) {
#pragma HLS INTERFACE m_axi port = A depth=32 offset = slave bundle = a_port
#pragma HLS INTERFACE m_axi port = B depth=32 offset = slave bundle = b_port
#pragma HLS INTERFACE m_axi port = X depth=32 offset = slave bundle = c_port
#pragma HLS INTERFACE m_axi port = Y depth=32 offset = slave bundle = d_port
#pragma HLS interface s_axilite port=xlimit
#pragma HLS interface s_axilite port=ylimit
#pragma HLS interface s_axilite register port=return
#pragma HLS RealProbe

#pragma HLS DATAFLOW

// The dataflow directive will enable the concurrent
// execution of the two accumulators described below

  // din_t A_buff[N];
  // din_t B_buff[N];
  // dout_t X_buff[N];
  // dout_t Y_buff[N];

  // memcpy(&A_buff[0], const_cast<din_t*>(A), sizeof(din_t) * N);
  // memcpy(&B_buff[0], const_cast<din_t*>(B), sizeof(din_t) * N);

  dout_t X_accum=0;
  dout_t Y_accum=0;
  int i,j;
  
  SUM_X:for (i=0;i<xlimit; i++) {
      X_accum += A[i];
      X[i] = X_accum;
  }

  SUM_Y:for (i=0;i<ylimit; i++) {
      Y_accum += B[i];
      Y[i] = Y_accum;
  }

  // memcpy(const_cast<dout_t*>(X), const_cast<dout_t*>(&X_buff[0]), sizeof(dout_t) * N);
  // memcpy(const_cast<dout_t*>(Y), const_cast<dout_t*>(&Y_buff[0]), sizeof(dout_t) * N);
}
