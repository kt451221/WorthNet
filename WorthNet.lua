-- WorthNet UI System v4.4 - Glass Bridge, Tug of War & Adjustable SpeedHack (Fixed)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

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

_G.toggleRegistry = _G.toggleRegistry or {}

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
		
		callback(isOn)
	end
	
	switch.MouseButton1Click:Connect(function()
		updateState(not isOn)
	end)
	
	_G.toggleRegistry[name] = updateState
end

-- AYARLANABİLİR SLİDER (BAR) FONKSİYONU
local function createModernSlider(name, description, min, max, default, callback)
	local cardFrame = Instance.new("Frame")
	cardFrame.Name = name
	cardFrame.Size = UDim2.new(1, -10, 0, 65)
	cardFrame.BackgroundColor3 = THEME.Card
	cardFrame.BorderSizePixel = 0
	cardFrame.ZIndex = 7
	cardFrame.Parent = contentArea
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

---------------------------------------------------------
-- HİLE AKTİVASYON ALANI
---------------------------------------------------------
local antiFlingConn = nil
local mm2ESPActive = false
local mm2Highlights = {}
local infJumpConn = nil
local bhopConn = nil
local originalSpeed = 16

-- 1. GLASS BRIDGE ESP
local glassEspActive = false
createModernToggle("Glass Bridge ESP", "Güvenli ve kırılacak camları gösterir.", function(state)
	glassEspActive = state
	task.spawn(function()
		while glassEspActive do
			task.wait(0.5)
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("BasePart") then
					local name = string.lower(obj.Name)
					if string.find(name, "glass") or string.find(name, "pane") then
						local hl = obj:FindFirstChild("WorthNetGlassHL") or Instance.new("Highlight", obj)
						hl.Name = "WorthNetGlassHL"
						hl.Enabled = glassEspActive
						if obj.Material == Enum.Material.Glass and obj.Transparency < 0.9 then
							hl.FillColor = Color3.fromRGB(0, 255, 100)
						else
							hl.FillColor = Color3.fromRGB(255, 0, 0)
						end
					end
				end
			end
		end
		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") then
				local hl = obj:FindFirstChild("WorthNetGlassHL")
				if hl then hl:Destroy() end
			end
		end
	end)
end)

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local towActive = false

-- Arka planda çalışan tek ve optimize edilmiş tıklama döngüsü
task.spawn(function()
	while true do
		if towActive then
			pcall(function()
				VirtualInputManager:SendMouseButtonEvent(500, 500, 0, true, game, 0)
				task.wait(0.005)
				VirtualInputManager:SendMouseButtonEvent(500, 500, 0, false, game, 0)
			end)
			task.wait(0.01)
		else
			task.wait(0.1) -- Kapalıyken boşa işlem yapıp yormaması için bekleme süresi
		end
	end
end)

-- UI Toggle (Menüden kontrol için)
createModernToggle("Tug of War Auto-Clicker", "Halat çekme oyununda otomatik tıklar. (Tuş: I)", function(state)
	towActive = state
end)

-- "I" tuşu ile kısayoldan açıp kapama
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.I then
		towActive = not towActive
	end
end)

-- 3. SPEEDHACK (Düzeltilmiş, Kayıtlı ve UI Uyumlu Modül)
local speedHackActive = false
local targetSpeedValue = 75
local speedSpamConn = nil

local speedHackContainer = Instance.new("Frame")
speedHackContainer.Name = "SpeedHackModule"
speedHackContainer.Size = UDim2.new(1, -10, 0, 105)
speedHackContainer.BackgroundColor3 = THEME.Card
speedHackContainer.BorderSizePixel = 0
speedHackContainer.ZIndex = 7
speedHackContainer.Parent = contentArea
roundCorners(speedHackContainer, 8)

local speedListLayout = Instance.new("UIListLayout")
speedListLayout.SortOrder = Enum.SortOrder.LayoutOrder
speedListLayout.Padding = UDim.new(0, 10)
speedListLayout.Parent = speedHackContainer

local topRow = Instance.new("Frame")
topRow.Size = UDim2.new(1, 0, 0, 28)
topRow.BackgroundTransparency = 1
topRow.LayoutOrder = 1
topRow.Parent = speedHackContainer

local speedTitleLabel = Instance.new("TextLabel")
speedTitleLabel.Name = "HackyTitle"
speedTitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
speedTitleLabel.Position = UDim2.new(0, 15, 0, 0)
speedTitleLabel.BackgroundTransparency = 1
speedTitleLabel.Text = "SpeedHack"
speedTitleLabel.TextColor3 = THEME.TextMain
speedTitleLabel.TextSize = 14
speedTitleLabel.Font = Enum.Font.GothamBold
speedTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
speedTitleLabel.ZIndex = 8
speedTitleLabel.Parent = topRow

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 44, 0, 22)
toggleBtn.Position = UDim2.new(1, -60, 0.5, -11)
toggleBtn.BackgroundColor3 = THEME.ToggleOff
toggleBtn.Text = ""
toggleBtn.ZIndex = 8
local toggleCorner = Instance.new("UICorner") 
toggleCorner.CornerRadius = UDim.new(1, 0) 
toggleCorner.Parent = toggleBtn
toggleBtn.Parent = topRow

