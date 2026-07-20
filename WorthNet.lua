-- WorthNet UI System v4.3 - Full Fixed & Optimized
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

-- Ekrandaki eski yapıları temizle
local oldGui = player.PlayerGui:FindFirstChild("WorthNetSystem")
if oldGui then oldGui:Destroy() end

-- ANA EKRAN CONTAINER
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WorthNetSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- PREMIUM TEMA RENKLERİ
local THEME = {
	Background = Color3.fromRGB(24, 24, 28),
	Sidebar = Color3.fromRGB(18, 18, 20),
	Card = Color3.fromRGB(28, 28, 32),
	Accent = Color3.fromRGB(220, 130, 30),
	TextMain = Color3.fromRGB(240, 240, 245),
	TextDark = Color3.fromRGB(150, 150, 155),
	ToggleOn = Color3.fromRGB(220, 130, 30),
	ToggleOff = Color3.fromRGB(60, 60, 65)
}

local function roundCorners(obj, radius)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, radius or 8)
	uiCorner.Parent = obj
	return uiCorner
end

---------------------------------------------------------
-- KUSURSUZ SÜRÜKLENME MOTORU
---------------------------------------------------------
local function makeDraggable(frame)
	local dragging = false
	local dragInput, dragStart, startPos

	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)

	frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
end

---------------------------------------------------------
-- MERKEZİ BİLDİRİM SİSTEMİ
---------------------------------------------------------
local activeNotifications = {}

local function rearrangeNotifications()
	for index, notif in ipairs(activeNotifications) do
		local targetY = 20 + ((index - 1) * 60)
		TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -240, 0, targetY)
		}):Play()
	end
end

local function showNotification(title, message, isSuccess)
	local notifFrame = Instance.new("Frame")
	notifFrame.Size = UDim2.new(0, 220, 0, 50)
	
	local initialY = 20 + (#activeNotifications * 60)
	notifFrame.Position = UDim2.new(1, 30, 0, initialY)
	notifFrame.BackgroundColor3 = THEME.Sidebar
	notifFrame.BorderSizePixel = 0
	notifFrame.Parent = screenGui
	roundCorners(notifFrame, 8)
	
	local stroke = Instance.new("UIStroke", notifFrame)
	stroke.Color = isSuccess and Color3.fromRGB(0, 200, 100) or Color3.fromRGB(200, 50, 50)
	stroke.Thickness = 1.5
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "🔔 [" .. title .. "]\n" .. message
	label.TextColor3 = THEME.TextMain
	label.Font = Enum.Font.GothamBold
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = notifFrame
	
	table.insert(activeNotifications, notifFrame)
	rearrangeNotifications()
	
	task.delay(2.5, function()
		local foundIndex = table.find(activeNotifications, notifFrame)
		if foundIndex then
			table.remove(activeNotifications, foundIndex)
		end
		
		local currentY = notifFrame.Position.Y.Offset
		local closeTween = TweenService:Create(notifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 30, 0, currentY)
		})
		closeTween:Play()
		rearrangeNotifications()
		
		closeTween.Completed:Connect(function() 
			notifFrame:Destroy() 
		end)
	end)
end

---------------------------------------------------------
-- KÜÇÜK LOGO (MINIMIZE WINDOW)
---------------------------------------------------------
local minLogo = Instance.new("TextButton")
minLogo.Size = UDim2.new(0, 65, 0, 65)
minLogo.Position = UDim2.new(1, -85, 0.5, -32)
minLogo.BackgroundColor3 = THEME.Sidebar
minLogo.Text = "👑\nWN"
minLogo.Font = Enum.Font.GothamBold
minLogo.TextSize = 14
minLogo.TextColor3 = THEME.Accent
minLogo.BorderSizePixel = 0
minLogo.ZIndex = 10
minLogo.Visible = true
minLogo.Parent = screenGui
roundCorners(minLogo, 16)
makeDraggable(minLogo)

