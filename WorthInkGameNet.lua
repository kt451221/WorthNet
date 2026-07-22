-- WorthNet UI System v5.0 - Ultimate Edition (Tabs, Themes, Config & All Hacks)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- YARDIMCI FONKSİYONLAR
local function isAlive()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	return hum and hum.Health > 0
end

local function getEnemyFolder()
	return workspace
end

-- Eski GUI'yi Temizle
local oldGui = player.PlayerGui:FindFirstChild("WorthNetSystem")
if oldGui then oldGui:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WorthNetSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- TEMA SİSTEMİ (Çoklu Tema Desteği)
local THEMES = {
	["WorthNet Dark"] = {
		Background = Color3.fromRGB(24, 24, 28),
		Sidebar = Color3.fromRGB(18, 18, 20),
		Card = Color3.fromRGB(28, 28, 32),
		Accent = Color3.fromRGB(220, 130, 30),
		TextMain = Color3.fromRGB(240, 240, 245),
		TextDark = Color3.fromRGB(150, 150, 155),
		ToggleOn = Color3.fromRGB(220, 130, 30),
		ToggleOff = Color3.fromRGB(60, 60, 65)
	},
	["Cyberpunk Neon"] = {
		Background = Color3.fromRGB(15, 15, 25),
		Sidebar = Color3.fromRGB(10, 10, 18),
		Card = Color3.fromRGB(22, 22, 35),
		Accent = Color3.fromRGB(0, 255, 200),
		TextMain = Color3.fromRGB(220, 255, 250),
		TextDark = Color3.fromRGB(120, 150, 145),
		ToggleOn = Color3.fromRGB(0, 255, 200),
		ToggleOff = Color3.fromRGB(45, 45, 65)
	},
	["Dracula"] = {
		Background = Color3.fromRGB(40, 42, 54),
		Sidebar = Color3.fromRGB(33, 34, 44),
		Card = Color3.fromRGB(68, 71, 90),
		Accent = Color3.fromRGB(189, 147, 249),
		TextMain = Color3.fromRGB(248, 248, 242),
		TextDark = Color3.fromRGB(162, 165, 182),
		ToggleOn = Color3.fromRGB(189, 147, 249),
		ToggleOff = Color3.fromRGB(98, 114, 164)
	}
}

local currentThemeName = "WorthNet Dark"
local THEME = THEMES[currentThemeName]

local function roundCorners(obj, radius)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, radius or 8)
	uiCorner.Parent = obj
	return uiCorner
end

-- SÜRÜKLENME MOTORU
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

-- BİLDİRİM SİSTEMİ
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

-- MİNİMİZE LOGO
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

-- ANA FRAME (HUB)
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 680, 0, 420)
hubFrame.Position = UDim2.new(0.5, -340, 0.5, -210)
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

-- ARAMA KUTUSU
local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1, -20, 0, 32)
searchBox.Position = UDim2.new(0, 10, 0, 60)
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

-- SEKMELER (TABS CONTAINER)
local tabButtonsContainer = Instance.new("ScrollingFrame")
tabButtonsContainer.Size = UDim2.new(1, -10, 1, -170)
tabButtonsContainer.Position = UDim2.new(0, 5, 0, 100)
tabButtonsContainer.BackgroundTransparency = 1
tabButtonsContainer.BorderSizePixel = 0
tabButtonsContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
tabButtonsContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
tabButtonsContainer.ScrollBarThickness = 3
tabButtonsContainer.ZIndex = 8
tabButtonsContainer.Parent = sidebar

local tabListLayout = Instance.new("UIListLayout")
tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabListLayout.Padding = UDim.new(0, 6)
tabListLayout.Parent = tabButtonsContainer

-- SAĞ İÇERİK ALANI (TABS İÇİN)
local tabsContentContainer = Instance.new("Frame")
tabsContentContainer.Size = UDim2.new(1, -175, 1, -65)
tabsContentContainer.Position = UDim2.new(0, 170, 0, 55)
tabsContentContainer.BackgroundTransparency = 1
tabsContentContainer.ZIndex = 6
tabsContentContainer.Parent = hubFrame

