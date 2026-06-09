# 播放功能测试脚本
# 使用方法：在PowerShell中运行此脚本

Write-Host "=== 播放功能测试脚本 ===" -ForegroundColor Green
Write-Host ""

# 步骤1：编译项目
Write-Host "[1/5] 编译项目..." -ForegroundColor Yellow
hvigorw assembleHap
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 编译失败" -ForegroundColor Red
    exit 1
}
Write-Host "✅ 编译成功" -ForegroundColor Green

# 步骤2：安装应用
Write-Host "`n[2/5] 安装应用到设备..." -ForegroundColor Yellow
hdc install entry\build\default\outputs\default\entry-default-signed.hap
if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ 安装失败" -ForegroundColor Red
    exit 1
}
Write-Host "✅ 安装成功" -ForegroundColor Green

# 步骤3：清空日志
Write-Host "`n[3/5] 清空设备日志..." -ForegroundColor Yellow
hdc hilog -r
Write-Host "✅ 日志已清空" -ForegroundColor Green

# 步骤4：启动应用
Write-Host "`n[4/5] 启动应用..." -ForegroundColor Yellow
hdc shell aa start -a EntryAbility -b com.example.wyy_music
Write-Host "✅ 应用已启动" -ForegroundColor Green

# 步骤5：显示初始化日志
Write-Host "`n[5/5] 查看初始化日志（等待3秒）..." -ForegroundColor Yellow
Start-Sleep -Seconds 3

Write-Host "`n=== 初始化日志 ===" -ForegroundColor Cyan
hdc hilog | Select-String -Pattern "IndexPage|PlayerService|AVPlayer|setupPlayerListeners" | Select-Object -First 20

Write-Host "`n=== 操作说明 ===" -ForegroundColor Yellow
Write-Host "1. 在设备上打开应用" -ForegroundColor White
Write-Host "2. 进入'我的'标签页" -ForegroundColor White
Write-Host "3. 点击'播放测试歌曲'按钮" -ForegroundColor White
Write-Host "4. 查看底部是否出现迷你播放栏" -ForegroundColor White
Write-Host "5. 点击迷你播放栏进入完整播放器页面" -ForegroundColor White

Write-Host "`n=== 查看播放日志 ===" -ForegroundColor Cyan
Write-Host "点击播放按钮后，在另一个PowerShell窗口中运行以下命令查看日志：" -ForegroundColor White
Write-Host "hdc hilog | Select-String -Pattern 'Button|playSong|Starting|Resetting|Setting|Preparing|Playing|state changed|ERROR|Failed'" -ForegroundColor Gray

Write-Host "`n=== 实时监控日志 ===" -ForegroundColor Cyan
Write-Host "要实时监控日志，运行以下命令：" -ForegroundColor White
Write-Host "hdc hilog -x | Select-String -Pattern 'Player|AVPlayer|state'" -ForegroundColor Gray

Write-Host "`n=== 预期结果 ===" -ForegroundColor Green
Write-Host "✅ 初始化成功日志" -ForegroundColor Green
Write-Host "✅ 播放按钮点击日志" -ForegroundColor Green
Write-Host "✅ AVPlayer状态变化日志" -ForegroundColor Green
Write-Host "✅ 底部出现迷你播放栏" -ForegroundColor Green
Write-Host "✅ 可以听到音频播放" -ForegroundColor Green

Write-Host "`n=== 常见问题 ===" -ForegroundColor Yellow
Write-Host "1. 如果没有日志输出：检查设备连接，运行 'hdc list targets'" -ForegroundColor White
Write-Host "2. 如果AVPlayer创建失败：检查设备HarmonyOS版本（需要API 9+）" -ForegroundColor White
Write-Host "3. 如果网络错误：检查设备网络连接和INTERNET权限" -ForegroundColor White
Write-Host "4. 如果音频无法播放：尝试其他测试音频URL" -ForegroundColor White

Write-Host "`n=== 测试音频URL ===" -ForegroundColor Cyan
Write-Host "1. https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3" -ForegroundColor Gray
Write-Host "2. https://file-examples.com/storage/feaade38c1651bd01984236/2017/11/file_example_MP3_700KB.mp3" -ForegroundColor Gray
Write-Host "3. https://samplelib.com/lib/preview/mp3/sample-3s.mp3" -ForegroundColor Gray

Write-Host "`n=== 调试指南 ===" -ForegroundColor Cyan
Write-Host "详细调试步骤请参考：docs\播放功能调试指南.md" -ForegroundColor White
Write-Host "`n测试完成！" -ForegroundColor Green