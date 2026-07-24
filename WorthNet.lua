-- WorthNet UI System v4.4 - Glass Bridge, Tug of War & Adjustable SpeedHack (Fixed & Xeno Compatible)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local mouse = player:GetMouse()

-- YARDIMCI FONKSİYONLAR (TriggerBot & Hitbox İçin)
local function isAlive()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	return hum and hum.Health > 0
end

local function getEnemyFolder()
	return workspace
end

-- Ekrandaki eski yapıları temizle
local oldGui = player.PlayerGui:FindFirstChild("WorthNetSystem")
if oldGui then oldGui:Destroy() end

-- ANA EKRAN CONTAINER
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WorthNetSystem"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

local THEME = {
	Background = Color3.fromRGB(10, 8, 8),         -- Çok Koyu Kan Siyahı
	Sidebar    = Color3.fromRGB(16, 12, 12),       -- Yan Menü Arka Planı
	Card       = Color3.fromRGB(24, 18, 18),       -- Kart Arka Planı
	Accent     = Color3.fromRGB(239, 68, 68),     -- Parlak Kan Kırmızı Vurgu
	AccentGlow = Color3.fromRGB(248, 113, 113),   -- Neon / Parlak Açık Kırmızı
	TextMain   = Color3.fromRGB(255, 255, 255),   -- Saf Beyaz
	TextDark   = Color3.fromRGB(150, 135, 135),   -- Soluk Gri-Kırmızı
	ToggleOn   = Color3.fromRGB(239, 68, 68),     -- Açık Buton (Parlak Kırmızı)
	ToggleOff  = Color3.fromRGB(45, 30, 30)        -- Kapalı Buton (Koyu Bordo/Gri)
}


local function roundCorners(obj, radius)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, radius or 8)
	uiCorner.Parent = obj
	return uiCorner
end

---------------------------------------------------------
-- KUSURSUZ SÜRÜKLENME MOTORU (Son Sürüm)
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
				if input.UserInputState == Enum.UserInputState.End then 
					dragging = false 
				end
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

local searchStroke = Instance.new("UIStroke")
searchStroke.Color = Color3.fromRGB(50, 50, 55)
searchStroke.Thickness = 1
searchStroke.Parent = searchBox

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

---------------------------------------------------------
-- TAB (SEKME) YÖNETİM SİSTEMİ
---------------------------------------------------------
local activeTabs = {}
local tabButtons = {}

local sidebarTabContainer = Instance.new("ScrollingFrame")
sidebarTabContainer.Size = UDim2.new(1, -20, 1, -210)
sidebarTabContainer.Position = UDim2.new(0, 10, 0, 100)
sidebarTabContainer.BackgroundTransparency = 1
sidebarTabContainer.BorderSizePixel = 0
sidebarTabContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
sidebarTabContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
sidebarTabContainer.ScrollBarThickness = 2
sidebarTabContainer.Parent = sidebar

local sidebarLayout = Instance.new("UIListLayout")
sidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
sidebarLayout.Padding = UDim.new(0, 6)
sidebarLayout.Parent = sidebarTabContainer

local function createTab(tabName, iconSymbol)
	local tabBtn = Instance.new("TextButton")
	tabBtn.Size = UDim2.new(1, 0, 0, 36)
	tabBtn.BackgroundColor3 = THEME.Card
	tabBtn.Text = "  " .. (iconSymbol or "📌") .. "  " .. tabName
	tabBtn.TextColor3 = THEME.TextDark
	tabBtn.Font = Enum.Font.GothamBold
	tabBtn.TextSize = 12
	tabBtn.TextXAlignment = Enum.TextXAlignment.Left
	tabBtn.ZIndex = 8
	tabBtn.Parent = sidebarTabContainer
	roundCorners(tabBtn, 8)

	local tabFrame = Instance.new("ScrollingFrame")
	tabFrame.Size = UDim2.new(1, -180, 1, -60)
	tabFrame.Position = UDim2.new(0, 170, 0, 50)
	tabFrame.BackgroundTransparency = 1
	tabFrame.BorderSizePixel = 0
	tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	tabFrame.ScrollBarThickness = 4
	tabFrame.ScrollBarImageColor3 = THEME.Accent
	tabFrame.ZIndex = 6
	tabFrame.Visible = false
	tabFrame.Parent = hubFrame

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 10)
	uiListLayout.Parent = tabFrame

	table.insert(activeTabs, tabFrame)
	table.insert(tabButtons, tabBtn)

	tabBtn.MouseButton1Click:Connect(function()
		for _, frame in ipairs(activeTabs) do
			frame.Visible = false
		end
		for _, btn in ipairs(tabButtons) do
			btn.TextColor3 = THEME.TextDark
			btn.BackgroundColor3 = THEME.Card
		end
		
		tabFrame.Visible = true
		tabBtn.TextColor3 = THEME.TextMain
		tabBtn.BackgroundColor3 = THEME.Accent
	end)

	return tabFrame
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
	local searchText = string.lower(searchBox.Text)
	for _, tabFrame in ipairs(activeTabs) do
		for _, card in ipairs(tabFrame:GetChildren()) do
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

_G.toggleRegistry = _G.toggleRegistry or {}

local function createModernToggle(parentTab, name, description, callback)
	local cardFrame = Instance.new("Frame")
	cardFrame.Size = UDim2.new(1, -10, 0, 55)
	cardFrame.BackgroundColor3 = THEME.Card
	cardFrame.BorderSizePixel = 0
	cardFrame.ZIndex = 7
	cardFrame.Parent = parentTab
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
		
		callback(isOn)
	end
	
	switch.MouseButton1Click:Connect(function()
		updateState(not isOn)
	end)
	
	_G.toggleRegistry[name] = updateState
end

local function createModernSlider(parentTab, name, description, min, max, default, callback)
	local cardFrame = Instance.new("Frame")
	cardFrame.Name = name
	cardFrame.Size = UDim2.new(1, -10, 0, 65)
	cardFrame.BackgroundColor3 = THEME.Card
	cardFrame.BorderSizePixel = 0
	cardFrame.ZIndex = 7
	cardFrame.Parent = parentTab
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
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
		end
	end)
	
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
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
end

-- TAB'LARI OLUŞTURMA
local mainTab     = createTab("Main", "❖")
local combatTab   = createTab("Combat", "⚔")
local visualsTab  = createTab("Visuals", "◈")
local moveTab     = createTab("Movement", "⚡")
local mm2Tab      = createTab("MM2 Special", "🎯")
local settingsTab = createTab("Settings", "⚙")

if activeTabs[1] then
	activeTabs[1].Visible = true
	tabButtons[1].TextColor3 = THEME.TextMain
	tabButtons[1].BackgroundColor3 = THEME.Accent
end

---------------------------------------------------------
-- SETTINGS TAB (AYARLAR SEKME İÇERİĞİ)
---------------------------------------------------------
local toggleKey = Enum.KeyCode.RightShift
local isSettingKey = false

local keybindCard = Instance.new("Frame")
keybindCard.Size = UDim2.new(1, -10, 0, 52)
keybindCard.BackgroundColor3 = THEME.Card
keybindCard.BorderSizePixel = 0
keybindCard.ZIndex = 7
keybindCard.Parent = settingsTab
roundCorners(keybindCard, 6)

local kbTitle = Instance.new("TextLabel")
kbTitle.Size = UDim2.new(0, 200, 0, 22)
kbTitle.Position = UDim2.new(0, 12, 0, 5)
kbTitle.BackgroundTransparency = 1
kbTitle.Text = "Menu Keybind"
kbTitle.TextColor3 = THEME.TextMain
kbTitle.Font = Enum.Font.GothamBold
kbTitle.TextSize = 13
kbTitle.TextXAlignment = Enum.TextXAlignment.Left
kbTitle.Parent = keybindCard

local kbDesc = Instance.new("TextLabel")
kbDesc.Size = UDim2.new(0, 220, 0, 18)
kbDesc.Position = UDim2.new(0, 12, 0, 25)
kbDesc.BackgroundTransparency = 1
kbDesc.Text = "Menüyü açıp kapatacak kısayol tuşu."
kbDesc.TextColor3 = THEME.TextDark
kbDesc.Font = Enum.Font.Gotham
kbDesc.TextSize = 10
kbDesc.TextXAlignment = Enum.TextXAlignment.Left
kbDesc.Parent = keybindCard

local kbBtn = Instance.new("TextButton")
kbBtn.Size = UDim2.new(0, 90, 0, 26)
kbBtn.Position = UDim2.new(1, -102, 0.5, -13)
kbBtn.BackgroundColor3 = Color3.fromRGB(32, 36, 48)
kbBtn.Text = toggleKey.Name
kbBtn.TextColor3 = THEME.Accent
kbBtn.Font = Enum.Font.GothamBold
kbBtn.TextSize = 11
kbBtn.Parent = keybindCard
roundCorners(kbBtn, 6)

