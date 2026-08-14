-- // WorthNet - MM2 Custom Edition (Fixed Tabs & Background Image)
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local ProtectedParent = CoreGui
if syn and syn.protect_gui then
    local gui = Instance.new("ScreenGui")
    syn.protect_gui(gui)
    ProtectedParent = gui
elseif gethui then
    ProtectedParent = gethui()
end

local success, PlaceInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
local CurrentGameName = success and PlaceInfo.Name or "Bilinmeyen Oyun"

if ProtectedParent:FindFirstChild("WorthNetUI") then 
    ProtectedParent.WorthNetUI:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WorthNetUI"
ScreenGui.Parent = ProtectedParent
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 500)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 20, 35)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.ZIndex = 2
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Arka Plan Görseli (İstediğin ID ile)
local Background = Instance.new("ImageLabel")
Background.Name = "BackgroundImage"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Image = "rbxassetid://118769314747652" 
Background.ScaleType = Enum.ScaleType.Crop
Background.BackgroundTransparency = 1
Background.ImageTransparency = 0.35 -- Görselin net görünmesi için saydamlık ayarlandı
Background.ZIndex = 1
Background.Parent = MainFrame

local ProfileContainer = Instance.new("Frame")
ProfileContainer.Size = UDim2.new(0, 310, 0, 50)
ProfileContainer.Position = UDim2.new(0, 15, 0, 15)
ProfileContainer.BackgroundColor3 = Color3.fromRGB(15, 22, 38)
ProfileContainer.BackgroundTransparency = 0.4
ProfileContainer.ZIndex = 5
ProfileContainer.Parent = MainFrame

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 25)
ProfileCorner.Parent = ProfileContainer

local ProfileStroke = Instance.new("UIStroke")
ProfileStroke.Color = Color3.fromRGB(80, 140, 220)
ProfileStroke.Transparency = 0.6
ProfileStroke.Parent = ProfileContainer

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 38, 0, 38)
AvatarImage.Position = UDim2.new(0, 6, 0.5, -19)
AvatarImage.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
AvatarImage.BackgroundTransparency = 1
AvatarImage.ZIndex = 6
AvatarImage.Parent = ProfileContainer

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

local ProfileText = Instance.new("TextLabel")
ProfileText.Size = UDim2.new(1, -55, 1, 0)
ProfileText.Position = UDim2.new(0, 50, 0, 0)
ProfileText.BackgroundTransparency = 1
ProfileText.Text = LocalPlayer.DisplayName .. " | " .. CurrentGameName
ProfileText.TextColor3 = Color3.fromRGB(255, 255, 255)
ProfileText.Font = Enum.Font.FredokaOne
ProfileText.TextSize = 13
ProfileText.TextXAlignment = Enum.TextXAlignment.Left
ProfileText.ZIndex = 6
ProfileText.Parent = ProfileContainer

local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(0, 75, 0, 30)
ButtonContainer.Position = UDim2.new(1, -85, 0, 15)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.ZIndex = 10
ButtonContainer.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 32, 0, 30)
CloseButton.Position = UDim2.new(1, -32, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
CloseButton.BackgroundTransparency = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 13
CloseButton.ZIndex = 11
CloseButton.Parent = ButtonContainer

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 4)
CloseCorner.Parent = CloseButton

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 32, 0, 30)
MinimizeButton.Position = UDim2.new(1, -68, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 60, 90)
MinimizeButton.BackgroundTransparency = 0
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.ZIndex = 11
MinimizeButton.Parent = ButtonContainer

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 4)
MinimizeCorner.Parent = MinimizeButton

local FloatingIcon = Instance.new("ImageButton")
FloatingIcon.Name = "FloatingLogo"
FloatingIcon.Size = UDim2.new(0, 60, 0, 60)
FloatingIcon.Position = UDim2.new(0, 30, 0.5, -30)
FloatingIcon.Image = "rbxassetid://118769314747652"
FloatingIcon.ScaleType = Enum.ScaleType.Crop
FloatingIcon.Visible = false
FloatingIcon.ZIndex = 100
FloatingIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(100, 180, 255)
IconStroke.Thickness = 2
IconStroke.Parent = FloatingIcon

local iconDragging, iconDragStart, iconStartPos
FloatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = true
        iconDragStart = input.Position
        iconStartPos = FloatingIcon.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        iconDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if iconDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - iconDragStart
        FloatingIcon.Position = UDim2.new(iconStartPos.X.Scale, iconStartPos.X.Offset + delta.X, iconStartPos.Y.Scale, iconStartPos.Y.Offset + delta.Y)
    end
end)

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinimizeButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    FloatingIcon.Visible = true
end)

FloatingIcon.MouseButton1Click:Connect(function()
    FloatingIcon.Visible = false
    MainFrame.Visible = true
end)

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 160, 0, 405)
TabContainer.Position = UDim2.new(0, 15, 0, 78)
TabContainer.BackgroundTransparency = 1
TabContainer.ZIndex = 5
TabContainer.Parent = MainFrame

