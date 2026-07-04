-- WORTHNET CLIENT V0.6 | FULL FEATURES WITH FLING & MM2 ESP
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Debris = game:GetService("Debris")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera

-- VirtualInputManager güvenli yükleme
local VirtualInputManager
pcall(function()
	VirtualInputManager = game:GetService("VirtualInputManager")
end)

local guiParent
pcall(function() guiParent = game:GetService("CoreGui") end)
if not guiParent then guiParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

local player = Players.LocalPlayer

if CoreGui:FindFirstChild("WorthNetClient") then
	CoreGui:FindFirstChild("WorthNetClient"):Destroy()
end

local screenGui = Instance.new("ScreenGui", guiParent)
screenGui.Name = "WorthNetClient"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0.25, 0, 0.6, 0)
frame.Position = UDim2.new(0.5, -120, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(107, 50, 124)
frame.BackgroundTransparency = 0.05
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(255, 0, 127)
frameStroke.Thickness = 1.5

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

local titleFix = Instance.new("Frame", titleBar)
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(255, 0, 127)
titleFix.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ WORTHNET V0.6"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

local speedBox = Instance.new("TextBox", frame)
speedBox.Size = UDim2.new(0.88, 0, 0, 36)
speedBox.Position = UDim2.new(0.06, 0, 0, 52)
speedBox.PlaceholderText = "Hız (Max 500)"
speedBox.Text = "50"
speedBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
speedBox.TextColor3 = Color3.fromRGB(0, 255, 80)
speedBox.PlaceholderColor3 = Color3.fromRGB(0, 150, 50)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 14
speedBox.ClearTextOnFocus = false

local speedBoxCorner = Instance.new("UICorner", speedBox)
speedBoxCorner.CornerRadius = UDim.new(0, 8)
local speedBoxStroke = Instance.new("UIStroke", speedBox)
speedBoxStroke.Color = Color3.fromRGB(0, 255, 80)
speedBoxStroke.Thickness = 1

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, 0, 1, -98)
scroll.Position = UDim2.new(0, 0, 0, 95)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 80)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y

local scrollLayout = Instance.new("UIListLayout", scroll)
scrollLayout.Padding = UDim.new(0, 6)
scrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local scrollPadding = Instance.new("UIPadding", scroll)
scrollPadding.PaddingTop = UDim.new(0, 6)
scrollPadding.PaddingBottom = UDim.new(0, 6)

local states = {}

local function createToggleButton(text, callback)
	states[text] = false
	local btn = Instance.new("TextButton", scroll)
	btn.Text = "[ OFF ]  " .. text
	btn.Size = UDim2.new(0.88, 0, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	btn.TextColor3 = Color3.fromRGB(180, 180, 180)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.AutoButtonColor = false
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 8)
	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Color = Color3.fromRGB(50, 50, 50)
	btnStroke.Thickness = 1
	btn.MouseButton1Click:Connect(function()
		states[text] = not states[text]
		if states[text] then
			btn.Text = "[ ON ]  " .. text
			btn.TextColor3 = Color3.fromRGB(0, 255, 80)
			btn.BackgroundColor3 = Color3.fromRGB(0, 40, 15)
			btnStroke.Color = Color3.fromRGB(0, 255, 80)
		else
			btn.Text = "[ OFF ]  " .. text
			btn.TextColor3 = Color3.fromRGB(180, 180, 180)
			btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			btnStroke.Color = Color3.fromRGB(50, 50, 50)
		end
		callback(states[text])
	end)
	return btn
end

local function createButton(text, callback)
	local btn = Instance.new("TextButton", scroll)
	btn.Text = text
	btn.Size = UDim2.new(0.88, 0, 0, 38)
	btn.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	btn.TextColor3 = Color3.fromRGB(0, 255, 80)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 13
	btn.AutoButtonColor = false
	local btnCorner = Instance.new("UICorner", btn)
	btnCorner.CornerRadius = UDim.new(0, 8)
	local btnStroke = Instance.new("UIStroke", btn)
	btnStroke.Color = Color3.fromRGB(0, 255, 80)
	btnStroke.Thickness = 1
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- ────────────────────────────────────────────────
-- GLOBALS
_G.isAntiFling = false
_G.isFlingTroll = false
_G.isNoclip = false
_G.isMM2ESP = false
local mouse = player:GetMouse()

-- ────────────────────────────────────────────────
-- MOTORLAR VE ARKAPLAN DÖNGÜLERİ
-- ────────────────────────────────────────────────