kbBtn.MouseButton1Click:Connect(function()
	isSettingKey = true
	kbBtn.Text = "Bas bekleniyor..."
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if isSettingKey and input.UserInputType == Enum.UserInputType.Keyboard then
		toggleKey = input.KeyCode
		kbBtn.Text = toggleKey.Name
		isSettingKey = false
		showNotification("Keybind", "Yeni tuş atandı: " .. toggleKey.Name, true)
	elseif not gameProcessed and input.KeyCode == toggleKey then
		hubFrame.Visible = not hubFrame.Visible
		minLogo.Visible = not hubFrame.Visible
	end
end)

createModernSlider(settingsTab, "UI Transparency", "Arayüz şeffaflığını ayarlar.", 0, 90, 0, function(val)
	local alpha = val / 100
	hubFrame.BackgroundTransparency = alpha
	sidebar.BackgroundTransparency = alpha
end)

createModernToggle(settingsTab, "Rejoin Server", "Bulunduğunuz sunucuya tekrar bağlanır.", function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
end)

createModernToggle(settingsTab, "Unload Script", "Tüm sistemleri durdurur ve UI'ı siler.", function()
	showNotification("System", "Script kaldırılıyor...", false)
	task.wait(0.5)
	screenGui:Destroy()
end)

---------------------------------------------------------
-- HİLE AKTİVASYON ALANI
---------------------------------------------------------
local antiFlingConn = nil
local mm2ESPActive = false
local mm2Highlights = {}
local infJumpConn = nil
local bhopConn = nil

-- TriggerBot
local TriggerBotEnabled = false
local TriggerBotDelay = 0

createModernToggle(combatTab, "TriggerBot", "Crosshair düşman üzerindeyken otomatik ateş eder.", function(Value)
	TriggerBotEnabled = Value
end)

createModernSlider(combatTab, "TriggerBot Delay", "Ateş etme gecikmesi (ms)", 0, 500, 0, function(Value)
	TriggerBotDelay = Value
end)

task.spawn(function()
	while true do
		task.wait(0.01)
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
					local enemyFolder = getEnemyFolder()
					if enemyFolder and (model.Parent == enemyFolder or enemyFolder == workspace) then
						local hum = model:FindFirstChildOfClass("Humanoid")
						if hum and hum.Health > 0 then
							if TriggerBotDelay > 0 then task.wait(TriggerBotDelay / 1000) end
							
							if mouse1click then 
								mouse1click() 
							elseif VirtualInputManager then 
								VirtualInputManager:SendMouseButtonEvent(viewportSize.X / 2, viewportSize.Y / 2, 0, true, game, 0)
								task.wait(0.01)
								VirtualInputManager:SendMouseButtonEvent(viewportSize.X / 2, viewportSize.Y / 2, 0, false, game, 0)
							end
							
							task.wait(0.02)
						end
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

local function getClosestSilentTarget()
	local closestTarget = nil
	local shortestDist = silentAimFov
	local camera = workspace.CurrentCamera
	local mouseLoc = UserInputService:GetMouseLocation()

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			if hum and hum.Health > 0 then
				if p.Team and p.Team == player.Team then continue end
				
				local head = p.Character.Head
				local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
				
				if onScreen then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
					if dist < shortestDist then
						shortestDist = dist
						closestTarget = head
					end
				end
			end
		end
	end
	return closestTarget
end

createModernToggle(combatTab, "Silent Aim", "Kamerayı sarsmadan en yakın hedefe vuruş yönlendirir.", function(state)
	silentAimActive = state
	silentAimDrawing.Visible = state
	
	if silentAimActive then
		silentAimConn = RunService.RenderStepped:Connect(function()
			local mouseLoc = UserInputService:GetMouseLocation()
			silentAimDrawing.Position = mouseLoc
			silentAimDrawing.Radius = silentAimFov
			
			local targetHead = getClosestSilentTarget()
			if targetHead then
				_G.WorthNetSilentTarget = targetHead
			else
				_G.WorthNetSilentTarget = nil
			end
		end)
	else
		silentAimDrawing.Visible = false
		if silentAimConn then
			silentAimConn:Disconnect()
			silentAimConn = nil
		end
		_G.WorthNetSilentTarget = nil
	end
end)

createModernSlider(combatTab, "Silent Aim FOV", "Silent aim etkileşim çapı", 30, 500, 150, function(value)
	silentAimFov = value
	silentAimDrawing.Radius = value
end)

-- Simple Hitbox (Fixli & Titremeyen Versiyon)
local HitboxEnabled = false
local HitboxSize = 3
local originalHeadSizes = {}
local hitboxConnection = nil

createModernToggle(combatTab, "Simple Hitbox", "Düşman kafalarının vuruş alanını büyütür (Maks 3).", function(Value)
    HitboxEnabled = Value
    
    -- Toggle kapatıldığında kafaları hemen eski haline döndür
    if not HitboxEnabled then
        for head, originalSize in pairs(originalHeadSizes) do
            if head and head.Parent then
                head.Size = originalSize
                head.Transparency = 0
            end
        end
        table.clear(originalHeadSizes)
    end
end)

createModernSlider(combatTab, "Hitbox Size", "Kafa hitbox boyutu (Studs)", 1, 5, 3, function(Value)
    HitboxSize = Value
end)

-- Yarım saniyelik yavaş döngü yerine hızlı ve kesintisiz RenderStepped kullanıyoruz
hitboxConnection = RunService.RenderStepped:Connect(function()
    if not HitboxEnabled then return end
    
    local enemyFolder = getEnemyFolder()
    if enemyFolder then
        for _, enemy in ipairs(enemyFolder:GetChildren()) do
            local head = enemy:FindFirstChild("Head")
            local hum = enemy:FindFirstChildOfClass("Humanoid")
            if head and hum and hum.Health > 0 then
                -- Orijinal boyutunu kaydet
                if not originalHeadSizes[head] then
                    originalHeadSizes[head] = head.Size
                end
                
                -- Boyutu sürekli büyük tut (oyun sıfırlasa bile anında tekrar büyütür)
                head.Size = Vector3.new(HitboxSize, HitboxSize, HitboxSize)
                head.CanCollide = false
                head.Transparency = 0.5
            end
        end
    end
end)

-- SpeedHack
local speedHackActive = false
local targetSpeedValue = 75
local speedSpamConn = nil

local function applySpeed(character, speed)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

createModernToggle(moveTab, "SpeedHack", "Karakterinizin yürüme hızını belirlediğiniz seviyede tutar.", function(state)
    speedHackActive = state
    if speedHackActive then
        applySpeed(player.Character, targetSpeedValue)
        speedSpamConn = RunService.RenderStepped:Connect(function()
            if speedHackActive and player.Character then
                applySpeed(player.Character, targetSpeedValue)
            end
        end)
    else
        if speedSpamConn then
            speedSpamConn:Disconnect()
            speedSpamConn = nil
        end
        applySpeed(player.Character, 16)
    end
end)

createModernSlider(moveTab, "Hız Seviyesi", "SpeedHack aktifken uygulanacak yürüme hızı.", 16, 300, 75, function(value)
    targetSpeedValue = value
    if speedHackActive then
        applySpeed(player.Character, targetSpeedValue)
    end
end)

-- Noclip
local noclipConnection = nil

createModernToggle(moveTab, "Noclip", "Duvarların içinden geçmenizi sağlar.", function(state)
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			local char = player.Character
			if char then
				local root = char:FindFirstChild("HumanoidRootPart")
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then 
						part.CanCollide = false 
					end
				end
				if root then
					local currentVel = root.AssemblyLinearVelocity
					if currentVel.Y < -5 then
						root.AssemblyLinearVelocity = Vector3.new(currentVel.X, 0, currentVel.Z)
					end
				end
			end
		end)
	else
		if noclipConnection then 
			noclipConnection:Disconnect() 
			noclipConnection = nil 
		end
		local char = player.Character
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then 
					part.CanCollide = true 
				end
			end
		end
	end
end)

-- Fly
local cframeFlyActive = false
local flySpeed = 35
local flyConnection

local function updateCFrameFly(state)
	cframeFlyActive = state
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")

	if cframeFlyActive and root and hum then
		hum.PlatformStand = true
		flyConnection = RunService.RenderStepped:Connect(function(dt)
			if not cframeFlyActive or not root or not root.Parent then
				if flyConnection then flyConnection:Disconnect() end
				return
			end
			
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
			
			local camera = workspace.CurrentCamera
			local moveDirection = Vector3.new(0, 0, 0)
			
			if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
			
			if moveDirection.Magnitude > 0 then
				moveDirection = moveDirection.Unit
			end
			
			root.CFrame = root.CFrame + (moveDirection * flySpeed * dt)
			root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
			root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		end)
	else
		if flyConnection then flyConnection:Disconnect() end
		if hum then hum.PlatformStand = false end
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then part.CanCollide = true end
			end
		end
	end