local PagesFolder = Instance.new("Folder")
PagesFolder.Name = "PagesFolder"
PagesFolder.Parent = MainFrame

local function CreatePage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(0, 380, 0, 405)
    page.Position = UDim2.new(0, 185, 0, 78)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.ScrollBarThickness = 2
    page.ZIndex = 5
    page.Visible = false
    page.Parent = PagesFolder
    return page
end

local function CreateGameTab(name, posY, targetPage)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, posY)
    -- İstediğin gibi Tab arka plan rengi güncellendi ve yazılar tamamen beyaz yapıldı
    btn.BackgroundColor3 = Color3.fromRGB(22, 32, 52)
    btn.BackgroundTransparency = 0.2
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 6
    btn.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 130, 200)
    stroke.Transparency = 0.4
    stroke.Parent = btn

    -- Tab Değiştirme Sorunu Giderildi
    btn.MouseButton1Click:Connect(function()
        for _, page in ipairs(PagesFolder:GetChildren()) do
            page.Visible = false
        end
        targetPage.Visible = true
    end)
    
    return btn
end

local function CreateFeatureToggle(parentPage, featureName, posY, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.Position = UDim2.new(0, 0, 0, posY)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(20, 28, 48)
    toggleFrame.BackgroundTransparency = 0.3
    toggleFrame.ZIndex = 6
    toggleFrame.Parent = parentPage
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggleFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 110, 180)
    stroke.Transparency = 0.5
    stroke.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = featureName
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 7
    label.Parent = toggleFrame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = Color3.fromRGB(40, 70, 110)
    switch.Text = ""
    switch.ZIndex = 7
    switch.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    local toggled = false
    switch.MouseButton1Click:Connect(function()
        toggled = not toggled
        local targetColor = toggled and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(40, 70, 110)
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
        if callback then
            callback(toggled)
        end
    end)
end

