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
#include "cpp_FIR.h"

// Top-level function with class instantiated
void cpp_FIR(volatile data_t* x, volatile data_t* y)
  {
#pragma HLS INTERFACE m_axi port = x depth=251 offset = slave bundle = a_port
#pragma HLS INTERFACE m_axi port = y depth=251 offset = slave bundle = b_port
#pragma HLS interface s_axilite register port=return
#pragma HLS RealProbe 

    data_t in_buff[251];
    data_t out_buff[251];

    memcpy(&in_buff[0], const_cast<data_t*>(x), sizeof(data_t) *251);

    for (int i = 0; i <= 250; i++){
      static CFir<coef_t, data_t, acc_t> fir1;
      out_buff[i] = fir1(in_buff[i]);
    }

    memcpy(const_cast<data_t*>(y), const_cast<data_t*>(&out_buff[0]), sizeof(data_t) * 251);

  }

