-- WorthNet UI System v3 - Clean & Single Page Architecture
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- Ekrandaki eski arayüzleri temizle
local oldGui = player.PlayerGui:FindFirstChild("WorthNetHub")
if oldGui then oldGui:Destroy() end

-- ANA EKRAN OLUŞTURMA
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "WorthNetHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = player.PlayerGui

-- RENK PALETİ (Koyu tema ve altın/turuncu detaylar)
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

-- KÖŞE YUVARLAMA YARDIMCISI
local function roundCorners(obj, radius)
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, radius or 8)
	uiCorner.Parent = obj
	return uiCorner
end

-- ANA FRAME
local hubFrame = Instance.new("Frame")
hubFrame.Size = UDim2.new(0, 600, 0, 380)
hubFrame.Position = UDim2.new(0.5, -300, 0.5, -190)
hubFrame.BackgroundColor3 = THEME.Background
hubFrame.BorderSizePixel = 0
hubFrame.Parent = screenGui
roundCorners(hubFrame, 12)

-- SÜRÜKLEME MOTORU (Drag System)
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

-- SOL SİDEBAR (Menü Alanı)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 160, 1, 0)
sidebar.BackgroundColor3 = THEME.Sidebar
sidebar.BorderSizePixel = 0
sidebar.Parent = hubFrame
roundCorners(sidebar, 12)

-- Başlık: WorthNet
local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(1, 0, 0, 50)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "👑 WorthNet"
logoLabel.TextColor3 = THEME.Accent
logoLabel.Font = Enum.Font.GothamBold
logoLabel.TextSize = 18
logoLabel.Parent = sidebar

-- Tek Sekme: All Hacks
local allHacksBtn = Instance.new("Frame")
allHacksBtn.Size = UDim2.new(1, -20, 0, 40)
allHacksBtn.Position = UDim2.new(0, 10, 0, 60)
allHacksBtn.BackgroundColor3 = THEME.Card
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
allHacksLabel.Parent = allHacksBtn

-- SAĞ İÇERİK ALANI (Hilelerin Listeleneceği Yer)
local contentArea = Instance.new("ScrollingFrame")
contentArea.Size = UDim2.new(1, -180, 1, -60)
contentArea.Position = UDim2.new(0, 170, 0, 50)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.CanvasSize = UDim2.new(0, 0, 0, 0) -- İçerik büyüdükçe otomatik uzar
contentArea.ScrollBarThickness = 4
contentArea.ScrollBarImageColor3 = THEME.Accent
contentArea.Parent = hubFrame

-- Liste Düzenleyici (Liste şeklinde alt alta dizer)
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 10)
uiListLayout.Parent = contentArea

-- KAPATMA BUTONU (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
closeBtn.Text = "✕"
closeBtn.TextColor3 = THEME.TextDark
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = hubFrame
roundCorners(closeBtn, 6)
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

---------------------------------------------------------
-- [DİNAMİK MOTOR] TOGGLE BUTON OLUŞTURMA FONKSİYONU
---------------------------------------------------------
local function createModernToggle(name, description, callback)
	local cardFrame = Instance.new("Frame")
	cardFrame.Size = UDim2.new(1, -10, 0, 55)
	cardFrame.BackgroundColor3 = THEME.Card
	cardFrame.BorderSizePixel = 0
	cardFrame.Parent = contentArea
	roundCorners(cardFrame, 8)
	
	-- Hile Adı
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(0, 200, 0, 25)
	title.Position = UDim2.new(0, 15, 0, 5)
	title.BackgroundTransparency = 1
	title.Text = name
	title.TextColor3 = THEME.TextMain
	title.Font = Enum.Font.GothamBold
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = cardFrame
	
	-- Hile Açıklaması
	local desc = Instance.new("TextLabel")
	desc.Size = UDim2.new(0, 250, 0, 20)
	desc.Position = UDim2.new(0, 15, 0, 26)
	desc.BackgroundTransparency = 1
	desc.Text = description
	desc.TextColor3 = THEME.TextDark
	desc.Font = Enum.Font.Gotham
	desc.TextSize = 11
	desc.TextXAlignment = Enum.TextXAlignment.Left
	desc.Parent = cardFrame
	
	-- Oval Switch Yapısı (image_b961e4_3.png stili)
	local switch = Instance.new("TextButton")
	switch.Size = UDim2.new(0, 45, 0, 22)
	switch.Position = UDim2.new(1, -60, 0.5, -11)
	switch.BackgroundColor3 = THEME.ToggleOff
	switch.Text = ""
	switch.Parent = cardFrame
	roundCorners(switch, 11)
	
	-- İçindeki Beyaz Yuvarlak Pin
	local pin = Instance.new("Frame")
	pin.Size = UDim2.new(0, 16, 0, 16)
	pin.Position = UDim2.new(0, 3, 0.5, -8)
	pin.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	pin.Parent = switch
	roundCorners(pin, 8)
	
	local isOn = false
	switch.MouseButton1Click:Connect(function()
		isOn = not isOn
		
		-- Akıcı Kayma ve Renk Değişimi Animasyonu
		local targetPos = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		local targetColor = isOn and THEME.ToggleOn or THEME.ToggleOff
		
		TweenService:Create(pin, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos}):Play()
		TweenService:Create(switch, TweenInfo.new(0.18), {BackgroundColor3 = targetColor}):Play()
		
		callback(isOn)
	end)
end

---------------------------------------------------------
-- HİLE AKTİVASYON MOTORLARI (ARKA PLAN FONKSİYONLARI)
---------------------------------------------------------
local noclipConnection = nil
local isFlying = false
local flySpeed = 50

-- 1. NOCLIP EKLEME
createModernToggle("Noclip", "Duvarların ve engellerin içinden geçmenizi sağlar.", function(state)
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

-- 2. FLY EKLEME
createModernToggle("Fly Control", "Karakteri havada serbestçe uçurur (W,A,S,D).", function(state)
	isFlying = state
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	
	if isFlying and root then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "WorthNetVelocity"
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bv.Velocity = Vector3.new(0, 0, 0)
		bv.Parent = root
		
		task.spawn(function()
			while isFlying and root and root.Parent do
				local camera = workspace.CurrentCamera
				local moveDir = Vector3.new(0, 0, 0)
				
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
		if root and root:FindFirstChild("WorthNetVelocity") then
			root.WorthNetVelocity:Destroy()
		end
	end
end)
