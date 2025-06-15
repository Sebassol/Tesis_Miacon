// Sistema de Control con ESP32 - GUI en Scilab
// Versión corregida y mejorada

function ControlSystemGUI()

    // --- Parámetros globales ---
    global sensor1_data sensor2_data sensor3_data
    global actuator1_state actuator2_state actuator3_state
    global controller_type connection_status serial_port
    global f text_control button_controls
    
    // Inicialización de variables
    controller_type = "NONE";
    connection_status = 0;  // 0: Desconectado, 1: Conectado
    serial_port = -1;
    
    // Datos de ejemplo para sensores
    sensor1_data = zeros(1,100);
    sensor2_data = zeros(1,100);
    sensor3_data = zeros(1,100);
    
    // --- Crear ventana principal ---
    f = figure("figure_name", "Sistema de Control ESP32", ...
               "dockable", "off", ...
               "infobar_visible", "off", ...
               "toolbar_visible", "off", ...
               "figure_size", [1000, 600], ...
               "background", color(240, 240, 240));

    show_window(f); // Importante para que figure_size esté actualizado

    // --- Crear controles de controladores ---
    
    // Texto principal
    text_control = uicontrol(f, "style", "text", ...
              "string", "TIPO DE CONTROLADOR", ...
              "position", [20, 350, 200, 30], ...
              "fontsize", 14, "fontweight", "bold");
    
    // Botones de controladores
    controllers = ["OFF", "P", "PD", "PI", "PID"];
    button_controls = [];
    for i = 1:5
        btn = uicontrol(f, "style", "pushbutton", ...
                 "string", controllers(i), ...
                 "position", [100, 400, 60, 25], ...
                 "fontsize", 10, ...
                 "callback", "update_controller_type('" + controllers(i) + "')");
        button_controls = [button_controls btn];
    end

    // --- Ajustar posiciones iniciales ---
    update_layout();

    // --- Asignar callback de resize ---
    f.resizefcn = "update_layout()";
    
endfunction


//--------------------SE ACTUALIZAN LOS TAMAÑOS DE LOS BOTONES SEGUN LA PANTALLA----------------------------------------


function update_layout()
    global f text_control button_controls;
    
    fig_size = f.figure_size;
    fig_height = fig_size(2);
    
    margin = 50;
    left_margin =5; // Margen izquierdo específico para los controles
    
    // Ajustar posición del texto (arriba a la izquierda)
    text_width = 200;
    text_height = 30;
    x_pos = left_margin;
    y_pos = fig_height - text_height - margin-10;
    text_control.position = [x_pos, y_pos, text_width, text_height];
    
    // Ajustar posiciones de botones (debajo del texto, alineados a la izquierda)
    n = length(button_controls);
    button_width = 40; // Ancho fijo para los botones
    button_height = 30;
    button_spacing = 3; // Espacio entre botones
    
    for i = 1:n
        bx = left_margin + (i-1)*(button_width + button_spacing);
        by = y_pos - button_height - 10; // 20px debajo del texto
        button_controls(i).position = [bx, by, button_width, button_height];
    end
endfunction


//-------------------------------CALL BACK-------------------------------------

// --- Funciones de callback ---
function update_controller_type(type)
    global controller_type
    controller_type = type;
    messagebox("Controlador cambiado a: " + type, "Configuración", "info");
endfunction

function connect_esp32()
    global connection_status serial_port
    
    if connection_status == 0 then
        // Simular conexión serial (en implementación real usar serialopen())
        serial_port = 1;  // Valor simulado
        connection_status = 1;
        
        findobj("tag", "connection_indicator").string = "CONECTADO";
        findobj("tag", "connection_indicator").background = [0.5, 1, 0.5];
        findobj("tag", "connect_button").string = "Desconectar";
        
        messagebox("Conexión establecida con ESP32", "Conexión", "info");
    else
        // Simular desconexión
        serial_port = -1;
        connection_status = 0;
        
        findobj("tag", "connection_indicator").string = "DESCONECTADO";
        findobj("tag", "connection_indicator").background = [1, 0.5, 0.5];
        findobj("tag", "connect_button").string = "Conectar ESP32";
    end
endfunction


function update_actuator(actuator_num)
    global actuator1_state actuator2_state actuator3_state
    
    slider_obj = findobj("tag", "actuator_" + string(actuator_num) + "_slider");
    value_obj = findobj("tag", "actuator_" + string(actuator_num) + "_value");
    
    if ~isempty(slider_obj) & ~isempty(value_obj) then
        slider_value = slider_obj.value;
        value_obj.string = string(slider_value);
        
        // Mapear a la tabla (-30 a 30 → -0.5 a 0.5)
        table_value = slider_value / 60;
        
        select actuator_num
        case 1 then
            actuator1_state = table_value;
        case 2 then
            actuator2_state = table_value;
        case 3 then
            actuator3_state = table_value;
        end
        
        // Actualizar la tabla visual
        update_actuator_table();
        
        disp("Actuador " + string(actuator_num) + " ajustado a: " + string(table_value));
    end
endfunction



// --- Función para actualizar gráficas ---
function update_sensors()
    global sensor1_data sensor2_data sensor3_data
    
    // Simular lectura de sensores (en implementación real leerías del ESP32)
    sensor1_data = [sensor1_data(2:$), rand()*100];
    sensor2_data = [sensor2_data(2:$), rand()*80 + 20];
    sensor3_data = [sensor3_data(2:$), rand()*50 + 50];
    
    // Actualizar gráficas
    drawlater();
    a1 = findobj("tag", "sensor1_axes");
    a1.children(1).data(:,2) = sensor1_data;
    
    a2 = findobj("tag", "sensor2_axes");
    a2.children(1).data(:,2) = sensor2_data;
    
    a3 = findobj("tag", "sensor3_axes");
    a3.children(1).data(:,2) = sensor3_data;
    drawnow();
endfunction


// Iniciar la GUI
ControlSystemGUI();

// Ejemplo: Para actualizar sensores cada segundo
// while %t
//     update_sensors();
//     sleep(1000);
// end
    
    
    
    
    
    
