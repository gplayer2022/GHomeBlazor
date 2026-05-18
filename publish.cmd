@ECHO OFF

dotnet publish -c Release

REM publish結果へ移動
cd GHomeBlazor/bin/Release/net8.0/publish/wwwroot

REM gh-pagesブランチへデプロイ
git init
git remote add github_gplayer2022 git@github_gplayer2022:gplayer2022/GHomeBlazor.git
git checkout -b gh-pages
git add .
git commit -m "deploy by cmd"
git push -f github_gplayer2022 gh-pages