end

createModernToggle(moveTab, "Fly", "Fizik motorunu bypass eder, P tuşu ile açılır.", function(state)
	updateCFrameFly(state)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
		updateCFrameFly(not cframeFlyActive)
	end
end)

-- Fling Menüsü
local flingPlayerListGui = nil
local flingScrollingRef = nil
local flingPlayerConns = {}
local activeFlingConnection = nil
local currentlyFlingingTarget = nil

local function createFlingPlayerListWindow()
	if flingPlayerListGui then
		flingPlayerListGui.Enabled = true
		return
	end

	flingPlayerListGui = Instance.new("ScreenGui")
	flingPlayerListGui.Name = "WorthNetFlingPlayerListMenu"
	
	local success = pcall(function()
		flingPlayerListGui.Parent = game:GetService("CoreGui")
	end)
	if not success then
		flingPlayerListGui.Parent = player.PlayerGui
	end

	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 240, 0, 320)
	mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
	mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	mainFrame.BorderSizePixel = 0
	mainFrame.Active = true
	mainFrame.Draggable = true
	mainFrame.Parent = flingPlayerListGui

	local frameCorner = Instance.new("UICorner")
	frameCorner.CornerRadius = UDim.new(0, 10)
	frameCorner.Parent = mainFrame

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, 0, 0, 40)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = "Seçmeli Fling Menüsü"
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	titleLabel.TextSize = 13
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.Parent = mainFrame

	local scrollingFrame = Instance.new("ScrollingFrame")
	scrollingFrame.Size = UDim2.new(1, -16, 1, -50)
	scrollingFrame.Position = UDim2.new(0, 8, 0, 42)
	scrollingFrame.BackgroundTransparency = 1
	scrollingFrame.BorderSizePixel = 0
	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollingFrame.ScrollBarThickness = 4
	scrollingFrame.Parent = mainFrame
	flingScrollingRef = scrollingFrame

	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	uiListLayout.Padding = UDim.new(0, 6)
	uiListLayout.Parent = scrollingFrame

	local function refreshFlingList()
		if not flingScrollingRef then return end
		
		for _, child in ipairs(flingScrollingRef:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end

		for _, targetPlayer in ipairs(Players:GetPlayers()) do
			if targetPlayer ~= player then
				local itemRow = Instance.new("Frame")
				itemRow.Size = UDim2.new(1, 0, 0, 32)
				itemRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
				itemRow.BorderSizePixel = 0
				itemRow.Parent = flingScrollingRef

				local rowCorner = Instance.new("UICorner")
				rowCorner.CornerRadius = UDim.new(0, 6)
				rowCorner.Parent = itemRow

				local nameLabel = Instance.new("TextLabel")
				nameLabel.Size = UDim2.new(0.55, 0, 1, 0)
				nameLabel.Position = UDim2.new(0, 8, 0, 0)
				nameLabel.BackgroundTransparency = 1
				nameLabel.Text = targetPlayer.Name
				nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
				nameLabel.TextSize = 12
				nameLabel.Font = Enum.Font.GothamMedium
				nameLabel.TextXAlignment = Enum.TextXAlignment.Left
				nameLabel.Parent = itemRow

				local flingButton = Instance.new("TextButton")
				flingButton.Size = UDim2.new(0.38, 0, 0.75, 0)
				flingButton.Position = UDim2.new(0.60, 0, 0.125, 0)
				flingButton.BackgroundColor3 = (currentlyFlingingTarget == targetPlayer) and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75)
				flingButton.BorderSizePixel = 0
				flingButton.Text = (currentlyFlingingTarget == targetPlayer) and "Durdur" or "Fling"
				flingButton.TextColor3 = Color3.fromRGB(255, 255, 255)
				flingButton.TextSize = 11
				flingButton.Font = Enum.Font.GothamBold
				flingButton.Parent = itemRow

				local btnCorner = Instance.new("UICorner")
				btnCorner.CornerRadius = UDim.new(0, 5)
				btnCorner.Parent = flingButton

				flingButton.MouseButton1Click:Connect(function()
					if currentlyFlingingTarget == targetPlayer then
						if activeFlingConnection then
							activeFlingConnection:Disconnect()
							activeFlingConnection = nil
						end
						currentlyFlingingTarget = nil
						
						local char = player.Character
						local rootPart = char and char:FindFirstChild("HumanoidRootPart")
						if rootPart then
							rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
							rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
						end
						
						showNotification("Fling", targetPlayer.Name .. " serbest bırakıldı.", false)
						refreshFlingList()
					else
						if activeFlingConnection then
							activeFlingConnection:Disconnect()
							activeFlingConnection = nil
						end

						currentlyFlingingTarget = targetPlayer
						showNotification("Fling", targetPlayer.Name .. " hedeflendi ve fırlatılıyor!", true)
						refreshFlingList()

						activeFlingConnection = RunService.Heartbeat:Connect(function()
							local character = player.Character
							local rootPart = character and character:FindFirstChild("HumanoidRootPart")
							
							if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") and rootPart then
								local targetRoot = targetPlayer.Character.HumanoidRootPart
								rootPart.CFrame = targetRoot.CFrame
								rootPart.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
								rootPart.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
							else
								if activeFlingConnection then
									activeFlingConnection:Disconnect()
									activeFlingConnection = nil
								end
								currentlyFlingingTarget = nil
								if rootPart then
									rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
									rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
								end
								refreshFlingList()
							end
						end)
					end
				end)
			end
		end
	end

	refreshFlingList()

	table.insert(flingPlayerConns, Players.PlayerAdded:Connect(refreshFlingList))
	table.insert(flingPlayerConns, Players.PlayerRemoving:Connect(refreshFlingList))
end

local function hideFlingPlayerListWindow()
	if flingPlayerListGui then
		flingPlayerListGui.Enabled = false
	end
	
	if activeFlingConnection then
		activeFlingConnection:Disconnect()
		activeFlingConnection = nil
	end
	currentlyFlingingTarget = nil
	
	local char = player.Character
	local rootPart = char and char:FindFirstChild("HumanoidRootPart")
	if rootPart then
		rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
		rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
	end
end

createModernToggle(moveTab, "Fling Menüsü", "Oyuncu listesini açar, istediğini seçip fırlatırsın.", function(state)
	if state then
		createFlingPlayerListWindow()
	else
		hideFlingPlayerListWindow()
	end
end)


-- Player ESP
local espActive = false

createModernToggle(visualsTab, "Player ESP", "Düşmanların rengini, ismini ve canını gösterir.", function(state)
	espActive = state
	
	if espActive then
		task.spawn(function()
			while espActive do
				for _, p in ipairs(Players:GetPlayers()) do
					if not espActive then break end
					if p ~= player and p.Character then
						local char = p.Character
						local head = char:FindFirstChild("Head")
						local hum = char:FindFirstChild("Humanoid")
						
						if head and hum and hum.Health > 0 then
							local highlight = char:FindFirstChild("WorthNet_Highlight")
							if not highlight then
								highlight = Instance.new("Highlight")
								highlight.Name = "WorthNet_Highlight"
								highlight.Adornee = char
								highlight.Parent = char
							end
							highlight.Enabled = true
							highlight.FillColor = Color3.fromRGB(255, 50, 50)
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
							highlight.FillTransparency = 0.5
							
							local billboard = head:FindFirstChild("WorthNet_ESPBill")
							local textLabel
							
							if not billboard then
								billboard = Instance.new("BillboardGui")
								billboard.Name = "WorthNet_ESPBill"
								billboard.Size = UDim2.new(0, 200, 0, 50)
								billboard.StudsOffset = Vector3.new(0, 2.5, 0)
								billboard.AlwaysOnTop = true
								billboard.Parent = head
								
								textLabel = Instance.new("TextLabel")
								textLabel.Name = "InfoText"
								textLabel.Size = UDim2.new(1, 0, 1, 0)
								textLabel.BackgroundTransparency = 1
								textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
								textLabel.TextStrokeTransparency = 0
								textLabel.TextSize = 14
								textLabel.Font = Enum.Font.SourceSansBold
								textLabel.Parent = billboard
							else
								textLabel = billboard:FindFirstChild("InfoText")
							end
							
							if textLabel then
								local healthPercent = math.floor((hum.Health / hum.MaxHealth) * 100)
								textLabel.Text = p.Name .. " [" .. healthPercent .. "%]"
							end
						end
					end
				end
				task.wait(0.3)
			end
		end)
	else
		for _, p in ipairs(Players:GetPlayers()) do
			if p.Character then
				local highlight = p.Character:FindFirstChild("WorthNet_Highlight")
				if highlight then highlight:Destroy() end
				
				local head = p.Character:FindFirstChild("Head")
				if head then
					local billboard = head:FindFirstChild("WorthNet_ESPBill")
					if billboard then billboard:Destroy() end
				end
			end
		end
	end
end)

