pcall(function()
	if game["Run Service"]:IsStudio() then
		game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("Nigga ui"):Destroy()
	end
end)

local TweenSevrice = game:GetService("TweenService")
local Run = game:GetService("RunService")

local Info = TweenInfo.new(0.1, Enum.EasingStyle.Sine)
local function Tween(Object, Properties, Info2)
	local Tw = TweenSevrice:Create(Object, Info2 or Info, Properties)
	Tw:Play()
	return Tw
end

local lib = {
	Window = function(Size)
		local Size = Size or UDim2.fromOffset(570, 340)
		
		local Niggaui = Instance.new("ScreenGui")
		local MainContainer = Instance.new("Frame")
		local Border = Instance.new("Frame")
		local RealContainer = Instance.new("Frame")
		local TopBar = Instance.new("Frame")
		local Banner = Instance.new("ImageLabel")
		local UICorner = {} -- Instance.new("UICorner")
		local NavBar = Instance.new("Frame")
		local UICorner_2 = {} -- Instance.new("UICorner")
		local TabsImage = Instance.new("ImageLabel")
		local CornerFix = Instance.new("Frame")
		local Tabs = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local UICorner_3 = {} -- Instance.new("UICorner")
		local CornerArch = Instance.new("ImageLabel")
		local UICorner_4 = {} -- Instance.new("UICorner")
		local UIGradient_2 = Instance.new("UIGradient")
		local UICorner_5 = {} -- Instance.new("UICorner")
		local UICorner_6 = {} -- Instance.new("UICorner")

		Niggaui.Name = "Nigga ui"
		Niggaui.Parent = Run:IsStudio() and game.Players.LocalPlayer.PlayerGui or game.CoreGui
		Niggaui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		Niggaui.ResetOnSpawn = false

		MainContainer.Name = "MainContainer"
		MainContainer.Parent = Niggaui
		MainContainer.AnchorPoint = Vector2.new(0.5, 0.5)
		MainContainer.BackgroundColor3 = Color3.fromRGB(44, 45, 44)
		MainContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainContainer.BorderSizePixel = 0
		MainContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
		MainContainer.Size = UDim2.new(0, 570, 0, 340)
		MainContainer.Active = true
		
		local function AddRipple(Button)
			local Clickbox
			if Button:IsA("TextButton") then 
				Clickbox = Button
			else
				Clickbox = Instance.new("TextButton", Button)
				Clickbox.Text = ""
				Clickbox.Size = UDim2.fromScale(1, 1)
				Clickbox.ZIndex = 2
				Clickbox.BackgroundTransparency = 1
			end
			Clickbox.MouseButton1Click:Connect(function()
				task.spawn(function()
					local mouse = game.Players.LocalPlayer:GetMouse()
					local Yes = Instance.new("Frame", Button)
					Yes.Position = UDim2.fromOffset(mouse.X - Button.AbsolutePosition.X, mouse.Y - Button.AbsolutePosition.Y)
					Yes.BackgroundColor3 = Color3.fromRGB(33, 97, 200)
					Yes.Size = UDim2.fromOffset(0, 0)
					Yes.AnchorPoint = Vector2.new(0.5, 0.5)

					local Corner = Instance.new("UICorner", Yes)
					Corner.CornerRadius = UDim.new(1, 0)

					Tween(Yes, {Size = UDim2.fromOffset(50, 50)}, TweenInfo.new(0.76, Enum.EasingStyle.Quint))
					Tween(Yes, {BackgroundTransparency = 1}, TweenInfo.new(0.76, Enum.EasingStyle.Quint))
					game.Debris:AddItem(Yes, 0.76)
				end)
			end)
			Button.ClipsDescendants = true
		end

		Border.Name = "Border"
		Border.Parent = MainContainer
		Border.AnchorPoint = Vector2.new(0.5, 0.5)
		Border.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Border.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Border.BorderSizePixel = 0
		Border.Position = UDim2.new(0.5, 0, 0.5, 0)
		Border.Size = UDim2.new(1, -8, 1, -8)

		RealContainer.Name = "RealContainer"
		RealContainer.Parent = Border
		RealContainer.AnchorPoint = Vector2.new(0.5, 0.5)
		RealContainer.BackgroundColor3 = Color3.fromRGB(44, 45, 44)
		RealContainer.BorderColor3 = Color3.fromRGB(0, 0, 0)
		RealContainer.BorderSizePixel = 0
		RealContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
		RealContainer.Size = UDim2.new(1, -4, 1, -4)

		TopBar.Name = "TopBar"
		TopBar.Parent = RealContainer
		TopBar.BackgroundColor3 = Color3.fromRGB(39, 40, 39)
		TopBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TopBar.BorderSizePixel = 0
		TopBar.Position = UDim2.new(0, 5, 0, 5)
		TopBar.Size = UDim2.new(1, -10, 0, 35)

		Banner.Name = "Banner"
		Banner.Parent = TopBar
		Banner.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Banner.BackgroundTransparency = 1.000
		Banner.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Banner.BorderSizePixel = 0
		Banner.Position = UDim2.new(0, 5, 0, 5)
		Banner.Size = UDim2.new(0, 200, 0, 25)
		Banner.Image = "rbxassetid://115753353262664"
		Banner.ScaleType = Enum.ScaleType.Crop

		UICorner.CornerRadius = UDim.new(0, 6)
		UICorner.Parent = TopBar

		NavBar.Name = "NavBar"
		NavBar.Parent = RealContainer
		NavBar.BackgroundColor3 = Color3.fromRGB(39, 40, 39)
		NavBar.BorderColor3 = Color3.fromRGB(0, 0, 0)
		NavBar.BorderSizePixel = 0
		NavBar.Position = UDim2.new(0, 5, 0, 40)
		NavBar.Size = UDim2.new(0, 135, 1, -45)

		UICorner_2.CornerRadius = UDim.new(0, 6)
		UICorner_2.Parent = NavBar

		TabsImage.Name = "TabsImage"
		TabsImage.Parent = NavBar
		TabsImage.BackgroundColor3 = Color3.fromRGB(126, 126, 126)
		TabsImage.BackgroundTransparency = 1.000
		TabsImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TabsImage.BorderSizePixel = 0
		TabsImage.Position = UDim2.new(0, 5, 0, 5)
		TabsImage.Size = UDim2.new(0, 60, 0, 15)
		TabsImage.Image = "rbxassetid://98095955159445"
		TabsImage.ImageColor3 = Color3.fromRGB(156, 156, 156)
		TabsImage.ScaleType = Enum.ScaleType.Crop

		CornerFix.Name = "CornerFix"
		CornerFix.Parent = NavBar
		CornerFix.AnchorPoint = Vector2.new(1, 0)
		CornerFix.BackgroundColor3 = Color3.fromRGB(39, 40, 39)
		CornerFix.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CornerFix.BorderSizePixel = 0
		CornerFix.Position = UDim2.new(1, 0, 0, 0)
		CornerFix.Size = UDim2.new(0, 4, 0, 4)

		Tabs.Name = "Tabs"
		Tabs.Parent = NavBar
		Tabs.Active = true
		Tabs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Tabs.BackgroundTransparency = 1.000
		Tabs.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Tabs.BorderSizePixel = 0
		Tabs.Position = UDim2.new(0, 5, 0, 30)
		Tabs.Size = UDim2.new(1, -20, 1, -35)
		Tabs.ScrollBarThickness = 0

		UIListLayout.Parent = Tabs
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 3)

		UICorner_3.CornerRadius = UDim.new(0, 6)
		UICorner_3.Parent = RealContainer

		CornerArch.Name = "CornerArch"
		CornerArch.Parent = RealContainer
		CornerArch.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		CornerArch.BackgroundTransparency = 1.000
		CornerArch.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CornerArch.BorderSizePixel = 0
		CornerArch.Position = UDim2.new(0, 137, 0, 37)
		CornerArch.Size = UDim2.new(0, 15, 0, 15)
		CornerArch.Image = "rbxassetid://117509933334518"
		CornerArch.ImageColor3 = Color3.fromRGB(39, 40, 39)
		CornerArch.Visible = false

		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(44, 174, 255)), ColorSequenceKeypoint.new(0.42, Color3.fromRGB(82, 212, 255)), ColorSequenceKeypoint.new(0.47, Color3.fromRGB(42, 92, 255)), ColorSequenceKeypoint.new(0.52, Color3.fromRGB(82, 212, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(123, 253, 255))}
		UIGradient_2.Rotation = -180
		UIGradient_2.Parent = Border

		UICorner_5.CornerRadius = UDim.new(0, 6)
		UICorner_5.Parent = Border

		UICorner_6.Parent = MainContainer

		do 
			local UIS = game:GetService("UserInputService")
			local function dragify(Drag, Frame)
				local dragToggle = nil
				local dragSpeed = 0.08
				local dragInput = nil
				local dragStart = nil
				local dragPos = nil
				local Delta, Position, startPos
				local function updateInput(input)
					Delta = input.Position - dragStart
					Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
					game:GetService("TweenService"):Create(Frame, TweenInfo.new(dragSpeed), {Position = Position}):Play()
				end
				Drag.InputBegan:Connect(function(input)
					if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
						dragToggle = true
						dragStart = input.Position
						startPos = Frame.Position
						input.Changed:Connect(function()
							if input.UserInputState == Enum.UserInputState.End then
								dragToggle = false
							end
						end)
					end
				end)
				Drag.InputChanged:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
						dragInput = input
					end
				end)
				UIS.InputChanged:Connect(function(input)
					if input == dragInput and dragToggle then
						updateInput(input)
					end
				end)
			end
			dragify(TopBar, MainContainer)
		end
		
		spawn(function() -- UIGradient_2.GradientCycle 
			while task.wait() do
				local rotation = UIGradient_2.Rotation
				if rotation == 180 then
					rotation = -181
				else	
					rotation = rotation + 1
				end
				UIGradient_2.Rotation = rotation
			end
		end)
		
		local TabsTable = {}
		
		return {
			Tab = function(name)
				local AutoFarm = Instance.new("Frame")
				local TextLabel = Instance.new("TextButton")
				local UIGradient = Instance.new("UIGradient")
				local AutoFarmContent = Instance.new("Frame")
				local ScrollingFrame = Instance.new("ScrollingFrame")
				local UIListLayout_2 = Instance.new("UIListLayout")
				
				AutoFarm.Name = name
				AutoFarm.Parent = Tabs
				AutoFarm.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				AutoFarm.BackgroundTransparency = 1.000
				AutoFarm.BorderColor3 = Color3.fromRGB(0, 0, 0)
				AutoFarm.BorderSizePixel = 0
				AutoFarm.Size = UDim2.new(1, 0, 0, 21)

				TextLabel.Parent = AutoFarm
				TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				TextLabel.BackgroundTransparency = 1.000
				TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
				TextLabel.BorderSizePixel = 0
				TextLabel.Size = UDim2.new(1, 0, 1, 0)
				TextLabel.Font = Enum.Font.ArialBold
				TextLabel.Text = name
				TextLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
				TextLabel.TextSize = 14.000
				TextLabel.TextXAlignment = Enum.TextXAlignment.Left

				UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(44, 174, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(123, 253, 255))}
				UIGradient.Rotation = -180
				UIGradient.Parent = TextLabel
				UIGradient.Enabled = false
				
				AutoFarmContent.Name = "AutoFarmContent"
				AutoFarmContent.Parent = RealContainer
				AutoFarmContent.BackgroundColor3 = Color3.fromRGB(41, 42, 41)
				AutoFarmContent.BorderColor3 = Color3.fromRGB(0, 0, 0)
				AutoFarmContent.BorderSizePixel = 0
				AutoFarmContent.Position = UDim2.new(0, 147, 0, 47)
				AutoFarmContent.Size = UDim2.new(1, -160, 1, -57)
				AutoFarmContent.Visible = false

				UICorner_4.Parent = AutoFarmContent

				ScrollingFrame.Parent = AutoFarmContent
				ScrollingFrame.Active = true
				ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				ScrollingFrame.BackgroundTransparency = 1.000
				ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
				ScrollingFrame.BorderSizePixel = 0
				ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
				ScrollingFrame.Size = UDim2.new(1, -10, 1, -10)
				ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
				ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
				ScrollingFrame.ScrollBarImageColor3 = Color3.fromRGB(93, 93, 93)
				ScrollingFrame.BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				ScrollingFrame.TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"

				UIListLayout_2.Parent = ScrollingFrame
				UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_2.Padding = UDim.new(0, 6)
				
				local Tcount = #TabsTable + 1
				local G = {
					frame = AutoFarm,
					content = AutoFarmContent,
				}
				TabsTable[Tcount] = G
				
				local function onclick()
					(function()
						AutoFarmContent.Visible = true
						UIGradient.Enabled = true
						local Tw = Tween(TextLabel, {Position = UDim2.fromOffset(4, 0)})
						Tw.Completed:Once(function(Playback)
							Tween(TextLabel, {Position = UDim2.fromOffset(0, 0)})
						end)
						for i, Tab in pairs(TabsTable) do
							if Tab ~= TabsTable[Tcount] then
								Tween(Tab.frame.TextButton, {Position = UDim2.fromOffset(0, 0)})
								Tab.frame.TextButton.UIGradient.Enabled = false
								Tab.content.Visible = false
							end
						end

					end)()
				end
				if Tcount == 1 then
					onclick()
				end
				TextLabel.MouseButton1Click:Connect(onclick)
				
				return {
					Section = function(name)
						local Section = Instance.new("Frame")
						local Section_2 = Instance.new("ImageLabel")
						local UIGradient = Instance.new("UIGradient")
						local TextLabel = Instance.new("TextLabel")
						local Frame = Instance.new("ImageLabel")
						local UIGradient_2 = Instance.new("UIGradient")

						Section.Name = "Section"
						Section.Parent = ScrollingFrame
						Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Section.BackgroundTransparency = 1.000
						Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
						Section.BorderSizePixel = 0
						Section.Size = UDim2.new(1, -17, 0, 21)

						Section_2.Name = "Section"
						Section_2.Parent = Section
						Section_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Section_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
						Section_2.BorderSizePixel = 0
						Section_2.Size = UDim2.new(1, 0, 0, 0)
						Section_2.Image = "rbxassetid://115990690686320"
						

						UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(71, 160, 255)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(51, 245, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(71, 160, 255))}
						UIGradient.Parent = Section_2

						TextLabel.Parent = Section_2
						TextLabel.AnchorPoint = Vector2.new(0.5, 0)
						TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						TextLabel.BackgroundTransparency = 1.000
						TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
						TextLabel.BorderSizePixel = 0
						TextLabel.Position = UDim2.new(0.5, 0, 0, 0)
						TextLabel.Size = UDim2.new(1, 0, 0, 21)
						TextLabel.Font = Enum.Font.ArialBold
						TextLabel.Text = name
						TextLabel.TextColor3 = Color3.fromRGB(213, 213, 213)
						TextLabel.TextSize = 14.000
						TextLabel.TextStrokeColor3 = Color3.fromRGB(250, 250, 250)

						Frame.Parent = TextLabel
						Frame.AnchorPoint = Vector2.new(0, 1)
						Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
						Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
						Frame.BorderSizePixel = 0
						Frame.Position = UDim2.new(0, 0, 1, 0)
						Frame.Size = UDim2.new(1, 0, 0, 3)
						Frame.Image = "rbxassetid://115990690686320"
