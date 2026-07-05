-- WorthNet UI System v4.3 - Search Engine, Notifications & Premium Expand
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
-- MERKEZİ BİLDİRİM SİSTEMİ (ALT ALTA SIRALAMA MOTORU)
---------------------------------------------------------
local activeNotifications = {}

local function rearrangeNotifications()
	for index, notif in ipairs(activeNotifications) do
		-- Her bildirim aralarında 10 piksel boşluk olacak şekilde alt alta hesaplanır
		local targetY = 20 + ((index - 1) * 60)
		TweenService:Create(notif, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(1, -240, 0, targetY)
		}):Play()
	end
end

local function showNotification(title, message, isSuccess)
	local notifFrame = Instance.new("Frame")
	notifFrame.Size = UDim2.new(0, 220, 0, 50)
	
	-- Giriş animasyonu için yine ekranın sağ dışından başlar
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
	
	-- Listeye ekle ve konumları güncelle
	table.insert(activeNotifications, notifFrame)
	rearrangeNotifications()
	
	-- Kapanış ve temizlik lojiği
	task.delay(2.5, function()
		-- Tablodan bu bildirimi kaldır
		local foundIndex = table.find(activeNotifications, notifFrame)
		if foundIndex then
			table.remove(activeNotifications, foundIndex)
		end
		
		-- Ekran dışına kayma animasyonu
		local currentY = notifFrame.Position.Y.Offset
		local closeTween = TweenService:Create(notifFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			Position = UDim2.new(1, 30, 0, currentY)
		})
		closeTween:Play()
		
		-- Diğer kalan bildirimleri yukarı kaydır
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

-- "All Hacks" Sekme Çerçevesi
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

---------------------------------------------------------
-- YENİ: ARAMA KUTUSU (SEARCH BAR)
---------------------------------------------------------
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

---------------------------------------------------------
-- YENİ: YOUTUBE SOSYAL MEDYA BUTONU
---------------------------------------------------------
local ytBtn = Instance.new("TextButton")
ytBtn.Size = UDim2.new(1, -20, 0, 35)
ytBtn.Position = UDim2.new(0, 10, 1, -45) -- Sidebar'ın en altında sabit durur
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

