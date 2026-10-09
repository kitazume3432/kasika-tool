@echo off
chcp 65001 >nul
setlocal
cd /d "%~dp0"

echo ============================================
echo  工程管理ツール 更新スクリプト
echo ============================================
echo.

git config --global --add safe.directory "*" >nul 2>&1

echo [1/3] 変更をステージしています...
git add -A

echo [2/3] コミットしています...
git commit -m "ツール更新 %date% %time%"
if errorlevel 1 (
    echo コミットする変更がありませんでした。
    echo %date% %time% 変更なし >> update_log.txt
    goto :end
)

echo [3/3] GitHubへpushしています...
git push origin main
if errorlevel 1 (
    echo エラーが発生しました。内容を確認してください。
    echo %date% %time% 更新失敗 >> update_log.txt
    goto :end
)

echo.
echo 更新が完了しました！
echo https://kitazume3432.github.io/kotei-kanri-tool/
echo %date% %time% 更新成功 >> update_log.txt

:end
echo.
pause
