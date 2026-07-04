-- WORTHNET V4.0 | MASTER ENGINE [PART 1: UI LIBRARY]
local WorthNet = {}
local TweenService = game:GetService("TweenService")

-- HoneyLua Tarzı Neon Vurgulu Tema
WorthNet.Theme = {
    Main = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(255, 100, 0),
    Text = Color3.fromRGB(255, 255, 255),
    Button = Color3.fromRGB(30, 30, 30)
}

function WorthNet:Init(name)
    local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 700, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
    MainFrame.BackgroundColor3 = self.Theme.Main
    MainFrame.Active = true; MainFrame.Draggable = true
    
    -- Neon Stroke
    local stroke = Instance.new("UIStroke", MainFrame)
    stroke.Color = self.Theme.Accent
    stroke.Thickness = 1.5
    
    -- HoneyLua'daki Arama Barı ve Config Manager İskeleti
    local TopBar = Instance.new("Frame", MainFrame)
    TopBar.Size = UDim2.new(1, 0, 0, 50)
    TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    
    local SearchBox = Instance.new("TextBox", TopBar)
    SearchBox.Size = UDim2.new(0, 200, 0, 30)
    SearchBox.Position = UDim2.new(0.5, -100, 0.1, 10)
    SearchBox.PlaceholderText = "Search..."
    SearchBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    
    return MainFrame
end

-- BURADAN SONRASI DEVAM EDECEK (Sayfa Yönetimi, Configs, Togglelar)