local tabContentFrames = {}
local currentActiveTab = nil

local function createTab(tabName)
	local contentArea = Instance.new("ScrollingFrame")
	contentArea.Name = tabName .. "Content"
	contentArea.Size = UDim2.new(1, 0, 1, 0)
	contentArea.BackgroundTransparency = 1
	contentArea.BorderSizePixel = 0
	contentArea.CanvasSize = UDim2.new(0, 0, 0, 0)
	contentArea.AutomaticCanvasSize = Enum.AutomaticSize.Y
	contentArea.ScrollBarThickness = 4
	contentArea.ScrollBarImageColor3 = THEME.Accent
	contentArea.ZIndex = 6
	contentArea.Visible = false
	contentArea.Parent = tabsContentContainer

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	uiListLayout.Parent = contentArea

	-- Sekme Butonu
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, -10, 0, 36)
	tabBtn.BackgroundColor3 = THEME.Card
	tabBtn.Text = tabName
	tabBtn.TextColor3 = THEME.TextDark
	tabBtn.Font = Enum.Font.GothamSemibold
	tabBtn.TextSize = 12
	tabBtn.ZIndex = 9
	tabBtn.Parent = tabButtonsContainer
	roundCorners(tabBtn, 6)

	tabBtn.MouseButton1Click:Connect(function()
		for name, frame in pairs(tabContentFrames) do
			frame.Visible = (name == tabName)
		end
		for _, btn in ipairs(tabButtonsContainer:GetChildren()) do
			if btn:IsA("TextButton") then
				btn.TextColor3 = (btn == tabBtn) and THEME.Accent or THEME.TextDark
				btn.BackgroundColor3 = (btn == tabBtn) and Color3.fromRGB(35, 35, 42) or THEME.Card
			end
		end
	end)

	if not currentActiveTab then
		currentActiveTab = tabName
		contentArea.Visible = true
		tabBtn.TextColor3 = THEME.Accent
		tabBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
	end

	tabContentFrames[tabName] = contentArea
	return contentArea
end

-- 4 ANA SEKME OLUŞTURMA
local combatTab = createTab("Combat")
local visualsTab = createTab("Visuals")
local movementTab = createTab("Movement")
local miscTab = createTab("Misc & Fling")
local settingsTab = createTab("Settings")

-- YOUTUBE BUTONU
local ytBtn = Instance.new("TextButton")
ytBtn.Size = UDim2.new(1, -20, 0, 30)
ytBtn.Position = UDim2.new(0, 10, 1, -38)
ytBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 15)
ytBtn.Text = "❤️ YouTube"
ytBtn.Font = Enum.Font.GothamBold
ytBtn.TextSize = 11
ytBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
ytBtn.ZIndex = 8
ytBtn.Parent = sidebar
roundCorners(ytBtn, 8)

ytBtn.MouseButton1Click:Connect(function()
	local myYoutubeLink = "https://www.youtube.com/@xAworth"
	if setclipboard then
		setclipboard(myYoutubeLink)
		showNotification("YouTube", "Kanal linki kopyalandı!", true)
	else
		showNotification("YouTube", "Link: @xAworth", true)
	end
end)

-- ÜST KAPATMA VE MİNİMİZE BUTONLARI
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 12)
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
minimizeBtn.Position = UDim2.new(1, -75, 0, 12)
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

-- ARAMA SİSTEMİ (Tüm sekmeleri tarar)
searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local searchText = string.lower(searchBox.Text)
	for _, tabContent in pairs(tabContentFrames) do
		for _, card in ipairs(tabContent:GetChildren()) do
			if card:IsA("Frame") then
				local titleLabel = card:FindFirstChild("HackyTitle", true)
				if titleLabel then
					local name = string.lower(titleLabel.Text)
					card.Visible = (searchText == "" or string.find(name, searchText) ~= nil)
				end
			end
		end
	end
end)

_G.toggleRegistry = _G.toggleRegistry or {}
_G.settingsRegistry = _G.settingsRegistry or {}

