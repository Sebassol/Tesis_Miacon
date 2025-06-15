function ControlSystemGUI()
    // --- Parámetros globales ---
    global sensor1_data sensor2_data sensor3_data
    global actuator1_state actuator2_state actuator3_state
    global controller_type connection_status serial_port
    global f text_control button_controls plot_handles
    global setpoint_values sp_controls
    
    // Inicialización de variables
    controller_type = "OFF";
    connection_status = 0;  // 0: Desconectado, 1: Conectado
    serial_port = -1;
    
    // Datos para sensores (circular buffer)
    buffer_size = 200;
    sensor1_data = zeros(1,buffer_size);
    sensor2_data = zeros(1,buffer_size);
    sensor3_data = zeros(1,buffer_size);
    time_data = 1:buffer_size;
    
    // Valores de setpoint
    setpoint_values = [25, 30, 35]; // Ejemplo para 3 variables
    
    // --- Crear ventana principal ---
    f = figure("figure_name", "Sistema de Control ESP32", ...
               "dockable", "off", ...
               "infobar_visible", "off", ...
               "toolbar_visible", "off", ...
               "figure_size", [1000, 600], ...
               "background", color(240, 240, 240));

    // --- Área de gráficos ---
    plot_handles = [];
    for i = 1:3
        subplot(3,1,i);
        plot_handles(i) = gca();
        plot(time_data, sensor1_data, 'b-', 'LineWidth', 2);
        xlabel("Tiempo (muestras)");
        ylabel(strcat(["Variable ", string(i)]));
        title(strcat(["Control en tiempo real - Variable ", string(i)]));
        grid on;
    end
    
    // --- Panel de control izquierdo ---
    control_panel = uicontrol(f, "style", "frame", ...
                            "position", [10 10 250 580], ...
                            "background", color(220,220,220));
    
    // Texto principal
    text_control = uicontrol(f, "style", "text", ...
              "string", "CONTROLADOR ESP32", ...
              "position", [20, 540, 230, 30], ...
              "fontsize", 14, "fontweight", "bold", ...
              "background", color(220,220,220));
    
    // Botones de controladores
    controllers = ["OFF", "P", "PD", "PI", "PID"];
    button_controls = [];
    for i = 1:5
        btn = uicontrol(f, "style", "pushbutton", ...
                 "string", controllers(i), ...
                 "position", [20, 490-(i-1)*40, 100, 30], ...
                 "fontsize", 10, ...
                 "callback", "update_controller_type('" + controllers(i) + "')");
        button_controls = [button_controls btn];
    end
    
    // Controles de setpoint
    sp_controls = [];
    for i = 1:3
        // Etiqueta
        uicontrol(f, "style", "text", ...
                "string", strcat(["Setpoint ", string(i)]), ...
                "position", [20, 350-(i-1)*60, 80, 20], ...
                "background", color(220,220,220));
        
        // Control numérico
        sp = uicontrol(f, "style", "edit", ...
                     "string", string(setpoint_values(i)), ...
                     "position", [110, 350-(i-1)*60, 60, 25], ...
                     "callback", "update_setpoint("+string(i)+")");
        sp_controls = [sp_controls sp];
    end
    
    // Botón de conexión
    uicontrol(f, "style", "pushbutton", ...
             "string", "Conectar ESP32", ...
             "position", [20, 50, 150, 40], ...
             "fontsize", 12, ...
             "callback", "connect_esp32()");
    
    // --- Temporizador para actualización ---
    timer_interval = 500; // ms
    timer_id = timer_create(timer_interval, "update_display");
    
    // --- Funciones de callback ---
    function update_controller_type(type)
        global controller_type;
        controller_type = type;
        disp("Controlador cambiado a: "+type);
        // Aquí enviar comando al ESP32
    endfunction
    
    function update_setpoint(var_num)
        global setpoint_values sp_controls;
        new_value = evstr(sp_controls(var_num).string);
        setpoint_values(var_num) = new_value;
        disp("Setpoint "+string(var_num)+" actualizado: "+string(new_value));
        // Aquí enviar nuevo setpoint al ESP32
    endfunction
    
    function connect_esp32()
        global connection_status;
        // Código para conectar con el ESP32 vía serial
        // ...
        connection_status = 1;
        disp("Conectado al ESP32");
    endfunction
    
    function update_display()
        global sensor1_data sensor2_data sensor3_data plot_handles;
        
        if connection_status then
            // Leer datos del ESP32 (simulado aquí)
            new_data1 = grand(1,1,"nor",25,1);
            new_data2 = grand(1,1,"nor",30,1.5);
            new_data3 = grand(1,1,"nor",35,2);
            
            // Actualizar buffers (desplazamiento)
            sensor1_data = [sensor1_data(2:$) new_data1];
            sensor2_data = [sensor2_data(2:$) new_data2];
            sensor3_data = [sensor3_data(2:$) new_data3];
            
            // Actualizar gráficos
            plot_handles(1).children.data(:,2) = sensor1_data';
            plot_handles(2).children.data(:,2) = sensor2_data';
            plot_handles(3).children.data(:,2) = sensor3_data';
        end
    endfunction
endfunction
// Iniciar la GUI
ControlSystemGUI();

// Ejemplo: Para actualizar sensores cada segundo
// while %t
//     update_sensors();
//     sleep(1000);
// end
    
    
    
    
    
    
