<div align="center">

<img src="https://capsule-render.vercel.app/api?type=venom&color=0:0f172a,50:1e3a5f,100:0f172a&height=220&section=header&text=SISCO&fontSize=80&fontColor=38bdf8&fontAlignY=42&fontAlign=50&desc=Sistema%20de%20Gestión%20de%20Aparcamiento%20Vehicular&descAlignY=63&descSize=17&descAlign=50&animation=fadeIn" width="100%"/>

<br/>

![Estado](https://img.shields.io/badge/Estado-En%20Producción-22c55e?style=for-the-badge&logo=checkmarx&logoColor=white)
![Versión](https://img.shields.io/badge/Versión-1.0.0-38bdf8?style=for-the-badge&logo=semantic-release&logoColor=white)
![Empresa](https://img.shields.io/badge/Fredal%20S.A.C.-Línea%20de%20Cochera-f59e0b?style=for-the-badge&logo=building&logoColor=white)
![Plataformas](https://img.shields.io/badge/Web%20+%20Mobile-Multiplataforma-8b5cf6?style=for-the-badge&logo=responsive-design&logoColor=white)

</div>

---

## 📋 Tabla de Contenidos

- [¿Qué es SISCO?](#-qué-es-sisco)
- [Problema que resuelve](#-problema-que-resuelve)
- [Funcionalidades](#-funcionalidades)
- [Arquitectura del Sistema](#️-arquitectura-del-sistema)
- [Stack Tecnológico](#-stack-tecnológico)
- [Estructura del Repositorio](#-estructura-del-repositorio)
- [Instalación](#️-instalación)
- [Autor](#-autor)

---

## 🚗 ¿Qué es SISCO?

**SISCO** es el sistema de gestión operacional de la **línea de aparcamiento vehicular de Peruvian Group Fredal S.A.C.** Centraliza en una sola plataforma el control de tickets de estacionamiento, el registro de ingresos y salidas de vehículos, y la gestión financiera de la cochera (ingresos, gastos, deudas y facturación).

El sistema opera en dos frentes complementarios:

| 🖥️ Plataforma Web | 📱 App para Colaboradores |
|:---|:---|
| Panel administrativo completo para gestión financiera, reportes y configuración | Aplicativo móvil para operadores en campo: registran ingresos, salidas y tickets en tiempo real |

---

## 🎯 Problema que resuelve

La línea de cochera de Fredal operaba con procesos manuales propensos a errores, sin trazabilidad financiera ni visibilidad operativa. SISCO digitaliza y automatiza ese flujo de principio a fin.

| ❌ Antes | ✅ Con SISCO |
|:---|:---|
| Tickets en papel, susceptibles a pérdidas y errores | Tickets digitales con registro automático de hora de entrada/salida |
| Control de caja manual y sin cierre formal | Registro de ingresos y gastos con historial trazable |
| Deudas de clientes sin seguimiento | Módulo de deudas con estado de pago actualizable |
| Facturación manual y descoordinada | Generación y control de comprobantes desde el sistema |
| Colaboradores sin herramienta de apoyo en campo | App móvil con flujo guiado de registro operativo |

---

## ⚡ Funcionalidades

### 🎫 Control de Tickets de Aparcamiento
- Generación de ticket digital al ingreso del vehículo con timestamp automático
- Registro de salida con cálculo de tiempo de permanencia
- Historial de tickets por fecha, vehículo o colaborador
- Estados de ticket: activo / cerrado / anulado

### 💰 Gestión de Ingresos y Gastos
- Registro de cobros por ticket con tarifas configurables
- Control de gastos operativos de la cochera
- Cierre de caja diario con resumen de movimientos
- Histórico financiero por período

### 📄 Facturación y Deudas
- Generación de comprobantes de pago para clientes frecuentes o empresas
- Módulo de deudas: registro, seguimiento y actualización de estado de pago
- Reporte de cuentas por cobrar vigentes

### 📊 Reportes Operativos
- Ocupación diaria y mensual de la cochera
- Ingresos consolidados por período
- Tickets anulados y excepciones operativas
- KPIs de rotación vehicular

### 📱 App Móvil para Colaboradores
- Registro de ingreso de vehículos en campo
- Registro de salida y cobro en tiempo real
- Consulta de tickets activos
- Interfaz simplificada orientada al operador de cochera

---

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                        SISCO PLATFORM                           │
│                                                                 │
│   ┌─────────────────┐    ┌────────────────────────────────┐    │
│   │   📱 MOBILE APP │    │       🖥️  WEB FRONTEND          │    │
│   │  (Colaboradores)│    │    Next.js · JavaScript        │    │
│   │  Registro campo │    │  Panel admin · Reportes        │    │
│   └────────┬────────┘    └───────────────┬────────────────┘    │
│            │                             │                      │
│            └──────────────┬──────────────┘                      │
│                           ▼                                     │
│              ┌────────────────────────┐                         │
│              │     ⚙️  BACKEND API     │                         │
│              │   Django REST · Python │                         │
│              └───────────┬────────────┘                         │
│                          ▼                                      │
│              ┌────────────────────────┐                         │
│              │    🗄️  BASE DE DATOS    │                         │
│              │  SQL Server · T-SQL    │                         │
│              └────────────────────────┘                         │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Stack Tecnológico

<div align="center">

**Backend**

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Django](https://img.shields.io/badge/Django-092E20?style=for-the-badge&logo=django&logoColor=white)
![Django REST](https://img.shields.io/badge/Django%20REST-ff1709?style=for-the-badge&logo=django&logoColor=white)

**Frontend Web**

![Next.js](https://img.shields.io/badge/Next.js-000000?style=for-the-badge&logo=next.js&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=for-the-badge&logo=css3&logoColor=white)

**App Móvil**

![Mobile](https://img.shields.io/badge/App%20Móvil-Colaboradores-38bdf8?style=for-the-badge&logo=android&logoColor=white)

**Base de Datos**

![SQL Server](https://img.shields.io/badge/SQL%20Server-CC2927?style=for-the-badge&logo=microsoft-sql-server&logoColor=white)
![T-SQL](https://img.shields.io/badge/T--SQL-4479A1?style=for-the-badge&logo=microsoft&logoColor=white)

**DevOps & Herramientas**

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)

</div>

---

## 📁 Estructura del Repositorio

```
sisco/
│
├── 📂 backend/                  # API REST – Django (Python)
│   ├── apps/
│   │   ├── tickets/             # Lógica de tickets de aparcamiento
│   │   ├── finanzas/            # Ingresos, gastos, cierre de caja
│   │   ├── facturacion/         # Comprobantes y gestión de deudas
│   │   └── usuarios/            # Colaboradores y control de acceso
│   ├── config/                  # Settings, URLs y configuración Django
│   └── requirements.txt
│
├── 📂 frontend/                 # Panel web administrativo – Next.js
│   ├── components/              # Componentes UI reutilizables
│   ├── pages/                   # Vistas: dashboard, tickets, reportes
│   └── public/                  # Assets estáticos
│
├── 📂 mobile/                   # App móvil para colaboradores de campo
│
├── 📄 models.py                 # Modelos de datos de referencia
├── 📄 script.sql                # Script de inicialización de base de datos
├── 📄 iniciar_sisco.ps1         # Script PowerShell de arranque rápido
└── 📄 README.md
```

---

## ⚙️ Instalación

### Prerrequisitos

- Python `>= 3.10`
- Node.js `>= 18.x`
- SQL Server o SQL Server Express
- PowerShell `>= 5.1` *(Windows)*

### 1 · Clonar el repositorio

```bash
git clone https://github.com/Williams0406/sisco.git
cd sisco
```

### 2 · Inicializar la base de datos

```bash
# Ejecutar en SQL Server Management Studio o sqlcmd
sqlcmd -S localhost -i script.sql
```

### 3 · Levantar el Backend

```bash
cd backend
python -m venv env
source env/bin/activate          # Linux/macOS
# .\env\Scripts\activate         # Windows

pip install -r requirements.txt
cp .env.example .env             # Configurar credenciales de BD y SECRET_KEY

python manage.py migrate
python manage.py runserver
```

### 4 · Levantar el Frontend

```bash
cd ../frontend
npm install
npm run dev
```

### ⚡ Arranque rápido en Windows

```powershell
# Levanta backend y frontend en un solo paso
.\iniciar_sisco.ps1
```

### URLs del sistema

| Servicio | URL |
|:---|:---|
| 🌐 Panel web | `http://localhost:3000` |
| ⚙️ API REST | `http://localhost:8000/api/` |
| 🔐 Admin Django | `http://localhost:8000/admin/` |

---

## 👤 Autor

<div align="center">

**Williams Uriel Junior Rodriguez Caceres**
*Ingeniero Industrial · Analista de Procesos & Automatización*

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Conectar-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/williams-rodriguez-438ba8238)
[![Email](https://img.shields.io/badge/Email-Escribir-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:Williams.rc04@gmail.com)
[![GitHub](https://img.shields.io/badge/GitHub-Williams0406-181717?style=for-the-badge&logo=github&logoColor=white)](https://github.com/Williams0406)

</div>

---

<div align="center">

<img src="https://capsule-render.vercel.app/api?type=waving&color=0:0f172a,50:1e3a5f,100:0f172a&height=100&section=footer" width="100%"/>

*SISCO · Peruvian Group Fredal S.A.C. · Línea de Aparcamiento Vehicular · 2025–2026*

</div>
