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

#include <cstdio>
#include <cstdlib>
#include <iostream>
#include <cmath>
using namespace std;

#include "fxp_sqrt_top.h"

// #define NUM_TEST_ITERS ITER//0000
#define MIN_ITER_IDX 0
#define MAX_ITER_IDX (MIN_ITER_IDX + ITER)

#define MY_DRAND() (rand() * rand() / (double)(RAND_MAX * RAND_MAX + 1))

#define ABS_ERR_THRESH (0.0 / (double)(1ll << (OUT_BW - OUT_IW)))

// Test program for validating C-model functionality and RTL co-simulation
int main(int argc, char *argv[])
{
   in_data_t test_val[ITER] = {0,};
   in_data_t min_test_val = 0;
   in_data_t max_test_val = 0;
   out_data_t hw_outval[ITER] = {0,};
   ap_ufixed<OUT_BW,OUT_IW,AP_RND> sw_outval[ITER] = {0,};
   unsigned err_cnt = 0;

   min_test_val.range(IN_BW - 1, 0) = ap_uint<IN_BW>(-1LL);
   max_test_val = 0.0;

   for (uint32_t i = MIN_ITER_IDX; i < MAX_ITER_IDX; i++) {
      if ( 0 )//NUM_TEST_ITERS <= 100)
         test_val[i] = i;
      else
         test_val[i] = double(1LL << IN_IW) * MY_DRAND();
      if (min_test_val > test_val[i]) min_test_val = test_val[i];
      if (max_test_val < test_val[i]) max_test_val = test_val[i];
   }
   // Run theVivado HLStop-level function
   fxp_sqrt_top(test_val, hw_outval);

   for (uint32_t i = MIN_ITER_IDX; i < MAX_ITER_IDX; i++) {

      // Check value against floating point reference value rounded to input format
      sw_outval[i] = sqrt(test_val[i].to_double());

      // if (NUM_TEST_ITERS <= 100) {
      //    cout << "sqrt(" << test_val <<") = " << sw_outval << ";\t";
      //    cout << "sqrt_fxp(" << test_val << ") = " << hw_outval << endl;
      // } else {
      //    if (i == 0)
      //       cout << "Running test.";
      //    else if (!(i % (NUM_TEST_ITERS / 100))) {
      //       cout << ".";
      //       fflush(stdout);
      //    }
      // }
      if (fabs(hw_outval[i].to_double() - sw_outval[i].to_double()) > ABS_ERR_THRESH) {
         cout << "MISMATCH (" << i << "): \t";
         cout << "fxp_sqrt(" << test_val << ") = " << hw_outval[i];
         cout << "\tDelta = " << (hw_outval[i].to_double() - sw_outval[i].to_double());
         cout << "\thw_outval/sw_outval = " << (hw_outval[i].to_double() / sw_outval[i].to_double());
         cout << endl << endl;
         err_cnt++;
      }

      cout << "fxp_sqrt(" << test_val[i] << ") = " << hw_outval[i] << "sw_outval: " << sw_outval[i] << endl;

   }

   cout << endl;
   cout << "Min tested val: " << min_test_val;
   cout << "\tMax tested val: " << max_test_val << endl;
   if (err_cnt) {
      cout << "!!! ERROR: " << err_cnt << " mismatches detected !!!";
      cout << endl << endl;
   } else {
      cout << "*** Test passes ***" << endl << endl;
   }
   if (err_cnt)
       return 1;
   else
       return 0;
}


