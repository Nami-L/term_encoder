#def saludar_persona(nombre):
#        print(f"Hola, {nombre}")
#saludar_persona ("Luis")

# def resta(a, b):
#     resultado = a - b
#     print(f"La resta es: {resultado}")

# resta(7,2)

# def suma():
#     a = int (input ("Dame el numero a:"))
#     b = int (input ("Dame el numero b:"))
#     print("La suma es : ", a + b)

# suma()

#Crear una primero las carpetas en UVM

#import os # Me permite crear, mover, cambiar, ejecturar carpetas

#os.mkdir("mi_carpeta") #Esto es para crear carpetas
#os.makedirs("mi_carpeta", exist_ok=True)

############## VOY A CREAR UNA ESTRUCTURA DE CARPETAS QUE SE TIENEN QUE UTILIZAR

import os
def crear_carpetas_uvm(Nombre_Proyecto ="Sumador",nombre_uvc_f="adder"):

 ## LAS CARPETAS QUE UTILIZA MI JERARQUÍA UVM
    carpetas = [
            f"{Nombre_Proyecto}",
            f"{Nombre_Proyecto}/rtl", 
            f"{Nombre_Proyecto}/verification",
            f"{Nombre_Proyecto}/verification/env",
            f"{Nombre_Proyecto}/verification/rtl",
            f"{Nombre_Proyecto}/verification/scripts",
            f"{Nombre_Proyecto}/verification/tb",
            f"{Nombre_Proyecto}/verification/tests",
            f"{Nombre_Proyecto}/verification/sv",
            f"{Nombre_Proyecto}/verification/sv/seqlib"

    ]

## ARCHIVOS DE MI JERARQUÍA UVM PARA COMPILAR EN VIVADO

    archivos = [ 
            f"{Nombre_Proyecto}/verification/sve.f",
            f"{Nombre_Proyecto}/verification/.gitignore",
            f"{Nombre_Proyecto}/verification/{nombre_uvc_f}_uvc.f",
            f"{Nombre_Proyecto}/verification/README.md"
    ]

#FUNCION PARA CREAR LAS CAPERTAS Y SUBCARPETAS UTILIZANDO LA FUNCION FOR

    for carpeta in carpetas:
        os.makedirs(carpeta, exist_ok=True)
        print(f"Creando carpetas y subcarpetas: {carpeta}")

#FUNCION PARA CREAR LOS ARCHIVOS DENTROS DE LA CARPERA verification
    for archivo in archivos:
        archivo_dir = os.path.dirname(archivo)
        os.makedirs(archivo_dir,exist_ok=True)
        with open(archivo, "w") as f:
            f.write("")
        print (f"Archivo creado correctamente: {archivo}")

#VAMOS A MODIFICAR EL README, Y PARA ELLO AGREGAREMOS LAS CARACTERISTICAS NECESARIAS

    ruta_README = f"{Nombre_Proyecto}/verification/README.md"
    with open(ruta_README,"w") as f:
        f.write( """ 
# SUMADOR IP UVM verification

Este proyecto tiene como objetivo que el usuario entienda como se construye una arquitectura UVM Básica.

## Setup

A continuación se colocan una serie de comando que deben ejecutarse desde terminal.

```bash
export GIT_ROOT=$(git rev-parse --show-toplevel)
export UVM_WORK="$GIT_ROOT/work/uvm"
mkdir -p work/uvm && cd work/uvm
ln -sf $GIT_ROOT/verification/uvm/scripts/makefiles/Makefile.xilinx Makefile
ln -sf $GIT_ROOT/verification/uvm/scripts/setup/setup_vivado_eda.sh
source setup_synopsys_eda.tcsh
make
```
""")

#AGREGAMOS LOS ARCHIVOS NCESARIOS PARA SVE 

    ruta_SVE = f"{Nombre_Proyecto}/verification/sve.f"
    with open(ruta_SVE,"w") as f:
        f.write( """ 
-i $UVM_ROOT/env
-i $UVM_ROOT/tests
-i $UVM_ROOT/tb
$UVM_ROOT/env/top_env_pkg.sv
$UVM_ROOT/tests/top_test_pkg.sv
$UVM_ROOT/tb/tb.sv
""")

