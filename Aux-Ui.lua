-- AUX LIBLARY 

local UILib = {}

local function rainbowBorder(frame)
	spawn(function()
		local hue = 0
		while frame and frame.Parent do
			hue = hue + 2
			if hue >= 360 then hue = 0 end
			frame.UIStroke.Color = Color3.fromHSV(hue/360, 1, 1)
			wait(0.02)
		end
	end)
end

local function createNotification(text, duration)
	local notifGui = Instance.new("ScreenGui")
	notifGui.Name = "NotificationGui"
	notifGui.Parent = game.CoreGui
	
	local notif = Instance.new("Frame")
	notif.Size = UDim2.new(0, 250, 0, 45)
	notif.Position = UDim2.new(1, 10, 0, 100)
	notif.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
	notif.BorderSizePixel = 0
	notif.Parent = notifGui
	
	local notifCorner = Instance.new("UICorner")
	notifCorner.CornerRadius = UDim.new(0, 8)
	notifCorner.Parent = notif
	
	local notifStroke = Instance.new("UIStroke")
	notifStroke.Thickness = 2
	notifStroke.Parent = notif
	rainbowBorder(notif)
	
	local notifText = Instance.new("TextLabel")
	notifText.Size = UDim2.new(1, -10, 1, 0)
	notifText.Position = UDim2.new(0, 5, 0, 0)
	notifText.BackgroundTransparency = 1
	notifText.Text = text
	notifText.TextColor3 = Color3.new(1, 1, 1)
	notifText.TextSize = 13
	notifText.Font = Enum.Font.Gotham
	notifText.TextWrapped = true
	notifText.Parent = notif
	
	-- Slide in animation
	notif:TweenPosition(UDim2.new(1, -260, 0, 100), "Out", "Quad", 0.5, true)
	
	-- Auto remove after duration
	wait(duration or 3)
	notif:TweenPosition(UDim2.new(1, 10, 0, 100), "In", "Quad", 0.5, true)
	wait(0.5)
	notifGui:Destroy()
end

local function createToggleButton(gui, mainFrame)
	local toggleBtn = Instance.new("ImageButton")
	toggleBtn.Size = UDim2.new(0, 60, 0, 60)
	toggleBtn.Position = UDim2.new(0, 20, 0, 20)
	toggleBtn.BackgroundColor3 = Color3.new(0.16, 0.16, 0.16)
	toggleBtn.BorderSizePixel = 0
	toggleBtn.Image = "rbxassetid://94472709418266"
	toggleBtn.Active = true
	toggleBtn.Draggable = true
	toggleBtn.Parent = gui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 15)
	corner.Parent = toggleBtn
	
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 3
	stroke.Parent = toggleBtn
	rainbowBorder(toggleBtn)
	
	local isVisible = true
	toggleBtn.MouseButton1Click:Connect(function()
		isVisible = not isVisible
		mainFrame.Visible = isVisible
	end)
end

function UILib:Create(title)
	local gui = Instance.new("ScreenGui")
	gui.Name = "AUX LIBLARY"
	gui.ResetOnSpawn = false
	gui.Parent = game.CoreGui

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 220, 0, 60)
	main.Position = UDim2.new(0, 100, 0, 150)
	main.BackgroundColor3 = Color3.new(0.12, 0.12, 0.12)
	main.BorderSizePixel = 0
	main.Active = true
	main.Draggable = true
	main.Parent = gui

	local mainCorner = Instance.new("UICorner")
	mainCorner.CornerRadius = UDim.new(0, 8)
	mainCorner.Parent = main

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Thickness = 2
	mainStroke.Parent = main
	rainbowBorder(main)

	local headerLabel = Instance.new("TextLabel")
	headerLabel.Size = UDim2.new(1, 0, 0, 30)
	headerLabel.Position = UDim2.new(0, 0, 0, 0)
	headerLabel.BackgroundColor3 = Color3.new(0.08, 0.08, 0.08)
	headerLabel.BorderSizePixel = 0
	headerLabel.Text = title or "AUX LIBLARY MADE BY VantaL0xk"
	headerLabel.TextColor3 = Color3.new(1, 1, 1)
	headerLabel.TextSize = 14
	headerLabel.Font = Enum.Font.GothamBold
	headerLabel.Parent = main

	local headerCorner = Instance.new("UICorner")
	headerCorner.CornerRadius = UDim.new(0, 8)
	headerCorner.Parent = headerLabel

	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Size = UDim2.new(1, -10, 1, -40)
	scrollFrame.Position = UDim2.new(0, 5, 0, 35)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarThickness = 6
	scrollFrame.ScrollBarImageColor3 = Color3.new(0.3, 0.3, 0.3)
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = main

	local layout = Instance.new("UIListLayout")
	layout.Padding = UDim.new(0, 5)
	layout.FillDirection = Enum.FillDirection.Vertical
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	layout.Parent = scrollFrame

	layout.Changed:Connect(function()
		scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
	end)

	createToggleButton(gui, main)

	local currentHeight = 60

	function UILib:Button(text, callback)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 200, 0, 35)
		btn.BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
		btn.BorderSizePixel = 0
		btn.Text = text
		btn.TextColor3 = Color3.new(1, 1, 1)
		btn.TextSize = 14
		btn.Font = Enum.Font.Gotham
		btn.Parent = scrollFrame

		local btnCorner = Instance.new("UICorner")
		btnCorner.CornerRadius = UDim.new(0, 6)
		btnCorner.Parent = btn

		btn.MouseButton1Click:Connect(function()
			if callback then
				callback()
			end
		end)

		currentHeight = currentHeight + 40
		main.Size = UDim2.new(0, 220, 0, math.min(currentHeight, 300))
	end

	function UILib:Toggle(text, callback)
		local toggle = Instance.new("TextButton")
		toggle.Size = UDim2.new(0, 200, 0, 35)
		toggle.BackgroundColor3 = Color3.new(0.18, 0.18, 0.18)
		toggle.BorderSizePixel = 0
		toggle.Text = "[OFF] " .. text
		toggle.TextColor3 = Color3.new(1, 1, 1)
		toggle.TextSize = 14
		toggle.Font = Enum.Font.Gotham
		toggle.Parent = scrollFrame

		local toggleCorner = Instance.new("UICorner")
		toggleCorner.CornerRadius = UDim.new(0, 6)
		toggleCorner.Parent = toggle

		local state = false
		toggle.MouseButton1Click:Connect(function()
			state = not state
			toggle.Text = (state and "[ON] " or "[OFF] ") .. text
			toggle.BackgroundColor3 = state and Color3.new(0.2, 0.4, 0.2) or Color3.new(0.18, 0.18, 0.18)
			if callback then
				callback(state)
			end
		end)

		currentHeight = currentHeight + 40
		main.Size = UDim2.new(0, 220, 0, math.min(currentHeight, 300))
	end

	function UILib:Notify(text, duration)
		spawn(function()
			createNotification(text, duration)
		end)
	end

	return UILib
end

return UILib
