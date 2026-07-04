-- WorthNet UI System v2 - Modern & Dynamic Architecture
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Ekrandaki eski arayüzleri temizle
local oldGui = player.PlayerGui:FindFirstChild("WorthNetHub") or player.PlayerGui:FindFirstChild("WorthNetGameMenu")
if oldGui then oldGui:Destroy() end

-- ANA EKRAN OLUŞTURMA
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WorthNetHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- RENK PALETİ (image_b961a7_2.png UYUMLU KOYU TEMA)
local THEME = {
	Background = Color3.fromRGB(24, 24, 28),
	Sidebar = Color3.fromRGB(18, 18, 20),
	Card = Color3.fromRGB(28, 28, 32),
	Accent = Color3.fromRGB(220, 130, 30), -- Altın/Turuncu Detay
	TextMain = Color3.fromRGB(240, 240, 245),
	TextDark = Color3.fromRGB(150, 150, 155),
	ToggleOn = Color3.fromRGB(220, 130, 30),
	ToggleOff = Color3.fromRGB(60, 60, 65)
}

-- YUVARLAK KÖŞE YARDIMCISI
local function roundCorners(obj, radius)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, radius or 8)
	uiCorner.Parent = obj
	return uiCorner
end

-- STRUKTUR DEĞİŞKENLERİ
local activeGameMenu = nil

-- HİLE MOTORLARI DEĞİŞKENLERİ
local noclipConnection = nil
local flyConnection = nil
local isFlying = false
local flySpeed = 50

