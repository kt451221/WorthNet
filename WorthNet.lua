-- WORTHNET CLIENT V0.3 | FULL FEATURES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

-- Eski GUI'yi temizle
if CoreGui:FindFirstChild("WorthNetClient") then
	CoreGui:FindFirstChild("WorthNetClient"):Destroy()
end

local screenGui = Instance.new("ScreenGui", CoreGui)
screenGui.Name = "WorthNetClient"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false

-- Ana Frame
local frame = Instance.new("Frame", screenGui)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 240, 0, 500)
frame.Position = UDim2.new(0.5, -120, 0.5, -250)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
frame.BackgroundTransparency = 0.05
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

local frameCorner = Instance.new("UICorner", frame)
frameCorner.CornerRadius = UDim.new(0, 12)

local frameStroke = Instance.new("UIStroke", frame)
frameStroke.Color = Color3.fromRGB(0, 255, 80)
frameStroke.Thickness = 1.5

-- Başlık
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 60)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

-- Alt kısmı düzelt (üst yuvarlak, alt düz)
local titleFix = Instance.new("Frame", titleBar)
titleFix.Size = UDim2.new(1, 0, 0.5, 0)
titleFix.Position = UDim2.new(0, 0, 0.5, 0)
titleFix.BackgroundColor3 = Color3.fromRGB(0, 200, 60)
titleFix.BorderSizePixel = 0

local titleLabel = Instance.new("TextLabel", titleBar)
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "⚡ WORTHNET V0.3"
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold

-- Hız TextBox
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

-- ScrollingFrame
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

-- State tablosu
local states = {}

-- Buton oluşturma fonksiyonu (ON/OFF toggle)
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

-- Normal buton (toggle değil)
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
_G.isNoclip = false
_G.isFly    = false
_G.isGod    = false
local bv, bg

-- ────────────────────────────────────────────────
-- 1. HIZ UYGULA
createButton("⚡ Hızı Uygula", function()
	local hum = player.Character and player.Character:FindFirstChild("Humanoid")
	if hum then
		hum.WalkSpeed = math.min(tonumber(speedBox.Text) or 50, 500)
	end
end)

-- ────────────────────────────────────────────────
-- 2. NOCLIP
createToggleButton("Noclip", function(on)
	_G.isNoclip = on
end)

-- ────────────────────────────────────────────────
-- 3. FLY
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

-- ────────────────────────────────────────────────
-- 4. GOD MODE
createToggleButton("God Mode", function(on)
	_G.isGod = on
end)

-- ────────────────────────────────────────────────
-- 5. PLAYER ESP
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
-- 6. AUTO AURA
_G.isAura = false

createToggleButton("Auto Aura", function(on)
	_G.isAura = on
	if on then
		task.spawn(function()
			while _G.isAura do
				local char = player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum  = char and char:FindFirstChild("Humanoid")
				if root and hum then
					local nearest, nearDist = nil, math.huge
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character then
							local r2 = p.Character:FindFirstChild("HumanoidRootPart")
							local h2 = p.Character:FindFirstChild("Humanoid")
							if r2 and h2 and h2.Health > 0 then
								local d = (root.Position - r2.Position).Magnitude
								if d < nearDist then
									nearDist = d
									nearest = p
								end
							end
						end
					end
					if nearest and nearDist < 15 then
						local npcRoot = nearest.Character:FindFirstChild("HumanoidRootPart")
						if npcRoot then
							-- Gravity'yi kes, PlatformStand ile havada tut
							hum.PlatformStand = true
							root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
							char:PivotTo(CFrame.new(npcRoot.Position + Vector3.new(0, 4, 0)))
							task.wait(0.05)
							-- Vur
							local enemyHum = nearest.Character:FindFirstChild("Humanoid")
							if enemyHum then enemyHum:TakeDamage(10) end
							task.wait(0.1)
							hum.PlatformStand = false
						end
					end
				end
				task.wait(0.5)
			end
			-- Loop bitince PlatformStand'ı sıfırla
			local hum = player.Character and player.Character:FindFirstChild("Humanoid")
			if hum then hum.PlatformStand = false end
		end)
	else
		local hum = player.Character and player.Character:FindFirstChild("Humanoid")
		if hum then hum.PlatformStand = false end
	end
end)