local toggleCircle = Instance.new("Frame")
toggleCircle.Size = UDim2.new(0, 18, 0, 18)
toggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleCircle.ZIndex = 9
local circleCorner = Instance.new("UICorner") 
circleCorner.CornerRadius = UDim.new(1, 0) 
circleCorner.Parent = toggleCircle
toggleCircle.Parent = toggleBtn

local sliderRow = Instance.new("Frame")
sliderRow.Size = UDim2.new(1, -30, 0, 50)
sliderRow.Position = UDim2.new(0, 15, 0, 0)
sliderRow.BackgroundTransparency = 1
sliderRow.LayoutOrder = 2
sliderRow.ZIndex = 8
sliderRow.Parent = speedHackContainer

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -55, 0, 20)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "Hız Seviyesi: 75"
sliderLabel.TextColor3 = THEME.TextDark
sliderLabel.TextSize = 11
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.ZIndex = 8
sliderLabel.Parent = sliderRow

local valueTextBox = Instance.new("TextBox")
valueTextBox.Size = UDim2.new(0, 45, 0, 20)
valueTextBox.Position = UDim2.new(1, -45, 0, 0)
valueTextBox.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
valueTextBox.TextColor3 = THEME.Accent
valueTextBox.Text = tostring(targetSpeedValue)
valueTextBox.TextSize = 12
valueTextBox.Font = Enum.Font.GothamBold
valueTextBox.ClearTextOnFocus = false
valueTextBox.ZIndex = 8
local boxCorner = Instance.new("UICorner") 
boxCorner.CornerRadius = UDim.new(0, 4) 
boxCorner.Parent = valueTextBox
valueTextBox.Parent = sliderRow

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, 0, 0, 6)
sliderTrack.Position = UDim2.new(0, 0, 0, 34)
sliderTrack.BackgroundColor3 = THEME.ToggleOff
sliderTrack.BorderSizePixel = 0
sliderTrack.ZIndex = 8
local trackCorner = Instance.new("UICorner") 
trackCorner.CornerRadius = UDim.new(1, 0) 
trackCorner.Parent = sliderTrack
sliderTrack.Parent = sliderRow

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = THEME.Accent
sliderFill.BorderSizePixel = 0
sliderFill.ZIndex = 9
local fillCorner = Instance.new("UICorner") 
fillCorner.CornerRadius = UDim.new(1, 0) 
fillCorner.Parent = sliderFill
sliderFill.Parent = sliderTrack

local sliderThumb = Instance.new("Frame")
sliderThumb.Size = UDim2.new(0, 14, 0, 14)
sliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
sliderThumb.Position = UDim2.new(0, 0, 0.5, 0)
sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderThumb.ZIndex = 10
local thumbCorner = Instance.new("UICorner") 
thumbCorner.CornerRadius = UDim.new(1, 0) 
thumbCorner.Parent = sliderThumb
sliderThumb.Parent = sliderTrack

local minVal, maxVal = 16, 500

local function updateSpeed(val)
	targetSpeedValue = math.clamp(math.floor(val), minVal, maxVal)
	valueTextBox.Text = tostring(targetSpeedValue)
	sliderLabel.Text = "Hız Seviyesi: " .. targetSpeedValue
	
	local percent = (targetSpeedValue - minVal) / (maxVal - minVal)
	sliderFill.Size = UDim2.new(percent, 0, 1, 0)
	sliderThumb.Position = UDim2.new(percent, 0, 0.5, 0)
end

local draggingSlider = false
sliderTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
	end
end)
sliderThumb.InputBegan:Connect(function(input)
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
		local mousePos = UserInputService:GetMouseLocation()
		local absPos = sliderTrack.AbsolutePosition
		local absSize = sliderTrack.AbsoluteSize
		local pos = math.clamp((mousePos.X - absPos.X) / absSize.X, 0, 1)
		local newVal = minVal + (maxVal - minVal) * pos
		updateSpeed(newVal)
	end
end)

valueTextBox.FocusLost:Connect(function()
	local num = tonumber(valueTextBox.Text)
	if num then
		updateSpeed(num)
	else
		valueTextBox.Text = tostring(targetSpeedValue)
	end
end)

-- Toggle Registry Kaydı ve Tıklama Yönetimi
_G.toggleRegistry = _G.toggleRegistry or {}

_G.toggleRegistry["SpeedHack"] = function(state, suppress)
	if speedHackActive ~= state then
		speedHackActive = state
		if speedHackActive then
			TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ToggleOn}):Play()
			TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -9)}):Play()
			if not suppress then showNotification("SpeedHack", "Aktif edildi!", true) end
			
			speedSpamConn = RunService.Heartbeat:Connect(function()
				local char = player.Character
				local hum = char and char:FindFirstChild("Humanoid")
				if hum and hum.WalkSpeed ~= targetSpeedValue then
					hum.WalkSpeed = targetSpeedValue
				end
			end)
		else
			TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ToggleOff}):Play()
			TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
			if not suppress then showNotification("SpeedHack", "Devre dışı bırakıldı.", false) end
			
			if speedSpamConn then speedSpamConn:Disconnect() speedSpamConn = nil end
			local hum = player.Character and player.Character:FindFirstChild("Humanoid")
			if hum then hum.WalkSpeed = originalSpeed end
		end
	end