#AGREGAMOS LOS ARCHIVOS NCESARIOS PARA EL RTL

    ruta_RTL = f"{Nombre_Proyecto}/verification/{nombre_uvc_f}_uvc.f"
    with open(ruta_RTL,"w") as f:
        f.write( """ 
-i $UVM_ROOT/sv
-i $UVM_ROOT/sv/seqlib
$UVM_ROOT/sv/adder_uvc_pkg.sv
$UVM_ROOT/sv/adder_uvc_if.sv
""")

#AGREGAMOS LA CONFIGURACION PARA EL GITIGNORE

    ruta_GIT = f"{Nombre_Proyecto}/verification/.gitignore"
    with open(ruta_GIT,"w") as f:
        f.write( """ 
# Directories
work/

# Files
Makefile
*.exe
*.o
*.pdf
""")

## CREAMOS LOS ARCHIVOS NECESARIOS PARA EL ENVIRONMENT
    files_env = [
            f"{Nombre_Proyecto}/verification/env/top_coverage.sv",
            f"{Nombre_Proyecto}/verification/env/top_env_pkg.sv",
            f"{Nombre_Proyecto}/verification/env/top_env.sv",
            f"{Nombre_Proyecto}/verification/env/top_scoreboard.sv",
            f"{Nombre_Proyecto}/verification/env/top_vsqr.sv"

    ]

    for files_e in files_env:
        files_dir = os.path.dirname(files_e)
        os.makedirs(files_dir,exist_ok=True)
        with open(files_e, "w") as f:
            f.write("")
        print (f"Archivos del Environment: {files_e}")

## CREAR TODOS LOS ARCHIVOS PARA EL SV

    files_sistemV = [
            f"{Nombre_Proyecto}/verification/env/sv/{nombre_uvc_f}_uvc_agent.sv",
            f"{Nombre_Proyecto}/verification/env/sv/{nombre_uvc_f}_uvc_config.sv",
            f"{Nombre_Proyecto}/verification/env/sv/{nombre_uvc_f}_uvc_driver.sv",
            f"{Nombre_Proyecto}/verification/env/sv/{nombre_uvc_f}_uvc_if.sv",
            f"{Nombre_Proyecto}/verification/env/sv/{nombre_uvc_f}_uvc_monitor.sv",
            f"{Nombre_Proyecto}/verification/env/sv/{nombre_uvc_f}_uvc_pkg.sv",
            f"{Nombre_Proyecto}/verification/env/sv/{nombre_uvc_f}_uvc_sequence_item.sv",
            f"{Nombre_Proyecto}/verification/env/sv/{nombre_uvc_f}_uvc_sequencer.sv"
    ]

    for files_sv in files_sistemV:
        files_dir = os.path.dirname(files_sv)
        os.makedirs(files_dir,exist_ok=True)
        with open(files_sv, "w") as f:
            f.write("")
        print (f"Archivos del Environment: {files_sv}")

## CREAR TODOS LOS ARCHIVOS PARA EL TEST

    files_tests = [
            f"{Nombre_Proyecto}/verification/env/tests/top_test_pkg.sv",
            f"{Nombre_Proyecto}/verification/env/tests/top_test_vseq.sv",
            f"{Nombre_Proyecto}/verification/env/tests/top_test.sv"
    ]

    for files_tes in files_tests:
        files_dir = os.path.dirname(files_tes)
        os.makedirs(files_dir,exist_ok=True)
        with open(files_tes, "w") as f:
            f.write("")
        print (f"Archivos del TEST: {files_tes}")


## CREAR TODOS LOS ARCHIVOS PARA EL TB  

    files_TOP= [
            f"{Nombre_Proyecto}/verification/env/tb/tb.sv"
    ]

    for files_tb in files_TOP:
        files_dir = os.path.dirname(files_tb)
        os.makedirs(files_dir,exist_ok=True)
        with open(files_tb, "w") as f:
            f.write("")
        print (f"Archivos del TB: {files_tb}")

##CREAR LA ELABORACION DE LA ARQUTIECTURA BASE/ESQUELETO DE CADA COMPONENTE UVM




#llamamos la funcion
crear_carpetas_uvm("Term_encoder","term_encoder")

