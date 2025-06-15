//    Copyright 2012 Manolo Venturin, EnginSoft S.P.A.
// 
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
// 
//        http://www.apache.org/licenses/LICENSE-2.0
// 
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.

function I = LHY_Initiation(L, H, Y, param)
// It returns the number of initiation for the LHY model.
//
// Input:
// L = number of light users,
// H = number of heavy users,
// Y = decaying heavy user years,
// param is a structure with the model parameters:
// param.tau  = number of innovators per year,
// param.s    = annual rate at which light users attract non-users,
// param.q    = deterrent effect of heavy users constant,
// param.smax = maximum feedback rate.
//
// Output:
// I    = initiation.
//
// Description:
// The initiation function.

// Fetching
tau  = param.tau;
s    = param.s;
q    = param.q;
smax = param.smax;

// Compute s effective
seff = s*exp(-q*Y./L);
seff = max(smax,seff);

// Compute initiation (vectorized formula)
I = tau + seff.*L;

endfunction
