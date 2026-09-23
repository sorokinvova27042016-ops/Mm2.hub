-- ============================================================
-- FSOCEITY PULSE CLONE — MM2 (МЕНЮ ПО G)
-- Wallhack + Aimbot + Bhop + Шейдеры + Kill All + Античит
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- ============================================================
-- ОБХОД АНТИЧИТА
-- ============================================================
local function bypassAntiCheat()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("anticheat") or n:find("cheat") or n:find("detect") or 
               n:find("exploit") or n:find("ban") or n:find("kick") or
               n:find("admin") or n:find("mod") then
                v:Destroy()
            end
        end
    end

    local oldKick = hookfunction(player.Kick, function(self, reason)
        if reason and (reason:lower():find("cheat") or reason:lower():find("exploit") or reason:lower():find("ban")) then
            return nil
        end
        return oldKick(self, reason)
    end)

    setfflag("FFlagDebugAllowVR", "true")
    setfflag("FFlagDebugDisableTeleportUtils", "true")
    getgenv().Executor = nil

    RunService.Stepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)

    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            local n = v.Name:lower()
            if n:find("teleport") or n:find("position") or n:find("velocity") then
                v.Disabled = true
            end
        end
    end

    print("[FSOCEITY] ✅ Античит обнулён")
end

bypassAntiCheat()

-- ============================================================
-- НАСТРОЙКИ
-- ============================================================
local settings = {
    aimbot = false,
    wallhack = false,
    bhop = false,
    shaders = false,
    invisibility = false,
    spin = false,
    autoKill = false
}

local spinSpeed = 15

-- ============================================================
-- ПОИСК МАРДЕРА
-- ============================================================
local function getMurderer()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local role = p:GetAttribute("Role") or p:FindFirstChild("Role")
            if role == "Murderer" or (role and role.Value == "Murderer") then
                return p
            end
            if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then
                return p
            end
        end
    end
    return nil
end

-- ============================================================
-- WALLHACK (ESP)
-- ============================================================
local function runWallhack()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hl = p.Character:FindFirstChild("FSOCEITY_HL")
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "FSOCEITY_HL"
                hl.Parent = p.Character
            end
            
            if settings.wallhack then
                local role = p:GetAttribute("Role") or "Innocent"
                if role == "Murderer" then
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                    hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                elseif role == "Sheriff" then
                    hl.FillColor = Color3.fromRGB(0, 100, 255)
                    hl.OutlineColor = Color3.fromRGB(0, 100, 255)
                else
                    hl.FillColor = Color3.fromRGB(0, 255, 0)
                    hl.OutlineColor = Color3.fromRGB(0, 255, 0)
                end
                hl.FillTransparency = 0.3
                hl.OutlineTransparency = 0
            else
                if hl then hl:Destroy() end
            end
        end
    end
end

-- ============================================================
-- АИМБОТ
-- ============================================================
local function runAimbot()
    if not settings.aimbot then return end
    
    local target = getMurderer()
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local targetPos = target.Character.HumanoidRootPart.Position + Vector3.new(0, 2.5, 0)
        camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
    end
end

-- ============================================================
-- BHOP
-- ============================================================
local function runBhop()
    if settings.bhop and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.JumpPower = 100
            humanoid.WalkSpeed = 50
        end
    end
end

-- ============================================================
-- ШЕЙДЕРЫ
-- ============================================================
local function runShaders()
    if settings.shaders then
        Lighting.Brightness = 3
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.Ambient = Color3.fromRGB(200, 200, 200)
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") then
                v.Enabled = false
            end
        end
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
    end
end

-- ============================================================
-- СПИН
-- ============================================================
local function runSpin()
    if settings.spin and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local root = player.Character.HumanoidRootPart
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end

-- ============================================================
-- НЕВИДИМОСТЬ
-- ============================================================
local function runInvisibility()
    if settings.invisibility and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
                part.CanCollide = false
            end
        end
        local ff = player.Character:FindFirstChildOfClass("ForceField")
        if not ff then
            ff = Instance.new("ForceField")
            ff.Parent = player.Character
        end
    end
end

-- ============================================================
-- УБИТЬ ВСЕХ
-- ============================================================
local function runKillAll()
    if settings.autoKill then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= player and p.Character and p.Character:FindFirstChild("Humanoid") then
                p.Character.Humanoid.Health = 0
            end
        end
        settings.autoKill = false
    end
