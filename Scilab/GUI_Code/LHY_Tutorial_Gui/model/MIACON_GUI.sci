//-AQUI VA EL COPYRIGTH-----------//


function [] = MIACON_Gui()

// --- Global config ---
global defaultfont controller_buttons;
defaultfont = "arial";

// Crear ventana principal
demo_lhy = scf(100001);
demo_lhy.figure_position = [100 100];
demo_lhy.figure_size = [1000 600];
demo_lhy.figure_name = "MIACON - Sistema de Control";
demo_lhy.background = -2;

// Limpiar menú default de Scilab
delmenu(demo_lhy.figure_id,gettext("&File"));
delmenu(demo_lhy.figure_id,gettext("&Tools"));
delmenu(demo_lhy.figure_id,gettext("&Edit"));
delmenu(demo_lhy.figure_id,gettext("&?"));
toolbar(demo_lhy.figure_id,"off");

// --- FRAME PRINCIPAL ---
my_frame = uicontrol("parent", demo_lhy, "relief", "groove", ...
    "style", "frame", "units", "normalized", ...
    "position", [0.02 0.02 0.28 0.90], ...
    "background", [1 1 1], ...
    "tag", "frame_control");

// --- Título Principal ---
my_frame_title = uicontrol("parent", my_frame, "style", "text", ...
    "string", "Controlador", "units", "normalized", ...
    "position", [0.05 0.92 0.9 0.05], ...
    "fontname", defaultfont, "fontsize", 16, ...
    "horizontalalignment", "center", ...
    "background", [1 1 1]);

// --- BLOQUE DE BOTONES DE CONTROLADORES ---
controllers = ["OFF", "P", "PI", "PD", "PID"];
controller_buttons = [];

n_ctrl = size(controllers, "*");
startX = 0.01;
startY = 0.85;
buttonW = 0.19;
buttonH = 0.05;
gap = 0.008;

for i = 1:n_ctrl
    btn = uicontrol("parent", my_frame, "style", "pushbutton", ...
        "string", controllers(i), ...
        "units", "normalized", ...
        "position", [startX + (i-1)*(buttonW+gap) startY buttonW buttonH], ...
        "fontsize", 10, ...
        "tag", "ctrl_"+controllers(i), ...
        "callback", "controller_select("+string(i)+")");
    controller_buttons = [controller_buttons btn];
end

// --- Título de constantes ---
uicontrol("parent", my_frame, "style", "text", ...
    "string", "Constantes PID. ", ...
    "units", "normalized", ...
    "position", [0.05 0.78 0.9 0.05], ...
    "fontname", defaultfont, "fontsize", 14, ...
    "horizontalalignment", "center", ...
    "background", [1 1 1]);

// --- Sliders dinámicos para Kp, Ki, Kd ---

labels_pid = ["Kp", "Ki", "Kd"];
n_pid = size(labels_pid, "*");

startY = 0.70;
stepY  = 0.08;
label_w = 0.10;
slider_w = 0.60;
edit_w = 0.20;

for k = 1:n_pid
    posY = startY - (k-1)*stepY;

    // Label
    uicontrol("parent", my_frame, "style","text", ...
        "string", labels_pid(k), "units", "normalized", ...
        "position", [0.05 posY label_w 0.05], ...
        "fontsize", 14, "background", [1 1 1]);

    // Slider
    uicontrol("parent", my_frame, "style", "slider", ...
        "min", 0, "max", 1000, "value", 1, ...
        "units", "normalized", ...
        "position", [0.05+label_w posY slider_w 0.05], ...
        "fontsize", 12, "tag", "slider_"+labels_pid(k), ...
        "callback", "update_slider_value('"+labels_pid(k)+"')");

    // Editbox numérico asociado
    uicontrol("parent", my_frame, "style","edit", ...
        "string", "1.0", ...
        "units", "normalized", ...
        "position", [0.05+label_w+slider_w+0.02 posY edit_w 0.05], ...
        "fontsize", 12, "background", [.9 .9 .9], ...
        "tag", "edit_"+labels_pid(k));
        
end

  // --- Título de Set point ---
    uicontrol("parent", my_frame, "style", "text", ...
        "string", "Set Point.", ...
        "units", "normalized", ...
        "position", [0.05 0.47 0.9 0.05], ...
        "fontname", defaultfont, "fontsize", 14, ...
        "horizontalalignment", "center", ...
        "background", [1 1 1]);
        
        
Set_point = ["Temperatura", "Humedad", "Velocidad", "Posición"];
n_pid2 = size(Set_point, "*");


// Definir nueva posición de inicio para SetPoint después de sliders PID
startY_setpoint = startY - n_pid*stepY - 0.05;
stepY_setpoint = 0.1;  // Un poco más compacto



label_w2=0.4;

for ki = 1:n_pid2
    posY2 = startY_setpoint - (ki-1)*stepY_setpoint;
        
    // Label de SetPoint
    uicontrol("parent", my_frame, "style","text", ...
        "string", Set_point(ki), "units", "normalized", ...
        "position", [0.1 posY2 label_w2 0.05], ...
        "fontsize", 14, "background", [1 1 1]);

    // Editbox numérico asociado
    uicontrol("parent", my_frame, "style","edit", ...
        "string", "1.0", ...
        "units", "normalized", ...
        "position", [0.1+label_w2+0.1 posY2 edit_w 0.05], ...
        "fontsize", 12, "background", [.9 .9 .9], ...
        "tag", "edit_"+ Set_point(ki));
end
        // --- Botón SET para el Set Point ---

    button_set_posY = posY2 - 0.1;  // bajamos un poco después de los setpoints
    
     uicontrol("parent", my_frame, "style","pushbutton", ...
        "units", "normalized", ...
        "position", [0.3 button_set_posY 0.4 0.06], ...
        "string", "SET", ...
        "backgroundcolor", [.9 .9 .9], ...  // <- esta es la forma correcta
        "fontsize", 14, ...
        "tag", "setpoint_button", ...
        "callback", "setpoint_callback()");
        
// --- Botón SET en estilo uniforme ---
uicontrol("parent", my_frame, "style","pushbutton", ...
    "units", "pixels", ...
    "position", [0.3 button_set_posY 0.4 0.06], ...  // posición ajustada (puedes mover estos valores)
    "string", "SET", ...
    "backgroundcolor", [.9 .9 .9], ...
    "fontsize", 12, ...
    "tag", "setpoint_button", ...
    "callback", "setpoint_callback()");

endfunction

// ====================================
// Función que sincroniza slider y edit
// ====================================

function update_slider_value(label)

    slider_obj = findobj("tag", "slider_"+label);
    edit_obj = findobj("tag", "edit_"+label);
    value = slider_obj.value;
    edit_obj.string = string(round(value*100)/100);

endfunction

// =====================================
// Función para manejar selección única
// =====================================

function controller_select(selected_id)

    global controller_buttons
    n_ctrl = size(controller_buttons, "*");

    for i=1:n_ctrl
        if i == selected_id then
            controller_buttons(i).backgroundcolor = [0.5 0.8 0.5];
        else
            controller_buttons(i).backgroundcolor = [0.9 0.9 0.9];
        end
    end

endfunction

MIACON_Gui();