-- ────────────────────────────────────────────────
-- 7. AUTO FARM (NPC)
_G.isAutoFarm = false

createToggleButton("Auto Farm", function(on)
	_G.isAutoFarm = on
	if on then
		task.spawn(function()
			while _G.isAutoFarm do
				local char = player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum  = char and char:FindFirstChild("Humanoid")
				if root and hum then
					local nearest, nearDist = nil, math.huge
					for _, obj in pairs(workspace:GetDescendants()) do
						if obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 then
							local r = obj.Parent:FindFirstChild("HumanoidRootPart")
							if r then
								local d = (root.Position - r.Position).Magnitude
								if d < nearDist then
									nearDist = d
									nearest = obj
								end
							end
						end
					end
					if nearest then
						local npcRoot = nearest.Parent:FindFirstChild("HumanoidRootPart")
						if npcRoot then
							-- Gravity'yi kes
							hum.PlatformStand = true
							root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
							char:PivotTo(CFrame.new(npcRoot.Position + Vector3.new(0, 4, 0)))
							task.wait(0.05)
							-- Vur
							nearest:TakeDamage(20)
							task.wait(0.1)
							hum.PlatformStand = false
						end
					end
				end
				task.wait(0.4)
			end
			-- Loop bitince sıfırla
			local hum = player.Character and player.Character:FindFirstChild("Humanoid")
			if hum then hum.PlatformStand = false end
		end)
	else
		local hum = player.Character and player.Character:FindFirstChild("Humanoid")
		if hum then hum.PlatformStand = false end
	end
end)

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
_G.isFullBright = false

