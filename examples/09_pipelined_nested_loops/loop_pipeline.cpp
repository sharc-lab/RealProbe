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
#include "loop_pipeline.h"

dout_t loop_pipeline(din_t A[N]) {  
#pragma HLS INTERFACE m_axi port = A depth=20 offset = slave bundle = a_port
#pragma HLS INTERFACE s_axilite port=return
#pragma HLS RealProbe

  din_t A_buff[N];
  memcpy(&A_buff[0], const_cast<din_t*>(A), sizeof(din_t) * N);

  	int i,j;
	static dout_t acc;
  
	LOOP_I:for(i=0; i < 20; i++){
		LOOP_J: for(j=0; j < 20; j++){
			acc += A_buff[j] * i;
		}
	}

	return acc;
}
