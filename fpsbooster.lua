-- [[ xAworth - Ultimate FPS Booster & Texture Cleaner ]] --

local success, err = pcall(function()
    
    -- Bildirim
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Ultimate FPS Boost Aktif",
        Text = "Texture'lar silindi, gece modu ve özel sky uygulandı!",
        Duration = 3
    })

    -- 1. Aydınlatma ve Gölgeleri Kökten Kapatma (Gece Modu)
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 9e9
    Lighting.FogStart = 9e9
    Lighting.Brightness = 1.2 -- Parlaklığı hafif açtık ki karanlıkta kör olmayasın
    Lighting.ClockTime = 0 -- Saati gece 00:00 yap (Karanlık ve performanslı)
    Lighting.OutdoorAmbient = Color3.fromRGB(100, 100, 100) -- Karanlıkta önünü görebilmek için hafif ortam ışığı
    
    -- Eski efektleri ve gökyüzünü temizle
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Clouds") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") then
            v:Destroy()
        end
    end

    -- İstediğin Custom Sky'ı ekle
    local CustomSky = Instance.new("Sky")
    CustomSky.Name = "xAworthCustomSky"
    CustomSky.SkyboxBk = "rbxassetid://128576416164363"
    CustomSky.SkyboxDn = "rbxassetid://128576416164363"
    CustomSky.SkyboxFt = "rbxassetid://128576416164363"
    CustomSky.SkyboxLf = "rbxassetid://128576416164363"
    CustomSky.SkyboxRt = "rbxassetid://128576416164363"
    CustomSky.SkyboxUp = "rbxassetid://128576416164363"
    CustomSky.Parent = Lighting

    -- 2. Workspace İçindeki Her Şeyi Temizleme ve Texture'ları Yok Etme
    local Workspace = game:GetService("Workspace")
    Workspace.StreamingEnabled = true
    
    for _, v in pairs(Workspace:GetDescendants()) do
        -- Parçaların üzerindeki bütün ağır texture (doku) ve decal'leri yok et (FPS'i en çok uçuran kısımdır)
        if v:IsA("Texture") or v:IsA("Decal") then
            v:Destroy()
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
            v.Reflectance = 0
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") or v:IsA("Fire") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v:Destroy() -- Efektleri tamamen silerek bellekten tasarruf et
        elseif v:IsA("Explosion") then
            v.Visible = false
        end
    end

    -- Yeni sonradan yüklenen parçaları da korumak için Workspace dinleyicisi
    Workspace.DescendantAdded:Connect(function(v)
        if v:IsA("Texture") or v:IsA("Decal") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            task.spawn(function()
                v:Destroy()
            end)
        elseif v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic
            v.CastShadow = false
        end
    end)

    -- 3. Render ve Kalite Ayarları
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

    print("[xAworth Optimizer] Her şey başarıyla optimize edildi ve temizlendi!")
end)

if not success then
    warn("[xAworth Optimizer] Hata: " .." ".. tostring(err))
end