-- YouTube Linki Kopyalama / Tetikleme İşlemi
ytBtn.MouseButton1Click:Connect(function()
	-- Buraya kendi youtube linkini tırnak içine yaz reis
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

---------------------------------------------------------
-- ARAMA MOTORU LOJİĞİ (SEARCH FUNCTIONAL)
---------------------------------------------------------
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

---------------------------------------------------------
-- ÜST KONTROL BUTONLARI (— VE ✕)
---------------------------------------------------------
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

---------------------------------------------------------
-- DINAMIK TOGGLE MOTORU (OTOMATİK BİLDİRİM ENTEGRELİ)
---------------------------------------------------------
local function createModernToggle(name, description, callback)
	local cardFrame = Instance.new("Frame")
	cardFrame.Size = UDim2.new(1, -10, 0, 55)
	cardFrame.BackgroundColor3 = THEME.Card
	cardFrame.BorderSizePixel = 0
	cardFrame.ZIndex = 7
	cardFrame.Parent = contentArea
	roundCorners(cardFrame, 8)
	
	local title = Instance.new("TextLabel")
	title.Name = "HackyTitle" -- Arama motorunun bulabilmesi için özel isim tagı
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
	switch.MouseButton1Click:Connect(function()
		isOn = not isOn
		local targetPos = isOn and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		local targetColor = isOn and THEME.ToggleOn or THEME.ToggleOff
		
		TweenService:Create(pin, TweenInfo.new(0.18), {Position = targetPos}):Play()
		TweenService:Create(switch, TweenInfo.new(0.18), {BackgroundColor3 = targetColor}):Play()
		
		-- MERKEZİ BİLDİRİM TETİKLEYİCİSİ
		if isOn then
			showNotification(name, "Aktif edildi!", true)
		else
			showNotification(name, "Devre dışı bırakıldı.", false)
		end
		
		callback(isOn)
	end)
end

---------------------------------------------------------
-- HİLE AKTİVASYON ALANI (YENİLENMİŞ LİSTE)
---------------------------------------------------------
local noclipConnection = nil
local isFlying = false
local flySpeed = 50
local antiFlingConn = nil
local mm2ESPActive = false
local mm2Highlights = {}
local infJumpConn = nil
local bhopConn = nil
local originalSpeed = 16

-- 1. NOCLIP
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
createModernToggle("Fly Control", "Karakteri havada özgürce uçurur.", function(state)
	isFlying = state
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if isFlying and root then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "WorthNetVelocity"
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
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
		if root and root:FindFirstChild("WorthNetVelocity") then root.WorthNetVelocity:Destroy() end
	end
end)

-- 3. ANTI-FLING
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

-- 4. MM2 ESP
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

-- 5. SpeedHack (Otomatik Yenilenen & Agresif)
local speedHackActive = false
local originalSpeed = 16 -- Varsayılan hız

createModernToggle("SpeedHack", "Hızını 75 yapar ve 30s'de bir günceller.", function(state)
    speedHackActive = state
    
    if speedHackActive then
        task.spawn(function()
            while speedHackActive do
                local char = player.Character
                local hum = char and char:FindFirstChild("Humanoid")
                
                if hum then
                    -- Hızı her zaman 75'e zorla
                    if hum.WalkSpeed ~= 75 then
                        hum.WalkSpeed = 75
                    end
                end
                
                -- 30 saniye bekle ve döngüyü tazele
                task.wait(30)
                
                -- Eğer kapatıldıysa döngüden çık
                if not speedHackActive then break end
            end
        end)
    else
        -- Kapatıldığında hızı normale döndür
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum then
            hum.WalkSpeed = originalSpeed
        end
    end
end)

-- 6. INFINITE JUMP
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

-- 7. BHOP
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

-- 8. YENİ: FULLBRIGHT
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

-- 9. YENİ: NO FOG
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

-- 10. ANTI-VOID
local antiVoidConn = nil
createModernToggle("Anti-Void", "Boşluğa düşerek ölmeyi engeller.", function(state)
	if state then
		antiVoidConn = RunService.Heartbeat:Connect(function()
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if root then
				-- Eğer oyuncu Y ekseninde -50'den aşağı düşerse tetiklenir
				if root.Position.Y < -50 then
					root.Velocity = Vector3.new(0, 0, 0)
					-- Karakteri tekrar yukarıda güvenli bir koordinata taşır
					root.CFrame = root.CFrame + Vector3.new(0, 80, 0)
				end
			end
		end)
	else
		if antiVoidConn then antiVoidConn:Disconnect() antiVoidConn = nil end
	end
end)

-- 11. GUN ESP
local gunESPActive = false
local gunHighlight = nil

createModernToggle("Gun ESP", "Yerdeki silahı mor renkli gösterir.", function(state)
	gunESPActive = state
	if not gunESPActive then
		if gunHighlight then gunHighlight:Destroy() gunHighlight = nil end
	else
		task.spawn(function()
			while gunESPActive do
				task.wait(0.5) -- Sunucuyu yormamak için yarım saniyede bir tarar
				if not gunESPActive then break end
				
				-- Workspace içinde "Gun" isimli bir Tool arar
				local droppedGun = workspace:FindFirstChild("Gun", true)
				
				-- Bulunan nesne gerçekten bir Tool mu ve bir oyuncunun içinde değil mi kontrolü
				if droppedGun and droppedGun:IsA("Tool") and not droppedGun:FindFirstAncestorOfClass("Model"):FindFirstChild("Humanoid") then
					if not gunHighlight or gunHighlight.Parent ~= droppedGun then
						if gunHighlight then gunHighlight:Destroy() end
						
						-- Siyah renkli ESP efekti oluşturma
						gunHighlight = Instance.new("Highlight")
						gunHighlight.FillColor = Color3.fromRGB(150, 0, 255)      -- İç dolgu siyah
						gunHighlight.OutlineColor = Color3.fromRGB(80, 0, 150) -- Dış çizgi koyu gri
						gunHighlight.FillTransparency = 0.4
						gunHighlight.Parent = droppedGun
					end
				else
					if gunHighlight then gunHighlight:Destroy() gunHighlight = nil end
				end
			end
		end)
	end
end)

-- Auto-Aim & Auto-TP (Güncellenmiş)
local autoAimActive = false

local function toggleAutoAim(state)
    autoAimActive = state
    if state then
        showNotification("Auto-Aim", "Aktif! H'ye basarak kapat.", true)
        task.spawn(function()
            while autoAimActive do
                task.wait(0.01)
                local char = player.Character
                if char and (char:FindFirstChild("Knife") or char:FindFirstChild("Gun")) then
                    local targetPlayer = nil
                    local dist = 1000
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            local d = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
                            if d < dist then
                                dist = d
                                targetPlayer = p
                            end
                        end
                    end
                    
                    if targetPlayer then
                        -- Auto TP: Hedefe 3 stud mesafe kalana kadar ışınlan
                        if (char.HumanoidRootPart.Position - targetPlayer.Character.HumanoidRootPart.Position).Magnitude > 5 then
                            char.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        end
                        -- Auto Aim: Kilitleme
                        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, targetPlayer.Character.HumanoidRootPart.Position)
                    end
                end
            end
        end)
    else
        -- HİLEDEN ÇIKINCA SABİT KALAN MOUSE VE KAMERA SORUNU FİXİ
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        showNotification("Auto-Aim", "Devre dışı bırakıldı.", false)
    end
end

-- 13. SpinBot
local spinConn = nil
createModernToggle("SpinBot", "Etrafında çılgınca dönersin.", function(state)
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if state and root then
        spinConn = RunService.RenderStepped:Connect(function()
            root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(45), 0) -- Hız ayarı (45 derece)
        end)
    else
        if spinConn then spinConn:Disconnect() spinConn = nil end
    end
end)

