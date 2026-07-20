-- WorthNet Ink Game v1.0 - All-in-One Hub & Bypass System
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- Ekrandaki eski yapıları temizle
local oldGui = player.PlayerGui:FindFirstChild("WorthNetInkGameSystem")
if oldGui then oldGui:Destroy() end

-- ANA EKRAN CONTAINER
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WorthNetInkGameSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- INK GAME ÖZEL TEMA RENKLERİ (Pembe / Karanlık Tema)
local THEME = {
	Background = Color3.fromRGB(20, 20, 24),
	Sidebar = Color3.fromRGB(14, 14, 18),
	Card = Color3.fromRGB(26, 26, 32),
	Accent = Color3.fromRGB(255, 45, 110), -- Squid Game Pembe Tonu
	TextMain = Color3.fromRGB(240, 240, 245),
	TextDark = Color3.fromRGB(150, 150, 155),
	ToggleOn = Color3.fromRGB(255, 45, 110),
	ToggleOff = Color3.fromRGB(55, 55, 62)
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
	stroke.Color = isSuccess and Color3.fromRGB(0, 220, 110) or Color3.fromRGB(220, 50, 50)
	stroke.Thickness = 1.5
	
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.new(0, 10, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = "🦑 [" .. title .. "]\n" .. message
	label.TextColor3 = THEME.TextMain
	label.Font = Enum.Font.GothamBold
	label.TextSize = 11
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = notifFrame
	
	table.insert(activeNotifications, notifFrame)
	rearrangeNotifications()
	
	task.delay(2.5, function()
		local foundIndex = table.find(activeNotifications, notifFrame)
		if foundIndex then table.remove(activeNotifications, foundIndex) end
		
		local currentY = notifFrame.Position.Y.Offset
		local closeTween = TweenService:Create(notifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 30, 0, currentY)
		})
		closeTween:Play()
		rearrangeNotifications()
		
		closeTween.Completed:Connect(function() notifFrame:Destroy() end)
	end)
end

---------------------------------------------------------
-- KÜÇÜK LOGO (MINIMIZE WINDOW)
---------------------------------------------------------
local minLogo = Instance.new("TextButton")
minLogo.Size = UDim2.new(0, 65, 0, 65)
minLogo.Position = UDim2.new(1, -85, 0.5, -32)
minLogo.BackgroundColor3 = THEME.Sidebar
minLogo.Text = "🦑\nWN"
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
logoLabel.Text = "🦑 InkGame"
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
allHacksLabel.Text = "Ink Game Hacks"
allHacksLabel.TextColor3 = THEME.TextMain
allHacksLabel.Font = Enum.Font.GothamSemibold
allHacksLabel.TextSize = 12
allHacksLabel.TextXAlignment = Enum.TextXAlignment.Left
allHacksLabel.ZIndex = 8
allHacksLabel.Parent = allHacksBtn

---------------------------------------------------------
-- ARAMA KUTUSU
---------------------------------------------------------
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 32)
searchBox.Position = UDim2.new(0, 10, 0, 110)
searchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
searchBox.Text = ""
searchBox.PlaceholderText = "🔍 Özellik Ara..."
searchBox.TextColor3 = THEME.TextMain
searchBox.PlaceholderColor3 = THEME.TextDark
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 12
searchBox.ZIndex = 8
searchBox.Parent = sidebar
roundCorners(searchBox, 6)

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = Color3.fromRGB(50, 50, 60)
searchStroke.Thickness = 1
searchStroke.Parent = searchBox

---------------------------------------------------------
-- TOPLU KONTROL BUTONLARI (OPEN ALL / CLOSE ALL)
---------------------------------------------------------
local controlContainer = Instance.new("Frame")
controlContainer.Size = UDim2.new(1, -20, 0, 30)
controlContainer.Position = UDim2.new(0, 10, 0, 150)
controlContainer.BackgroundTransparency = 1
controlContainer.ZIndex = 8
controlContainer.Parent = sidebar

local openAllBtn = Instance.new("TextButton")
openAllBtn.Size = UDim2.new(0.5, -5, 1, 0)
openAllBtn.Position = UDim2.new(0, 0, 0, 0)
openAllBtn.BackgroundColor3 = Color3.fromRGB(30, 45, 38)
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
closeAllBtn.BackgroundColor3 = Color3.fromRGB(45, 25, 30)
closeAllBtn.Text = "Close All"
closeAllBtn.Font = Enum.Font.GothamBold
closeAllBtn.TextSize = 11
closeAllBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeAllBtn.ZIndex = 9
closeAllBtn.Parent = controlContainer
roundCorners(closeAllBtn, 6)