end

toggleBtn.MouseButton1Click:Connect(function()
	_G.toggleRegistry["SpeedHack"](not speedHackActive, false)
end)

updateSpeed(targetSpeedValue)

-- -- 4. SAFE NOCLIP (Yere Düşme ve Kick Önleyici)
local noclipConnection = nil

createModernToggle("Noclip", "Duvarların içinden geçmenizi sağlar (Kick atmaz).", function(state)
	if state then
		noclipConnection = RunService.Stepped:Connect(function()
			local char = player.Character
			if char then
				local root = char:FindFirstChild("HumanoidRootPart")
				
				-- Karakterin tüm parçalarının çarpışmasını kapat
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") and part.CanCollide then 
						part.CanCollide = false 
					end
				end
				
				-- Yerin dibine düşüp anti-cheat'e yakalanmamak için hızı ve yerçekimini dengeliyoruz
				if root then
					local currentVel = root.AssemblyLinearVelocity
					-- Eğer aşağıya doğru hızlı bir düşüş varsa bunu sıfırlayarak kicklenmeyi önlüyoruz
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
		
		-- Kapatıldığında eski haline döndür
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

-- -- 5. CFRAME FLY (Anti-Kick / Delta Style Bypass)
local cframeFlyActive = false
local flySpeed = 50
local flyConnection

local function updateCFrameFly(state)
	cframeFlyActive = state
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")

	if cframeFlyActive and root and hum then
		hum.PlatformStand = true
		
		-- Fizik motorunu devre dışı bırakıp tamamen CFrame ile kontrolü ele alıyoruz
		flyConnection = RunService.RenderStepped:Connect(function(dt)
			if not cframeFlyActive or not root or not root.Parent then
				if flyConnection then flyConnection:Disconnect() end
				return
			end
			
			-- Çarpışmaları kapat ki duvarlara takılma
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
			
			-- Pozisyonu direkt güncelliyoruz ve sunucu hız algılamasın diye Velocity'yi sıfırlıyoruz
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

createModernToggle("Fly", "(Kick Atmaz)", "Fizik motorunu bypass eder, P tuşu ile açılır.", function(state)
	updateCFrameFly(state)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.P then
		updateCFrameFly(not cframeFlyActive)
	end
end)

-- 8. FLING MODULE (UI Uyumlu createModernToggle İle)
local flingActive = false
local flingConn = nil

createModernToggle("Fling", "En yakınındaki oyuncuyu fırlatır.", function(state)
	flingActive = state
	
	if flingActive then
		flingConn = RunService.Heartbeat:Connect(function()
			local character = player.Character
			local rootPart = character and character:FindFirstChild("HumanoidRootPart")
			if not rootPart then return end
			
			-- En yakın hedefi bul
			local closestPlayer = nil
			local minDist = math.huge
			
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local targetRoot = p.Character.HumanoidRootPart
					local dist = (targetRoot.Position - rootPart.Position).Magnitude
					if dist < minDist then
						minDist = dist
						closestPlayer = p
					end
				end
			end
			
			-- Hedef varsa üzerine yapış ve fizik motorunu patlat
			if closestPlayer and closestPlayer.Character and closestPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local targetRoot = closestPlayer.Character.HumanoidRootPart
				rootPart.CFrame = targetRoot.CFrame
				rootPart.AssemblyAngularVelocity = Vector3.new(0, 99999, 0)
				rootPart.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
			end
		end)
	else
		-- Kapatıldığında bağlantıyı kopar ve hızları sıfırla
		if flingConn then
			flingConn:Disconnect()
			flingConn = nil
		end
		
		local char = player.Character
		local rootPart = char and char:FindFirstChild("HumanoidRootPart")
		if rootPart then
			rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		end
	end
end)

-- 7. AIMBOT MODULE (UI Uyumlu, Sağ Click Basılı Tutma, Smooth Takip & Toggle Registry Kayıtlı)
local aimbotActive = false
local targetFovValue = 150
local aimbotConn = nil

local aimbotContainer = Instance.new("Frame")
aimbotContainer.Name = "AimbotModule"
aimbotContainer.Size = UDim2.new(1, -10, 0, 105)
aimbotContainer.BackgroundColor3 = THEME.Card
aimbotContainer.BorderSizePixel = 0
aimbotContainer.ZIndex = 7
aimbotContainer.Parent = contentArea
roundCorners(aimbotContainer, 8)

local aimbotListLayout = Instance.new("UIListLayout")
aimbotListLayout.SortOrder = Enum.SortOrder.LayoutOrder
aimbotListLayout.Padding = UDim.new(0, 10)
aimbotListLayout.Parent = aimbotContainer

local topRow = Instance.new("Frame")
topRow.Size = UDim2.new(1, 0, 0, 28)
topRow.BackgroundTransparency = 1
topRow.LayoutOrder = 1
topRow.Parent = aimbotContainer

local aimbotTitleLabel = Instance.new("TextLabel")
aimbotTitleLabel.Name = "AimbotTitle"
aimbotTitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
aimbotTitleLabel.Position = UDim2.new(0, 15, 0, 0)
aimbotTitleLabel.BackgroundTransparency = 1
aimbotTitleLabel.Text = "Aimbot"
aimbotTitleLabel.TextColor3 = THEME.TextMain
aimbotTitleLabel.TextSize = 14
aimbotTitleLabel.Font = Enum.Font.GothamBold
aimbotTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
aimbotTitleLabel.ZIndex = 8
aimbotTitleLabel.Parent = topRow

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 44, 0, 22)
toggleBtn.Position = UDim2.new(1, -60, 0.5, -11)
toggleBtn.BackgroundColor3 = THEME.ToggleOff
toggleBtn.Text = ""
toggleBtn.ZIndex = 8
local toggleCorner = Instance.new("UICorner") 
toggleCorner.CornerRadius = UDim.new(1, 0) 
toggleCorner.Parent = toggleBtn
toggleBtn.Parent = topRow

local toggleCircle = Instance.new("Frame")
toggleCircle.Size = UDim2.new(0, 18, 0, 18)
toggleCircle.Position = UDim2.new(0, 3, 0.5, -9)
toggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleCircle.ZIndex = 9
local circleCorner = Instance.new("UICorner") 
circleCorner.CornerRadius = UDim.new(1, 0) 
circleCorner.Parent = toggleCircle
toggleCircle.Parent = toggleBtn

local sliderRow = Instance.new("Frame")
sliderRow.Size = UDim2.new(1, -30, 0, 50)
sliderRow.Position = UDim2.new(0, 15, 0, 0)
sliderRow.BackgroundTransparency = 1
sliderRow.LayoutOrder = 2
sliderRow.ZIndex = 8
sliderRow.Parent = aimbotContainer

local sliderLabel = Instance.new("TextLabel")
sliderLabel.Size = UDim2.new(1, -55, 0, 20)
sliderLabel.BackgroundTransparency = 1
sliderLabel.Text = "FOV Çapı: 150"
sliderLabel.TextColor3 = THEME.TextDark
sliderLabel.TextSize = 11
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
sliderLabel.ZIndex = 8
sliderLabel.Parent = sliderRow

local valueTextBox = Instance.new("TextBox")
valueTextBox.Size = UDim2.new(0, 45, 0, 20)
valueTextBox.Position = UDim2.new(1, -45, 0, 0)
valueTextBox.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
valueTextBox.TextColor3 = THEME.Accent
valueTextBox.Text = tostring(targetFovValue)
valueTextBox.TextSize = 12
valueTextBox.Font = Enum.Font.GothamBold
valueTextBox.ClearTextOnFocus = false
valueTextBox.ZIndex = 8
local boxCorner = Instance.new("UICorner") 
boxCorner.CornerRadius = UDim.new(0, 4) 
boxCorner.Parent = valueTextBox
valueTextBox.Parent = sliderRow

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, 0, 0, 6)
sliderTrack.Position = UDim2.new(0, 0, 0, 34)
sliderTrack.BackgroundColor3 = THEME.ToggleOff
sliderTrack.BorderSizePixel = 0
sliderTrack.ZIndex = 8
local trackCorner = Instance.new("UICorner") 
trackCorner.CornerRadius = UDim.new(1, 0) 
trackCorner.Parent = sliderTrack
sliderTrack.Parent = sliderRow

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0, 0, 1, 0)
sliderFill.BackgroundColor3 = THEME.Accent
sliderFill.BorderSizePixel = 0
sliderFill.ZIndex = 9
local fillCorner = Instance.new("UICorner") 
fillCorner.CornerRadius = UDim.new(1, 0) 
fillCorner.Parent = sliderFill
sliderFill.Parent = sliderTrack