local logoStroke = Instance.new("UIStroke")
logoStroke.Color = THEME.Accent
logoStroke.Thickness = 1.5
logoStroke.Parent = minLogo

---------------------------------------------------------
-- ANA FRAME (HUB FRAME)
---------------------------------------------------------
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 600, 0, 380)
hubFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
hubFrame.BackgroundColor3 = THEME.Background
hubFrame.BorderSizePixel = 0
hubFrame.ZIndex = 5
hubFrame.Visible = false
hubFrame.Parent = screenGui
roundCorners(hubFrame, 12)
makeDraggable(hubFrame)

minLogo.MouseButton1Click:Connect(function()
	minLogo.Visible = false
	hubFrame.Visible = true
end)

-- SOL SİDEBAR
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = THEME.Sidebar
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 6
sidebar.Parent = hubFrame
roundCorners(sidebar, 12)

local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(1, 0, 0, 50)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "👑 WorthNet"
logoLabel.TextColor3 = THEME.Accent
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextSize = 18
logoLabel.ZIndex = 7
logoLabel.Parent = sidebar

local allHacksBtn = Instance.new("Frame")
allHacksBtn.Size = UDim2.new(1, -20, 0, 40)
allHacksBtn.Position = UDim2.new(0, 10, 0, 60)
allHacksBtn.BackgroundColor3 = THEME.Card
allHacksBtn.ZIndex = 7
allHacksBtn.Parent = sidebar
roundCorners(allHacksBtn, 8)

local allHacksLabel = Instance.new("TextLabel")
allHacksLabel.Size = UDim2.new(1, 0, 1, 0)
allHacksLabel.Position = UDim2.new(0, 10, 0, 0)
allHacksLabel.BackgroundTransparency = 1
allHacksLabel.Text = "All Hacks"
allHacksLabel.TextColor3 = THEME.TextMain
allHacksLabel.Font = Enum.Font.GothamSemibold
allHacksLabel.TextSize = 13
allHacksLabel.TextXAlignment = Enum.TextXAlignment.Left
allHacksLabel.ZIndex = 8
allHacksLabel.Parent = allHacksBtn

-- ARAMA KUTUSU
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 32)
searchBox.Position = UDim2.new(0, 10, 0, 110)
searchBox.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
searchBox.Text = ""
searchBox.PlaceholderText = "🔍 Hile Ara..."
searchBox.TextColor3 = THEME.TextMain
searchBox.PlaceholderColor3 = THEME.TextDark
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.ZIndex = 8
searchBox.Parent = sidebar
roundCorners(searchBox, 6)

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = Color3.fromRGB(50, 50, 55)
searchStroke.Thickness = 1
searchStroke.Parent = searchBox

-- TOPLU KONTROL BUTONLARI
local controlContainer = Instance.new("Frame")
controlContainer.Size = UDim2.new(1, -20, 0, 30)
controlContainer.Position = UDim2.new(0, 10, 0, 150)
controlContainer.BackgroundTransparency = 1
controlContainer.ZIndex = 8
controlContainer.Parent = sidebar

local openAllBtn = Instance.new("TextButton")
openAllBtn.Size = UDim2.new(0.5, -5, 1, 0)
openAllBtn.Position = UDim2.new(0, 0, 0, 0)
openAllBtn.BackgroundColor3 = Color3.fromRGB(30, 45, 35)
openAllBtn.Text = "Open All"
openAllBtn.Font = Enum.Font.GothamBold
openAllBtn.TextSize = 11
openAllBtn.TextColor3 = Color3.fromRGB(100, 220, 120)
openAllBtn.ZIndex = 9
openAllBtn.Parent = controlContainer
roundCorners(openAllBtn, 6)

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(50, 120, 70)
openStroke.Thickness = 1
openStroke.Parent = openAllBtn

