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

function LHYdot = LHY_System(t, LHY, param)
// The LHY system

// Fetching LHY system parameters
a = param.a;
b = param.b;
g = param.g;
delta = param.delta;

// Fetching solution
L = LHY(1,:);
H = LHY(2,:);
Y = LHY(3,:);

// Evaluation of initiation
I = LHY_Initiation(L, H, Y, param);

// Compute Ldot
Ldot = I - (a+b)*L;
Hdot = b*L - g*H;
Ydot = H - delta*Y;

LHYdot = [Ldot; Hdot; Ydot];

endfunction
