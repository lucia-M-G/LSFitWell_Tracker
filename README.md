# 🏃🏽‍➡️​ LSFitWell

## 📌 Descripción
LSFitWell Tracker es un sistema de gestión de datos diseñado para una app de seguimiento de actividad física. A través del desarrollo de una base de datos en MySQL, se gestionan datos como:
- Tipos de actividad
- Duración
- Calorías quemadas
- Dispositivos utilizados

El proyecto se estructura por fases incrementales que abordan:
- Carga y tratamiento de datos
- Normalización y validación
- Seguridad y control
- Exportación de información

## ​📂 ​Estructura
```
LSFitWell_Tracker/
│
├── README.md                        # Documento explicativo del proyecto
├── memoria.pdf                      # Documentación final: modelo, diseño y validaciones
│
├── dades/
│   ├── prompt_IA.txt                # Prompt utilizado para generar datos ficticios
│   ├── activitats.csv               # CSV original con 100+ registros de actividades
│   └── activitats2.csv              # CSV adicional para pruebas con triggers
│
├── scripts/
│   ├── pas01.sql                    # Crear tabla 'activitats_raw' y cargar CSV
│   ├── pas02.sql                    # Crear 'activitats_net' y tratar datos
│   ├── pas03.sql                    # Tabla de control y exportación a CSV
│   ├── pas04.sql                    # Crear catálogo 'MD_activitat'
│   ├── pas05.sql                    # Procedimiento para detectar nuevas actividades
│   ├── pas06.sql                    # Triggers de auditoría
│   ├── pas07.sql                    # Evento de copia de seguridad semanal
│   └── pas08.sql                    # Gestión de usuarios y permisos
│
└── backup/
    └── (Aquí se generarán automáticamente las copias de seguridad)

```

## 💻 Requisitos del Entorno
- Base de Datos: MySQL
- Editor: VS Code / Sublime Text / otro editor de texto
- Permisos: Usuario con privilegios de administrador para creación de roles y eventos

## 📜 Licencia
MIT LISENCE - Ver [LICENSE](LICENSE) para más detalles.

## 👨🏻‍💻 Autores
💻 **Jordi Fernández Arlegui** <br>
💻 **Lucía Martínez Gutiérrez** <br>
💻 **Joan Navió González** <br>

🏫 La Salle Gràcia  <br>
🏫 0484 - Base de Dades