---------------------------------------------------------
-- [FONKSİYON] OYUN ÖZEL MENÜSÜNÜ AÇMA (2. AŞAMA GUI)
---------------------------------------------------------
local function openGameMenu(gameName)
	screenGui.Enabled = false -- Ana menüyü gizle
	
	if activeGameMenu then activeGameMenu:Destroy() end
	
	local gameGui = Instance.new("ScreenGui")
	gameGui.Name = "WorthNetGameMenu"
	gameGui.ResetOnSpawn = false
	gameGui.Parent = player.PlayerGui
	activeGameMenu = gameGui
	
	-- Ana Çerçeve
	local mainFrame = Instance.new("Frame")
	mainFrame.Size = UDim2.new(0, 680, 0, 420)
	mainFrame.Position = UDim2.new(0.5, -340, 0.5, -210)
	mainFrame.BackgroundColor3 = THEME.Background
	mainFrame.BorderSizePixel = 0
	mainFrame.Parent = gameGui
	roundCorners(mainFrame, 12)
	
	-- Üst Bar (Title Bar)
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, 0, 0, 45)
	topBar.BackgroundColor3 = THEME.Sidebar
	topBar.BorderSizePixel = 0
	topBar.Parent = mainFrame
	roundCorners(topBar, 12)
	
	-- Başlık: <OyunAdı> WorthNet
	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(0, 300, 1, 0)
	titleLabel.Position = UDim2.new(0, 50, 0, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = gameName .. " | WorthNet"
	titleLabel.TextColor3 = THEME.TextMain
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 16
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = topBar
	
	-- Geri Dön Butonu (⬅️)
	local backBtn = Instance.new("TextButton")
	backBtn.Size = UDim2.new(0, 35, 0, 35)
	backBtn.Position = UDim2.new(0, 8, 0, 5)
	backBtn.BackgroundColor3 = THEME.Card
	backBtn.Text = "⬅️"
	backBtn.TextColor3 = THEME.TextMain
	backBtn.TextSize = 14
	backBtn.Parent = topBar
	roundCorners(backBtn, 6)
	
	backBtn.MouseButton1Click:Connect(function()
		gameGui:Destroy()
		-- Hileleri kapat temiz ayrıl
		if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
		isFlying = false
		screenGui.Enabled = true
	end)
	
	-- Kapatma Butonu (X)
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 35, 0, 35)
	closeBtn.Position = UDim2.new(1, -43, 0, 5)
	closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = THEME.TextMain
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 14
	closeBtn.Parent = topBar
	roundCorners(closeBtn, 6)
	
	closeBtn.MouseButton1Click:Connect(function()
		gameGui:Destroy()
		screenGui:Destroy()
		if noclipConnection then noclipConnection:Disconnect() end
	end)

	-- Sol Menü (Hile Listesi Alanı)
	local menuSidebar = Instance.new("Frame")
	menuSidebar.Size = UDim2.new(0, 180, 1, -45)
	menuSidebar.Position = UDim2.new(0, 0, 0, 45)
	menuSidebar.BackgroundColor3 = THEME.Sidebar
	menuSidebar.BorderSizePixel = 0
	menuSidebar.Parent = mainFrame
	
	-- Sağ İçerik Ekranı
	local contentArea = Instance.new("Frame")
	contentArea.Size = UDim2.new(1, -180, 1, -45)
	contentArea.Position = UDim2.new(0, 180, 0, 45)
	contentArea.BackgroundTransparency = 1
	contentArea.Parent = mainFrame
	
	local statusLabel = Instance.new("TextLabel")
	statusLabel.Size = UDim2.new(1, 0, 0, 40)
	statusLabel.Position = UDim2.new(0, 20, 0, 20)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = "Hile Durum Paneli - Ayarları Soldan Yönetin"
	statusLabel.TextColor3 = THEME.TextDark
	statusLabel.Font = Enum.Font.GothamSemibold
	statusLabel.TextSize = 14
	statusLabel.TextXAlignment = Enum.TextXAlignment.Left
	statusLabel.Parent = contentArea

	---------------------------------------------------------
	-- ÖZEL MODERN TOGGLE BUTONU EKLEME FONKSİYONU
	---------------------------------------------------------
	local toggleCount = 0
	local function createModernToggle(name, callback)
		local toggleFrame = Instance.new("Frame")
		toggleFrame.Size = UDim2.new(1, -20, 0, 40)
		toggleFrame.Position = UDim2.new(0, 10, 0, 15 + (toggleCount * 45))
		toggleFrame.BackgroundTransparency = 1
		toggleFrame.Parent = menuSidebar
		
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0, 100, 1, 0)
		label.BackgroundTransparency = 1
		label.Text = name
		label.TextColor3 = THEME.TextMain
		label.Font = Enum.Font.Gotham
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = toggleFrame
		
		-- image_b961e4_2.png stili oval Toggle şasisi
		local switch = Instance.new("TextButton")
		switch.Size = UDim2.new(0, 45, 0, 22)
		switch.Position = UDim2.new(1, -45, 0.5, -11)
		switch.BackgroundColor3 = THEME.ToggleOff
		switch.Text = ""
		switch.Parent = toggleFrame
		roundCorners(switch, 11)
		
		-- Buton içindeki kayan yuvarlak pin
		local pin = Instance.new("Frame")
		pin.Size = UDim2.new(0, 16, 0, 16)
		pin.Position = UDim2.new(0, 3, 0.5, -8)
		pin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		pin.Parent = switch
		roundCorners(pin, 8)
		
		local isOn = false
		switch.MouseButton1Click:Connect(function()
			isOn = not isOn
			
			-- Akıcı Kayma Animasyonu
			local targetPos = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
			local targetColor = isOn and THEME.ToggleOn or THEME.ToggleOff
			
			TweenService:Create(pin, TweenInfo.new(0.2), {Position = targetPos}):Play()
			TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
			
			callback(isOn)
		end)
		
		toggleCount = toggleCount + 1
	end

	-- 1. NOCLIP (DUVARLARDAN GEÇME) TEST MOTORU
	createModernToggle("Noclip", function(state)
		if state then
			noclipConnection = RunService.Stepped:Connect(function()
				local char = player.Character
				if char then
					for _, part in ipairs(char:GetDescendants()) do
						if part:IsA("BasePart") and part.CanCollide then
							part.CanCollide = false
						end
					end
				end
			end)
		else
			if noclipConnection then
				noclipConnection:Disconnect()
				noclipConnection = nil
			end
		end
	end)

	-- 2. FLY (UÇMA) TEST MOTORU
	createModernToggle("Fly Control", function(state)
		isFlying = state
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		
		if isFlying and root then
			local bv = Instance.new("BodyVelocity")
			bv.Name = "WorthNetFly"
			bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
			bv.Velocity = Vector3.new(0, 0, 0)
			bv.Parent = root
			
			task.spawn(function()
				while isFlying and root and root.Parent do
					local camera = workspace.CurrentCamera
					local moveDir = Vector3.new(0,0,0)
					
					if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camera.CFrame.LookVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camera.CFrame.LookVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camera.CFrame.RightVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camera.CFrame.RightVector end
					
					bv.Velocity = moveDir * flySpeed
					task.wait()
				end
				if bv then bv:Destroy() end
			end)
		else
			if root and root:FindFirstChild("WorthNetFly") then
				root.WorthNetFly:Destroy()
			end
		end
	end)
end

