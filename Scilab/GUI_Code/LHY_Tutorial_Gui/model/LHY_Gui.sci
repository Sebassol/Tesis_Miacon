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

function [] = LHY_Gui() 
	// Visual application

	// -------------------------------
	// Step : Store default parameters
	// -------------------------------
	
	// Default simulation parameters
	param = [];
	param.tau   = 5e4;      // Number of innovators per year (initiation)
	param.s     = 0.61;     // Annual rate at which light users attract non-users (initiation)
	param.q     = 3.443;    // Constant which measures the deterrent effect of heavy users (initiation)
	param.smax  = 0.1;      // Lower bound for s effective (initiation)
	param.a     = 0.163;    // Annual rate at which light users quit
	param.b     = 0.024;    // Annual rate at which light users escalate to heavy use
	param.g     = 0.062;    // Annual rate at which heavy users quit
	param.delta = 0.291;    // Forgetting rate

	// Simulation data
	// Time variables
	sim = [];
	sim.Tbegin = 1970;          // Initial time
	sim.Tend   = 2020;          // Final time
	sim.Tstep  = 1/12;          // Time step
	// Initial conditions
	sim.L0 = 1.4e6;             // Light users at the initial time
	sim.H0 = 0.13e6;            // Heavy users at the initial time
	sim.Y0 = 0.11e6;            // Decaying heavy user at the initial time

	// ----------------------------
	// Step : Empty window creation
	// ----------------------------
	
	// Global window parameters
	global margin_x margin_y;
	global frame_w frame_h plot_w plot_h;

	// Window Parameters initialization
	frame_w = 300; frame_h = 550;		// Frame width and height
	plot_w = 600; plot_h = frame_h;	// Plot width and heigh
	margin_x = 15; margin_y = 15;		// Horizontal and vertical margin for elements
	defaultfont = "arial"; 			// Default Font
	axes_w = 3*margin_x + frame_w + plot_w;	// axes width
	axes_h = 2*margin_y + frame_h;          	// axes height (100 => toolbar height)
	demo_lhy = scf(100001);			// Create window with id=100001 and make it the current one
	
	// Background and text
	demo_lhy.background      = -2;
	demo_lhy.figure_position = [100 100];
	demo_lhy.figure_name     = gettext("LHY solution");
	
	// Change dimensions of the figure
	demo_lhy.axes_size = [axes_w axes_h];
	
	// ------------------
	// Step : Window menu
	// ------------------
	
	// Remove Scilab graphics menus & toolbar
	delmenu(demo_lhy.figure_id,gettext("&File"));
	delmenu(demo_lhy.figure_id,gettext("&Tools"));
	delmenu(demo_lhy.figure_id,gettext("&Edit"));
	delmenu(demo_lhy.figure_id,gettext("&?"));
	toolbar(demo_lhy.figure_id,"off");

	// New menu
	h1 = uimenu("parent",demo_lhy, "label",gettext("File"));
	h2 = uimenu("parent",demo_lhy, "label",gettext("About"));
	
	// Populate menu: file
	uimenu("parent",h1, "label",gettext("Close"), "callback", "demo_lhy=get_figure_handle(100001);delete(demo_lhy);", "tag","close_menu");
	
	// Populate menu: about
	uimenu("parent",h2, "label",gettext("About"), "callback","LHY_About();");
	// Sleep to guarantee a better display (avoiding to see a sequential display)
	sleep(500);
   
	// ---------------------
	// Step : Create a frame
	// ---------------------
	
	// Frames creation [LHY parameters]
	my_frame = uicontrol("parent",demo_lhy, "relief","groove", ...
		"style","frame", "units","pixels", ...
		"position",[ margin_x margin_y frame_w frame_h], ...
		"horizontalalignment","center", "background",[1 1 1], ...
		"tag","frame_control");

	// Frame title
	my_frame_title = uicontrol("parent",demo_lhy, "style","text", ...
		"string","LHY parameters", "units","pixels", ...
		"position",[30+margin_x margin_y+frame_h-10 frame_w-60 20], ...
		"fontname",defaultfont, "fontunits","points", ...
		"fontsize",16, "horizontalalignment","center", ...
		"background",[1 1 1], "tag","title_frame_control");

	// -------------------------
	// Step : Populate the frame
	// -------------------------
	// Adding model parameters
	guih1 = frame_w;
	guih1o = 240;
	// ordered list of labels
	labels1 = ["Tau", "s", "q", "smax", "a", "b", "g", "delta"];
	// ordered list of default values
	values1 = [5e4, 0.61, 3.443, 0.1, 0.163, 0.024, 0.062, 0.291];
	// positioning
	l1 = 40; l2 = 100; l3 = 110;
	for k=1:size(labels1,2)
		uicontrol("parent",demo_lhy, "style","text",...
			"string",labels1(k), "position",[l1,guih1-k*20+guih1o,l2,20], ...
			"horizontalalignment","left", "fontsize",14, ...
			"background",[1 1 1]);
     
		guientry1(k) = uicontrol("parent",demo_lhy, "style","edit", ...
			"string",string(values1(k)), "position",[l3,guih1-k*20+guih1o,180,20], ...
			"horizontalalignment","left", "fontsize",14, ...
			"background",[.9 .9 .9], "tag",labels1(k));
	end

	// Adding simulation paramters
	guih2 = 240;
	guih2o = 80;
	labels2 = ["Tbegin", "Tend", "Tstep"];
	values2 = [1970, 2020, 0.5];
	l1 = 40; l2 = 100; l3 = 110;
	for k=1:size(labels2,2)
		uicontrol("parent",demo_lhy, "style","text", ...
			"string",labels2(k), "position",[l1,guih2-k*20+guih2o,l2,20], ...
			"horizontalalignment","left", "fontsize",14, ...
			"background",[1 1 1]);
	
		guientry2(k) = uicontrol("parent",demo_lhy, "style","edit", ...
			"string",string(values2(k)), "position",[l3,guih2-k*20+guih2o,180,20], ...
			"horizontalalignment","left", "fontsize",14, ...
			"background",[.9 .9 .9], "tag",labels2(k));
	end

	// Adding initial conditions
	guih3 = 150;
	guih3o = 80;
	labels3 = ["L0", "H0", "Y0"];
	values3 = [1.4e6, 0.13e6, 0.11e6];
	l1 = 40; l2 = 100; l3 = 110;
	for k=1:size(labels3,2)
		uicontrol("parent",demo_lhy, "style","text", ...
			"string",labels3(k), "position",[l1,guih3-k*20+guih3o,l2,20], ...
			"horizontalalignment","left", "fontsize",14, ...
			"background",[1 1 1]);
     
		guientry3(k) = uicontrol("parent",demo_lhy, "style","edit", ...
			"string",string(values3(k)), "position",[l3,guih3-k*20+guih3o,180,20], ...
			"horizontalalignment","left", "fontsize",14,...
			"background",[.9 .9 .9], "tag",labels3(k));
	end

	// Adding button
	huibutton = uicontrol(demo_lhy, "style","pushbutton", ...
		"Position",[110 100 100 20], "String","Compute", ...
		"BackgroundColor",[.9 .9 .9], "fontsize",14, ...
		"Callback","syscompute");

	// Compute solution
	sol = solvingProblem(param, sim);

	// Redraw window
	drawlater();
	newaxes();
	displayProblem(sol);
	drawnow();
