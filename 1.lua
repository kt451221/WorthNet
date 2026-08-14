-- =====================================================================
--      WORTHNET ULTIMATE MASTER SYSTEM v7.0 (FINAL & COMPLETE)
-- =====================================================================

pcall(function()
    if syn and syn.secure_call then syn.secure_call(function() end) end
    getgenv().WorthNetSecure = true
    if not firetouchinterest and firetouchpos then
        getgenv().firetouchinterest = function(p1, p2, val)
            if val == 0 then firetouchpos(p1.Position) else firetouchpos(p2.Position) end
        end
    end
end)

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")

local player = Players.LocalPlayer
local pGui = player:WaitForChild("PlayerGui")
local parentGui = pGui
pcall(function() parentGui = CoreGui end)

local VALID_KEYS = {
    ["admin"] = true,
    ["WortNet"] = true,
    ["34frkhjG3JDAJNFA"] = true,
    ["xAworth"] = true,
    ["xA"] = true
}

-- 24 Saatlik Key Oturum Kontrolü
local SESSION_FILE = "WorthNet_Session_" .. player.UserId .. ".json"
local function checkSavedSession()
    if readfile and isfile and isfile(SESSION_FILE) then
        local success, data = pcall(function()
            return HttpService:JSONDecode(readfile(SESSION_FILE))
        end)
        if success and data and data.expireTime and os.time() < data.expireTime then
            return true
        end
    end
    return false
end

local function saveSession()
    if writefile then
        pcall(function()
            local data = { expireTime = os.time() + 86400 }
            writefile(SESSION_FILE, HttpService:JSONEncode(data))
        end)
    end
end

local function showNotification(title, desc)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = "WorthNet | " .. title; Text = desc; Duration = 4; })
    end)
end

-- Bypass Fonksiyonları (Anticheat Kısıtlamalarını Hafifletme)
pcall(function()
    for _, v in ipairs(getconnections(player.Idled)) do
        v:Disable()
    end
end)

local loadWorthNetMenu

-- =====================================================================
-- 1. KEY SİSTEMİ EKRANI
-- =====================================================================
local function openKeySystem()
    if checkSavedSession() then
        loadWorthNetMenu()
        return
    end

    local KeySystemGui = Instance.new("ScreenGui")
    KeySystemGui.Name = "WorthNetKeySystem"
    KeySystemGui.DisplayOrder = 2147483647
    KeySystemGui.ResetOnSpawn = false
    KeySystemGui.Parent = parentGui

    local KeyMainFrame = Instance.new("Frame")
    KeyMainFrame.Size = UDim2.new(0, 360, 0, 220)
    KeyMainFrame.Position = UDim2.new(0.5, -180, 0.5, -110)
    KeyMainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    KeyMainFrame.BorderSizePixel = 0
    KeyMainFrame.Active = true
    KeyMainFrame.Draggable = true
    KeyMainFrame.Parent = KeySystemGui
    Instance.new("UICorner", KeyMainFrame).CornerRadius = UDim.new(0, 10)

    local KeyTitle = Instance.new("TextLabel")
    KeyTitle.Size = UDim2.new(1, 0, 0, 50)
    KeyTitle.BackgroundTransparency = 1
    KeyTitle.Text = "WorthNet | Key Verification"
    KeyTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
    KeyTitle.TextSize = 16
    KeyTitle.Font = Enum.Font.GothamBold
    KeyTitle.Parent = KeyMainFrame

    local KeyInputBox = Instance.new("TextBox")
    KeyInputBox.Size = UDim2.new(0.85, 0, 0, 42)
    KeyInputBox.Position = UDim2.new(0.075, 0, 0.32, 0)
    KeyInputBox.BackgroundColor3 = Color3.fromRGB(26, 26, 32)
    KeyInputBox.BorderSizePixel = 0
    KeyInputBox.PlaceholderText = "Key girin (Örn: admin, xA)"
    KeyInputBox.Text = ""
    KeyInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInputBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 140)
    KeyInputBox.TextSize = 13
    KeyInputBox.Font = Enum.Font.GothamMedium
    KeyInputBox.Parent = KeyMainFrame
    Instance.new("UICorner", KeyInputBox).CornerRadius = UDim.new(0, 6)

    local EnterButton = Instance.new("TextButton")
    EnterButton.Size = UDim2.new(0.85, 0, 0, 42)
    EnterButton.Position = UDim2.new(0.075, 0, 0.62, 0)
    EnterButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    EnterButton.BorderSizePixel = 0
    EnterButton.Text = "Giriş Yap"
    EnterButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    EnterButton.TextSize = 14
    EnterButton.Font = Enum.Font.GothamBold
    EnterButton.Parent = KeyMainFrame
    Instance.new("UICorner", EnterButton).CornerRadius = UDim.new(0, 6)

    EnterButton.MouseButton1Click:Connect(function()
        local enteredKey = KeyInputBox.Text
        if VALID_KEYS[enteredKey] then
            saveSession()
            KeySystemGui:Destroy()
            loadWorthNetMenu()
        else
            showNotification("Hata", "Geçersiz key! Doğru key gir.")
        end
    end)
