-- LocalScript.lua

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ProTools"

local function createButton(text, y)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 120, 0, 40)
	btn.Position = UDim2.new(0, 20, 0, y)
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 18
	btn.Parent = ScreenGui
	return btn
end

local flyBtn = createButton("🛸 บิน", 50)
local noclipBtn = createButton("🚪 ทะลุ", 100)
local invisBtn = createButton("👻 ล่องหน", 150)

-- บิน
local flying = false
local UIS = game:GetService("UserInputService")
local hrp = char:WaitForChild("HumanoidRootPart")
local flySpeed = 50
local direction = Vector3.zero

local function fly()
	flying = not flying
	if flying then
		local bv = Instance.new("BodyVelocity")
		bv.Name = "FlyVelocity"
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.zero
		bv.Parent = hrp

		UIS.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.Keyboard then
				if input.KeyCode == Enum.KeyCode.W then direction = Vector3.new(0, 0, -1)
				elseif input.KeyCode == Enum.KeyCode.S then direction = Vector3.new(0, 0, 1)
				elseif input.KeyCode == Enum.KeyCode.A then direction = Vector3.new(-1, 0, 0)
				elseif input.KeyCode == Enum.KeyCode.D then direction = Vector3.new(1, 0, 0)
				elseif input.KeyCode == Enum.KeyCode.Space then direction = Vector3.new(0, 1, 0)
				elseif input.KeyCode == Enum.KeyCode.LeftControl then direction = Vector3.new(0, -1, 0)
				end
			end
		end)

		UIS.InputEnded:Connect(function()
			direction = Vector3.zero
		end)

		while flying and hrp and hrp:FindFirstChild("FlyVelocity") do
			hrp.FlyVelocity.Velocity = (hrp.CFrame:VectorToWorldSpace(direction)) * flySpeed
			task.wait()
		end
	else
		if hrp:FindFirstChild("FlyVelocity") then
			hrp:FindFirstChild("FlyVelocity"):Destroy()
		end
	end
end

-- ทะลุ
local noclip = false
local RunService = game:GetService("RunService")

local function toggleNoclip()
	noclip = not noclip
	if noclip then
		RunService.Stepped:Connect(function()
			if noclip and char then
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end
			end
		end)
	else
		for _, part in pairs(char:GetDescendants()) do
			if part:IsA("BasePart") then
				part.CanCollide = true
			end
		end
	end
end

-- ล่องหน
local invisible = false
local function toggleInvisible()
	invisible = not invisible
	if char then
		for _, obj in pairs(char:GetDescendants()) do
			if obj:IsA("BasePart") or obj:IsA("Decal") then
				obj.Transparency = invisible and 1 or 0
			end
		end
	end
end

-- เชื่อมปุ่ม
flyBtn.MouseButton1Click:Connect(fly)
noclipBtn.MouseButton1Click:Connect(toggleNoclip)
invisBtn.MouseButton1Click:Connect(toggleInvisible)