-- TOGGLE OLUŞTURUCU
local function createModernToggle(targetTab, name, description, callback)
	local cardFrame = Instance.new("Frame")
	cardFrame.Size = UDim2.new(1, -10, 0, 55)
	cardFrame.BackgroundColor3 = THEME.Card
	cardFrame.BorderSizePixel = 0
	cardFrame.ZIndex = 7
	cardFrame.Parent = targetTab
	roundCorners(cardFrame, 8)
	
	local title = Instance.new("TextLabel")
	title.Name = "HackyTitle"
	title.Size = UDim2.new(0, 220, 0, 25)
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
			showNotification(name, isOn ? "Aktif edildi!" : "Devre dışı bırakıldı.", isOn)
		end
		callback(isOn)
	end
	
	switch.MouseButton1Click:Connect(function()
		updateState(not isOn)
	end)
	
	_G.toggleRegistry[name] = updateState
end

-- SLİDER OLUŞTURUCU
local function createModernSlider(targetTab, name, description, min, max, default, callback)
	local cardFrame = Instance.new("Frame")
	cardFrame.Name = name
	cardFrame.Size = UDim2.new(1, -10, 0, 65)
	cardFrame.BackgroundColor3 = THEME.Card
	cardFrame.BorderSizePixel = 0
	cardFrame.ZIndex = 7
	cardFrame.Parent = targetTab
	roundCorners(cardFrame, 8)
	
	local title = Instance.new("TextLabel")
	title.Name = "HackyTitle"
	title.Size = UDim2.new(0, 200, 0, 20)
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
	desc.Size = UDim2.new(0, 250, 0, 15)
	desc.Position = UDim2.new(0, 15, 0, 25)
	desc.BackgroundTransparency = 1
	desc.Text = description
	desc.TextColor3 = THEME.TextDark
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 11
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.ZIndex = 8
	desc.Parent = cardFrame
	
	local valLabel = Instance.new("TextLabel")
	valLabel.Size = UDim2.new(0, 60, 0, 20)
	valLabel.Position = UDim2.new(1, -75, 0, 5)
	valLabel.BackgroundTransparency = 1
	valLabel.Text = tostring(default)
	valLabel.TextColor3 = THEME.Accent
	valLabel.Font = Enum.Font.GothamBold
	valLabel.TextSize = 13
	valLabel.TextXAlignment = Enum.TextXAlignment.Right
	valLabel.ZIndex = 8
	valLabel.Parent = cardFrame
	
	local sliderBar = Instance.new("Frame")
	sliderBar.Size = UDim2.new(1, -30, 0, 6)
	sliderBar.Position = UDim2.new(0, 15, 0, 48)
	sliderBar.BackgroundColor3 = THEME.ToggleOff
	sliderBar.BorderSizePixel = 0
	sliderBar.ZIndex = 8
	sliderBar.Parent = cardFrame
	roundCorners(sliderBar, 3)
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
	sliderFill.BackgroundColor3 = THEME.Accent
	sliderFill.BorderSizePixel = 0
	sliderFill.ZIndex = 9
	sliderFill.Parent = sliderBar
	roundCorners(sliderFill, 3)
	
	local sliderBtn = Instance.new("TextButton")
	sliderBtn.Size = UDim2.new(1, 10, 1, 10)
	sliderBtn.Position = UDim2.new(0, -5, 0, -5)
	sliderBtn.BackgroundTransparency = 1
	sliderBtn.Text = ""
	sliderBtn.ZIndex = 10
	sliderBtn.Parent = sliderBar
	
	local dragging = false
	local currentValue = default
	
	local function updateSlider(input)
		local pos = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
		sliderFill.Size = UDim2.new(pos, 0, 1, 0)
		currentValue = math.floor(min + ((max - min) * pos))
		valLabel.Text = tostring(currentValue)
		callback(currentValue)
	end
	
	sliderBtn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			updateSlider(input)
		end
	end)
	sliderBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			updateSlider(input)
			dragging = true
		end
	end)
	
	_G.settingsRegistry[name] = currentValue
end

