-- WORTHNET V3.0 CORE ENGINE
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function createNeonFrame(parent, size, pos, color)
    local frame = Instance.new("Frame", parent)
    frame.Size = size
    frame.Position = pos
    frame.BackgroundColor3 = color
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 100, 0) -- Neon Turuncu Vurgu
    stroke.Thickness = 1.2
    return frame
end

local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
local MainUI = createNeonFrame(ScreenGui, UDim2.new(0, 650, 0, 420), UDim2.new(0.5, -325, 0.5, -210), Color3.fromRGB(20, 20, 20))
MainUI.Active = true; MainUI.Draggable = true

-- Sol Menü (Tablar için)
local LeftTab = Instance.new("Frame", MainUI)
LeftTab.Size = UDim2.new(0, 160, 1, 0)
LeftTab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", LeftTab).CornerRadius = UDim.new(0, 8)

-- Orta (İçerik) Alanı
local ContentFrame = Instance.new("Frame", MainUI)
ContentFrame.Size = UDim2.new(1, -170, 1, -10)
ContentFrame.Position = UDim2.new(0, 165, 0, 5)
ContentFrame.BackgroundTransparency = 1

-- Sayfa Yöneticisi
local currentPage = "Page1"

-- BUTON ANIMASYONU (HoneyLua Kalitesi)
local function animateBtn(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)
end

-- Sayfa Oluşturucu (10'ar Oyunluk)
local function buildPage(pageNumber)
    ContentFrame:ClearAllChildren()
    local Grid = Instance.new("UIGridLayout", ContentFrame)
    Grid.CellSize = UDim2.new(0, 140, 0, 50)
    Grid.Padding = UDim2.new(0, 10, 0, 10)
    
    for i = 1, 10 do
        local btn = Instance.new("TextButton", ContentFrame)
        btn.Text = "Game " .. ((pageNumber-1)*10 + i)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", btn)
        animateBtn(btn)
        
        btn.MouseButton1Click:Connect(function()
            -- OYUN AÇILDIĞINDA MENÜ DEĞİŞİMİ
            print("Oyun Menüsüne Geçiş Yapıldı")
        end)
    end
end

-- Sol Menü (Tablar)
for i = 1, 5 do
    local tabBtn = Instance.new("TextButton", LeftTab)
    tabBtn.Size = UDim2.new(0.9, 0, 0, 40)
    tabBtn.Position = UDim2.new(0.05, 0, 0, 10 + (i-1)*50)
    tabBtn.Text = "Page " .. i
    tabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", tabBtn)
    animateBtn(tabBtn)
    
    tabBtn.MouseButton1Click:Connect(function()
        buildPage(i)
    end)
end

buildPage(1) -- İlk sayfa yükle
