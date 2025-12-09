local Library = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = not RunService:IsStudio() and game:GetService("CoreGui")

Library.string_crypt = (function(length)
	length = length or 16

	local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
	local result = {}

	for i = 1, length do
		local rand = math.random(1, #chars)
		result[i] = string.sub(chars, rand, rand)
	end

	return table.concat(result)
end)

Library.Window_crypt = Library.string_crypt(32)

Library.SafeParent = (function()
	if RunService:IsStudio() then
		return Players.LocalPlayer.PlayerGui
	end

	if gethui then
		return gethui()
	end

	return CoreGui
end)()

Library.IsMobile = (function()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		return true
	end

	return false
end)()

Library.AutoScale = (function()
	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		return 1
	end

	return 1.5
end)()

function Library:Tween(info)
	return TweenService:Create(info.v, TweenInfo.new(info.t, Enum.EasingStyle[info.s], Enum.EasingDirection[info.d]), info.g)
end

function Library:Button(p)
	local Click = Instance.new("TextButton")

	Click.Name = "Click"
	Click.Parent = p
	Click.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Click.BackgroundTransparency = 1.000
	Click.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Click.BorderSizePixel = 0
	Click.Size = UDim2.new(1, 0, 1, 0)
	Click.Font = Enum.Font.SourceSans
	Click.Text = ""
	Click.TextColor3 = Color3.fromRGB(0, 0, 0)
	Click.TextSize = 14.000
	Click.ZIndex = p.ZIndex + 3

	return Click
end

function Library:Draggable(inputframe, dragframe)
	local dragging = false
	local dragStart = nil
	local startPos = nil

	inputframe.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch then

			dragging = true

			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragStart = UserInputService:GetMouseLocation()
			else
				dragStart = input.Position
			end

			startPos = dragframe.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement 
			or input.UserInputType == Enum.UserInputType.Touch) then

			local currentPos
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				currentPos = UserInputService:GetMouseLocation()
			else
				currentPos = input.Position
			end

			local delta = currentPos - dragStart

			dragframe.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
end

function Library:Effect(c, p)
	p.ClipsDescendants = true
	local Mouse = game.Players.LocalPlayer:GetMouse()

	local relativeX = Mouse.X - c.AbsolutePosition.X
	local relativeY = Mouse.Y - c.AbsolutePosition.Y

	if relativeX < 0 or relativeY < 0 or relativeX > c.AbsoluteSize.X or relativeY > c.AbsoluteSize.Y then
		return
	end

	local ClickButtonCircle = Instance.new("Frame")
	ClickButtonCircle.Parent = p
	ClickButtonCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ClickButtonCircle.BackgroundTransparency = 0.5
	ClickButtonCircle.BorderSizePixel = 0
	ClickButtonCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	ClickButtonCircle.Position = UDim2.new(0, relativeX, 0, relativeY)
	ClickButtonCircle.Size = UDim2.new(0, 0, 0, 0)
	ClickButtonCircle.ZIndex = p.ZIndex

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = ClickButtonCircle

	local tweenInfo = TweenInfo.new(2.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	local goal = {
		Size = UDim2.new(0, c.AbsoluteSize.X * 1.5, 0, c.AbsoluteSize.X * 1.5),
		BackgroundTransparency = 1
	}

	local expandTween = TweenService:Create(ClickButtonCircle, tweenInfo, goal)

	expandTween.Completed:Connect(function()
		ClickButtonCircle:Destroy()
	end)

	expandTween:Play()
end

function Library:Resize(inputframe, frametoresize, minSize, maxSize, speed)
	if Library.IsMobile then return end

	local resizing = false
	local resizeStart = nil
	local startSize = nil

	minSize = minSize or Vector2.new(50, 50)
	maxSize = maxSize or Vector2.new(1000, 1000)
	speed   = speed or 1.5

	inputframe.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 
			or input.UserInputType == Enum.UserInputType.Touch then
			resizing = true
			resizeStart = input.Position
			startSize = frametoresize.Size

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					resizing = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement 
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = (input.Position - resizeStart) * speed

			local newX = math.clamp(startSize.X.Offset + delta.X, minSize.X, maxSize.X)
			local newY = math.clamp(startSize.Y.Offset + delta.Y, minSize.Y, maxSize.Y)

			frametoresize.Size = UDim2.new(
				startSize.X.Scale, newX,
				startSize.Y.Scale, newY
			)
		end
	end)
end

function Library:Asset(rbx)
	if typeof(rbx) == 'number' then
		return "rbxassetid://" .. rbx
	end

	if typeof(rbx) == 'string' and rbx:find('rbxassetid://') then
		return rbx
	end

	return rbx
end

function Library:VectorToUdim(vec2)
	return UDim2.new(0, vec2.X, 0, vec2.Y)
end