local closeAllBtn = Instance.new("TextButton")
closeAllBtn.Size = UDim2.new(0.5, -5, 1, 0)
closeAllBtn.Position = UDim2.new(0.5, 5, 0, 0)
closeAllBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 25)
closeAllBtn.Text = "Close All"
closeAllBtn.Font = Enum.Font.GothamBold
closeAllBtn.TextSize = 11
closeAllBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeAllBtn.ZIndex = 9
closeAllBtn.Parent = controlContainer
roundCorners(closeAllBtn, 6)

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(150, 50, 50)
closeStroke.Thickness = 1
closeStroke.Parent = closeAllBtn

_G.toggleRegistry = _G.toggleRegistry or {}

openAllBtn.MouseButton1Click:Connect(function()
	showNotification("System", "Tüm modüller aktif ediliyor...", true)
	for name, setToggle in pairs(_G.toggleRegistry) do
		pcall(function() setToggle(true, true) end)
	end
end)

closeAllBtn.MouseButton1Click:Connect(function()
	showNotification("System", "Tüm modüller kapatılıyor...", false)
	for name, setToggle in pairs(_G.toggleRegistry) do
		pcall(function() setToggle(false, true) end)
	end
end)

-- YOUTUBE BUTONU
local ytBtn = Instance.new("TextButton")
ytBtn.Size = UDim2.new(1, -20, 0, 35)
ytBtn.Position = UDim2.new(0, 10, 1, -45)
ytBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
ytBtn.Text = "❤️ YouTube"
ytBtn.Font = Enum.Font.GothamBold
ytBtn.TextSize = 12
ytBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
ytBtn.ZIndex = 8
ytBtn.Parent = sidebar
roundCorners(ytBtn, 8)

local ytStroke = Instance.new("UIStroke")
ytStroke.Color = Color3.fromRGB(200, 50, 50)
ytStroke.Thickness = 1
ytStroke.Parent = ytBtn

ytBtn.MouseButton1Click:Connect(function()
	local myYoutubeLink = "https://www.youtube.com/@xAworth" 
	if setclipboard then
		setclipboard(myYoutubeLink)
		showNotification("YouTube", "Kanal linki panoya kopyalandı!", true)
	else
		showNotification("YouTube", "Link: worthnet.youtube", true)
	end
end)

-- SAĞ İÇERİK ALANI
local contentArea = Instance.new("ScrollingFrame")
contentArea.Size = UDim2.new(1, -180, 1, -60)
contentArea.Position = UDim2.new(0, 170, 0, 50)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
contentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentArea.ScrollBarThickness = 4
contentArea.ScrollBarImageColor3 = THEME.Accent
contentArea.ZIndex = 6
contentArea.Parent = hubFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = contentArea

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local searchText = string.lower(searchBox.Text)
	for _, card in ipairs(contentArea:GetChildren()) do
		if card:IsA("Frame") then
			local titleLabel = card:FindFirstChild("HackyTitle")
			if titleLabel then
				local name = string.lower(titleLabel.Text)
				if string.find(name, searchText) then
					card.Visible = true
				else
					card.Visible = false
				end
			end
		end
	end
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
closeBtn.Text = "X"
closeBtn.TextColor3 = THEME.TextDark
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.ZIndex = 7
closeBtn.Parent = hubFrame
roundCorners(closeBtn, 6)

closeBtn.MouseButton1Click:Connect(function()
	hubFrame.Visible = false
	minLogo.Visible = true
end)

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -75, 0, 10)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = THEME.TextDark
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 14
minimizeBtn.ZIndex = 7
minimizeBtn.Parent = hubFrame
roundCorners(minimizeBtn, 6)

minimizeBtn.MouseButton1Click:Connect(function()
	hubFrame.Visible = false
	minLogo.Visible = true
end)

