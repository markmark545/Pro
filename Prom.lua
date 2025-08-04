-- 🔥 ใส่ใน StarterPlayerScripts
local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- 🎮 ตัวละคร
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- อัปเดตตัวละครตอนเกิดใหม่
player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
end)

-- 🎨 UI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ProHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 300, 0, 300)
main.Position = UDim2.new(0.5, -150, 0.5, -150)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.Visible = false
Instance.new("UICorner", main)

local toggle = Instance.new("TextButton", gui)
toggle.Size = UDim2.new(0, 80, 0, 35)
toggle.Position = UDim2.new(0, 10, 0.5, -20)
toggle.Text = "เปิดโปร"
toggle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", toggle)

toggle.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- 📦 ฟังก์ชันสร้างปุ่ม
local function createButton(text, callback)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, -20, 0, 40)
	btn.Position = UDim2.new(0, 10, 0, #main:GetChildren() * 45)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = text
	Instance.new("UICorner", btn)
	btn.Parent = main
	btn.MouseButton1Click:Connect(callback)
	return btn
end

-- 🛸 บิน
local flying = false
local flySpeed = 3
local bodyGyro, bodyVel

createButton("บิน", function()
	flying = not flying
	character = player.Character or player.CharacterAdded:Wait()

	if flying then
		bodyGyro = Instance.new("BodyGyro", character.HumanoidRootPart)
		bodyGyro.P = 9e4
		bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
		bodyGyro.CFrame = character.HumanoidRootPart.CFrame

		bodyVel = Instance.new("BodyVelocity", character.HumanoidRootPart)
		bodyVel.Velocity = Vector3.new(0, 0, 0)
		bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)

		RS:BindToRenderStep("Fly", Enum.RenderPriority.Input.Value, function()
			local camCF = workspace.CurrentCamera.CFrame
			local moveDir = Vector3.new()

			if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end

			bodyVel.Velocity = moveDir.Unit * flySpeed
			bodyGyro.CFrame = camCF
		end)
	else
		RS:UnbindFromRenderStep("Fly")
		if bodyGyro then bodyGyro:Destroy() end
		if bodyVel then bodyVel:Destroy() end
	end
end)

-- 🧱 ทะลุ
local noclip = false
local noclipConn

createButton("ทะลุ", function()
	noclip = not noclip
	character = player.Character or player.CharacterAdded:Wait()

	if noclip then
		noclipConn = RS.Stepped:Connect(function()
			for _, part in pairs(character:GetDescendants()) do
				if part:IsA("BasePart") then
					part.CanCollide = false
				end
			end
		end)
	else
		if noclipConn then noclipConn:Disconnect() end
	end
end)

-- 🕵️ ล่องหน
local invisible = false

createButton("ล่องหน", function()
	invisible = not invisible
	character = player.Character or player.CharacterAdded:Wait()

	for _, v in pairs(character:GetDescendants()) do
		if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
			v.Transparency = invisible and 1 or 0
		elseif v:IsA("Decal") then
			v.Transparency = invisible and 1 or 0
		end
	end
end)

-- 💨 วิ่งเร็ว
local speedOn = false

createButton("สปีด x3", function()
	speedOn = not speedOn
	humanoid = character:WaitForChild("Humanoid")
	humanoid.WalkSpeed = speedOn and 48 or 16
end)
