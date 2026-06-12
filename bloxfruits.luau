local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()
local plr = game:GetService("Players").LocalPlayer
local replicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local Players = game:GetService("Players")

local netFolder = replicatedStorage:FindFirstChild("Modules")
if netFolder then netFolder = netFolder:FindFirstChild("Net") end
local registerHit = netFolder and netFolder:FindFirstChild("RE/RegisterHit")
local registerAttack = netFolder and netFolder:FindFirstChild("RE/RegisterAttack")
if not registerHit or not registerAttack then
    warn("RE remotes not found")
end

local autoAttackEnabled = false
local attackDelay = 0.1
local targetFilter = "NPCs Only"

local Window = Library:MakeWindow({
    Title = "Moon",
    SubTitle = "by tlmoondevs",
    ScriptFolder = "MoonHub"
})

local MiscTab = Window:MakeTab({Title = "Auto Attack", Icon = "swords"})

MiscTab:AddToggle({
    Name = "Auto Attack",
    Default = false,
    Flag = "autoAttackMain",
    Callback = function(Value)
        autoAttackEnabled = Value
    end
})

MiscTab:AddSlider({
    Name = "Attack Delay",
    Min = 0.05,
    Max = 1.0,
    Increment = 0.05,
    Default = 0.1,
    Flag = "attackDelay",
    Callback = function(Value)
        attackDelay = Value
    end
})

MiscTab:AddDropdown({
    Name = "Target",
    Options = {"NPCs Only", "Players Only", "Both"},
    Default = "NPCs Only",
    Flag = "targetFilter",
    Callback = function(Value)
        targetFilter = Value
    end
})

local function randomHex()
    return string.format("%08x", math.random(0, 0xFFFFFFFF))
end

local function findTarget()
    local char = plr.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local nearest, minDist = nil, 200

    local function scan(folder)
        for _, obj in pairs(folder:GetChildren()) do
            if obj:IsA("Model") and obj ~= char then
                local hum = obj:FindFirstChild("Humanoid")
                local hrp = obj:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local isPlayer = Players:GetPlayerFromCharacter(obj)
                    local valid = false
                    if targetFilter == "NPCs Only" and not isPlayer then
                        valid = true
                    elseif targetFilter == "Players Only" and isPlayer and isPlayer ~= plr then
                        valid = true
                    elseif targetFilter == "Both" and (not isPlayer or (isPlayer and isPlayer ~= plr)) then
                        valid = true
                    end
                    if valid then
                        local dist = (root.Position - hrp.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearest = obj
                        end
                    end
                end
            end
        end
    end

    local enemiesFolder = workspace:FindFirstChild("Enemies")
    if enemiesFolder then scan(enemiesFolder) end
    for _, obj in pairs(workspace:GetChildren()) do
        if obj:IsA("Model") then
            local hum = obj:FindFirstChild("Humanoid")
            local hrp = obj:FindFirstChild("HumanoidRootPart")
            if hum and hrp and hum.Health > 0 then
                local isPlayer = Players:GetPlayerFromCharacter(obj)
                if targetFilter == "Players Only" and isPlayer and isPlayer ~= plr then
                    local dist = (root.Position - hrp.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearest = obj
                    end
                end
            end
        end
    end
    return nearest
end

local function ensureWeaponEquipped()
    local char = plr.Character
    if not char then return false end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and not string.find(child.Name, "-") then
            return true
        end
    end
    local backpack = plr:FindFirstChild("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and not string.find(tool.Name, "-") then
                tool.Parent = char
                return true
            end
        end
    end
    return false
end

local function attackTarget(target)
    local part = target:FindFirstChild("Head") or target:FindFirstChild("HumanoidRootPart")
    if not part then return end

    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local oldCF = root and root.CFrame
    if root then
        root.CFrame = CFrame.lookAt(root.Position, part.Position)
    end

    pcall(function()
        registerHit:FireServer(part, {}, nil, randomHex())
    end)
    for _ = 1, 2 do
        pcall(function()
            registerAttack:FireServer(0.4)
        end)
        task.wait()
    end

    if root and oldCF then
        pcall(function() root.CFrame = oldCF end)
    end
end

task.spawn(function()
    while task.wait(attackDelay) do
        if autoAttackEnabled then
            if ensureWeaponEquipped() then
                local target = findTarget()
                if target then
                    attackTarget(target)
                end
            else
                task.wait(0.5)
            end
        else
            task.wait(0.2)
        end
    end
end)