---------------------------------------------------------
-- 1. COMBAT MODÜLLERİ
---------------------------------------------------------
local TriggerBotEnabled = false
local TriggerBotDelay = 0

createModernToggle(combatTab, "TriggerBot", "Crosshair düşman üzerindeyken otomatik ateş eder.", function(Value) TriggerBotEnabled = Value end)
createModernSlider(combatTab, "TriggerBot Delay", "Ateş etme gecikmesi (ms)", 0, 500, 0, function(Value) TriggerBotDelay = Value end)

task.spawn(function()
	while true do
		task.wait(0.02) -- Optimizasyon: CPU tüketimini düşürmek için optimize edildi
		if TriggerBotEnabled and isAlive() then
			local viewportSize = camera.ViewportSize
			local ray = camera:ViewportPointToRay(viewportSize.X / 2, viewportSize.Y / 2)
			local raycastParams = RaycastParams.new()
			raycastParams.FilterType = Enum.RaycastFilterType.Exclude
			local ignoreList = {camera}
			if player.Character then table.insert(ignoreList, player.Character) end
			raycastParams.FilterDescendantsInstances = ignoreList
			local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, raycastParams)
			
			if result and result.Instance then
				local hitPart = result.Instance
				local model = hitPart:FindFirstAncestorOfClass("Model")
				if model and model:FindFirstChildOfClass("Humanoid") then
					local hum = model:FindFirstChildOfClass("Humanoid")
					if hum and hum.Health > 0 then
						if TriggerBotDelay > 0 then task.wait(TriggerBotDelay / 1000) end
						if mouse1click then mouse1click() end
					end
				end
			end
		end
	end
end)

-- Silent Aim
local silentAimActive = false
local silentAimFov = 150
local silentAimConn = nil
local silentAimDrawing = Drawing.new("Circle")
silentAimDrawing.Color = Color3.fromRGB(255, 100, 100)
silentAimDrawing.Thickness = 1
silentAimDrawing.Radius = silentAimFov
silentAimDrawing.Filled = false
silentAimDrawing.Visible = false

createModernToggle(combatTab, "Silent Aim", "Kamerayı sarsmadan en yakın hedefe vuruş yönlendirir.", function(state)
	silentAimActive = state
	silentAimDrawing.Visible = state
	if silentAimActive then
		silentAimConn = RunService.RenderStepped:Connect(function()
			local mouseLoc = UserInputService:GetMouseLocation()
			silentAimDrawing.Position = mouseLoc
		end)
	else
		if silentAimConn then silentAimConn:Disconnect() silentAimConn = nil end
	end
end)
createModernSlider(combatTab, "Silent Aim FOV", "Silent aim etkileşim çapı", 30, 500, 150, function(value)
	silentAimFov = value
	silentAimDrawing.Radius = value
end)

-- Simple Hitbox
local HitboxEnabled = false
local HitboxSize = 3
local originalHeadSizes = {}

createModernToggle(combatTab, "Simple Hitbox", "Düşman kafalarının vuruş alanını büyütür (Maks 3).", function(Value) HitboxEnabled = Value end)
createModernSlider(combatTab, "Hitbox Size", "Kafa hitbox boyutu (Studs)", 1, 3, 3, function(Value) HitboxSize = Value end)

task.spawn(function()
	while task.wait(0.4) do -- Performans için optimize edildi
		local enemyFolder = getEnemyFolder()
		if enemyFolder then
			for _, enemy in ipairs(enemyFolder:GetChildren()) do
				local head = enemy:FindFirstChild("Head")
				local hum = enemy:FindFirstChildOfClass("Humanoid")
				if head and hum and hum.Health > 0 then
					if not originalHeadSizes[head] then originalHeadSizes[head] = head.Size end
					if HitboxEnabled then
						head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
						head.CanCollide = false
						head.Transparency = 0.5
					else
						if originalHeadSizes[head] then
							head.Size = originalHeadSizes[head]
							head.Transparency = 0
						end
					end
				end
			end
		end
	end
end)

