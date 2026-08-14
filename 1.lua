-- =====================================================================
--           WORTHNET ULTIMATE MASTER SYSTEM v6.0 (FINAL+)
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
    KeyMainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
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
    KeyInputBox.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    KeyInputBox.BorderSizePixel = 0
    KeyInputBox.PlaceholderText = "Key girin (Örn: admin, xA)"
    KeyInputBox.Text = ""
    KeyInputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    KeyInputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
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
-- 2. ANA HİLE MENÜSÜ VE OYUNA GÖRE DİNAMİK YÜKLEME
-- =====================================================================
function loadWorthNetMenu()
    showNotification("Hoşgeldin!", player.Name)

    local MainGui = Instance.new("ScreenGui")
    MainGui.Name = "WorthNetMainSystem"
    MainGui.DisplayOrder = 2147483647
    MainGui.ResetOnSpawn = false
    MainGui.Parent = parentGui

    local Window = Instance.new("Frame")
    Window.Size = UDim2.new(0, 520, 0, 420)
    Window.Position = UDim2.new(0.5, -260, 0.5, -210)
    Window.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    Window.BorderSizePixel = 0
    Window.Active = true
    Window.Draggable = true
    Window.Parent = MainGui
    Instance.new("UICorner", Window).CornerRadius = UDim.new(0, 10)

    -- Üst Bilgi Paneli (Profil & İsim)
    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 55)
    TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Window
    Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

    local ProfileName = Instance.new("TextLabel")
    ProfileName.Size = UDim2.new(0.6, 0, 1, 0)
    ProfileName.Position = UDim2.new(0, 14, 0, 0)
    ProfileName.BackgroundTransparency = 1
    ProfileName.Text = "WorthNet | " .. player.Name
    ProfileName.TextColor3 = Color3.fromRGB(240, 240, 240)
    ProfileName.TextSize = 14
    ProfileName.Font = Enum.Font.GothamBold
    ProfileName.TextXAlignment = Enum.TextXAlignment.Left
    ProfileName.Parent = TopBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -38, 0.5, -15)
    CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TopBar
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -74, 0.5, -15)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TopBar
    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 6)

    -- Küçültülmüş Sürüklenebilir Logo
    local FloatingLogo = Instance.new("TextButton")
    FloatingLogo.Size = UDim2.new(0, 50, 0, 50)
    FloatingLogo.Position = UDim2.new(0.1, 0, 0.1, 0)
    FloatingLogo.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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

    local ContentArea = Instance.new("ScrollingFrame")
    ContentArea.Size = UDim2.new(1, -20, 1, -70)
    ContentArea.Position = UDim2.new(0, 10, 0, 62)
    ContentArea.BackgroundTransparency = 1
    ContentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
    ContentArea.ScrollBarThickness = 4
    ContentArea.Parent = Window

    local UIList = Instance.new("UIListLayout")
    UIList.SortOrder = Enum.SortOrder.LayoutOrder
    UIList.Padding = UDim.new(0, 8)
    UIList.Parent = ContentArea

    -- Özlü `createMT` Fonksiyonu
    local function createMT(tabName, hileTitle, callback)
        local ToggleRow = Instance.new("Frame")
        ToggleRow.Size = UDim2.new(1, 0, 0, 42)
        ToggleRow.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
        ToggleRow.Parent = ContentArea
        Instance.new("UICorner", ToggleRow).CornerRadius = UDim.new(0, 6)

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
        TitleLabel.Position = UDim2.new(0, 10, 0, 0)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = "[" .. tabName .. "] " .. hileTitle
        TitleLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
        TitleLabel.TextSize = 13
        TitleLabel.Font = Enum.Font.GothamMedium
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.Parent = ToggleRow

        local SwitchBtn = Instance.new("TextButton")
        SwitchBtn.Size = UDim2.new(0, 44, 0, 22)
        SwitchBtn.Position = UDim2.new(1, -54, 0.5, -11)
        SwitchBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        SwitchBtn.Text = ""
        SwitchBtn.Parent = ToggleRow
        Instance.new("UICorner", SwitchBtn).CornerRadius = UDim.new(1, 0)

        local Circle = Instance.new("Frame")
        Circle.Size = UDim2.new(0, 18, 0, 18)
        Circle.Position = UDim2.new(0, 2, 0.5, -9)
        Circle.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
        Circle.Parent = SwitchBtn
        Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

        local toggled = false
        SwitchBtn.MouseButton1Click:Connect(function()
            toggled = not toggled
            local targetPos = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
            local targetColor = toggled and Color3.fromRGB(0, 122, 255) or Color3.fromRGB(45, 45, 45)
            
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
            TweenService:Create(SwitchBtn, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
            
            pcall(function() callback(toggled) end)
        end)
    end

    -- Oyunu Otomatik Algılama
    local currentPlaceId = game.PlaceId
    local isMM2 = (currentPlaceId == 142823291)
    local isBloxFruits = (currentPlaceId == 2753915549)

    if not isMM2 and not isBloxFruits then
        if Workspace:FindFirstChild("CoinContainer") then isMM2 = true end
    end

    -- =====================================================================
    -- 3. HİLELER (Movement, TP Menüsü, Anti-Fling, Fling, MM2, Blox Fruits)
    -- =====================================================================

    -- EVRENSEL HİLELER (SpeedHack, Noclip, Inf Jump, Fly)
    local speedVal = 75
    local speedConn
    createMT("Movement", "SpeedHack", function(state)
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

    local noclipConn
    createMT("Movement", "WorthNet Noclip", function(state)
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

    local infJumpConn
    createMT("Movement", "Infinite Jump", function(state)
        if state then
            infJumpConn = UserInputService.JumpRequest:Connect(function()
                local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
            end)
        else
            if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
        end
    end)

    -- WorthNet Fly (P Tuşu)
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
        if input.KeyCode == Enum.KeyCode.P then
            flyActive = not flyActive
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then keys.W = false end
        if input.KeyCode == Enum.KeyCode.S then keys.S = false end
        if input.KeyCode == Enum.KeyCode.A then keys.A = false end
        if input.KeyCode == Enum.KeyCode.D then keys.D = false end
        if input.KeyCode == Enum.KeyCode.Space then keys.Space = false end
        if input.KeyCode == Enum.KeyCode.LeftShift then keys.Shift = false end
    end)

    createMT("Movement", "WorthNet Fly (P Tuşu)", function(state)
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

    -- YENİ EKLENEN ÖZELLİKLER: Anti-Fling, TP Menüsü ve Fling Sistemi
    
    -- 1. Anti-Fling Koruması
    local antiFlingConn
    createMT("Safety", "Anti-Fling", function(state)
        if state then
            antiFlingConn = RunService.Stepped:Connect(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        for _, part in ipairs(p.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.RotVelocity = Vector3.new(0, 0, 0)
                                part.Velocity = Vector3.new(0, 0, 0)
                            end
                        end
                    end
                end
            end)
        else
            if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
        end
    end)

    -- 2. Oyuncu Flingleme (Hedef Oyuncuya Uçurarak Fling Atma)
    createMT("Trolling", "Player Fling (Target)", function(state)
        _G.FlingActive = state
        if _G.FlingActive then
            task.spawn(function()
                local targetName = "" -- İstediğiniz hedef oyuncu adı eklenebilir veya en yakın oyuncu seçilebilir
                while _G.FlingActive do
                    task.wait()
                    local char = player.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local target = nil
                        for _, p in ipairs(Players:GetPlayers()) do
                            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                                target = p.Character.HumanoidRootPart
                                break
                            end
                        end
                        if target then
                            local rot = hrp.CFrame
                            hrp.CFrame = target.CFrame
                            hrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                            hrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
                            RunService.Heartbeat:Wait()
                        end
                    end
                end
            end)
        end
    end)

    -- 3. Oyuncuya Işınlanma (TP Menüsü Mantığı)
    createMT("Teleport", "TP to Random Player", function(state)
        if state then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        hrp.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                        showNotification("Teleport", p.Name .. " adlı oyuncuya ışınlanıldı!")
                        break
                    end
                end
            end
        end
    end)

    -- MM2 ÖZEL HİLELERİ
    if isMM2 then
        local function getCoinContainer()
            for _, child in ipairs(Workspace:GetChildren()) do
                local container = child:FindFirstChild("CoinContainer")
                if container then return container end
            end
            return nil
        end

        createMT("MM2", "MM2 AutoCoin", function(state)
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

        createMT("MM2", "Auto GunDrop", function(state)
            _G.AutoGunDropActive = state
        end)

        task.spawn(function()
            while true do
                task.wait(0.1)
                if _G.AutoGunDropActive and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local bp = player:FindFirstChild("Backpack")
                    local hasKnife = (bp and bp:FindFirstChild("Knife")) or player.Character:FindFirstChild("Knife")
                    if not hasKnife then
                        local hrp = player.Character.HumanoidRootPart
                        local origCFrame = hrp.CFrame
                        local targetPart = nil
                        for _, item in ipairs(Workspace:GetChildren()) do
                            if item.Name == "GunDrop" then
                                targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or (item:IsA("BasePart") and item)
                                if targetPart then break end
                            end
                        end
                        if targetPart then
                            pcall(function()
                                hrp.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                                if targetPart:IsA("BasePart") then
                                    firetouchinterest(hrp, targetPart, 0)
                                    firetouchinterest(hrp, targetPart, 1)
                                end
                                task.wait()
                                if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    hrp.CFrame = origCFrame
                                end
                            end)
                        end
                    end
                end
            end
        end)

        local mm2Highlights = {}
        createMT("MM2", "MM2 Rol ESP", function(state)
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

    -- BLOX FRUITS ÖZEL HİLELERİ
    if isBloxFruits then
        createMT("BloxFruits", "Blox Fruits Auto Farm", function(state)
            _G.BFAutoFarm = state
        end)
    end

    showNotification("WorthNet", "Sistem başarıyla yüklendi!", true)
end

openKeySystem()
