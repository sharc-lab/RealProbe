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

#include "fxp_sqrt_top.h"


void fxp_sqrt_top(
   volatile in_data_t *in_val,
   volatile out_data_t *out_val)
{
   #pragma HLS INTERFACE m_axi port = in_val depth=512 offset = slave bundle = a_port
   #pragma HLS INTERFACE m_axi port = out_val depth=512 offset = slave bundle = b_port
   #pragma HLS interface s_axilite register port=return
   #pragma HLS RealProbe

   in_data_t in_val_buff[ITER];
   out_data_t out_val_buff[ITER];

   memcpy(&in_val_buff[0], const_cast<in_data_t*>(in_val), sizeof(in_data_t) * ITER);
   memcpy(&out_val_buff[0], const_cast<out_data_t*>(out_val), sizeof(out_data_t) * ITER);

   fxp_sqrt(out_val_buff, in_val_buff, ITER);

   memcpy(const_cast<out_data_t*>(out_val), const_cast<out_data_t*>(&out_val_buff[0]), sizeof(out_data_t) * ITER);

   // return result;
}


