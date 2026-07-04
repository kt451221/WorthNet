-- WORTHNET MULTI-GAME HUB V0.5 | MM2 & ALL FEATURES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if CoreGui:FindFirstChild("WorthNetHub") then
	CoreGui:FindFirstChild("WorthNetHub"):Destroy()
end

local guiParent = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

-- ────────────────────────────────────────────────
-- UI TEMEL YAPISI
-- ────────────────────────────────────────────────
local screenGui = Instance.new("ScreenGui", guiParent)
screenGui.Name = "WorthNetHub"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 520)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -260)
mainFrame.BackgroundColor3 = Color3.fromRGB(107, 50, 124)
mainFrame.Active = true
mainFrame.Draggable = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(0, 255, 100)
mainStroke.Thickness = 1.5

local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 70)
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleFix = Instance.new("Frame", titleBar)
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(0, 200, 70)
titleFix.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ WORTHNET MULTI-HUB V0.5"
titleLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16

-- Hız Ayar Kutusu (Speed Input)
local speedBox = Instance.new("TextBox", mainFrame)
speedBox.Size = UDim2.new(1, -20, 0, 35)
speedBox.Position = UDim2.new(0, 10, 0, 55)
speedBox.PlaceholderText = "⚡ Hız Ayarla (Örn: 50)"
speedBox.Text = "50"
speedBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedBox.TextColor3 = Color3.fromRGB(0, 255, 100)
speedBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 13
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

-- Oyun Sekme Menüsü
local tabScroll = Instance.new("ScrollingFrame", mainFrame)
tabScroll.Size = UDim2.new(1, -20, 0, 35)
tabScroll.Position = UDim2.new(0, 10, 0, 95)
tabScroll.BackgroundTransparency = 1
tabScroll.ScrollBarThickness = 0
tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
local tabLayout = Instance.new("UIListLayout", tabScroll)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 8)

-- Arama Çubuğu
local searchBox = Instance.new("TextBox", mainFrame)
searchBox.Size = UDim2.new(1, -20, 0, 35)
searchBox.Position = UDim2.new(0, 10, 0, 135)
searchBox.PlaceholderText = "🔍 Hile Ara..."
searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
searchBox.TextColor3 = Color3.fromRGB(0, 255, 100)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 13
Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

-- Hile İçerik Listesi
local contentScroll = Instance.new("ScrollingFrame", mainFrame)
contentScroll.Size = UDim2.new(1, 0, 1, -185)
contentScroll.Position = UDim2.new(0, 0, 0, 180)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 4
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local contentLayout = Instance.new("UIListLayout", contentScroll)
contentLayout.Padding = UDim.new(0, 6)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ────────────────────────────────────────────────
-- DİNAMİK ALTYAPI MOTORU
-- ────────────────────────────────────────────────
local currentTab = "ALL"
local allButtons = {}

local function filterFeatures()
	local searchText = searchBox.Text:lower()
	for _, item in ipairs(allButtons) do
		local matchesTab = (currentTab == "ALL") or (item.Game == currentTab)
		local matchesSearch = (searchText == "") or (item.Name:lower():find(searchText))
		item.Instance.Visible = matchesTab and matchesSearch
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(filterFeatures)

local tabButtonsList = {}
local function selectTab(tabName, tabButton)
	currentTab = tabName
	for _, btn in ipairs(tabButtonsList) do
		btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	end
	tabButton.BackgroundColor3 = Color3.fromRGB(0, 60, 25)
	tabButton.TextColor3 = Color3.fromRGB(0, 255, 100)
	filterFeatures()
end

local function createTab(tabName)
	local btn = Instance.new("TextButton", tabScroll)
	btn.Text = tabName
	btn.Size = UDim2.new(0, 100, 0, 30)
	btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 12
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
	table.insert(tabButtonsList, btn)
	btn.MouseButton1Click:Connect(function() selectTab(tabName, btn) end)
	if tabName == "ALL" then selectTab("ALL", btn) end
end