-- Noclip Motoru
RunService.Stepped:Connect(function()
	if _G.isNoclip and player.Character then
		for _, part in ipairs(player.Character:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = false
			end
		end
	end
end)

-- Anti-Fling Koruma Motoru
RunService.Heartbeat:Connect(function()
	if _G.isAntiFling and player.Character then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				local enemyRoot = p.Character:FindFirstChild("HumanoidRootPart")
				if enemyRoot then
					if enemyRoot.Velocity.Magnitude > 75 or enemyRoot.RotVelocity.Magnitude > 75 then
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
	end
end)

-- MM2 Rol Bulucu & ESP Döngüsü
local mm2Highlights = {}
RunService.Heartbeat:Connect(function()
	if not _G.isMM2ESP then
		for _, hl in pairs(mm2Highlights) do if hl then hl:Destroy() end end
		table.clear(mm2Highlights)
		return
	end

	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local roleColor = Color3.fromRGB(0, 255, 0) -- Varsayılan Masum (Mor)
			
			-- Silah/Bıçak kontrolü ile rol analizi
			local backpack = p:FindFirstChild("Backpack")
			local character = p.Character
			
			if (backpack and backpack:FindFirstChild("Knife")) or (character and character:FindFirstChild("Knife")) then
				roleColor = Color3.fromRGB(255, 0, 0) -- Katil (Kırmızı)
			elseif (backpack and backpack:FindFirstChild("Gun")) or (character and character:FindFirstChild("Gun")) then
				roleColor = Color3.fromRGB(0, 100, 255) -- Şerif (Koyu Mavi)
			end

			if not mm2Highlights[p.Name] or mm2Highlights[p.Name].Parent ~= character then
				if mm2Highlights[p.Name] then mm2Highlights[p.Name]:Destroy() end
				local hl = Instance.new("Highlight", character)
				hl.FillTransparency = 0.5
				hl.OutlineTransparency = 0.2
				mm2Highlights[p.Name] = hl
			end
			
			mm2Highlights[p.Name].FillColor = roleColor
			mm2Highlights[p.Name].OutlineColor = roleColor
		end
	end
end)

-- ────────────────────────────────────────────────
-- BUTONLAR VE İŞLEVLER
-- ────────────────────────────────────────────────

-- 1. HIZ UYGULA
createButton("⚡ Hızı Uygula", function()
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = math.min(tonumber(speedBox.Text) or 50, 500)
	end
end)

-- 2. NOCLIP
createToggleButton("Noclip", function(on)
	_G.isNoclip = on
end)

-- 3. FAKE CHAT SYSTEM TROLL
local fakeChatBox = Instance.new("TextBox", frame)
fakeChatBox.Size = UDim2.new(0.88, 0, 0, 36)
fakeChatBox.Position = UDim2.new(0.06, 0, 0, 92)
fakeChatBox.PlaceholderText = "Korkutulacak Oyuncu Adı"
fakeChatBox.Text = ""
fakeChatBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fakeChatBox.TextColor3 = Color3.fromRGB(255, 255, 255)
fakeChatBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
fakeChatBox.Font = Enum.Font.Gotham
fakeChatBox.TextSize = 14
fakeChatBox.ClearTextOnFocus = false

local fakeChatBoxCorner = Instance.new("UICorner", fakeChatBox)
fakeChatBoxCorner.CornerRadius = UDim.new(0, 8)
local fakeChatBoxStroke = Instance.new("UIStroke", fakeChatBox)
fakeChatBoxStroke.Color = Color3.fromRGB(107, 50, 124)
fakeChatBoxStroke.Thickness = 1

createButton("🚨 Sahte Ban Uyarısı Geç", function()
	local targetName = fakeChatBox.Text
	if targetName == "" then targetName = "UnknownPlayer" end
	
	local fakeMessage = "                                                                                \n[SYSTEM]: " .. targetName .. " has been flagged for cheating and will be banned shortly."
	
	local TextChatService = game:GetService("TextChatService")
	if TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
		local generalChannel = TextChatService:FindFirstChild("RBXGeneral", true) or TextChatService:FindFirstChild("TextChannels", true):FindFirstChild("RBXGeneral")
		if generalChannel then
			generalChannel:SendAsync(fakeMessage)
		end
	else
		local SayMessageRequest = game:GetService("ReplicatedStorage"):FindFirstChild("DefaultChatSystemChatEvents") 
			and game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents:FindFirstChild("SayMessageRequest")
		if SayMessageRequest then
			SayMessageRequest:FireServer(fakeMessage, "All")
		end
	end
end)

-- 4. ANTI-FLING KANAL BUTONU
createToggleButton("Anti-Fling Kalkanı", function(on)
	_G.isAntiFling = on
end)

-- 5. FLING TROLL BUTONU (ASLA UÇURMAYAN YENİ NESİL MOTOR)
createToggleButton("Fling", function(on)
	_G.isFlingTroll = on
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	local hum = char and char:FindFirstChild("Humanoid")
	
	if on and root and hum then
		-- Karakterin animasyonlarını ve fiziksel dengesini dondur
		hum.PlatformStand = true
		
		-- Karakter parçalarının birbirine çarpıp glitch yapmasını engelle
		task.spawn(function()
			while _G.isFlingTroll and char and char.Parent do
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
				RunService.Heartbeat:Wait()
			end
		end)

		-- Eski BodyVelocity yerine modern AngularVelocity nesnesi kuruyoruz
		local att = Instance.new("Attachment", root)
		att.Name = "FlingAttachment"
		
		local angVel = Instance.new("AngularVelocity", root)
		angVel.Name = "FlingSpin"
		angVel.Attachment0 = att
		-- Aşırı yüksek değerler (99999 gibi) motoru çökertir, kararlı maksimum devir:
		angVel.AngularVelocity = Vector3.new(0, 25000, 0) 
		angVel.MaxTorque = 9e9
		angVel.RelativeTo = Enum.ActuatorRelativeTo.Attachment0

		-- Uçmanı kesin olarak engelleyen dikey kilit (LinearVelocity)
		local linVel = Instance.new("LinearVelocity", root)
		linVel.Name = "FlingAntiFly"
		linVel.Attachment0 = att
		-- Karakterin sadece X ve Z ekseninde yürümesini izin verir, Y eksenini (yukarı uçmayı) kilitler
		linVel.MaxForce = 9e9
		linVel.VectorVelocity = Vector3.new(0, 0, 0)
		linVel.RelativeTo = Enum.ActuatorRelativeTo.World

		-- Dönüş anında rakipleri algılayıp momentum transferi yapan itici güç
		task.spawn(function()
			while _G.isFlingTroll and root and root.Parent do
				-- Sadece yatayda küçük sarsıntılar üreterek rakiplerin hit kutusuna çarpar
				root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z) + Vector3.new(30, 0, 30)
				RunService.Heartbeat:Wait()
				if root and root.Parent then
					root.Velocity = Vector3.new(root.Velocity.X, 0, root.Velocity.Z) - Vector3.new(30, 0, 30)
				end
				RunService.Heartbeat:Wait()
			end
		end)
	else
		-- Kapatıldığında her şeyi tamamen temizle
		if root then
			if root:FindFirstChild("FlingAttachment") then root.FlingAttachment:Destroy() end
			if root:FindFirstChild("FlingSpin") then root.FlingSpin:Destroy() end
			if root:FindFirstChild("FlingAntiFly") then root.FlingAntiFly:Destroy() end
			root.Velocity = Vector3.new(0, 0, 0)
			root.RotVelocity = Vector3.new(0, 0, 0)
		end
		if hum then
			hum.PlatformStand = false
		end
		if char then
			for _, part in ipairs(char:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = true
				end
			end
		end
	end
end)

-- 6. MM2 ROLE ESP BUTONU
createToggleButton("MM2 Rol ESP", function(on)
	_G.isMM2ESP = on
end)
-- ────────────────────────────────────────────────
-- DİĞER FONKSİYONLAR (ESP, FLY, GOD)
-- ────────────────────────────────────────────────

local function createESPBox(player)
	local box = Drawing.new("Square")
	box.Visible = false
	box.Thickness = 1
	box.Color = Color3.fromRGB(0, 255, 0)
	box.Filled = false

	local label = Drawing.new("Text")
	label.Visible = false
	label.Center = true
	label.Outline = true
	label.Font = 2
	label.Size = 13
	label.Color = Color3.fromRGB(0, 255, 0)

	RunService.RenderStepped:Connect(function()
		if _G.isESPBox and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local root = player.Character.HumanoidRootPart
			local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

			if onScreen then
				box.Size = Vector2.new(1000 / pos.Z, 1000 / pos.Z)
				box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
				box.Visible = true

				label.Position = Vector2.new(pos.X, pos.Y + box.Size.Y / 2)
				label.Text = player.Name .. "\n" .. (player.Character:FindFirstChildOfClass("Tool") and player.Character:FindFirstChildOfClass("Tool").Name or "Empty")
				label.Visible = true
			else
				box.Visible = false
				label.Visible = false
			end
		else
			box:Remove()
			label:Remove()
		end
	end)
end

createToggleButton("Pro Box ESP", function(on)
	_G.isESPBox = on
	if on then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= Players.LocalPlayer then createESPBox(p) end
		end
	end
end)

createToggleButton("Fly", function(on)
	_G.isFly = on
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if on and root then
		bv = Instance.new("BodyVelocity", root)
		bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
		bv.Velocity = Vector3.new(0, 0, 0)
		bg = Instance.new("BodyGyro", root)
		bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bg.CFrame = root.CFrame
		task.spawn(function()
			while _G.isFly and root and root.Parent do
				local cam = workspace.CurrentCamera
				local moveDir = Vector3.new(0, 0, 0)
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir += cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir -= cam.CFrame.LookVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir -= cam.CFrame.RightVector end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir += cam.CFrame.RightVector end
				bv.Velocity = (moveDir.Magnitude > 0) and (moveDir.Unit * 250) or Vector3.new(0, 0.1, 0)
				bg.CFrame = cam.CFrame
				task.wait()
			end
		end)
	else
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

createToggleButton("God Mode", function(on)
	_G.isGod = on
end)

local espHighlights = {}
createToggleButton("Player ESP", function(on)
	if on then
		for _, p in pairs(Players:GetPlayers()) do
			if p ~= player and p.Character then
				if not espHighlights[p.Name] then
					local hl = Instance.new("Highlight", p.Character)
					hl.FillColor = Color3.fromRGB(0, 255, 80)
					hl.OutlineColor = Color3.fromRGB(0, 255, 80)
					hl.FillTransparency = 0.6
					espHighlights[p.Name] = hl
				end
			end
		end
	else
		for _, hl in pairs(espHighlights) do
			if hl then hl:Destroy() end
		end
		espHighlights = {}
	end
end)

-- ────────────────────────────────────────────────
-- SILENT AIM + FOV ÇEMBERİ
local Camera = workspace.CurrentCamera
_G.isSilentAim = false
_G.isAutoClicker = false
local autoClickerSpeedBox = Instance.new("TextBox", frame)
autoClickerSpeedBox.Size = UDim2.new(0.88, 0, 0, 36)
autoClickerSpeedBox.Position = UDim2.new(0.06, 0, 0, 97)
autoClickerSpeedBox.PlaceholderText = "Click interval (ms)"
autoClickerSpeedBox.Text = "100"
autoClickerSpeedBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
autoClickerSpeedBox.TextColor3 = Color3.fromRGB(0, 255, 80)
autoClickerSpeedBox.PlaceholderColor3 = Color3.fromRGB(0, 150, 50)
autoClickerSpeedBox.Font = Enum.Font.Gotham
autoClickerSpeedBox.TextSize = 14
autoClickerSpeedBox.ClearTextOnFocus = false
local autoClickerSpeedCorner = Instance.new("UICorner", autoClickerSpeedBox)
autoClickerSpeedCorner.CornerRadius = UDim.new(0, 8)
local autoClickerSpeedStroke = Instance.new("UIStroke", autoClickerSpeedBox)
autoClickerSpeedStroke.Color = Color3.fromRGB(0, 255, 80)
autoClickerSpeedStroke.Thickness = 1


local antiRagdollConnections = {}
local function setupAntiRagdoll()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if antiRagdollConnections[char] then return end

    local conn = hum.StateChanged:Connect(function(oldState, newState)
        if not _G.isAntiRagdoll then return end
        if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown or newState == Enum.HumanoidStateType.GettingUp then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.Running)
                hum.PlatformStand = false
                local root = char:FindFirstChild("HumanoidRootPart")
                if root then
                    root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end)
        end
    end)

    antiRagdollConnections[char] = conn
    char.AncestryChanged:Connect(function(_, parent)
        if not parent and antiRagdollConnections[char] then
            antiRagdollConnections[char]:Disconnect()
            antiRagdollConnections[char] = nil
        end
    end)
