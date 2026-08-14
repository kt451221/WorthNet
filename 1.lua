-- // WorthNet - Gradient & Animasyonlu Cam Tasarım Sürümü
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local MarketplaceService = game:GetService("MarketplaceService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local success, PlaceInfo = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
end)
local CurrentGameName = success and PlaceInfo.Name or "Bilinmeyen Oyun"

-- Eski UI'ı temizle
if CoreGui:FindFirstChild("WorthNetUI") then 
    CoreGui.WorthNetUI:Destroy() 
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WorthNetUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Ana Menü Penceresi
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 580, 0, 500)
MainFrame.Position = UDim2.new(0.5, -290, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 14, 24)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 14)
UICorner.Parent = MainFrame

-- Arka Plan Resmi
local Background = Instance.new("ImageLabel")
Background.Name = "BackgroundImage"
Background.Size = UDim2.new(1, 0, 1, 0)
Background.Image = "rbxassetid://118769314747652" 
Background.ScaleType = Enum.ScaleType.Crop
Background.BackgroundTransparency = 1
Background.ImageTransparency = 0.15
Background.ZIndex = 1
Background.Parent = MainFrame

-- Atmosferik Arka Plan Degradesi
local MainGradient = Instance.new("UIGradient")
MainGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 25, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(8, 10, 16))
})
MainGradient.Rotation = 45
MainGradient.Parent = MainFrame

-- Sol Üst Profil Alanı (Şeffaf Cam)
local ProfileContainer = Instance.new("Frame")
ProfileContainer.Size = UDim2.new(0, 310, 0, 50)
ProfileContainer.Position = UDim2.new(0, 15, 0, 15)
ProfileContainer.BackgroundColor3 = Color3.fromRGB(15, 22, 38)
ProfileContainer.BackgroundTransparency = 0.4
ProfileContainer.ZIndex = 2
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
AvatarImage.ZIndex = 3
AvatarImage.Parent = ProfileContainer

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarImage

-- Profil Metni (DisplayName | GameName)
local ProfileText = Instance.new("TextLabel")
ProfileText.Size = UDim2.new(1, -55, 1, 0)
ProfileText.Position = UDim2.new(0, 50, 0, 0)
ProfileText.BackgroundTransparency = 1
ProfileText.Text = LocalPlayer.DisplayName .. " | " .. CurrentGameName
ProfileText.TextColor3 = Color3.fromRGB(240, 245, 255)
ProfileText.Font = Enum.Font.GothamBold
ProfileText.TextSize = 11
ProfileText.TextXAlignment = Enum.TextXAlignment.Left
ProfileText.ZIndex = 3
ProfileText.Parent = ProfileContainer

-- Sağ Üst Kontrol Butonları ("X" Kapat ve "-" Küçült)
local ButtonContainer = Instance.new("Frame")
ButtonContainer.Size = UDim2.new(0, 80, 0, 30)
ButtonContainer.Position = UDim2.new(1, -95, 0, 25)
ButtonContainer.BackgroundTransparency = 1
ButtonContainer.ZIndex = 5
ButtonContainer.Parent = MainFrame

local CloseButton = Instance.new("TextButton")
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.BackgroundTransparency = 0.2
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 12
CloseButton.ZIndex = 6
CloseButton.Parent = ButtonContainer

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseButton

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(1, -70, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 50, 80)
MinimizeButton.BackgroundTransparency = 0.2
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextSize = 16
MinimizeButton.ZIndex = 6
MinimizeButton.Parent = ButtonContainer

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeButton

-- Küçülmüş Logo (Yüzen Simge)
local FloatingIcon = Instance.new("ImageButton")
FloatingIcon.Name = "FloatingLogo"
FloatingIcon.Size = UDim2.new(0, 60, 0, 60)
FloatingIcon.Position = UDim2.new(0, 30, 0.5, -30)
FloatingIcon.Image = "rbxassetid://118769314747652"
FloatingIcon.ScaleType = Enum.ScaleType.Crop
FloatingIcon.Visible = false
FloatingIcon.ZIndex = 10
FloatingIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(1, 0)
IconCorner.Parent = FloatingIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(100, 180, 255)
IconStroke.Thickness = 2
IconStroke.Parent = FloatingIcon

-- Buton Animasyon İşlevleri
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