---------------------------------------------------------
-- 1. AŞAMA: ANA PANELSİZ (HUB) ARAYÜZ KURULUMU
---------------------------------------------------------
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 720, 0, 460)
hubFrame.Position = UDim2.new(0.5, -360, 0.5, -230)
hubFrame.BackgroundColor3 = THEME.Background
hubFrame.BorderSizePixel = 0
hubFrame.Parent = screenGui
roundCorners(hubFrame, 14)

-- Sürükleme Özelliği (Drag System)
local dragToggle, dragStart, startPos
hubFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragToggle = true
		dragStart = input.Position
		startPos = hubFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
		end)
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement and dragToggle then
		local delta = input.Position - dragStart
		hubFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Sol Sayfa Menüsü (Pages Sidebar)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.BackgroundColor3 = THEME.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = hubFrame
roundCorners(sidebar, 14)

local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(1, 0, 0, 50)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "👑 WorthNet Hub"
logoLabel.TextColor3 = THEME.Accent
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextSize = 18
logoLabel.Parent = sidebar

-- Sağ Büyük Oyun Arayüzü (XenoScripts Alanı)
local mainDisplay = Instance.new("Frame")
mainDisplay.Size = UDim2.new(1, -190, 1, -20)
mainDisplay.Position = UDim2.new(0, 190, 0, 10)
mainDisplay.BackgroundTransparency = 1
mainDisplay.Parent = hubFrame

-- Kapatma Düğmesi (Ana Hub)
local mainClose = Instance.new("TextButton")
mainClose.Size = UDim2.new(0, 30, 0, 30)
mainClose.Position = UDim2.new(1, -35, 0, 5)
mainClose.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
mainClose.Text = "✕"
mainClose.TextColor3 = THEME.TextDark
mainClose.Parent = mainDisplay
roundCorners(mainClose, 6)
mainClose.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- OYUN LİSTESİ DİZİSİ (Tam 10 Adet Popüler Oyun)
local totalGames = {
	"Murder Mystery 2", "Brookhaven RP", "Blox Fruits", "BedWars", 
	"Adopt Me!", "Arsenal", "Pet Simulator 99", "Evade", 
	"Door's", "Blade Ball"
}

-- Sayfaları ve Tıklama Sistemini Kurma
local activePage = nil
local function setupPages()
	for i = 1, 5 do
		local pageBtn = Instance.new("TextButton")
		pageBtn.Size = UDim2.new(1, -20, 0, 40)
		pageBtn.Position = UDim2.new(0, 10, 0, 60 + ((i - 1) * 48))
		pageBtn.BackgroundColor3 = (i == 1) and THEME.Card or Color3.fromRGB(30, 30, 35)
		pageBtn.Text = "   Page " .. i
		pageBtn.TextColor3 = (i == 1) and THEME.TextMain or THEME.TextDark
		pageBtn.Font = Enum.Font.GothamSemibold
		pageBtn.TextSize = 13
		pageBtn.TextXAlignment = Enum.TextXAlignment.Left
		pageBtn.Parent = sidebar
		roundCorners(pageBtn, 8)
		
		-- Sadece Page 1 İçeriği Aktif Olacak
		if i == 1 then
			-- Izgara Düzenleyici (Grid Layout)
			local grid = Instance.new("UIGridLayout")
			grid.CellSize = UDim2.new(0, 240, 0, 65)
			grid.CellPadding = UDim2.new(0, 15, 0, 15)
			grid.SortOrder = Enum.SortOrder.LayoutOrder
			grid.Parent = mainDisplay
			
			-- 10 Oyunu Grid Alanına Dizme
			for index, gameName in ipairs(totalGames) do
				local gameCard = Instance.new("TextButton")
				gameCard.BackgroundColor3 = THEME.Card
				gameCard.Text = "🎮 " .. gameName
				gameCard.TextColor3 = THEME.TextMain
				gameCard.Font = Enum.Font.GothamBold
				gameCard.TextSize = 14
				gameCard.Parent = mainDisplay
				roundCorners(gameCard, 10)
				
				-- Efekt: Üzerine Gelince Renk Değişimi
				gameCard.MouseEnter:Connect(function()
					TweenService:Create(gameCard, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent}):Play()
				end)
				gameCard.MouseLeave:Connect(function()
					TweenService:Create(gameCard, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Card}):Play()
				end)
				
				-- Tıklayınca 2. Aşama Arayüze Geçiş
				gameCard.MouseButton1Click:Connect(function()
					openGameMenu(gameName)
				end)
			end
		end
	end
end

setupPages()