end

player.CharacterAdded:Connect(function()
    if _G.isFakeName then
        task.wait(1)
        createFakeNameGui()
    end
    if _G.isAntiRagdoll then
        task.wait(1)
        setupAntiRagdoll()
    end
end)


local function getNearestPlayer()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local target, nearest = nil, math.huge
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < nearest then nearest = dist; target = p end
        end
    end
    return target
end

local function getPlayersInfo()
    local info = {}
    for _, p in pairs(Players:GetPlayers()) do
        local hum = p.Character and p.Character:FindFirstChild("Humanoid")
        table.insert(info, p.Name .. " (" .. tostring(hum and math.floor(hum.Health) or "--") .. ")")
    end
    return table.concat(info, ", ")
end

local function getServerPing()
    local ping = math.floor((game:GetService("Stats"):FindFirstChild("Network"):FindFirstChild("IncomingReplicationLag") and game:GetService("Stats").Network.IncomingReplicationLag.Value or 0) * 1000)
    return ping
end

local chatEvents = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents") or ReplicatedStorage:FindFirstChild("Chat")

local FOVCircle = nil
pcall(function()
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Visible = false
    FOVCircle.Radius = 150
    FOVCircle.Color = Color3.fromRGB(255, 255, 255)
    FOVCircle.Thickness = 1
    FOVCircle.Filled = false
    FOVCircle.Transparency = 0.5
end)
if not FOVCircle then
    FOVCircle = {Visible = false, Position = Vector2.new(0,0)}
end

-- Sonra butonu tanımla
createToggleButton("Silent Aim", function(on)
    _G.isSilentAim = on
    FOVCircle.Visible = on
end)

createToggleButton("Auto Clicker", function(on)
    _G.isAutoClicker = on
end)


