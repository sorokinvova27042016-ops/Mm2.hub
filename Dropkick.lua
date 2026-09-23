-- ============================================================
-- FSOCEITY NATURAL DISASTER — ANTICHEAT BYPASS
-- Dropkick + Fly + Speed + ESP + Anti-Kick
-- ============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local char = player.Character or player.CharacterAdded:Wait()
local root = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- ============================================================
-- ОБХОД АНТИЧИТА (DROPKICK)
-- ============================================================
local function bypassAntiCheat()
    -- 1. Уничтожаем античит-ремоуты
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            local n = v.Name:lower()
            if n:find("anticheat") or n:find("cheat") or n:find("detect") or 
               n:find("exploit") or n:find("ban") or n:find("kick") or
               n:find("admin") or n:find("mod") or n:find("dropkick") then
                v:Destroy()
                print("[FSOCEITY] Убит античит-ремоут: " .. v.Name)
            end
        end
    end

    -- 2. Блокируем кик
    local oldKick = hookfunction(player.Kick, function(self, reason)
        if reason and (reason:lower():find("cheat") or reason:lower():find("exploit") or reason:lower():find("ban")) then
            print("[FSOCEITY] Блокирован кик: " .. reason)
            return nil
        end
        return oldKick(self, reason)
    end)

    -- 3. Маскируем инжектор
    setfflag("FFlagDebugAllowVR", "true")
    setfflag("FFlagDebugDisableTeleportUtils", "true")
    getgenv().Executor = nil

    -- 4. Отключаем проверки скорости
    RunService.Stepped:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)

    -- 5. Отключаем скрипты слежения
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Script") or v:IsA("LocalScript") then
            local n = v.Name:lower()
            if n:find("anticheat") or n:find("detect") or n:find("dropkick") then
                v.Disabled = true
            end
        end
    end

    print("[FSOCEITY] ✅ Античит Dropkick обойдён")
end

bypassAntiCheat()

-- ============================================================
-- НАСТРОЙКИ
-- ============================================================
local settings = {
    dropkick = false,
    fly = false,
    speed = false,
    esp = false,
    invisibility = false,
    spin = false,
    antiKick = true
}

local flySpeed = 100
local spinSpeed = 15
local normalSpeed = 16

-- ============================================================
-- DROPKICK (УДАР В ПРЫЖКЕ)
-- ============================================================
local function runDropkick()
    if not settings.dropkick then return end
    
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (root.Position - p.Character.HumanoidRootPart.Position).Magnitude
            if dist < 10 then
                -- Кик по игроку
                local kick = ReplicatedStorage:FindFirstChild("Dropkick") or 
                             ReplicatedStorage:FindFirstChild("Kick")
                if kick then
                    kick:FireServer(p)
                else
                    -- Альтернатива — просто убить
                    if p.Character:FindFirstChild("Humanoid") then
                        p.Character.Humanoid.Health = 0
                    end
                end
            end
        end
    end
end

-- ============================================================
-- FLY
-- ============================================================
local bodyVel = Instance.new("BodyVelocity")
bodyVel.MaxForce = Vector3.new(1e9, 1e9, 1e9)

local function runFly()
    if settings.fly then
        bodyVel.Parent = root
        bodyVel.Velocity = Vector3.new(0, flySpeed, 0)
    else
        bodyVel.Parent = nil
    end
end

-- ============================================================
-- SPEED
-- ============================================================
local function runSpeed()
    if settings.speed then
        humanoid.WalkSpeed = 100
    else
        humanoid.WalkSpeed = normalSpeed
    end
end

-- ============================================================
-- ESP (WALLHACK)
-- ============================================================
local function runESP()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hl = p.Character:FindFirstChild("FSOCEITY_HL")
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "FSOCEITY_HL"
                hl.Parent = p.Character
            end
            
            if settings.esp then
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 0, 0)
                hl.FillTransparency = 0.3
                hl.OutlineTransparency = 0
            else
                if hl then hl:Destroy() end
            end
        end
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
-- СПИН
-- ============================================================
local function runSpin()
    if settings.spin then
        root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
    end
end

-- ============================================================
-- ГЛАВНЫЙ ЦИКЛ
-- ============================================================
RunService.RenderStepped:Connect(function()
    runDropkick()
    runFly()
    runSpeed()
    runESP()
    runInvisibility()
    runSpin()
end)

-- ============================================================
-- GUI МЕНЮ
-- ============================================================
local sg = Instance.new("ScreenGui")
sg.Name = "FSOCEITY_ND"
sg.ResetOnSpawn = false
sg.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 480)
frame.Position = UDim2.new(0.5, -160, 0.5, -240)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 25)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 3
frame.BorderColor3 = Color3.fromRGB(0, 200, 255)
frame.Active = true
frame.Draggable = true
frame.Parent = sg
frame.Visible = false

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(0, 50, 80)
title.Text = "🌪 NATURAL DISASTER"
title.TextColor3 = Color3.fromRGB(0, 200, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local sub = Instance.new("TextLabel")
sub.Size = UDim2.new(1, 0, 0, 25)
sub.Position = UDim2.new(0, 0, 0, 50)
sub.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
sub.Text = "FSOCEITY Cheat | G — меню"
sub.TextColor3 = Color3.fromRGB(0, 200, 255)
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

makeToggle("🦵 Dropkick", 0.17, "dropkick", Color3.fromRGB(0, 150, 0))
makeToggle("🕊 Fly", 0.26, "fly", Color3.fromRGB(0, 150, 0))
makeToggle("⚡ Speed", 0.35, "speed", Color3.fromRGB(0, 150, 0))
makeToggle("👁 ESP", 0.44, "esp", Color3.fromRGB(0, 150, 0))
makeToggle("👻 Невидимость", 0.53, "invisibility", Color3.fromRGB(150, 0, 150))
makeToggle("🌀 Спин", 0.62, "spin", Color3.fromRGB(0, 150, 0))

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.9, 0, 0, 35)
closeBtn.Position = UDim2.new(0.05, 0, 0.71, 0)
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
status.Position = UDim2.new(0, 0, 0.83, 0)
status.BackgroundColor3 = Color3.fromRGB(0, 0, 0, 0)
status.Text = "✅ Античит обойдён | G — меню | F1 — STOP"
status.TextColor3 = Color3.fromRGB(0, 200, 255)
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
    end
end)

-- ============================================================
-- F1 — ОСТАНОВКА
-- ============================================================
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.F1 then
        settings.dropkick = false
        settings.fly = false
        settings.speed = false
        settings.esp = false
        settings.invisibility = false
        settings.spin = false
        bodyVel.Parent = nil
        sg:Destroy()
        print("[FSOCEITY] 🛑 СКРИПТ ОСТАНОВЛЕН")
    end
end)

print("[FSOCEITY] ✅ Natural Disaster Cheat загружен!")
print("[FSOCEITY] Нажми G — меню | F1 — остановка")
