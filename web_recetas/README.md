 # Recetario — Proyecto final adaptado a la asignatura

Resumen
-------
Esta aplicación es una Single Page Application (SPA) implementada en JavaScript nativo que sirve como punto de encuentro para entusiastas de la cocina (recetas). Integra datos locales con resultados externos de la API TheMealDB, permite publicar recetas de usuario a un mock server (json-server) y aplica medidas de seguridad y optimización.

Características principales
- SPA en Vanilla JS (ES6 modules)
- Catálogo con recetas locales y búsqueda integrada
- Integración con API externa: TheMealDB (búsqueda por término)
 - Integración con API externa: TheMealDB (búsqueda por término). La app consulta TheMealDB para sugerir recetas externas cuando el usuario activa la opción "Incluir recetas externas". Las búsquedas externas se cachean en localStorage durante 24 horas y las llamadas usan un timeout para evitar bloqueos.
 - Importación: desde la vista de detalle de una receta externa puedes "Importar receta (local)". La importación crea una copia local (almacenada en `localStorage` y añadida al catálogo) y opcionalmente intenta publicar la receta al mock server (`POST /user_recipes`) si está activo.
 - Imágenes externas: por defecto las imágenes remotas están deshabilitadas en la UI para evitar dependencias externas; se puede activar la opción "Mostrar imágenes externas" en el header para ver miniaturas proporcionadas por TheMealDB.
- Formulario para crear recetas de usuario y POST a `json-server` (mock API)
- Medidas de seguridad: sanitización básica (eliminación de etiquetas HTML) y validación en cliente
- Optimización: caching de resultados externos en localStorage (24h), imágenes con loading="lazy", CSS responsive y dark theme

Estructura de archivos
- `recetario_chrome.html` — SPA autocontenida (entrada principal)
- `recetario.css` — estilos profesionales y responsive
- `db.json` — datos para json-server (user_recipes)
- `package.json` — scripts para ejecutar live-server y json-server

Requisitos (local)
---------------
Necesitas Node.js y npm para ejecutar el servidor mock (`json-server`) y `live-server`.

Instalación y ejecución
-----------------------
1. Abre una terminal en la carpeta `web_recetas`.
2. Instala dependencias (recomendado):

```powershell
npm install
```

3. En una terminal ejecuta el servidor de desarrollo (sirve archivos estáticos en el puerto 5500):

```powershell
npm start
# abre: http://127.0.0.1:5500/web_recetas/index.html
```

4. Abre otra terminal y arranca el mock API:

```powershell
npm run server-mock
# json-server queda en http://localhost:3000
```

Uso de la aplicación
---------------------
- `Catálogo`: busca recetas locales. Marca "Incluir recetas externas" para añadir resultados de TheMealDB (por término de búsqueda).
 - `Catálogo`: busca recetas locales. Marca "Incluir recetas externas" para añadir resultados de TheMealDB (por término de búsqueda). Si aparecen recetas externas, la tarjeta mostrará la etiqueta `(externa)` y el botón "Ver" abre su detalle. Desde allí puedes importar la receta al catálogo local.
- `Planner`: añadir recetas al planner semanal (persistente en localStorage).
- `Lista`: generar lista de compra desde el planner.
- `Añadir receta` (ruta `#/nuevo`): envía una receta a `json-server` (POST a `/user_recipes`).

Resolución de problemas con la API externa (TheMealDB)
----------------------------------------------------
Si la búsqueda externa no devuelve resultados o la conexión falla, prueba lo siguiente antes de pedirme cambios adicionales:

1) Sirve la app desde un servidor local (no abrir por file://). En `web_recetas` ejecuta:

```powershell
npm start
```

2) Abre las herramientas del navegador (F12) y revisa la pestaña "Consola" y "Red" (Network) al hacer una búsqueda externa. Busca errores CORS, timeouts, o mensajes de red.

3) En la UI hay un botón "Probar API" en el header que realiza una búsqueda de prueba ("Arrabiata") y muestra si TheMealDB responde. Usa ese botón y revisa el mensaje que aparece.

4) Si obtienes un error tipo "Failed to fetch" o "network error":
	- Prueba abrir https://www.themealdb.com en el navegador. Si tampoco carga, el problema es de red o firewall.
	- Si estás en una red corporativa o educativa, prueba con otra red o VPN.