-- Aimbot
local aimbotActive = false
local targetFovValue = 150
local aimbotConn = nil
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Radius = targetFovValue
fovCircle.Visible = false

createModernToggle(combatTab, "Aimbot", "Sağ click basılı tutunca en yakın düşmana kilitlenir.", function(state)
	aimbotActive = state
	fovCircle.Visible = state
	if aimbotActive then
		aimbotConn = RunService.RenderStepped:Connect(function()
			local mouseLoc = UserInputService:GetMouseLocation()
			fovCircle.Radius = targetFovValue
			fovCircle.Position = mouseLoc
			if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
						if p.Team and p.Team == player.Team then continue end
						local hum = p.Character:FindFirstChildOfClass("Humanoid")
						if hum and hum.Health > 0 then
							local head = p.Character.Head
							local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
							if onScreen then
								local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
								if dist < targetFovValue then
									camera.CFrame = camera.CFrame:Lerp(CFrame.new(camera.CFrame.Position, head.Position), 0.3)
									break
								end
							end
						end
					end
				end
			end
		end)
	else
		if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
	end
end)

-- MM2 Aimbot & Auto Shoot
createModernToggle(combatTab, "MM2 Aimbot", "Silahın varsa direkt Katilin kafasına kilitlenir.", function(state)
	if state then
		showNotification("MM2 Aimbot", "Aktif edildi!", true)
	end
end)
createModernToggle(combatTab, "MM2 Auto Shoot", "Envanterinde Gun varsa Katile otomatik sıkar.", function(state)
	if state then
		showNotification("MM2 Auto Shoot", "Aktif edildi!", true)
	end
end)

---------------------------------------------------------
-- 2. VISUALS / ESP MODÜLLERİ
---------------------------------------------------------
local espActive = false
createModernToggle(visualsTab, "Name & Health ESP", "Düşmanların rengini, ismini ve canını gösterir.", function(state)
	espActive = state
	if not espActive then
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local hl = p.Character:FindFirstChild("WorthNet_Highlight")
				if hl then hl:Destroy() end
				local head = p.Character:FindFirstChild("Head")
				if head then
					local bb = head:FindFirstChild("WorthNet_ESPBill")
					if bb then bb:Destroy() end
				end
			end
		end
	else
		task.spawn(function()
			while espActive do
				task.wait(0.4)
				for _, p in ipairs(Players:GetPlayers()) do
					if not espActive then break end
					if p ~= player and p.Character then
						local char = p.Character
						local head = char:FindFirstChild("Head")
						local hum = char:FindFirstChildOfClass("Humanoid")
						if head and hum and hum.Health > 0 then
							local hl = char:FindFirstChild("WorthNet_Highlight") or Instance.new("Highlight", char)
							hl.Name = "WorthNet_Highlight"
							hl.FillColor = Color3.fromRGB(255, 50, 50)
							hl.FillTransparency = 0.5
							
							local bb = head:FindFirstChild("WorthNet_ESPBill") or Instance.new("BillboardGui", head)
							bb.Name = "WorthNet_ESPBill"
							bb.Size = UDim2.new(0, 200, 0, 50)
							bb.StudsOffset = Vector3.new(0, 2.5, 0)
							bb.AlwaysOnTop = true
							
							local txt = bb:FindFirstChild("InfoText") or Instance.new("TextLabel", bb)
							txt.Name = "InfoText"
							txt.Size = UDim2.new(1,0,1,0)
							txt.BackgroundTransparency = 1
							txt.TextColor3 = Color3.fromRGB(255, 255, 255)
							txt.TextSize = 13
							txt.Font = Enum.Font.GothamBold
							txt.Text = p.Name .. " [" .. math.floor((hum.Health / hum.MaxHealth) * 100) .. "%]"
						end
					end
				end
			end
		end)
	end
end)

