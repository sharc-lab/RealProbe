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
#include "loop_imperfect.h"

void loop_imperfect(din_t A[N], dout_t B[N]) {
#pragma HLS INTERFACE m_axi port = A depth=20 offset = slave bundle = a_port
#pragma HLS INTERFACE m_axi port = B depth=20 offset = slave bundle = b_port
#pragma HLS INTERFACE s_axilite register port=return
#pragma HLS RealProbe

  din_t A_buff[N];
  dout_t B_buff[N];

  memcpy(&A_buff[0], const_cast<din_t*>(A), sizeof(din_t) * N);

    int i,j;
    dint_t acc;

    LOOP_I:for(i=0; i < N; i++)
    {
        acc = 0;
        LOOP_J: for(j=0; j < N; j++)
        {
            acc += A_buff[j] * j;
        }
        if (i%2 == 0)
            B_buff[i] = acc / N;
        else
            B_buff[i] = 0;
    }
  memcpy(const_cast<dout_t*>(B), const_cast<dout_t*>(&B_buff[0]), sizeof(dout_t) * N);

}