local sliderThumb = Instance.new("Frame")
sliderThumb.Size = UDim2.new(0, 14, 0, 14)
sliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
sliderThumb.Position = UDim2.new(0, 0, 0.5, 0)
sliderThumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderThumb.ZIndex = 10
local thumbCorner = Instance.new("UICorner") 
thumbCorner.CornerRadius = UDim.new(1, 0) 
thumbCorner.Parent = sliderThumb
sliderThumb.Parent = sliderTrack

local minVal, maxVal = 30, 500

local function updateFov(val)
	targetFovValue = math.clamp(math.floor(val), minVal, maxVal)
	valueTextBox.Text = tostring(targetFovValue)
	sliderLabel.Text = "FOV Çapı: " .. targetFovValue
	
	local percent = (targetFovValue - minVal) / (maxVal - minVal)
	sliderFill.Size = UDim2.new(percent, 0, 1, 0)
	sliderThumb.Position = UDim2.new(percent, 0, 0.5, 0)
end

local draggingSlider = false
sliderTrack.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		draggingSlider = true
	end
end)
sliderThumb.InputBegan:Connect(function(input)
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
		local mousePos = UserInputService:GetMouseLocation()
		local absPos = sliderTrack.AbsolutePosition
		local absSize = sliderTrack.AbsoluteSize
		local pos = math.clamp((mousePos.X - absPos.X) / absSize.X, 0, 1)
		local newVal = minVal + (maxVal - minVal) * pos
		updateFov(newVal)
	end
end)