createToggleButton("Anti Ragdoll", function(on)
    _G.isAntiRagdoll = on
    if on then
        setupAntiRagdoll()
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.isSilentAim then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

task.spawn(function()
    while true do
        if _G.isAutoClicker then
            local interval = tonumber(autoClickerSpeedBox.Text) or 100
            interval = math.max(20, math.min(interval, 1000))
            pcall(function()
                if VirtualInputManager then
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end)
            task.wait(interval / 1000)
        else
            task.wait(0.1)
        end
    end
end)


local function handleSilentAim(self, method, args)
    if not _G.isSilentAim or method ~= "FireServer" or self.Name ~= "WeaponEvent" then return nil end
    local closest, shortestDist = nil, 150
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(p.Character.HumanoidRootPart.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if dist < shortestDist then
                    closest = p.Character.HumanoidRootPart
                    shortestDist = dist
                end
            end
        end
    end
    if closest then
        args[1] = closest.Position
        return true
    end
    return false
end

-- ────────────────────────────────────────────────
-- 8. INFINITE JUMP
_G.isInfJump = false

createToggleButton("Infinite Jump", function(on)
	_G.isInfJump = on
end)

UserInputService.JumpRequest:Connect(function()
	if _G.isInfJump then
		local hum = player.Character and player.Character:FindFirstChild("Humanoid")
		if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- ────────────────────────────────────────────────
-- 9. FULLBRIGHT
local origAmbient, origOutdoor, origBrightness

createToggleButton("FullBright", function(on)
	if on then
		origAmbient    = Lighting.Ambient
		origOutdoor    = Lighting.OutdoorAmbient
		origBrightness = Lighting.Brightness
		Lighting.Ambient        = Color3.new(1, 1, 1)
		Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		Lighting.Brightness     = 2
	else
		if origAmbient    then Lighting.Ambient        = origAmbient    end
		if origOutdoor    then Lighting.OutdoorAmbient = origOutdoor    end
		if origBrightness then Lighting.Brightness     = origBrightness end
	end
end)

-- ────────────────────────────────────────────────
-- 11. BTOOLS
local btoolMode = nil

local btoolFrame = Instance.new("Frame", scroll)
btoolFrame.Size = UDim2.new(0.88, 0, 0, 38)
btoolFrame.BackgroundTransparency = 1

local btoolLayout = Instance.new("UIListLayout", btoolFrame)
btoolLayout.FillDirection = Enum.FillDirection.Horizontal
btoolLayout.Padding = UDim.new(0, 6)

local function makeBtoolBtn(label, mode)
	local b = Instance.new("TextButton", btoolFrame)
	b.Size = UDim2.new(0.5, -3, 1, 0)
	b.Text = label
	b.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	b.TextColor3 = Color3.fromRGB(0, 255, 80)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	local c = Instance.new("UICorner", b) c.CornerRadius = UDim.new(0, 8)
	local s = Instance.new("UIStroke", b) s.Color = Color3.fromRGB(0,255,80) s.Thickness = 1
	b.MouseButton1Click:Connect(function()
		if btoolMode == mode then
			btoolMode = nil
			b.BackgroundColor3 = Color3.fromRGB(18,18,18)
		else
			btoolMode = mode
			b.BackgroundColor3 = Color3.fromRGB(0,40,15)
		end
	end)
end

makeBtoolBtn("🗑 Sil", "delete")
makeBtoolBtn("✋ Taşı", "move")

-- ────────────────────────────────────────────────
-- 12. TELEPORT LIST
local tpListVisible = false
local tpFrame = Instance.new("Frame", screenGui)
tpFrame.Size = UDim2.new(0, 220, 0, 300)
tpFrame.Position = UDim2.new(0.5, 130, 0.5, -150)
tpFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
tpFrame.Visible = false
tpFrame.Active = true
tpFrame.Draggable = true

local tpCorner = Instance.new("UICorner", tpFrame)
tpCorner.CornerRadius = UDim.new(0, 12)
local tpStroke = Instance.new("UIStroke", tpFrame)
tpStroke.Color = Color3.fromRGB(0, 255, 80)
tpStroke.Thickness = 1.5

local tpTitle = Instance.new("TextLabel", tpFrame)
tpTitle.Size = UDim2.new(1, 0, 0, 36)
tpTitle.Text = "📍 Teleport Listesi"
tpTitle.BackgroundColor3 = Color3.fromRGB(0, 200, 60)
tpTitle.TextColor3 = Color3.fromRGB(0,0,0)
tpTitle.Font = Enum.Font.GothamBold
tpTitle.TextSize = 13
tpTitle.BorderSizePixel = 0
local tpTitleCorner = Instance.new("UICorner", tpTitle)
tpTitleCorner.CornerRadius = UDim.new(0, 12)

local tpScroll = Instance.new("ScrollingFrame", tpFrame)
tpScroll.Size = UDim2.new(1, -10, 1, -46)
tpScroll.Position = UDim2.new(0, 5, 0, 41)
tpScroll.BackgroundTransparency = 1
tpScroll.ScrollBarThickness = 4
tpScroll.ScrollBarImageColor3 = Color3.fromRGB(0,255,80)
tpScroll.CanvasSize = UDim2.new(0,0,0,0)
tpScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
tpScroll.BorderSizePixel = 0

local tpLayout = Instance.new("UIListLayout", tpScroll)
tpLayout.Padding = UDim.new(0, 6)
tpLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function refreshTpList()
	for _, c in pairs(tpScroll:GetChildren()) do
		if not c:IsA("UIListLayout") then c:Destroy() end
	end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player then
			local nameLabel = Instance.new("TextLabel", tpScroll)
			nameLabel.Size = UDim2.new(0.92, 0, 0, 22)
			nameLabel.Text = "👤 " .. p.Name
			nameLabel.BackgroundTransparency = 1
			nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			nameLabel.Font = Enum.Font.GothamBold
			nameLabel.TextSize = 12

			local row = Instance.new("Frame", tpScroll)
			row.Size = UDim2.new(0.92, 0, 0, 32)
			row.BackgroundTransparency = 1
			local rowLayout = Instance.new("UIListLayout", row)
			rowLayout.FillDirection = Enum.FillDirection.Horizontal
			rowLayout.Padding = UDim.new(0, 5)

			local goBtn = Instance.new("TextButton", row)
			goBtn.Size = UDim2.new(0.5, -3, 1, 0)
			goBtn.Text = "➜ Git"
			goBtn.BackgroundColor3 = Color3.fromRGB(0, 40, 15)
			goBtn.TextColor3 = Color3.fromRGB(0, 255, 80)
			goBtn.Font = Enum.Font.Gotham
			goBtn.TextSize = 12
			local gc = Instance.new("UICorner", goBtn) gc.CornerRadius = UDim.new(0, 8)
			local gs = Instance.new("UIStroke", goBtn) gs.Color = Color3.fromRGB(0, 255, 80) gs.Thickness = 1

			goBtn.MouseButton1Click:Connect(function()
				local char = player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local tgt  = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if not (char and root and tgt) then return end
				root.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
				root.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				char:PivotTo(tgt.CFrame * CFrame.new(2, 0, 0))
			end)

			local pullBtn = Instance.new("TextButton", row)
			pullBtn.Size = UDim2.new(0.5, -3, 1, 0)
			pullBtn.Text = "⬇ Çek"
			pullBtn.BackgroundColor3 = Color3.fromRGB(30, 15, 0)
			pullBtn.TextColor3 = Color3.fromRGB(255, 160, 0)
			pullBtn.Font = Enum.Font.Gotham
			pullBtn.TextSize = 12
			local pc = Instance.new("UICorner", pullBtn) pc.CornerRadius = UDim.new(0, 8)
			local ps = Instance.new("UIStroke", pullBtn) ps.Color = Color3.fromRGB(255, 160, 0) ps.Thickness = 1

			pullBtn.MouseButton1Click:Connect(function()
				local myChar   = player.Character
				local myRoot   = myChar and myChar:FindFirstChild("HumanoidRootPart")
				local theirChar = p.Character
				local theirRoot = theirChar and theirChar:FindFirstChild("HumanoidRootPart")
				if not (myRoot and theirChar and theirRoot) then return end
				theirRoot.AssemblyLinearVelocity  = Vector3.new(0, 0, 0)
				theirRoot.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
				theirChar:PivotTo(myRoot.CFrame * CFrame.new(2, 0, 0))
			end)

			local divider = Instance.new("Frame", tpScroll)
			divider.Size = UDim2.new(0.92, 0, 0, 1)
			divider.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			divider.BorderSizePixel = 0
		end
	end
end



createToggleButton("Teleport Listesi", function(on)
	tpListVisible = on
	tpFrame.Visible = on
	if on then refreshTpList() end
end)

-- ────────────────────────────────────────────────
-- 13. ANTI-AFK
_G.isAntiAfk = false

createToggleButton("Anti-AFK", function(on)
	_G.isAntiAfk = on
	if on then
		task.spawn(function()
			while _G.isAntiAfk do
				local vrs = game:GetService("VirtualUser")
				pcall(function()
					vrs:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
					task.wait(0.1)
					vrs:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
				end)
				task.wait(60)
			end
		end)
	end
end)

-- ────────────────────────────────────────────────
-- RUNSERVICE: Noclip / God / Anti-Knockback / Btools
RunService.Stepped:Connect(function()
	if player.Character then
		if _G.isNoclip then
			for _, v in pairs(player.Character:GetDescendants()) do
				if v:IsA("BasePart") then v.CanCollide = false end
			end
		end
		if _G.isGod then
			local hum = player.Character:FindFirstChild("Humanoid")
			if hum then hum.Health = hum.MaxHealth end
		end
		if _G.isAntiKnock then
			local root = player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local vel = root.AssemblyLinearVelocity
				root.AssemblyLinearVelocity = Vector3.new(0, math.min(vel.Y, 0), 0)
			end
		end
	end
end)

-- Mouse: Btools + Property Editor ortak
mouse.Button1Down:Connect(function()
	if btoolMode == "delete" then
		local target = mouse.Target
		if target and not target:IsDescendantOf(screenGui) then
			target:Destroy()
		end
	elseif btoolMode == "move" then
		local target = mouse.Target
		if target and target:IsA("BasePart") and not target:IsDescendantOf(screenGui) then
			local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
			if root then target.Position = root.Position + Vector3.new(0, 5, -5) end
		end
	end
	if isSelecting and mouse.Target then
		selectedPart = mouse.Target
		targetLabel.Text = "Seçili: " .. (selectedPart.Name:sub(1,10))
	end
end)

-- ────────────────────────────────────────────────
-- 14. NO FOG
createToggleButton("No Fog", function(on)
	if on then
		Lighting.FogEnd   = 100000
		Lighting.FogStart = 100000
	else
		Lighting.FogEnd   = 1000
		Lighting.FogStart = 0
	end
end)

-- ────────────────────────────────────────────────
-- 15. FOV CHANGER
local fovBox = Instance.new("TextBox", scroll)
fovBox.Size = UDim2.new(0.88, 0, 0, 36)
fovBox.PlaceholderText = "FOV (50-120)"
fovBox.Text = "70"
fovBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fovBox.TextColor3 = Color3.fromRGB(0, 255, 80)
fovBox.PlaceholderColor3 = Color3.fromRGB(0, 150, 50)
fovBox.Font = Enum.Font.Gotham
fovBox.TextSize = 14
fovBox.ClearTextOnFocus = false
local fovCorner = Instance.new("UICorner", fovBox) fovCorner.CornerRadius = UDim.new(0, 8)
local fovStroke = Instance.new("UIStroke", fovBox) fovStroke.Color = Color3.fromRGB(0,255,80) fovStroke.Thickness = 1

local origFOV = workspace.CurrentCamera.FieldOfView

createButton("FOV Uygula", function()
	local val = tonumber(fovBox.Text)
	if val then workspace.CurrentCamera.FieldOfView = math.clamp(val, 50, 120) end
end)

createButton("FOV Sıfırla", function()
	workspace.CurrentCamera.FieldOfView = origFOV
end)

-- ────────────────────────────────────────────────
-- 16. CROSSHAIR
local crosshair = Instance.new("Frame", screenGui)
crosshair.Size = UDim2.new(0, 20, 0, 20)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
crosshair.BackgroundTransparency = 1
crosshair.Visible = false
crosshair.ZIndex = 10

local chH = Instance.new("Frame", crosshair)
chH.Size = UDim2.new(1, 0, 0, 2)
chH.Position = UDim2.new(0, 0, 0.5, -1)
chH.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
chH.BorderSizePixel = 0
chH.ZIndex = 10

local chV = Instance.new("Frame", crosshair)
chV.Size = UDim2.new(0, 2, 1, 0)
chV.Position = UDim2.new(0.5, -1, 0, 0)
chV.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
chV.BorderSizePixel = 0
chV.ZIndex = 10

local chDot = Instance.new("Frame", crosshair)
chDot.Size = UDim2.new(0, 4, 0, 4)
chDot.Position = UDim2.new(0.5, -2, 0.5, -2)
chDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
chDot.BorderSizePixel = 0
chDot.ZIndex = 11
local chDotCorner = Instance.new("UICorner", chDot)
chDotCorner.CornerRadius = UDim.new(1, 0)

createToggleButton("Crosshair", function(on)
	crosshair.Visible = on
end)

-- ────────────────────────────────────────────────
-- 17. THIRD PERSON
local origCamType
_G.isThirdPerson = false

createToggleButton("Third Person", function(on)
	_G.isThirdPerson = on
	local cam = workspace.CurrentCamera
	if on then
		origCamType = cam.CameraType
		cam.CameraType = Enum.CameraType.Attach
		task.spawn(function()
			while _G.isThirdPerson do
				local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if root then
					local back = root.CFrame.LookVector * -10 + Vector3.new(0, 4, 0)
					cam.CFrame = CFrame.new(root.Position + back, root.Position + Vector3.new(0, 2, 0))
				end
				task.wait()
			end
		end)
	else
		cam.CameraType = origCamType or Enum.CameraType.Custom
	end
end)

-- ────────────────────────────────────────────────
-- 18. NO CAM SHAKE
_G.isNoCamShake = false

createToggleButton("No Cam Shake", function(on)
	_G.isNoCamShake = on
	if on then
		task.spawn(function()
			while _G.isNoCamShake do
				if player.Character then
					local hum = player.Character:FindFirstChild("Humanoid")
					if hum then hum.CameraOffset = Vector3.new(0, 0, 0) end
				end
				for _, v in pairs(workspace:GetDescendants()) do
					if v:IsA("LocalScript") and v.Name:lower():find("shake") then
						v.Disabled = true
					end
				end
				task.wait(0.1)
			end
		end)
	end
end)

-- ────────────────────────────────────────────────
-- 19. FPS GÖSTERGESİ
local fpsLabel = Instance.new("TextLabel", screenGui)
fpsLabel.Size = UDim2.new(0, 80, 0, 26)
fpsLabel.Position = UDim2.new(0, 10, 0, 60)
fpsLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 80)
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextSize = 14
fpsLabel.Text = "FPS: --"
fpsLabel.BorderSizePixel = 0
local fpsCorner = Instance.new("UICorner", fpsLabel)
fpsCorner.CornerRadius = UDim.new(0, 6)

RunService.RenderStepped:Connect(function(dt)
	if dt > 0 then
		local fps = math.floor(1 / dt)
		fpsLabel.Text = "FPS: " .. fps
		fpsLabel.TextColor3 = fps < 30 and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 80)
	end
end)


-- ────────────────────────────────────────────────
-- 22. PROPERTY EDITOR
local selectedPart = nil
local isSelecting = false

local propFrame = Instance.new("Frame", screenGui)
propFrame.Size = UDim2.new(0, 180, 0, 175)
propFrame.Position = UDim2.new(0.5, 250, 0.5, -200)
propFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
propFrame.Visible = false
propFrame.Active = true
propFrame.Draggable = true
Instance.new("UICorner", propFrame).CornerRadius = UDim.new(0, 10)
local propStroke = Instance.new("UIStroke", propFrame)
propStroke.Color = Color3.fromRGB(0, 255, 80)
propStroke.Thickness = 1.5

local propLayout = Instance.new("UIListLayout", propFrame)
propLayout.Padding = UDim.new(0, 4)
propLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local targetLabel = Instance.new("TextLabel", propFrame)
targetLabel.Size = UDim2.new(1, 0, 0, 30)
targetLabel.Text = "Obje Seçilmedi"
targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetLabel.BackgroundTransparency = 1
targetLabel.Font = Enum.Font.Gotham
targetLabel.TextSize = 12

local function createPropBtn(text, action)
	local b = Instance.new("TextButton", propFrame)
	b.Size = UDim2.new(0.9, 0, 0, 32)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	b.TextColor3 = Color3.fromRGB(0, 255, 80)
	b.Font = Enum.Font.Gotham
	b.TextSize = 12
	b.AutoButtonColor = false
	local bc = Instance.new("UICorner", b) bc.CornerRadius = UDim.new(0, 6)
	local bs = Instance.new("UIStroke", b) bs.Color = Color3.fromRGB(0,255,80) bs.Thickness = 1
	b.MouseButton1Click:Connect(function()
		if selectedPart and selectedPart.Parent then action(selectedPart) end
	end)
end

createPropBtn("👁 X-Ray (Şeffaf)", function(p) p.Transparency = 0.7 end)
createPropBtn("🚫 Collide Off",    function(p) p.CanCollide = false end)
createPropBtn("🗑 Sil (Delete)",   function(p) p:Destroy(); selectedPart = nil; targetLabel.Text = "Obje Seçilmedi" end)

createToggleButton("Property Editor", function(on)
	isSelecting = on
	propFrame.Visible = on
end)


-- ────────────────────────────────────────────────
-- 24. TIME CHANGER
local timeBox = Instance.new("TextBox", scroll)
timeBox.Size = UDim2.new(0.88, 0, 0, 36)
timeBox.PlaceholderText = "Saat (0-24)"
timeBox.Text = "12"
timeBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
timeBox.TextColor3 = Color3.fromRGB(0, 255, 80)
timeBox.PlaceholderColor3 = Color3.fromRGB(0, 150, 50)
timeBox.Font = Enum.Font.Gotham
timeBox.TextSize = 13
timeBox.ClearTextOnFocus = false
local timeCorner = Instance.new("UICorner", timeBox) timeCorner.CornerRadius = UDim.new(0, 8)
local timeStroke = Instance.new("UIStroke", timeBox) timeStroke.Color = Color3.fromRGB(0,255,80) timeStroke.Thickness = 1

local timeRow = Instance.new("Frame", scroll)
timeRow.Size = UDim2.new(0.88, 0, 0, 38)
timeRow.BackgroundTransparency = 1
local timeRowLayout = Instance.new("UIListLayout", timeRow)
timeRowLayout.FillDirection = Enum.FillDirection.Horizontal
timeRowLayout.Padding = UDim.new(0, 5)

local function makeTimeBtn(label, hour)
	local b = Instance.new("TextButton", timeRow)
	b.Size = UDim2.new(0.33, -4, 1, 0)
	b.Text = label
	b.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	b.TextColor3 = Color3.fromRGB(0, 255, 80)
	b.Font = Enum.Font.Gotham
	b.TextSize = 11
	b.AutoButtonColor = false
	local bc = Instance.new("UICorner", b) bc.CornerRadius = UDim.new(0, 8)
	local bs = Instance.new("UIStroke", b) bs.Color = Color3.fromRGB(0,255,80) bs.Thickness = 1
	b.MouseButton1Click:Connect(function()
		Lighting.ClockTime = hour
	end)
end

makeTimeBtn("🌅 Sabah", 6)
makeTimeBtn("☀️ Öğle", 14)
makeTimeBtn("🌙 Gece", 0)

createButton("⚡ Saati Uygula", function()
	local val = tonumber(timeBox.Text)
	if val then Lighting.ClockTime = math.clamp(val, 0, 24) end
end)

-- ────────────────────────────────────────────────
-- 25. SPIN (Hızlandırılmış)
_G.isSpin = false

createToggleButton("Spin", function(on)
    _G.isSpin = on
    if on then
        task.spawn(function()
            local angle = 0
            -- Hızı kontrol eden iki değişken:
            local rotationSpeed = 30 -- Her karede kaç derece dönecek (5 yerine 20 yaptık)
            local updateRate = 0.01 -- Kaç saniyede bir güncellenecek (0.03 yerine 0.01 yaptık)
            
            while _G.isSpin do
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    angle = (angle + rotationSpeed) % 360
                    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(angle), 0)
                end
                task.wait(updateRate)
            end
        end)
    end
end)
-- ────────────────────────────────────────────────
-- 26. LOW GRAVITY
local origGravity = workspace.Gravity
_G.isLowGrav = false