end

-- =====================================================================
-- 2. ANA HİLE MENÜSÜ (SOL TAB SİSTEMİ, MODERN TEMA, DİNAMİK OYUN ALGILAMA)
-- =====================================================================
function loadWorthNetMenu()
    showNotification("Hoşgeldin!", player.Name)

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "WorthNetMainSystem"
    MainGui.DisplayOrder = 2147483647
    MainGui.ResetOnSpawn = false
    MainGui.Parent = parentGui

    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(0, 560, 0, 440)
    Window.Position = UDim2.new(0.5, -280, 0.5, -220)
    Window.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
    Window.BorderSizePixel = 0
    Window.Active = true
    Window.Draggable = true
    Window.Parent = MainGui
    Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 10)

    -- Üst Bilgi Paneli (Profil Resmi, DisplayName, | Oyun İsmi)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Window
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

    -- Profil Resmi (Avatar Thumbnail)
    local ProfileImage = Instance.new("ImageLabel")
    ProfileImage.Size = UDim2.new(0, 34, 0, 34)
    ProfileImage.Position = UDim2.new(0, 12, 0.5, -17)
    ProfileImage.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
    ProfileImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size42x42)
    ProfileImage.Parent = TopBar
    Instance.new("UICorner", ProfileImage).CornerRadius = UDim.new(1, 0)

    -- DisplayName ve Oyun İsmi Etiketi
    local gameNameText = "Evrensel Sistem"
    local currentPlaceId = game.PlaceId
    local isMM2 = (currentPlaceId == 142823291 or Workspace:FindFirstChild("CoinContainer"))
    local isBloxFruits = (currentPlaceId == 2753915549)
    if isMM2 then gameNameText = "Murder Mystery 2" elseif isBloxFruits then gameNameText = "Blox Fruits" end

    local ProfileName = Instance.new("TextLabel")
    ProfileName.Size = UDim2.new(0.8, 0, 1, 0)
    ProfileName.Position = UDim2.new(0, 56, 0, 0)
    ProfileName.BackgroundTransparency = 1
    ProfileName.Text = player.DisplayName .. "  |  " .. gameNameText
    ProfileName.TextColor3 = Color3.fromRGB(240, 240, 245)
    ProfileName.TextSize = 13
    ProfileName.Font = Enum.Font.GothamBold
    ProfileName.TextXAlignment = Enum.TextXAlignment.Left
    ProfileName.Parent = TopBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 28, 0, 28)
    CloseButton.Position = UDim2.new(1, -36, 0.5, -14)
    CloseButton.BackgroundColor3 = Color3.fromRGB(235, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 28, 0, 28)
    MinimizeButton.Position = UDim2.new(1, -70, 0.5, -14)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TopBar
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

    -- Küçültülmüş Logo
    local FloatingLogo = Instance.new("TextButton")
    FloatingLogo.Size = UDim2.new(0, 50, 0, 50)
    FloatingLogo.Position = UDim2.new(0.1, 0, 0.1, 0)
    FloatingLogo.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    FloatingLogo.Text = "WN"
    FloatingLogo.TextColor3 = Color3.fromRGB(0, 122, 255)
    FloatingLogo.Font = Enum.Font.GothamBold
    FloatingLogo.Visible = false
    FloatingLogo.Active = true
    FloatingLogo.Draggable = true
    FloatingLogo.Parent = MainGui
    Instance.new("UICorner", FloatingLogo).CornerRadius = UDim.new(1, 0)

    CloseButton.MouseButton1Click:Connect(function() MainGui:Destroy() end)
    MinimizeButton.MouseButton1Click:Connect(function() Window.Visible = false FloatingLogo.Visible = true end)
    FloatingLogo.MouseButton1Click:Connect(function() Window.Visible = true FloatingLogo.Visible = false end)

    -- SOL TAB MENÜ SİSTEMİ
    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Size = UDim2.new(0, 130, 1, -60)
    TabContainer.Position = UDim2.new(0, 8, 0, 54)
    TabContainer.BackgroundTransparency = 1
    TabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = Window

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabListLayout.Padding = UDim.new(0, 6)
    TabListLayout.Parent = TabContainer

    -- İçerik Sayfaları Tutucusu
    local PagesContainer = Instance.new("Frame")
    PagesContainer.Size = UDim2.new(1, -150, 1, -60)
    PagesContainer.Position = UDim2.new(0, 146, 0, 54)
    PagesContainer.BackgroundTransparency = 1
    PagesContainer.Parent = Window

    local tabs = {}
    local activeTab = nil

    local function createTab(name)
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 36)
        TabButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        TabButton.Text = name
        TabButton.TextColor3 = Color3.fromRGB(160, 160, 180)
        TabButton.TextSize = 13
        TabButton.Font = Enum.Font.GothamMedium
        TabButton.Parent = TabContainer
        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 6)

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Size = UDim2.new(1, 0, 1, 0)
        TabPage.BackgroundTransparency = 1
        TabPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabPage.ScrollBarThickness = 4
        TabPage.Visible = false
        TabPage.Parent = PagesContainer

        local PageLayout = Instance.new("UIListLayout")
        PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
        PageLayout.Padding = UDim.new(0, 8)
        PageLayout.Parent = TabPage

        TabButton.MouseButton1Click:Connect(function()
            for _, t in pairs(tabs) do
                t.Page.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(22, 22, 28), TextColor3 = Color3.fromRGB(160, 160, 180)}):Play()
            end
            TabPage.Visible = true
            TweenService:Create(TabButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 122, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        end)

        if not activeTab then
            activeTab = TabPage
            TabPage.Visible = true
            TabButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
            TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end

        table.insert(tabs, {Button = TabButton, Page = TabPage})
        return TabPage
    end

    -- Tablar Oluşturuluyor: Main, Movement, Teleport, Trolling, Safety, (MM2 veya Blox Fruits)
    local mainTab = createTab("Main")
    local movementTab = createTab("Movement")
    local teleportTab = createTab("Teleport")
    local trollingTab = createTab("Trolling")
    local safetyTab = createTab("Safety")
    local gameTab = createTab(isMM2 and "MM2" or (isBloxFruits and "Blox Fruits" or "Extra"))

    local function createModernToggle(tab, title, desc, callback)
        local ToggleRow = Instance.new("Frame")
        ToggleRow.Size = UDim2.new(1, 0, 0, 46)
        ToggleRow.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        ToggleRow.Parent = tab
        Instance.new("UICorner", ToggleRow).CornerRadius = UDim.new(0, 6)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(0.7, 0, 0, 22)
        TitleLabel.Position = UDim2.new(0, 10, 0, 4)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
        TitleLabel.TextSize = 13
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = ToggleRow

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(0.7, 0, 0, 16)
        DescLabel.Position = UDim2.new(0, 10, 0, 26)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = desc
        DescLabel.TextColor3 = Color3.fromRGB(120, 120, 140)
        DescLabel.TextSize = 11
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Parent = ToggleRow

        local SwitchBtn = Instance.new("TextButton")
        SwitchBtn.Size = UDim2.new(0, 44, 0, 22)
        SwitchBtn.Position = UDim2.new(1, -54, 0.5, -11)
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
        SwitchBtn.Text = ""
        SwitchBtn.Parent = ToggleRow
        Instance.new("UICorner", SwitchBtn).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 18, 0, 18)
        Circle.Position = UDim2.new(0, 2, 0.5, -9)
        Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
        Circle.Parent = SwitchBtn
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local toggled = false
        SwitchBtn.MouseButton1Click:Connect(function()
            toggled = not toggled
            local targetPos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local targetColor = toggled and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 55)
            
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            pcall(function() callback(toggled) end)
        end)
    end

    -- =====================================================================
    -- 3. HİLELER VE ÖZELLİKLER (HIZ BARLI, OPTİMİZE ANTI-FLING, MENÜLÜ FING & TP)
    -- =====================================================================

    -- SPEEDHACK VE HIZ AYARLANABİLİR SLIDER BAR
    local speedVal = 16
    local speedConn
    createModernToggle(movementTab, "SpeedHack", "Karakter hızını artırır.", function(state)
        if state then
            speedConn = RunService.RenderStepped:Connect(function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = speedVal end
            end)
        else
            if speedConn then speedConn:Disconnect() speedConn = nil end
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end)

    -- Hız Ayar Slider Barı
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(1, 0, 0, 42)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    SliderFrame.Parent = movementTab
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Size = UDim2.new(0.7, 0, 0, 20)
    SliderTitle.Position = UDim2.new(0, 10, 0, 2)
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Text = "Hız Ayarı: 16 - 400"
    SliderTitle.TextColor3 = Color3.fromRGB(200, 200, 210)
    SliderTitle.TextSize = 12
    SliderTitle.Font = Enum.Font.GothamBold
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left
    SliderTitle.Parent = SliderFrame

    local SliderBarBg = Instance.new("Frame")
    SliderBarBg.Size = UDim2.new(0.9, 0, 0, 8)
    SliderBarBg.Position = UDim2.new(0.05, 0, 0, 26)
    SliderBarBg.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    SliderBarBg.BorderSizePixel = 0
    SliderBarBg.Parent = SliderFrame
    Instance.new("UICorner", SliderBarBg).CornerRadius = UDim.new(1, 0)

    local SliderBarFill = Instance.new("Frame")
    SliderBarFill.Size = UDim2.new(0, 0, 1, 0)
    SliderBarFill.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
    SliderBarFill.BorderSizePixel = 0
    SliderBarFill.Parent = SliderBarBg
    Instance.new("UICorner", SliderBarFill).CornerRadius = UDim.new(1, 0)

    local draggingSlider = false
    SliderBarBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBarBg.AbsolutePosition.X) / SliderBarBg.AbsoluteSize.X, 0, 1)
            SliderBarFill.Size = UDim2.new(pos, 0, 1, 0)
            speedVal = math.floor(16 + (pos * (400 - 16)))
            SliderTitle.Text = "Hız Ayarı: " .. speedVal
        end
    end)

    -- NOCLIP
    local noclipConn
    createModernToggle(movementTab, "WorthNet Noclip", "Duvarlardan ve nesnelerden geçmeni sağlar.", function(state)
        if state then
            noclipConn = RunService.Stepped:Connect(function()
                local char = player.Character
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if noclipConn then noclipConn:Disconnect() noclipConn = nil end
        end
    end)

    -- INFINITE JUMP
    local infJumpConn
    createModernToggle(movementTab, "Infinite Jump", "Havadayken sınırsız zıplamanı sağlar.", function(state)
        if state then
            infJumpConn = UserInputService.JumpRequest:Connect(function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
        end
    end)

    -- FLY (P Tuşu)
    local flyActive = false
    local flySpeed = 50
    local bg, bv, flyConn
    local keys = {W=false, S=false, A=false, D=false, Space=false, Shift=false}

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.W then keys.W = true end
        if input.KeyCode == Enum.KeyCode.S then keys.S = true end
        if input.KeyCode == Enum.KeyCode.A then keys.A = true end
        if input.KeyCode == Enum.KeyCode.D then keys.D = true end
        if input.KeyCode == Enum.KeyCode.Space then keys.Space = true end
        if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = true end
        if input.KeyCode == Enum.KeyCode.P then flyActive = not flyActive end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keys.W = false end
        if input.KeyCode == Enum.KeyCode.S then keys.S = false end
        if input.KeyCode == Enum.KeyCode.A then keys.A = false end
        if input.KeyCode == Enum.KeyCode.D then keys.D = false end
        if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = false end
    end)

    createModernToggle(movementTab, "WorthNet Fly (P Tuşu)", "P tuşuna basarak uçuşu açıp kapatabilirsin.", function(state)
        flyActive = state
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")

        if flyActive and root and hum then
            hum.PlatformStand = true
            bv = Instance.new("BodyVelocity", root)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)

            bg = Instance.new("BodyGyro", root)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 9000
            bg.CFrame = root.CFrame

            flyConn = RunService.RenderStepped:Connect(function()
                if not flyActive or not root or not root.Parent then
                    if flyConn then flyConn:Disconnect() end
                    return
                end
                local cam = Workspace.CurrentCamera
                local camCF = cam.CFrame
                local moveDir = Vector3.new(0,0,0)
                if keys.W then moveDir = moveDir + camCF.LookVector end
                if keys.S then moveDir = moveDir - camCF.LookVector end
                if keys.A then moveDir = moveDir - camCF.RightVector end
                if keys.D then moveDir = moveDir + camCF.RightVector end
                if keys.Space then moveDir = moveDir + Vector3.new(0,1,0) end
                if keys.Shift then moveDir = moveDir - Vector3.new(0,1,0) end

                bv.Velocity = moveDir.Magnitude > 0 and moveDir.Unit * flySpeed or Vector3.new(0, 0.1, 0)
                bg.CFrame = camCF
            end)
        else
            if flyConn then flyConn:Disconnect() end
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            if hum then hum.PlatformStand = false end
        end
    end)

    -- OPTİMİZE EDİLMİŞ KASMA YAPMAYAN ANTI-FLING
    local antiFlingConn = nil
    createModernToggle(safetyTab, "Anti-Fling (Optimize)", "Seni uçurmaya çalışan exploitleri engeller.", function(state)
        if state then
            antiFlingConn = RunService.Heartbeat:Connect(function()
                local char = player.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root and root.AssemblyLinearVelocity.Magnitude > 250 then
                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local enemyRoot = p.Character:FindFirstChild("HumanoidRootPart")
                        if enemyRoot then
                            if enemyRoot.AssemblyLinearVelocity.Magnitude > 75 or enemyRoot.AssemblyAngularVelocity.Magnitude > 75 then
                                for _, part in ipairs(p.Character:GetDescendants()) do
                                    if part:IsA("BasePart") then
                                        part.CanCollide = false
                                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                    end
                                end
                            end
                        end
                    end
                end
            end)
            showNotification("Anti-Fling", "Aktif edildi.", true)
        else
            if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
            showNotification("Anti-Fling", "Durduruldu.", false)
        end
    end)

    -- =====================================================================
    -- 4. OYUNCU SEÇİMLİ TELEPORT MENÜSÜ
    -- =====================================================================
    createModernToggle(teleportTab, "Işınlanma Menüsü Aç", "Seçilen oyuncuya anında ışınlanmanı sağlar.", function(state)
        if state then
            local TPMenuGui = Instance.new("ScreenGui")
            TPMenuGui.Name = "WorthNetTPMenu"
            TPMenuGui.DisplayOrder = 2147483647
            TPMenuGui.Parent = parentGui

            local TPFrame = Instance.new("Frame")
            TPFrame.Size = UDim2.new(0, 260, 0, 320)
            TPFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
            TPFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            TPFrame.Active = true
            TPFrame.Draggable = true
            TPFrame.Parent = TPMenuGui
            Instance.new("UICorner", TPFrame).CornerRadius = UDim.new(0, 10)

            local TPTitle = Instance.new("TextLabel")
            TPTitle.Size = UDim2.new(1, 0, 0, 40)
            TPTitle.BackgroundTransparency = 1
            TPTitle.Text = "Oyuncu Seç & Işınlan"
            TPTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            TPTitle.Font = Enum.Font.GothamBold
            TPTitle.TextSize = 14
            TPTitle.Parent = TPFrame

            local CloseTP = Instance.new("TextButton")
            CloseTP.Size = UDim2.new(0, 24, 0, 24)
            CloseTP.Position = UDim2.new(1, -32, 0, 8)
            CloseTP.BackgroundColor3 = Color3.fromRGB(235, 60, 60)
            CloseTP.Text = "X"
            CloseTP.TextColor3 = Color3.fromRGB(255, 255, 255)
            CloseTP.Font = Enum.Font.GothamBold
            CloseTP.Parent = TPFrame
            Instance.new("UICorner", CloseTP).CornerRadius = UDim.new(0, 4)
            CloseTP.MouseButton1Click:Connect(function() TPMenuGui:Destroy() end)

            local TPScroll = Instance.new("ScrollingFrame")
            TPScroll.Size = UDim2.new(1, -16, 1, -55)
            TPScroll.Position = UDim2.new(0, 8, 0, 45)
            TPScroll.BackgroundTransparency = 1
            TPScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            TPScroll.ScrollBarThickness = 3
            TPScroll.Parent = TPFrame

            local TPList = Instance.new("UIListLayout")
            TPList.SortOrder = Enum.SortOrder.LayoutOrder
            TPList.Padding = UDim.new(0, 5)
            TPList.Parent = TPScroll

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    local pBtn = Instance.new("TextButton")
                    pBtn.Size = UDim2.new(1, 0, 0, 32)
                    pBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
                    pBtn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
                    pBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
                    pBtn.Font = Enum.Font.GothamMedium
                    pBtn.TextSize = 12
                    pBtn.TextXAlignment = Enum.TextXAlignment.Left
                    pBtn.Parent = TPScroll
                    Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)

                    pBtn.MouseButton1Click:Connect(function()
                        if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                hrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                                showNotification("Işınlanma", p.Name .. " yanına ışınlanıldı.")
                            end
                        end
                    end)
                end
            end
        end
    end)

    -- =====================================================================
    -- 5. OYUNCU SEÇİMLİ FLING MENÜSÜ
    -- =====================================================================
    createModernToggle(trollingTab, "Fling Oyuncu Menüsü", "İstediğin oyuncuya fling atmanı sağlar.", function(state)
        if state then
            local FlingMenuGui = Instance.new("ScreenGui")
            FlingMenuGui.Name = "WorthNetFlingMenu"
            FlingMenuGui.DisplayOrder = 2147483647
            FlingMenuGui.Parent = parentGui

            local FlingFrame = Instance.new("Frame")
            FlingFrame.Size = UDim2.new(0, 260, 0, 320)
            FlingFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
            FlingFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
            FlingFrame.Active = true
            FlingFrame.Draggable = true
            FlingFrame.Parent = FlingMenuGui
            Instance.new("UICorner", FlingFrame).CornerRadius = UDim.new(0, 10)

            local FTitle = Instance.new("TextLabel")
            FTitle.Size = UDim2.new(1, 0, 0, 40)
            FTitle.BackgroundTransparency = 1
            FTitle.Text = "Fling Atılacak Oyuncuyu Seç"
            FTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            FTitle.Font = Enum.Font.GothamBold
            FTitle.TextSize = 13
            FTitle.Parent = FlingFrame

            local CloseF = Instance.new("TextButton")
            CloseF.Size = UDim2.new(0, 24, 0, 24)
            CloseF.Position = UDim2.new(1, -32, 0, 8)
            CloseF.BackgroundColor3 = Color3.fromRGB(235, 60, 60)
            CloseF.Text = "X"
            CloseF.TextColor3 = Color3.fromRGB(255, 255, 255)
            CloseF.Font = Enum.Font.GothamBold
            CloseF.Parent = FlingFrame
            Instance.new("UICorner", CloseF).CornerRadius = UDim.new(0, 4)
            CloseF.MouseButton1Click:Connect(function()
                _G.SelectedFlingTarget = nil
                FlingMenuGui:Destroy()
            end)

            local FScroll = Instance.new("ScrollingFrame")
            FScroll.Size = UDim2.new(1, -16, 1, -55)
            FScroll.Position = UDim2.new(0, 8, 0, 45)
            FScroll.BackgroundTransparency = 1
            FScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
            FScroll.ScrollBarThickness = 3
            FScroll.Parent = FlingFrame

            local FList = Instance.new("UIListLayout")
            FList.SortOrder = Enum.SortOrder.LayoutOrder
            FList.Padding = UDim.new(0, 5)
            FList.Parent = FScroll

            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    local pBtn = Instance.new("TextButton")
                    pBtn.Size = UDim2.new(1, 0, 0, 32)
                    pBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
                    pBtn.Text = "  " .. p.DisplayName .. " (Flingle)"
                    pBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
                    pBtn.Font = Enum.Font.GothamMedium
                    pBtn.TextSize = 12
                    pBtn.TextXAlignment = Enum.TextXAlignment.Left
                    pBtn.Parent = FScroll
                    Instance.new("UICorner", pBtn).CornerRadius = UDim.new(0, 6)

                    pBtn.MouseButton1Click:Connect(function()
                        _G.SelectedFlingTarget = p
                        showNotification("Fling", p.Name .. " hedeflendi! Fling eylemi başlatılıyor.")
                        task.spawn(function()
                            while _G.SelectedFlingTarget == p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") do
                                task.wait()
                                local char = player.Character
                                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                                local target = p.Character.HumanoidRootPart
                                if hrp and target then
                                    hrp.CFrame = target.CFrame
                                    hrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                                    hrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
                                    RunService.Heartbeat:Wait()
                                end
                            end
                        end)
                    end)
                end
            end
        else
            _G.SelectedFlingTarget = nil
        end
    end)

    -- =====================================================================
    -- 6. MM2 ÖZEL HİLELERİ (AUTO GUNDROP, AUTO COIN, ROL ESP, FLING SHERIFF & MURDER)
    -- =====================================================================
    if isMM2 then
        local function getCoinContainer()
            for _, child in ipairs(Workspace:GetChildren()) do
                local container = child:FindFirstChild("CoinContainer")
                if container then return container end
            end
            return nil
        end

        createModernToggle(gameTab, "MM2 AutoCoin", "Haritadaki coinleri otomatik toplar.", function(state)
            _G.AutoCoinActive = state
        end)

        task.spawn(function()
            local collectedCount = 0
            while task.wait(0.5) do
                if _G.AutoCoinActive then
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local coinContainer = getCoinContainer()
                        if coinContainer then
                            for _, coinPart in ipairs(coinContainer:GetChildren()) do
                                if not _G.AutoCoinActive then break end
                                if coinPart.Name == "Coin_Server" and coinPart:IsA("BasePart") then
                                    while coinPart and coinPart.Parent and _G.AutoCoinActive do
                                        local targetPos = coinPart.Position - Vector3.new(0, 3.5, 0)
                                        local dist = (hrp.Position - coinPart.Position).Magnitude
                                        if dist < 2 then break end
                                        local finalTarget = dist < 12 and coinPart.Position or targetPos
                                        
                                        RunService.Heartbeat:Wait()
                                        local direction = (finalTarget - hrp.Position).Unit
                                        hrp.CFrame = hrp.CFrame + (direction * math.min(16 * 0.03, (finalTarget - hrp.Position).Magnitude))
                                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    end
                                    collectedCount = collectedCount + 1
                                    if collectedCount >= 50 then
                                        local hum = char:FindFirstChildOfClass("Humanoid")
                                        if hum then hum.Health = 0 end
                                        collectedCount = 0
                                        task.wait(3)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)

        -- DÜZELTİLMİŞ VE HIZLANDIRILMIŞ AUTO GUNDROP
        local autoGunDropEnabled = false
        createModernToggle(gameTab, "Auto GunDrop", "Harita içindeki Silahı anında toplar.", function(state)
            autoGunDropEnabled = state
        end)

        task.spawn(function()
            while true do
                task.wait(0.05)
                if autoGunDropEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local backpack = player:FindFirstChild("Backpack")
                    local hasKnife = false
                    if backpack and backpack:FindFirstChild("Knife") then
                        hasKnife = true
                    elseif player.Character:FindFirstChild("Knife") then
                        hasKnife = true
                    end

                    if not hasKnife then
                        local rootPart = player.Character.HumanoidRootPart
                        local originalCFrame = rootPart.CFrame
                        local targetPart = nil

                        for _, item in ipairs(Workspace:GetChildren()) do
                            if item.Name == "GunDrop" then
                                targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or (item:IsA("BasePart") and item)
                                if targetPart then break end
                            elseif item:IsA("Model") or item:IsA("Folder") then
                                local foundInMap = item:FindFirstChild("GunDrop", true)
                                if foundInMap then
                                    if foundInMap:IsA("Model") then
                                        targetPart = foundInMap.PrimaryPart or foundInMap:FindFirstChildWhichIsA("BasePart")
                                    elseif foundInMap:IsA("BasePart") then
                                        targetPart = foundInMap
                                    end
                                    if targetPart then break end
                                end
                            end
                        end

                        if targetPart then
                            pcall(function()
                                rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                                if targetPart:IsA("BasePart") then
                                    firetouchinterest(rootPart, targetPart, 0)
                                    firetouchinterest(rootPart, targetPart, 1)
                                end
                                task.wait()
                                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    rootPart.CFrame = originalCFrame
                                    if rootPart:FindFirstChildOfClass("BodyVelocity") == nil then
                                        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                                    end
                                end
                            end)
                        end
                    end
                end
            end
        end)

        -- FLING SHERIFF & FLING MURDER
        createModernToggle(gameTab, "Fling Sheriff", "Envanterinde Gun olan kişiyi flingler ve geri döner.", function(state)
            if state then
                task.spawn(function()
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local origCF = hrp.CFrame
                    local target = nil
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local pack = p:FindFirstChild("Backpack")
                            if (pack and (pack:FindFirstChild("Gun") or pack:FindFirstChild("Revolver"))) or p.Character:FindFirstChild("Gun") then
                                target = p.Character:FindFirstChild("HumanoidRootPart")
                                break
                            end
                        end
                    end
                    if target then
                        for i = 1, 30 do
                            hrp.CFrame = target.CFrame
                            hrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                            hrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
                            RunService.Heartbeat:Wait()
                        end
                        hrp.CFrame = origCF
                        showNotification("Fling Sheriff", "Hedef flinglendi ve eski konuma dönüldü.")
                    else
                        showNotification("Fling Sheriff", "Aktif Sheriff bulunamadı.")
                    end
                end)
            end
        end)

        createModernToggle(gameTab, "Fling Murder", "Envanterinde Knife olan kişiyi flingler ve geri döner.", function(state)
            if state then
                task.spawn(function()
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if not hrp then return end
                    local origCF = hrp.CFrame
                    local target = nil
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character then
                            local pack = p:FindFirstChild("Backpack")
                            if (pack and (pack:FindFirstChild("Knife") or pack:FindFirstChild("MurdererKnife"))) or p.Character:FindFirstChild("Knife") then
                                target = p.Character:FindFirstChild("HumanoidRootPart")
                                break
                            end
                        end
                    end
                    if target then
                        for i = 1, 30 do
                            hrp.CFrame = target.CFrame
                            hrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                            hrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
                            RunService.Heartbeat:Wait()
                        end
                        hrp.CFrame = origCF
                        showNotification("Fling Murder", "Hedef flinglendi ve eski konuma dönüldü.")
                    else
                        showNotification("Fling Murder", "Aktif Murderer bulunamadı.")
                    end
                end)
            end
        end)

        local mm2Highlights = {}
        createModernToggle(gameTab, "MM2 Rol ESP", "Murderer ve Sheriff rollerini renkli gösterir.", function(state)
            _G.MM2ESP = state
            if not _G.MM2ESP then
                for _, hl in pairs(mm2Highlights) do if hl then hl:Destroy() end end
                table.clear(mm2Highlights)
            else
                task.spawn(function()
                    while _G.MM2ESP do
                        task.wait(0.5)
                        for _, p in ipairs(Players:GetPlayers()) do
                            if not _G.MM2ESP then break end
                            if p ~= player and p.Character then
                                local char = p.Character
                                local roleColor = Color3.fromRGB(0, 255, 0)
                                local pack = p:FindFirstChild("Backpack")
                                if (pack and (pack:FindFirstChild("Knife") or pack:FindFirstChild("MurdererKnife"))) or char:FindFirstChild("Knife") then
                                    roleColor = Color3.fromRGB(255, 0, 0)
                                elseif (pack and (pack:FindFirstChild("Gun") or pack:FindFirstChild("Revolver"))) or char:FindFirstChild("Gun") then
                                    roleColor = Color3.fromRGB(0, 122, 255)
                                end
                                if not mm2Highlights[p.Name] or mm2Highlights[p.Name].Parent ~= char then
                                    if mm2Highlights[p.Name] then mm2Highlights[p.Name]:Destroy() end
                                    local hl = Instance.new("Highlight", char)
                                    hl.FillTransparency = 0.5
                                    hl.OutlineTransparency = 0
                                    mm2Highlights[p.Name] = hl
                                end
                                mm2Highlights[p.Name].FillColor = roleColor
                                mm2Highlights[p.Name].OutlineColor = roleColor
                            end
                        end
                    end
                end)
            end
        end)
    end

    -- =====================================================================
    -- 7. BLOX FRUITS ÖZEL HİLELERİ
    -- =====================================================================
    if isBloxFruits then
        createModernToggle(gameTab, "Blox Fruits Auto Farm", "Blox Fruits için otomatik görev ve level kasma.", function(state)
            _G.BFAutoFarm = state
        end)
    end

    showNotification("WorthNet", "Sistem başarıyla yüklendi!", true)
end

openKeySystem()