local function createModernToggle(name, description, callback)
	local cardFrame = Instance.new("Frame")
	cardFrame.Size = UDim2.new(1, -10, 0, 55)
	cardFrame.BackgroundColor3 = THEME.Card
	cardFrame.BorderSizePixel = 0
	cardFrame.ZIndex = 7
	cardFrame.Parent = contentArea
	roundCorners(cardFrame, 8)
	
	local title = Instance.new("TextLabel")
	title.Name = "HackyTitle"
	title.Size = UDim2.new(0, 200, 0, 25)
	title.Position = UDim2.new(0, 15, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = THEME.TextMain
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.ZIndex = 8
	title.Parent = cardFrame
	
	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(0, 250, 0, 20)
	desc.Position = UDim2.new(0, 15, 0, 26)
	desc.BackgroundTransparency = 1
	desc.Text = description
	desc.TextColor3 = THEME.TextDark
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 11
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.ZIndex = 8
	desc.Parent = cardFrame
	
	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 45, 0, 22)
	switch.Position = UDim2.new(1, -60, 0.5, -11)
	switch.BackgroundColor3 = THEME.ToggleOff
	switch.Text = ""
	switch.ZIndex = 8
	switch.Parent = cardFrame
	roundCorners(switch, 11)
	
	local pin = Instance.new("Frame")
	pin.Size = UDim2.new(0, 16, 0, 16)
	pin.Position = UDim2.new(0, 3, 0.5, -8)
	pin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pin.ZIndex = 9
	pin.Parent = switch
	roundCorners(pin, 8)
	
	local isOn = false
	
	local function updateState(targetState, suppressNotification)
		if isOn == targetState then return end
		isOn = targetState
		
		local targetPos = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		local targetColor = isOn and THEME.ToggleOn or THEME.ToggleOff
		
		TweenService:Create(pin, TweenInfo.new(0.18), {Position = targetPos}):Play()
		TweenService:Create(switch, TweenInfo.new(0.18), {BackgroundColor3 = targetColor}):Play()
		
		if not suppressNotification then
			if isOn then
				showNotification(name, "Aktif edildi!", true)
			else
				showNotification(name, "Devre dışı bırakıldı.", false)
			end
		end
		
		pcall(function()
			callback(isOn)
		end)
	end
	
	switch.MouseButton1Click:Connect(function()
		updateState(not isOn)
	end)
	
	_G.toggleRegistry[name] = updateState
end

---------------------------------------------------------
-- HİLELER (GÜVENLİ VE HATASIZ LİSTE)
---------------------------------------------------------

-- 1. NOCLIP
local noclipConnection = nil  
createModernToggle("Noclip", "Duvarların içinden geçmenizi sağlar.", function(state)
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			if player.Character then
				for _, part in ipairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
				end
			end
		end)
	else
		if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
	end
end)

-- 2. FLY CONTROL
local flyingEnabled = false
local flySpeed = 60
local bv, bg

local function updateFlyState(state)
    flyingEnabled = state
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")

    if flyingEnabled and root and hum then
        hum.PlatformStand = true
        
        bv = Instance.new("BodyVelocity")
        bv.Name = "WorthNetVelocity"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = root
        
        bg = Instance.new("BodyGyro")
        bg.Name = "WorthNetGyro"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bg.P = 10000
        bg.D = 100
        bg.CFrame = root.CFrame
        bg.Parent = root

        task.spawn(function()
            local currentVelocity = Vector3.new(0, 0, 0)
            while flyingEnabled and root and root.Parent do
                local camera = workspace.CurrentCamera
                local targetDir = Vector3.new(0, 0, 0)

                if UserInputService:IsKeyDown(Enum.KeyCode.W) then targetDir = targetDir + camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then targetDir = targetDir - camera.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then targetDir = targetDir - camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then targetDir = targetDir + camera.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then targetDir = targetDir + Vector3.new(0, 1, 0) end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then targetDir = targetDir - Vector3.new(0, 1, 0) end

                currentVelocity = currentVelocity:Lerp(targetDir * flySpeed, 0.1)
                bv.Velocity = currentVelocity
                bg.CFrame = camera.CFrame
                task.wait()
            end
        end)
    else
        if hum then hum.PlatformStand = false end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

