# PowerShell脚本 - 规范命名food和service目录下的图片
# 设置文件夹路径
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$rootPath = Split-Path -Parent $scriptPath
$foodSourceFolder = Join-Path -Path $rootPath -ChildPath "images\food"
$serviceSourceFolder = Join-Path -Path $rootPath -ChildPath "images\service"

# 确保目标文件夹存在
if (-not (Test-Path $foodSourceFolder)) {
    New-Item -Path $foodSourceFolder -ItemType Directory -Force
}

if (-not (Test-Path $serviceSourceFolder)) {
    New-Item -Path $serviceSourceFolder -ItemType Directory -Force
}

# 处理food文件夹中的图片
Write-Output "开始处理food文件夹中的图片..."
$foodImageFiles = Get-ChildItem -Path $foodSourceFolder -Filter "*.jpg"
$foodCounter = 1

# 临时存储重命名信息
$foodRenameMap = @{}

# 第一步：记录所有将要重命名的文件
foreach ($file in $foodImageFiles) {
    # 新的文件名格式: food{数字}.jpg
    $newFileName = "food$foodCounter.jpg"
    $tempFilePath = Join-Path -Path $foodSourceFolder -ChildPath "temp_$newFileName"
    
    # 记录原始文件名和新文件名的映射关系
    $foodRenameMap[$file.FullName] = $newFileName
    
    # 递增计数器以便下一个文件
    $foodCounter++
}

# 第二步：执行重命名
foreach ($originalPath in $foodRenameMap.Keys) {
    $file = Get-Item -Path $originalPath
    $newFileName = $foodRenameMap[$originalPath]
    $newFilePath = Join-Path -Path $foodSourceFolder -ChildPath $newFileName
    
    # 使用临时文件名来避免冲突
    $tempPath = Join-Path -Path $foodSourceFolder -ChildPath "temp_$newFileName"
    
    # 复制到临时文件
    Copy-Item -Path $file.FullName -Destination $tempPath -Force
    
    Write-Output "已标记重命名: $($file.Name) -> $newFileName"
}

# 删除原始文件
foreach ($originalPath in $foodRenameMap.Keys) {
    Remove-Item -Path $originalPath -Force
}

# 将临时文件重命名为最终文件名
Get-ChildItem -Path $foodSourceFolder -Filter "temp_*.jpg" | ForEach-Object {
    $finalName = $_.Name -replace "temp_", ""
    $finalPath = Join-Path -Path $foodSourceFolder -ChildPath $finalName
    Move-Item -Path $_.FullName -Destination $finalPath -Force
    Write-Output "完成重命名: $finalName"
}

# 处理service文件夹中的图片
Write-Output "`n开始处理service文件夹中的图片..."
$serviceImageFiles = Get-ChildItem -Path $serviceSourceFolder -Filter "*.jpg"
$serviceCounter = 1

# 临时存储重命名信息
$serviceRenameMap = @{}

# 第一步：记录所有将要重命名的文件
foreach ($file in $serviceImageFiles) {
    # 新的文件名格式: service{数字}.jpg
    $newFileName = "service$serviceCounter.jpg"
    $tempFilePath = Join-Path -Path $serviceSourceFolder -ChildPath "temp_$newFileName"
    
    # 记录原始文件名和新文件名的映射关系
    $serviceRenameMap[$file.FullName] = $newFileName
    
    # 递增计数器以便下一个文件
    $serviceCounter++
}

# 第二步：执行重命名
foreach ($originalPath in $serviceRenameMap.Keys) {
    $file = Get-Item -Path $originalPath
    $newFileName = $serviceRenameMap[$originalPath]
    $newFilePath = Join-Path -Path $serviceSourceFolder -ChildPath $newFileName
    
    # 使用临时文件名来避免冲突
    $tempPath = Join-Path -Path $serviceSourceFolder -ChildPath "temp_$newFileName"
    
    # 复制到临时文件
    Copy-Item -Path $file.FullName -Destination $tempPath -Force
    
    Write-Output "已标记重命名: $($file.Name) -> $newFileName"
}

# 删除原始文件
foreach ($originalPath in $serviceRenameMap.Keys) {
    Remove-Item -Path $originalPath -Force
}

# 将临时文件重命名为最终文件名
Get-ChildItem -Path $serviceSourceFolder -Filter "temp_*.jpg" | ForEach-Object {
    $finalName = $_.Name -replace "temp_", ""
    $finalPath = Join-Path -Path $serviceSourceFolder -ChildPath $finalName
    Move-Item -Path $_.FullName -Destination $finalPath -Force
    Write-Output "完成重命名: $finalName"
}

# 获取重命名后的图片数量
$foodCount = (Get-ChildItem -Path $foodSourceFolder -Filter "*.jpg").Count
$serviceCount = (Get-ChildItem -Path $serviceSourceFolder -Filter "*.jpg").Count

Write-Output "`n完成! 所有图片已规范命名"
Write-Output "food文件夹中有 $foodCount 张图片"
Write-Output "service文件夹中有 $serviceCount 张图片"

# 创建配置文件以供网页使用
$configPath = Join-Path -Path $rootPath -ChildPath "scripts\image_config.js"
@"
// 由重命名脚本自动生成的配置
const IMAGE_CONFIG = {
    foodCount: $foodCount,
    serviceCount: $serviceCount
};
"@ | Out-File -FilePath $configPath -Encoding utf8

Write-Output "已生成图片配置文件: scripts\image_config.js" 