-- WorthNet Anti-Fling (Gelişmiş & Güncel Pro Versiyon)
local antiFlingConn = nil

createModernToggle(moveTab, "Anti-Fling ", "Seni uçurmaya çalışanların hızını ve çarpışmasını engeller.", function(state)
    if state then
        antiFlingConn = RunService.Heartbeat:Connect(function()
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            
            -- 1. Kendi karakterimizi ani dış fizik itmelerine karşı sabitle
            if root then
                -- Eğer normalin çok üstünde bir hızla fırlatılıyorsan hızını sıfırla
                if root.AssemblyLinearVelocity.Magnitude > 250 then
                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end
            
            -- 2. Yakındaki oyuncuları tara ve fling yapanların hızını kes
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local enemyRoot = p.Character:FindFirstChild("HumanoidRootPart")
                    if enemyRoot then
                        -- Güncel hız ve açısal hız (RotVelocity yerine AssemblyAngularVelocity)
                        local linearSpeed = enemyRoot.AssemblyLinearVelocity.Magnitude
                        local rotSpeed = enemyRoot.AssemblyAngularVelocity.Magnitude
                        
                        -- Eğer birisi fling yapmak için hızlanıyorsa
                        if linearSpeed > 75 or rotSpeed > 75 then
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
        showNotification("Anti-Fling", "Gelişmiş Anti-Fling aktif!", true)
    else
        if antiFlingConn then 
            antiFlingConn:Disconnect() 
            antiFlingConn = nil 
        end
        showNotification("Anti-Fling", "Durduruldu.", false)
    end
end)


-- WorthNet MM2 ESP (Tur Başlar Başlamaz / Anlık Yakalayan Versiyon)
local mm2Highlights = {}

createModernToggle(mm2Tab, "MM2 ESP (Fast)", "Roller dağıtıldığı an katil ve şerifi anında renklendirir.", function(state)
    mm2ESPActive = state
    if not mm2ESPActive then
        for _, hl in pairs(mm2Highlights) do if hl then hl:Destroy() end end
        table.clear(mm2Highlights)
    else
        task.spawn(function()
            while mm2ESPActive do
                task.wait(0.1) -- Tarama hızını artırdık (0.4'ten 0.1'e düşürdük ki anında yakalasın)
                for _, p in ipairs(Players:GetPlayers()) do
                    if not mm2ESPActive then break end
                    if p ~= player and p.Character then
                        local char = p.Character
                        local back = p:FindFirstChild("Backpack")
                        
                        -- Hem karakterin üstünde hem çantasında hem de elinde arama yapar
                        local isMurderer = (char:FindFirstChild("Knife") or (back and back:FindFirstChild("Knife")) or char:FindFirstChild("Revolver") and false) -- Bıçak kontrolü
                        
                        -- Alternatif olarak MM2'nin bazı sürümlerinde roller değer (Value) olarak tutulur:
                        local roleVal = p:FindFirstChild("Role") or (char:FindFirstChild("HumanoidRootPart") and p:FindFirstChild("Data"))
                        
                        -- Bıçak veya tabanca kontrolünü daha geniş tutuyoruz
                        local hasKnife = char:FindFirstChild("Knife") or (back and back:FindFirstChild("Knife"))
                        local hasGun = char:FindFirstChild("Gun") or (back and back:FindFirstChild("Gun"))
                        local droppedGun = workspace:FindFirstChild("GunDrop") -- Yere düşen şerif tabancası
                        
                        local color = hasKnife and Color3.fromRGB(255, 0, 0) or (hasGun and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(0, 255, 0))
                        
                        -- Eğer şerif öldüyse ve yerde tabancası duruyorsa şerif rengini nötr yapabiliriz
                        if not mm2Highlights[p.Name] or mm2Highlights[p.Name].Parent ~= char then
                            if mm2Highlights[p.Name] then mm2Highlights[p.Name]:Destroy() end
                            local hl = Instance.new("Highlight", char)
                            hl.FillTransparency = 0.5
                            hl.OutlineTransparency = 0
                            mm2Highlights[p.Name] = hl
                        end
                        mm2Highlights[p.Name].FillColor = color
                        mm2Highlights[p.Name].OutlineColor = color
                    end
                end
            end
        end)
    end
end)

-- Infinite Jump
createModernToggle(moveTab, "Infinite Jump", "Sonsuz kez havada zıplamanızı sağlar.", function(state)
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

-- FullBright
local origAmbient, origColorShift, brightLoop = nil, nil, nil
createModernToggle(visualsTab, "FullBright", "Haritadaki tüm karanlık ve gölgeleri kaldırıp aydınlatır.", function(state)
	if state then
		origAmbient = Lighting.Ambient
		origColorShift = Lighting.ColorShift_Top
		brightLoop = RunService.RenderStepped:Connect(function()
			Lighting.Ambient = Color3.fromRGB(255, 255, 255)
			Lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)
		end)
	else
		if brightLoop then brightLoop:Disconnect() brightLoop = nil end
		if origAmbient then Lighting.Ambient = origAmbient Lighting.ColorShift_Top = origColorShift end
	end
end)

-- No Fog
local origFogStart, origFogEnd = nil, nil
createModernToggle(visualsTab, "No Fog", "Görüş mesafesini düşüren tüm sis efektlerini yok eder.", function(state)
	if state then
		origFogStart = Lighting.FogStart
		origFogEnd = Lighting.FogEnd
		Lighting.FogStart = 9e9
		Lighting.FogEnd = 9e9
	else
		if origFogStart then Lighting.FogStart = origFogStart Lighting.FogEnd = origFogEnd end
	end
end)

-- Anti-Void
local antiVoidConn = nil
createModernToggle(mainTab, "Anti-Void", "Boşluğa düşerek ölmeyi engeller.", function(state)
	if state then
		antiVoidConn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root and root.Position.Y < -50 then
				root.Velocity = Vector3.new(0, 0, 0)
				root.CFrame = root.CFrame + Vector3.new(0, 80, 0)
			end
		end)
	else
		if antiVoidConn then antiVoidConn:Disconnect() antiVoidConn = nil end
	end
end)

-- SpinBot
local spinConn = nil
createModernToggle(moveTab, "SpinBot", "Etrafında çılgınca dönersin.", function(state)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if state and root then
        spinConn = RunService.RenderStepped:Connect(function()
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end)
    else
        if spinConn then spinConn:Disconnect() spinConn = nil end
    end
end)

-- Inventory ESP
local invESPActive = false
local invTags = {}

createModernToggle(visualsTab, "Inventory ESP", "Oyuncuların elindeki/sırtındaki itemleri listeler.", function(state)
    invESPActive = state
    if not invESPActive then
        for _, tag in pairs(invTags) do if tag then tag:Destroy() end end
        table.clear(invTags)
    else
        task.spawn(function()
            while invESPActive do
                task.wait(1)
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local items = {}
                        local tool = p.Character:FindFirstChildOfClass("Tool")
                        if tool then table.insert(items, tool.Name) end
                        
                        local back = p:FindFirstChild("Backpack")
                        if back then
                            for _, item in ipairs(back:GetChildren()) do
                                if item:IsA("Tool") then table.insert(items, item.Name) end
                            end
                        end
                        
                        local head = p.Character:FindFirstChild("Head")
                        if head then
                            if not invTags[p.Name] then
                                local bb = Instance.new("BillboardGui", head)
                                bb.Size = UDim2.new(0, 200, 0, 50)
                                bb.StudsOffset = Vector3.new(0, 3, 0)
                                local label = Instance.new("TextLabel", bb)
                                label.Size = UDim2.new(1,0,1,0)
                                label.BackgroundTransparency = 1
                                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                                label.TextScaled = true
                                invTags[p.Name] = label
                            end
                            invTags[p.Name].Text = table.concat(items, ", ")
                        end
                    end
                end
            end
        end)
    end
end)

-- TP Nearest
createModernToggle(moveTab, "TP Nearest", "En yakındaki oyuncunun yanına ışınlanırsın.", function(state)
    if state then
        local target = nil
        local dist = 100000
        
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if myRoot then
                    local d = (myRoot.Position - p.Character.HumanoidRootPart.Position).Magnitude
                    if d < dist then
                        dist = d
                        target = p.Character.HumanoidRootPart
                    end
                end
            end
        end
        
        if target then
            player.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 0, 2)
            showNotification("Teleport", "Oyuncuya ışınlanıldı!", true)
        else
            showNotification("Teleport", "Yakında oyuncu bulunamadı.", false)
        end
    end
end)

-- Oyuncu Listesi Penceresi (TP)
local playerListGui = nil
local scrollingFrameRef = nil
local playerConnections = {}