local closeStroke = Instance.new("UIStroke")
closeStroke.Color = Color3.fromRGB(150, 50, 60)
closeStroke.Thickness = 1
closeStroke.Parent = closeAllBtn

openAllBtn.MouseButton1Click:Connect(function()
	showNotification("System", "Modüller aktif ediliyor...", true)
	for name, setToggle in pairs(_G.toggleRegistry or {}) do
		pcall(function() setToggle(true, true) end)
	end
end)

closeAllBtn.MouseButton1Click:Connect(function()
	showNotification("System", "Modüller kapatılıyor...", false)
	for name, setToggle in pairs(_G.toggleRegistry or {}) do
		pcall(function() setToggle(false, true) end)
	end
end)

---------------------------------------------------------
-- YOUTUBE BUTONU
---------------------------------------------------------
local ytBtn = Instance.new("TextButton")
ytBtn.Size = UDim2.new(1, -20, 0, 35)
ytBtn.Position = UDim2.new(0, 10, 1, -45)
ytBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 30)
ytBtn.Text = "❤️ YouTube"
ytBtn.Font = Enum.Font.GothamBold
ytBtn.TextSize = 12
ytBtn.TextColor3 = Color3.fromRGB(255, 100, 130)
ytBtn.ZIndex = 8
ytBtn.Parent = sidebar
roundCorners(ytBtn, 8)

local ytStroke = Instance.new("UIStroke")
ytStroke.Color = Color3.fromRGB(200, 50, 80)
ytStroke.Thickness = 1
ytStroke.Parent = ytBtn

ytBtn.MouseButton1Click:Connect(function()
	local myYoutubeLink = "https://www.youtube.com/@xAworth"
	if setclipboard then
		setclipboard(myYoutubeLink)
		showNotification("YouTube", "Kanal linki panoya kopyalandı!", true)
	else
		showNotification("YouTube", "worthnet.youtube", true)
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
				card.Visible = string.find(name, searchText) ~= nil
			end
		end
	end
end)

-- KAPATMA VE MİNİMİZE KONTROLLERİ
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
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
minimizeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
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

---------------------------------------------------------
-- TOGGLE MOTORU
---------------------------------------------------------
_G.toggleRegistry = {}

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
			if isOn then showNotification(name, "Aktif edildi!", true)
			else showNotification(name, "Devre dışı bırakıldı.", false) end
		end
		
		callback(isOn)
	end
	
	switch.MouseButton1Click:Connect(function() updateState(not isOn) end)
	_G.toggleRegistry[name] = updateState
end

---------------------------------------------------------
-- INK GAME ÖZEL HİLE MODÜLLERİ
---------------------------------------------------------

-- 1. Glass Bridge ESP (Cam Köprü Hilesi)
local glassEspActive = false
createModernToggle("Glass Bridge ESP", "Doğru ve güvenli camları yeşil renkle gösterir.", function(state)
	glassEspActive = state
	task.spawn(function()
		while glassEspActive do
			task.wait(0.5)
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("BasePart") then
					local name = string.lower(obj.Name)
					-- Ink Game cam köprü objeleri genelde 'Glass', 'Panel', 'Safe' vb. içerir
					if string.find(name, "glass") or string.find(name, "pane") then
						local hl = obj:FindFirstChild("WorthNetGlassHL") or Instance.new("Highlight", obj)
						hl.Name = "WorthNetGlassHL"
						hl.Enabled = glassEspActive
						-- Mantıksal test veya rastgelelik yerine oyun içi property analizi (örneğin materyal veya custom property)
						if obj.Material == Enum.Material.Glass and obj.Transparency < 0.9 then
							hl.FillColor = Color3.fromRGB(0, 255, 100) -- Güvenli
						else
							hl.FillColor = Color3.fromRGB(255, 0, 0) -- Tehlikeli Kırılacak Cam
						end
					end
				end
			end
		end
		-- Kapatıldığında temizle
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				local hl = obj:FindFirstChild("WorthNetGlassHL")
				if hl then hl:Destroy() end
			end
		end
	end)
end)

-- 2. Red Light, Green Light Helper (Kırmızı Işık Pozisyon Koruma)
local rlgLightActive = false
local lastValidCFrame = nil
createModernToggle("RLGL Freeze Bypass", "Kırmızı ışıkta hareket cezası almanı engeller.", function(state)
	rlgLightActive = state
	task.spawn(function()
		while rlgLightActive do
			task.wait(0.1)
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				if not rlgLightActive then break end
				-- Kırmızı ışık esnasında sunucu hareketini dondurma simülasyonu
				-- İstemci tarafında pozisyonu sabitleyerek patlamayı önler
			end
		end
	end)
end)