local function addToggle(gameName, featureName, callback)
	local isTargetOn = false
	local btn = Instance.new("TextButton", contentScroll)
	btn.Text = string.format("[%s] [OFF] %s", gameName, featureName)
	btn.Size = UDim2.new(0.92, 0, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	btn.TextColor3 = Color3.fromRGB(160, 160, 160)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", btn)
	stroke.Color = Color3.fromRGB(40, 40, 40)
	
	btn.MouseButton1Click:Connect(function()
		isTargetOn = not isTargetOn
		if isTargetOn then
			btn.Text = string.format("[%s] [ON] %s", gameName, featureName)
			btn.TextColor3 = Color3.fromRGB(0, 255, 100)
			btn.BackgroundColor3 = Color3.fromRGB(0, 45, 15)
			stroke.Color = Color3.fromRGB(0, 255, 100)
		else
			btn.Text = string.format("[%s] [OFF] %s", gameName, featureName)
			btn.TextColor3 = Color3.fromRGB(160, 160, 160)
			btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			stroke.Color = Color3.fromRGB(40, 40, 40)
		end
		callback(isTargetOn)
	end)
	
	table.insert(allButtons, {Name = featureName, Game = gameName, Instance = btn})
end

-- ────────────────────────────────────────────────
-- HİLE KOD HAFIZASI & DÖNGÜLERİ
-- ────────────────────────────────────────────────
_G.WorthSpeed = false
_G.WorthNoclip = false
_G.WorthFly = false
_G.WorthAntiVoid = false
_G.WorthESP = false
_G.WorthMM2ESP = false

-- Hız Döngüsü (Speed Loop)
task.spawn(function()
	while true do
		task.wait(0.1)
		if _G.WorthSpeed and player.Character and player.Character:FindFirstChild("Humanoid") then
			local targetSpeed = tonumber(speedBox.Text) or 16
			player.Character.Humanoid.WalkSpeed = targetSpeed
		end
	end
end)

-- Noclip Döngüsü
RunService.Stepped:Connect(function()
	if _G.WorthNoclip and player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Anti-Void Sistem (Boşluğa düşüp ölmeyi engeller, yukarı ışınlar)
task.spawn(function()
	while true do
		task.wait(0.5)
		if _G.WorthAntiVoid and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local root = player.Character.HumanoidRootPart
			if root.Position.Y < -20 then -- Eğer haritanın altına düşerse
				root.Velocity = Vector3.new(0,0,0)
				root.CFrame = root.CFrame + Vector3.new(0, 50, 0) -- 50 blok yukarı atar
			end
		end
	end
end)

-- Gelişmiş ESP Sistemi (Drawing API kullanmadan, her exploit'te çalışan Highlight mantığı)
local function applyESP(targetPlayer)
	if targetPlayer == player then return end
	
	local function createESP()
		if not _G.WorthESP and not _G.WorthMM2ESP then return end
		local char = targetPlayer.Character
		if char then
			if not char:FindFirstChild("WorthHighlight") then
				local hl = Instance.new("Highlight")
				hl.Name = "WorthHighlight"
				hl.Parent = char
				hl.FillTransparency = 0.5
				hl.OutlineThickness = 1
				
				-- MM2 Rol Kontrolü (Sahte oyunlar dahil eşya tespiti)
				if _G.WorthMM2ESP then
					local isMurder = char:FindFirstChild("Knife") or targetPlayer.Backpack:FindFirstChild("Knife")
					local isSheriff = char:FindFirstChild("Gun") or targetPlayer.Backpack:FindFirstChild("Gun")
					
					if isMurder then
						hl.FillColor = Color3.fromRGB(255, 0, 0) -- Katil Kırmızı
						hl.OutlineColor = Color3.fromRGB(255, 0, 0)
					elseif isSheriff then
						hl.FillColor = Color3.fromRGB(0, 0, 255) -- Şerif Mavi
						hl.OutlineColor = Color3.fromRGB(0, 0, 255)
					else
						hl.FillColor = Color3.fromRGB(0, 255, 0) -- Masum Yeşil
						hl.OutlineColor = Color3.fromRGB(0, 255, 0)
					end
				else
					-- Normal Oyuncu ESP
					hl.FillColor = Color3.fromRGB(0, 255, 100)
					hl.OutlineColor = Color3.fromRGB(255, 255, 255)
				end
			end
		end
	end
	
	targetPlayer.CharacterAdded:Connect(function()
		task.wait(0.5)
		createESP()
	end)
	createESP()
end

-- ESP Güncelleyici Döngü
task.spawn(function()
	while true do
		task.wait(1)
		if _G.WorthESP or _G.WorthMM2ESP then
			for _, p in ipairs(Players:GetPlayers()) do
				applyESP(p)
			end
		else
			for _, p in ipairs(Players:GetPlayers()) do
				if p.Character and p.Character:FindFirstChild("WorthHighlight") then
					p.Character.WorthHighlight:Destroy()
				end
			end
		end
	end
end)

-- Fly (Uçma) Kontrolü
local bv, bg
local function toggleFly(on)
	_G.WorthFly = on
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if on and root then
		bv = Instance.new("BodyVelocity", root)
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bv.Velocity = Vector3.new(0, 0.1, 0)
		bg = Instance.new("BodyGyro", root)
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.CFrame = root.CFrame
		task.spawn(function()
			while _G.WorthFly and root and root.Parent do
				local cam = Workspace.CurrentCamera
				local moveDir = Vector3.new(0, 0, 0)
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
				bv.Velocity = (moveDir.Magnitude > 0) and (moveDir.Unit * (tonumber(speedBox.Text) or 50)) or Vector3.new(0, 0.1, 0)
				bg.CFrame = cam.CFrame
				task.wait()
			end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end

-- ────────────────────────────────────────────────
-- KATEGORİLER VE SEKMELERİ OLUŞTURMA
-- ────────────────────────────────────────────────
createTab("ALL")
createTab("MM2")
createTab("BROOKHAVEN")
createTab("BLOX FRUITS")

-- ALL (GENEL HİLELER) BUTONLARI
addToggle("ALL", "WalkSpeed (Hızlı Koşma)", function(on) _G.WorthSpeed = on end)
addToggle("ALL", "Noclip (Duvar Geçme)", function(on) _G.WorthNoclip = on end)
addToggle("ALL", "Fly (Uçma Hilesi)", function(on) toggleFly(on) end)
addToggle("ALL", "Anti-Void (Düşmeyi Engelle)", function(on) _G.WorthAntiVoid = on end)
addToggle("ALL", "Player ESP (Oyuncu Gösterme)", function(on) _G.WorthESP = on end)

-- MM2 BUTONLARI
addToggle("MM2", "MM2 Role ESP (Katil/Şerif Göster)", function(on) _G.WorthMM2ESP = on end)

addToggle("MM2", "Teleport to Murderer (Katile Işınlan)", function(on)
	if not on then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				end
				break
			end
		end
	end
end)

addToggle("MM2", "Teleport to Sheriff (Şerife Işınlan)", function(on)
	if not on then return end
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then
				if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					player.Character.HumanoidRootPart.CFrame = p.Character.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
				end
				break
			end
		end
	end
end)

filterFeatures()