-- Oyun Kontrolü (Cinayet Gizemi / MM2)
local lowerName = string.lower(CurrentGameName)
if string.find(lowerName, "mm2") or string.find(lowerName, "murder") or string.find(lowerName, "cinayet") then
    
    local pageVisuals = CreatePage("Visuals")
    local pagePlayer = CreatePage("Player")
    local pageMain = CreatePage("Main")
    
    pageESP.Visible = true -- İlk açılışta ESP sayfası görünür
    
    CreateGameTab("Player", 0, pagePlayer)
    CreateGameTab("Visuals", 45, pageVisuals)
    CreateGameTab("Main", 90, pageMain)
    
    local mm2Highlights = {}
    local mm2Tags = {}
    local mm2ESPActive = false
    
    local function removeMM2ESP()
        for _, hl in pairs(mm2Highlights) do if hl then hl:Destroy() end end
        for _, tag in pairs(mm2Tags) do if tag then tag:Destroy() end end
        table.clear(mm2Highlights)
        table.clear(mm2Tags)
    end

    local function getMurderer()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local backpack = p:FindFirstChild("Backpack")
                local char = p.Character
                if (backpack and (backpack:FindFirstChild("Knife") or backpack:FindFirstChild("MurdererKnife"))) or
                   (char:FindFirstChild("Knife") or char:FindFirstChild("MurdererKnife")) then
                    return p
                end
            end
        end
        return nil
    end

    local function getCoinContainer()
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj.Name == "CoinContainer" or obj.Name == "Coins" then
                return obj
            end
        end
        return nil
    end

    CreateFeatureToggle(pageVisuals, "MM2 Rol ESP (Katil/Şerif)", 0, function(state)
        mm2ESPActive = state
        if not mm2ESPActive then
            removeMM2ESP()
        else
            task.spawn(function()
                while mm2ESPActive do
                    task.wait(0.4)
                    for _, p in ipairs(Players:GetPlayers()) do
                        if not mm2ESPActive then break end
                        if p ~= LocalPlayer and p.Character then
                            local char = p.Character
                            local hrp = char:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local roleName = "Masum"
                                local roleColor = Color3.fromRGB(0, 255, 0)
                                
                                local backpack = p:FindFirstChild("Backpack")
                                if (backpack and (backpack:FindFirstChild("Knife") or backpack:FindFirstChild("MurdererKnife"))) or
                                   (char:FindFirstChild("Knife") or char:FindFirstChild("MurdererKnife")) then
                                    roleName = "Katil"
                                    roleColor = Color3.fromRGB(255, 0, 0)
                                elseif (backpack and (backpack:FindFirstChild("Gun") or backpack:FindFirstChild("Revolver"))) or
                                       (char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")) then
                                    roleName = "Şerif"
                                    roleColor = Color3.fromRGB(0, 140, 255)
                                end
                                
                                if not mm2Highlights[p.Name] or mm2Highlights[p.Name].Parent ~= char then
                                    if mm2Highlights[p.Name] then mm2Highlights[p.Name]:Destroy() end
                                    local hl = Instance.new("Highlight", char)
                                    hl.FillTransparency = 0.5
                                    hl.OutlineTransparency = 0
                                    mm2Highlights[p.Name] = hl
                                end
                                mm2Highlights[p.Name].FillColor = roleColor
                                mm2Highlights[p.Name].OutlineColor = roleColor
                                
                                local head = char:FindFirstChild("Head")
                                if head then
                                    local tag = mm2Tags[p.Name]
                                    if not tag or tag.Adornee ~= head then
                                        if tag then tag:Destroy() end
                                        local bg = Instance.new("BillboardGui")
                                        bg.Size = UDim2.new(0, 110, 0, 45)
                                        bg.StudsOffset = Vector3.new(0, 2.5, 0)
                                        bg.AlwaysOnTop = true
                                        bg.Adornee = head
                                        
                                        local txt = Instance.new("TextLabel", bg)
                                        txt.Size = UDim2.new(1, 0, 1, 0)
                                        txt.BackgroundTransparency = 1
                                        txt.TextColor3 = Color3.fromRGB(255, 255, 255)
                                        txt.TextScaled = true
                                        txt.Font = Enum.Font.SourceSansBold
                                        txt.TextStrokeTransparency = 0
                                        
                                        bg.Parent = char
                                        mm2Tags[p.Name] = bg
                                        tag = bg
                                    end
                                    local tagLabel = tag:FindFirstChildOfClass("TextLabel")
                                    if tagLabel then
                                        tagLabel.Text = p.Name .. "\n[" .. roleName .. "]"
                                        tagLabel.TextColor3 = roleColor
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end)

    CreateFeatureToggle(pageMain, "Auto Coin Farm", 0, function(state)
        _G.AutoCoinActive = state
    end)

    task.spawn(function()
        local collectedCount = 0
        while task.wait(0.5) do
            if _G.AutoCoinActive then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local murderer = getMurderer()
                    local isSafe = true
                    if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                        if (hrp.Position - murderer.Character.HumanoidRootPart.Position).Magnitude < 18 then
                            isSafe = false
                        end
                    end
                    
                    if isSafe then
                        local coinContainer = getCoinContainer()
                        if coinContainer then
                            for _, coinPart in ipairs(coinContainer:GetChildren()) do
                                if not _G.AutoCoinActive then break end
                                if coinPart.Name == "Coin_Server" and coinPart:IsA("BasePart") then
                                    while coinPart and coinPart.Parent and _G.AutoCoinActive do
                                        local targetPos = coinPart.Position - Vector3.new(0, 3.5, 0)
                                        local distance = (hrp.Position - coinPart.Position).Magnitude
                                        if distance < 2 then break end
                                        
                                        local step = RunService.Heartbeat:Wait()
                                        local direction = (targetPos - hrp.Position).Unit
                                        hrp.CFrame = hrp.CFrame + (direction * math.min(16 * step, (targetPos - hrp.Position).Magnitude))
                                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                                    end
                                    collectedCount = collectedCount + 1
                                    if collectedCount >= 55 then
                                        local humanoid = char:FindFirstChildOfClass("Humanoid")
                                        if humanoid then humanoid.Health = 0 end
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
        end
    end)

    CreateFeatureToggle(pageMain, "Auto GunDrop", 0, function(state)
        _G.AutoGunDropEnabled = state
    end)

    task.spawn(function()
        while true do
            task.wait(0.05)
            if _G.AutoGunDropEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                local hasKnife = (backpack and backpack:FindFirstChild("Knife")) or LocalPlayer.Character:FindFirstChild("Knife")
                
                if not hasKnife then
                    local rootPart = LocalPlayer.Character.HumanoidRootPart
                    local originalCFrame = rootPart.CFrame
                    local targetPart = nil

                    for _, item in ipairs(workspace:GetChildren()) do
                        if item.Name == "GunDrop" then
                            targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChildWhichIsA("BasePart")) or (item:IsA("BasePart") and item)
                            if targetPart then break end
                        end
                    end

                    if targetPart then
                        pcall(function()
                            rootPart.CFrame = targetPart.CFrame + Vector3.new(0, 2, 0)
                            if targetPart:IsA("BasePart") and firetouchinterest then
                                firetouchinterest(rootPart, targetPart, 0)
                                firetouchinterest(rootPart, targetPart, 1)
                            end
                            task.wait()
                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                rootPart.CFrame = originalCFrame
                                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            end
                        end)
                    end
                end
            end
        end
    end)

else
    local pageGeneral = CreatePage("General")
    pageGeneral.Visible = true
    CreateGameTab("⚙️ Genel Modlar", 0, pageGeneral)
    CreateFeatureToggle(pageGeneral, "Genel Uçuş (Fly)", 0)
    CreateFeatureToggle(pageGeneral, "Duvardan Geçme (Noclip)", 45)
end

local dragging, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

print("WorthNet Tamamen Güncellendi!")
