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