5) Si el error es CORS (bloqueo por política de origen), copia el mensaje exacto de la consola y pégamelo; puedo añadir un pequeño proxy opcional en Node que haga las llamadas al API desde el servidor (evitando CORS).

6) Alternativa manual: si la API no está disponible para ti en este momento, puedes importar recetas manualmente pegando JSON en la ruta de añadir receta (`#/nuevo`) o crear recetas locales con la UI; las recetas externas encontradas pueden importarse manualmente mediante el botón "Importar receta (local)" cuando la API responda.

Si quieres, implemento ahora alguna de las siguientes soluciones:
- un proxy simple integrado en Node (opcional) para evitar problemas CORS/filtrado de red; o
- un parser mejor de medidas al importar recetas; o
- ampliar los mensajes de error y registros en la UI para que puedas copiar el error y enviármelo.

Búsquedas más potentes en TheMealDB
----------------------------------
La app ahora soporta varias modalidades de búsqueda en TheMealDB desde el Catálogo (cuando activas "Incluir recetas externas"):

- Buscar por Nombre (por defecto): usa el endpoint de búsqueda por nombre y devuelve coincidencias parciales.
- Buscar por Ingrediente: busca recetas que incluyan el ingrediente indicado (usa `filter.php?i=`). Los resultados iniciales son mínimos; al hacer "Ver" la app carga el detalle completo vía `lookup`.
- Buscar por Categoría: busca por categoría (`filter.php?c=`) y permite explorar platos por categoría.
- Buscar por Nacionalidad/Área: busca por área (`filter.php?a=`) para encontrar recetas de una región concreta.
- Buscar por Inicial: busca por letra inicial (pulsa "Inicial" y escribe una letra o palabra; la app usará la primera letra).

Usa el selector "Buscar externo por:" en el Catálogo para cambiar la modalidad y escribe tu término de búsqueda en la caja de búsqueda. Si haces clic en una tarjeta externa que proviene de un endpoint `filter`, la app cargará automáticamente el detalle completo para que puedas ver ingredientes y opciones de importación.

Maridaje recomendado
--------------------
Perfecto 😎 — aquí tienes un **maridaje ideal para cada una de tus recetas**, pensado para que lo puedas usar directamente dentro de tu página de recetas (como un campo “maridaje recomendado”).

Incluyo tanto **bebidas alcohólicas** como **alternativas sin alcohol** (para que tu web pueda ofrecer ambas opciones). Todos los maridajes están pensados para resaltar el perfil de sabor principal (acidez, dulzor, especias, textura, temperatura, etc.) de cada plato.

---

### 🥖 Tostadas mediterráneas

**Vino:** Verdejo joven o Albariño (blanco, fresco, afrutado).
**Sin alcohol:** Agua con gas con rodajas de limón y romero.

---

### 🍛 Curry de garbanzos

**Vino:** Riesling seco o Gewürztraminer (blanco aromático que equilibra las especias).
**Sin alcohol:** Té frío de jengibre y limón.

---

### 🍫 Brownie clásico

**Vino:** Oporto Ruby o vino dulce tipo Pedro Ximénez.
**Sin alcohol:** Café espresso o chocolate caliente amargo.

---

### 🥣 Avena overnight con frutas

**Vino:** Moscato d’Asti (ligeramente espumoso, dulce y fresco).
**Sin alcohol:** Smoothie de mango o zumo de naranja natural.

---

### 🥗 Ensalada de quinoa y aguacate

**Vino:** Sauvignon Blanc o Verdejo (refrescante, con notas herbáceas).
**Sin alcohol:** Kombucha de jengibre o limonada con hierbabuena.

---

### 🥣 Sopa de lentejas

**Vino:** Tempranillo joven o Garnacha suave.
**Sin alcohol:** Té negro con especias o agua con un toque de lima.

---

### 🍝 Pasta al pesto

**Vino:** Pinot Grigio o un blanco italiano seco.
**Sin alcohol:** Limonada casera con albahaca fresca.

---

### 🌮 Tacos de pescado

**Vino:** Chardonnay sin madera o cerveza tipo lager ligera.
**Sin alcohol:** Agua con gas con lima o kombucha cítrica.

---

### 🍗 Pollo al horno con hierbas

**Vino:** Chardonnay con leve barrica o un rosado seco.
**Sin alcohol:** Té verde con miel y limón.

---