Frame.BackgroundTransparency = 1
						UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(71, 160, 255)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(51, 245, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(71, 160, 255))}
						UIGradient_2.Parent = Frame
						
						return {
							Toggle = function(name, callback, default)
								local Enabled = default
								local Toggle = Instance.new("Frame")
								local UICorner = Instance.new("UICorner")
								local TextLabel = Instance.new("TextLabel")
								local Frame = Instance.new("Frame")
								local UICorner_2 = Instance.new("UICorner")
								local Frame_2 = Instance.new("Frame")
								local UICorner_3 = Instance.new("UICorner")

								Toggle.Name = "Toggle"
								Toggle.Parent = ScrollingFrame
								Toggle.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
								Toggle.BorderColor3 = Color3.fromRGB(0, 0, 0)
								Toggle.BorderSizePixel = 0
								Toggle.Size = UDim2.new(1, -17, 0, 30)

								--UICorner.Parent = Toggle

								TextLabel.Parent = Toggle
								TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								TextLabel.BackgroundTransparency = 1.000
								TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
								TextLabel.BorderSizePixel = 0
								TextLabel.Position = UDim2.new(0, 8, 0, 0)
								TextLabel.Size = UDim2.new(1, -100, 1, 0)
								TextLabel.Font = Enum.Font.ArialBold
								TextLabel.Text = name
								TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
								TextLabel.TextSize = 14.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left

								Frame.Parent = Toggle
								Frame.AnchorPoint = Vector2.new(1, 0.5)
								Frame.BackgroundColor3 = Color3.fromRGB(39, 40, 39)
								Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
								Frame.BorderSizePixel = 0
								Frame.Position = UDim2.new(1, -8, 0.5, 0)
								Frame.Size = UDim2.new(0, 50, 0, 21)

								UICorner_2.CornerRadius = UDim.new(1, 0)
								UICorner_2.Parent = Frame

								Frame_2.Parent = Frame
								Frame_2.AnchorPoint = Vector2.new(0, 0.5)
								Frame_2.BackgroundColor3 = Color3.fromRGB(47, 148, 198)
								Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
								Frame_2.BorderSizePixel = 0
								Frame_2.Position = UDim2.new(0, 5, 0.5, 0)
								Frame_2.Size = UDim2.new(0, 15, 0, 15)

								UICorner_3.CornerRadius = UDim.new(1, 0)
								UICorner_3.Parent = Frame_2
								
								if default then
									Frame.BackgroundColor3 = Color3.fromRGB(46, 47, 46)
									Frame_2.BackgroundColor3 = Color3.fromRGB(52, 164, 216)
									Frame_2.Position = UDim2.new(1, -20, 0.5, 0)
								end
								
								local Clickbox = Instance.new("TextButton", Toggle)
								Clickbox.Text = ""
								Clickbox.Size = UDim2.fromScale(1, 1)
								Clickbox.ZIndex = 2
								Clickbox.BackgroundTransparency = 1
								Clickbox.MouseButton1Click:Connect(function()
									Enabled = not Enabled
									local Tweens = {
										[true] = {
											function()
												Tween(Frame, {BackgroundColor3 = Color3.fromRGB(46, 47, 46)})
											end,
											function()
												Tween(Frame_2, {BackgroundColor3 = Color3.fromRGB(52, 164, 216), Position = UDim2.new(1, -20, 0.5, 0)})
											end,
										},
										[false] = {
											function()
												Tween(Frame, {BackgroundColor3 = Color3.fromRGB(39, 40, 39)})
											end,
											function()
												Tween(Frame_2, {BackgroundColor3 = Color3.fromRGB(47, 148, 198), Position = UDim2.new(0, 5, 0.5, 0)})
											end,
										}
									}
									for i, Tween in pairs(Tweens[Enabled]) do
										Tween()
									end
									callback(Enabled)
								end)
								
								AddRipple(Clickbox)
							end,
							Button = function(name, callback)
								local Button = Instance.new("Frame")
								local UICorner = Instance.new("UICorner")
								local TextLabel = Instance.new("TextLabel")
								local ImageLabel = Instance.new("ImageLabel")
								Button.Name = "Button"
								Button.Parent = ScrollingFrame
								Button.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
								Button.BorderColor3 = Color3.fromRGB(0, 0, 0)
								Button.BorderSizePixel = 0
								Button.Size = UDim2.new(1, -17, 0, 30)
								Button.ClipsDescendants = true

								--UICorner.Parent = Button

								TextLabel.Parent = Button
								TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								TextLabel.BackgroundTransparency = 1.000
								TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
								TextLabel.BorderSizePixel = 0
								TextLabel.Position = UDim2.new(0, 8, 0, 0)
								TextLabel.Size = UDim2.new(1, -100, 1, 0)
								TextLabel.Font = Enum.Font.ArialBold
								TextLabel.Text = name
								TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
								TextLabel.TextSize = 14.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left

								ImageLabel.Parent = Button
								ImageLabel.AnchorPoint = Vector2.new(1, 0.5)
								ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								ImageLabel.BackgroundTransparency = 1.000
								ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
								ImageLabel.BorderSizePixel = 0
								ImageLabel.Position = UDim2.new(1, -8, 0.5, 0)
								ImageLabel.Size = UDim2.new(0, 20, 0, 20)
								ImageLabel.Image = "rbxassetid://81903642911217"
								ImageLabel.ImageColor3 = Color3.fromRGB(52, 164, 216)
								
								local Clickbox = Instance.new("TextButton", Button)
								Clickbox.Text = ""
								Clickbox.Size = UDim2.fromScale(1, 1)
								Clickbox.ZIndex = 2
								Clickbox.BackgroundTransparency = 1
								Clickbox.MouseButton1Click:Connect(function()
									(callback or function() end)()
								end)
								
								AddRipple(Clickbox)
							end,
							Slider = function(name, min, max, def, callback)
								local Slider = Instance.new("Frame")
								local TextLabel = Instance.new("TextLabel")
								local Frame = Instance.new("Frame")
								local UICorner = Instance.new("UICorner")
								local Frame_2 = Instance.new("Frame")
								local UICorner_2 = Instance.new("UICorner")
								local TextLabel_2 = Instance.new("TextLabel")

								Slider.Name = "Slider"
								Slider.Parent = ScrollingFrame
								Slider.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
								Slider.BorderColor3 = Color3.fromRGB(0, 0, 0)
								Slider.BorderSizePixel = 0
								Slider.Size = UDim2.new(1, -17, 0, 30)

								TextLabel.Parent = Slider
								TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								TextLabel.BackgroundTransparency = 1.000
								TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
								TextLabel.BorderSizePixel = 0
								TextLabel.Position = UDim2.new(0, 8, 0, 0)
								TextLabel.Size = UDim2.new(1, -100, 1, 0)
								TextLabel.Font = Enum.Font.ArialBold
								TextLabel.Text = name
								TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
								TextLabel.TextSize = 14.000
								TextLabel.TextXAlignment = Enum.TextXAlignment.Left

								Frame.Parent = Slider
								Frame.AnchorPoint = Vector2.new(1, 0.5)
								Frame.BackgroundColor3 = Color3.fromRGB(39, 40, 39)
								Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
								Frame.BorderSizePixel = 0
								Frame.Position = UDim2.new(1, -8, 0.5, 0)
								Frame.Size = UDim2.new(0, 100, 0, 15)

								UICorner.CornerRadius = UDim.new(1, 0)
								UICorner.Parent = Frame

								Frame_2.Parent = Frame
								Frame_2.BackgroundColor3 = Color3.fromRGB(47, 148, 198)
								Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
								Frame_2.BorderSizePixel = 0
								Frame_2.Size = UDim2.new(0.330000013, 0, 1, 0)

								UICorner_2.CornerRadius = UDim.new(1, 0)
								UICorner_2.Parent = Frame_2

								TextLabel_2.Parent = Frame
								TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
								TextLabel_2.BackgroundTransparency = 1.000
								TextLabel_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
								TextLabel_2.BorderSizePixel = 0
								TextLabel_2.Size = UDim2.new(1, 0, 1, 0)
								TextLabel_2.Font = Enum.Font.ArialBold
								TextLabel_2.Text = tostring(def)
								TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
								TextLabel_2.TextSize = 14.000
								

								local ClickBox = Instance.new("TextButton")
								ClickBox.Parent = Frame
								ClickBox.Text = ""
								ClickBox.BackgroundTransparency = 1
								ClickBox.ZIndex = 1
								ClickBox.Size = UDim2.fromScale(1, 1)
								
								local Dragging = false
								local Last
								ClickBox.MouseButton1Down:Connect(function(Key)
									--if WindowConnections:IsPress(Key) then
									Dragging = true
									while Dragging do
										local Percent = math.clamp((game:GetService("Players").LocalPlayer:GetMouse().X - Frame.AbsolutePosition.X) / Frame.AbsoluteSize.X, 0, 1) -- will you please fuck off roblox ai i dont want it
										local Value = min + (Percent*(max-min))
										TweenSevrice:Create(Frame_2, TweenInfo.new(0.1, Enum.EasingStyle.Quint), {Size = UDim2.fromScale(Percent, 1)}):Play()
										if math.floor(Value) ~= Last then
											TextLabel_2.Text = math.floor(Value);
											Last = math.floor(Value);
											(callback or function() end)(math.floor(Value))
										end
										wait()
									end
									--end
								end)
								game:GetService("UserInputService").InputEnded:Connect(function(Key)
									if Key.UserInputType == Enum.UserInputType.MouseButton1 or Key.UserInputType == Enum.UserInputType.Touch then
										Dragging = false
									end
								end)
							end,
						}
					end,
				}
			end,
		}
	end,
}

--[[local window = lib.Window()
local firsttab = window.Tab("Hello")
local secondtab = window.Tab("World")

local mainsection = firsttab.Section("Mobs")
mainsection.Toggle("Toggle", function(call)
	print(call)
end, true)
mainsection.Button("Click This", function()
	print("clicked it")
end)
mainsection.Slider("Hello", 5, 10, 8, print)]]

return lib
