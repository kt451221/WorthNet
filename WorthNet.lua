-- WORTHNET CLIENT V0.3 | FULL FEATURES
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

-- VirtualInputManager güvenli yükleme (kick önleme)
local VirtualInputManager
pcall(function()
	VirtualInputManager = game:GetService("VirtualInputManager")
end)

-- PlayerGui fallback (CoreGui kick ederse)
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

local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 45)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 200, 60)
titleBar.BorderSizePixel = 0

local titleCorner = Instance.new("UICorner", titleBar)
titleCorner.CornerRadius = UDim.new(0, 12)

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
_G.isNoclip = false
_G.isFly    = false
_G.isGod    = false
local bv, bg
local mouse = player:GetMouse()

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
local Camera = workspace.CurrentCamera
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Kutu ve yazı oluşturucu
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

    -- Sürekli güncelleme döngüsü
    RunService.RenderStepped:Connect(function()
        if _G.isESPBox and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local root = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(root.Position)

            if onScreen then
                -- Kutuyu hesapla
                box.Size = Vector2.new(1000 / pos.Z, 1000 / pos.Z) -- Uzaklığa göre boyutlanma
                box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                box.Visible = true

                -- Yazıyı kutunun altına sabitle
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

-- Butona bağla
createToggleButton("Pro Box ESP", function(on)
    _G.isESPBox = on
    if on then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= Players.LocalPlayer then createESPBox(p) end
        end
    end
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

local chatMessageBox = Instance.new("TextBox", frame)
chatMessageBox.Size = UDim2.new(0.88, 0, 0, 36)
chatMessageBox.Position = UDim2.new(0.06, 0, 0, 140)
chatMessageBox.PlaceholderText = "Chat mesajını gir..."
chatMessageBox.Text = "WORTHNET aktiftir!"
chatMessageBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
chatMessageBox.TextColor3 = Color3.fromRGB(0, 255, 80)
chatMessageBox.PlaceholderColor3 = Color3.fromRGB(0, 150, 50)
chatMessageBox.Font = Enum.Font.Gotham
chatMessageBox.TextSize = 14
chatMessageBox.ClearTextOnFocus = false
local chatMessageCorner = Instance.new("UICorner", chatMessageBox)
chatMessageCorner.CornerRadius = UDim.new(0, 8)
local chatMessageStroke = Instance.new("UIStroke", chatMessageBox)
chatMessageStroke.Color = Color3.fromRGB(0, 255, 80)
chatMessageStroke.Thickness = 1

local fakeNameBox = Instance.new("TextBox", frame)
fakeNameBox.Size = UDim2.new(0.88, 0, 0, 36)
fakeNameBox.Position = UDim2.new(0.06, 0, 0, 186)
fakeNameBox.PlaceholderText = "Fake isim gir..."
fakeNameBox.Text = "WORTHNET"
fakeNameBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
fakeNameBox.TextColor3 = Color3.fromRGB(0, 255, 80)
fakeNameBox.PlaceholderColor3 = Color3.fromRGB(0, 150, 50)
fakeNameBox.Font = Enum.Font.Gotham
fakeNameBox.TextSize = 14
fakeNameBox.ClearTextOnFocus = false
local fakeNameCorner = Instance.new("UICorner", fakeNameBox)
fakeNameCorner.CornerRadius = UDim.new(0, 8)
local fakeNameStroke = Instance.new("UIStroke", fakeNameBox)
fakeNameStroke.Color = Color3.fromRGB(0, 255, 80)
fakeNameStroke.Thickness = 1

local remoteSpyFrame = Instance.new("Frame", screenGui)
remoteSpyFrame.Size = UDim2.new(0, 280, 0, 220)
remoteSpyFrame.Position = UDim2.new(1, -290, 0, 10)
remoteSpyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
remoteSpyFrame.BorderSizePixel = 0
remoteSpyFrame.Visible = false
remoteSpyFrame.ZIndex = 30
local remoteSpyCorner = Instance.new("UICorner", remoteSpyFrame)
remoteSpyCorner.CornerRadius = UDim.new(0, 12)
local remoteSpyTitle = Instance.new("TextLabel", remoteSpyFrame)
remoteSpyTitle.Size = UDim2.new(1, 0, 0, 32)
remoteSpyTitle.BackgroundTransparency = 1
remoteSpyTitle.Text = "🔎 Remote Spy"
remoteSpyTitle.TextColor3 = Color3.fromRGB(0, 255, 80)
remoteSpyTitle.Font = Enum.Font.GothamBold
remoteSpyTitle.TextSize = 14
remoteSpyTitle.ZIndex = 31
local remoteSpyLogScroll = Instance.new("ScrollingFrame", remoteSpyFrame)
remoteSpyLogScroll.Size = UDim2.new(1, -10, 1, -42)
remoteSpyLogScroll.Position = UDim2.new(0, 5, 0, 37)
remoteSpyLogScroll.BackgroundTransparency = 1
remoteSpyLogScroll.BorderSizePixel = 0
remoteSpyLogScroll.ScrollBarThickness = 4
remoteSpyLogScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 80)
remoteSpyLogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
remoteSpyLogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
remoteSpyLogScroll.ZIndex = 31
local remoteSpyLogLayout = Instance.new("UIListLayout", remoteSpyLogScroll)
remoteSpyLogLayout.Padding = UDim.new(0, 4)
remoteSpyLogLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
local remoteSpyLogs = {}
local function addRemoteSpyLog(text)
    table.insert(remoteSpyLogs, 1, text)
    if #remoteSpyLogs > 20 then table.remove(remoteSpyLogs, #remoteSpyLogs) end
    for _, child in pairs(remoteSpyLogScroll:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end
    for i = 1, #remoteSpyLogs do
        local label = Instance.new("TextLabel", remoteSpyLogScroll)
        label.Size = UDim2.new(1, 0, 0, 22)
        label.BackgroundTransparency = 1
        label.Text = remoteSpyLogs[i]
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Font = Enum.Font.Code
        label.TextSize = 12
        label.ZIndex = 31
    end
end

local function formatArg(arg)
    if typeof(arg) == "Instance" then return arg:GetFullName() end
    if typeof(arg) == "string" then return arg end
    if typeof(arg) == "Vector3" or typeof(arg) == "Vector2" or typeof(arg) == "CFrame" then return tostring(arg) end
    if typeof(arg) == "table" then return "<table>" end
    return tostring(arg)
end

local function formatArgs(args)
    local out = {}
    for _, a in ipairs(args) do table.insert(out, formatArg(a)) end
    return table.concat(out, ", ")
end

local function sendChatMessage(msg)
    msg = tostring(msg or "")
    if msg == "" then return end
    if chatEvents and chatEvents:FindFirstChild("SayMessageRequest") then
        pcall(function() chatEvents.SayMessageRequest:FireServer(msg, "All") end)
    else
        pcall(function() player:Chat(msg) end)
    end
end

local function setSystemMessage(text, color)
    local success, StarterGui = pcall(function() return game:GetService("StarterGui") end)
    if success and StarterGui then
        pcall(function()
            StarterGui:SetCore("ChatMakeSystemMessage", {Text = text, Color = color or Color3.fromRGB(0, 255, 80), Font = Enum.Font.GothamBold, FontSize = Enum.FontSize.Size24})
        end)
    end
end

local function boldify(text)
    local map = {}
    for i = 1, 26 do
        map[string.char(64 + i)] = string.char(0x1D400 + i - 1)
        map[string.char(96 + i)] = string.char(0x1D41A + i - 1)
    end
    map["0"] = "𝟎" map["1"] = "𝟏" map["2"] = "𝟐" map["3"] = "𝟑" map["4"] = "𝟒" map["5"] = "𝟓" map["6"] = "𝟔" map["7"] = "𝟕" map["8"] = "𝟖" map["9"] = "𝟗"
    local result = ""
    for c in text:gmatch(".") do
        result = result .. (map[c] or c)
    end
    return result
end

local function updateFakeName()
    if fakeNameGui and fakeNameLabel then
        fakeNameLabel.Text = fakeNameBox.Text ~= "" and fakeNameBox.Text or "WORTHNET"
    end
end

local fakeNameGui = nil
local fakeNameLabel = nil
local function createFakeNameGui()
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if fakeNameGui then fakeNameGui:Destroy() end
    fakeNameGui = Instance.new("BillboardGui", head)
    fakeNameGui.Size = UDim2.new(0, 200, 0, 50)
    fakeNameGui.StudsOffset = Vector3.new(0, 2.5, 0)
    fakeNameGui.AlwaysOnTop = true
    fakeNameLabel = Instance.new("TextLabel", fakeNameGui)
    fakeNameLabel.Size = UDim2.new(1, 0, 1, 0)
    fakeNameLabel.BackgroundTransparency = 1
    fakeNameLabel.TextColor3 = Color3.fromRGB(0, 255, 80)
    fakeNameLabel.TextStrokeTransparency = 0.7
    fakeNameLabel.Font = Enum.Font.GothamBold
    fakeNameLabel.TextSize = 18
    fakeNameLabel.Text = fakeNameBox.Text ~= "" and fakeNameBox.Text or "WORTHNET"
end

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

local chatSpyConnections = {}
local function connectChatSpy(playerObj)
    if chatSpyConnections[playerObj] then return end
    chatSpyConnections[playerObj] = playerObj.Chatted:Connect(function(msg)
        if _G.isChatSpy then
            notify("[ChatSpy] " .. playerObj.Name .. ": " .. msg, Color3.fromRGB(0, 255, 255))
        end
    end)
end

Players.PlayerAdded:Connect(function(playerObj)
    if _G.isChatSpy then connectChatSpy(playerObj) end
end)

Players.PlayerRemoving:Connect(function(playerObj)
    if chatSpyConnections[playerObj] then
        chatSpyConnections[playerObj]:Disconnect()
        chatSpyConnections[playerObj] = nil
    end
end)

local blockList = {}
local function hideBlockedPlayers()
    for _, p in pairs(Players:GetPlayers()) do
        if blockList[p.UserId] and p.Character then
            for _, part in pairs(p.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("Decal") then
                    pcall(function() part.Transparency = 1 end)
                end
            end
        end
    end
end

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

createToggleButton("Remote Spy", function(on)
    _G.isRemoteSpy = on
    remoteSpyFrame.Visible = on
    if on then addRemoteSpyLog("Remote Spy açıldı") end
end)

createToggleButton("Chat Spy", function(on)
    _G.isChatSpy = on
    if on then
        for _, p in pairs(Players:GetPlayers()) do
            connectChatSpy(p)
        end
    end
end)

createToggleButton("Chat Spam", function(on)
    _G.isChatSpam = on
end)

createToggleButton("Auto Say", function(on)
    _G.isAutoSay = on
end)

createToggleButton("Rainbow Chat", function(on)
    _G.isRainbowChat = on
end)

createToggleButton("Bold Chat", function(on)
    _G.isBoldChat = on
end)

createToggleButton("Sound Spam", function(on)
    _G.isSoundSpam = on
end)

createToggleButton("Emote Spam", function(on)
    _G.isEmoteSpam = on
end)

createToggleButton("Effect Spam", function(on)
    _G.isEffectSpam = on
end)

createToggleButton("Fake Name", function(on)
    _G.isFakeName = on
    if on then
        createFakeNameGui()
    else
        if fakeNameGui then fakeNameGui:Destroy() fakeNameGui = nil end
    end
end)

createButton("Friend Manager", function()
    local success, friends = pcall(function()
        return Players:GetFriendsAsync(player.UserId)
    end)
    if success and friends then
        notify("Friend sayısı: " .. tostring(#friends), Color3.fromRGB(0, 255, 80))
    else
        notify("Friend listesi alınamadı.", Color3.fromRGB(255, 100, 100))
    end
end)

createToggleButton("Block Manager", function(on)
    _G.isBlockManager = on
    if on then hideBlockedPlayers() end
end)

createButton("Server Info", function()
    notify("Ping: " .. tostring(getServerPing()) .. " ms | Oyuncu: " .. tostring(#Players:GetPlayers()), Color3.fromRGB(0, 255, 80))
end)

createButton("Player List", function()
    notify(getPlayersInfo(), Color3.fromRGB(0, 255, 80))
end)

createButton("Link Discord", function()
    setSystemMessage("Discord: discord.gg/WORTHNET", Color3.fromRGB(0, 255, 80))
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

local function handleRemoteSpy(self, method, args)
    if not _G.isRemoteSpy then return end
    if method ~= "FireServer" and method ~= "InvokeServer" and method ~= "FireClient" and method ~= "InvokeClient" then return end
    local eventInfo = tostring(self.ClassName) .. " " .. tostring(self:GetFullName())
    addRemoteSpyLog("[" .. method .. "] " .. eventInfo .. " => " .. formatArgs(args))
end

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

local function namecallHook(self, ...)
    local args = {...}
    local method = getnamecallmethod()
    handleRemoteSpy(self, method, args)
    local modified = handleSilentAim(self, method, args)
    if modified then
        return oldNamecall(self, table.unpack(args))
    end
    return oldNamecall(self, ...)
end

if hookmetamethod then
    oldNamecall = hookmetamethod(game, "__namecall", namecallHook)
elseif getrawmetatable and newcclosure then
    local mt = getrawmetatable(game)
    if mt then
        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            handleRemoteSpy(self, method, args)
            local modified = handleSilentAim(self, method, args)
            if modified then
                return old(self, table.unpack(args))
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end
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
-- 10. ANTI-KNOCKBACK
_G.isAntiKnock = false

createToggleButton("Anti-Knockback", function(on)
	_G.isAntiKnock = on
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

local function safeServerHop()
	if not HttpService or not TeleportService then
		notify("Safe Server Hop yapılamıyor.", Color3.fromRGB(255, 100, 100))
		return
	end

	task.spawn(function()
		local placeId = game.PlaceId
		local jobId = game.JobId
		notify("Safe Server Hop aranıyor...", Color3.fromRGB(0, 255, 80))
		local url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", placeId)
		local success, result = pcall(function()
			return HttpService:GetAsync(url, true)
		end)
		if not success then
			notify("Server listesi alınamadı.", Color3.fromRGB(255, 100, 100))
			return
		end

		local data = nil
		pcall(function()
			data = HttpService:JSONDecode(result)
		end)
		if type(data) ~= "table" or type(data.data) ~= "table" then
			notify("Geçerli server verisi yok.", Color3.fromRGB(255, 100, 100))
			return
		end

		local targetServer = nil
		for _, server in ipairs(data.data) do
			if type(server) == "table" and server.id and server.playing and server.maxPlayers and server.id ~= jobId and server.playing < server.maxPlayers then
				targetServer = server.id
				break
			end
		end

		if not targetServer then
			notify("Uygun server bulunamadı.", Color3.fromRGB(255, 100, 100))
			return
		end

		pcall(function()
			TeleportService:TeleportToPlaceInstance(placeId, targetServer, player)
			notify("Yeni servera geçiliyor...", Color3.fromRGB(0, 255, 80))
		end)
	end)
end

createButton("Safe Server Hop", safeServerHop)

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

createButton("⚡ FOV Uygula", function()
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
-- 20. KILL AURA V2
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
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character then
							local r2 = p.Character:FindFirstChild("HumanoidRootPart")
							local h2 = p.Character:FindFirstChild("Humanoid")
							if r2 and h2 and h2.Health > 0 then
								if (root.Position - r2.Position).Magnitude <= 20 then
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
					for _, obj in pairs(workspace:GetDescendants()) do
						if obj:IsA("Humanoid") and obj.Parent ~= char and obj.Health > 0 then
							local r = obj.Parent:FindFirstChild("HumanoidRootPart")
							if r and (root.Position - r.Position).Magnitude <= 20 then
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
				task.wait(0.3)
			end
			local h = player.Character and player.Character:FindFirstChild("Humanoid")
			if h then h.PlatformStand = false end
		end)
	else
		local h = player.Character and player.Character:FindFirstChild("Humanoid")
		if h then h.PlatformStand = false end
	end
end)

-- ────────────────────────────────────────────────
-- 21. NO WALL CHECK
_G.isNoWall = false

createToggleButton("No Wall Check", function(on)
	_G.isNoWall = on
	if on then
		task.spawn(function()
			while _G.isNoWall do
				for _, v in pairs(workspace:GetDescendants()) do
					if v:IsA("BasePart") and not v:IsDescendantOf(player.Character or Instance.new("Folder")) then
						pcall(function() v.LocalTransparencyModifier = 0.5 end)
					end
				end
				task.wait(0.1)
			end
			for _, v in pairs(workspace:GetDescendants()) do
				if v:IsA("BasePart") then
					pcall(function() v.LocalTransparencyModifier = 0 end)
				end
			end
		end)
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
-- 23. CUSTOM WALK ANIMATION
local animLabel = Instance.new("TextLabel", scroll)
animLabel.Size = UDim2.new(0.88, 0, 0, 20)
animLabel.Text = "── Animasyon ID ──"
animLabel.BackgroundTransparency = 1
animLabel.TextColor3 = Color3.fromRGB(0, 200, 60)
animLabel.Font = Enum.Font.GothamBold
animLabel.TextSize = 12

local animBox = Instance.new("TextBox", scroll)
animBox.Size = UDim2.new(0.88, 0, 0, 36)
animBox.PlaceholderText = "ID gir (ör: 180426354)"
animBox.Text = ""
animBox.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
animBox.TextColor3 = Color3.fromRGB(0, 255, 80)
animBox.PlaceholderColor3 = Color3.fromRGB(0, 150, 50)
animBox.Font = Enum.Font.Gotham
animBox.TextSize = 13
animBox.ClearTextOnFocus = false
local animCorner = Instance.new("UICorner", animBox)
animCorner.CornerRadius = UDim.new(0, 8)
local animStroke = Instance.new("UIStroke", animBox)
animStroke.Color = Color3.fromRGB(0, 255, 80)
animStroke.Thickness = 1

local currentAnim = nil
_G.isCustomAnim = false

createToggleButton("Custom Walk Anim", function(on)
	_G.isCustomAnim = on
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	local animFolder = char:FindFirstChild("Animate")

	if on then
		local id = animBox.Text
		if id == "" then _G.isCustomAnim = false return end

		if animFolder then
			for _, animType in pairs({"walk", "run"}) do
				local folder = animFolder:FindFirstChild(animType)
				if folder then
					local animObj = folder:FindFirstChildOfClass("Animation")
					if animObj then
						animObj.AnimationId = "rbxassetid://" .. id
					end
				end
			end
		end

		if hum then
			local animator = hum:FindFirstChildOfClass("Animator")
			if animator then
				for _, track in pairs(animator:GetPlayingAnimationTracks()) do
					track:Stop()
				end
			end
			local anim = Instance.new("Animation")
			anim.AnimationId = "rbxassetid://" .. id
			currentAnim = hum:LoadAnimation(anim)
			currentAnim:Play()
			task.spawn(function()
				while _G.isCustomAnim do
					if currentAnim and not currentAnim.IsPlaying then currentAnim:Play() end
					task.wait(0.1)
				end
			end)
		end
	else
		if currentAnim then currentAnim:Stop(); currentAnim = nil end
		if animFolder then
			animFolder.Disabled = true
			task.wait(0.1)
			animFolder.Disabled = false
		end
	end
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
            local rotationSpeed = 20 -- Her karede kaç derece dönecek (5 yerine 20 yaptık)
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
-- 27. INVISIBLE

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
-- 29. DASH (E tuşu)
_G.isDash = false
local dashCooldown = false

createToggleButton("Dash", function(on)
	_G.isDash = on
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and _G.isDash and input.KeyCode == Enum.KeyCode.E and not dashCooldown then
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if root then
			dashCooldown = true
			local dir = root.CFrame.LookVector
			root.AssemblyLinearVelocity = dir * 120 + Vector3.new(0, 10, 0)
			task.wait(0.8)
			dashCooldown = false
		end
	end
end)

-- ────────────────────────────────────────────────
-- 30. SLIDE (C tuşu)
_G.isSlide = false

createToggleButton("Slide", function(on)
	_G.isSlide = on
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if not gpe and _G.isSlide and input.KeyCode == Enum.KeyCode.C then
		local char = player.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum  = char and char:FindFirstChild("Humanoid")
		if root and hum then
			local dir = root.CFrame.LookVector
			hum.WalkSpeed = 0
			root.AssemblyLinearVelocity = dir * 80
			task.wait(0.6)
			hum.WalkSpeed = tonumber(speedBox.Text) or 16
		end
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
-- 33. ITEM ESP
_G.isItemESP = false
local itemHighlights = {}

local healthOverlayEnabled = false
local healthOverlays = {}
local healthConnections = {}
local healthCache = {}

local function updateHealthOverlay(model)
	local root = model:FindFirstChild("HumanoidRootPart")
	local hum = model:FindFirstChild("Humanoid")
	if not root or not hum then return end

	local overlay = healthOverlays[model]
	if not overlay then
		local gui = Instance.new("BillboardGui")
		gui.Name = "HealthOverlay"
		gui.Adornee = root
		gui.AlwaysOnTop = true
		gui.Size = UDim2.new(0, 120, 0, 40)
		gui.StudsOffset = Vector3.new(0, 3, 0)
		gui.Parent = root

		local label = Instance.new("TextLabel", gui)
		label.Size = UDim2.new(1, 1, 1, 0)
		label.BackgroundTransparency = 1
		label.TextColor3 = Color3.fromRGB(0, 255, 80)
		label.Font = Enum.Font.GothamBold
		label.TextSize = 12
		label.TextWrapped = true
		label.TextYAlignment = Enum.TextYAlignment.Top

		healthOverlays[model] = {gui = gui, label = label}
		if not healthConnections[hum] then
			healthConnections[hum] = hum.HealthChanged:Connect(function(newHealth)
				local prev = healthCache[hum] or hum.MaxHealth
				healthCache[hum] = newHealth
				if newHealth < prev then
					local dmg = math.floor(prev - newHealth)
					local dmgGui = Instance.new("BillboardGui")
					dmgGui.Adornee = root
					dmgGui.AlwaysOnTop = true
					dmgGui.Size = UDim2.new(0, 80, 0, 30)
					dmgGui.StudsOffset = Vector3.new(0, 5, 0)
					dmgGui.Parent = root
					local dmgLabel = Instance.new("TextLabel", dmgGui)
					dmgLabel.Size = UDim2.new(1, 1, 1, 0)
					dmgLabel.BackgroundTransparency = 1
					dmgLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
					dmgLabel.Font = Enum.Font.GothamBold
					dmgLabel.TextSize = 16
					dmgLabel.Text = "-" .. dmg
					game:GetService("Debris"):AddItem(dmgGui, 0.7)
				end
			end)
		end
	end

	local info = healthOverlays[model]
	if info and info.label then
		info.label.Text = string.format("HP: %d/%d", math.floor(hum.Health), math.floor(hum.MaxHealth or 0))
	end
end

local function clearHealthOverlays()
	for model, info in pairs(healthOverlays) do
		if info.gui and info.gui.Parent then
			info.gui:Destroy()
		end
		healthOverlays[model] = nil
	end
	for hum, conn in pairs(healthConnections) do
		if conn then conn:Disconnect() end
		healthConnections[hum] = nil
		healthCache[hum] = nil
	end
end

createToggleButton("Health Overlay", function(on)
	healthOverlayEnabled = on
	if not on then
		clearHealthOverlays()
		return
	end
	task.spawn(function()
		while healthOverlayEnabled do
			for _, obj in pairs(workspace:GetDescendants()) do
				if obj:IsA("Model") and obj ~= player.Character and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
					updateHealthOverlay(obj)
				end
			end
			task.wait(1)
		end
	end)
end)

createToggleButton("Item ESP", function(on)
	_G.isItemESP = on
	if on then
		task.spawn(function()
			while _G.isItemESP do
				for _, obj in pairs(workspace:GetDescendants()) do
					if obj:IsA("Tool") and not itemHighlights[obj.Name .. tostring(obj)] then
						local hl = Instance.new("Highlight", obj)
						hl.FillColor = Color3.fromRGB(255, 255, 0)
						hl.OutlineColor = Color3.fromRGB(255, 255, 0)
						hl.FillTransparency = 0.4
						itemHighlights[obj.Name .. tostring(obj)] = hl
					end
				end
				task.wait(1)
			end
		end)
	else
		for _, hl in pairs(itemHighlights) do
			if hl then hl:Destroy() end
		end
		itemHighlights = {}
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
-- 37-40. CUSTOM ANİMASYONLAR (Hepsi Ninja)
local NINJA_ID = "656118852"

local function applyAnim(animName, id)
	local char = player.Character
	if not char then return end
	local hum = char:FindFirstChild("Humanoid")
	local animFolder = char:FindFirstChild("Animate")
	if not (hum and animFolder) then return end

	local folder = animFolder:FindFirstChild(animName)
	if folder then
		local animObj = folder:FindFirstChildOfClass("Animation")
		if animObj then
			animObj.AnimationId = "rbxassetid://" .. id
		end
	end

	-- Animator'ı yenile
	local animator = hum:FindFirstChildOfClass("Animator")
	if animator then
		for _, track in pairs(animator:GetPlayingAnimationTracks()) do
			if track.Name == animName then track:Stop() end
		end
	end
end

createToggleButton("Ninja Idle Anim", function(on)
	if on then applyAnim("idle", NINJA_ID)
	else
		local animFolder = player.Character and player.Character:FindFirstChild("Animate")
		if animFolder then animFolder.Disabled = true task.wait(0.1) animFolder.Disabled = false end
	end
end)

createToggleButton("Ninja Jump Anim", function(on)
	if on then applyAnim("jump", NINJA_ID)
	else
		local animFolder = player.Character and player.Character:FindFirstChild("Animate")
		if animFolder then animFolder.Disabled = true task.wait(0.1) animFolder.Disabled = false end
	end
end)

createToggleButton("Ninja Fall Anim", function(on)
	if on then applyAnim("fall", NINJA_ID)
	else
		local animFolder = player.Character and player.Character:FindFirstChild("Animate")
		if animFolder then animFolder.Disabled = true task.wait(0.1) animFolder.Disabled = false end
	end
end)

createToggleButton("Ninja Death Anim", function(on)
	if on then applyAnim("death", NINJA_ID)
	else
		local animFolder = player.Character and player.Character:FindFirstChild("Animate")
		if animFolder then animFolder.Disabled = true task.wait(0.1) animFolder.Disabled = false end
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