createModernToggle("Fly", "İstediğin yere uç! (P Tuşu ile aç/kapat)", function(state)
    updateFlyState(state)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
        updateFlyState(not flyingEnabled)
    end
end)

-- 3. INVISIBLE
createModernToggle("Invisible", "Karakterini görünmez yap.", function(state)
    local char = player.Character
    if not char then return end

    for _, obj in pairs(char:GetDescendants()) do
        if obj:IsA("BasePart") or obj:IsA("Decal") then
            obj.Transparency = state and 1 or 0
        end
        if obj:IsA("Accessory") then
            for _, child in pairs(obj:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Transparency = state and 1 or 0
                end
            end
        end
    end
    showNotification("Invisibility", state and "Görünmezlik Aktif!" or "Görünmezlik Kapalı!", true)
end)

-- 4. AIMBOT
local aimbotEnabled = false
local aimbotConnection = nil
local fovRadius = 200
local fovCircle

pcall(function()
    fovCircle = Drawing.new("Circle")
    fovCircle.Color = Color3.fromRGB(255, 255, 255)
    fovCircle.Thickness = 1
    fovCircle.Radius = fovRadius
    fovCircle.Filled = false
    fovCircle.Visible = false
end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled and fovCircle then
        local camera = workspace.CurrentCamera
        fovCircle.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
        fovCircle.Visible = true
    elseif fovCircle then
        fovCircle.Visible = false
    end
end)

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = fovRadius
    local currentCamera = workspace.CurrentCamera
    local mouseLocation = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            if p.Team and p.Team == player.Team then continue end
            local hum = p.Character:FindFirstChild("Humanoid")
            if hum and hum.Health > 0 then
                local screenPos, onScreen = currentCamera:WorldToViewportPoint(p.Character.Head.Position)
                if onScreen then
                    local playerScreenPoint = Vector2.new(screenPos.X, screenPos.Y)
                    local screenDistance = (playerScreenPoint - mouseLocation).Magnitude
                    if screenDistance < shortestDistance then
                        shortestDistance = screenDistance
                        closestPlayer = p
                    end
                end
            end
        end
    end
    return closestPlayer
end

createModernToggle("Aimbot", "Sadece FOV çemberi içindeki rakiplere kilitlenir.", function(state)
    aimbotEnabled = state
    if aimbotEnabled then
        aimbotConnection = RunService.RenderStepped:Connect(function()
            local targetPlayer = getClosestPlayer()
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
                local head = targetPlayer.Character.Head
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, head.Position)
            end
        end)
    else
        if aimbotConnection then aimbotConnection:Disconnect() aimbotConnection = nil end
    end
end)

-- 5. AUTO COIN
local autoCoinEnabled = false
local collectedCount = 0

createModernToggle("Auto Coin", "Yer altından, hızlı ve güvenli coin toplar.", function(state)
    autoCoinEnabled = state
    if autoCoinEnabled then
        task.spawn(function()
            while autoCoinEnabled do
                if collectedCount >= 40 then
                    showNotification("Auto Coin", "40/40! 30sn bekleme...", false)
                    task.wait(30)
                    collectedCount = 0
                end

                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end

                    local coinFound = nil
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if obj:IsA("BasePart") and (string.find(obj.Name, "Coin") or string.find(obj.Name, "Gold")) then
                            coinFound = obj
                            break
                        end
                    end
                    
                    if coinFound then
                        hrp.CFrame = coinFound.CFrame + Vector3.new(0, -1, 0)
                        pcall(function()
                            firetouchinterest(hrp, coinFound, 0)
                            firetouchinterest(hrp, coinFound, 1)
                        end)
                        collectedCount = collectedCount + 1
                        task.wait(1.5)
                    end
                end
                task.wait(0.1)
            end
        end)
    end
end)

