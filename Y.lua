local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UIS = game:GetService("UserInputService")

-- 🖼️ สร้าง ScreenGui
local gui = Instance.new("ScreenGui", playerGui)
gui.Name = "ModernHub"
gui.ResetOnSpawn = false
gui.Enabled = false

-- 🔘 ปุ่มเปิด/ปิด UI
local toggleBtn = Instance.new("TextButton", playerGui:WaitForChild("PlayerGui"))
toggleBtn.Size = UDim2.new(0, 120, 0, 40)
toggleBtn.Position = UDim2.new(0, 10, 0, 10)
toggleBtn.Text = "Open Menu"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 16
Instance.new("UICorner", toggleBtn)

toggleBtn.MouseButton1Click:Connect(function()
	gui.Enabled = not gui.Enabled
	toggleBtn.Text = gui.Enabled and "Close Menu" or "Open Menu"
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.M then
		gui.Enabled = not gui.Enabled
		toggleBtn.Text = gui.Enabled and "Close Menu" or "Open Menu"
	end
end)

-- 🟫 โลโก้ + Sidebar
local sidebar = Instance.new("Frame", gui)
sidebar.Size = UDim2.new(0, 180, 1, 0)
sidebar.Position = UDim2.new(0, 0, 0, 0)
sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Instance.new("UICorner", sidebar)

-- 🧿 โลโก้
local logo = Instance.new("ImageLabel", sidebar)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0.5, -30, 0, 10)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://15373539666" -- ใส่โลโก้ของคุณเองที่นี่

-- 🧾 ปุ่ม Sidebar
local tabNames = {"Main", "Events", "Pet", "Craft", "Trade", "Shop"}
local tabButtons = {}
local contentFrames = {}

for i, name in ipairs(tabNames) do
	local btn = Instance.new("TextButton", sidebar)
	btn.Size = UDim2.new(1, -20, 0, 35)
	btn.Position = UDim2.new(0, 10, 0, 80 + (i-1)*45)
	btn.Text = name
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 16
	Instance.new("UICorner", btn)
	tabButtons[name] = btn
end

-- 📄 Main Content
local mainContent = Instance.new("Frame", gui)
mainContent.Size = UDim2.new(0, 500, 0, 400)
mainContent.Position = UDim2.new(0, 200, 0.5, -200)
mainContent.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
mainContent.Visible = true
Instance.new("UICorner", mainContent)

contentFrames["Main"] = mainContent

-- 🏷️ หัวข้อ
local title = Instance.new("TextLabel", mainContent)
title.Size = UDim2.new(1, 0, 0, 50)
title.Text = "Main"
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

-- 🔽 Select Mutation Dropdown
local mutationDrop = Instance.new("TextButton", mainContent)
mutationDrop.Size = UDim2.new(0, 200, 0, 35)
mutationDrop.Position = UDim2.new(0, 20, 0, 60)
mutationDrop.Text = "Select Mutation: Tranquil"
mutationDrop.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
mutationDrop.TextColor3 = Color3.new(1, 1, 1)
mutationDrop.Font = Enum.Font.Gotham
mutationDrop.TextSize = 16
Instance.new("UICorner", mutationDrop)

-- 🔽 Select Plant Dropdown
local plantDrop = mutationDrop:Clone()
plantDrop.Position = UDim2.new(0, 20, 0, 110)
plantDrop.Text = "Select Plant: All"
plantDrop.Parent = mainContent

-- 🔘 Auto Collect Toggle
local autoCollect = Instance.new("TextButton", mainContent)
autoCollect.Size = UDim2.new(0, 200, 0, 35)
autoCollect.Position = UDim2.new(0, 20, 0, 160)
autoCollect.Text = "Auto Collect Plant: OFF"
autoCollect.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoCollect.TextColor3 = Color3.new(1, 1, 1)
autoCollect.Font = Enum.Font.Gotham
autoCollect.TextSize = 16
Instance.new("UICorner", autoCollect)

local autoState = false
autoCollect.MouseButton1Click:Connect(function()
	autoState = not autoState
	autoCollect.Text = "Auto Collect Plant: " .. (autoState and "ON" or "OFF")
end)

-- 🧮 Collect Delay Slider
local sliderFrame = Instance.new("Frame", mainContent)
sliderFrame.Size = UDim2.new(0, 200, 0, 35)
sliderFrame.Position = UDim2.new(0, 20, 0, 210)
sliderFrame.BackgroundTransparency = 1

local sliderLabel = Instance.new("TextLabel", sliderFrame)
sliderLabel.Size = UDim2.new(1, 0, 1, 0)
sliderLabel.Text = "Collect Delay: 0"
sliderLabel.TextColor3 = Color3.new(1, 1, 1)
sliderLabel.Font = Enum.Font.Gotham
sliderLabel.TextSize = 16
sliderLabel.BackgroundTransparency = 1

local collectDelay = 0

-- 🟦 Slider Bar
local slider = Instance.new("TextButton", mainContent)
slider.Size = UDim2.new(0, 200, 0, 10)
slider.Position = UDim2.new(0, 20, 0, 250)
slider.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
slider.Text = ""
Instance.new("UICorner", slider)

local knob = Instance.new("Frame", slider)
knob.Size = UDim2.new(0, 10, 1.5, 0)
knob.Position = UDim2.new(0, 0, -0.25, 0)
knob.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
Instance.new("UICorner", knob)

local dragging = false
knob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local relX = math.clamp((input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X, 0, 1)
		knob.Position = UDim2.new(relX, -5, -0.25, 0)
		collectDelay = math.floor(relX * 10)
		sliderLabel.Text = "Collect Delay: " .. collectDelay
	end
end)

sliderLabel.Parent = sliderFrame

-- ✅ Auto Plant Toggle
local autoPlant = autoCollect:Clone()
autoPlant.Position = UDim2.new(0, 20, 0, 280)
autoPlant.Text = "Auto Plant: OFF"
autoPlant.Parent = mainContent

local plantState = false
autoPlant.MouseButton1Click:Connect(function()
	plantState = not plantState
	autoPlant.Text = "Auto Plant: " .. (plantState and "ON" or "OFF")
end)

-- 🌱 Plant Limit Slider
local plantSlider = slider:Clone()
plantSlider.Position = UDim2.new(0, 20, 0, 330)
plantSlider.Parent = mainContent

local plantKnob = plantSlider:FindFirstChildOfClass("Frame")
local plantValue = 800

local plantLabel = sliderLabel:Clone()
plantLabel.Text = "Plant Limit: 800"
plantLabel.Parent = mainContent
plantLabel.Position = UDim2.new(0, 20, 0, 300)

local draggingPlant = false
plantKnob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingPlant = true
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingPlant = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if draggingPlant and input.UserInputType == Enum.UserInputType.MouseMovement then
		local relX = math.clamp((input.Position.X - plantSlider.AbsolutePosition.X) / plantSlider.AbsoluteSize.X, 0, 1)
		plantKnob.Position = UDim2.new(relX, -5, -0.25, 0)
		plantValue = math.floor(relX * 1000)
		plantLabel.Text = "Plant Limit: " .. plantValue
	end
end)

-- 🔄 เปลี่ยนเนื้อหาตามปุ่ม
for name, btn in pairs(tabButtons) do
	btn.MouseButton1Click:Connect(function()
		for _, frame in pairs(contentFrames) do
			frame.Visible = false
		end
		if contentFrames[name] then
			contentFrames[name].Visible = true
		end
	end)
end