local function createPlayerListWindow()
    if playerListGui then
        playerListGui.Enabled = true
        return
    end

    playerListGui = Instance.new("ScreenGui")
    playerListGui.Name = "WorthNetPlayerListMenu"
    local success = pcall(function()
        playerListGui.Parent = game:GetService("CoreGui")
    end)
    if not success then
        playerListGui.Parent = player.PlayerGui
    end

    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 240, 0, 320)
    mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = playerListGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Oyuncu Işınlanma Menüsü"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame

    local scrollingFrame = Instance.new("ScrollingFrame")
    scrollingFrame.Size = UDim2.new(1, -16, 1, -50)
    scrollingFrame.Position = UDim2.new(0, 8, 0, 42)
    scrollingFrame.BackgroundTransparency = 1
    scrollingFrame.BorderSizePixel = 0
    scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollingFrame.ScrollBarThickness = 4
    scrollingFrame.Parent = mainFrame
    scrollingFrameRef = scrollingFrame

    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiListLayout.Padding = UDim.new(0, 6)
    uiListLayout.Parent = scrollingFrame

    local function refreshList()
        if not scrollingFrameRef then return end
        
        for _, child in ipairs(scrollingFrameRef:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                local itemRow = Instance.new("Frame")
                itemRow.Size = UDim2.new(1, 0, 0, 32)
                itemRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                itemRow.BorderSizePixel = 0
                itemRow.Parent = scrollingFrameRef

                local rowCorner = Instance.new("UICorner")
                rowCorner.CornerRadius = UDim.new(0, 6)
                rowCorner.Parent = itemRow

                local nameLabel = Instance.new("TextLabel")
                nameLabel.Size = UDim2.new(0.65, 0, 1, 0)
                nameLabel.Position = UDim2.new(0, 8, 0, 0)
                nameLabel.BackgroundTransparency = 1
                nameLabel.Text = targetPlayer.Name
                nameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
                nameLabel.TextSize = 12
                nameLabel.Font = Enum.Font.GothamMedium
                nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                nameLabel.Parent = itemRow

                local tpButton = Instance.new("TextButton")
                tpButton.Size = UDim2.new(0.28, 0, 0.75, 0)
                tpButton.Position = UDim2.new(0.70, 0, 0.125, 0)
                tpButton.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
                tpButton.BorderSizePixel = 0
                tpButton.Text = "TP"
                tpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                tpButton.TextSize = 12
                tpButton.Font = Enum.Font.GothamBold
                tpButton.Parent = itemRow

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 5)
                btnCorner.Parent = tpButton

                tpButton.MouseButton1Click:Connect(function()
                    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                        if myRoot then
                            myRoot.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
                        end
                    end
                end)
            end
        end
    end

    refreshList()

    table.insert(playerConnections, Players.PlayerAdded:Connect(refreshList))
    table.insert(playerConnections, Players.PlayerRemoving:Connect(refreshList))
end

local function hidePlayerListWindow()
    if playerListGui then
        playerListGui.Enabled = false
    end
end

createModernToggle(moveTab, "TP Player Menüsü", "Oyuncu listesi penceresini açar/kapatır.", function(state)
    if state then
        createPlayerListWindow()
    else
        hidePlayerListWindow()
    end
end)

-- Click TP (X Tuşu)
local clickTPXActive = false

createModernToggle(moveTab, "Click TP (X Tuşu)", "Fareyi nereye tutarsan X tuşuna basınca oraya ışınlanırsın.", function(state)
    clickTPXActive = state
    if state then
        showNotification("Click TP", "Aktif! Nişan al ve X tuşuna bas.", true)
    else
        showNotification("Click TP", "Kapatıldı.", false)
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and clickTPXActive and input.KeyCode == Enum.KeyCode.X then
        pcall(function()
            if mouse.Hit then
                local targetPos = mouse.Hit.p
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                
                if hrp then
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                    task.defer(function()
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end
        end)
    end
end)

-- Auto Follow / Lock
local followEnabled = false
createModernToggle(mainTab, "Auto Follow/Lock", "En yakın oyuncuyu takip eder.", function(state)
    followEnabled = state
end)

RunService.RenderStepped:Connect(function()
    if followEnabled then
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local closestPlayer = nil
            local shortestDist = math.huge
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local targetHrp = p.Character.HumanoidRootPart
                    local dist = (hrp.Position - targetHrp.Position).Magnitude
                    if dist < shortestDist then
                        shortestDist = dist
                        closestPlayer = p
                    end
                end
            end
            if closestPlayer and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
                hrp.CFrame = closestPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Anti-Ragdoll (Gelişmiş & Fizik Bağlantı Temizleyici)
local antiRagdollEnabled = false
local antiRagdollConnection = nil

createModernToggle(mainTab, "Anti-Ragdoll (Pro)", "Özel ragdoll ve fizik eklemlerini bozar.", function(state)
    antiRagdollEnabled = state
    if antiRagdollEnabled then
        if not antiRagdollConnection then
            antiRagdollConnection = RunService.RenderStepped:Connect(function()
                local char = player.Character
                if not char then return end
                
                local hum = char:FindFirstChild("Humanoid")
                if hum then
                    hum.PlatformStand = false
                    local currentState = hum:GetState()
                    if currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
                
                -- Özel oyunların eklediği Ragdoll fizik eklemlerini (BallSocket) yok et
                for _, descendant in ipairs(char:GetDescendants()) do
                    if descendant:IsA("BallSocketConstraint") or descendant:IsA("HingeConstraint") then
                        -- Eğer ragdoll için eklenmiş bir eklemse yok et veya devre dışı bırak
                        descendant:Destroy()
                    end
                end
            end)
        end
        showNotification("Anti-Ragdoll", "Gelişmiş koruma aktif!", true)
    else
        if antiRagdollConnection then
            antiRagdollConnection:Disconnect()
            antiRagdollConnection = nil
        end
        showNotification("Anti-Ragdoll", "Durduruldu.", false)
    end
end)

-- Anti-AFK
local afkConn = nil
createModernToggle(mainTab, "Anti-AFK", "Sunucudan atılmayı engeller.", function(state)
    if state then
        afkConn = player.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end)
    else
        if afkConn then afkConn:Disconnect() end
    end
end)

-- Smooth Aim
local smoothAimActive = false
local aimSpeed = 0.2

createModernToggle(combatTab, "Smooth Aim", "Yakındaki düşmana yumuşak geçişli kilitlenme.", function(state)
    smoothAimActive = state
    task.spawn(function()
        while smoothAimActive do
            task.wait()
            local closestPlayer = nil
            local shortestDist = math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    local pos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(p.Character.Head.Position)
                    if onScreen then
                        local dist = (Vector2.new(pos.X, pos.Y) - UserInputService:GetMouseLocation()).Magnitude
                        if dist < shortestDist then
                            closestPlayer = p.Character.Head
                            shortestDist = dist
                        end
                    end
                end
            end
            if closestPlayer and shortestDist < 200 then
                local targetCFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Position)
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(targetCFrame, aimSpeed)
            end
        end
    end)
end)

-- WorthNet MM2 Aimbot (Fixli & Tahminli Pro Versiyon)
local mm2AimbotEnabled = false
local mm2AimbotConnection = nil

local crosshair = Drawing.new("Circle")
crosshair.Visible = false
crosshair.Radius = 3
crosshair.Filled = true
crosshair.Color = Color3.fromRGB(0, 255, 255)
crosshair.Transparency = 0.9

local function localHasGun()
    local localChar = player.Character
    local localBack = player:FindFirstChild("Backpack")
    return (localChar and localChar:FindFirstChild("Gun")) or (localBack and localBack:FindFirstChild("Gun"))
end

local function getTargetPlayer()
    -- 1. KONTROL: Eğer elimizde silah YOKSA, hiç kimseyi hedef alma!
    if not localHasGun() then return nil end

    local closestPlayer = nil
    local shortestDistance = math.huge
    local currentCamera = workspace.CurrentCamera
    local localChar = player.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    if not localRoot then return nil end

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local char = targetPlayer.Character
            local back = targetPlayer:FindFirstChild("Backpack")
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")

            -- Sadece elinde Bıçak olan kişiyi (Katili) hedef seç
            local targetHasKnife = (char:FindFirstChild("Knife") or (back and back:FindFirstChild("Knife")))

            if targetHasKnife and head and hum and hum.Health > 0 then
                local _, onScreen = currentCamera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local distance = (head.Position - localRoot.Position).Magnitude
                    if distance < shortestDistance then
                        shortestDistance = distance
                        closestPlayer = targetPlayer
                    end
                end
            end
        end
    end
    return closestPlayer
end

