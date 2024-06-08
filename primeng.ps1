# Nombre del proyecto (puedes pasar el nombre como parámetro o modificar aquí)
param (
    [string]$projectName,
    [string]$projectDir
)

if (-not $projectName) {
    Write-Host "Por favor, proporciona un nombre para el proyecto."
    Write-Host "Uso: -projectName nombre-del-proyecto -projectDir ruta-del-proyecto"
    exit
}

if (-not $projectDir) {
    Write-Host "Por favor, proporciona una ruta para el proyecto."
    Write-Host "Uso: -projectName nombre-del-proyecto -projectDir ruta-del-proyecto"
    exit
}

if (-not (Test-Path -Path $projectDir)) {
    Write-Host "❗ La ruta proporcionada no es válida. Por favor, proporciona una ruta válida."
    exit
}

# Cambiar al directorio del proyecto
Set-Location -Path $projectDir

# Crear un nuevo proyecto de Angular
Write-Host "Creando proyecto de Angular..."
ng new $projectName

# Cambiar al directorio del proyecto recién creado
Set-Location -Path (Join-Path -Path $projectDir -ChildPath $projectName)

# Instalar PrimeNG y sus dependencias
Write-Host "Instalando PrimeNG y dependencias..."
npm install primeng primeicons

# Añadir estilos de PrimeNG en angular.json
# Write-Host "Configurando estilos de PrimeNG en angular.json..."
# $json = Get-Content -Raw -Path ".\angular.json" | ConvertFrom-Json
# $styles = @(
#     "node_modules/primeng/resources/themes/saga-blue/theme.css",
#     "node_modules/primeng/resources/primeng.min.css",
#     "node_modules/primeicons/primeicons.css"
# ) + $json.projects.$projectName.architect.build.options.styles
# $json.projects.$projectName.architect.build.options.styles = $styles
# $json | ConvertTo-Json -Depth 100 | Set-Content -Path ".\angular.json"

# Instalar TailwindCSS y sus dependencias
Write-Host "Instalando TailwindCSS y dependencias..."
npm install -D tailwindcss postcss autoprefixer

# Crear archivo de configuración de TailwindCSS
Write-Host "Creando archivo de configuración de TailwindCSS..."
npx tailwindcss init

# Configurar tailwind.config.js
Write-Host "Configurando tailwind.config.js..."
@"
module.exports = {
  content: [
    "./src/**/*.{html,ts}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
"@ | Set-Content -Path ".\tailwind.config.js"

# Añadir directivas de TailwindCSS en styles.css
Write-Host "Añadiendo directivas de TailwindCSS en src/styles.css..."
@"
@layer tailwind-base, primeng, tailwind-utilities;

@import "primeng/resources/primeng.css";
@import "primeng/resources/themes/lara-light-blue/theme.css"; /* <---- change this to your theme */
@import "primeicons/primeicons.css";

@layer tailwind-base {
    @tailwind base;
}

@layer tailwind-utilities {
    @tailwind components;
    @tailwind utilities;
}
"@ | Set-Content -Path ".\src\styles.css"

# Configurar app.config.ts
Write-Host "Configurando app.config.ts..."
@"
import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideAnimations } from '@angular/platform-browser/animations';

import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [provideRouter(routes), provideAnimations()],
};
"@ | Set-Content -Path ".\src\app\app.config.ts"

# Configurar pp.component.ts
Write-Host "Configurando app.component.ts..."
@"
import { Component, OnInit } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { PrimeNGConfig } from 'primeng/api';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet],
  templateUrl: './app.component.html',
  styleUrl: './app.component.css'
})
export class AppComponent implements OnInit {
  title = '';

  constructor(private primengConfig: PrimeNGConfig) {}

  ngOnInit() {
      this.primengConfig.ripple = true;
  }
}
"@ | Set-Content -Path ".\src\app\app.component.ts"

# Instalar dependencias
Write-Host "Instalando dependencias..."
npm install

# Finalizar
Write-Host "Configuracion completa. Puedes iniciar el servidor con 'ng serve'."