### 🎃 Crema de calabaza

**Vino:** Viognier o Chardonnay suave, con notas de miel.
**Sin alcohol:** Zumo de manzana caliente con canela.

---

### 🥬 Ensalada César

**Vino:** Sauvignon Blanc o un rosado seco.
**Sin alcohol:** Agua con pepino y menta o kombucha de limón.

---

### 🥞 Pancakes esponjosos

**Vino:** Cava dulce o vino espumoso semiseco.
**Sin alcohol:** Café latte o batido de vainilla.

---

### 🍣 Sushi variado

**Vino:** Sake frío o vino blanco tipo Albariño.
**Sin alcohol:** Té verde japonés (sencha o matcha suave).

---

### 🌶️ Mapo Tofu

**Vino:** Gewürztraminer o Riesling off-dry (su dulzor atenúa el picante).
**Sin alcohol:** Té helado de jazmín o agua con pepino.

---

### 🍷 Coq au Vin

**Vino:** Pinot Noir o Merlot suave (acompaña el guiso sin dominar).
**Sin alcohol:** Mosto tinto o té negro con ciruela.

---

### 🥘 Paella mixta

**Vino:** Verdejo o rosado valenciano, frescos y secos.
**Sin alcohol:** Agua con gas con piel de naranja o kombucha floral.

---

### 🇬🇷 Moussaka

**Vino:** Syrah o Garnacha madura (complementa la berenjena y la bechamel).
**Sin alcohol:** Zumo de granada o té frío de menta.

---

### 🍖 BBQ Ribs

**Vino:** Zinfandel o Malbec (intensos y con notas ahumadas).
**Sin alcohol:** Cola artesanal o té helado de durazno.

---

### 🥟 Empanadas salteñas

**Vino:** Malbec joven o Torrontés (si las empanadas son más suaves).
**Sin alcohol:** Mate frío o limonada con jengibre.

---

### 🍲 Feijoada

**Vino:** Cabernet Sauvignon o Syrah con cuerpo.
**Sin alcohol:** Zumo de frutas tropicales o agua con lima y menta.

---

### 🍖 Tajine de cordero

**Vino:** Garnacha o vino tinto especiado del Ródano.
**Sin alcohol:** Té moruno (verde con hierbabuena y azúcar).

---

### 🥥 Thai Green Curry

**Vino:** Riesling o Sauvignon Blanc tropical.
**Sin alcohol:** Agua de coco o limonada con jengibre.

---

### Cómo usar esta sección en la app

- En la vista de cada receta verás un bloque "Maridaje ideal — (alcohólico y sin alcohol)" cuando exista un maridaje detallado para esa receta.
- También hay una sección global "Maridaje general (bebidas)" disponible desde el Catálogo (botón) que lista bebidas y permite ver las recetas que mejor combinan con cada bebida.

Si quieres que exporte esta lista a un archivo `maridajes.json` o que la sincronice con `db.json` (para poder editar desde la UI y persistir en el mock server), lo implemento también.

Seguridad
---------
- Se elimina cualquier etiqueta HTML de los campos de texto proporcionados por el usuario antes de enviarlos o almacenarlos (prevención XSS).
- Se realizan validaciones en cliente: campos obligatorios y formato básico de ingredientes.

Optimización y rendimiento
--------------------------
- Resultados externos cacheados en localStorage por 24 horas para evitar llamadas repetidas.
- Imágenes usan `loading="lazy"`.
- CSS responsive y versiones clara/oscura.

Mock API (json-server)
----------------------
El `db.json` contiene la colección `user_recipes`. Cuando ejecutes `npm run server-mock` se expondrá una API REST completa:

- GET /user_recipes
- POST /user_recipes

Requisitos de entrega / despliegue
---------------------------------
- Sube el contenido de `web_recetas` a un repositorio público (GitHub). Incluye este README en la raíz.
- Para desplegar una versión pública estática puedes usar GitHub Pages o Netlify. Nota: la parte de `json-server` no se desplegará en GitHub Pages — para la evaluación, indica en el README cómo ejecutarlo localmente.

Notas finales
-------------
Si quieres que prepare también un backend sencillo en Express que sirva la API (en vez de json-server), o que te ayude a subir el repositorio a GitHub y a desplegar en Netlify/Vercel, dímelo y lo preparo.

---
Fecha de actualización: 28-10-2025
