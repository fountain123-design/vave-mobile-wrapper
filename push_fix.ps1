# PowerShell script to push Gradle fix
cd "C:\Users\fountain xie\Desktop\vave-mobile-wrapper"

Write-Host "Adding files..." -ForegroundColor Green
git add .

Write-Host "Committing..." -ForegroundColor Green
git commit -m "Fix: Downgrade Gradle to 7.6 for Flutter 3.x compatibility

- Gradle: 8.0 -> 7.6
- AGP: 8.1.0 -> 7.3.1  
- Kotlin: 1.9.0 -> 1.7.10
- compileSdk: 34 -> 33
- Java: 17 -> 1.8
- Simplified build config"

Write-Host "Pushing to GitHub..." -ForegroundColor Green
git push origin main

Write-Host "Done!" -ForegroundColor Green