valueTextBox.FocusLost:Connect(function()
	local num = tonumber(valueTextBox.Text)
	if num then
		updateFov(num)
	else
		valueTextBox.Text = tostring(targetFovValue)
	end
end)

-- FOV Çemberi
local fovCircle = Drawing.new("Circle")
fovCircle.Color = Color3.fromRGB(255, 255, 255)
fovCircle.Thickness = 1
fovCircle.Radius = targetFovValue
fovCircle.Filled = false
fovCircle.Visible = false

local function getClosestPlayerInFov()
	local closestPlayer = nil
	local shortestDistance = targetFovValue
	local currentCamera = workspace.CurrentCamera
	local mouseLocation = UserInputService:GetMouseLocation()

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
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

-- Toggle Registry Kaydı ve Tıklama Yönetimi
_G.toggleRegistry = _G.toggleRegistry or {}

_G.toggleRegistry["Aimbot"] = function(state, suppress)
	if aimbotActive ~= state then
		aimbotActive = state
		if aimbotActive then
			TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ToggleOn}):Play()
			TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -9)}):Play()
			if not suppress then showNotification("Aimbot", "Aktif edildi (Sağ Click basılı tutun)!", true) end
			
			aimbotConn = RunService.RenderStepped:Connect(function()
				local camera = workspace.CurrentCamera
				local mouseLoc = UserInputService:GetMouseLocation()
				
				fovCircle.Radius = targetFovValue
				fovCircle.Position = mouseLoc
				fovCircle.Visible = true

				-- Sadece Sağ Click (MouseButton2) basılı tutulduğunda kilitlen
				if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
					local targetPlayer = getClosestPlayerInFov()
					if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
						local head = targetPlayer.Character.Head
						local targetCFrame = CFrame.new(camera.CFrame.Position, head.Position)
						camera.CFrame = camera.CFrame:Lerp(targetCFrame, 0.3)
					end
				end
			end)
		else
			TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ToggleOff}):Play()
			TweenService:Create(toggleCircle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -9)}):Play()
			fovCircle.Visible = false
			if not suppress then showNotification("Aimbot", "Devre dışı bırakıldı.", false) end
			
			if aimbotConn then aimbotConn:Disconnect() aimbotConn = nil end
		end
	end
end

toggleBtn.MouseButton1Click:Connect(function()
	_G.toggleRegistry["Aimbot"](not aimbotActive, false)
end)

updateFov(targetFovValue)

-- -- 9. ADVANCED NAME & HEALTH ESP (Highlight + BillboardGui)
local espActive = false

createModernToggle("Name & Health ESP", "Düşmanların rengini, ismini ve canını gösterir.", function(state)
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
							-- 1. Highlight (Karakter Renklendirme ve Parlatma)
							local highlight = char:FindFirstChild("WorthNet_Highlight")
							if not highlight then
								highlight = Instance.new("Highlight")
								highlight.Name = "WorthNet_Highlight"
								highlight.Adornee = char
								highlight.Parent = char
							end
							highlight.Enabled = true
							highlight.FillColor = Color3.fromRGB(255, 50, 50) -- Kırmızı dolgu rengi
							highlight.OutlineColor = Color3.fromRGB(255, 255, 255) -- Beyaz çerçeve
							highlight.FillTransparency = 0.5
							
							-- 2. BillboardGui (İsim ve Can Göstergesi)
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
								textLabel.TextStrokeTransparency = 0 -- Okunabilirlik için siyah kenar
								textLabel.TextSize = 14
								textLabel.Font = Enum.Font.SourceSansBold
								textLabel.Parent = billboard
							else
								textLabel = billboard:FindFirstChild("InfoText")
							end
							
							-- Can yüzdesini hesapla ve yazdır
							if textLabel then
								local healthPercent = math.floor((hum.Health / hum.MaxHealth) * 100)
								textLabel.Text = p.Name .. " [" .. healthPercent .. "%]"
							end
						end
					end
				end
				task.wait(0.3) -- Performans için optimize edilmiş tarama aralığı
			end
		end)
	else
		-- Kapatıldığında tüm ESP ögelerini temizle
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