createModernToggle(mm2Tab, "MM2 Aimbot", "Sadece silahın varsa katile kilitlenir ve hareket tahminli vurur.", function(state)
    mm2AimbotEnabled = state
    crosshair.Visible = state
    
    if mm2AimbotEnabled then
        mm2AimbotConnection = RunService.RenderStepped:Connect(function()
            local screenSize = workspace.CurrentCamera.ViewportSize
            crosshair.Position = screenSize / 2

            local targetPlayer = getTargetPlayer()
            local char = targetPlayer and targetPlayer.Character
            local head = char and char:FindFirstChild("Head")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if head and hrp then
                local camera = workspace.CurrentCamera
                
                -- 2. HAREKET TAHMİNİ (Prediction): Katil koşarken merminin boşa gitmemesi için öne nişan alır
                local predictedPos = head.Position + (hrp.AssemblyLinearVelocity * 0.09)
                
                -- Kamerayı yumuşak ve isabetli şekilde kilitler
                local targetCFrame = CFrame.new(camera.CFrame.Position, predictedPos)
                camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.5)
            end
        end)
        showNotification("MM2 Aimbot", "Akıllı Aimbot aktif!", true)
    else
        if mm2AimbotConnection then
            mm2AimbotConnection:Disconnect()
            mm2AimbotConnection = nil
        end
        crosshair.Visible = false
        showNotification("MM2 Aimbot", "Durduruldu.", false)
    end
end)


-- WorthNet MM2 Auto Shoot (Geliştirilmiş & Akıllı Versiyon)
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local workspace = game:GetService("Workspace")

local mm2AutoShootEnabled = false
local mm2AutoShootConn = nil
local lastShot = 0
local shootDelay = 0.4 -- Ateş etme aralığı (Saniye)

createModernToggle(mm2Tab, "MM2 Auto Shoot", "Yumuşak nişan alma ve tahmin özellikli otomatik katil vurucu.", function(state)
    mm2AutoShootEnabled = state
    
    if mm2AutoShootEnabled then
        mm2AutoShootConn = RunService.RenderStepped:Connect(function()
            if not localHasGun() then return end
            
            local killer = getKillerTarget()
            if killer and killer.Character and killer.Character:FindFirstChild("Head") and killer.Character:FindFirstChild("HumanoidRootPart") then
                local head = killer.Character.Head
                local hrp = killer.Character.HumanoidRootPart
                local camera = workspace.CurrentCamera
                
                -- 1. Hareket Tahmini (Prediction): Katilin koşu yönüne göre hafif öne nişan al
                local predictedPos = head.Position + (hrp.AssemblyLinearVelocity * 0.08)
                
                -- 2. Smooth LookAt (Ekranın titrememesi için yumuşak kamera geçişi)
                local targetCFrame = CFrame.new(camera.CFrame.Position, predictedPos)
                camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.4)
                
                -- Silahı kontrol et ve eline al
                local localChar = player.Character
                local gun = localChar:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun")
                
                if gun then
                    if gun.Parent ~= localChar then
                        gun.Parent = localChar
                    end
                    
                    -- 3. Cooldown Kontrolü (Gereksiz spamı önlemek için)
                    if tick() - lastShot > shootDelay then
                        lastShot = tick()
                        pcall(function()
                            gun:Activate()
                        end)
                    end
                end
            end
        end)
        showNotification("Auto Shoot", "Gelişmiş Auto Shoot aktif!", true)
    else
        if mm2AutoShootConn then
            mm2AutoShootConn:Disconnect()
            mm2AutoShootConn = nil
        end
        showNotification("Auto Shoot", "Durduruldu.", false)
    end
end)

-- UI Viewer / Dex Explorer
createModernToggle(visualsTab, "UI Viewer (Dex)", "Arayüzü ve oyun ağacını incelemek için Explorer açar.", function(state)
	if state then
		pcall(function()
			loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))()
		end)
		showNotification("UI Viewer", "Dex Explorer yüklendi!", true)
	end
end)

-- Çoklu Remote Event Spam Sistemi
local remoteSpamActive = false

-- Spam yapmak istediğin farklı event isimlerini buraya ekleyebilirsin
local targetRemotes = {
    "RemoteEvent",
    "GiveItemEvent",
    "BuyItem",
    "RewardClaim",
    "TestData"
}

createModernToggle(mainTab, "Multi Remote Spam", "Listedeki tüm remote eventleri sürekli tetikler.", function(state)
    remoteSpamActive = state
    if state then
        task.spawn(function()
            while remoteSpamActive do
                task.wait(0.05)
                pcall(function()
                    -- Workspace ve ReplicatedStorage içindeki her şeyi tara
                    for _, v in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if v:IsA("RemoteEvent") then
                            -- Tablodaki isimlerden biriyle eşleşiyor mu diye kontrol et
                            for _, targetName in ipairs(targetRemotes) do
                                if v.Name == targetName then
                                    v:FireServer()
                                end
                            end
                        end
                    end
                end)
            end
        end)
        showNotification("Multi Spam", "Çoklu spam başlatıldı!", true)
    else
        showNotification("Multi Spam", "Durduruldu.", false)
    end
end)




-- Purchase Spoofing (Ücretsiz satın alma simülasyonu)
createModernToggle(mainTab, "Purchase Spoofing", "Mağaza satın alım eventlerini manipüle eder.", function(state)
	if state then
		pcall(function()
			for _, v in ipairs(workspace:GetDescendants()) do
				if v:IsA("RemoteEvent") and (v.Name:lower():find("buy") or v.Name:lower():find("purchase") or v.Name:lower():find("shop")) then
					v:FireServer("Free", true, 0, 999999)
				end
			end
			showNotification("Purchase Spoofing", "Satın alımlar manipüle edildi!", true)
		end)
	end
end)


createModernToggle(mainTab, "Give Items", "Birden fazla silah/eşya ID'sini sırayla dener.", function(state)
    if state then
        pcall(function()
            -- Denemek istediğin eşya adlarının veya ID'lerinin listesi
            local itemsToTry = {
                "Godkiller",
                "Sword",
                "AK47",
                "AdminGun",
                "Knife",
                "Gun",
				"Hammer",
				"SuperGun",
				"SuperKnife",
				"SuperHammer",
				"BanKnife",
				"Flashlight",
                "BanHammer",
                "SuperWeapon"
            }
            
            for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:lower():find("give") or v.Name:lower():find("giveweapon") or v.Name:lower():find("giveitem")  or v.Name:lower():find("item") or v.Name:lower():find("weapon")) then
                    
                    -- Tablodaki her bir eşyayı sırayla döner ve fırlatır
                    for _, itemName in ipairs(itemsToTry) do
                        v:FireServer("All", itemName, 1)
                        task.wait(0.05) -- Sunucuyu anında çökertmemek/kick yememek için mini gecikme
                    end
                    
                end
            end
            
            showNotification("Item Give", "Tüm eşya kombinasyonları fırlatıldı!", true)
        end)
    end
end)

-- FireServer Spoofing (Örn: Miktar = 999999)
createModernToggle(mainTab, "FireServer Spoofing", "Remote fonksiyonlara sahte parametreler yollar.", function(state)
	if state then
		pcall(function()
			for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
				if v:IsA("RemoteEvent") then
					v:FireServer(999999, "WorthNet_Exploit", true)
				end
			end
			showNotification("FireServer", "Sahte parametreler fırlatıldı!", true)
		end)
	end
end)


-- Kill All Players (Herkesin canını düşürme eventini tetikle)
createModernToggle(combatTab, "Kill All Players", "Can azaltma Remote Event'ini herkes için tetikler.", function(state)
	if state then
		pcall(function()
			for _, v in ipairs(ReplicatedStorage:GetDescendants()) do
				if v:IsA("RemoteEvent") and (v.Name:lower():find("damage") or v.Name:lower():find("hit") or v.Name:lower():find("kill") or v.Name:lower():find("attack")) then
					for _, p in ipairs(Players:GetPlayers()) do
						if p ~= player then
							v:FireServer(p, 999999)
						end
					end
				end
			end
			showNotification("Kill All", "Herkes için ölüm paketi gönderildi!", true)
		end)
	end
end)

-- Auto-Dodge (Gelen alan hasarlarından/yeteneklerden otomatik kaçma)
local autoDodgeActive = false
createModernToggle(moveTab, "Auto-Dodge", "Yaklaşan tehlikelerden ve AoE alanlardan otomatik kaçar.", function(state)
	autoDodgeActive = state
	if state then
		task.spawn(function()
			while autoDodgeActive do
				task.wait(0.05)
				pcall(function()
					local char = player.Character
					local hrp = char and char:FindFirstChild("HumanoidRootPart")
					if hrp then
						for _, obj in ipairs(workspace:GetChildren()) do
							if obj:IsA("Part") and obj.Name:lower():find("bullet") or obj.Name:lower():find("spell") or obj.Name:lower():find("aoe") then
								if (obj.Position - hrp.Position).Magnitude < 15 then
									hrp.CFrame = hrp.CFrame + Vector3.new(math.random(-10, 10), 5, math.random(-10, 10))
								end
							end
						end
					end
				end)
			end
		end)
		showNotification("Auto-Dodge", "Aktif! Tehlikelerden kaçılıyor.", true)
	else
		showNotification("Auto-Dodge", "Devre dışı bırakıldı.", false)
	end
end)
-- WorthNet MM2 AutoCoin System (Fixed & Dynamic)
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- Aktif harita içindeki CoinContainer'ı dinamik olarak bulan fonksiyon
local function getCoinContainer()
    for _, child in ipairs(Workspace:GetChildren()) do
        local container = child:FindFirstChild("CoinContainer")
        if container then
            return container
        end
    end
    return nil
