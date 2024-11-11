local bpAPI = {
    animationAPI = {},
    logicAPI = {}
}

-- Vars
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Cleanup
getgenv().BPAPI_CONNECTIONS = getgenv().BPAPI_CONNECTIONS or {}
for _,connection in getgenv().BPAPI_CONNECTIONS do
    connection:Disconnect()
end
getgenv().BPAPI_CONNECTIONS = {}
local function addConnection(conn)
    table.insert(getgenv().BPAPI_CONNECTIONS, conn)
end

-- AnimationAPI
local AnimationAPI = {
    animations = {},
    stabcount = 1
}
local function add(p1, p2)
    AnimationAPI.animations[p1] = LocalPlayer.Character.Humanoid:LoadAnimation(p2)
end

local function KnifeUp()
    pcall(function() 
        LocalPlayer.Character.Blade.GripForward = Vector3.new(0, 0, -1)
        LocalPlayer.Character.Blade.GripRight = Vector3.new(1, 0, 0)
        LocalPlayer.Character.Blade.GripUp = Vector3.new(0, 1, 0)
    end)
end
local function KnifeDown()
    pcall(function()
        LocalPlayer.Character.Blade.GripForward = Vector3.new(0, 0, -1)
        LocalPlayer.Character.Blade.GripRight = Vector3.new(1, 0, 0)
        LocalPlayer.Character.Blade.GripUp = Vector3.new(0, -1, 0)
    end)
end
function bpAPI.animationAPI.play(name, looped, speed)
    local animation = AnimationAPI.animations[name]
    if not animation then return end
    animation:Play()
    animation.Looped = looped
    animation.Priority = Enum.AnimationPriority.Action
    if name == "stab3" then
        KnifeDown()
        delay(0.5, function()
            KnifeUp()
        end)
    end
    if speed then
        animation:AdjustSpeed(speed)
    end
end
function bpAPI.animationAPI.stop(name)
    if not name then
        for _, anim in AnimationAPI.animations do
            anim:Stop()
        end
        return
    end
    local animation = AnimationAPI.animations[name]
    if not animation then return end
    AnimationAPI.animations[name]:Stop()
end

function bpAPI.animationAPI.throw()
    bpAPI.animationAPI.play("raise", false, 0.5)
    task.wait(0.5)
    bpAPI.animationAPI.stop("raise")
end

function bpAPI.animationAPI.stab()
    local name = "stab" .. tostring(AnimationAPI.stabcount)
    AnimationAPI.stabcount += 1
    if AnimationAPI.stabcount > 3 then
        AnimationAPI.stabcount = 1
    end
    pcall(function()
        LocalPlayer.Character.Blade.Swoosh1:Play()
    end)
    bpAPI.animationAPI.play(name, false, math.random() * 0.5 + 1);
    task.wait(0.5)
    bpAPI.animationAPI.stop(name);
end
-- AnimationAPI connections
local function setup(tool)
    if tool:IsA("Tool") and tool.Name == "Blade" then
        AnimationAPI.animations = {}
        add("raise", tool:WaitForChild("raise"))
        add("stab1", tool:WaitForChild("stab1"))
        add("stab2", tool:WaitForChild("stab2"))
        add("stab3", tool:WaitForChild("stab3"))
    end
end

addConnection(LocalPlayer.CharacterAdded:Connect(function(char)
    char.ChildAdded:Connect(setup)
end))

pcall(function()
    setup(LocalPlayer.Character.Blade)
end)

-- LogicAPI
function bpAPI.logicAPI.getDuo()
    if game.PlaceId ~= 1410026010 then return false end
    local plr = LocalPlayer:FindFirstChild("duo") and Players:FindFirstChild(LocalPlayer.duo.Value)
    if not plr then
        for _,v in Players:GetPlayers() do
            if v ~= LocalPlayer and v.TeamColor == LocalPlayer.TeamColor then
                plr = v
                break
            end
        end
    end
    return plr
end

function bpAPI.logicAPI.hasKnife(plr)
    plr = plr or LocalPlayer
    return (plr.Character and plr.Character:FindFirstChild("Blade")) or plr.Backpack:FindFirstChild("Blade")
end

function bpAPI.logicAPI.isSit(plr)
    plr = plr or LocalPlayer
    return not plr.Character or not plr.Character:FindFirstChild("Humanoid") or plr.Character.Humanoid.Sit
end

function bpAPI.logicAPI.isInGlass(p1)
    if typeof(p1) == "Instance" then
        if p1.Position.X <= -9.174 and p1.Position.X >= -51.426 and p1.Position.Z >= -245.9085 and p1.Position.Z <= -175.6995 then
            return true
        end
        return false
    elseif typeof(p1) == "Vector3" then
        if p1.X <= -9.174 and p1.X >= -51.426 and p1.Z >= -245.9085 and p1.Z <= -175.6995 then
            return true
        end
        return false
    end
end

function bpAPI.logicAPI.hasWon()
    for _,v in Players:GetPlayers() do
        if v.Name ~= LocalPlayer.Name and v.Character and v.Character.PrimaryPart and bpAPI.logicAPI.isInGlass(v.Character.PrimaryPart) and v ~= bpAPI.logicAPI.getDuo() then
            return false
        end
    end
    return true
end

function bpAPI.logicAPI.throw(cframe)
    LocalPlayer.PlayerScripts.Event:Fire("t", cframe)
end

function bpAPI.logicAPI.slash()
    LocalPlayer.PlayerScripts.Event:Fire("s")
end

local isThrowing = false
function bpAPI.logicAPI.isThrowing()
    return isThrowing
end

function bpAPI.logicAPI.allow(char)
    return char.Character and char.Character.PrimaryPart and char.Character:FindFirstChild("Humanoid") and char.Character.Humanoid.Health > 0 and (bpAPI.logicAPI.getDuo() and bpAPI.logicAPI.getDuo().Name) ~= char.Name
end

-- logicAPI connections
addConnection(LocalPlayer.PlayerScripts.Event.Event:Connect(function(name, value)
    if name == "c" then
        isThrowing = value
    end
end))

return bpAPI
