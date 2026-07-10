@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ==========================================
echo   MI PROYECTO PERSONAL - WINDOWS
echo ==========================================
echo.
where node >nul 2>nul
if errorlevel 1 (
  echo No se encontro Node.js.
  echo Instala Node.js LTS y vuelve a abrir este archivo.
  pause
  exit /b 1
)
echo Instalando componentes necesarios...
call npm install
if errorlevel 1 goto error
echo.
echo Creando instalador y version portable...
call npm run build:win
if errorlevel 1 goto error
echo.
echo LISTO. Abre la carpeta dist.
start "" "%~dp0dist"
pause
exit /b 0
:error
echo.
echo No se pudo completar. Revisa tu conexion a Internet y vuelve a intentar.
pause
exit /b 1
