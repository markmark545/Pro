-- Y.lua (โหลดผ่าน loadstring)
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local human = char:WaitForChild("Humanoid")

local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
ScreenGui.Name = "ProUI"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 300, 0, 400)
Frame.Position = UDim2.new(0.5, -150, 0.5, -200)
Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Frame.Visible = true
Instance.new("UICorner", Frame)

local UIListLayout = Instance.new("UIListLayout", Frame)
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Title = Instance.new("TextLabel", Frame)
Title.Text = "💻 Pro Hub"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20

-- Utility function
local function createButton(text, callback)
	local button = Instance.new("TextButton", Frame)
	button.Text = text
	button.Size = UDim2.new(1, -20, 0, 40)
	button.Position = UDim2.new(0, 10, 0, 0)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.Font = Enum.Font.Gotham
	button.TextSize = 16
	Instance.new("UICorner", button)
	button.MouseButton1Click:Connect(callback)
	return button
end

-- ⚡ Speed
createButton("⚡ Speed", function()
	human.WalkSpeed = 100
end)

-- 🦘 Jump
createButton("🦘 Jump", function()
	human.JumpPower = 150
end)

-- 🛡️ God Mode
createButton("🛡️ Godmode", function()
	human.MaxHealth = math.huge
	human.Health = math.huge
end)

-- 👻 Invisible
createButton("👻 Invisible", function()
	for _, v in pairs(char:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = 1
		end
	end
end)

-- 🚪 No Clip (ทะลุสิ่งของ)
local noclip = false
createButton("🚪 Noclip", function()
	noclip = not noclip
	game:GetService("RunService").Stepped:Connect(function()
		if noclip then
			for _, v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end
	end)
end)

-- 🕊️ Fly
createButton("🕊️ Fly", function()
	local UIS = game:GetService("UserInputService")
	local flying = true
	local bv = Instance.new("BodyVelocity", char.HumanoidRootPart)
	bv.Velocity = Vector3.new(0,0,0)
	bv.MaxForce = Vector3.new(1e9,1e9,1e9)

	UIS.InputBegan:Connect(function(input)
		if flying then
			if input.KeyCode == Enum.KeyCode.W then
				bv.Velocity = char.HumanoidRootPart.CFrame.LookVector * 100
			elseif input.KeyCode == Enum.KeyCode.S then
				bv.Velocity = -char.HumanoidRootPart.CFrame.LookVector * 100
			elseif input.KeyCode == Enum.KeyCode.Space then
				bv.Velocity = Vector3.new(0, 100, 0)
			elseif input.KeyCode == Enum.KeyCode.LeftControl then
				bv.Velocity = Vector3.new(0, -100, 0)
			end
		end
	end)
end)