-- 6. NAME ESP
createModernToggle("Name ESP", "Düşmanları ve isimlerini parlatır.", function(state)
    _G.ESP = state
    task.spawn(function()
        while _G.ESP do
            task.wait(1)
            for _, p in pairs(Players:GetPlayers()) do
                if not _G.ESP then break end
                if p ~= player and p.Character then
                    local highlight = p.Character:FindFirstChild("ESP_Highlight") or Instance.new("Highlight", p.Character)
                    highlight.Name = "ESP_Highlight"
                    highlight.Enabled = _G.ESP
                    highlight.FillColor = Color3.fromRGB(255, 0, 0)
                end
            end
        end
    end)
end)

-- 7. ANTI-FLING
local antiFlingConn = nil
createModernToggle("Anti-Fling", "Sizi haritadan uçurmaya çalışanları engeller.", function(state)
	if state then
		antiFlingConn = RunService.Heartbeat:Connect(function()
			if player.Character then
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= player and p.Character then
						local enemyRoot = p.Character:FindFirstChild("HumanoidRootPart")
						if enemyRoot and (enemyRoot.AssemblyLinearVelocity.Magnitude > 75 or enemyRoot.AssemblyAngularVelocity.Magnitude > 75) then
							for _, part in ipairs(p.Character:GetDescendants()) do
								if part:IsA("BasePart") then
									part.CanCollide = false
								end
							end
						end
					end
				end
			end
		end)
	else
		if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
	end
end)

-- 8. MAP BYPASS
createModernToggle("Map Bypass", "Görünmez duvarları yok et.", function(state)
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            if (obj.Transparency == 1 and obj.CanCollide == true) or obj.Name:lower():find("barrier") or obj.Name:lower():find("wall") then
                obj.CanCollide = not state
            end
        end
    end
    showNotification("Map Bypass", state ? "Görünmez duvarlar kaldırıldı!" : "Kapatıldı.", state)
end)

-- 9. MM2 ESP
local mm2ESPActive = false
local mm2Highlights = {}
createModernToggle("MM2 ESP", "Murder Mystery 2 rollerini duvar arkasından gösterir.", function(state)
	mm2ESPActive = state
	if not mm2ESPActive then
		for _, hl in pairs(mm2Highlights) do if hl then hl:Destroy() end end
		table.clear(mm2Highlights)
	else
		task.spawn(function()
			while mm2ESPActive do
				task.wait(0.4)
				for _, p in ipairs(Players:GetPlayers()) do
					if not mm2ESPActive then break end
					if p ~= player and p.Character then
						local char = p.Character
						local back = p:FindFirstChild("Backpack")
						local isMurderer = (char:FindFirstChild("Knife") or (back and back:FindFirstChild("Knife")))
						local isSheriff = (char:FindFirstChild("Gun") or (back and back:FindFirstChild("Gun")))
						
						local color = isMurderer and Color3.fromRGB(255, 0, 0) or (isSheriff and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(0, 255, 0))
						
						if not mm2Highlights[p.Name] or mm2Highlights[p.Name].Parent ~= char then
							if mm2Highlights[p.Name] then mm2Highlights[p.Name]:Destroy() end
							local hl = Instance.new("Highlight", char)
							hl.FillTransparency = 0.5
							mm2Highlights[p.Name] = hl
						end
						mm2Highlights[p.Name].FillColor = color
					end
				end
			end
		end)
	end
end)

-- 10. SPEEDHACK
local speedHackActive = false
createModernToggle("SpeedHack", "Hızını 75 yapar ve sürekli günceller.", function(state)
    speedHackActive = state
    if speedHackActive then
        task.spawn(function()
            while speedHackActive do
                local char = player.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum and hum.WalkSpeed ~= 75 then
                    hum.WalkSpeed = 75
                end
                task.wait(1)
            end
        end)
    else
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then hum.WalkSpeed = 16 end
    end
end)

