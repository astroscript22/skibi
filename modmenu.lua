local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ThaBronx3ModMenu"

-- Main Frame
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 450, 0, 400)
frame.Position = UDim2.new(0.3, 0, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "SleepyHub.ez | v1.6 BETA | Premium User"
title.TextColor3 = Color3.fromRGB(140, 255, 140)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 14

-- Sidebar for Tabs
local sidebar = Instance.new("Frame", frame)
sidebar.Size = UDim2.new(0, 80, 1, -30)
sidebar.Position = UDim2.new(0, 0, 0, 30)
sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)

local tabs = {"Main", "AutoFarm", "Combat", "Visuals", "Settings"}

for i, name in ipairs(tabs) do
	local tabBtn = Instance.new("TextButton", sidebar)
	tabBtn.Size = UDim2.new(1, 0, 0, 25)
	tabBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
	tabBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	tabBtn.TextColor3 = Color3.fromRGB(200, 200, 255)
	tabBtn.Text = name
	tabBtn.Font = Enum.Font.SourceSans
	tabBtn.TextSize = 14
end

-- Main Content Panel
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -80, 1, -30)
content.Position = UDim2.new(0, 80, 0, 30)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

-- Simulated sections like "Target", "Destroy Vehicle", etc.
local function createSection(titleText, yOffset)
	local section = Instance.new("TextLabel", content)
	section.Size = UDim2.new(1, -10, 0, 20)
	section.Position = UDim2.new(0, 5, 0, yOffset)
	section.Text = titleText
	section.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	section.TextColor3 = Color3.fromRGB(170, 100, 255)
	section.Font = Enum.Font.SourceSansBold
	section.TextSize = 14
	return section
end

local function createButton(name, yOffset)
	local btn = Instance.new("TextButton", content)
	btn.Size = UDim2.new(1, -20, 0, 25)
	btn.Position = UDim2.new(0, 10, 0, yOffset)
	btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = name
	btn.Font = Enum.Font.SourceSans
	btn.TextSize = 13
	return btn
end

-- Sample layout
local y = 10
createSection("Target", y)
y = y + 25
createButton("Kill [Fist]", y)
y = y + 30
createButton("Goto", y)
y = y + 30
createButton("Kill All", y)
y = y + 40
createSection("Destroy Vehicle", y)
y = y + 25
createButton("Damage All Vehicles", y)

-- Add more buttons/sections as needed
local flying = false
local speed = 50
local uis = game:GetService("UserInputService")
local runService = game:GetService("RunService")

local velocity = Vector3.new()
local direction = {
	W = false,
	A = false,
	S = false,
	D = false
}

-- Control Input
uis.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local key = input.KeyCode.Name
	if direction[key] ~= nil then
		direction[key] = true
	end
end)

uis.InputEnded:Connect(function(input)
	local key = input.KeyCode.Name
	if direction[key] ~= nil then
		direction[key] = false
	end
end)

-- Fly Logic
local function startFlying()
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not hrp then return end

	local bodyGyro = Instance.new("BodyGyro", hrp)
	bodyGyro.P = 9e4
	bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bodyGyro.CFrame = hrp.CFrame

	local bodyVelocity = Instance.new("BodyVelocity", hrp)
	bodyVelocity.Velocity = Vector3.new(0,0,0)
	bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

	runService:BindToRenderStep("Flying", Enum.RenderPriority.Character.Value + 1, function()
		local camCF = workspace.CurrentCamera.CFrame
		velocity = Vector3.zero
		if direction.W then velocity += camCF.LookVector end
		if direction.S then velocity -= camCF.LookVector end
		if direction.A then velocity -= camCF.RightVector end
		if direction.D then velocity += camCF.RightVector end

		bodyGyro.CFrame = camCF
		bodyVelocity.Velocity = velocity.Unit * speed
	end)
end

local function stopFlying()
	runService:UnbindFromRenderStep("Flying")
	local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then
		if hrp:FindFirstChildOfClass("BodyGyro") then hrp:FindFirstChildOfClass("BodyGyro"):Destroy() end
		if hrp:FindFirstChildOfClass("BodyVelocity") then hrp:FindFirstChildOfClass("BodyVelocity"):Destroy() end
	end
end

-- Toggle on button click
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		startFlying()
		flyBtn.Text = "Fly: ON"
	else
		stopFlying()
		flyBtn.Text = "Fly: OFF"
	end
end)