end

-- 1. Toggle Butonu
createModernToggle(mm2Tab, "MM2 AutoCoin", "Dinamik harita algılayarak coin toplar, limit dolunca reset atar.", function(state)
    _G.AutoCoinActive = state
end)

-- 2. Ana AutoCoin Döngüsü (Güncellenmiş Versiyon)
task.spawn(function()
    local collectedCount = 0
    local RunService = game:GetService("RunService")
    
    while task.wait(0.5) do
        if _G.AutoCoinActive then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if hrp then
                -- Noclip aktif tutma
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
                
                -- O anki aktif haritanın coin konteynerini bul
                local coinContainer = getCoinContainer()
                
                if coinContainer then
                    for _, coinPart in ipairs(coinContainer:GetChildren()) do
                        if not _G.AutoCoinActive then break end
                        
                        if coinPart.Name == "Coin_Server" and coinPart:IsA("BasePart") then
                            -- Karakter coine ulaşana kadar CFrame ile akıcı şekilde taşıyalış
                            while coinPart and coinPart.Parent and _G.AutoCoinActive do
                                local distance = (hrp.Position - coinPart.Position).Magnitude
                                if distance < 3 then 
                                    break -- Coine çok yaklaştıysa döngüden çık (toplanmış sayılır)
                                end
                                
                             -- Hız ayarı (Saniyedeki Stud birimi)
                                local speed = 30 
                                local step = RunService.Heartbeat:Wait()
                                
                                -- Direkt coinin üstüne doğru lineer ilerleme
                                local direction = (coinPart.Position - hrp.Position).Unit
                                hrp.CFrame = hrp.CFrame + (direction * math.min(speed * step, distance))
                                
                                -- Hız sabitlemek için sıfırlama
                                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            end
                            
                            collectedCount = collectedCount + 1
                            task.wait(0.1)
                            
                            -- 38-40 coin limitine ulaşınca reset at
                            if collectedCount >= 38 then
                                local humanoid = char:FindFirstChildOfClass("Humanoid")
                                if humanoid then
                                    humanoid.Health = 0
                                end
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

-- Auto Remote Event Spam & Argument Flooding
_G.RemoteFloodActive = false
createModernToggle(combatTab, "Remote & Arg Flood", "ReplicatedStorage'daki eventlere büyük veriler spamler.", function(state)
    _G.RemoteFloodActive = state
    task.spawn(function()
        while _G.RemoteFloodActive do
            for _, v in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if v:IsA("RemoteEvent") then
                    pcall(function()
                        v:FireServer(string.rep("WorthNet", 5000), math.huge, {})
                    end)
                end
            end
            task.wait()
        end
    end)
end)


-- Tool Reach Extender
_G.ReachEnabled = false
createModernToggle(combatTab, "Tool Reach Extender", "Elindeki silah/kılıç menzilini uzatır.", function(state)
    _G.ReachEnabled = state
    task.spawn(function()
        while _G.ReachEnabled do
            local char = player.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool then
                for _, handle in ipairs(tool:GetDescendants()) do
                    if handle:IsA("BasePart") then
                        handle.Size = Vector3.new(4, 4, 15)
                        handle.Transparency = 0.8
                    end
                end
            end
            task.wait(1)
        end
    end)
end)

-- Custom FOV
local Camera = workspace.CurrentCamera
createModernSlider(visualsTab, "Custom FOV", "Görüş açınızı (FOV) ayarlar.", 70, 120, 70, function(value)
    Camera.FieldOfView = value
end)



-- Map Editor / Part Inspector & Deleter
_G.PartDeleterActive = false

local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local mouse = localPlayer:GetMouse()

-- Nesnenin tam hiyerarşisini (iskelet yolunu) çıkaran fonksiyon
local function getFullPath(obj)
    local path = obj.Name
    local current = obj.Parent
    while current and current ~= game do
        path = current.Name .." . ".. path
        current = current.Parent
    end
    return path
end

createModernToggle(visualsTab, "Click Part Deleter", "Tıkladığın parçanın bilgisini F9'a yazdırır ve siler.", function(state)
    _G.PartDeleterActive = state
end)

-- Mouse tıklama olayını tek bir kez dinleyiciye bağlıyoruz (Çift tetiklenmeyi önlemek için)
mouse.Button1Down:Connect(function()
    if _G.PartDeleterActive and mouse.Target then
        local targetPart = mouse.Target
        
        print("--------------------PART BULUNDU--------------------")
        print("İsim       : " .. targetPart.Name)
        print("Sınıf (Tür): " .. targetPart.ClassName)
        print("İskelet Yolu: " .. getFullPath(targetPart))
        print("--------------------------------------------------")
        
        -- Parçayı oyundan tamamen siler
        targetPart:Destroy()
    end
end)

-- Gravity Changer (Düzeltilmiş Hali)
createModernSlider(moveTab, "Gravity Changer", "Dünyanın yerçekimi kuvvetini ayarlar.", 0, 196, 196, function(val)
    workspace.Gravity = val
end)


-- Chat Logger (Mevcut + Yeni Oyuncular)
local Players = game:GetService("Players")

local function monitorPlayer(p)
    p.Chatted:Connect(function(msg)
        print("[WorthNet ChatLogger] " .. p.Name .. ": " .. msg)
    end)
end

-- 1. Oyunda şu an bulunan herkesi ekle
for _, p in ipairs(Players:GetPlayers()) do
    monitorPlayer(p)
end

-- 2. Oyuna sonradan girecek olanları dinle
Players.PlayerAdded:Connect(monitorPlayer)

-- Freecam / Camera Lock
_G.FreecamActive = false
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local freecamPos = Vector3.new(0, 0, 0)
local freecamAngles = Vector2.new(0, 0)

createModernToggle(visualsTab, "Freecam", "Kamerayı karakterden bağımsız serbest gezdirir.", function(state)
    _G.FreecamActive = state
    
    if state then
        -- Kameranın mevcut pozisyonunu ve açısını al başlangıç yap
        freecamPos = Camera.CFrame.Position
        local rot = Camera.CFrame - Camera.CFrame.Position
        -- İsteğe bağlı: Karakterin hareketini dondurmak için WalkSpeed'i 0 yapabilirsin
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 0
        end
        
        Camera.CameraType = Enum.CameraType.Scriptable
        
        -- Her karede kamerayı hareket ettiren döngü
        RunService:BindToRenderStep("WorthNetFreecam", Enum.RenderPriority.Camera.Value + 1, function(dt)
            if not _G.FreecamActive then
                RunService:UnbindFromRenderStep("WorthNetFreecam")
                return
            end
            
            local moveVector = Vector3.new(0, 0, 0)
            
            -- WASD / Yön Tuşları Kontrolü
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveVector = moveVector + Vector3.new(0, 0, -1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveVector = moveVector + Vector3.new(0, 0, 1) end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveVector = moveVector + Vector3.new(-1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveVector = moveVector + Vector3.new(1, 0, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then moveVector = moveVector + Vector3.new(0, 1, 0) end -- Yukarı
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then moveVector = moveVector + Vector3.new(0, -1, 0) end -- Aşağı
            
            -- Kameranın bakış açısına göre vektörü yönlendir ve pozisyonu güncelle
            local camCFrame = Camera.CFrame
            moveVector = camCFrame:VectorToWorldSpace(moveVector) * (60 * dt * 2) -- Hız çarpanı
            freecamPos = freecamPos + moveVector
            
            Camera.CFrame = CFrame.new(freecamPos) * (camCFrame - camCFrame.Position)
        end)
    else
        -- Kapatıldığında eski haline döndür
        RunService:UnbindFromRenderStep("SwoxTechFreecam")
        Camera.CameraType = Enum.CameraType.Custom
        
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 -- Normal hıza döndür
        end
    end
end)

-- Metatable Hook & Anti-Kick / Korumalar
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "Kick" and self == player then
         print("[WorthNet Security] Kick denemesi engellendi!")
         return
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- UI Toggle Key (Sağ Shift ile menüyü gizleme/açma)
local UserInputService = game:GetService("UserInputService")
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == Enum.KeyCode.RightShift then
        -- Kendi arayüz değişkenine göre MainUI durumunu ayarlayabilirsin
    end
end)

-- Basic Remote Spy
_G.RemoteSpyActive = false

createModernToggle(settingsTab, "Basic Remote Spy", "Giden eventleri F9 konsoluna yazdırır.", function(state)
    _G.RemoteSpyActive = state
end)

-- Metamethod Hook ile giden Remote'ları Yakalama
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Eğer RemoteSpy açıksa ve giden metod FireServer ise
    if _G.RemoteSpyActive and (method == "FireServer" or method == "InvokeServer") then
        if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
            print("[WorthNet Spy] -> Remote:", self:GetFullName())
            print("Args:", unpack(args))
        end
    end
    
    return oldNamecall(self, ...)
end)

-- Arayüze eklenecek toggle (Settings veya ayrı bir Troll sekmesine koyabilirsin)
createModernToggle(settingsTab, "Auto Remote Spam", "ReplicatedStorage'daki tüm eventleri bulur ve spamler.", function(state)
    _G.RemoteSpamActive = state
    
    if _G.RemoteSpamActive then
        task.spawn(function()
            while _G.RemoteSpamActive do
                local foundRemotes = getRemotes()
                
                for _, remote in ipairs(foundRemotes) do
                    if not _G.RemoteSpamActive then break end
                    
                    -- Güvenli bir şekilde spam at (Hata verip scripti durdurmaması için pcall kullanıyoruz)
                    pcall(function()
                        remote:FireServer("WorthNetSpam", math.random(1, 999999), {}, true)
                    end)
                end
                
                task.wait() -- Hızlı döngü
            end
        end)
    end
end)

createModernToggle(settingsTab, "FPS Booster", "Gereksiz görsel efektleri kapatarak FPS'i artırır.", function(state)
    if state then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 9e9
            for _, v in ipairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                end
            end
            showNotification("FPS Booster", "Grafikler optimize edildi!", true)
        end)
    end
end)

-- 3. Air Swim (Havada Yüzme)
local airSwimActive = false
createModernToggle(moveTab, "Air Swim", "Yerçekimini yok edip havada yüzmeni sağlar.", function(state)
    airSwimActive = state
    task.spawn(function()
        while airSwimActive do
            task.wait()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(char.HumanoidRootPart.Velocity.X, 2, char.HumanoidRootPart.Velocity.Z)
            end
        end
    end)
end)

-- 4. Wall Climb (Duvara Tırmanma)
local wallClimbActive = false
createModernToggle(moveTab, "Wall Climb", "Düz duvarlara tırmanmanı sağlar.", function(state)
    wallClimbActive = state
    task.spawn(function()
        while wallClimbActive do
            task.wait()
            pcall(function()
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.MoveDirection.Magnitude > 0 then
                    char.HumanoidRootPart.CFrame = char.HumanoidRootPart.CFrame + (hum.MoveDirection * 0.5)
                end
            end)
        end
    end)
end)

-- 11. Auto-Climb Ladders (Otomatik Merdiven)
createModernToggle(moveTab, "Auto-Climb Ladders", "Merdivenlere dokunmadan anında tırmanır.", function(state)
    if state then
        local char = player.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Climbing) end
    end
end)