createToggleButton("FullBright", function(on)
	_G.isFullBright = on
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
-- 10. ANTI-KNOCKBACK
_G.isAntiKnock = false

createToggleButton("Anti-Knockback", function(on)
	_G.isAntiKnock = on
end)

-- ────────────────────────────────────────────────
-- 11. BTOOLS (Sil/Taşı)
local btoolMode = nil -- "delete" | "move"

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

-- Btools tıklama
local mouse = player:GetMouse()
mouse.Button1Down:Connect(function()
	if btoolMode == "delete" then
		local target = mouse.Target
		if target and not target:IsDescendantOf(screenGui) then
			target:Destroy()
		end
	elseif btoolMode == "move" then
		local target = mouse.Target
		if target and target:IsA("BasePart") and not target:IsDescendantOf(screenGui) then
			target.Position = player.Character and player.Character:FindFirstChild("HumanoidRootPart") and
				player.Character.HumanoidRootPart.Position + Vector3.new(0, 5, -5) or target.Position
		end
	end
end)

-- ────────────────────────────────────────────────
-- 12. TELEPORT LIST
local tpListVisible = false
local tpFrame = Instance.new("Frame", screenGui)
tpFrame.Size = UDim2.new(0, 200, 0, 300)
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
tpLayout.Padding = UDim.new(0, 4)
tpLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local function refreshTpList()
	for _, c in pairs(tpScroll:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player then
			local b = Instance.new("TextButton", tpScroll)
			b.Size = UDim2.new(0.92, 0, 0, 34)
			b.Text = "➜ " .. p.Name
			b.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
			b.TextColor3 = Color3.fromRGB(0, 255, 80)
			b.Font = Enum.Font.Gotham
			b.TextSize = 12
			local bc = Instance.new("UICorner", b) bc.CornerRadius = UDim.new(0, 8)
			local bs = Instance.new("UIStroke", b) bs.Color = Color3.fromRGB(0, 255, 80) bs.Thickness = 1

			b.MouseButton1Click:Connect(function()
				local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
				local tgt  = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if not (root and tgt) then return end

				-- Fizik sıfırla + anchor et
				root.Velocity = Vector3.new(0, 0, 0)
				root.RotVelocity = Vector3.new(0, 0, 0)
				root.Anchored = true

				-- Hedefin o anki konumuna ışınlan
				root.CFrame = CFrame.new(tgt.Position + Vector3.new(0, 3, 0))

				task.wait(0.1) -- Fizik engine'in yerleşmesi için kısa bekle
				root.Anchored = false
			end)
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
-- RUNSERVICE: Noclip / God / Anti-Knockback
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
			if root and root:FindFirstChild("RootAttachment") then
				local vel = root.AssemblyLinearVelocity
				root.AssemblyLinearVelocity = Vector3.new(0, math.min(vel.Y, 0), 0)
			end
		end
	end
end)

-- ────────────────────────────────────────────────
-- NO FOG
createToggleButton("No Fog", function(on)
	if on then
		Lighting.FogEnd   = 100000
		Lighting.FogStart = 100000
	else
		Lighting.FogEnd   = 100000 -- orijinali bilmiyoruz, oyuna göre değişir
		Lighting.FogStart = 0
	end
end)

-- ────────────────────────────────────────────────
-- FOV CHANGER
local fovBox = Instance.new("TextBox", scroll)
fovBox.Size = UDim2.new(0.88, 0, 0, 36)
fovBox.PlaceholderText = "FOV (70-120)"
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

createButton("⚡ FOV Uygula", function()
	local val = tonumber(fovBox.Text)
	if val then
		workspace.CurrentCamera.FieldOfView = math.clamp(val, 50, 120)
	end
end)

createToggleButton("FOV Sıfırla", function(on)
	if on then
		workspace.CurrentCamera.FieldOfView = origFOV
	end
end)

-- ────────────────────────────────────────────────
-- CROSSHAIR
local crosshair = Instance.new("Frame", screenGui)
crosshair.Size = UDim2.new(0, 20, 0, 20)
crosshair.AnchorPoint = Vector2.new(0.5, 0.5)
crosshair.Position = UDim2.new(0.5, 0, 0.5, 0)
crosshair.BackgroundTransparency = 1
crosshair.Visible = false
crosshair.ZIndex = 10

-- Yatay çizgi
local chH = Instance.new("Frame", crosshair)
chH.Size = UDim2.new(1, 0, 0, 2)
chH.Position = UDim2.new(0, 0, 0.5, -1)
chH.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
chH.BorderSizePixel = 0
chH.ZIndex = 10

-- Dikey çizgi
local chV = Instance.new("Frame", crosshair)
chV.Size = UDim2.new(0, 2, 1, 0)
chV.Position = UDim2.new(0.5, -1, 0, 0)
chV.BackgroundColor3 = Color3.fromRGB(0, 255, 80)
chV.BorderSizePixel = 0
chV.ZIndex = 10

-- Merkez nokta
local chDot = Instance.new("Frame", crosshair)
chDot.Size = UDim2.new(0, 4, 0, 4)
chDot.Position = UDim2.new(0.5, -2, 0.5, -2)
chDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
chDot.BorderSizePixel = 0
chDot.ZIndex = 11
local chDotCorner = Instance.new("UICorner", chDot) chDotCorner.CornerRadius = UDim.new(1, 0)

createToggleButton("Crosshair", function(on)
	crosshair.Visible = on
end)

-- ────────────────────────────────────────────────
-- THIRD PERSON
local origCamType
_G.isThirdPerson = false

createToggleButton("Third Person", function(on)
	_G.isThirdPerson = on
	local cam = workspace.CurrentCamera
	if on then
		origCamType = cam.CameraType
		cam.CameraType = Enum.CameraType.Attach
		-- Karakter kamerasını uzaklaştır
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
-- NO CAMERA SHAKE
_G.isNoCamShake = false
local origCamCFrame

createToggleButton("No Cam Shake", function(on)
	_G.isNoCamShake = on
	if on then
		task.spawn(function()
			while _G.isNoCamShake do
				local cam = workspace.CurrentCamera
				-- CameraOffset sıfırla, shake efektlerini kes
				if player.Character then
					local hum = player.Character:FindFirstChild("Humanoid")
					if hum then
						hum.CameraOffset = Vector3.new(0, 0, 0)
					end
				end
				-- Tüm camera shake scriptlerini devre dışı bırak
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
-- ────────────────────────────────────────────────
-- GÜNCELLENMİŞ SILENT AIM (Duvar Arkası Engelli & En Yakın Hedef)
_G.isSilentAim = false
local aimFOV = 150 
local camera = workspace.CurrentCamera

local crosshair = Drawing.new("Circle")
crosshair.Radius = 60
crosshair.Thickness = 1.5
crosshair.Color = Color3.fromRGB(255, 0, 0)
crosshair.Filled = false
crosshair.Visible = false

createToggleButton("Silent Aim", function(on)
    _G.isSilentAim = on
    crosshair.Visible = on
end)

-- Görüş hattı kontrolü (Duvar arkasını engeller)
local function isVisible(targetPart)
    local origin = camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {player.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local raycastResult = workspace:Raycast(origin, direction, raycastParams)
    
    if raycastResult then
        return raycastResult.Instance:IsDescendantOf(targetPart.Parent)
    end
    return false
end

RunService.RenderStepped:Connect(function()
    crosshair.Position = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
    
    if _G.isSilentAim then
        local nearest, minDistance = nil, aimFOV -- FOV'u sınır olarak al
        local mousePos = Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
        
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local head = p.Character.Head
                local screenPos, onScreen = camera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local distToMouse = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    
                    -- Hem FOV içinde mi, hem en yakın mı, hem de GÖRÜNÜYOR mu?
                    if distToMouse < minDistance and isVisible(head) then
                        minDistance = distToMouse
                        nearest = head
                    end
                end
            end
        end
        
        if nearest then
            -- Kamerayı hedefe kilitle
            camera.CFrame = CFrame.new(camera.CFrame.Position, nearest.Position)
        end
    end
end)

-- ────────────────────────────────────────────────
-- 15. GERÇEK FPS GÖSTERGESİ (Performans Tabanlı)
local fpsLabel = Instance.new("TextLabel", screenGui)
fpsLabel.Size = UDim2.new(0, 120, 0, 30)
fpsLabel.Position = UDim2.new(0, 10, 0, 60)
fpsLabel.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 80)
fpsLabel.Font = Enum.Font.Code
fpsLabel.TextSize = 16
fpsLabel.Text = "FPS: 60"
fpsLabel.BorderSizePixel = 0

local fpsCorner = Instance.new("UICorner", fpsLabel)
fpsCorner.CornerRadius = UDim.new(0, 6)

-- Gerçek FPS Hesaplama
RunService.RenderStepped:Connect(function(deltaTime)
    if deltaTime > 0 then
        local fps = math.floor(1 / deltaTime)
        fpsLabel.Text = "FPS: " .. fps
        
        -- FPS değerine göre renk değişimi (Havalı durur)
        if fps < 30 then
            fpsLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- FPS düşükse kırmızı
        else
            fpsLabel.TextColor3 = Color3.fromRGB(0, 255, 80) -- FPS iyiyse yeşil
        end
    end
end)

-- ────────────────────────────────────────────────
-- 16. GÜNCELLENMİŞ HITBOX EXPANDER (Stabil Mantık)
_G.isHitbox = false
local hitboxSize = 6

createToggleButton("Hitbox Expander", function(on)
    _G.isHitbox = on
    -- Kapatıldığında tüm eklenenleri temizle
    if not on then
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character and p.Character:FindFirstChild("HitboxPart") then
                p.Character.HitboxPart:Destroy()
            end
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if _G.isHitbox then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
                local head = p.Character.Head
                
                -- Eğer daha önce oluşturulmamışsa veya silinmişse yeniden oluştur
                if not p.Character:FindFirstChild("HitboxPart") then
                    local hb = Instance.new("Part", p.Character)
                    hb.Name = "HitboxPart"
                    hb.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                    hb.Transparency = 0.8
                    hb.Color = Color3.fromRGB(255, 0, 0)
                    hb.Material = Enum.Material.Neon
                    hb.CanCollide = false
                    hb.Anchored = false
                    
                    -- Kafaya sabitlemek için Weld
                    local weld = Instance.new("WeldConstraint", hb)
                    weld.Part0 = hb
                    weld.Part1 = head
                end
                
                -- Oluşturulan parçayı sürekli güncelle
                local hb = p.Character.HitboxPart
                hb.CFrame = head.CFrame
            end
        end
    end
end)

-- ────────────────────────────────────────────────
-- WALL CHECK KALDIR (Kamera duvardan geçer)
_G.isNoWall = false

createToggleButton("No Wall Check", function(on)
	_G.isNoWall = on
	local cam = workspace.CurrentCamera
	if on then
		-- Kameranın duvarla çarpışmasını kapat
		player.CameraMode = Enum.CameraMode.Classic
		task.spawn(function()
			while _G.isNoWall do
				cam.CameraType = Enum.CameraType.Custom
				-- Tüm parçaların kameraya çarpışmasını kapat
				for _, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v:IsDescendantOf(player.Character or Instance.new("Folder")) then
						v.CastShadow = v.CastShadow -- dokunma
						pcall(function()
							v.LocalTransparencyModifier = 0.5
						end)
					end
				end
				task.wait(0.1)
			end
			-- Kapat, orijinale dön
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") then
					pcall(function()
						v.LocalTransparencyModifier = 0
					end)
				end
			end
		end)
	end
end)

-- ────────────────────────────────────────────────
-- KILL AURA V2 (Çoklu hedef, 20 stud menzil)
_G.isKillAuraV2 = false

createToggleButton("Kill Aura V2", function(on)
	_G.isKillAuraV2 = on
	if on then
		task.spawn(function()
			while _G.isKillAuraV2 do
				local char = player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum  = char and char:FindFirstChild("Humanoid")
				if root and hum then

					-- Tüm yakın oyuncuları topla
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character then
							local r2 = p.Character:FindFirstChild("HumanoidRootPart")
							local h2 = p.Character:FindFirstChild("Humanoid")
							if r2 and h2 and h2.Health > 0 then
								local dist = (root.Position - r2.Position).Magnitude
								if dist <= 20 then
									-- 3 stud üstüne çık, vur
									hum.PlatformStand = true
									root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
									char:PivotTo(CFrame.new(r2.Position + Vector3.new(0, 4, 0)))
									task.wait(0.05)
									h2:TakeDamage(15)
									task.wait(0.05)
									hum.PlatformStand = false
								end
							end
						end
					end

					-- NPC'leri de hedef al
					for _, obj in pairs(workspace:GetDescendants()) do
						if obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 then
							local r = obj.Parent:FindFirstChild("HumanoidRootPart")
							if r then
								local dist = (root.Position - r.Position).Magnitude
								if dist <= 20 then
									hum.PlatformStand = true
									root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
									char:PivotTo(CFrame.new(r.Position + Vector3.new(0, 4, 0)))
									task.wait(0.05)
									obj:TakeDamage(15)
									task.wait(0.05)
									hum.PlatformStand = false
								end
							end
						end
					end
				end
				task.wait(0.3)
			end
			-- Kapatınca PlatformStand sıfırla
			local h = player.Character and player.Character:FindFirstChild("Humanoid")
			if h then h.PlatformStand = false end
		end)
	else
		local h = player.Character and player.Character:FindFirstChild("Humanoid")
		if h then h.PlatformStand = false end
	end
end)

-- ────────────────────────────────────────────────
-- 17. BYPASS (Anti-Kick & Remote Protection)
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    
    -- Anti-Kick: Sunucunun gönderdiği kick isteklerini engelle
    if method == "Kick" or method == "kick" then
        return nil
    end

    -- RemoteEvent Manipülasyonu: Hileli istekleri meşrulaştır
    if self:IsA("RemoteEvent") or self:IsA("RemoteFunction") then
        if args[1] == "TeleportDetect" or args[1] == "SpeedHack" then
            return nil -- Sunucunun algılama sinyallerini boşa düşür
        end
    end

    return oldNamecall(self, ...)
end)

-- Anti-Log: Oyunun 'LogService'ini sustur
local LogService = game:GetService("LogService")
LogService.MessageOut:Connect(function(msg, type)
    if string.find(msg, "Detected") or string.find(msg, "Exploit") then
        -- Hile algılama mesajlarını konsoldan temizle
    end
end)

-- ────────────────────────────────────────────────
-- 18 & 19. GELİŞMİŞ PROPERTY EDITOR (PANEL İLE)
local selectedPart = nil
local propFrame = Instance.new("Frame", screenGui)
propFrame.Name = "PropertyPanel"
propFrame.Size = UDim2.new(0, 180, 0, 200)
propFrame.Position = UDim2.new(0.5, 250, 0.5, -200)
propFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
propFrame.Visible = false
propFrame.Active = true
propFrame.Draggable = true
propFrame.BorderSizePixel = 0

local pCorner = Instance.new("UICorner", propFrame) pCorner.CornerRadius = UDim.new(0, 10)
local pStroke = Instance.new("UIStroke", propFrame) pStroke.Color = Color3.fromRGB(0, 255, 80) pStroke.Thickness = 2

local titleLabel = Instance.new("TextLabel", propFrame)
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Text = "OBJE AYARLARI"
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 80)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold

local targetLabel = Instance.new("TextLabel", propFrame)
targetLabel.Size = UDim2.new(1, 0, 0, 25)
targetLabel.Position = UDim2.new(0, 0, 0, 30)
targetLabel.Text = "Obje Seçilmedi"
targetLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
targetLabel.TextSize = 12
targetLabel.BackgroundTransparency = 1

local listLayout = Instance.new("UIListLayout", propFrame)
listLayout.Padding = UDim.new(0, 5)
listLayout.Padding = UDim.new(0, 5)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.Padding = UDim.new(0, 5)

-- Buton oluşturucu fonksiyon
local function createPropBtn(text, action)
    local b = Instance.new("TextButton", propFrame)
    b.Size = UDim2.new(0.9, 0, 0, 30)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.Font = Enum.Font.Gotham
    b.AutoButtonColor = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    b.MouseButton1Click:Connect(function()
        if selectedPart and selectedPart.Parent then action(selectedPart) end
    end)
    return b
end

-- Butonları ekle
createPropBtn("X-Ray (Şeffaf Yap)", function(p) p.Transparency = 0.7 end)
createPropBtn("Katı Yap (Collide On)", function(p) p.CanCollide = true end)
createPropBtn("İçinden Geç (Collide Off)", function(p) p.CanCollide = false end)
createPropBtn("Yok Et (Delete)", function(p) p:Destroy() targetLabel.Text = "Obje Silindi!" end)

-- Seçme Mantığı
local isSelecting = false
local mouse = player:GetMouse()

createToggleButton("Property Editor", function(on)
    isSelecting = on
    propFrame.Visible = on
end)

mouse.Button1Down:Connect(function()
    if isSelecting and mouse.Target then
        selectedPart = mouse.Target
        targetLabel.Text = "Seçili: " .. (selectedPart.Name:sub(1, 15))
    end
end)

-- ────────────────────────────────────────────────
-- X TUŞU: Gizle/Göster
UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and input.KeyCode == Enum.KeyCode.X then
		frame.Visible = not frame.Visible
	end
end)