end

-- ============================================================
-- ГЛАВНЫЙ ЦИКЛ
-- ============================================================
RunService.RenderStepped:Connect(function()
    runWallhack()
    runAimbot()
    runBhop()
    runShaders()
    runSpin()
    runInvisibility()
    runKillAll()
end)

-- ============================================================
-- GUI МЕНЮ
-- ============================================================
local sg = Instance.new("ScreenGui")
sg.Name = "FSOCEITY_MM2"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 480)
frame.Position = UDim2.new(0.5, -160, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(255, 0, 0)
frame.Active = true
frame.Draggable = true
frame.Parent = sg
frame.Visible = false -- Меню СКРЫТО по умолчанию

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(30, 0, 0)
title.Text = "🔥 FSOCEITY PULSE 🔥"
title.TextColor3 = Color3.fromRGB(255, 0, 0)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 25)
sub.Position = UDim2.new(0, 0, 0, 50)
sub.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
sub.Text = "MM2 Cheat v2.0 | G — меню"
sub.TextColor3 = Color3.fromRGB(255, 100, 100)
sub.TextScaled = true
sub.Font = Enum.Font.Gotham
sub.Parent = frame

local function makeToggle(text, y, key, colorOn)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 38)
    btn.Position = UDim2.new(0.05, 0, y, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    btn.Text = text .. ": ВЫКЛ"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.BorderSizePixel = 1
    btn.BorderColor3 = Color3.fromRGB(100, 100, 100)
    btn.Parent = frame
    btn.MouseButton1Click:Connect(function()
        settings[key] = not settings[key]
        btn.Text = text .. ": " .. (settings[key] and "ВКЛ" or "ВЫКЛ")
        btn.BackgroundColor3 = settings[key] and colorOn or Color3.fromRGB(40, 40, 60)
    end)
    return btn
end

makeToggle("🎯 Аимбот", 0.17, "aimbot", Color3.fromRGB(0, 150, 0))
makeToggle("👁 Wallhack (ESP)", 0.26, "wallhack", Color3.fromRGB(0, 150, 0))
makeToggle("🐇 Bhop", 0.35, "bhop", Color3.fromRGB(0, 150, 0))
makeToggle("✨ Шейдеры + FPS", 0.44, "shaders", Color3.fromRGB(0, 150, 0))
makeToggle("🌀 Спин", 0.53, "spin", Color3.fromRGB(0, 150, 0))
makeToggle("👻 Невидимость", 0.62, "invisibility", Color3.fromRGB(150, 0, 150))

local killBtn = Instance.new("TextButton")
killBtn.Size = UDim2.new(0.9, 0, 0, 45)
killBtn.Position = UDim2.new(0.05, 0, 0.71, 0)
killBtn.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
killBtn.Text = "💀 УБИТЬ ВСЕХ"
killBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
killBtn.TextScaled = true
killBtn.Font = Enum.Font.GothamBold
killBtn.BorderSizePixel = 2
killBtn.BorderColor3 = Color3.fromRGB(255, 0, 0)
killBtn.Parent = frame
killBtn.MouseButton1Click:Connect(function()
    settings.autoKill = true
end)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.9, 0, 0, 35)
closeBtn.Position = UDim2.new(0.05, 0, 0.83, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0)
closeBtn.Text = "❌ Закрыть меню (G)"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = frame
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 1, -25)
status.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
status.Text = "✅ Античит обойдён | G — меню | F1 — STOP"
status.TextColor3 = Color3.fromRGB(100, 255, 100)
status.TextScaled = true
status.Font = Enum.Font.Gotham
status.Parent = frame

-- ============================================================
-- G — ОТКРЫТИЕ/ЗАКРЫТИЕ МЕНЮ
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.G then
        frame.Visible = not frame.Visible
        print("[FSOCEITY] Меню " .. (frame.Visible and "открыто" or "закрыто"))
    end
end)

-- ============================================================
-- F1 — ОСТАНОВКА
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        settings.aimbot = false
        settings.wallhack = false
        settings.bhop = false
        settings.shaders = false
        settings.spin = false
        settings.invisibility = false
        sg:Destroy()
        print("[FSOCEITY] 🛑 СКРИПТ ОСТАНОВЛЕН")
    end
end)

print("[FSOCEITY] ✅ Pulse Clone загружен!")
print("[FSOCEITY] Нажми G — меню | F1 — остановка")
