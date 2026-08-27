#!/usr/bin/env bash
# ==============================================================================
# SISTEMAS OPERATIVOS II - 2026
# SUITE DE PRUEBAS DE LA DEMOSTRACIÓN (TP 0 Demo)i
# ==============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

PUNTAJE=0
MAX_PUNTAJE=100
FALLOS=0

echo -e "${BLUE}================================================================${NC}"
echo -e "${BOLD}       SISTEMAS OPERATIVOS II - EVALUACIÓN DE DEMOSTRACIÓN       ${NC}"
echo -e "${BLUE}================================================================${NC}"

if [ ! -f "demo_ejercicios.sh" ]; then
    echo -e "${RED}[ERROR CRÍTICO] No se encontró 'demo_ejercicios.sh'.${NC}"
    exit 1
fi

source ./demo_ejercicios.sh
mkdir -p soluciones_demo

# ------------------------------------------------------------------------------
# Test Demo 1 (20 pts)
# ------------------------------------------------------------------------------
test_demo1() {
    echo -e "\n${BOLD}Verificando Demo 1: Estructura de Carpetas y Metadatos...${NC}"
    demo1_estructura > /dev/null 2>&1
    local err=0
    
    if [ ! -d "soluciones_demo/proyecto/src" ] || [ ! -d "soluciones_demo/proyecto/data" ] || [ ! -d "soluciones_demo/proyecto/docs" ]; then
        echo -e "  ${RED}✗ Faltan directorios en 'soluciones_demo/proyecto/'${NC}"
        err=1
    fi
    if [ ! -f "soluciones_demo/proyecto/src/main.sh" ]; then
        echo -e "  ${RED}✗ Falta el archivo 'soluciones_demo/proyecto/src/main.sh'${NC}"
        err=1
    fi
    if [ ! -f "soluciones_demo/proyecto/docs/autor.txt" ]; then
        echo -e "  ${RED}✗ Falta 'soluciones_demo/proyecto/docs/autor.txt'${NC}"
        err=1
    else
        local txt
        txt=$(cat soluciones_demo/proyecto/docs/autor.txt | tr -d '\r\n')
        if [[ "$txt" != *"Catedra Sistemas Operativos II"* ]]; then
            echo -e "  ${RED}✗ Contenido incorrecto en 'autor.txt'. Se esperaba 'Catedra Sistemas Operativos II'${NC}"
            err=1
        fi
    fi
    
    if [ $err -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Demo 1 correcta (+20 Pts)${NC}"
        PUNTAJE=$((PUNTAJE + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Demo 1 con errores (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Demo 2 (20 pts)
# ------------------------------------------------------------------------------
test_demo2() {
    echo -e "\n${BOLD}Verificando Demo 2: Redirecciones, Tail y Conteo de Errores 500...${NC}"
    demo2_redirecciones > /dev/null 2>&1
    local err=0
    
    if [ ! -f "soluciones_demo/ultimos_accesos.log" ]; then
        echo -e "  ${RED}✗ Falta 'soluciones_demo/ultimos_accesos.log'${NC}"
        err=1
    else
        local n
        n=$(wc -l < soluciones_demo/ultimos_accesos.log | tr -d ' ')
        if [ "$n" -ne 10 ]; then
            echo -e "  ${RED}✗ 'ultimos_accesos.log' tiene $n líneas en lugar de 10.${NC}"
            err=1
        fi
    fi
    
    if [ ! -f "soluciones_demo/total_errores_500.txt" ]; then
        echo -e "  ${RED}✗ Falta 'soluciones_demo/total_errores_500.txt'${NC}"
        err=1
    else
        local e500
        e500=$(cat soluciones_demo/total_errores_500.txt | tr -d ' \r\n\t')
        if [ "$e500" -ne 3 ]; then
            echo -e "  ${RED}✗ El total de errores 500 es '$e500', se esperaba '3'.${NC}"
            err=1
        fi
    fi
    
    if [ $err -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Demo 2 correcta (+20 Pts)${NC}"
        PUNTAJE=$((PUNTAJE + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Demo 2 con errores (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Demo 3 (20 pts)
# ------------------------------------------------------------------------------
test_demo3() {
    echo -e "\n${BOLD}Verificando Demo 3: Tuberías y Endpoints Únicos...${NC}"
    demo3_tuberias > /dev/null 2>&1
    local err=0
    local esperado="/admin/panel
/api/carrito
/api/checkout
/api/healthcheck
/api/login
/api/notificaciones
/api/ordenes
/api/perfil
/api/productos
/api/productos/105
/archivos/manual.pdf
/contacto.html
/css/estilos.css
/imagenes/logo.png
/index.html
/js/app.js
/nosotros.html"
    
    if [ ! -f "soluciones_demo/endpoints_unicos.txt" ]; then
        echo -e "  ${RED}✗ Falta 'soluciones_demo/endpoints_unicos.txt'${NC}"
        err=1
    else
        local obt
        obt=$(cat soluciones_demo/endpoints_unicos.txt | sed '/^[[:space:]]*$/d' | tr -d '\r')
        if [ "$obt" != "$esperado" ]; then
            echo -e "  ${RED}✗ La lista de endpoints no coincide.${NC}"
            err=1
        fi
    fi
    
    if [ $err -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Demo 3 correcta (+20 Pts)${NC}"
        PUNTAJE=$((PUNTAJE + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Demo 3 con errores (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Demo 4 (20 pts)
# ------------------------------------------------------------------------------
test_demo4() {
    echo -e "\n${BOLD}Verificando Demo 4: Filtrado de Inventario de Servidores...${NC}"
    demo4_inventario_csv > /dev/null 2>&1
    local err=0
    local esperado="analytics-worker-01,10.0.7.10
api-backend-01,10.0.2.10
auth-gateway-01,10.0.6.10
cache-redis-01,10.0.4.10
db-master-01,10.0.3.10
db-replica-01,10.0.3.11
web-frontend-01,10.0.1.10
web-frontend-02,10.0.1.11"
    
    if [ ! -f "soluciones_demo/nodos_online.txt" ]; then
        echo -e "  ${RED}✗ Falta 'soluciones_demo/nodos_online.txt'${NC}"
        err=1
    else
        local obt
        obt=$(cat soluciones_demo/nodos_online.txt | sed '/^[[:space:]]*$/d' | tr -d '\r')
        if [ "$obt" != "$esperado" ]; then
            echo -e "  ${RED}✗ La lista de nodos online no coincide.${NC}"
            err=1
        fi
    fi
    
    if [ $err -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Demo 4 correcta (+20 Pts)${NC}"
        PUNTAJE=$((PUNTAJE + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Demo 4 con errores (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

# ------------------------------------------------------------------------------
# Test Demo 5 (20 pts)
# ------------------------------------------------------------------------------
test_demo5() {
    echo -e "\n${BOLD}Verificando Demo 5: Script de Salud y Permisos de Ejecución...${NC}"
    demo5_script_monitoreo > /dev/null 2>&1
    local err=0
    local script="soluciones_demo/check_health.sh"
    
    if [ ! -f "$script" ]; then
        echo -e "  ${RED}✗ Falta el script '$script'${NC}"
        err=1
    else
        if [ ! -x "$script" ]; then
            echo -e "  ${RED}✗ El archivo '$script' no tiene permisos de ejecución (chmod +x).${NC}"
            err=1
        fi
        local out
        out=$(bash "$script" 2>/dev/null)
        if [[ "$out" != *"=== ESTADO DE SALUD DEL NODO ==="* ]]; then
            echo -e "  ${RED}✗ Cabecera incorrecta en '$script'${NC}"
            err=1
        fi
        if [[ "$out" != *"Host:"* ]]; then
            echo -e "  ${RED}✗ No se encontró el campo 'Host:' en '$script'${NC}"
            err=1
        fi
    fi
    
    if [ $err -eq 0 ]; then
        echo -e "  ${GREEN}✓ [PASS] Demo 5 correcta (+20 Pts)${NC}"
        PUNTAJE=$((PUNTAJE + 20))
    else
        echo -e "  ${RED}✗ [FAIL] Demo 5 con errores (+0 Pts)${NC}"
        FALLOS=$((FALLOS + 1))
    fi
}

test_demo1
test_demo2
test_demo3
test_demo4
test_demo5

echo -e "\n${BLUE}================================================================${NC}"
if [ $PUNTAJE -eq 100 ]; then
    echo -e "${GREEN}${BOLD}  RESULTADO DEMO: EXCELENTE! PUNTAJE FINAL: ${PUNTAJE} / ${MAX_PUNTAJE} PTS  ${NC}"
    echo -e "${GREEN}  Todos los tests de la demostración pasaron exitosamente.  ${NC}"
    echo -e "${BLUE}================================================================${NC}"
    exit 0
else
    echo -e "${YELLOW}${BOLD}  RESULTADO DEMO: PUNTAJE: ${PUNTAJE} / ${MAX_PUNTAJE} PTS (${FALLOS} fallos)  ${NC}"
    echo -e "${BLUE}================================================================${NC}"
    exit 1
fi