-- 10. ANTI-FLING
createModernToggle("Anti-Fling", "Sizi haritadan uçurmaya çalışanları engeller.", function(state)
	if state then
		antiFlingConn = RunService.Heartbeat:Connect(function()
			if player.Character then
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= player and p.Character then
						local enemyRoot = p.Character:FindFirstChild("HumanoidRootPart")
						if enemyRoot and (enemyRoot.Velocity.Magnitude > 75 or enemyRoot.RotVelocity.Magnitude > 75) then
							for _, part in ipairs(p.Character:GetDescendants()) do
								if part:IsA("BasePart") then
									part.CanCollide = false
									part.Velocity = Vector3.new(0,0,0)
									part.RotVelocity = Vector3.new(0,0,0)
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

-- 11. MAP BYPASS
local function bypassMap(state)
    _G.BypassEnabled = state
    if state then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                if obj.Transparency == 1 and obj.CanCollide == true then
                    obj.CanCollide = false
                end
                if obj.Name:lower():find("barrier") or obj.Name:lower():find("wall") or obj.Name:lower():find("invisiblewall") then
                    obj.CanCollide = false
                end
            end
        end
        showNotification("Map Bypass", "Görünmez duvarlar kaldırıldı!", true)
    else
        showNotification("Map Bypass", "Kapatıldı.", false)
    end
end

createModernToggle("Map Bypass", "Görünmez duvarları yok et.", function(state)
    bypassMap(state)
end)

-- 12. MM2 ESP
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

-- 13. INFINITE JUMP
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


-- 15. FULLBRIGHT
local origAmbient, origColorShift, brightLoop = nil, nil, nil
createModernToggle("FullBright", "Haritadaki tüm karanlık ve gölgeleri kaldırıp aydınlatır.", function(state)
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

-- 16. NO FOG
local origFogStart, origFogEnd = nil, nil
createModernToggle("No Fog", "Görüş mesafesini düşüren tüm sis efektlerini yok eder.", function(state)
	if state then
		origFogStart = Lighting.FogStart
		origFogEnd = Lighting.FogEnd
		Lighting.FogStart = 9e9
		Lighting.FogEnd = 9e9
	else
		if origFogStart then Lighting.FogStart = origFogStart Lighting.FogEnd = origFogEnd end
	end
end)

-- 17. ANTI-VOID
local antiVoidConn = nil
createModernToggle("Anti-Void", "Boşluğa düşerek ölmeyi engeller.", function(state)
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


-- 19. AUTO AIM / TRIGGERBOT
local autoAimEnabled = false
local autoAimConnection = nil
local vim = game:GetService("VirtualInputManager")

local function autoClick()
    vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, true, game, 0)
    task.wait(0.02)
    vim:SendMouseButtonEvent(mouse.X, mouse.Y, 0, false, game, 0)
end

createModernToggle("Auto Aim", "Crosshair rakibin üzerine geldiğinde otomatik ateş eder.", function(state)
    autoAimEnabled = state
    if autoAimEnabled then
        autoAimConnection = mouse:GetPropertyChangedSignal("Target"):Connect(function()
            if not autoAimEnabled then return end
            local target = mouse.Target
            if target and target.Parent then
                local character = target.Parent
                if not character:FindFirstChild("Humanoid") then
                    character = character.Parent
                end
                local humanoid = character and character:FindFirstChild("Humanoid")
                local targetPlayer = Players:GetPlayerFromCharacter(character)
                
                if targetPlayer and targetPlayer ~= player and humanoid and humanoid.Health > 0 then
                    if targetPlayer.Team and targetPlayer.Team == player.Team then return end
                    if not UserInputService:GetFocusedTextBox() then
                        autoClick()
                    end
                end
            end
        end)
    else
        if autoAimConnection then
            autoAimConnection:Disconnect()
            autoAimConnection = nil
        end
    end
end)

-- 20. SPINBOT
local spinConn = nil
createModernToggle("SpinBot", "Etrafında çılgınca dönersin.", function(state)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if state and root then
        spinConn = RunService.RenderStepped:Connect(function()
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0)
        end)
    else
        if spinConn then spinConn:Disconnect() spinConn = nil end
    end
end)

-- 21. HITBOX EXPANDER
local hitboxEnabled = false
local hitboxConnection = nil

createModernToggle("Hitbox Expander", "Rakiplerin vurulma alanını büyütür.", function(state)
    hitboxEnabled = state
    if hitboxEnabled then
        hitboxConnection = RunService.Heartbeat:Connect(function()
            for _, targetPlayer in ipairs(Players:GetPlayers()) do
                if targetPlayer ~= player and targetPlayer.Character then
                    local root = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        root.Size = Vector3.new(5, 5, 5)
                        root.Transparency = 0.7
                        root.Color = Color3.fromRGB(220, 130, 30)
                        root.CanCollide = false
                    end
                end
            end
        end)
    else
        if hitboxConnection then hitboxConnection:Disconnect() hitboxConnection = nil end
        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                targetPlayer.Character.HumanoidRootPart.Size = Vector3.new(2, 2, 1)
                targetPlayer.Character.HumanoidRootPart.Transparency = 1
            end
        end
    end
end)

-- 22. INVENTORY ESP
local invESPActive = false
local invTags = {}

createModernToggle("Inventory ESP", "Oyuncuların elindeki/sırtındaki itemleri listeler.", function(state)
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

-- 23. TP NEAREST
createModernToggle("TP Nearest", "En yakındaki oyuncunun yanına ışınlanırsın.", function(state)
    if state then
        local target = nil
        local dist = 10000
        
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

-- Oyuncu Listesi Penceresini Yöneten Değişkenler
local playerListGui = nil
local scrollingFrameRef = nil
local playerConnections = {}

local function createPlayerListWindow()
    if playerListGui then
        playerListGui.Enabled = true
        return
    end

    -- Ana Ekran GUI'si
    playerListGui = Instance.new("ScreenGui")
    playerListGui.Name = "SwoxTechPlayerListMenu"
    -- Güvenli bir şekilde CoreGui'ye ekleyelim (yoksa PlayerGui)
    local success = pcall(function()
        playerListGui.Parent = game:GetService("CoreGui")
    end)
    if not success then
        playerListGui.Parent = player.PlayerGui
    end

    -- Ana Çerçeve (Kutu)
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(0, 240, 0, 320)
    mainFrame.Position = UDim2.new(0.05, 0, 0.3, 0) -- Ekranın sol orta kısmı
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true -- İsteğe bağlı sürüklenebilir olsun
    mainFrame.Parent = playerListGui

    local frameCorner = Instance.new("UICorner")
    frameCorner.CornerRadius = UDim.new(0, 10)
    frameCorner.Parent = mainFrame

    -- Başlık
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Oyuncu Işınlanma Menüsü"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 13
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = mainFrame

    -- Kaydırma Alanı (ScrollingFrame)
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

    -- Listeyi Doldurma Fonksiyonu
    local function refreshList()
        if not scrollingFrameRef then return end
        
        -- Eski elemanları temizle
        for _, child in ipairs(scrollingFrameRef:GetChildren()) do
            if child:IsA("Frame") then
                child:Destroy()
            end
        end

        for _, targetPlayer in ipairs(Players:GetPlayers()) do
            if targetPlayer ~= player then
                -- Her oyuncu için satır
                local itemRow = Instance.new("Frame")
                itemRow.Size = UDim2.new(1, 0, 0, 32)
                itemRow.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                itemRow.BorderSizePixel = 0
                itemRow.Parent = scrollingFrameRef

                local rowCorner = Instance.new("UICorner")
                rowCorner.CornerRadius = UDim.new(0, 6)
                rowCorner.Parent = itemRow

                -- Oyuncu Adı
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

                -- TP Butonu
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

                -- TP Butonuna Basıldığında Çalışacak Kod
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

    -- Oyuncu giriş/çıkışlarında listeyi otomatik güncelle
    table.insert(playerConnections, Players.PlayerAdded:Connect(refreshList))
    table.insert(playerConnections, Players.PlayerRemoving:Connect(refreshList))
end

local function hidePlayerListWindow()
    if playerListGui then
        playerListGui.Enabled = false
    end
end

-- Toggle Bağlantısı
createModernToggle("TP Player Menüsü", "Oyuncu listesi penceresini açar/kapatır.", function(state)
    if state then
        createPlayerListWindow()
    else
        hidePlayerListWindow()
    end
end)

-- 26. X TUŞU İLE CLICK TP (Bypass & Anti-Rubberband Destekli)
local clickTPXActive = false

createModernToggle("Click TP (X Tuşu)", "Fareyi nereye tutarsan X tuşuna basınca oraya ışınlanırsın.", function(state)
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
                    -- Anti-cheat'in velocity (hız) algoritmalarını kandırmak için hızı sıfırlıyoruz
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    
                    -- Yerin içine gömülmemek için hafif yukarıda başlatıyoruz
                    hrp.CFrame = CFrame.new(targetPos + Vector3.new(0, 3, 0))
                    
                    -- Pozisyon değiştikten sonra hızı tekrar sıfırlayarak geri atılmayı (rubber-band) azaltıyoruz
                    task.defer(function()
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end)
                end
            end
        end)
    end
end)

-- 27. AUTO FOLLOW & LOCK SYSTEM
local followEnabled = false
createModernToggle("Auto Follow/Lock", "En yakın oyuncuyu takip eder.", function(state)
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

-- Anti-Ragdoll System
local antiRagdollEnabled = false
local antiRagdollConnection = nil

createModernToggle("Anti-Ragdoll", "Yere kapaklanmayı ve sersemlemeyi önler.", function(state)
    antiRagdollEnabled = state
    
    if antiRagdollEnabled then
        if not antiRagdollConnection then
            antiRagdollConnection = RunService.RenderStepped:Connect(function()
                local char = player.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum then
                    if hum.PlatformStand then
                        hum.PlatformStand = false
                    end
                    local currentState = hum:GetState()
                    if currentState == Enum.HumanoidStateType.Ragdoll or currentState == Enum.HumanoidStateType.FallingDown then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    end
                end
            end)
        end
    else
        if antiRagdollConnection then
            antiRagdollConnection:Disconnect()
            antiRagdollConnection = nil
        end
    end
end)

-- 28. ANTI-AFK
local afkConn = nil
createModernToggle("Anti-AFK", "Sunucudan atılmayı engeller.", function(state)
    if state then
        afkConn = player.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end)
    else
        if afkConn then afkConn:Disconnect() end
    end
end)


-- 30. SMOOTH AIM
local smoothAimActive = false
local aimSpeed = 0.2

createModernToggle("Smooth Aim", "Yakındaki düşmana yumuşak geçişli kilitlenme.", function(state)
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

-- 31. MM2 ÖZEL AIMBOT & CROSSHAIR
local mm2AimbotEnabled = false
local mm2AimbotConnection = nil

-- Küçük bir crosshair oluşturalım (Drawing Kütüphanesi)
local crosshair = Drawing.new("Circle")
crosshair.Visible = false
crosshair.Radius = 3
crosshair.Filled = true
crosshair.Color = Color3.fromRGB(0, 255, 255) -- Cyan / Mavi tonlarında şık bir crosshair
crosshair.Transparency = 0.9

-- Yerel oyuncunun elinde/envanterinde Gun var mı kontrol eden fonksiyon
local function localHasGun()
    local localChar = player.Character
    local localBack = player:FindFirstChild("Backpack")
    return (localChar and localChar:FindFirstChild("Gun")) or (localBack and localBack:FindFirstChild("Gun"))
end

local function getTargetPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local currentCamera = workspace.CurrentCamera
    local localChar = player.Character
    local localRoot = localChar and localChar:FindFirstChild("HumanoidRootPart")

    if not localRoot then return nil end

    local hasGun = localHasGun()

    for _, targetPlayer in ipairs(Players:GetPlayers()) do
        if targetPlayer ~= player and targetPlayer.Character then
            local char = targetPlayer.Character
            local back = targetPlayer:FindFirstChild("Backpack")
            local hum = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head") -- Doğrudan kafa hedef alınır

            local targetHasKnife = (char:FindFirstChild("Knife") or (back and back:FindFirstChild("Knife")))
            local targetHasGun = (char:FindFirstChild("Gun") or (back and back:FindFirstChild("Gun")))

            -- Eğer bizim elimizde Gun varsa, sadece Knife olan kişiye (Katile) odaklan
            local isValidTarget = false
            if hasGun then
                isValidTarget = targetHasKnife
            else
                isValidTarget = targetHasKnife or targetHasGun
            end

            if isValidTarget and head and hum and hum.Health > 0 then
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

createModernToggle("MM2 Aimbot", "Silahın varsa direkt Katilin kafasına kilitlenir.", function(state)
    mm2AimbotEnabled = state
    crosshair.Visible = state
    
    if mm2AimbotEnabled then
        mm2AimbotConnection = RunService.RenderStepped:Connect(function()
            -- Crosshair'i ekranın tam merkezine sabitle
            local screenSize = workspace.CurrentCamera.ViewportSize
            crosshair.Position = screenSize / 2

            local targetPlayer = getTargetPlayer()
            local char = targetPlayer and targetPlayer.Character
            local head = char and char:FindFirstChild("Head")
            
            if head then
                local camera = workspace.CurrentCamera
                camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
            end
        end)
    else
        if mm2AimbotConnection then
            mm2AimbotConnection:Disconnect()
            mm2AimbotConnection = nil
        end
    end
end)

-- MM2 AUTO SHOOT (Elinde Gun varsa Katile otomatik sıkma)
local mm2AutoShootEnabled = false
local mm2AutoShootConn = nil

local function localHasGun()
	local localChar = player.Character
	local localBack = player:FindFirstChild("Backpack")
	return (localChar and localChar:FindFirstChild("Gun")) or (localBack and localBack:FindFirstChild("Gun"))
end

local function getKillerTarget()
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

			-- Sadece Katili (Knife taşıyanı) hedef al
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

createModernToggle("MM2 Auto Shoot", "Envanterinde Gun varsa Katile otomatik sıkar.", function(state)
	mm2AutoShootEnabled = state
	
	if mm2AutoShootEnabled then
		mm2AutoShootConn = RunService.RenderStepped:Connect(function()
			if not localHasGun() then return end
			
			local killer = getKillerTarget()
			if killer and killer.Character and killer.Character:FindFirstChild("Head") then
				local head = killer.Character.Head
				local camera = workspace.CurrentCamera
				
				-- Katilin kafasına kamerayı sabitle
				camera.CFrame = CFrame.new(camera.CFrame.Position, head.Position)
				
				-- Silahı ele al ve ateş et
				local localChar = player.Character
				local gun = localChar:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun")
				
				if gun then
					if gun.Parent ~= localChar then
						gun.Parent = localChar -- Silahı eline ver
					end
					pcall(function()
						gun:Activate() -- Otomatik ateş et
					end)
				end
			end
		end)
	else
		if mm2AutoShootConn then
			mm2AutoShootConn:Disconnect()
			mm2AutoShootConn = nil
		end
	end
end)

-- Metatable Bypass
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