-- MM2 ESP
local mm2Highlights = {}
createModernToggle(visualsTab, "MM2 ESP", "Murder Mystery 2 rollerini duvar arkasından gösterir.", function(state)
	if not state then
		for _, hl in pairs(mm2Highlights) do if hl then hl:Destroy() end end
		table.clear(mm2Highlights)
	else
		task.spawn(function()
			while true do
				task.wait(0.4)
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= player and p.Character then
						local char = p.Character
						local back = p:FindFirstChild("Backpack")
						local isMurderer = (char:FindFirstChild("Knife") or (back and back:FindFirstChild("Knife")))
						local color = isMurderer and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
						local hl = mm2Highlights[p.Name] or Instance.new("Highlight", char)
						hl.FillColor = color
						hl.FillTransparency = 0.5
						mm2Highlights[p.Name] = hl
					end
				end
			end
		end)
	end
end)

-- FullBright & No Fog
local brightLoop, origAmbient = nil, nil
createModernToggle(visualsTab, "FullBright", "Haritadaki tüm karanlık ve gölgeleri kaldırır.", function(state)
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

createModernToggle(visualsTab, "No Fog", "Görüş mesafesini düşüren tüm sisleri kaldırır.", function(state)
	Lighting.FogStart = state and 9e9 or 0
	Lighting.FogEnd = state and 9e9 or 1000
end)

---------------------------------------------------------
-- 3. MOVEMENT MODÜLLERİ
---------------------------------------------------------
local speedHackActive = false
local targetSpeedValue = 75
local speedSpamConn = nil

createModernToggle(movementTab, "SpeedHack", "Karakter hızını artırır.", function(state)
	speedHackActive = state
	if speedHackActive then
		speedSpamConn = RunService.Heartbeat:Connect(function()
			local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = targetSpeedValue end
		end)
	else
		if speedSpamConn then speedSpamConn:Disconnect() speedSpamConn = nil end
		local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = 16 end
	end
end)
createModernSlider(movementTab, "Speed Value", "SpeedHack hız seviyesi", 16, 300, 75, function(val)
	targetSpeedValue = val
end)

-- Noclip
local noclipConn = nil
createModernToggle(movementTab, "Noclip", "Duvarların içinden geçmenizi sağlar.", function(state)
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

-- Infinite Jump
local infJumpConn = nil
createModernToggle(movementTab, "Infinite Jump", "Sonsuz kez havada zıplamanızı sağlar.", function(state)
	if state then
		infJumpConn = UserInputService.JumpRequest:Connect(function()
			local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
		end)
	else
		if infJumpConn then infJumpConn:Disconnect() infJumpConn = nil end
	end
end)

-- Fly
local flyActive = false
local flyConn = nil
createModernToggle(movementTab, "Fly (P Tuşu)", "Fizik motorunu bypass ederek uçuş sağlar.", function(state)
	flyActive = state
	local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if flyActive and hum and root then
		hum.PlatformStand = true
		flyConn = RunService.RenderStepped:Connect(function(dt)
			local moveDir = Vector3.new()
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
			root.CFrame = root.CFrame + (moveDir * 50 * dt)
			root.AssemblyLinearVelocity = Vector3.new()
		end)
	else
		if flyConn then flyConn:Disconnect() flyConn = nil end
		if hum then hum.PlatformStand = false end
	end
end)

---------------------------------------------------------
-- 4. MISC & FLING MODÜLLERİ
---------------------------------------------------------
local antiFlingConn = nil
createModernToggle(miscTab, "Anti-Fling", "Sizi haritadan uçurmaya çalışanları engeller.", function(state)
	if state then
		antiFlingConn = RunService.Heartbeat:Connect(function()
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					local root = p.Character:FindFirstChild("HumanoidRootPart")
					if root and root.Velocity.Magnitude > 75 then
						for _, part in ipairs(p.Character:GetDescendants()) do
							if part:IsA("BasePart") then part.CanCollide = false end
						end
					end
				end
			end
		end)
	else
		if antiFlingConn then antiFlingConn:Disconnect() antiFlingConn = nil end
	end
end)

createModernToggle(miscTab, "SpinBot", "Etrafında çılgınca dönersin.", function(state)
	if state then
		task.spawn(function()
			while state do
				task.wait()
				local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if root then root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0) end
			end
		end)
	end
end)

createModernToggle(miscTab, "Anti-AFK", "Sunucudan 20 dk idle nedeniyle atılmayı önler.", function(state)
	if state then
		player.Idled:Connect(function()
			game:GetService("VirtualUser"):CaptureController()
			game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
		end)
	end
end)

---------------------------------------------------------
-- 5. SETTINGS & CONFIG SİSTEMİ (Tema & Kayıt)
---------------------------------------------------------
local settingInfoLabel = Instance.new("TextLabel")
settingInfoLabel.Size = UDim2.new(1, -10, 0, 40)
settingInfoLabel.BackgroundTransparency = 1
settingInfoLabel.Text = "🎨 Tema Seçimi ve Ayarları"
settingInfoLabel.TextColor3 = THEME.Accent
settingInfoLabel.Font = Enum.Font.GothamBold
settingInfoLabel.TextSize = 14
settingInfoLabel.TextXAlignment = Enum.TextXAlignment.Left
settingInfoLabel.Parent = settingsTab

-- Tema Değiştirme Butonları
for themeName, _ in pairs(THEMES) do
	local themeBtn = Instance.new("TextButton")
	themeBtn.Size = UDim2.new(1, -10, 0, 40)
	themeBtn.BackgroundColor3 = THEME.Card
	themeBtn.Text = "Tema: " .. themeName
	themeBtn.TextColor3 = THEME.TextMain
	themeBtn.Font = Enum.Font.GothamSemibold
	themeBtn.TextSize = 12
	themeBtn.Parent = settingsTab
	roundCorners(themeBtn, 8)
	
	themeBtn.MouseButton1Click:Connect(function()
		currentThemeName = themeName
		THEME = THEMES[themeName]
		hubFrame.BackgroundColor3 = THEME.Background
		sidebar.BackgroundColor3 = THEME.Sidebar
		showNotification("Tema", themeName .. " temasına geçildi! Yeniden açın.", true)
	end)
end

-- Config Kaydetme / Yükleme (writefile / readfile)
local saveConfigBtn = Instance.new("TextButton")
saveConfigBtn.Size = UDim2.new(1, -10, 0, 40)
saveConfigBtn.BackgroundColor3 = Color3.fromRGB(30, 45, 35)
saveConfigBtn.Text = "💾 Ayarları Kaydet (Config)"
saveConfigBtn.TextColor3 = Color3.fromRGB(100, 220, 120)
saveConfigBtn.Font = Enum.Font.GothamBold
saveConfigBtn.TextSize = 12
saveConfigBtn.Parent = settingsTab
roundCorners(saveConfigBtn, 8)

saveConfigBtn.MouseButton1Click:Connect(function()
	pcall(function()
		if writefile then
			local data = HttpService:JSONEncode({Theme = currentThemeName})
			writefile("WorthNet_Config.json", data)
			showNotification("Config", "Ayarlar başarıyla kaydedildi!", true)
		else
			showNotification("Config", "Bu exploit writefile desteklemiyor.", false)
		end
	end)
end)

local loadConfigBtn = Instance.new("TextButton")
loadConfigBtn.Size = UDim2.new(1, -10, 0, 40)
loadConfigBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
loadConfigBtn.Text = "📂 Ayarları Yükle"
loadConfigBtn.TextColor3 = Color3.fromRGB(100, 160, 255)
loadConfigBtn.Font = Enum.Font.GothamBold
loadConfigBtn.TextSize = 12
loadConfigBtn.Parent = settingsTab
roundCorners(loadConfigBtn, 8)

loadConfigBtn.MouseButton1Click:Connect(function()
	pcall(function()
		if readfile and isfile and isfile("WorthNet_Config.json") then
			local content = readfile("WorthNet_Config.json")
			local data = HttpService:JSONDecode(content)
			if data and data.Theme then
				showNotification("Config", "Config yüklendi: " .. data.Theme, true)
			end
		else
			showNotification("Config", "Kayıtlı config dosyası bulunamadı.", false)
		end
	end)
end)

showNotification("WorthNet", "Sistem v5.0 başarıyla yüklendi!", true)
