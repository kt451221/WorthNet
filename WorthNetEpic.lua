-- YENİ OYUN İÇİN REMOTE SCANNER
local rs = game:GetService("ReplicatedStorage")
print("--- YENİ OYUN REMOTE LİSTESİ ---")

for _, v in pairs(rs:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        print("Buldum: " .. v:GetFullName())
    end
end

-- Ayrıca oyuncunun kendi içindeki Remote'lara da bakalım (bazen burada olur)
for _, v in pairs(game:GetService("Players").LocalPlayer:GetDescendants()) do
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        print("Player İçinde Buldum: " .. v:GetFullName())
    end
end