createToggleButton("Low Gravity", function(on)
	_G.isLowGrav = on
	if on then
		workspace.Gravity = 20
	else
		workspace.Gravity = origGravity
	end
end)

-- ────────────────────────────────────────────────
-- 28. ANTI-VOID
_G.isAntiVoid = false
local lastSafePos = nil

createToggleButton("Anti-Void", function(on)
	_G.isAntiVoid = on
	if on then
		task.spawn(function()
			while _G.isAntiVoid do
				local char = player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum  = char and char:FindFirstChild("Humanoid")
				if root and hum then
					-- Güvenli pozisyonu kaydet (yerde duruyorsa)
					if hum.FloorMaterial ~= Enum.Material.Air then
						lastSafePos = root.Position
					end
					-- Void'e düşünce kurtarır (-100 altı tehlikeli kabul edilir)
					if root.Position.Y < -80 and lastSafePos then
						root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
						char:PivotTo(CFrame.new(lastSafePos + Vector3.new(0, 5, 0)))
					end
				end
				task.wait(0.2)
			end
		end)
	end
end)


-- ────────────────────────────────────────────────
-- 31. RAINBOW ESP (GÜNCEL VE GÖZÜ PEK)
_G.isRainbowESP = false
local rainbowHighlights = {}

local function addHighlight(obj)
    if obj:IsA("Model") and obj:FindFirstChild("HumanoidRootPart") and obj.Name ~= player.Name then
        if not rainbowHighlights[obj.Name] then
            local hl = Instance.new("Highlight", obj)
            hl.FillTransparency = 0.5
            rainbowHighlights[obj.Name] = hl
        end
    end