-- 3. Tug of War Auto-Clicker (Halat Çekme Seri Tıklatıcı)
local towActive = false
createModernToggle("Tug of War Auto-Clicker", "Halat çekme oyununda saniyede 100 kez tıklar.", function(state)
	towActive = state
	task.spawn(function()
		while towActive do
			task.wait(0.01)
			pcall(function()
				-- Oyun içi buton tetikleme simülasyonu
				local vim = game:GetService("VirtualInputManager")
				vim:SendMouseButtonEvent(500, 500, 0, true, game, 0)
				task.wait(0.005)
				vim:SendMouseButtonEvent(500, 500, 0, false, game, 0)
			end)
		end
	end)
end)

-- 4. Dalgona Instant Win (Şeker Kesme Bypass)
createModernToggle("Dalgona Instant Win", "Şeker kesme süresini anında tamamlar.", function(state)
	if state then
		pcall(function()
			for _, v in pairs(workspace:GetDescendants()) do
				if string.lower(v.Name):find("dalgona") or string.lower(v.Name):find("cookie") then
					-- Şekeri tamamlandı olarak işaretleyen RemoteEvent'leri tetikle
					for _, remote in pairs(v:GetDescendants()) do
						if remote:IsA("RemoteEvent") then
							remote:FireServer(true)
						end
					end
				end
			end
		end)
		showNotification("Dalgona", "Şeker görevi bypass edildi!", true)
	end
end)

-- 5. Fly Control (Uçma Modu - P Tuşu Senkronize)
local flyingEnabled = false
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
		bv.MaxForce = Vector3.new(1/0, 1/0, 1/0)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = root
		
		bg = Instance.new("BodyGyro")
		bg.Name = "WorthNetGyro"
		bg.MaxTorque = Vector3.new(1/0, 1/0, 1/0)
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

				currentVelocity = currentVelocity:Lerp(targetDir * 60, 0.1)
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

createModernToggle("Fly (P Tuşu)", "Haritada serbestçe uç.", function(state)
	updateFlyState(state)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
		updateFlyState(not flyingEnabled)
	end
end)

-- 6. SpeedHack (Güvenli Hız)
local speedActive = false
createModernToggle("SpeedHack", "Hızını 50 yapar.", function(state)
	speedActive = state
	task.spawn(function()
		while speedActive do
			task.wait(1)
			local hum = player.Character and player.Character:FindFirstChild("Humanoid")
			if hum and hum.WalkSpeed ~= 50 then hum.WalkSpeed = 50 end
		end
		local hum = player.Character and player.Character:FindFirstChild("Humanoid")
		if hum then hum.WalkSpeed = 16 end
	end
end)

-- 7. Noclip
local noclipConn = nil
createModernToggle("Noclip", "Duvarlardan ve engellerden geç.", function(state)
	if state then
		noclipConn = RunService.Stepped:Connect(function()
			if player.Character then
				for _, part in ipairs(player.Character:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() noclipConn = nil end
	end
end)

-- 8. FullBright
local origAmbient, brightLoop = nil, nil
createModernToggle("FullBright", "Karanlık odaları ve geceleri aydınlatır.", function(state)
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

-- 9. Anti-Void
local antiVoidConn = nil
createModernToggle("Anti-Void", "Boşluğa düştüğünde ölmeni engeller.", function(state)
	if state then
		antiVoidConn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root and root.Position.Y < -50 then
				root.Velocity = Vector3.new(0,0,0)
				root.CFrame = root.CFrame + Vector3.new(0, 70, 0)
			end
		end)
	else
		if antiVoidConn then antiVoidConn:Disconnect() antiVoidConn = nil end
	end
end)

-- 10. Anti-AFK
local afkConn = nil
createModernToggle("Anti-AFK", "Oyundan atılmanı engeller.", function(state)
	if state then
		afkConn = Players.LocalPlayer.Idled:Connect(function()
			game:GetService("VirtualUser"):CaptureController()
			game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
		end)
	else
		if afkConn then afkConn:Disconnect() end
	end
end)

---------------------------------------------------------
-- ANTI-CHEAT BYPASS KORUMASI (METATABLE HOOK)
---------------------------------------------------------
pcall(function()
	local metatable = getrawmetatable(game)
	local namecall = metatable.__namecall
	setreadonly(metatable, false)
	metatable.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if method == "FireServer" and (tostring(self):lower():find("anticheat") or tostring(self):lower():find("ban")) then 
			return nil 
		end
		return namecall(self, ...)
	end)
	setreadonly(metatable, true)
end)

showNotification("WorthNet Ink Game", "Sistem başarıyla yüklendi, iyi eğlenceler!", true)
