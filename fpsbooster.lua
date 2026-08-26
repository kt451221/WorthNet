-- [[ xAworth - Advanced Client FPS Booster & Bypass Script ]] --

-- 1. Hata Yakalama (Bypass / Güvenlik Kalkanı)
-- Oyunun güvenlik sistemlerinin script yüzünden anında çökmesini önlemek için pcall kullanıyoruz.
local success, err = pcall(function()
    
    -- Bildirim / Bilgi
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "FPS Booster Aktif",
        Text = "Grafikler düşürüldü ve gereksiz efektler kapatıldı!",
        Duration = 3
    })

    -- 2. Lighting (Işıklandırma ve Gölgeler) Optimizasyonu
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 999999
    Lighting.Brightness = 1
    
    -- Işık efektlerini ve post-processing ögelerini temizle
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("Sky") or v:IsA("Clouds") then
            v.Enabled = false
            -- İsteğe bağlı tamamen silmek için: v:Destroy()
        end
    end

    -- 3. Workspace (Dünya ve Parçalar) Optimizasyonu
    local Workspace = game:GetService("Workspace")
    Workspace.StreamingEnabled = true -- Bellek tasarrufu için parça yükleme optimizasyonu
    
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.SmoothPlastic -- Ağır dokuları düz plastiğe çevirir
            v.CastShadow = False -- Gölgeleri kapatır (FPS'i uçurur)
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
            v.Enabled = false -- Havada uçuşan duman, ateş, parıltı gibi efektleri kapatır
        elseif v:IsA("Explosion") then
            v.Visible = false
        end
    end

    -- 4. Kullanıcı Arayüzü (UI) ve Render Optimizasyonu
    local RunService = game:GetService("RunService")
    
    -- Doku kalitesini düşür (Mümkünse)
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    
    -- FPS Sabitlemesini Kaldır (Varsa)
    setfpscap(999) -- Executor destekliyorsa sınırsız FPS yapar

    print("[xAworth Optimizer] Sistem başarıyla optimize edildi!")
end)

if not success then
    warn("[xAworth Optimizer] Optimizasyon sırasında bir hata oluştu: " .. tostring(err))
end