-- 14. Hitbox Expander
local hitboxActive = false
createModernToggle("Hitbox Expander", "Rakiplerin kafalarını büyütür.", function(state)
    hitboxActive = state
    task.spawn(function()
        while hitboxActive do
            task.wait(1)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                    p.Character.Head.Size = Vector3.new(5, 5, 5)
                    p.Character.Head.Transparency = 0.5
                    p.Character.Head.CanCollide = false
                end
            end
        end
    end)
end)

-- 14. Inventory ESP (Envanter Tarayıcı)
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
                task.wait(1) -- Sunucuyu yormamak için 1 saniyelik tarama
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character then
                        local items = {}
                        -- 1. Elde tutulanı kontrol et
                        local tool = p.Character:FindFirstChildOfClass("Tool")
                        if tool then table.insert(items, tool.Name) end
                        
                        -- 2. Backpack (Sırt çantası) kontrol et
                        local back = p:FindFirstChild("Backpack")
                        if back then
                            for _, item in ipairs(back:GetChildren()) do
                                if item:IsA("Tool") then table.insert(items, item.Name) end
                            end
                        end
                        
                        -- ESP Tag oluştur/güncelle
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

-- 15. Teleport To Nearest Player
createModernToggle("TP Nearest", "En yakındaki oyuncunun yanına ışınlanırsın.", function(state)
    if state then
        local target = nil
        local dist = 1000
        
        -- En yakın oyuncuyu bul
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
        
        -- Işınlanma işlemi
        if target then
            player.Character.HumanoidRootPart.CFrame = target.CFrame * CFrame.new(0, 0, 2)
            showNotification("Teleport", "Oyuncuya ışınlanıldı!", true)
        else
            showNotification("Teleport", "Yakında oyuncu bulunamadı.", false)
        end
        
        -- Butonu otomatik kapat (sadece tıklandığında çalışması için)
        task.wait(0.5)
        -- Not: Burada butonun 'isOn' durumunu false yapacak logic ekleyebilirsin
    end
end)

-- 15. Fling System (Fixlendi - Hedefi Uçuran Versiyon)
createModernToggle("Fling System", "Hedefi sessizce haritadan atar.", function(state)
    _G.FlingEnabled = state
    task.spawn(function()
        while _G.FlingEnabled do
            task.wait(0.1)
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        local hrp = p.Character.HumanoidRootPart
                        local dist = (char.HumanoidRootPart.Position - hrp.Position).Magnitude
                        
                        -- Sadece 15 stud mesafeye girince tetiklen
                        if dist < 15 then
                            -- Fizik patlamasını sadece hedef oyuncu üzerinde tetikle
                            local bf = Instance.new("BodyForce", hrp)
                            bf.Force = Vector3.new(9e9, 9e9, 9e9) -- Hedefi anlık patlat
                            task.wait(0.1)
                            bf:Destroy()
                            
                            -- Sen sarsılma diye küçük bir bekleme
                            task.wait(0.5) 
                        end
                    end
                end
            end
        end
    end)
end)

-- 16. Anti-AFK
local afkConn = nil
createModernToggle("Anti-AFK", "Sunucudan atılmayı engeller.", function(state)
    if state then
        afkConn = Players.LocalPlayer.Idled:Connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
        end)
    else
        if afkConn then afkConn:Disconnect() end
    end
end)

-- 17. Rejoin Button (Tek tıkla çıkıp tekrar girer)
local TeleportService = game:GetService("TeleportService")

createModernToggle("Rejoin", "Aynı sunucuya tekrar bağlanır.", function(state)
    if state then
        local jobId = game.JobId
        TeleportService:Teleport(game.PlaceId, player)
    end
end)

-- 18. Smooth Aim (FPS Oyunları İçin Güvenli Auto-Aim)
local smoothAimActive = false
local aimSpeed = 0.1 -- Bu değeri düşürürsen daha yavaş (daha güvenli) kilitlenir

createModernToggle("Smooth Aim", "Yakındaki düşmana yumuşak geçişli kilitlenme.", function(state)
    smoothAimActive = state
    task.spawn(function()
        while smoothAimActive do
            task.wait()
            local closestPlayer = nil
            local shortestDist = math.huge
            
            -- En yakındaki düşmanı bul
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
            
            -- Yumuşak kilitlenme
            if closestPlayer and shortestDist < 200 then -- 200 piksel mesafe sınırı
                local targetCFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, closestPlayer.Position)
                workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(targetCFrame, aimSpeed)
            end
        end
    end)
end)

-- Arka plan bypass sistemi
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

-- Kesin Çözüm: Kamera Kilitlenme Fix
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = game:GetService("Players").LocalPlayer

local isFree = false
local loop = nil

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.P then -- P tuşu
        isFree = not isFree
        
        if isFree then
            -- Fareyi serbest bırak ama kamera sistemini bozma
            loop = RunService.RenderStepped:Connect(function()
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            end)
            showNotification("System", "Fare serbest bırakıldı!", true)
        else
            -- Döngüyü temizle ve kontrolü oyuna geri ver
            if loop then loop:Disconnect() end
            UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
            showNotification("System", "Kamera normal modda.", false)
        end
    end
end)
