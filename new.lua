-- WORTHNET MULTI-GAME HUB V0.4 | DEVELOPED BY AGA
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Re-exec önleme
if CoreGui:FindFirstChild("WorthNetHub") then
	CoreGui:FindFirstChild("WorthNetHub"):Destroy()
end

-- UI Parent Ayarı
local guiParent = pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or player:WaitForChild("PlayerGui")

-- ────────────────────────────────────────────────
-- ANA EKRAN VE TEMA (Neon Yeşil & Siyah)
-- ────────────────────────────────────────────────
local screenGui = Instance.new("ScreenGui", guiParent)
screenGui.Name = "WorthNetHub"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 380, 0, 500)
mainFrame.Position = UDim2.new(0.5, -190, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
mainFrame.BackgroundTransparency = 0.05
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = Color3.fromRGB(0, 255, 100)
mainStroke.Thickness = 1.5

-- Başlık Çubuğu
local titleBar = Instance.new("Frame", mainFrame)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 70)

Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)
local titleFix = Instance.new("Frame", titleBar) -- Alt köşeleri düzeltmek için
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(0, 200, 70)
titleFix.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ WORTHNET MULTI-HUB V0.4"
titleLabel.TextColor3 = Color3.fromRGB(10, 10, 10)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16

-- ────────────────────────────────────────────────
-- OYUN SEÇİM MENÜSÜ (Tabs)
-- ────────────────────────────────────────────────
local tabScroll = Instance.new("ScrollingFrame", mainFrame)
tabScroll.Size = UDim2.new(1, -20, 0, 40)
tabScroll.Position = UDim2.new(0, 10, 0, 55)
tabScroll.BackgroundTransparency = 1
tabScroll.ScrollBarThickness = 2
tabScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
tabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
tabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X

local tabLayout = Instance.new("UIListLayout", tabScroll)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 8)
tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center

-- ────────────────────────────────────────────────
-- ARAMA ÇUBUĞU (Search Bar)
-- ────────────────────────────────────────────────
local searchBox = Instance.new("TextBox", mainFrame)
searchBox.Size = UDim2.new(1, -20, 0, 35)
searchBox.Position = UDim2.new(0, 10, 0, 100)
searchBox.PlaceholderText = "🔍 Hile Ara..."
searchBox.Text = ""
searchBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
searchBox.TextColor3 = Color3.fromRGB(0, 255, 100)
searchBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.ClearTextOnFocus = false

Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)
local searchStroke = Instance.new("UIStroke", searchBox)
searchStroke.Color = Color3.fromRGB(40, 40, 40)
searchStroke.Thickness = 1

-- ────────────────────────────────────────────────
-- HİLE LİSTESİ (Main Content Scroll)
-- ────────────────────────────────────────────────
local contentScroll = Instance.new("ScrollingFrame", mainFrame)
contentScroll.Size = UDim2.new(1, 0, 1, -150)
contentScroll.Position = UDim2.new(0, 0, 0, 145)
contentScroll.BackgroundTransparency = 1
contentScroll.ScrollBarThickness = 4
contentScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 100)
contentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
contentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)

local contentLayout = Instance.new("UIListLayout", contentScroll)
contentLayout.Padding = UDim.new(0, 8)
contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- ────────────────────────────────────────────────
-- DİNAMİK SİSTEM MOTORU (Engine)
-- ────────────────────────────────────────────────
local currentTab = "ALL"
local allButtons = {}

-- Buton Filtreleme Fonksiyonu (Hem Kategori hem Arama için)
local function filterFeatures()
	local searchText = searchBox.Text:lower()
	for _, item in ipairs(allButtons) do
		local matchesTab = (currentTab == "ALL") or (item.Game == currentTab)
		local matchesSearch = (searchText == "") or (item.Name:lower():find(searchText))
		
		if matchesTab and matchesSearch then
			item.Instance.Visible = true
		else
			item.Instance.Visible = false
		end
	end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(filterFeatures)

-- Sekme Değiştirme Fonksiyonu
local function selectTab(tabName, tabButton, allTabButtons)
	currentTab = tabName
	for _, btn in ipairs(allTabButtons) do
		btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	end
	tabButton.BackgroundColor3 = Color3.fromRGB(0, 60, 25)
	tabButton.TextColor3 = Color3.fromRGB(0, 255, 100)
	filterFeatures()
end

-- Sekme Oluşturucu
local tabButtonsList = {}
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
	
	btn.MouseButton1Click:Connect(function()
		selectTab(tabName, btn, tabButtonsList)
	end)
	
	if tabName == "ALL" then
		selectTab("ALL", btn, tabButtonsList)
	end
end

-- Hile Aktif/Pasif Butonu Ekleme Fonksiyonu
local function addToggle(gameName, featureName, callback)
	local isTargetOn = false
	
	local btn = Instance.new("TextButton", contentScroll)
	btn.Text = string.format("[%s] [OFF] %s", gameName, featureName)
	btn.Size = UDim2.new(0.9, 0, 0, 40)
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
	
	table.insert(allButtons, {
		Name = featureName,
		Game = gameName,
		Instance = btn
	})
end

-- ────────────────────────────────────────────────
-- KATEGORİLERİ TANIMLA
-- ────────────────────────────────────────────────
createTab("ALL")
createTab("MM2")
createTab("BROOKHAVEN")
createTab("BLOX FRUITS")

-- ────────────────────────────────────────────────
-- HİLELERİ EKLE (İleride buraya yenilerini ekleyebilirsin)
-- ────────────────────────────────────────────────

-- KÜRESEL / GENEL HİLELER (ALL kategorisi hepsini kapsar)
addToggle("ALL", "Noclip (Duvarlardan Geçme)", function(on)
    _G.isNoclip = on
    -- Noclip kod bloğun buraya gelecek
end)

addToggle("ALL", "Fly (Uçma)", function(on)
    -- Uçma kod bloğun buraya gelecek
end)

-- MURDER MYSTERY 2 HİLELERİ
addToggle("MM2", "Murderer / Sheriff ESP", function(on)
    -- MM2 ESP kodları buraya
end)

addToggle("MM2", "Auto Collect Coins (Paraları Topla)", function(on)
    -- Otomatik para toplama kodları
end)

-- BROOKHAVEN HİLELERİ
addToggle("BROOKHAVEN", "Unlock All Cars (Tüm Arabalar)", function(on)
    -- Brookhaven araba açma scripti
end)

addToggle("BROOKHAVEN", "Teleport to Houses (Evlere Işınlan)", function(on)
    -- Evlere ışınlanma scripti
end)

-- BLOX FRUITS HİLELERİ
addToggle("BLOX FRUITS", "Auto Farm Level", function(on)
    -- Blox Fruits Auto Farm kodları
end)

addToggle("BLOX FRUITS", "Teleport to Fruits (Meyvelere Git)", function(on)
    -- Meyve ışınlanma kodları
end)

-- İlk açılışta filtrelemeyi tetikle
filterFeatures()