end

createToggleButton("Rainbow ESP", function(on)
    _G.isRainbowESP = on
    if on then
        task.spawn(function()
            local hue = 0
            while _G.isRainbowESP do
                hue = (hue + 0.01) % 1
                local color = Color3.fromHSV(hue, 1, 1)
                
                -- HERŞEYİ TARA
                for _, obj in pairs(workspace:GetDescendants()) do
                    addHighlight(obj)
                end
                
                -- RENKLERİ GÜNCELLE
                for name, hl in pairs(rainbowHighlights) do
                    if hl and hl.Parent then
                        hl.FillColor = color
                        hl.OutlineColor = color
                    else
                        rainbowHighlights[name] = nil
                    end
                end
                task.wait(0.5) -- Tarama süresi
            end
        end)
    else
        for _, hl in pairs(rainbowHighlights) do
            if hl then hl:Destroy() end
        end
        rainbowHighlights = {}
    end
end)
-- ────────────────────────────────────────────────
-- 32. NPC ESP
_G.isNpcESP = false
local npcHighlights = {}

createToggleButton("NPC ESP", function(on)
	_G.isNpcESP = on
	if on then
		task.spawn(function()
			while _G.isNpcESP do
				for _, obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("Humanoid") and obj.Parent ~= player.Character then
						local isPlayer = false
						for _, p in pairs(Players:GetPlayers()) do
							if p.Character == obj.Parent then isPlayer = true break end
						end
						if not isPlayer and not npcHighlights[obj.Parent.Name] then
							local hl = Instance.new("Highlight", obj.Parent)
							hl.FillColor = Color3.fromRGB(255, 100, 0)
							hl.OutlineColor = Color3.fromRGB(255, 100, 0)
							hl.FillTransparency = 0.5
							npcHighlights[obj.Parent.Name] = hl
						end
					end
				end
				task.wait(1)
			end
		end)
	else
		for _, hl in pairs(npcHighlights) do
			if hl then hl:Destroy() end
		end
		npcHighlights = {}
	end
end)


