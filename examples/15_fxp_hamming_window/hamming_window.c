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
#include "hamming_window.h" // Provides default WINDOW_LEN if not user defined

// Translation module function prototypes:
static void hamming_rom_init(int16_t rom_array[]);

// Function definitions:
void hamming_window(int32_t outdata[WINDOW_LEN], int16_t indata[WINDOW_LEN])
{
#pragma HLS INTERFACE m_axi port = outdata depth=256 offset = slave bundle = a_port
#pragma HLS INTERFACE m_axi port = indata depth=256 offset = slave bundle = b_port
#pragma HLS INTERFACE s_axilite register port=return
#pragma HLS RealProbe

   int16_t in_buff[WINDOW_LEN];
   int32_t out_buff[WINDOW_LEN];

  memcpy(&in_buff[0], indata, sizeof(int16_t) * WINDOW_LEN);

   static int16_t window_coeff[WINDOW_LEN];
   unsigned i;

   // In order to ensure that 'window_coeff' is inferred and properly
   // initialized as a ROM, it is recommended that the arrya initialization
   // be done in a sub-function with global (wrt this source file) scope.
   hamming_rom_init(window_coeff);

   for (i = 0; i < WINDOW_LEN; i++) {
#pragma HLS pipeline
      out_buff[i] = (int32_t)window_coeff[i] * (int32_t)in_buff[i];
   }

   //  memcpy(const_cast<int32_t*>(outdata), const_cast<int32_t*>(&out_buff[0]), sizeof(int32_t) * WINDOW_LEN);
   memcpy(outdata, &out_buff[0], sizeof(int32_t) * WINDOW_LEN);

}

// This initialization function will be optimized away during high level
// sythesis (HLS), resulting in the underlying memory being inferred as a ROM
// by RTL synthesis.
static void hamming_rom_init(int16_t rom_array[WINDOW_LEN])
{
   int i;
   for (i = 0; i < WINDOW_LEN; i++) {
      float real_val = 0.54f -
         0.46f * cos(2.0f * M_PI * i / (float)(WINDOW_LEN - 1));
      rom_array[i] = (int16_t)(WIN_COEFF_SCALE * real_val);
   }
}