-- 17. Anti-Slowdown (Yavaşlatma Koruması)
local antiSlowActive = false
createModernToggle(moveTab, "Anti-Slowdown", "Yavaşlatma ve stun efektlerini engeller.", function(state)
    antiSlowActive = state
    task.spawn(function()
        while antiSlowActive do
            task.wait(0.5)
            pcall(function()
                local char = player.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.WalkSpeed = 16
					 -- Varsayılan hızı sabitler
                    hum.JumpPower = 50
                end
            end)
        end
    end)
end)

-- 5. Rainbow Lighting (Gökkuşağı Işıklandırma)
local rainbowLightActive = false
createModernToggle(visualsTab, "Rainbow Lighting", "Haritayı parti ortamına çevirir.", function(state)
    rainbowLightActive = state
    task.spawn(function()
        while rainbowLightActive do
            for i = 0, 1, 0.01 do
                if not rainbowLightActive then break end
                Lighting.Ambient = Color3.fromHSV(i, 1, 1)
                task.wait(0.1)
            end
        end
        Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
    end)
end)

-- 7. Custom Crosshair (Özel Nişangah)
local crosshairGui
createModernToggle(visualsTab, "Custom Crosshair", "Ekrana özel nişangah sabitler.", function(state)
    if state then
        crosshairGui = Instance.new("ScreenGui", game.CoreGui)
        local dot = Instance.new("Frame", crosshairGui)
        dot.Size = UDim2.new(0, 6, 0, 6)
        dot.Position = UDim2.new(0.5, -3, 0.5, -3)
        dot.BackgroundColor3 = Color3.fromRGB(0, 255, 128)
        dot.BorderSizePixel = 0
        dot.Name = "WorthNetCrosshair"
    else
        if crosshairGui then crosshairGui:Destroy() end
    end
end)

-- 15. Ghost Mode (Hayalet Modu)
local ghostActive = false
createModernToggle(visualsTab, "Ghost Mode", "Karakterini tamamen şeffaf yapar.", function(state)
    ghostActive = state
    pcall(function()
        local char = player.Character
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Part") then
                v.Transparency = ghostActive and 0.7 or 0
            elseif v:IsA("Decal") then
                v.Transparency = ghostActive and 0.7 or 0
            end
        end
    end)
end)


-- 20. Crash Protection (Sunucu Çökme Koruması)
createModernToggle(mainTab, "Crash Protection", "İstemciyi çökmelere karşı korur.", function(state)
    if state then
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local old = mt.__namecall
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Kick" and self == player then
                return
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
        showNotification("WorthNet", "Crash koruması aktif!", true)
    end
end)

-- Server Hop (Düşük oyunculu sunucu)
createModernButton(mainTab, "Server Hop", "En sakin sunucuya geçiş yapar.", function()
    pcall(function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in ipairs(Servers.data) do
            if s.playing < s.maxPlayers - 2 then
                TPS:TeleportToPlaceInstance(game.PlaceId, s.id, player)
                break
            end
        end
    end)
end)

-- 18. Command Bar (Gizli Komut Satırı)
createModernButton(settingsTab, "Command Bar", "Ekranın altına komut çubuğu ekler.", function()
    pcall(function()
        if game.CoreGui:FindFirstChild("WorthNetCmd") then return end
        local gui = Instance.new("ScreenGui", game.CoreGui)
        gui.Name = "WorthNetCmd"
        local box = Instance.new("TextBox", gui)
        box.Size = UDim2.new(0, 300, 0, 30)
        box.Position = UDim2.new(0.5, -150, 1, -40)
        box.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.PlaceholderText = "Komut yaz (örn: speed 100)"
        box.Text = ""
        box.FocusLost:Connect(function(enter)
            if enter then
                local cmd = box.Text
                if cmd:sub(1,6) == "speed " then
                    local val = tonumber(cmd:sub(7))
                    if val then player.Character.Humanoid.WalkSpeed = val end
                end
                box.Text = ""
            end
        end)
    end)
end)

-- Arsenal Silent Aim & Wallbang Entegresi
local silentAimActive = false
createModernToggle(combatTab, "Arsenal Silent Aim", "Nişan almadan mermileri düşmana kilitler.", function(state)
    silentAimActive = state
    
    local Camera = workspace.CurrentCamera
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- En yakın düşmanı bulma fonksiyonu
    local function getClosestPlayer()
        local target = nil
        local shortestDist = math.huge
        for _, v in ipairs(Players:GetPlayers()) do
            if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") then
                if v.Character.Humanoid.Health > 0 then
                    -- Takım kontrolü (Arsenal için TeamCheck)
                    if v.Team ~= LocalPlayer.Team then
                        local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
                        local dist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            target = v.Character.Head
                        end
                    end
                end
            end
        end
        return target
    end

    -- Hook metodu ile mermi yönünü değiştirme
    task.spawn(function()
        local mt = getrawmetatable(game)
        setreadonly(mt, false)
        local oldNamecall = mt.__namecall
        
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            
            if silentAimActive and method == "FireServer" then
                -- Arsenal mermi atış remote'larını yakalama
                if self.Name:lower():find("fire") or self.Name:lower():find("shoot") or self.Name:lower():find("hit") then
                    local targetHead = getClosestPlayer()
                    if targetHead then
                        for i, v in ipairs(args) do
                            if typeof(v) == "Vector3" then
                                args[i] = targetHead.Position + Vector3.new(0, 0, 0) -- Duvar arkası için pozisyon zorlaması
                            elseif typeof(v) == "Instance" and v:IsA("BasePart") then
                                args[i] = targetHead
                            end
                        end
                        return oldNamecall(self, unpack(args))
                    end
                end
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end)
end)





-- Xeno ve Executor Uyumluluk Metatable Koruması
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
