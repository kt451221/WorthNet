-- [[ xAworth - Ultimate God-Tier FPS Booster & Memory Cleaner ]] --

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local function optimizeGame()
    pcall(function()

        SoundService.Volume = 0.5 
        
 
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.FogStart = 9e9
        Lighting.Brightness = 1.3
        Lighting.ClockTime = 0
        Lighting.OutdoorAmbient = Color3.fromRGB(120, 120, 120)
        
        for _, v in pairs(Lighting:GetChildren()) do
            if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Clouds") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
                v:Destroy()
            end
        end


        if not Lighting:FindFirstChild("xAworthCustomSky") then
            local CustomSky = Instance.new("Sky")
            CustomSky.Name = "xAworthCustomSky"
            CustomSky.SkyboxBk = "rbxassetid://128576416164363"
            CustomSky.SkyboxDn = "rbxassetid://128576416164363"
            CustomSky.SkyboxFt = "rbxassetid://128576416164363"
            CustomSky.SkyboxLf = "rbxassetid://128576416164363"
            CustomSky.SkyboxRt = "rbxassetid://128576416164363"
            CustomSky.SkyboxUp = "rbxassetid://128576416164363"
            CustomSky.Parent = Lighting
        end


        Workspace.StreamingEnabled = true
        
        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("Texture") or v:IsA("Decal") then
                v:Destroy()
            elseif v:IsA("BasePart") then
                if v.Material ~= Enum.Material.SmoothPlastic or v.CastShadow == true then
                    v.Material = Enum.Material.SmoothPlastic
                    v.CastShadow = false
                    v.Reflectance = 0
                end
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v:Destroy()
            elseif v:IsA("Explosion") then
                v.Visible = false
            end
        end


        local Terrain = Workspace:FindFirstChildOfClass("Terrain")
        if Terrain then
            Terrain.WaterWaveSize = 0
            Terrain.WaterWaveSpeed = 0
            Terrain.WaterTransparency = 0
            Terrain.WaterReflectance = 0
        end

        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
        
        if setfpscap then
            setfpscap(999)
        end


        task.defer(function()
            collectgarbage("collect")
        end)
    end)
end


pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Memory & FPS Booster",
        Text = "Bellek temizliği ve otomatik döngü aktif!",
        Duration = 3
    })
end)


task.spawn(function()
    while true do
        optimizeGame()
        task.wait(4) 
    end
end)