-- ────────────────────────────────────────────────
-- 34. AURA EFEKTİ (görsel halka)
_G.isAuraFX = false
local auraParticle = nil

createToggleButton("Aura Efekti", function(on)
	_G.isAuraFX = on
	local char = player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	if on then
		-- Neon halka oluştur
		auraParticle = Instance.new("SelectionBox", root)
		auraParticle.Adornee = root
		auraParticle.Color3 = Color3.fromRGB(0, 255, 80)
		auraParticle.LineThickness = 0.05
		auraParticle.SurfaceTransparency = 0.8
		auraParticle.SurfaceColor3 = Color3.fromRGB(0, 255, 80)

		-- Renk animasyonu
		task.spawn(function()
			local hue = 0
			while _G.isAuraFX and auraParticle and auraParticle.Parent do
				hue = (hue + 0.02) % 1
				local color = Color3.fromHSV(hue, 1, 1)
				auraParticle.Color3 = color
				auraParticle.SurfaceColor3 = color
				task.wait(0.05)
			end
		end)
	else
		if auraParticle then auraParticle:Destroy(); auraParticle = nil end
	end
end)




-- ────────────────────────────────────────────────
-- 41. MİNİ MAP
local miniMapFrame = Instance.new("Frame", screenGui)
miniMapFrame.Size = UDim2.new(0, 160, 0, 160)
miniMapFrame.Position = UDim2.new(1, -170, 1, -170)
miniMapFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
miniMapFrame.BackgroundTransparency = 0.3
miniMapFrame.Visible = false
miniMapFrame.ZIndex = 5

local miniMapCorner = Instance.new("UICorner", miniMapFrame)
miniMapCorner.CornerRadius = UDim.new(0, 8)
local miniMapStroke = Instance.new("UIStroke", miniMapFrame)
miniMapStroke.Color = Color3.fromRGB(0, 255, 80)
miniMapStroke.Thickness = 1.5

local miniMapTitle = Instance.new("TextLabel", miniMapFrame)
miniMapTitle.Size = UDim2.new(1, 0, 0, 20)
miniMapTitle.Text = "🗺 Mini Map"
miniMapTitle.BackgroundTransparency = 1
miniMapTitle.TextColor3 = Color3.fromRGB(0, 255, 80)
miniMapTitle.Font = Enum.Font.GothamBold
miniMapTitle.TextSize = 11
miniMapTitle.ZIndex = 6

-- Oyuncu noktası (sen)
local selfDot = Instance.new("Frame", miniMapFrame)
selfDot.Size = UDim2.new(0, 8, 0, 8)
selfDot.AnchorPoint = Vector2.new(0.5, 0.5)
selfDot.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
selfDot.ZIndex = 7
local selfDotCorner = Instance.new("UICorner", selfDot)
selfDotCorner.CornerRadius = UDim.new(1, 0)

local miniMapDots = {}
local MAP_SCALE = 2 -- 1 stud = kaç pixel

createToggleButton("Mini Map", function(on)
	miniMapFrame.Visible = on
	if on then
		task.spawn(function()
			while states["Mini Map"] do
				local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				if myRoot then
					-- Kendi noktamızı ortada göster
					selfDot.Position = UDim2.new(0.5, 0, 0.5, 0)

					-- Diğer oyuncuları göster
					for name, dot in pairs(miniMapDots) do
						dot:Destroy()
						miniMapDots[name] = nil
					end

					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character then
							local r = p.Character:FindFirstChild("HumanoidRootPart")
							if r then
								local diff = r.Position - myRoot.Position
								local px = 0.5 + (diff.X * MAP_SCALE) / 160
								local py = 0.5 + (diff.Z * MAP_SCALE) / 160

								if px > 0 and px < 1 and py > 0 and py < 1 then
									local dot = Instance.new("Frame", miniMapFrame)
									dot.Size = UDim2.new(0, 6, 0, 6)
									dot.AnchorPoint = Vector2.new(0.5, 0.5)
									dot.Position = UDim2.new(px, 0, py, 0)
									dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
									dot.ZIndex = 7
									local dc = Instance.new("UICorner", dot)
									dc.CornerRadius = UDim.new(1, 0)
									miniMapDots[p.Name] = dot
								end
							end
						end
					end
				end
				task.wait(0.2)
			end
			-- Kapatınca noktaları temizle
			for _, dot in pairs(miniMapDots) do dot:Destroy() end
			miniMapDots = {}
		end)
	else
		for _, dot in pairs(miniMapDots) do dot:Destroy() end
		miniMapDots = {}
	end
end)

-- ────────────────────────────────────────────────
-- 42. NOTİFİKASYON SİSTEMİ
local notifFrame = Instance.new("Frame", screenGui)
notifFrame.Size = UDim2.new(0, 220, 0, 0)
notifFrame.Position = UDim2.new(1, -230, 0, 10)
notifFrame.BackgroundTransparency = 1
notifFrame.ZIndex = 20
notifFrame.AutomaticSize = Enum.AutomaticSize.Y