function Library:OnMouse(button)
	button.MouseEnter:Connect(function()
		Library:Tween({
			v = button,
			t = 0.15,
			s = "Bounce",
			d = "Out",
			g = {BackgroundTransparency = 0.5}
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		Library:Tween({
			v = button,
			t = 0.15,
			s = "Bounce",
			d = "Out",
			g = {BackgroundTransparency = 0}
		}):Play()
	end)
end

function Library:SimpleDraggable(a)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = TweenService:Create(a, TweenInfo.new(0.3), {Position = pos})
		Tween:Play()
	end

	a.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = a.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	a.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

function Library:Row(Parent, Title, Desc, Size)
	local Raw = Instance.new("Frame")
	local Text_1 = Instance.new("Frame")
	local Title_1 = Instance.new("TextLabel")
	local UIListLayout_1 = Instance.new("UIListLayout")

	local Sizes = Size or 0.8

	Raw.Name = "Raw"
	Raw.Parent = Parent
	Raw.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Raw.BackgroundTransparency = 1
	Raw.BorderColor3 = Color3.fromRGB(0,0,0)
	Raw.BorderSizePixel = 0
	Raw.Position = UDim2.new(0.030882353, 0,0, 0)
	Raw.Size = UDim2.new(1, 0,0, 27)

	Text_1.Name = "Text"
	Text_1.Parent = Raw
	Text_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Text_1.BackgroundTransparency = 1
	Text_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Text_1.BorderSizePixel = 0
	Text_1.Position = UDim2.new(0.00121151912, 0,0, 0)
	Text_1.Size = UDim2.new(1, 0,1, 0)

	Title_1:GetPropertyChangedSignal('TextBounds'):Connect(function()
		Title_1.Size = UDim2.new(Sizes, 0,0, Title_1.TextBounds.Y)
	end)

	Title_1.Name = "Title"
	Title_1.Parent = Text_1
	Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_1.BackgroundTransparency = 1
	Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_1.BorderSizePixel = 0
	Title_1.LayoutOrder = -1
	Title_1.Position = UDim2.new(0, 0,0.200000003, 0)
	Title_1.Size = UDim2.new(Sizes, 0,0, 14)
	Title_1.Font = Enum.Font.GothamMedium
	Title_1.RichText = true
	Title_1.Text = Title
	Title_1.TextColor3 = Color3.fromRGB(255,255,255)
	Title_1.TextSize = 14
	Title_1.TextXAlignment = Enum.TextXAlignment.Left

	UIListLayout_1.Parent = Text_1
	UIListLayout_1.Padding = UDim.new(0,1)
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	local Desc_1 = Desc and Instance.new('TextLabel') or nil do
		if Desc then
			Desc_1:GetPropertyChangedSignal('TextBounds'):Connect(function()
				Desc_1.Size = UDim2.new(Sizes, 0,0, Desc_1.TextBounds.Y)
			end)

			Desc_1.Name = "Desc"
			Desc_1.Parent = Text_1
			Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Desc_1.BackgroundTransparency = 1
			Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Desc_1.BorderSizePixel = 0
			Desc_1.Position = UDim2.new(0, 0,0.555555582, 0)
			Desc_1.Size = UDim2.new(Sizes, 0,0, 12)
			Desc_1.Font = Enum.Font.GothamMedium
			Desc_1.RichText = true
			Desc_1.Text = Desc
			Desc_1.TextColor3 = Color3.fromRGB(255,255,255)
			Desc_1.TextSize = 11
			Desc_1.TextTransparency = 0.5
			Desc_1.TextWrapped = true
			Desc_1.TextXAlignment = Enum.TextXAlignment.Left
			Desc_1.TextYAlignment = Enum.TextYAlignment.Top
		end
	end

	UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Raw.Size = UDim2.new(1, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 5)
	end)

	task.delay(0.1, function()
		Raw.Size = UDim2.new(1, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 5)
	end)

	return Raw
end

function Library.new(params)
	local self = Library

	local Title = params.Title or "Xzer"
	local Author = params.Author or "Premium's Script"
	local Logo = params.Logo or 89020944660589
	local Keybind = params.Enum or Enum.KeyCode['F1']
	local Size = params.Size or UDim2.new(0, 500,0, 360)

	local Xzer = Instance.new("ScreenGui")
	local Main_1 = Instance.new("Frame")
	local Backgroud_1 = Instance.new("Frame")
	local Blur_1 = Instance.new("ImageLabel")
	local UICorner_1 = Instance.new("UICorner")
	local UIStroke_1 = Instance.new("UIStroke")

	Xzer.Name = self.Window_crypt
	Xzer.Parent = self.SafeParent
	Xzer.ZIndexBehavior = Enum.ZIndexBehavior.Global
	Xzer.IgnoreGuiInset = true

	Main_1.Name = "Main"
	Main_1.Parent = Xzer
	Main_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Main_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Main_1.BackgroundTransparency = 1
	Main_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Main_1.BorderSizePixel = 0
	Main_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Main_1.Size = Size

	Backgroud_1.Name = "Backgroud"
	Backgroud_1.Parent = Main_1
	Backgroud_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Backgroud_1.BackgroundColor3 = Color3.fromRGB(37,37,38)
	Backgroud_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Backgroud_1.BorderSizePixel = 0
	Backgroud_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Backgroud_1.Size = UDim2.new(1, 0,1, 0)

	Blur_1.Name = "Blur"
	Blur_1.Parent = Backgroud_1
	Blur_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Blur_1.BackgroundColor3 = Color3.fromRGB(28,28,30)
	Blur_1.BackgroundTransparency = 1
	Blur_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Blur_1.BorderSizePixel = 0
	Blur_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Blur_1.Size = UDim2.new(1, 120,1, 116)
	Blur_1.ZIndex = - 999999999
	Blur_1.Image = "rbxassetid://8992230677"
	Blur_1.ImageColor3 = Color3.fromRGB(0,0,0)
	Blur_1.ImageTransparency = 0.6000000238418579
	Blur_1.ScaleType = Enum.ScaleType.Slice
	Blur_1.SliceCenter = Rect.new(99, 99, 99, 99)

	UICorner_1.Parent = Backgroud_1

	UIStroke_1.Parent = Backgroud_1
	UIStroke_1.Color = Color3.fromRGB(48,48,48)
	UIStroke_1.Thickness = 1

	local Components = Instance.new("Frame")
	local Draggable_1 = Instance.new("ImageLabel")
	local Input_1 = Instance.new("TextButton")
	local Size_1 = Instance.new("Frame")

	Components.Name = "Components"
	Components.Parent = Backgroud_1
	Components.AnchorPoint = Vector2.new(0.5, 0.5)
	Components.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Components.BackgroundTransparency = 1
	Components.BorderColor3 = Color3.fromRGB(0,0,0)
	Components.BorderSizePixel = 0
	Components.Position = UDim2.new(0.5, 0,0.5, 0)
	Components.Size = UDim2.new(1, 0,1, 0)

	Draggable_1.Name = "Draggable"
	Draggable_1.Parent = Components
	Draggable_1.AnchorPoint = Vector2.new(0.5, 0)
	Draggable_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Draggable_1.BackgroundTransparency = 1
	Draggable_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Draggable_1.BorderSizePixel = 0
	Draggable_1.Position = UDim2.new(0.5, 0,1, 4)
	Draggable_1.Size = UDim2.new(0, 200,0, 4)
	Draggable_1.Image = "rbxassetid://80999662900595"
	Draggable_1.ImageTransparency = 0.800000011920929
	Draggable_1.ScaleType = Enum.ScaleType.Slice
	Draggable_1.SliceCenter = Rect.new(256, 256, 256, 256)
	Draggable_1.SliceScale = 0.38671875

	Input_1.Name = "Input"
	Input_1.Parent = Draggable_1
	Input_1.Active = true
	Input_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Input_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Input_1.BackgroundTransparency = 1
	Input_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Input_1.BorderSizePixel = 0
	Input_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Input_1.Size = UDim2.new(1, 12,1, 12)
	Input_1.Font = Enum.Font.SourceSans
	Input_1.Text = ""
	Input_1.TextSize = 14

	Size_1.Name = "Size"
	Size_1.Parent = Components
	Size_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Size_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Size_1.BackgroundTransparency = 1
	Size_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Size_1.BorderSizePixel = 0
	Size_1.Position = UDim2.new(1, 0,1, 0)
	Size_1.Size = UDim2.new(0, 40,0, 40)
	Size_1.ZIndex = -99

	local Toggle = Instance.new("ImageLabel") do
		local Input_1 = Instance.new("TextButton")
		Toggle.Name = "Toggle"
		Toggle.Parent = Xzer
		Toggle.AnchorPoint = Vector2.new(1, 0.5)
		Toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Toggle.BackgroundTransparency = 1
		Toggle.BorderColor3 = Color3.fromRGB(0,0,0)
		Toggle.BorderSizePixel = 0
		Toggle.Position = UDim2.new(0.015, 0,0.5, 0)
		Toggle.Size = UDim2.new(0, 7,0, 200)
		Toggle.Image = "rbxassetid://80999662900595"
		Toggle.ImageTransparency = 0.699999988079071
		Toggle.ScaleType = Enum.ScaleType.Slice
		Toggle.SliceCenter = Rect.new(256, 256, 256, 256)
		Toggle.SliceScale = 0.38671875

		Input_1.Name = "Input"
		Input_1.Parent = Toggle
		Input_1.Active = true
		Input_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Input_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Input_1.BackgroundTransparency = 1
		Input_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Input_1.BorderSizePixel = 0
		Input_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Input_1.Size = UDim2.new(1, 25,1, 25)
		Input_1.Font = Enum.Font.SourceSans
		Input_1.Text = ""
		Input_1.TextSize = 14
		Input_1.ZIndex = 99

		local function closeopenui()
			Main_1:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Sine", 0.1, true)
			Library:Tween({
				v = Toggle,
				t = 0.2,
				s = "Back",
				d = "Out",
				g = {ImageTransparency = 0.3}
			}):Play()
			delay(0.1, function()
				Library:Tween({
					v = Toggle,
					t = 0.2,
					s = "Back",
					d = "Out",
					g = {ImageTransparency = 0.7}
				}):Play()
			end)
			Main_1.Visible = not Main_1.Visible
		end

		local On = true

		Input_1.MouseButton1Click:Connect(function()
			closeopenui()
			On = not On
		end)

		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if not gameProcessed and input.KeyCode == Keybind then
				closeopenui()
				On = not On
			end
		end)
	end

	local SizeCorner = Instance.new("UICorner")
	SizeCorner.Parent = Size_1
	SizeCorner.CornerRadius = UDim.new(1, 0)

	Size_1.MouseEnter:Connect(function()
		Library:Tween({
			v = Size_1,
			t = 0.5,
			s = "Exponential",
			d = "Out",
			g = {BackgroundTransparency = 0.8}
		}):Play()
	end)

	Size_1.MouseLeave:Connect(function()
		Library:Tween({
			v = Size_1,
			t = 0.5,
			s = "Exponential",
			d = "Out",
			g = {BackgroundTransparency = 1}
		}):Play()
	end)

	if Library.IsMobile then
		local MinSize = Vector2.new(430, 315)
		local MaxSize = Vector2.new(500, 350)

		local UIScale = Instance.new("UIScale")
		UIScale.Scale = 1.075
		UIScale.Parent = Xzer

		Main_1.Size = UDim2.new(0, 450, 0, 315)

		self:Resize(Size_1, Main_1, MinSize, MaxSize, 2)
	else
		local MinSize = Vector2.new(500, 350)
		local MaxSize = Vector2.new(850, 600)

		self:Resize(Size_1, Main_1, MinSize, MaxSize, 2)
	end

	local Tabs = Instance.new("Frame")
	local RE_Light_1 = Instance.new("Frame")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local Close_1 = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local Minisize_1 = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Max_1 = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIPadding_1 = Instance.new("UIPadding")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local RE_Tabs_1 = Instance.new("Frame")
	local RF_Scrolling_1 = Instance.new("ScrollingFrame")
	local UIListLayout_3 = Instance.new("UIListLayout")
	local UIPadding_2 = Instance.new("UIPadding")
	local UIPadding_3 = Instance.new("UIPadding")

	Tabs.Name = "Tabs"
	Tabs.Parent = Backgroud_1
	Tabs.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Tabs.BackgroundTransparency = 1
	Tabs.BorderColor3 = Color3.fromRGB(0,0,0)
	Tabs.BorderSizePixel = 0
	Tabs.Size = UDim2.new(0, 135,1, 0)

	RE_Light_1.Name = "RE_Light"
	RE_Light_1.Parent = Tabs
	RE_Light_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	RE_Light_1.BackgroundTransparency = 1
	RE_Light_1.BorderColor3 = Color3.fromRGB(0,0,0)
	RE_Light_1.BorderSizePixel = 0
	RE_Light_1.LayoutOrder = -5
	RE_Light_1.Position = UDim2.new(0, 0,0.922005594, 0)
	RE_Light_1.Size = UDim2.new(1, 0,0, 50)

	UIListLayout_1.Parent = RE_Light_1
	UIListLayout_1.Padding = UDim.new(0,11)
	UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	Close_1.Name = "Close"
	Close_1.Parent = RE_Light_1
	Close_1.BackgroundColor3 = Color3.fromRGB(255,112,112)
	Close_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Close_1.BorderSizePixel = 0
	Close_1.Size = UDim2.new(0, 10,0, 10)

	UICorner_1.Parent = Close_1
	UICorner_1.CornerRadius = UDim.new(1,0)

	Minisize_1.Name = "Minisize"
	Minisize_1.Parent = RE_Light_1
	Minisize_1.BackgroundColor3 = Color3.fromRGB(255,255,127)
	Minisize_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Minisize_1.BorderSizePixel = 0
	Minisize_1.Size = UDim2.new(0, 10,0, 10)

	UICorner_2.Parent = Minisize_1
	UICorner_2.CornerRadius = UDim.new(1,0)

	Max_1.Name = "Max"
	Max_1.Parent = RE_Light_1
	Max_1.BackgroundColor3 = Color3.fromRGB(73,255,146)
	Max_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Max_1.BorderSizePixel = 0
	Max_1.Size = UDim2.new(0, 10,0, 10)

	Library:OnMouse(Max_1) do
		local MinSize = Vector2.new(500, 350)
		local MaxSize = Vector2.new(850, 600)
		local LastSize = Main_1.Size
		local Threshold = 100
		local MaxButton = Library:Button(Max_1)

		local function Maxs(value)
			if value then
				if Main_1.Size.Y.Offset ~= MaxSize.Y then
					local MaxY = Library:Tween({
						v = Main_1,
						t = 0.2,
						s = "Exponential",
						d = "Out",
						g = {Size = UDim2.new(0, Main_1.Size.X.Offset, 0, MaxSize.Y)}
					})

					MaxY:Play()
					MaxY.Completed:Wait()
				end

				if Main_1.Size.X.Offset ~= MaxSize.X then
					Library:Tween({
						v = Main_1,
						t = 0.2,
						s = "Exponential",
						d = "Out",
						g = {Size = UDim2.new(0, MaxSize.X, 0, Main_1.Size.Y.Offset)}
					}):Play()
				end
			else
				if Main_1.Size.X.Offset ~= MinSize.X then
					local MinX = Library:Tween({
						v = Main_1,
						t = 0.2,
						s = "Exponential",
						d = "Out",
						g = {Size = UDim2.new(0, MinSize.X, 0, Main_1.Size.Y.Offset)}
					})

					MinX:Play()
					MinX.Completed:Wait()
				end

				if Main_1.Size.Y.Offset ~= MinSize.Y then
					Library:Tween({
						v = Main_1,
						t = 0.2,
						s = "Exponential",
						d = "Out",
						g = {Size = UDim2.new(0, Main_1.Size.X.Offset, 0, MinSize.Y)}
					}):Play()
				end
			end
		end


		MaxButton.MouseButton1Click:Connect(function()
			LastSize = Main_1.Size

			local curX = LastSize.X.Offset
			local curY = LastSize.Y.Offset

			local distanceToMin = math.sqrt((curX - MinSize.X)^2 + (curY - MinSize.Y)^2)
			local distanceToMax = math.sqrt((curX - MaxSize.X)^2 + (curY - MaxSize.Y)^2)

			if distanceToMin <= Threshold then
				Maxs(true)
			elseif distanceToMax <= Threshold then
				Maxs(false)
			else
				Maxs(true)
			end
		end)
	end

	Library:OnMouse(Minisize_1) do
		local MinisizeButton = Library:Button(Minisize_1)

		MinisizeButton.MouseButton1Click:Connect(function()
			Main_1.Visible = false
		end)
	end

	Library:OnMouse(Close_1) do
		local CloseButton = Library:Button(Close_1)

		CloseButton.MouseButton1Click:Connect(function()
			Xzer:Destroy()
		end)
	end

	UICorner_3.Parent = Max_1
	UICorner_3.CornerRadius = UDim.new(1,0)

	UIPadding_1.Parent = RE_Light_1
	UIPadding_1.PaddingLeft = UDim.new(0,17)

	UIListLayout_2.Parent = Tabs
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder

	RE_Tabs_1.Name = "RE_Tabs"
	RE_Tabs_1.Parent = Tabs
	RE_Tabs_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	RE_Tabs_1.BackgroundTransparency = 1
	RE_Tabs_1.BorderColor3 = Color3.fromRGB(0,0,0)
	RE_Tabs_1.BorderSizePixel = 0
	RE_Tabs_1.LayoutOrder = -4
	RE_Tabs_1.Position = UDim2.new(0, 0,0.138888896, 0)
	RE_Tabs_1.Size = UDim2.new(1, 0,1, 0)

	RF_Scrolling_1.Name = "RF_Scrolling"
	RF_Scrolling_1.Parent = RE_Tabs_1
	RF_Scrolling_1.Active = true
	RF_Scrolling_1.AnchorPoint = Vector2.new(0.5, 0.5)
	RF_Scrolling_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	RF_Scrolling_1.BackgroundTransparency = 1
	RF_Scrolling_1.BorderColor3 = Color3.fromRGB(0,0,0)
	RF_Scrolling_1.BorderSizePixel = 0
	RF_Scrolling_1.Position = UDim2.new(0.5, 0,0.5, 0)
	RF_Scrolling_1.Size = UDim2.new(1, 0,1, 0)
	RF_Scrolling_1.ClipsDescendants = true
	RF_Scrolling_1.AutomaticCanvasSize = Enum.AutomaticSize.None
	RF_Scrolling_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
	RF_Scrolling_1.CanvasPosition = Vector2.new(0, 0)
	RF_Scrolling_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	RF_Scrolling_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	RF_Scrolling_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	RF_Scrolling_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
	RF_Scrolling_1.ScrollBarImageTransparency = 1
	RF_Scrolling_1.ScrollBarThickness = 0
	RF_Scrolling_1.ScrollingDirection = Enum.ScrollingDirection.XY
	RF_Scrolling_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
	RF_Scrolling_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
	RF_Scrolling_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

	UIListLayout_3.Parent = RF_Scrolling_1
	UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder

	UIListLayout_3:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		RF_Scrolling_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_3.AbsoluteContentSize.Y + 15)
	end)

	UIPadding_2.Parent = RF_Scrolling_1
	UIPadding_2.PaddingTop = UDim.new(0,2)

	UIPadding_3.Parent = RE_Tabs_1
	UIPadding_3.PaddingBottom = UDim.new(0,50)

	local Header = Instance.new("Frame")
	local Head_1 = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local SQ_1 = Instance.new("Frame")
	local SQ2_1 = Instance.new("Frame")
	local Window_1 = Instance.new("Frame")
	local Textfield_1 = Instance.new("Frame")
	local Title_1 = Instance.new("TextLabel")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local Desc_1 = Instance.new("TextLabel")
	local Icon_1q = Instance.new("ImageLabel")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local UIPadding_1 = Instance.new("UIPadding")
	local Search_1 = Instance.new("Frame")
	local Search_2 = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local UIStroke_1 = Instance.new("UIStroke")
	local UIListLayout_3 = Instance.new("UIListLayout")
	local asset_1 = Instance.new("ImageLabel")
	local UIPadding_2 = Instance.new("UIPadding")
	local SearchBox_1 = Instance.new("TextBox")
	local UIPadding_3 = Instance.new("UIPadding")
	local UIPadding_4 = Instance.new("UIPadding")

	self:Draggable(Input_1, Main_1)
	self:Draggable(Header, Main_1)

	Header.Name = "Header"
	Header.Parent = Backgroud_1
	Header.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Header.BackgroundTransparency = 1
	Header.BorderColor3 = Color3.fromRGB(0,0,0)
	Header.BorderSizePixel = 0
	Header.Size = UDim2.new(1, 0,0, 50)

	Head_1.Name = "Head"
	Head_1.Parent = Header
	Head_1.AnchorPoint = Vector2.new(0, 0.5)
	Head_1.BackgroundColor3 = Color3.fromRGB(54,54,54)
	Head_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Head_1.BorderSizePixel = 0
	Head_1.Position = UDim2.new(0, 0,0.5, 0)
	Head_1.Size = UDim2.new(1, 0,1, 0)

	UICorner_1.Parent = Head_1

	SQ_1.Name = "SQ"
	SQ_1.Parent = Head_1
	SQ_1.BackgroundColor3 = Color3.fromRGB(54,54,54)
	SQ_1.BorderColor3 = Color3.fromRGB(0,0,0)
	SQ_1.BorderSizePixel = 0
	SQ_1.Size = UDim2.new(0, 10,1, 0)

	SQ2_1.Name = "SQ2"
	SQ2_1.Parent = Head_1
	SQ2_1.AnchorPoint = Vector2.new(0, 1)
	SQ2_1.BackgroundColor3 = Color3.fromRGB(54,54,54)
	SQ2_1.BorderColor3 = Color3.fromRGB(0,0,0)
	SQ2_1.BorderSizePixel = 0
	SQ2_1.Position = UDim2.new(0, 0,1, 0)
	SQ2_1.Size = UDim2.new(1, 0,0, 5)

	Window_1.Name = "Window"
	Window_1.Parent = Head_1
	Window_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Window_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Window_1.BackgroundTransparency = 1
	Window_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Window_1.BorderSizePixel = 0
	Window_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Window_1.Size = UDim2.new(1, 0,1, 0)

	Textfield_1.Name = "Textfield"
	Textfield_1.Parent = Window_1
	Textfield_1.AnchorPoint = Vector2.new(1, 0.5)
	Textfield_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Textfield_1.BackgroundTransparency = 1
	Textfield_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Textfield_1.BorderSizePixel = 0
	Textfield_1.Position = UDim2.new(0.0845070407, 0,0, 0)
	Textfield_1.Size = UDim2.new(0, 325,0, 47)

	Title_1.Name = "Title"
	Title_1.Parent = Textfield_1
	Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_1.BackgroundTransparency = 1
	Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_1.BorderSizePixel = 0
	Title_1.Position = UDim2.new(0, 0,0.280000001, 0)
	Title_1.Size = UDim2.new(0, 200,0, 16)
	Title_1.Font = Enum.Font.GothamSemibold
	Title_1.Text = Title
	Title_1.TextColor3 = Color3.fromRGB(255,255,255)
	Title_1.TextSize = 15
	Title_1.TextXAlignment = Enum.TextXAlignment.Left

	UIListLayout_1.Parent = Textfield_1
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	Desc_1.Name = "Desc"
	Desc_1.Parent = Textfield_1
	Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Desc_1.BackgroundTransparency = 1
	Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Desc_1.BorderSizePixel = 0
	Desc_1.Position = UDim2.new(0, 0,0.280000001, 0)
	Desc_1.Size = UDim2.new(0, 200,0, 14)
	Desc_1.Font = Enum.Font.GothamMedium
	Desc_1.Text = Author
	Desc_1.TextColor3 = Color3.fromRGB(255,255,255)
	Desc_1.TextSize = 10
	Desc_1.TextTransparency = 0.20000000298023224
	Desc_1.TextXAlignment = Enum.TextXAlignment.Left

	Icon_1q.Name = "Icon"
	Icon_1q.Parent = Window_1
	Icon_1q.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Icon_1q.BackgroundTransparency = 1
	Icon_1q.BorderColor3 = Color3.fromRGB(0,0,0)
	Icon_1q.BorderSizePixel = 0
	Icon_1q.LayoutOrder = -1
	Icon_1q.Size = UDim2.new(0, 20,0, 20)
	Icon_1q.Image = ""
	Icon_1q.ImageTransparency = 0.5

	UIListLayout_2.Parent = Window_1
	UIListLayout_2.Padding = UDim.new(0,10)
	UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

	UIPadding_1.Parent = Window_1
	UIPadding_1.PaddingLeft = UDim.new(0,10)

	Search_1.Name = "Search"
	Search_1.Parent = Head_1
	Search_1.AnchorPoint = Vector2.new(1, 0.5)
	Search_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Search_1.BackgroundTransparency = 1
	Search_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Search_1.BorderSizePixel = 0
	Search_1.Position = UDim2.new(1, 0,0.5, 0)
	Search_1.Size = UDim2.new(1, 0,1, 0)

	Search_2.Name = "Search"
	Search_2.Parent = Search_1
	Search_2.AnchorPoint = Vector2.new(1, 0.5)
	Search_2.BackgroundColor3 = Color3.fromRGB(54,54,54)
	Search_2.BorderColor3 = Color3.fromRGB(0,0,0)
	Search_2.BorderSizePixel = 0
	Search_2.Position = UDim2.new(1, 0,0.5, 0)
	Search_2.Size = UDim2.new(0, 100,0, 25)

	UICorner_2.Parent = Search_2
	UICorner_2.CornerRadius = UDim.new(0,5)

	UIStroke_1.Parent = Search_2
	UIStroke_1.Color = Color3.fromRGB(110,110,110)
	UIStroke_1.Thickness = 1

	UIListLayout_3.Parent = Search_2
	UIListLayout_3.Padding = UDim.new(0,5)
	UIListLayout_3.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_3.VerticalAlignment = Enum.VerticalAlignment.Center

	asset_1.Name = "asset"
	asset_1.Parent = Search_2
	asset_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	asset_1.BackgroundTransparency = 1
	asset_1.BorderColor3 = Color3.fromRGB(0,0,0)
	asset_1.BorderSizePixel = 0
	asset_1.Size = UDim2.new(0, 15,0, 15)
	asset_1.Image = "rbxassetid://125928820284709"

	UIPadding_2.Parent = Search_2
	UIPadding_2.PaddingLeft = UDim.new(0,5)

	SearchBox_1.Name = "SearchBox"
	SearchBox_1.Parent = Search_2
	SearchBox_1.Active = true
	SearchBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	SearchBox_1.BackgroundTransparency = 1
	SearchBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
	SearchBox_1.BorderSizePixel = 0
	SearchBox_1.Position = UDim2.new(0.157894731, 0,0.100000001, 0)
	SearchBox_1.Size = UDim2.new(0, 70,0, 20)
	SearchBox_1.Font = Enum.Font.GothamMedium
	SearchBox_1.PlaceholderText = "Search ..."
	SearchBox_1.Text = ""
	SearchBox_1.TextColor3 = Color3.fromRGB(178,178,178)
	SearchBox_1.TextSize = 12
	SearchBox_1.TextXAlignment = Enum.TextXAlignment.Left

	UIPadding_3.Parent = Search_1
	UIPadding_3.PaddingRight = UDim.new(0,10)

	UIPadding_4.Parent = Header
	UIPadding_4.PaddingLeft = UDim.new(0,135)

	local PageFolder = Instance.new("Frame")
	local UIPadding_2 = Instance.new("UIPadding")

	PageFolder.Name = "PageFolder"
	PageFolder.Parent = Backgroud_1
	PageFolder.AnchorPoint = Vector2.new(0.5, 0.5)
	PageFolder.BackgroundColor3 = Color3.fromRGB(255,255,255)
	PageFolder.BackgroundTransparency = 1
	PageFolder.BorderColor3 = Color3.fromRGB(0,0,0)
	PageFolder.BorderSizePixel = 0
	PageFolder.Position = UDim2.new(0.5, 0,0.5, 0)
	PageFolder.Size = UDim2.new(1, 0,1, 0)

	UIPadding_2.Parent = PageFolder
	UIPadding_2.PaddingLeft = UDim.new(0,135)
	UIPadding_2.PaddingTop = UDim.new(0,50)

	SearchBox_1.Changed:Connect(function()
		local searchText = string.lower(SearchBox_1.Text)

		for _, page in pairs(PageFolder:GetChildren()) do
			if page:IsA("Frame") and page.Name == "AddPage" and page.Visible then
				local scrolling = page.Page.Scrolling
				for _, section in pairs(scrolling:GetChildren()) do
					if section.Name == "PageTitle" or section.Name == "Section" then
						local foundSomething = false
						local visibleRows = {}

						for i, row in ipairs(section:GetChildren()) do
							if row:IsA("Frame") or row:IsA("TextLabel") then
								if row.Name ~= "Line" then
									local rowVisible = false

									if row:IsA("TextLabel") then
										local labelText = string.lower(row.Text)
										if string.find(labelText, searchText, 1, true) then
											rowVisible = true
											foundSomething = true
										end
									end

									if row:IsA("Frame") then
										for _, con in pairs(row:GetDescendants()) do
											if con:IsA("TextLabel") then
												local labelText = string.lower(con.Text)
												if string.find(labelText, searchText, 1, true) then
													rowVisible = true
													foundSomething = true
													break
												end
											end
										end
									end

									row.Visible = rowVisible

									if rowVisible then
										table.insert(visibleRows, i)
									end

									local nextRow = section:GetChildren()[i + 1]
									if nextRow and nextRow.Name == "Line" then
										nextRow.Visible = rowVisible
									end
								end
							end
						end

						if #visibleRows == 1 then
							for _, child in ipairs(section:GetChildren()) do
								if child.Name == "Line" then
									child.Visible = false
								end
							end
						elseif #visibleRows > 1 then
							local lastRowIndex = visibleRows[#visibleRows]
							local lastLine = section:GetChildren()[lastRowIndex + 1]
							if lastLine and lastLine.Name == "Line" then
								lastLine.Visible = false
							end
						end

						section.Visible = foundSomething
					end
				end
			end
		end
	end)

	SearchBox_1.Focused:Connect(function()
		SearchBox_1.TextTruncate = Enum.TextTruncate.None
		for _, page in pairs(PageFolder:GetChildren()) do
			if page:IsA("Frame") and page.Name == "AddPage" and page.Visible then
				local scrolling = page.Page.Scrolling
				scrolling.CanvasPosition = Vector2.new(0, 0)
			end
		end
	end)

	SearchBox_1.FocusLost:Connect(function()
		SearchBox_1.TextTruncate = Enum.TextTruncate.AtEnd
		for _, page in pairs(PageFolder:GetChildren()) do
			if page:IsA("Frame") and page.Name == "AddPage" and page.Visible then
				local scrolling = page.Page.Scrolling
				scrolling.CanvasPosition = Vector2.new(0, 0)
			end
		end
	end)

	local Tab = {
		Value = false
	}

	function Tab:Add(params)
		local Title = params.Title or "Unknow"
		local Icon = params.Icon and Library:Asset(params.Icon) or 0

		local AddTab = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local About_1 = Instance.new("Frame")
		local Title_1 = Instance.new("TextLabel")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local Icon_1 = Instance.new("ImageLabel")
		local UIPadding_1 = Instance.new("UIPadding")
		local ClickTabs = Library:Button(AddTab)

		AddTab.Name = "AddTab"
		AddTab.Parent = RF_Scrolling_1
		AddTab.BackgroundColor3 = Color3.fromRGB(233, 1, 77)
		AddTab.BackgroundTransparency = 1
		AddTab.BorderColor3 = Color3.fromRGB(0,0,0)
		AddTab.BorderSizePixel = 0
		AddTab.Size = UDim2.new(0, 120,0, 30)

		UICorner_1.Parent = AddTab
		UICorner_1.CornerRadius = UDim.new(0,5)

		About_1.Name = "About"
		About_1.Parent = AddTab
		About_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		About_1.BackgroundTransparency = 1
		About_1.BorderColor3 = Color3.fromRGB(0,0,0)
		About_1.BorderSizePixel = 0
		About_1.Size = UDim2.new(1, 0,1, 0)

		Title_1.Name = "Title"
		Title_1.Parent = About_1
		Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Title_1.BackgroundTransparency = 1
		Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Title_1.BorderSizePixel = 0
		Title_1.Position = UDim2.new(0.586206913, 0,0.5, 0)
		Title_1.Size = UDim2.new(0.827586234, 0,1, 0)
		Title_1.Font = Enum.Font.GothamBold
		Title_1.Text = Title
		Title_1.TextColor3 = Color3.fromRGB(255,255,255)
		Title_1.TextSize = 12
		Title_1.TextTransparency = 0.30000001192092896
		Title_1.TextXAlignment = Enum.TextXAlignment.Left

		UIListLayout_1.Parent = About_1
		UIListLayout_1.Padding = UDim.new(0,6)
		UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

		Icon_1.Name = "Icon"
		Icon_1.Parent = About_1
		Icon_1.BackgroundColor3 = Color3.fromRGB(10,130,255)
		Icon_1.BackgroundTransparency = 1
		Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Icon_1.BorderSizePixel = 0
		Icon_1.LayoutOrder = -1
		Icon_1.Size = UDim2.new(0, 15,0, 15)
		Icon_1.Image = Icon
		Icon_1.ImageColor3 = Color3.fromRGB(233, 1, 77)

		UIPadding_1.Parent = About_1
		UIPadding_1.PaddingLeft = UDim.new(0,6)

		local AddPage = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local SQ4_1 = Instance.new("Frame")
		local Page_1 = Instance.new("Frame")
		local Scrolling_1 = Instance.new("ScrollingFrame")
		local UIListLayout_1z = Instance.new("UIListLayout")
		local UIPadding_1 = Instance.new("UIPadding")
		local SQ5_1 = Instance.new("Frame")

		AddPage.Name = "AddPage"
		AddPage.Parent = PageFolder
		AddPage.AnchorPoint = Vector2.new(0.5, 0.5)
		AddPage.BackgroundColor3 = Color3.fromRGB(28,28,30)
		AddPage.BorderColor3 = Color3.fromRGB(0,0,0)
		AddPage.BorderSizePixel = 0
		AddPage.Position = UDim2.new(0.5, 0,0.5, 0)
		AddPage.Size = UDim2.new(1, 0,1, 0)
		AddPage.Visible = false

		UICorner_1.Parent = AddPage

		SQ4_1.Name = "SQ4"
		SQ4_1.Parent = AddPage
		SQ4_1.BackgroundColor3 = Color3.fromRGB(28,28,30)
		SQ4_1.BorderColor3 = Color3.fromRGB(0,0,0)
		SQ4_1.BorderSizePixel = 0
		SQ4_1.Size = UDim2.new(1, 0,0, 10)

		Page_1.Name = "Page"
		Page_1.Parent = AddPage
		Page_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Page_1.BackgroundTransparency = 1
		Page_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Page_1.BorderSizePixel = 0
		Page_1.Size = UDim2.new(1, 0,1, 0)
		Page_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Page_1.Position = UDim2.new(0.55, 0,0.5, 0)

		Scrolling_1.Name = "Scrolling"
		Scrolling_1.Parent = Page_1
		Scrolling_1.Active = true
		Scrolling_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Scrolling_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Scrolling_1.BackgroundTransparency = 1
		Scrolling_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Scrolling_1.BorderSizePixel = 0
		Scrolling_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Scrolling_1.Size = UDim2.new(1, 0,1, 0)
		Scrolling_1.ClipsDescendants = true
		Scrolling_1.AutomaticCanvasSize = Enum.AutomaticSize.None
		Scrolling_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		Scrolling_1.CanvasPosition = Vector2.new(0, 0)
		Scrolling_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		Scrolling_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		Scrolling_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		Scrolling_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
		Scrolling_1.ScrollBarImageTransparency = 1
		Scrolling_1.ScrollBarThickness = 0
		Scrolling_1.ScrollingDirection = Enum.ScrollingDirection.XY
		Scrolling_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		Scrolling_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
		Scrolling_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

		UIListLayout_1z.Parent = Scrolling_1
		UIListLayout_1z.Padding = UDim.new(0,10)
		UIListLayout_1z.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_1z.SortOrder = Enum.SortOrder.LayoutOrder

		UIListLayout_1z:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Scrolling_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_1z.AbsoluteContentSize.Y + 15)
		end)

		UIPadding_1.Parent = Scrolling_1
		UIPadding_1.PaddingBottom = UDim.new(0,10)
		UIPadding_1.PaddingLeft = UDim.new(0,10)
		UIPadding_1.PaddingRight = UDim.new(0,10)
		UIPadding_1.PaddingTop = UDim.new(0,10)

		SQ5_1.Name = "SQ5"
		SQ5_1.Parent = AddPage
		SQ5_1.AnchorPoint = Vector2.new(0, 1)
		SQ5_1.BackgroundColor3 = Color3.fromRGB(28,28,30)
		SQ5_1.BorderColor3 = Color3.fromRGB(0,0,0)
		SQ5_1.BorderSizePixel = 0
		SQ5_1.Position = UDim2.new(0, 0,1, 0)
		SQ5_1.Size = UDim2.new(0, 10,0, 10)

		local function OnSelectPage()
			for _, v in pairs(PageFolder:GetChildren()) do
				if v.Name == "AddPage" then
					v.Visible = false
					v.Page.Position = UDim2.new(0.55, 0,0.5, 0)
				end
			end

			for _, v in pairs(RF_Scrolling_1:GetChildren()) do
				if v.Name == "AddTab" then
					Library:Tween({
						v = v,
						t = 0.15,
						s = "Exponential",
						d = "Out",
						g = {BackgroundTransparency = 1}
					}):Play()
					Library:Tween({
						v = v.About.Title,
						t = 0.15,
						s = "Exponential",
						d = "Out",
						g = {TextTransparency = 0.3}
					}):Play()

					v.About.Icon.ImageColor3 = Color3.fromRGB(233, 1, 77)
				end
			end

			Library:Tween({
				v = AddTab,
				t = 0.15,
				s = "Exponential",
				d = "Out",
				g = {BackgroundTransparency = 0}
			}):Play()

			Library:Tween({
				v = Title_1,
				t = 0.15,
				s = "Exponential",
				d = "Out",
				g = {TextTransparency = 0}
			}):Play()

			AddPage.Visible = true

			Library:Tween({
				v = Page_1,
				t = 0.3,
				s = "Back",
				d = "Out",
				g = {Position = UDim2.new(0.5, 0,0.5, 0)}
			}):Play()

			Icon_1.ImageColor3 = Color3.fromRGB(255, 255, 255)
			Icon_1q.Image = Icon_1.Image
		end

		task.delay(0.1, function()
			if not Tab.Value then
				Tab.Value = true

				Library:Tween({
					v = AddTab,
					t = 0.15,
					s = "Exponential",
					d = "Out",
					g = {BackgroundTransparency = 0}
				}):Play()

				Library:Tween({
					v = Title_1,
					t = 0.15,
					s = "Exponential",
					d = "Out",
					g = {TextTransparency = 0}
				}):Play()

				AddPage.Visible = true

				Library:Tween({
					v = Page_1,
					t = 0.3,
					s = "Back",
					d = "Out",
					g = {Position = UDim2.new(0.5, 0,0.5, 0)}
				}):Play()

				Icon_1.ImageColor3 = Color3.fromRGB(255, 255, 255)
				Icon_1q.Image = Icon_1.Image
			end
		end)

		ClickTabs.MouseButton1Click:Connect(OnSelectPage)

		local Section = {}

		function Section.new()
			local Section = Instance.new("Frame")
			local UICorner_1 = Instance.new("UICorner")
			local UIStroke_1 = Instance.new("UIStroke")
			local UIListLayout_1s = Instance.new("UIListLayout")
			local UIPadding_1 = Instance.new("UIPadding")

			Section.Name = "Section"
			Section.Parent = Scrolling_1
			Section.BackgroundColor3 = Color3.fromRGB(31,31,33)
			Section.BorderColor3 = Color3.fromRGB(0,0,0)
			Section.BorderSizePixel = 0
			Section.LayoutOrder = 1
			Section.Position = UDim2.new(-0.356338024, 0,0, 0)
			Section.Size = UDim2.new(1, 0,0, 0)
			Section.AutomaticSize = Enum.AutomaticSize.Y

			UICorner_1.Parent = Section

			UIStroke_1.Parent = Section
			UIStroke_1.Color = Color3.fromRGB(61,61,61)
			UIStroke_1.Thickness = 1

			UIListLayout_1s.Parent = Section

			if Library.IsMobile then
				UIListLayout_1s.Padding = UDim.new(0,3)
			else
				UIListLayout_1s.Padding = UDim.new(0,7)
			end

			UIListLayout_1s.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout_1s.SortOrder = Enum.SortOrder.LayoutOrder

			UIPadding_1.Parent = Section
			UIPadding_1.PaddingBottom = UDim.new(0,10)
			UIPadding_1.PaddingTop = UDim.new(0,10)
			UIPadding_1.PaddingRight = UDim.new(0,12)
			UIPadding_1.PaddingLeft = UDim.new(0,12)

			local Element = {}

			function Element:Paragarp(params)
				local Title = params.Title or "Unknow"
				local Desc = params.Desc or nil
				local DisbleLine = params.DisbleLine or false

				local Rower = Library:Row(Section, Title, Desc, 1)

				local self = {}

				local Titles = Rower.Text.Title
				local Descs = Rower.Text.Desc

				function self:SetTitle(a)
					Titles.Text = a
				end

				function self:SetDesc(a)
					Descs.Text = a
				end

				if not DisbleLine then
					Element:Line()
				end

				return self
			end

			function Element:Line()
				local Line = Instance.new("Frame")

				Line.Name = "Line"
				Line.Parent = Section
				Line.BackgroundColor3 = Color3.fromRGB(61,61,61)
				Line.BorderColor3 = Color3.fromRGB(0,0,0)
				Line.BorderSizePixel = 0
				Line.Size = UDim2.new(1, 0,0, 1)

				return Line
			end

			function Element:Toggle(new)
				local Title = new.Title
				local Desc = new.Desc or nil
				local Raw = Library:Row(Section, Title, Desc)
				local Button = Library:Button(Raw)
				local Line = (not new.DisbleLine and self:Line()) or nil
				local Value = new.Value or false
				local Callback = new.Call or function() return end

				local Vanity = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local Circle_1 = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")

				Vanity.Name = "Vanity"
				Vanity.Parent = Raw
				Vanity.AnchorPoint = Vector2.new(1, 0.5)
				Vanity.BackgroundColor3 = Color3.fromRGB(67,67,69)
				Vanity.BorderColor3 = Color3.fromRGB(0,0,0)
				Vanity.BorderSizePixel = 0
				Vanity.Position = UDim2.new(1, 0,0.5, 0)
				Vanity.Size = UDim2.new(0, 35,0, 21)

				UICorner_1.Parent = Vanity
				UICorner_1.CornerRadius = UDim.new(1,0)

				Circle_1.Name = "Circle"
				Circle_1.Parent = Vanity
				Circle_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Circle_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Circle_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Circle_1.BorderSizePixel = 0
				Circle_1.Position = UDim2.new(0, 0,0.5, 0)
				Circle_1.Size = UDim2.new(0, 15,0, 15)

				UICorner_2.Parent = Circle_1
				UICorner_2.CornerRadius = UDim.new(1,0)

				local function OnChanged(value)
					if not value then 
						Callback(Value)
						Library:Tween({
							v = Circle_1,
							t = 0.1,
							s = "Exponential",
							d = "Out",
							g = {Size = UDim2.new(0, 15,0, 8)}
						}):Play()
						Vanity.BackgroundColor3 = Color3.fromRGB(67,67,69)
						Library:Tween({
							v = Circle_1,
							t = 0.25,
							s = "Back",
							d = "Out",
							g = {Position = UDim2.new(0.3, 0,0.5, 0)}
						}):Play()
						delay(0.05, function()
							Library:Tween({
								v = Circle_1,
								t = 0.1,
								s = "Bounce",
								d = "Out",
								g = {Size = UDim2.new(0, 15,0, 15)}
							}):Play()
						end)
					elseif value then 
						Callback(Value)
						Library:Tween({
							v = Circle_1,
							t = 0.1,
							s = "Exponential",
							d = "Out",
							g = {Size = UDim2.new(0, 15,0, 8)}
						}):Play()
						Library:Tween({
							v = Circle_1,
							t = 0.1,
							s = "Linear",
							d = "Out",
							g = {Position = UDim2.new(0.7, 0,0.5, 0)}
						}):Play()
						delay(0.05, function()
							Library:Tween({
								v = Circle_1,
								t = 0.1,
								s = "Bounce",
								d = "Out",
								g = {Size = UDim2.new(0, 15,0, 15)}
							}):Play()
						end)

						Vanity.BackgroundColor3 = Color3.fromRGB(233, 1, 77)
					end
				end

				local function Init()
					Value = not Value
					OnChanged(Value)
				end

				Button.MouseButton1Click:Connect(Init)

				OnChanged(Value)

				local Constant = {}

				function Constant:ChangeValue(value)
					Value = value
					OnChanged(value)
				end

				return Constant
			end

			function Element:Button(new)
				local Title = new.Title
				local Desc = new.Desc or nil
				local Label = new.Label or 'Click!'
				local Raw = Library:Row(Section, Title, Desc)
				local Line = (not new.DisbleLine and self:Line()) or nil
				local Callback = new.Call or function() return end

				local Clickable = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIGradient_1 = Instance.new("UIGradient")
				local Title_1 = Instance.new("TextLabel")
				local Button = Library:Button(Clickable)

				Clickable.Name = "Clickable"
				Clickable.Parent = Raw
				Clickable.AnchorPoint = Vector2.new(1, 0.5)
				Clickable.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Clickable.BorderColor3 = Color3.fromRGB(0,0,0)
				Clickable.BorderSizePixel = 0
				Clickable.Position = UDim2.new(1, 0,0.5, 0)
				Clickable.Size = UDim2.new(0, 52,0, 15)

				UICorner_1.Parent = Clickable
				UICorner_1.CornerRadius = UDim.new(0,4)

				UIGradient_1.Parent = Clickable
				UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(116, 0, 39)), ColorSequenceKeypoint.new(1, Color3.fromRGB(233, 1, 77))}
				UIGradient_1.Rotation = 90

				Title_1.Name = "Title"
				Title_1.Parent = Clickable
				Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Title_1.BackgroundTransparency = 1
				Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Title_1.BorderSizePixel = 0
				Title_1.Position = UDim2.new(0.5, 0,0.449999988, 0)
				Title_1.Size = UDim2.new(0, 20,0, 14)
				Title_1.Font = Enum.Font.GothamSemibold
				Title_1.Text = Label
				Title_1.TextColor3 = Color3.fromRGB(255,255,255)
				Title_1.TextSize = 10

				Clickable.Size = UDim2.new(0, Title_1.TextBounds.X + 20, 0, 15)

				Button.MouseButton1Click:Connect(function()
					Callback()
					Library:Effect(Button, Clickable)
				end)
			end

			function Element:Textfield(new)
				local Title = new.Title
				local Desc = new.Desc or nil
				local Holder = new.Holder or ' ... '
				local Value = new.Value or ""
				local Raw = Library:Row(Section, Title, Desc, 0.65)
				local Line = (not new.DisbleLine and self:Line()) or nil
				local Callback = new.Call or function() return end

				local Box = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIStroke_1 = Instance.new("UIStroke")
				local TextBox_1 = Instance.new("TextBox")

				Box.Name = "Box"
				Box.Parent = Raw
				Box.AnchorPoint = Vector2.new(1, 0.5)
				Box.BackgroundColor3 = Color3.fromRGB(50,50,50)
				Box.BorderColor3 = Color3.fromRGB(0,0,0)
				Box.BorderSizePixel = 0
				Box.Position = UDim2.new(1, 0,0.5, 0)
				Box.Size = UDim2.new(0, 100,0, 18)

				UICorner_1.Parent = Box
				UICorner_1.CornerRadius = UDim.new(0,4)

				UIStroke_1.Parent = Box
				UIStroke_1.Color = Color3.fromRGB(75,75,75)
				UIStroke_1.Thickness = 1

				TextBox_1.Parent = Box
				TextBox_1.Active = true
				TextBox_1.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.BackgroundTransparency = 1
				TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextBox_1.BorderSizePixel = 0
				TextBox_1.CursorPosition = -1
				TextBox_1.Position = UDim2.new(0.5, 0,0.5, 0)
				TextBox_1.Size = UDim2.new(0.899999976, 0,1, 0)
				TextBox_1.Font = Enum.Font.GothamMedium
				TextBox_1.PlaceholderText = Holder
				TextBox_1.Text = Value
				TextBox_1.TextColor3 = Color3.fromRGB(178,178,178)
				TextBox_1.TextSize = 11
				TextBox_1.TextTruncate = Enum.TextTruncate.AtEnd

				TextBox_1.Focused:Connect(function()
					TextBox_1.TextColor3 = Color3.new(1, 1, 1)
					SearchBox_1.TextTruncate = Enum.TextTruncate.None
				end)

				TextBox_1.FocusLost:Connect(function()
					Value = TextBox_1.Text
					Callback(Value)
					TextBox_1.TextColor3 = Color3.fromRGB(178,178,178)
					SearchBox_1.TextTruncate = Enum.TextTruncate.AtEnd
				end)
			end

			function Element:Slider(new)
				local Title = new.Title
				local Desc = new.Desc or nil
				local Value = new.Value or ""
				local Min = new.Min or 1
				local Max = new.Max or 10
				local Rounding = new.Rounding or 0
				local Raw = Library:Row(Section, Title, Desc, 0.475)
				local Line = (not new.DisbleLine and self:Line()) or nil
				local Callback = new.Call or function() return end

				local Side = Instance.new("Frame")
				local Changed_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIStroke_1 = Instance.new("UIStroke")
				local TextBox_1 = Instance.new("TextBox")
				local SliderFrame_1 = Instance.new("Frame")
				local Slider_1 = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local Color_1 = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local Circle_1 = Instance.new("Frame")
				local UICorner_4 = Instance.new("UICorner")
				local UIPadding_1 = Instance.new("UIPadding")
				local Slide = Library:Button(Side)

				Side.Name = "Side"
				Side.Parent = Raw
				Side.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Side.BackgroundTransparency = 1
				Side.BorderColor3 = Color3.fromRGB(0,0,0)
				Side.BorderSizePixel = 0
				Side.Size = UDim2.new(1, 0,1, 0)

				Changed_1.Name = "Changed"
				Changed_1.Parent = Side
				Changed_1.AnchorPoint = Vector2.new(1, 0.5)
				Changed_1.BackgroundColor3 = Color3.fromRGB(50,50,50)
				Changed_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Changed_1.BorderSizePixel = 0
				Changed_1.Position = UDim2.new(1, 0,0.5, 0)
				Changed_1.Size = UDim2.new(0, 35,0, 20)

				UICorner_1.Parent = Changed_1
				UICorner_1.CornerRadius = UDim.new(0,4)

				UIStroke_1.Parent = Changed_1
				UIStroke_1.Color = Color3.fromRGB(75,75,75)
				UIStroke_1.Thickness = 1

				TextBox_1.Parent = Changed_1
				TextBox_1.Active = true
				TextBox_1.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.BackgroundTransparency = 1
				TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextBox_1.BorderSizePixel = 0
				TextBox_1.Position = UDim2.new(0.5, 0,0.449999988, 0)
				TextBox_1.Size = UDim2.new(0.9, 0,1, 0)
				TextBox_1.Font = Enum.Font.GothamMedium
				TextBox_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextBox_1.PlaceholderText = "Value"
				TextBox_1.Text = "10"
				TextBox_1.TextColor3 = Color3.fromRGB(178,178,178)
				TextBox_1.TextSize = 10
				TextBox_1.TextTruncate = Enum.TextTruncate.AtEnd
				TextBox_1.ZIndex = Slide.ZIndex + 1

				SliderFrame_1.Name = "SliderFrame"
				SliderFrame_1.Parent = Side
				SliderFrame_1.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				SliderFrame_1.BackgroundTransparency = 1
				SliderFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
				SliderFrame_1.BorderSizePixel = 0
				SliderFrame_1.Position = UDim2.new(0.5, 0,0.5, 0)
				SliderFrame_1.Size = UDim2.new(1, 0,1, 0)

				Slider_1.Name = "Slider"
				Slider_1.Parent = SliderFrame_1
				Slider_1.AnchorPoint = Vector2.new(1, 0.5)
				Slider_1.BackgroundColor3 = Color3.fromRGB(54,54,54)
				Slider_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Slider_1.BorderSizePixel = 0
				Slider_1.Position = UDim2.new(1, 0,0.5, 0)
				Slider_1.Size = UDim2.new(0, 120,0, 5)

				UICorner_2.Parent = Slider_1
				UICorner_2.CornerRadius = UDim.new(1,0)

				Color_1.Name = "Color"
				Color_1.Parent = Slider_1
				Color_1.AnchorPoint = Vector2.new(0, 0.5)
				Color_1.BackgroundColor3 = Color3.fromRGB(233,1,77)
				Color_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Color_1.BorderSizePixel = 0
				Color_1.Position = UDim2.new(0, 0,0.5, 0)
				Color_1.Size = UDim2.new(0.0909090936, 0,1, 0)

				UICorner_3.Parent = Color_1
				UICorner_3.CornerRadius = UDim.new(1,0)

				Circle_1.Name = "Circle"
				Circle_1.Parent = Color_1
				Circle_1.AnchorPoint = Vector2.new(1, 0.5)
				Circle_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Circle_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Circle_1.BorderSizePixel = 0
				Circle_1.Position = UDim2.new(1, 0,0.5, 0)
				Circle_1.Size = UDim2.new(0, 15,0, 15)

				UICorner_4.Parent = Circle_1
				UICorner_4.CornerRadius = UDim.new(1,0)

				UIPadding_1.Parent = SliderFrame_1
				UIPadding_1.PaddingRight = UDim.new(0,45)

				local function roundToDecimal(value, decimals)
					local factor = 10 ^ decimals
					return math.floor(value * factor + 0.5) / factor
				end

				local function updateSlider(value)
					value = math.clamp(value, Min, Max)
					value = roundToDecimal(value, Rounding)
					Library:Tween({
						v = Color_1,
						t = 0.15,
						s = "Exponential",
						d = "Out",
						g = {Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)}
					}):Play()
					local startValue = tonumber(TextBox_1.Text) or 0
					local targetValue = value

					local steps = 5
					local currentValue = startValue
					for i = 1, steps do
						task.wait(0.01 / steps)
						currentValue = currentValue + (targetValue - startValue) / steps
						TextBox_1.Text = tostring(roundToDecimal(currentValue, Rounding))
					end

					TextBox_1.Text = tostring(roundToDecimal(targetValue, Rounding))

					Callback(value)
				end

				updateSlider(Value or 0)

				local function move(input)
					local sliderBar = Slider_1
					local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
					local value = relativeX * (Max - Min) + Min
					updateSlider(value)
				end

				TextBox_1.FocusLost:Connect(function()
					local value = tonumber(TextBox_1.Text) or Min
					updateSlider(value)
				end)

				local dragging = false

				Slide.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						move(input)
					end
				end)

				Slide.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						move(input)
					end
				end)
			end

			function Element:List(new)
				local Title = new.Title or "Dropdown"
				local List = new.List or {}
				local Value = new.Value or "N/A"
				local Multi = (typeof(Value) == "table" and true)
				local Raw = Library:Row(Section, Title, "N/A", 0.9)
				local Line = (not new.DisbleLine and self:Line()) or nil
				local Call = new.Call or function() return end

				local Desc_1 = Raw.Text.Desc

				local function ChangeText()
					if typeof(Value) == 'table' then
						Desc_1.Text = table.concat(Value, ", ")
					else
						Desc_1.Text = Value
					end
				end

				ChangeText()

				local asset = Instance.new("ImageLabel")
				asset.Name = "asset"
				asset.Parent = Raw
				asset.AnchorPoint = Vector2.new(1, 0.5)
				asset.BackgroundColor3 = Color3.fromRGB(255,255,255)
				asset.BackgroundTransparency = 1
				asset.BorderColor3 = Color3.fromRGB(0,0,0)
				asset.BorderSizePixel = 0
				asset.Position = UDim2.new(1, 0,0.5, 0)
				asset.Size = UDim2.new(0, 20,0, 20)
				asset.Image = "rbxassetid://100756722171557"

				local Buttons = Library:Button(Raw)

				local Dropdown = Instance.new("Frame")
				local UIStroke_1 = Instance.new("UIStroke")
				local ScrollingFrame_1 = Instance.new("ScrollingFrame")
				local UIListLayout_1 = Instance.new("UIListLayout")
				local UIPadding_1 = Instance.new("UIPadding")
				local DropShadow_1 = Instance.new("ImageLabel")
				local UICorner_1 = Instance.new("UICorner")
				local Search_1 = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local UIListLayout_2 = Instance.new("UIListLayout")
				local UIPadding_2 = Instance.new("UIPadding")
				local UIStroke_2 = Instance.new("UIStroke")
				local SearchBox_1 = Instance.new("TextBox")
				local asset_1 = Instance.new("ImageLabel")

				SearchBox_1.Focused:Connect(function()
					SearchBox_1.TextTruncate = Enum.TextTruncate.None
				end)

				SearchBox_1.FocusLost:Connect(function()
					SearchBox_1.TextTruncate = Enum.TextTruncate.AtEnd
				end)

				Dropdown.Name = "Dropdown"
				Dropdown.Parent = Main_1
				Dropdown.AnchorPoint = Vector2.new(0.5, 0.5)
				Dropdown.BackgroundColor3 = Color3.fromRGB(54,54,54)
				Dropdown.BorderColor3 = Color3.fromRGB(0,0,0)
				Dropdown.BorderSizePixel = 0
				Dropdown.Position = UDim2.new(0.5, 0,0.35, 0)
				Dropdown.Size = UDim2.new(0, 275,0, 275)
				Dropdown.ZIndex = 20
				Dropdown.Visible = false
				UIStroke_1.Parent = Dropdown
				UIStroke_1.Color = Color3.fromRGB(100,100,100)
				UIStroke_1.Thickness = 1

				ScrollingFrame_1.Name = "ScrollingFrame"
				ScrollingFrame_1.Parent = Dropdown
				ScrollingFrame_1.Active = true
				ScrollingFrame_1.AnchorPoint = Vector2.new(0.5, 0.5)
				ScrollingFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ScrollingFrame_1.BackgroundTransparency = 1
				ScrollingFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
				ScrollingFrame_1.BorderSizePixel = 0
				ScrollingFrame_1.Position = UDim2.new(0.5, 0,0.441818178, 0)
				ScrollingFrame_1.Size = UDim2.new(1, 0,0.883636355, 0)
				ScrollingFrame_1.ClipsDescendants = true
				ScrollingFrame_1.AutomaticCanvasSize = Enum.AutomaticSize.None
				ScrollingFrame_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
				ScrollingFrame_1.CanvasPosition = Vector2.new(0, 0)
				ScrollingFrame_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
				ScrollingFrame_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
				ScrollingFrame_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				ScrollingFrame_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
				ScrollingFrame_1.ScrollBarImageTransparency = 1
				ScrollingFrame_1.ScrollBarThickness = 0
				ScrollingFrame_1.ScrollingDirection = Enum.ScrollingDirection.XY
				ScrollingFrame_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
				ScrollingFrame_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
				ScrollingFrame_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

				UIListLayout_1.Parent = ScrollingFrame_1
				UIListLayout_1.Padding = UDim.new(0,3)
				UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

				UIPadding_1.Parent = ScrollingFrame_1
				UIPadding_1.PaddingTop = UDim.new(0,10)

				DropShadow_1.Name = "DropShadow"
				DropShadow_1.Parent = Dropdown
				DropShadow_1.AnchorPoint = Vector2.new(0.5, 0.5)
				DropShadow_1.BackgroundColor3 = Color3.fromRGB(28,28,30)
				DropShadow_1.BackgroundTransparency = 1
				DropShadow_1.BorderColor3 = Color3.fromRGB(0,0,0)
				DropShadow_1.BorderSizePixel = 0
				DropShadow_1.Position = UDim2.new(0.5, 0,0.5, 0)
				DropShadow_1.Size = UDim2.new(1, 100,1, 100)
				DropShadow_1.Image = "rbxassetid://8992230677"
				DropShadow_1.ImageColor3 = Color3.fromRGB(103,103,103)
				DropShadow_1.ImageTransparency = 0.4000000059604645
				DropShadow_1.ScaleType = Enum.ScaleType.Slice
				DropShadow_1.SliceCenter = Rect.new(99, 99, 99, 99)

				UICorner_1.Parent = Dropdown

				Search_1.Name = "Search"
				Search_1.Parent = Dropdown
				Search_1.BackgroundColor3 = Color3.fromRGB(33,33,33)
				Search_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Search_1.BorderSizePixel = 0
				Search_1.Position = UDim2.new(0.0218181815, 0,0.894545436, 0)
				Search_1.Size = UDim2.new(0, 263,0, 24)
				Search_1.ZIndex = 20

				UICorner_2.Parent = Search_1
				UICorner_2.CornerRadius = UDim.new(0,5)

				UIListLayout_2.Parent = Search_1
				UIListLayout_2.Padding = UDim.new(0,5)
				UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

				UIPadding_2.Parent = Search_1
				UIPadding_2.PaddingLeft = UDim.new(0,5)

				UIStroke_2.Parent = Search_1
				UIStroke_2.Color = Color3.fromRGB(110,110,110)
				UIStroke_2.Thickness = 1

				SearchBox_1.Name = "SearchBox"
				SearchBox_1.Parent = Search_1
				SearchBox_1.Active = true
				SearchBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				SearchBox_1.BackgroundTransparency = 1
				SearchBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
				SearchBox_1.BorderSizePixel = 0
				SearchBox_1.Position = UDim2.new(0.157894731, 0,0.100000001, 0)
				SearchBox_1.Size = UDim2.new(0, 230,0, 20)
				SearchBox_1.ZIndex = 20
				SearchBox_1.Font = Enum.Font.GothamMedium
				SearchBox_1.PlaceholderText = "Search ..."
				SearchBox_1.Text = ""
				SearchBox_1.TextColor3 = Color3.fromRGB(178,178,178)
				SearchBox_1.TextSize = 12
				SearchBox_1.TextXAlignment = Enum.TextXAlignment.Left

				asset_1.Name = "asset"
				asset_1.Parent = Search_1
				asset_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				asset_1.BackgroundTransparency = 1
				asset_1.BorderColor3 = Color3.fromRGB(0,0,0)
				asset_1.BorderSizePixel = 0
				asset_1.LayoutOrder = -1
				asset_1.Size = UDim2.new(0, 15,0, 15)
				asset_1.ZIndex = 20
				asset_1.Image = "rbxassetid://125928820284709"

				local isOpen = false

				UserInputService.InputBegan:Connect(function(A)
					local mouse = game:GetService("Players").LocalPlayer:GetMouse()
					local mx, my = mouse.X, mouse.Y
					local DBP, DBS = Dropdown.AbsolutePosition, Dropdown.AbsoluteSize

					local function inside(pos, size)
						return mx >= pos.X and mx <= pos.X + size.X and my >= pos.Y and my <= pos.Y + size.Y
					end

					if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
						if not inside(DBP, DBS) then
							isOpen = false
							Dropdown.Visible = false
							Dropdown.Position = UDim2.new(0.5, 0,0.35, 0)
						end
					end

					if A.UserInputType == Enum.UserInputType.MouseWheel then
						if not inside(DBP, DBS) then
							isOpen = false
							Dropdown.Visible = false
							Dropdown.Position = UDim2.new(0.5, 0,0.35, 0)
						end
					end
				end)

				local function OnDropdownChanged()
					for _, v in pairs(Main_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end

					isOpen = not isOpen

					if isOpen then
						Library:Tween({
							v = Dropdown,
							t = 0.3,
							s = "Back",
							d = "Out",
							g = {Position = UDim2.new(0.5, 0,0.5, 0)}
						}):Play()
						Dropdown.Visible = true
					else
						Dropdown.Visible = false
						Dropdown.Position = UDim2.new(0.5, 0,0.35, 0)
					end
				end

				SearchBox_1.Changed:Connect(function()
					local SearchT = string.lower(SearchBox_1.Text)
					for i, v in pairs(ScrollingFrame_1:GetChildren()) do
						if v:IsA("Frame") then
							local labelText = string.lower(v.Title.Text)
							if string.find(labelText, SearchT, 1, true) then
								v.Visible = true
							else
								v.Visible = false
							end
						end
					end
				end)

				Buttons.MouseButton1Click:Connect(OnDropdownChanged)

				local itemslist = {}

				local selectedItem

				function itemslist:Clear(a)
					local function shouldClear(v)
						if a == nil then
							return true
						elseif type(a) == "string" then
							return v.Title.Text == a
						elseif type(a) == "table" then
							for _, name in ipairs(a) do
								if v.Title.Text == name then
									return true
								end
							end
						end
						return false
					end

					for _, v in ipairs(ScrollingFrame_1:GetChildren()) do
						if v:IsA("Frame") and shouldClear(v) then
							if selectedItem and v.Title.Text == selectedItem then
								selectedItem = nil
								Desc_1.Text = "N/A"
							end
							v:Destroy()
						end
					end

					if selectedItem == a or Desc_1.Text == a then
						selectedItem = nil
						Desc_1.Text = "N/A"
					end

					if a == nil then
						selectedItem = nil
						Desc_1.Text = "N/A"
					end
				end

				local selectedValues = {}

				local function isValueInTable(val, tbl)
					if type(tbl) ~= "table" then
						return false
					end

					for _, v in pairs(tbl) do
						if v == val then
							return true
						end
					end
					return false
				end

				function itemslist:AddList(i)

					local AddList = Instance.new("Frame")
					local Title_1 = Instance.new("TextLabel")
					local UICorner_1 = Instance.new("UICorner")
					local ClickList = Library:Button(AddList)

					AddList.Name = "AddList"
					AddList.Parent = ScrollingFrame_1
					AddList.BackgroundColor3 = Color3.fromRGB(38,38,38)
					AddList.BorderColor3 = Color3.fromRGB(0,0,0)
					AddList.BorderSizePixel = 0
					AddList.Position = UDim2.new(0.0309090912, 0,0, 0)
					AddList.Size = UDim2.new(0, 260,0, 25)
					AddList.ZIndex = 20

					Title_1.Name = "Title"
					Title_1.Parent = AddList
					Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
					Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Title_1.BackgroundTransparency = 1
					Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Title_1.BorderSizePixel = 0
					Title_1.Position = UDim2.new(0.5, 0,0.474999994, 0)
					Title_1.Size = UDim2.new(0.899999976, 0,1, 0)
					Title_1.ZIndex = 20
					Title_1.Font = Enum.Font.GothamBold
					Title_1.Text = i
					Title_1.TextColor3 = Color3.fromRGB(255,255,255)
					Title_1.TextSize = 12
					Title_1.TextTransparency = 0.35
					Title_1.TextXAlignment = Enum.TextXAlignment.Left

					UICorner_1.Parent = AddList
					UICorner_1.CornerRadius = UDim.new(0,5)

					local function Changed(v)
						if v then
							Library:Tween({
								v = Title_1,
								t = 0.15,
								s = "Exponential",
								d = "Out",
								g = {TextTransparency = 0}
							}):Play()
							AddList.BackgroundColor3 = Color3.fromRGB(233, 1, 77)
						else
							Library:Tween({
								v = Title_1,
								t = 0.15,
								s = "Exponential",
								d = "Out",
								g = {TextTransparency = 0.35}
							}):Play()
							AddList.BackgroundColor3 = Color3.fromRGB(38,38,38)
						end
					end

					local function OnSelected()
						if Multi then
							if selectedValues[i] then
								selectedValues[i] = nil
								Changed(false)
							else
								selectedValues[i] = true
								Changed(true)
							end

							local selectedList = {}

							for i, v in pairs(selectedValues) do
								table.insert(selectedList, i)
							end

							if #selectedList > 0 then
								table.sort(selectedList)
								Value = selectedList
								ChangeText()
							else
								Desc_1.Text = "N/A"
							end

							pcall(Call, selectedList)
						else
							for i,v in pairs(ScrollingFrame_1:GetChildren()) do
								if v:IsA("Frame") then
									Library:Tween({
										v = v.Title,
										t = 0.15,
										s = "Exponential",
										d = "Out",
										g = {TextTransparency = 0.35}
									}):Play()

									v.BackgroundColor3 = Color3.fromRGB(38,38,38)
								end
							end

							Changed(true)
							Dropdown.Visible = false
							Dropdown.Position = UDim2.new(0.5, 0,0.35, 0)
							isOpen = false
							Value = i
							ChangeText()
							pcall(Call, Value)
						end
					end

					delay(0,function()
						if Multi then
							if isValueInTable(i, Value) then
								selectedValues[i] = true

								Changed(true)

								local selectedList = {}

								for i, v in pairs(selectedValues) do
									table.insert(selectedList, i)
								end

								if #selectedList > 0 then
									ChangeText()
								else
									Desc_1.Text = "N/A"
								end

								pcall(Call, selectedList)
							end
						else
							if i == Value then
								Value = i
								Changed(true)
								ChangeText()
								pcall(Call, Value)
							end
						end
					end)

					ClickList.MouseButton1Click:Connect(OnSelected)
				end

				for _, name in ipairs(List) do
					itemslist:AddList(name)
				end

				UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					ScrollingFrame_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 15)
				end)

				return itemslist
			end

			function Element:Enum(options)
				local Title      = options.Title or "Unknown"
				local Desc       = options.Desc
				local Key        = options.Key or Enum.KeyCode.Q
				local Value      = options.Value or false
				local Callback   = options.Call or function() end
				local DisableLine= options.DisableLine or false

				local Raw = Library:Row(Section, Title, Desc)
				local Line = (not DisableLine) and self:Line() or nil

				local Side = Instance.new("Frame")
				local Changed = Instance.new("Frame")
				local Corner = Instance.new("UICorner")
				local Stroke = Instance.new("UIStroke")
				local Label = Instance.new("TextLabel")
				local Button = Library:Button(Changed)

				Side.Name = "Side"
				Side.Parent = Raw
				Side.BackgroundTransparency = 1
				Side.Size = UDim2.fromScale(1, 1)

				Changed.Name = "Changed"
				Changed.Parent = Side
				Changed.AnchorPoint = Vector2.new(1, 0.5)
				Changed.Position = UDim2.new(1, 0, 0.5, 0)
				Changed.Size = UDim2.new(0, 25, 0, 20)
				Changed.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

				Corner.CornerRadius = UDim.new(0, 4)
				Corner.Parent = Changed

				Stroke.Thickness = 1
				Stroke.Color = Color3.fromRGB(75, 75, 75)
				Stroke.Parent = Changed

				Label.Name = "Enum"
				Label.Parent = Changed
				Label.AnchorPoint = Vector2.new(0.5, 0.5)
				Label.Position = UDim2.fromScale(0.5, 0.5)
				Label.Size = UDim2.fromScale(0.8, 0.8)
				Label.BackgroundTransparency = 1
				Label.Font = Enum.Font.GothamSemibold
				Label.Text = tostring(Key):gsub("Enum.KeyCode.", "")
				Label.TextColor3 = Color3.fromRGB(255, 255, 255)
				Label.TextSize = 12
				Label.TextTransparency = 0.5

				local function resizeBox()
					Changed.Size = UDim2.new(0, math.max(Label.TextBounds.X + 10, 25), 0, 20)
				end

				resizeBox()

				local function changeKey()
					Label.Text = "..."
					resizeBox()

					local connection
					connection = UserInputService.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.Keyboard then
							Key = input.KeyCode
							Label.Text = tostring(Key):gsub("Enum.KeyCode.", "")
							resizeBox()
							connection:Disconnect()
							Callback(Key, Value)
						end
					end)
				end

				UserInputService.InputEnded:Connect(function(input)
					if input.KeyCode == Key then
						Value = not Value
						Callback(Key, Value)
					end
				end)

				task.defer(function()
					Callback(Key, Value)
				end)

				Button.MouseButton1Click:Connect(changeKey)
			end

			return Element
		end

		function Section:PageTitle(params)
			local Title = params.Title or "Unknow"
			local Desc = params.Desc or nil

			local PageTitle = Instance.new("Frame")
			local UIListLayout_1z = Instance.new("UIListLayout")
			local Title_1 = Instance.new("TextLabel")

			PageTitle.Name = "PageTitle"
			PageTitle.Parent = Scrolling_1
			PageTitle.AutomaticSize = Enum.AutomaticSize.Y
			PageTitle.BackgroundColor3 = Color3.fromRGB(255,255,255)
			PageTitle.BackgroundTransparency = 1
			PageTitle.BorderColor3 = Color3.fromRGB(0,0,0)
			PageTitle.BorderSizePixel = 0
			PageTitle.LayoutOrder = 1
			PageTitle.Size = UDim2.new(1, 0,0, 25)

			UIListLayout_1z.Parent = PageTitle
			UIListLayout_1z.SortOrder = Enum.SortOrder.LayoutOrder

			Title_1:GetPropertyChangedSignal('TextBounds'):Connect(function()
				Title_1.Size = UDim2.new(1, 0,0, Title_1.TextBounds.Y)
			end)

			Title_1.Name = "Title"
			Title_1.Parent = PageTitle
			Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Title_1.BackgroundTransparency = 1
			Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Title_1.BorderSizePixel = 0
			Title_1.Size = UDim2.new(1, 0,0, 10)
			Title_1.Font = Enum.Font.GothamSemibold
			Title_1.Text = Title
			Title_1.TextColor3 = Color3.fromRGB(255,255,255)
			Title_1.TextSize = 14
			Title_1.TextStrokeColor3 = Color3.fromRGB(255,255,255)
			Title_1.TextXAlignment = Enum.TextXAlignment.Left
			Title_1.TextWrapped = true
			Title_1.RichText = true

			local Desc_1 = Desc and Instance.new("TextLabel") or nil do
				if Desc then
					Desc_1:GetPropertyChangedSignal('TextBounds'):Connect(function()
						Desc_1.Size = UDim2.new(1, 0,0, Desc_1.TextBounds.Y)
					end)

					Desc_1.Name = "Desc"
					Desc_1.Parent = PageTitle
					Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Desc_1.BackgroundTransparency = 1
					Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Desc_1.BorderSizePixel = 0
					Desc_1.Position = UDim2.new(0, 0,0.439999998, 0)
					Desc_1.Size = UDim2.new(1, 0,0, 10)
					Desc_1.Font = Enum.Font.GothamMedium
					Desc_1.Text = Desc
					Desc_1.TextColor3 = Color3.fromRGB(255,255,255)
					Desc_1.TextSize = 11
					Desc_1.TextTransparency = 0.5
					Desc_1.TextXAlignment = Enum.TextXAlignment.Left
					Desc_1.TextWrapped = true
					Desc_1.RichText = true
				end
			end
		end

		return Section
	end

	function Tab:SetEnum(a)
		Keybind = a
	end

	return Tab
end

return Library
