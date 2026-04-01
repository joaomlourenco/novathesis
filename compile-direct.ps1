# NOVAthesis Direct Compilation Script (No latexmk/Perl required)
# Usage: .\compile-direct.ps1 [engine] [-Clean]
# Engines: lua (default), pdf, xe
# -Clean: remove all auxiliary files after compilation (keeps only .pdf)

param(
    [string]$Engine = "lua",
    [switch]$Clean
)

Write-Host "NOVAthesis Direct Compilation Script" -ForegroundColor Cyan
Write-Host "=====================================" -ForegroundColor Cyan
Write-Host ""

# Check if template.tex exists
if (-not (Test-Path "template.tex")) {
    Write-Host "ERROR: template.tex not found in current directory!" -ForegroundColor Red
    exit 1
}

# Determine which LaTeX compiler to use
$latexCmdName = $null
switch ($Engine.ToLower()) {
    "lua" {
        $latexCmdName = "lualatex"
        Write-Host "Using: LuaLaTeX" -ForegroundColor Green
    }
    "pdf" {
        $latexCmdName = "pdflatex"
        Write-Host "Using: pdfLaTeX" -ForegroundColor Green
    }
    "xe" {
        $latexCmdName = "xelatex"
        Write-Host "Using: XeLaTeX" -ForegroundColor Green
    }
    default {
        Write-Host "ERROR: Unknown engine '$Engine'. Use: lua, pdf, or xe" -ForegroundColor Red
        exit 1
    }
}

# Check if the LaTeX compiler is available
$compiler = Get-Command $latexCmdName -ErrorAction SilentlyContinue
$miktexPath = "$env:LOCALAPPDATA\Programs\MiKTeX\miktex\bin\x64"

# If not in PATH, try MiKTeX installation directory
if (-not $compiler) {
    if (Test-Path "$miktexPath\$latexCmdName.exe") {
        $latexCmd = "$miktexPath\$latexCmdName.exe"
        Write-Host "Found $latexCmdName in MiKTeX directory" -ForegroundColor Green
    } else {
        Write-Host "ERROR: $latexCmdName not found. Please check your MiKTeX installation." -ForegroundColor Red
        Write-Host "Tried: $miktexPath\$latexCmdName.exe" -ForegroundColor Yellow
        exit 1
    }
} else {
    $latexCmd = $compiler.Source
}

# Check if biber is available
$biber = Get-Command biber -ErrorAction SilentlyContinue
if (-not $biber) {
    # Try MiKTeX directory
    if (Test-Path "$miktexPath\biber.exe") {
        $biber = "$miktexPath\biber.exe"
    } else {
        Write-Host "WARNING: biber not found. Bibliography may not be processed correctly." -ForegroundColor Yellow
    }
}

Write-Host "Main file: template.tex" -ForegroundColor Green
Write-Host ""

# Compilation flags
$flags = "-shell-escape", "-synctex=1", "-interaction=nonstopmode"

# Step 1: First LaTeX pass
Write-Host "Step 1/4: First LaTeX pass..." -ForegroundColor Yellow
try {
    & $latexCmd $flags template.tex
    if ($LASTEXITCODE -ne 0) {
        Write-Host "ERROR: First LaTeX pass failed!" -ForegroundColor Red
        exit $LASTEXITCODE
    }
} catch {
    Write-Host "ERROR: Failed to run $latexCmd" -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Red
    exit 1
}

# Step 2: Biber (bibliography processing)
if ($biber) {
    Write-Host "Step 2/4: Processing bibliography with biber..." -ForegroundColor Yellow
    try {
        & biber template
        if ($LASTEXITCODE -ne 0) {
            Write-Host "WARNING: Biber had issues, but continuing..." -ForegroundColor Yellow
        }
    } catch {
        Write-Host "WARNING: Biber failed, but continuing..." -ForegroundColor Yellow
    }
} else {
    Write-Host "Step 2/4: Skipping bibliography (biber not found)..." -ForegroundColor Yellow
}

# Step 3: Second LaTeX pass (resolve references)
Write-Host "Step 3/4: Second LaTeX pass (resolving references)..." -ForegroundColor Yellow
try {
    & $latexCmd $flags template.tex | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "WARNING: Second pass had issues, but continuing..." -ForegroundColor Yellow
    }
} catch {
    Write-Host "WARNING: Second pass failed, but continuing..." -ForegroundColor Yellow
}

# Step 4: Third LaTeX pass (finalize)
Write-Host "Step 4/4: Final LaTeX pass..." -ForegroundColor Yellow
try {
    & $latexCmd $flags template.tex | Out-Null
    if ($LASTEXITCODE -ne 0) {
        Write-Host "WARNING: Final pass had issues." -ForegroundColor Yellow
    }
} catch {
    Write-Host "WARNING: Final pass failed." -ForegroundColor Yellow
}

# Check if PDF was created
Write-Host ""
if (Test-Path "template.pdf") {
    $pdfSize = (Get-Item "template.pdf").Length / 1MB
    Write-Host "SUCCESS: PDF generated successfully!" -ForegroundColor Green
    Write-Host "Output: template.pdf ($([math]::Round($pdfSize, 2)) MB)" -ForegroundColor Green

    # Clean up auxiliary files if -Clean flag is set
    if ($Clean) {
        Write-Host ""
        Write-Host "Cleaning auxiliary files..." -ForegroundColor Cyan
        $auxExtensions = @(
            "*.aux", "*.bbl", "*.bcf", "*.blg", "*.fdb_latexmk", "*.fls",
            "*.glg", "*.glo", "*.gls", "*.acn", "*.acr", "*.alg",
            "*.ist", "*.lof", "*.log", "*.lot", "*.out", "*.run.xml",
            "*.slg", "*.slo", "*.sls", "*.toc", "*.xdy",
            "*.synctex", "*.synctex.gz", "*.synctex(busy)"
        )
        foreach ($pattern in $auxExtensions) {
            Get-ChildItem -Path . -Filter $pattern -File | Remove-Item -Force
        }
        Write-Host "Done - only template.pdf remains." -ForegroundColor Green
    }

    exit 0
} else {
    Write-Host "ERROR: template.pdf was not created!" -ForegroundColor Red
    Write-Host "Check template.log for error details." -ForegroundColor Yellow
    exit 1
}