local notifLayout = Instance.new("UIListLayout", notifFrame)
notifLayout.Padding = UDim.new(0, 4)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function notify(text, color)
	color = color or Color3.fromRGB(0, 255, 80)
	local n = Instance.new("Frame", notifFrame)
	n.Size = UDim2.new(1, 0, 0, 36)
	n.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	n.BackgroundTransparency = 0.1
	n.ZIndex = 20
	local nc = Instance.new("UICorner", n) nc.CornerRadius = UDim.new(0, 8)
	local ns = Instance.new("UIStroke", n) ns.Color = color ns.Thickness = 1
	local nl = Instance.new("TextLabel", n)
	nl.Size = UDim2.new(1, -10, 1, 0)
	nl.Position = UDim2.new(0, 5, 0, 0)
	nl.BackgroundTransparency = 1
	nl.Text = text
	nl.TextColor3 = color
	nl.Font = Enum.Font.Gotham
	nl.TextSize = 12
	nl.TextXAlignment = Enum.TextXAlignment.Left
	nl.ZIndex = 21

	-- 3 saniye sonra sil
	task.delay(3, function()
		if n and n.Parent then
			TweenService:Create(n, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
			task.wait(0.3)
			n:Destroy()
		end
	end)
end

-- Toggle butonlarına notif bağla (createToggleButton override)
-- Test butonu
createButton("🔔 Notif Test", function()
	notify("⚡ WorthNet aktif!", Color3.fromRGB(0, 255, 80))
end)

-- ────────────────────────────────────────────────
-- 43. MÜZİK ÇALAR
local musicIds = {
	["Phonk 1"] = "1836906637",
	["Lofi"]    = "1373026421",
	["Bass"]    = "1845808327",
}

local musicSound = Instance.new("Sound", workspace)
musicSound.Volume = 0.5
musicSound.Looped = true

local musicFrame = Instance.new("Frame", screenGui)
musicFrame.Size = UDim2.new(0, 200, 0, 220)
musicFrame.Position = UDim2.new(0, 10, 0.5, 0)
musicFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
musicFrame.Visible = false
musicFrame.Active = true
musicFrame.Draggable = true
musicFrame.ZIndex = 10

local musicCorner = Instance.new("UICorner", musicFrame)
musicCorner.CornerRadius = UDim.new(0, 12)
local musicStroke = Instance.new("UIStroke", musicFrame)
musicStroke.Color = Color3.fromRGB(0, 255, 80)
musicStroke.Thickness = 1.5

local musicTitle = Instance.new("TextLabel", musicFrame)
musicTitle.Size = UDim2.new(1, 0, 0, 36)
musicTitle.Text = "🎵 Müzik Çalar"
musicTitle.BackgroundColor3 = Color3.fromRGB(0, 200, 60)
musicTitle.TextColor3 = Color3.fromRGB(0, 0, 0)
musicTitle.Font = Enum.Font.GothamBold
musicTitle.TextSize = 13
musicTitle.ZIndex = 11
local musicTitleCorner = Instance.new("UICorner", musicTitle)
musicTitleCorner.CornerRadius = UDim.new(0, 12)

local musicScroll = Instance.new("ScrollingFrame", musicFrame)
musicScroll.Size = UDim2.new(1, -10, 1, -80)
musicScroll.Position = UDim2.new(0, 5, 0, 42)
musicScroll.BackgroundTransparency = 1
musicScroll.ScrollBarThickness = 4
musicScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 80)
musicScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
musicScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
musicScroll.BorderSizePixel = 0
musicScroll.ZIndex = 11

local musicScrollLayout = Instance.new("UIListLayout", musicScroll)
musicScrollLayout.Padding = UDim.new(0, 4)
musicScrollLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Şarkı butonları
for name, id in pairs(musicIds) do
	local mb = Instance.new("TextButton", musicScroll)
	mb.Size = UDim2.new(0.92, 0, 0, 32)
	mb.Text = "▶ " .. name
	mb.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	mb.TextColor3 = Color3.fromRGB(0, 255, 80)
	mb.Font = Enum.Font.Gotham
	mb.TextSize = 12
	mb.ZIndex = 12
	local mbc = Instance.new("UICorner", mb) mbc.CornerRadius = UDim.new(0, 8)
	local mbs = Instance.new("UIStroke", mb) mbs.Color = Color3.fromRGB(0,255,80) mbs.Thickness = 1
	mb.MouseButton1Click:Connect(function()
		musicSound.SoundId = "rbxassetid://" .. id
		musicSound:Play()
		notify("🎵 Çalıyor: " .. name)
	end)
end

-- Custom ID kutusu
local musicIdBox = Instance.new("TextBox", musicFrame)
musicIdBox.Size = UDim2.new(0.9, 0, 0, 30)
musicIdBox.Position = UDim2.new(0.05, 0, 1, -38)
musicIdBox.PlaceholderText = "Sound ID gir..."
musicIdBox.Text = ""
musicIdBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
musicIdBox.TextColor3 = Color3.fromRGB(0, 255, 80)
musicIdBox.Font = Enum.Font.Gotham
musicIdBox.TextSize = 12
musicIdBox.ClearTextOnFocus = false
musicIdBox.ZIndex = 12
local musicIdCorner = Instance.new("UICorner", musicIdBox) musicIdCorner.CornerRadius = UDim.new(0, 6)

musicIdBox.FocusLost:Connect(function()
	local id = musicIdBox.Text
	if id ~= "" then
		musicSound.SoundId = "rbxassetid://" .. id
		musicSound:Play()
		notify("🎵 Custom ses çalıyor")
	end
end)

-- Durdur butonu
local stopBtn = Instance.new("TextButton", musicFrame)
stopBtn.Size = UDim2.new(0.9, 0, 0, 28)
stopBtn.Position = UDim2.new(0.05, 0, 1, -70)
stopBtn.Text = "⏹ Durdur"
stopBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 10)
stopBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
stopBtn.Font = Enum.Font.Gotham
stopBtn.TextSize = 12
stopBtn.ZIndex = 12
local stopCorner = Instance.new("UICorner", stopBtn) stopCorner.CornerRadius = UDim.new(0, 8)
stopBtn.MouseButton1Click:Connect(function()
	musicSound:Stop()
	notify("⏹ Müzik durduruldu", Color3.fromRGB(255, 80, 80))
end)

createToggleButton("Müzik Çalar", function(on)
	musicFrame.Visible = on
	if not on then musicSound:Stop() end
end)


-- ────────────────────────────────────────────────
-- ESP SİSTEMİ (GÜNCEL VE STABİL)
_G.isESP = false

local function createHighlight(target)
    if not target:FindFirstChild("Highlight") then
        local h = Instance.new("Highlight")
        h.Parent = target
        h.FillColor = Color3.fromRGB(255, 0, 0) -- Kırmızı renk
        h.OutlineColor = Color3.fromRGB(255, 255, 255)
        h.FillTransparency = 0.5
        h.OutlineTransparency = 0
    end
end



-- ────────────────────────────────────────────────
-- X TUŞU: Gizle/Göster
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.X then
		frame.Visible = not frame.Visible
	end
end)
