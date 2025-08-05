local player = game.Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

player.CharacterAdded:Connect(function(char)
	character = char
	humanoid = character:WaitForChild("Humanoid")
end)

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "ProHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 500, 0, 400)
main.Position = UDim2.new(0.5, -250, 0.5, -200)
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

-- 🎯 UI ลากได้
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
main.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- 🎨 Sidebar
local sidebar = Instance.new("Frame", main)
sidebar.Size = UDim2.new(0, 120, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", sidebar)

-- 🎨 MainContent
local mainContent = Instance.new("Frame", main)
mainContent.Size = UDim2.new(1, -120, 1, 0)
mainContent.Position = UDim2.new(0, 120, 0, 0)
mainContent.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Instance.new("UICorner", mainContent)

-- 📦 ฟังก์ชันสร้างปุ่มหมวด
local function createCategoryButton(name, callback)
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Position = UDim2.new(0, 0, 0, #sidebar:GetChildren() * 45)
	btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Text = name
	Instance.new("UICorner", btn)
	btn.MouseButton1Click:Connect(callback)
end

-- 🏠 หมวด Main (รวมฟีเจอร์เดิม)
createCategoryButton("Main", function()
	for _, v in ipairs(mainContent:GetChildren()) do v:Destroy() end
	local label = Instance.new("TextLabel", mainContent)
	label.Size = UDim2.new(1, -20, 0, 40)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = "ฟีเจอร์หลัก"
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true

	local yPos = 60

	local function createFeatureButton(text, callback)
		local btn = Instance.new("TextButton", mainContent)
		btn.Size = UDim2.new(0, 200, 0, 40)
		btn.Position = UDim2.new(0, 10, 0, yPos)
		btn.Text = text
		btn.BackgroundColor3 = Color3.fromRGB(0,170,255)
		Instance.new("UICorner", btn)
		btn.MouseButton1Click:Connect(callback)
		yPos = yPos + 50
	end

	-- 🛸 บิน
	local flying, flySpeed, bodyGyro, bodyVel = false, 3
	createFeatureButton("บิน", function()
		flying = not flying
		local hrp = character:WaitForChild("HumanoidRootPart")
		local humanoid = character:WaitForChild("Humanoid")
		if flying then
			humanoid.PlatformStand = true
			bodyGyro = Instance.new("BodyGyro", hrp)
			bodyGyro.P, bodyGyro.MaxTorque = 9e4, Vector3.new(9e9, 9e9, 9e9)
			bodyVel = Instance.new("BodyVelocity", hrp)
			bodyVel.MaxForce = Vector3.new(9e9,9e9,9e9)
			RS:BindToRenderStep("Fly", Enum.RenderPriority.Input.Value, function()
				local camCF, moveDir = workspace.CurrentCamera.CFrame, Vector3.zero
				if UIS:IsKeyDown(Enum.KeyCode.W) then moveDir += camCF.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.S) then moveDir -= camCF.LookVector end
				if UIS:IsKeyDown(Enum.KeyCode.A) then moveDir -= camCF.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.D) then moveDir += camCF.RightVector end
				if UIS:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
				if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir -= Vector3.new(0,1,0) end
				bodyVel.Velocity = moveDir.Magnitude>0 and moveDir.Unit*flySpeed or Vector3.zero
				bodyGyro.CFrame = camCF
			end)
		else
			humanoid.PlatformStand = false
			RS:UnbindFromRenderStep("Fly")
			if bodyGyro then bodyGyro:Destroy() end
			if bodyVel then bodyVel:Destroy() end
		end
	end)

	-- 🧱 ทะลุ
	local noclip, noclipConn = false
	createFeatureButton("ทะลุ", function()
		noclip = not noclip
		if noclip then
			noclipConn = RS.Stepped:Connect(function()
				for _, part in pairs(character:GetDescendants()) do
					if part:IsA("BasePart") then part.CanCollide = false end
				end
			end)
		else
			if noclipConn then noclipConn:Disconnect() end
		end
	end)

	-- 🕵️ ล่องหน
	local invisible = false
	createFeatureButton("ล่องหน", function()
		invisible = not invisible
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
	createFeatureButton("สปีด x3", function()
		speedOn = not speedOn
		humanoid.WalkSpeed = speedOn and 48 or 16
	end)
end)

-- 👁️ หมวด ESP
createCategoryButton("ESP", function()
	for _, v in ipairs(mainContent:GetChildren()) do v:Destroy() end
	local label = Instance.new("TextLabel", mainContent)
	label.Size = UDim2.new(1, -20, 0, 40)
	label.Position = UDim2.new(0, 10, 0, 10)
	label.BackgroundTransparency = 1
	label.Text = "ฟีเจอร์ ESP"
	label.TextColor3 = Color3.new(1,1,1)
	label.TextScaled = true

	local espButton = Instance.new("TextButton", mainContent)
	espButton.Size = UDim2.new(0, 200, 0, 40)
	espButton.Position = UDim2.new(0, 10, 0, 60)
	espButton.Text = "เปิด/ปิด ESP ชื่อผู้เล่น"
	espButton.BackgroundColor3 = Color3.fromRGB(0,170,255)
	Instance.new("UICorner", espButton)
	espButton.MouseButton1Click:Connect(function()
		print("สลับสถานะ ESP ชื่อผู้เล่น")
	end)
end)