-- Sol Sekme Paneli
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 160, 0, 405)
TabContainer.Position = UDim2.new(0, 15, 0, 78)
TabContainer.BackgroundTransparency = 1
TabContainer.ZIndex = 2
TabContainer.Parent = MainFrame

-- Sağ Hile İçerik Alanı
local ContentContainer = Instance.new("ScrollingFrame")
ContentContainer.Size = UDim2.new(0, 380, 0, 405)
ContentContainer.Position = UDim2.new(0, 185, 0, 78)
ContentContainer.BackgroundTransparency = 1
ContentContainer.BorderSizePixel = 0
ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentContainer.ScrollBarThickness = 2
ContentContainer.ZIndex = 2
ContentContainer.Parent = MainFrame

-- Gradyentli & Uyumlu Sekme Oluşturucu
local function CreateGameTab(name, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.1
    btn.Text = "  " .. name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.ZIndex = 3
    btn.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn
    
    -- Butona Uyumlu Buz Mavisi Degrade
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 50, 85)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 25, 45))
    })
    grad.Rotation = 90
    grad.Parent = btn
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(70, 130, 200)
    stroke.Transparency = 0.5
    stroke.Parent = btn
    
    return btn
end

-- Gradyentli Hile Özelliği (Toggle) Oluşturucu
local function CreateFeatureToggle(featureName, posY)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.Position = UDim2.new(0, 0, 0, posY)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    toggleFrame.BackgroundTransparency = 0.1
    toggleFrame.ZIndex = 3
    toggleFrame.Parent = ContentContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = toggleFrame
    
    -- İçerik Kutularına Şık Uyumlu Degrade
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 35, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 18, 32))
    })
    grad.Rotation = 90
    grad.Parent = toggleFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 110, 180)
    stroke.Transparency = 0.6
    stroke.Parent = toggleFrame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = featureName
    label.TextColor3 = Color3.fromRGB(240, 245, 255)
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 12
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4
    label.Parent = toggleFrame
    
    local switch = Instance.new("TextButton")
    switch.Size = UDim2.new(0, 40, 0, 20)
    switch.Position = UDim2.new(1, -50, 0.5, -10)
    switch.BackgroundColor3 = Color3.fromRGB(40, 70, 110)
    switch.Text = ""
    switch.ZIndex = 4
    switch.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switch
    
    -- Toggle Tıklama Animasyonu ve Mantığı
    local toggled = false
    switch.MouseButton1Click:Connect(function()
        toggled = not toggled
        local targetColor = toggled and Color3.fromRGB(60, 200, 120) or Color3.fromRGB(40, 70, 110)
        TweenService:Create(switch, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)
end

-- Akıllı Oyun Sekmeleri ve Hileleri (Yeni oyun eklemek için burayı çoğaltabilirsin)
if string.find(string.lower(CurrentGameName), "mm2") or string.find(string.lower(CurrentGameName), "murder") or string.find(string.lower(CurrentGameName), "1v1") then
    CreateGameTab("🎯 Rol Gösterici (ESP)", 0)
    CreateGameTab("🔫 Silah / Bıçak Aura", 45)
    CreateGameTab("⚡ Hız & Zıplama", 90)
    CreateGameTab("🛠️ Güvenli Bölge Farm", 135)
    
    CreateFeatureToggle("Şerif ve Katil ESP", 0)
    CreateFeatureToggle("Bıçak Menzil Uzatma", 45)
    CreateFeatureToggle("Otomatik Silah Alma", 90)
elseif string.find(string.lower(CurrentGameName), "blox fruits") then
    CreateGameTab("⚔️ Oto Quest & Farm", 0)
    CreateGameTab(" devil Fruit Finder", 45)
    CreateGameTab("💨 Instant Teleport", 90)
    CreateGameTab("🛡️ Raid Bot", 135)
    
    CreateFeatureToggle("Auto Hit / Kill Aura", 0)
    CreateFeatureToggle("Fast Attack Bypass", 45)
else
    CreateGameTab("⚙️ Oyun İçi Modlar", 0)
    CreateGameTab("🚀 Hızlı İşlemler", 45)
    
    CreateFeatureToggle("Genel Uçuş (Fly)", 0)
    CreateFeatureToggle("Duvardan Geçme (Noclip)", 45)
end

-- Sürükleme Mantığı (Mobil & PC)
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

print("WorthNet Gradient & Animasyonlu Sürüm Aktif Edildi!")