-- 11. INFINITE JUMP
local infJumpConn = nil
createModernToggle("Infinite Jump", "Sonsuz kez havada zıplamanızı sağlar.", function(state)
	if state then
		infJumpConn = UserInputService.JumpRequest:Connect(function()
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	else
		if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
	end
end)

-- 12. BHOP
local bhopConn = nil
createModernToggle("Bhop Control", "Zıplama tuşuna basılı tutarak seri bhop yaparsınız.", function(state)
	if state then
		bhopConn = RunService.RenderStepped:Connect(function()
			if player.Character and player.Character:FindFirstChild("Humanoid") then
				local hum = player.Character.Humanoid
				if hum.FloorMaterial ~= Enum.Material.Air and UserInputService:IsKeyDown(Enum.KeyCode.Space) then
					hum.Jump = true
				end
			end
		end)
	else
		if bhopConn then bhopConn:Disconnect() bhopConn = nil end
	end
end)

-- 13. FULLBRIGHT
local origAmbient, brightLoop = nil, nil
createModernToggle("FullBright", "Haritadaki tüm karanlık ve gölgeleri kaldırır.", function(state)
	if state then
		origAmbient = Lighting.Ambient
		brightLoop = RunService.RenderStepped:Connect(function()
			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
		end)
	else
		if brightLoop then brightLoop:Disconnect() brightLoop = nil end
		if origAmbient then Lighting.Ambient = origAmbient end
	end
end)

-- 14. NO FOG
local origFogEnd = nil
createModernToggle("No Fog", "Görüş mesafesini düşüren sisleri yok eder.", function(state)
	if state then
		origFogEnd = Lighting.FogEnd
		Lighting.FogEnd = 9e9
	else
		if origFogEnd then Lighting.FogEnd = origFogEnd end
	end
end)

-- 15. ANTI-VOID
local antiVoidConn = nil
createModernToggle("Anti-Void", "Boşluğa düşerek ölmeyi engeller.", function(state)
	if state then
		antiVoidConn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root and root.Position.Y < -50 then
				root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				root.CFrame = root.CFrame + Vector3.new(0, 80, 0)
			end
		end)
	else
		if antiVoidConn then antiVoidConn:Disconnect() antiVoidConn = nil end
	end
end)

-- 16. GOD MODE
local godEnabled = false
createModernToggle("God Mode", "Canını sürekli full'de tutar.", function(state)
    godEnabled = state
end)

RunService.Heartbeat:Connect(function()
    if godEnabled then
        local char = player.Character
        local hum = char and char:FindFirstChild("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end
end)

-- 17. CLICK TP
local mouse = player:GetMouse()
_G.ClickTP = false
createModernToggle("Click TP", "Tıkladığın yere ışınlar.", function(state)
    _G.ClickTP = state
end)

mouse.Button1Down:Connect(function()
    if _G.ClickTP and mouse.Hit then
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
        end
    end
end)

-- 18. ANTI-AFK
local afkConn = nil
createModernToggle("Anti-AFK", "Sunucudan atılmayı engeller.", function(state)
    if state then
        afkConn = player.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end)
    else
        if afkConn then afkConn:Disconnect() afkConn = nil end
    end
end)

-- 19. REJOIN
createModernToggle("Rejoin", "Aynı sunucuya tekrar bağlanır.", function(state)
    if state then
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end
end)

-- Bypass koruması güvenli moda alındı
pcall(function()
	local metatable = getrawmetatable(game)
	local namecall = metatable.__namecall
	setreadonly(metatable, false)
	metatable.__namecall = newcclosure(function(self, ...)
		if getnamecallmethod() == "FireServer" and tostring(self) == "WalkSpeedCheck" then return nil end
		return namecall(self, ...)
	end)
	setreadonly(metatable, true)
end)

showNotification("WorthNet", "Tüm sistemler başarıyla yüklendi!", true)