endfunction



function syscompute
	// retrive data
	param = [];
	tau = findobj("tag", "Tau");		param.tau = evstr(tau.string);
	s = findobj("tag", "s");			param.s = evstr(s.string);
	q = findobj("tag", "q");			param.q = evstr(q.string);
	smax = findobj("tag", "smax");	param.smax = evstr(smax.string);
	a = findobj("tag", "a");			param.a = evstr(a.string);
	b = findobj("tag", "b");			param.b = evstr(b.string);
	g = findobj("tag", "g");			param.g = evstr(g.string);
	delta = findobj("tag", "delta");	param.delta = evstr(delta.string);

	sim = [];
	Tbegin = findobj("tag", "Tbegin");sim.Tbegin = evstr(Tbegin.string);
	Tend = findobj("tag", "Tend");	sim.Tend = evstr(Tend.string);
	Tstep = findobj("tag", "Tstep");	sim.Tstep = evstr(Tstep.string);
	L0 = findobj("tag", "L0");			sim.L0 = evstr(L0.string);
	H0 = findobj("tag", "H0");			sim.H0 = evstr(H0.string);
	Y0 = findobj("tag", "Y0");			sim.Y0 = evstr(Y0.string);
   
	// Compute solution
	sol = solvingProblem(param, sim);

	// Redraw window
	drawlater();
	my_plot_axes = gca();
	my_plot_axes.title.text = "LHY solution";
	newaxes();
	displayProblem(sol);
	drawnow();
endfunction

function sol = solvingProblem(param, sim)
	// Compute the solution
	sol = struct();

	// Assign ODE solver data
	y0 = [sim.L0;sim.H0;sim.Y0];
	t0 = sim.Tbegin;
	t = sim.Tbegin:sim.Tstep:(sim.Tend+100*%eps);
	f = LHY_System;

	// Solving the system
	sol.LHY = ode(y0, t0, t, f);
	sol.t = t;
endfunction

function displayProblem(solh)   
	// Fetching solution
	LHY = sol.LHY;
	t = sol.t;
	L = LHY(1,:); H = LHY(2,:); Y = LHY(3,:);

	// Evaluate initiation
	I = LHY_Initiation(L,H,Y, param);

	// maximum values for nice plot
	[Lmax, Lindmax] = max(L); tL = t(Lindmax);
	[Hmax, Hindmax] = max(H); tH = t(Hindmax);
	[Ymax, Yindmax] = max(Y); tY = t(Yindmax);
	[Imax, Iindmax] = max(I); tI = t(Iindmax);

	// Text of the maximum point
	Ltext = msprintf(' ( %4.1f , %7.0f)',tL,Lmax);
	Htext = msprintf(' ( %4.1f , %7.0f)',tH,Hmax);
	Ytext = msprintf(' ( %4.1f , %7.0f)',tY,Ymax);
	Itext = msprintf(' ( %4.1f , %7.0f)',tI,Imax);

	// Plotting of model data
	delete(gca());
	plot(t,[LHY;I]);
	legend(['Light Users';'Heavy users';'Memory';'Initiation']);

	// Vertical line
	set(gca(),"auto_clear","off");
	xpolys([tL,tH,tY,tI;tL,tH,tY,tI],[0,0,0,0;Lmax,Hmax,Ymax,Imax]);

	// Text of maximum point
	xstring(tL,Lmax,Ltext); xstring(tH,Hmax,Htext);
	xstring(tY,Ymax,Ytext); xstring(tI,Imax,Itext);
	xlabel('Year');
	set(gca(),"auto_clear","on");

	my_plot_axes = gca();
	my_plot_axes.title.font_size = 5;
	my_plot_axes.axes_bounds = [1/3,0,2/3,1];
	my_plot_axes.title.text = "LHY solution";
endfunction

function LHY_About()
	msg = msprintf(gettext("LHY is developed by the Openeering Team.\nAuthor: M. Venturin"));
	messagebox(msg, gettext("About"), "info", "modal");
endfunction

