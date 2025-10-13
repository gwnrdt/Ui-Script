
local Library = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = not RunService:IsStudio() and game:GetService("CoreGui")

local Signal = {} do
	Signal.__index = Signal

	function Signal.new()
		return setmetatable({
			Connections = {}
		}, Signal)
	end

	function Signal:Connect(func)
		table.insert(self.Connections, func)
	end

	function Signal:Fire(...)
		for _, func in ipairs(self.Connections) do
			task.spawn(func, ...)
		end
	end
end

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

function Library:Tween(info)
	return TweenService:Create(info.v, TweenInfo.new(info.t, Enum.EasingStyle[info.s], Enum.EasingDirection[info.d]), info.g)
end

function Library:Button(p)
	local Click = Instance.new("TextButton")

	Click.Name = "Click"
	Click.Parent = p
	Click.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Click.BackgroundTransparency = 1
	Click.BorderSizePixel = 0
	Click.Size = UDim2.new(1, 0, 1, 0)
	Click.Font = Enum.Font.SourceSans
	Click.Text = ""
	Click.TextColor3 = Color3.fromRGB(0, 0, 0)
	Click.TextSize = 14
	Click.ZIndex = (p.ZIndex or 1) + 3

	Click.Active = true

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

function Library:Row(Parent, Title, Desc, Size, Icon, IconSize)
	local Rows = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local UIStroke_1 = Instance.new("UIStroke")
	local PaddingFrame_1 = Instance.new("Frame")
	local UIPadding_1 = Instance.new("UIPadding")
	local Text_1 = Instance.new("Frame")
	local Title_1 = Instance.new("TextLabel")
	local UIListLayout_1 = Instance.new("UIListLayout")

	local Sizes = Size or 0.8

	Rows.Name = "Rows"
	Rows.Parent = Parent
	Rows.BackgroundColor3 = Color3.fromRGB(37,37,38)
	Rows.BorderColor3 = Color3.fromRGB(0,0,0)
	Rows.BorderSizePixel = 0
	Rows.Size = UDim2.new(1, 0,0, 50)

	UICorner_1.Parent = Rows
	UICorner_1.CornerRadius = UDim.new(0,5)

	UIStroke_1.Parent = Rows
	UIStroke_1.Color = Color3.fromRGB(55,56,58)
	UIStroke_1.Thickness = 0.75

	PaddingFrame_1.Name = "PaddingFrame"
	PaddingFrame_1.Parent = Rows
	PaddingFrame_1.AnchorPoint = Vector2.new(0.5, 0.5)
	PaddingFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	PaddingFrame_1.BackgroundTransparency = 1
	PaddingFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
	PaddingFrame_1.BorderSizePixel = 0
	PaddingFrame_1.Position = UDim2.new(0.5, 0,0.5, 0)
	PaddingFrame_1.Size = UDim2.new(1, 0,1, 0)

	local PaddingOffset = Icon and 50 or 12

	UIPadding_1.Parent = PaddingFrame_1
	UIPadding_1.PaddingBottom = UDim.new(0,10)
	UIPadding_1.PaddingLeft = UDim.new(0,PaddingOffset)
	UIPadding_1.PaddingRight = UDim.new(0,12)
	UIPadding_1.PaddingTop = UDim.new(0,10)

	Text_1.Name = "Text"
	Text_1.Parent = PaddingFrame_1
	Text_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Text_1.BackgroundTransparency = 1
	Text_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Text_1.BorderSizePixel = 0
	Text_1.Size = UDim2.new(1, 0,1, 0)

	Title_1.Changed:Connect(function()
		if Desc and not Icon then
			Title_1.Size = UDim2.new(Sizes, 0,0, Title_1.TextBounds.Y)
			return
		end

		if Icon and not Desc then
			Title_1.Size = UDim2.new(Sizes, 0,0, Title_1.TextBounds.Y + 10)
			return
		end

		if not Desc and not Icon then
			Title_1.Size = UDim2.new(Sizes, 0,0, Title_1.TextBounds.Y)
		end
	end)

	Title_1.Name = "Title"
	Title_1.Parent = Text_1
	Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_1.BackgroundTransparency = 1
	Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_1.BorderSizePixel = 0
	Title_1.LayoutOrder = -1
	Title_1.Size = UDim2.new(1, 0,0, 14)
	Title_1.Font = Enum.Font.GothamMedium
	Title_1.RichText = true
	Title_1.Text = Title
	Title_1.TextColor3 = Color3.fromRGB(255,255,255)
	Title_1.TextSize = 14
	Title_1.TextXAlignment = Enum.TextXAlignment.Left

	UIListLayout_1.Parent = Text_1
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	if Desc then
		local Desc_1 = Instance.new("TextLabel")

		Desc_1.Changed:Connect(function()
			Desc_1.Size = UDim2.new(Sizes, 0,0, Desc_1.TextBounds.Y)
		end)

		Desc_1.Name = "Desc"
		Desc_1.Parent = Text_1
		Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Desc_1.BackgroundTransparency = 1
		Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Desc_1.BorderSizePixel = 0
		Desc_1.Position = UDim2.new(0, 0,0.555555582, 0)
		Desc_1.Size = UDim2.new(1, 0,0, 11)
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

	if Icon then
		local AssetFrame_1 = Instance.new("Frame")
		local asset_1 = Instance.new("ImageLabel")
		local UIPadding_2 = Instance.new("UIPadding")

		AssetFrame_1.Name = "AssetFrame"
		AssetFrame_1.Parent = Rows
		AssetFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		AssetFrame_1.BackgroundTransparency = 1
		AssetFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
		AssetFrame_1.BorderSizePixel = 0
		AssetFrame_1.Size = UDim2.new(1, 0,1, 0)

		asset_1.Name = "asset"
		asset_1.Parent = AssetFrame_1
		asset_1.AnchorPoint = Vector2.new(0, 0.5)
		asset_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		asset_1.BackgroundTransparency = 1
		asset_1.BorderColor3 = Color3.fromRGB(0,0,0)
		asset_1.BorderSizePixel = 0
		asset_1.Position = UDim2.new(0, 0,0.5, 0)
		asset_1.Size = UDim2.new(0, IconSize,0, IconSize)
		asset_1.Image = Library:Asset(Icon)

		UIPadding_2.Parent = AssetFrame_1
		UIPadding_2.PaddingLeft = UDim.new(0,5)
	end

	UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Rows.Size = UDim2.new(1, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 25)
	end)

	task.delay(0.1, function()
		Rows.Size = UDim2.new(1, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 25)
	end)

	return PaddingFrame_1
end

function Library:app(params)
	local Title = params.Title or "Visual Studio Code - Library"
	local Footer = params.Footer or "Network Constant"
	local Enums = params.Enums or Enum.KeyCode.F1
	local StartSize = params.Size or Vector2.new(500,360)
	local MinSize = params.MinSize or Vector2.new(500, 350)
	local MaxSize = params.MaxSize or Vector2.new(850, 600)

	local VSCODE = Instance.new("ScreenGui")
	local Main_1 = Instance.new("Frame")
	local Background_1 = Instance.new("Frame")
	local Blur_1 = Instance.new("ImageLabel")
	local UICorner_1 = Instance.new("UICorner")

	local Toggle = Instance.new("ImageLabel") do
		local Input_1 = Instance.new("TextButton")
		Toggle.Name = "Toggle"
		Toggle.Parent = VSCODE
		Toggle.AnchorPoint = Vector2.new(0.5, 0)
		Toggle.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Toggle.BackgroundTransparency = 1
		Toggle.BorderColor3 = Color3.fromRGB(0,0,0)
		Toggle.BorderSizePixel = 0
		Toggle.Position = UDim2.new(0.5, 0,0, 10)
		Toggle.Size = UDim2.new(0, 200,0, 7)
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
			if not gameProcessed and input.KeyCode == Enums then
				closeopenui()
				On = not On
			end
		end)
	end

	VSCODE.Name = self.Window_crypt
	VSCODE.Parent = self.SafeParent
	VSCODE.ZIndexBehavior = Enum.ZIndexBehavior.Global
	VSCODE.IgnoreGuiInset = true

	Main_1.Name = "Main"
	Main_1.Parent = VSCODE
	Main_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Main_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Main_1.BackgroundTransparency = 1
	Main_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Main_1.BorderSizePixel = 0
	Main_1.Position = UDim2.new(0.5, 0,0.5, 0)

	if Library.IsMobile then
		Main_1.Size = UDim2.new(0, 450,0, 300)
		local UIScale = Instance.new("UIScale") do
			UIScale.Scale = 1.15
			UIScale.Parent = VSCODE

			MinSize = Vector2.new(450, 300)
			MaxSize = Vector2.new(500, 350)
		end
	else
		Main_1.Size = UDim2.new(0, 500,0, 360)
	end

	Background_1.Name = "Background"
	Background_1.Parent = Main_1
	Background_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Background_1.BackgroundColor3 = Color3.fromRGB(31,31,31)
	Background_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Background_1.BorderSizePixel = 0
	Background_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Background_1.Size = UDim2.new(1, 0,1, 0)

	Blur_1.Name = "Blur"
	Blur_1.Parent = Background_1
	Blur_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Blur_1.BackgroundColor3 = Color3.fromRGB(28,28,30)
	Blur_1.BackgroundTransparency = 1
	Blur_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Blur_1.BorderSizePixel = 0
	Blur_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Blur_1.Size = UDim2.new(1, 120,1, 116)
	Blur_1.ZIndex = -999999999
	Blur_1.Image = "rbxassetid://8992230677"
	Blur_1.ImageColor3 = Color3.fromRGB(0,0,0)
	Blur_1.ImageTransparency = 0.6000000238418579
	Blur_1.ScaleType = Enum.ScaleType.Slice
	Blur_1.SliceCenter = Rect.new(99, 99, 99, 99)

	UICorner_1.Parent = Background_1
	UICorner_1.CornerRadius = UDim.new(0,5)

	local Header = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local Squire_1 = Instance.new("Frame")
	local Text_1 = Instance.new("Frame")
	local Title_1 = Instance.new("TextLabel")
	local Light_1 = Instance.new("Frame")
	local Red_1 = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local Yellow_1 = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local Green_1 = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local Topbar_1 = Instance.new("Frame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local Destroy_1 = Instance.new("ImageLabel")
	local UIPadding_1 = Instance.new("UIPadding")
	local Hide_1 = Instance.new("ImageLabel")

	Header.Name = "Header"
	Header.Parent = Background_1
	Header.BackgroundColor3 = Color3.fromRGB(58,61,65)
	Header.BorderColor3 = Color3.fromRGB(0,0,0)
	Header.BorderSizePixel = 0
	Header.Size = UDim2.new(1, 0,0, 20)

	UICorner_1.Parent = Header
	UICorner_1.CornerRadius = UDim.new(0,5)

	Squire_1.Name = "Squire"
	Squire_1.Parent = Header
	Squire_1.AnchorPoint = Vector2.new(0, 1)
	Squire_1.BackgroundColor3 = Color3.fromRGB(58,61,65)
	Squire_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Squire_1.BorderSizePixel = 0
	Squire_1.Position = UDim2.new(0, 0,1, 0)
	Squire_1.Size = UDim2.new(1, 0,0, 10)

	Text_1.Name = "Text"
	Text_1.Parent = Header
	Text_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Text_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Text_1.BackgroundTransparency = 1
	Text_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Text_1.BorderSizePixel = 0
	Text_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Text_1.Size = UDim2.new(1, 0,1, 0)

	Title_1.Name = "Title"
	Title_1.Parent = Text_1
	Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_1.BackgroundTransparency = 1
	Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_1.BorderSizePixel = 0
	Title_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Title_1.Size = UDim2.new(0, 200,0, 10)
	Title_1.Font = Enum.Font.GothamSemibold
	Title_1.Text = Title
	Title_1.TextColor3 = Color3.fromRGB(255,255,255)
	Title_1.TextSize = 11
	Title_1.TextTransparency = 0.3499999940395355

	Light_1.Name = "Light"
	Light_1.Parent = Header
	Light_1.AnchorPoint = Vector2.new(0, 0.5)
	Light_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Light_1.BackgroundTransparency = 1
	Light_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Light_1.BorderSizePixel = 0
	Light_1.Position = UDim2.new(0, 0,0.5, 0)
	Light_1.Size = UDim2.new(0, 45,0, 20)

	Red_1.Name = "Red"
	Red_1.Parent = Light_1
	Red_1.BackgroundColor3 = Color3.fromRGB(254,93,86)
	Red_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Red_1.BorderSizePixel = 0
	Red_1.Size = UDim2.new(0, 6,0, 6)

	UICorner_2.Parent = Red_1
	UICorner_2.CornerRadius = UDim.new(1,0)

	Yellow_1.Name = "Yellow"
	Yellow_1.Parent = Light_1
	Yellow_1.BackgroundColor3 = Color3.fromRGB(255,187,46)
	Yellow_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Yellow_1.BorderSizePixel = 0
	Yellow_1.Size = UDim2.new(0, 6,0, 6)

	UICorner_3.Parent = Yellow_1
	UICorner_3.CornerRadius = UDim.new(1,0)

	Green_1.Name = "Green"
	Green_1.Parent = Light_1
	Green_1.BackgroundColor3 = Color3.fromRGB(56,193,76)
	Green_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Green_1.BorderSizePixel = 0
	Green_1.Size = UDim2.new(0, 6,0, 6)

	UICorner_4.Parent = Green_1
	UICorner_4.CornerRadius = UDim.new(1,0)

	UIListLayout_1.Parent = Light_1
	UIListLayout_1.Padding = UDim.new(0,5)
	UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	Topbar_1.Name = "Topbar"
	Topbar_1.Parent = Header
	Topbar_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Topbar_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Topbar_1.BackgroundTransparency = 1
	Topbar_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Topbar_1.BorderSizePixel = 0
	Topbar_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Topbar_1.Size = UDim2.new(1, 0,1, 0)

	UIListLayout_2.Parent = Topbar_1
	UIListLayout_2.Padding = UDim.new(0,10)
	UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

	Destroy_1.Name = "Destroy"
	Destroy_1.Parent = Topbar_1
	Destroy_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Destroy_1.BackgroundTransparency = 1
	Destroy_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Destroy_1.BorderSizePixel = 0
	Destroy_1.LayoutOrder = 999999999
	Destroy_1.Size = UDim2.new(0, 12,0, 12)
	Destroy_1.Image = "rbxassetid://105957381820378"
	Destroy_1.ImageRectOffset = Vector2.new(480, 0)
	Destroy_1.ImageRectSize = Vector2.new(96, 96)
	Destroy_1.ImageTransparency = 0.5

	UIPadding_1.Parent = Topbar_1
	UIPadding_1.PaddingRight = UDim.new(0,5)

	Hide_1.Name = "Hide"
	Hide_1.Parent = Topbar_1
	Hide_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Hide_1.BackgroundTransparency = 1
	Hide_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Hide_1.BorderSizePixel = 0
	Hide_1.LayoutOrder = 999999997
	Hide_1.Size = UDim2.new(0, 12,0, 12)
	Hide_1.Image = "rbxassetid://136452605242985"
	Hide_1.ImageRectOffset = Vector2.new(288, 672)
	Hide_1.ImageRectSize = Vector2.new(96, 96)
	Hide_1.ImageTransparency = 0.5

	local Max_1 = Instance.new("ImageLabel") do
		if not Library.IsMobile then
			local MaxButton = Library:Button(Max_1) do
				Max_1.Name = "Max"
				Max_1.Parent = Topbar_1
				Max_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Max_1.BackgroundTransparency = 1
				Max_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Max_1.BorderSizePixel = 0
				Max_1.LayoutOrder = 999999998
				Max_1.Size = UDim2.new(0, 10,0, 10)
				Max_1.Image = "rbxassetid://99249999535639"
				Max_1.ImageTransparency = 0.5
			end

			local LastSize = Main_1.Size
			local Threshold = 100

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

			local DestroyButton = Library:Button(Destroy_1)

			DestroyButton.MouseButton1Click:Connect(function()
				VSCODE:Destroy()
			end)
		end
	end

	local HideButton = Library:Button(Hide_1)

	HideButton.MouseButton1Click:Connect(function()
		Main_1.Visible = false
	end)

	local Lower = Instance.new("Frame")
	local UICorner_1 = Instance.new("UICorner")
	local Squire_Lower_1 = Instance.new("Frame")
	local Text_Lower_1 = Instance.new("Frame")
	local Title_Lower_1 = Instance.new("TextLabel")
	local UIPadding_1 = Instance.new("UIPadding")
	local Light_Lower_1 = Instance.new("Frame")
	local _2_1 = Instance.new("Frame")
	local UICorner_2 = Instance.new("UICorner")
	local _3_1 = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local _1_1 = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local UIListLayout_1 = Instance.new("UIListLayout")

	Lower.Name = "Lower"
	Lower.Parent = Background_1
	Lower.AnchorPoint = Vector2.new(0, 1)
	Lower.BackgroundColor3 = Color3.fromRGB(5,120,200)
	Lower.BorderColor3 = Color3.fromRGB(0,0,0)
	Lower.BorderSizePixel = 0
	Lower.Position = UDim2.new(0, 0,1, 0)
	Lower.Size = UDim2.new(1, 0,0, 15)

	UICorner_1.Parent = Lower
	UICorner_1.CornerRadius = UDim.new(0,5)

	Squire_Lower_1.Name = "Squire_Lower"
	Squire_Lower_1.Parent = Lower
	Squire_Lower_1.BackgroundColor3 = Color3.fromRGB(5,120,200)
	Squire_Lower_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Squire_Lower_1.BorderSizePixel = 0
	Squire_Lower_1.Size = UDim2.new(1, 0,0, 10)

	Text_Lower_1.Name = "Text_Lower"
	Text_Lower_1.Parent = Lower
	Text_Lower_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Text_Lower_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Text_Lower_1.BackgroundTransparency = 1
	Text_Lower_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Text_Lower_1.BorderSizePixel = 0
	Text_Lower_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Text_Lower_1.Size = UDim2.new(1, 0,1, 0)

	Title_Lower_1.Name = "Title_Lower"
	Title_Lower_1.Parent = Text_Lower_1
	Title_Lower_1.AnchorPoint = Vector2.new(0, 0.5)
	Title_Lower_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Title_Lower_1.BackgroundTransparency = 1
	Title_Lower_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Title_Lower_1.BorderSizePixel = 0
	Title_Lower_1.Position = UDim2.new(0, 0,0.5, 0)
	Title_Lower_1.Size = UDim2.new(0, 200,0, 5)
	Title_Lower_1.Font = Enum.Font.GothamMedium
	Title_Lower_1.Text = Footer
	Title_Lower_1.TextColor3 = Color3.fromRGB(255,255,255)
	Title_Lower_1.TextSize = 9
	Title_Lower_1.TextXAlignment = Enum.TextXAlignment.Left

	UIPadding_1.Parent = Text_Lower_1
	UIPadding_1.PaddingLeft = UDim.new(0,5)

	Light_Lower_1.Name = "Light_Lower"
	Light_Lower_1.Parent = Lower
	Light_Lower_1.AnchorPoint = Vector2.new(1, 0.5)
	Light_Lower_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Light_Lower_1.BackgroundTransparency = 1
	Light_Lower_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Light_Lower_1.BorderSizePixel = 0
	Light_Lower_1.Position = UDim2.new(1, 0,0.5, 0)
	Light_Lower_1.Size = UDim2.new(0, 45,0, 15)

	_2_1.Name = "_2"
	_2_1.Parent = Light_Lower_1
	_2_1.BackgroundColor3 = Color3.fromRGB(31,31,31)
	_2_1.BorderColor3 = Color3.fromRGB(0,0,0)
	_2_1.BorderSizePixel = 0
	_2_1.Size = UDim2.new(0, 6,0, 6)

	UICorner_2.Parent = _2_1
	UICorner_2.CornerRadius = UDim.new(1,0)

	_3_1.Name = "_3"
	_3_1.Parent = Light_Lower_1
	_3_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	_3_1.BorderColor3 = Color3.fromRGB(0,0,0)
	_3_1.BorderSizePixel = 0
	_3_1.Size = UDim2.new(0, 6,0, 6)

	UICorner_3.Parent = _3_1
	UICorner_3.CornerRadius = UDim.new(1,0)

	_1_1.Name = "_1"
	_1_1.Parent = Light_Lower_1
	_1_1.BackgroundColor3 = Color3.fromRGB(31,31,31)
	_1_1.BorderColor3 = Color3.fromRGB(0,0,0)
	_1_1.BorderSizePixel = 0
	_1_1.Size = UDim2.new(0, 6,0, 6)

	UICorner_4.Parent = _1_1
	UICorner_4.CornerRadius = UDim.new(1,0)

	UIListLayout_1.Parent = Light_Lower_1
	UIListLayout_1.Padding = UDim.new(0,5)
	UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	local Components = Instance.new("Frame")
	local Draggable_1 = Instance.new("ImageLabel")
	local Input_1 = Instance.new("TextButton")
	local Size_1 = Instance.new("Frame")

	Components.Name = "Components"
	Components.Parent = Background_1
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
	Size_1.ZIndex = 99

	self:Draggable(Input_1, Main_1)
	self:Draggable(Header, Main_1)
	self:Resize(Size_1, Main_1, MinSize, MaxSize, 2)

	local Tabs = Instance.new("Frame")
	local Layer_1 = Instance.new("Frame")
	local Scrolling_1 = Instance.new("ScrollingFrame")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local UIPadding_1 = Instance.new("UIPadding")

	Tabs.Name = "Tabs"
	Tabs.Parent = Background_1
	Tabs.AnchorPoint = Vector2.new(0, 0.5)
	Tabs.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Tabs.BackgroundTransparency = 1
	Tabs.BorderColor3 = Color3.fromRGB(0,0,0)
	Tabs.BorderSizePixel = 0
	Tabs.Position = UDim2.new(0, 0,0.5, 0)
	Tabs.Size = UDim2.new(0, 45,1, 0)

	Layer_1.Name = "Layer"
	Layer_1.Parent = Tabs
	Layer_1.BackgroundColor3 = Color3.fromRGB(46,46,48)
	Layer_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Layer_1.BorderSizePixel = 0
	Layer_1.Size = UDim2.new(1, 0,1, 0)

	Scrolling_1.Name = "Scrolling"
	Scrolling_1.Parent = Layer_1
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

	UIListLayout_1.Parent = Scrolling_1
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

	UIPadding_1.Parent = Tabs
	UIPadding_1.PaddingBottom = UDim.new(0,15)
	UIPadding_1.PaddingTop = UDim.new(0,20)

	UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		Scrolling_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 15)
	end)

	local History = Instance.new("Frame")
	local Page_1 = Instance.new("Frame")
	local UIPageLayout_1 = Instance.new("UIPageLayout")
	local UIPadding_1 = Instance.new("UIPadding")

	History.Name = "History"
	History.Parent = Background_1
	History.AnchorPoint = Vector2.new(0.5, 0.5)
	History.BackgroundColor3 = Color3.fromRGB(255,255,255)
	History.BackgroundTransparency = 1
	History.BorderColor3 = Color3.fromRGB(0,0,0)
	History.BorderSizePixel = 0
	History.Position = UDim2.new(0.5, 0,0.5, 0)
	History.Size = UDim2.new(1, 0,1, 0)

	Page_1.Name = "Page"
	Page_1.Parent = History
	Page_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Page_1.BackgroundTransparency = 1
	Page_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Page_1.BorderSizePixel = 0
	Page_1.Size = UDim2.new(1, 0,1, 0)
	Page_1.ClipsDescendants = true

	UIPageLayout_1.Parent = Page_1
	UIPageLayout_1.TweenTime = 0.15
	UIPageLayout_1.EasingStyle = Enum.EasingStyle.Sine
	UIPageLayout_1.FillDirection = Enum.FillDirection.Horizontal
	UIPageLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Left

	UIPadding_1.Parent = History
	UIPadding_1.PaddingBottom = UDim.new(0,15)
	UIPadding_1.PaddingLeft = UDim.new(0,45)
	UIPadding_1.PaddingTop = UDim.new(0,20)

	local Tabs = {
		Value = false
	}

	function Tabs:Normal(Icons)
		local Icon = Library:Asset(Icons)

		local AddTab = Instance.new("Frame")
		local Transparent_1 = Instance.new("Frame")
		local UICorner_1 = Instance.new("UICorner")
		local Icon_1 = Instance.new("ImageLabel")
		local Line_1 = Instance.new("Frame")
		local ButtonAddTab = Library:Button(AddTab)

		AddTab.Name = "AddTab"
		AddTab.Parent = Scrolling_1
		AddTab.BackgroundColor3 = Color3.fromRGB(255,255,255)
		AddTab.BackgroundTransparency = 1
		AddTab.BorderColor3 = Color3.fromRGB(0,0,0)
		AddTab.BorderSizePixel = 0
		AddTab.Size = UDim2.new(0, 45,0, 45)

		Transparent_1.Name = "Transparent"
		Transparent_1.Parent = AddTab
		Transparent_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Transparent_1.BackgroundColor3 = Color3.fromRGB(31,31,31)
		Transparent_1.BackgroundTransparency = 1
		Transparent_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Transparent_1.BorderSizePixel = 0
		Transparent_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Transparent_1.Size = UDim2.new(0.800000012, 0,0.800000012, 0)

		UICorner_1.Parent = Transparent_1

		Icon_1.Name = "Icon"
		Icon_1.Parent = Transparent_1
		Icon_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Icon_1.BackgroundTransparency = 1
		Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Icon_1.BorderSizePixel = 0
		Icon_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Icon_1.Size = UDim2.new(0.5, 0,0.5, 0)
		Icon_1.Image = Icon
		Icon_1.ImageTransparency = 0.5

		Line_1.Name = "Line"
		Line_1.Parent = AddTab
		Line_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Line_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Line_1.BackgroundTransparency = 1
		Line_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Line_1.BorderSizePixel = 0
		Line_1.Position = UDim2.new(0, 0,0.5, 0)
		Line_1.Size = UDim2.new(0, 3,0, 30)

		local AddPage = Instance.new("Frame")
		local Head_1 = Instance.new("Frame")
		local HeadScrolling_1 = Instance.new("ScrollingFrame")
		local UIListLayout_1 = Instance.new("UIListLayout")
		local PageList_1 = Instance.new("Frame")
		local UIPadding_1 = Instance.new("UIPadding")

		AddPage.Name = "AddPage"
		AddPage.Parent = Page_1
		AddPage.BackgroundColor3 = Color3.fromRGB(255,255,255)
		AddPage.BackgroundTransparency = 1
		AddPage.BorderColor3 = Color3.fromRGB(0,0,0)
		AddPage.BorderSizePixel = 0
		AddPage.Position = UDim2.new(-0.15384616, 0,0.0123076923, 0)
		AddPage.Size = UDim2.new(1, 0,1, 0)

		Head_1.Name = "Head"
		Head_1.Parent = AddPage
		Head_1.BackgroundColor3 = Color3.fromRGB(31,31,31)
		Head_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Head_1.BorderSizePixel = 0
		Head_1.Size = UDim2.new(1, 0,0, 20)

		HeadScrolling_1.Name = "HeadScrolling"
		HeadScrolling_1.Parent = Head_1
		HeadScrolling_1.Active = true
		HeadScrolling_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		HeadScrolling_1.BackgroundTransparency = 1
		HeadScrolling_1.BorderColor3 = Color3.fromRGB(0,0,0)
		HeadScrolling_1.BorderSizePixel = 0
		HeadScrolling_1.Size = UDim2.new(1, 0,1, 0)
		HeadScrolling_1.ClipsDescendants = true
		HeadScrolling_1.AutomaticCanvasSize = Enum.AutomaticSize.None
		HeadScrolling_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		HeadScrolling_1.CanvasPosition = Vector2.new(0, 0)
		HeadScrolling_1.CanvasSize = UDim2.new(2, 0,0, 0)
		HeadScrolling_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		HeadScrolling_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		HeadScrolling_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		HeadScrolling_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
		HeadScrolling_1.ScrollBarImageTransparency = 1
		HeadScrolling_1.ScrollBarThickness = 0
		HeadScrolling_1.ScrollingDirection = Enum.ScrollingDirection.XY
		HeadScrolling_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		HeadScrolling_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
		HeadScrolling_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

		UIListLayout_1.Parent = HeadScrolling_1
		UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

		UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			HeadScrolling_1.CanvasSize = UDim2.new(0, UIListLayout_1.AbsoluteContentSize.X + 15, 0, 0)
		end)

		PageList_1.Name = "PageList"
		PageList_1.Parent = AddPage
		PageList_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		PageList_1.BackgroundTransparency = 1
		PageList_1.BorderColor3 = Color3.fromRGB(0,0,0)
		PageList_1.BorderSizePixel = 0
		PageList_1.Size = UDim2.new(1, 0,1, 0)

		UIPadding_1.Parent = PageList_1
		UIPadding_1.PaddingTop = UDim.new(0,20)

		local function OnSelectPage()
			for _, v in pairs(Page_1:GetChildren()) do
				if v.Name == 'AddPage' or v.Name == 'AddDropdown' then
					v.Visible = false
				end
			end

			for _, v in pairs(Scrolling_1:GetChildren()) do
				if v.Name == 'AddTab' then
					Library:Tween({
						v = v.Transparent,
						t = 0.15,
						s = "Exponential",
						d = "Out",
						g = {BackgroundTransparency = 1}
					}):Play()
					Library:Tween({
						v = v.Transparent.Icon,
						t = 0.15,
						s = "Exponential",
						d = "Out",
						g = {ImageTransparency = 0.5}
					}):Play()
					Library:Tween({
						v = v.Line,
						t = 0.15,
						s = "Exponential",
						d = "Out",
						g = {BackgroundTransparency = 1}
					}):Play()
				end
			end

			AddPage.Visible = true
			UIPageLayout_1:JumpTo(AddPage)
			Library:Tween({
				v = Transparent_1,
				t = 0.15,
				s = "Exponential",
				d = "Out",
				g = {BackgroundTransparency = 0}
			}):Play()
			Library:Tween({
				v = Icon_1,
				t = 0.15,
				s = "Exponential",
				d = "Out",
				g = {ImageTransparency = 0}
			}):Play()
			Library:Tween({
				v = Line_1,
				t = 0.15,
				s = "Exponential",
				d = "Out",
				g = {BackgroundTransparency = 0}
			}):Play()
		end

		if not Tabs.Value then
			Tabs.Value = true
			AddPage.Visible = true
			UIPageLayout_1:JumpTo(AddPage)
			Library:Tween({
				v = Transparent_1,
				t = 0.3,
				s = "Exponential",
				d = "Out",
				g = {BackgroundTransparency = 0}
			}):Play()
			Library:Tween({
				v = Icon_1,
				t = 0.3,
				s = "Exponential",
				d = "Out",
				g = {ImageTransparency = 0}
			}):Play()
			Library:Tween({
				v = Line_1,
				t = 0.3,
				s = "Exponential",
				d = "Out",
				g = {BackgroundTransparency = 0}
			}):Play()
		end

		ButtonAddTab.MouseButton1Click:Connect(OnSelectPage)

		local Element = {
			Value = false
		}

		function Element:Element(Title, Descss)
			local AddElement = Instance.new("Frame")
			local Title_1 = Instance.new("TextLabel")
			local ButtonAddElement = Library:Button(AddElement)

			AddElement.Name = "AddElement"
			AddElement.Parent = HeadScrolling_1
			AddElement.BackgroundColor3 = Color3.fromRGB(37,37,38)
			AddElement.BorderColor3 = Color3.fromRGB(0,0,0)
			AddElement.BorderSizePixel = 0
			AddElement.Size = UDim2.new(0, 75,0, 20)

			Title_1.Name = "Title"
			Title_1.Parent = AddElement
			Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
			Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Title_1.BackgroundTransparency = 1
			Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Title_1.BorderSizePixel = 0
			Title_1.Position = UDim2.new(0.5, 0,0.5, 0)
			Title_1.Size = UDim2.new(1, 0,1, 0)
			Title_1.Font = Enum.Font.GothamMedium
			Title_1.Text = Title
			Title_1.TextColor3 = Color3.fromRGB(255,255,255)
			Title_1.TextSize = 10
			Title_1.TextTransparency = 0.5

			AddElement.Size = UDim2.new(0, Title_1.TextBounds.X + 35, 0, 20)

			local MainPages_1 = Instance.new("Frame")
			local ScrollingPAGE_1 = Instance.new("ScrollingFrame")
			local UIListLayout_2 = Instance.new("UIListLayout")
			local UIPadding_2 = Instance.new("UIPadding")

			MainPages_1.Name = "MainPages"
			MainPages_1.Parent = PageList_1
			MainPages_1.AnchorPoint = Vector2.new(0.5, 0.5)
			MainPages_1.Position = UDim2.new(0.6, 0, 0.5, 0)
			MainPages_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			MainPages_1.BackgroundTransparency = 1
			MainPages_1.BorderColor3 = Color3.fromRGB(0,0,0)
			MainPages_1.BorderSizePixel = 0
			MainPages_1.Size = UDim2.new(1, 0,1, 0)
			MainPages_1.Visible = false

			ScrollingPAGE_1.Name = "ScrollingPAGE"
			ScrollingPAGE_1.Parent = MainPages_1
			ScrollingPAGE_1.Active = true
			ScrollingPAGE_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			ScrollingPAGE_1.BackgroundTransparency = 1
			ScrollingPAGE_1.BorderColor3 = Color3.fromRGB(0,0,0)
			ScrollingPAGE_1.BorderSizePixel = 0
			ScrollingPAGE_1.Size = UDim2.new(1, 0,1, 0)
			ScrollingPAGE_1.ClipsDescendants = true
			ScrollingPAGE_1.AutomaticCanvasSize = Enum.AutomaticSize.None
			ScrollingPAGE_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
			ScrollingPAGE_1.CanvasPosition = Vector2.new(0, 305)
			ScrollingPAGE_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
			ScrollingPAGE_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
			ScrollingPAGE_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
			ScrollingPAGE_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
			ScrollingPAGE_1.ScrollBarImageTransparency = 1
			ScrollingPAGE_1.ScrollBarThickness = 0
			ScrollingPAGE_1.ScrollingDirection = Enum.ScrollingDirection.XY
			ScrollingPAGE_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
			ScrollingPAGE_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
			ScrollingPAGE_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

			UIListLayout_2.Parent = ScrollingPAGE_1
			UIListLayout_2.Padding = UDim.new(0, 6)
			UIListLayout_2.SortOrder = Enum.SortOrder.Name

			UIListLayout_2:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				ScrollingPAGE_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_2.AbsoluteContentSize.Y + 15)
			end)

			UIPadding_2.Parent = ScrollingPAGE_1
			UIPadding_2.PaddingBottom = UDim.new(0,7)
			UIPadding_2.PaddingLeft = UDim.new(0,7)
			UIPadding_2.PaddingRight = UDim.new(0,7)
			UIPadding_2.PaddingTop = UDim.new(0,7)

			local function Select()
				for _, v in pairs(PageList_1:GetChildren()) do
					if v:IsA("Frame") then
						v.Position = UDim2.new(0.6, 0, 0.5, 0)
						v.Visible = false
					end
				end

				for _, v in pairs(HeadScrolling_1:GetChildren()) do
					if v:IsA("Frame") then
						v.BackgroundColor3 = Color3.fromRGB(37,37,38)
						Library:Tween({
							v = v.Title,
							t = 0.15,
							s = "Exponential",
							d = "Out",
							g = {TextTransparency = 0.5}
						}):Play()
					end
				end

				MainPages_1.Visible = true
				Library:Tween({
					v = MainPages_1,
					t = 0.3,
					s = "Exponential",
					d = "Out",
					g = {Position = UDim2.new(0.5, 0, 0.5, 0)}
				}):Play()
				AddElement.BackgroundColor3 = Color3.fromRGB(5,120,200)
				Library:Tween({
					v = Title_1,
					t = 0.15,
					s = "Exponential",
					d = "Out",
					g = {TextTransparency = 0}
				}):Play()
			end

			if not Element.Value then
				Element.Value = true
				MainPages_1.Visible = true
				Library:Tween({
					v = MainPages_1,
					t = 0.3,
					s = "Exponential",
					d = "Out",
					g = {Position = UDim2.new(0.5, 0, 0.5, 0)}
				}):Play()
				AddElement.BackgroundColor3 = Color3.fromRGB(5,120,200)
				Library:Tween({
					v = Title_1,
					t = 0.15,
					s = "Exponential",
					d = "Out",
					g = {TextTransparency = 0}
				}):Play()
			end

			ButtonAddElement.MouseButton1Click:Connect(Select)

			local Class = {}

			do
				local PageTitle = Instance.new("Frame")
				local UIListLayout_1z = Instance.new("UIListLayout")
				local Title_1 = Instance.new("TextLabel")

				PageTitle.Name = "PageTitle"
				PageTitle.Parent = ScrollingPAGE_1
				PageTitle.AutomaticSize = Enum.AutomaticSize.Y
				PageTitle.BackgroundColor3 = Color3.fromRGB(255,255,255)
				PageTitle.BackgroundTransparency = 1
				PageTitle.BorderColor3 = Color3.fromRGB(0,0,0)
				PageTitle.BorderSizePixel = 0
				PageTitle.LayoutOrder = 1
				PageTitle.Size = UDim2.new(1, 0,0, 25)

				UIListLayout_1z.Parent = PageTitle
				UIListLayout_1z.Padding = UDim.new(0,1)
				UIListLayout_1z.SortOrder = Enum.SortOrder.LayoutOrder

				Title_1.Changed:Connect(function()
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

				local Desc_1 = Descss and Instance.new("TextLabel") or nil do
					if Descss then
						Desc_1.Changed:Connect(function()
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
						Desc_1.Text = Descss
						Desc_1.TextColor3 = Color3.fromRGB(255,255,255)
						Desc_1.TextSize = 11
						Desc_1.TextTransparency = 0.5
						Desc_1.TextXAlignment = Enum.TextXAlignment.Left
						Desc_1.TextWrapped = true
						Desc_1.RichText = true
					end
				end
			end

			function Class:Paragarp(params)
				local Title = params.Title or "Unknow"
				local Desc = params.Desc or nil
				local Icon = params.Icon or nil
				local IconSize = params.IconSize or 40
				local StatusValue = params.Status or "None"
				local Rower = nil

				if StatusValue ~= "None" then
					Rower = Library:Row(ScrollingPAGE_1, Title, Desc, nil, Icon, IconSize)
				else
					Rower = Library:Row(ScrollingPAGE_1, Title, Desc, 1, Icon, IconSize)
				end

				local selfs = {}

				local Statust = Instance.new("Frame")
				local UIPadding_1 = Instance.new("UIPadding")
				local Circle_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local LightCircle_1 = Instance.new("ImageLabel")

				Statust.Name = "Status"

				if StatusValue ~= "None" then
					StatusValue = true
				else
					StatusValue = false
				end

				Statust.Parent = Rower
				Statust.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Statust.BackgroundTransparency = 1
				Statust.BorderColor3 = Color3.fromRGB(0,0,0)
				Statust.BorderSizePixel = 0
				Statust.Size = UDim2.new(1, 0,1, 0)

				UIPadding_1.Parent = Statust
				UIPadding_1.PaddingRight = UDim.new(0,5)

				Circle_1.Name = "Circle"
				Circle_1.Parent = Statust
				Circle_1.AnchorPoint = Vector2.new(1, 0.5)
				Circle_1.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
				Circle_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Circle_1.BorderSizePixel = 0
				Circle_1.Position = UDim2.new(1, 0,0.5, 0)
				Circle_1.Size = UDim2.new(0, 15,0, 15)

				UICorner_1.Parent = Circle_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				LightCircle_1.Name = "LightCircle"
				LightCircle_1.Parent = Circle_1
				LightCircle_1.AnchorPoint = Vector2.new(0.5, 0.5)
				LightCircle_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				LightCircle_1.BackgroundTransparency = 1
				LightCircle_1.BorderColor3 = Color3.fromRGB(0,0,0)
				LightCircle_1.BorderSizePixel = 0
				LightCircle_1.Position = UDim2.new(0.5, 0,0.5, 0)
				LightCircle_1.Size = UDim2.new(1, 30,1, 30)
				LightCircle_1.Image = "rbxassetid://110890831577968"
				LightCircle_1.ImageColor3 = Color3.fromRGB(255, 255, 0)

				function selfs:SetStatus(value)
					if not value then
						Circle_1.BackgroundColor3 = Color3.fromRGB(254,93,86)
						LightCircle_1.ImageColor3 = Color3.fromRGB(254,93,86)
					else
						Circle_1.BackgroundColor3 = Color3.fromRGB(56,193,76)
						LightCircle_1.ImageColor3 = Color3.fromRGB(56,193,76)
					end
				end

				selfs:SetStatus(StatusValue)

				local Titles = Rower.Text.Title

				function selfs:SetTitle(a)
					Titles.Text = a
				end

				if Desc then
					local Descs = Rower.Text.Desc

					function selfs:SetDesc(a)
						Descs.Text = a
					end
				end

				if Icon then
					function selfs:SetIcon(a)
						local _Icon = Rower.Parent.AssetFrame.asset
						_Icon.Image = Library:Asset(a)
					end
				end

				return selfs
			end

			function Class:Toggle(new)
				local Title = new.Title
				local Desc = new.Desc or nil
				local Icon = new.Icon or nil
				local IconSize = new.IconSize or 40
				local Raw = Library:Row(ScrollingPAGE_1, Title, Desc, 0.9, Icon, IconSize)
				local Button = Library:Button(Raw.Parent)
				local Value = new.Value or false
				local Callback = new.Call or function() return end
				local selfs = {}

				local ElementSignal = Signal.new()
				selfs.OnValueChanged = ElementSignal

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
					for _, v in pairs(Main_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end

					Library:Effect(Button, Raw)

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

						Vanity.BackgroundColor3 = Color3.fromRGB(5, 120, 200)
					end
				end

				local function Init()
					Value = not Value
					OnChanged(Value)
					ElementSignal:Fire(Value)
				end

				Button.MouseButton1Click:Connect(Init)

				OnChanged(Value)

				local Titles = Raw.Text.Title

				function selfs:SetTitle(a)
					Titles.Text = a
				end

				if Desc then
					local Descs = Raw.Text.Desc

					function selfs:SetDesc(a)
						Descs.Text = a
					end
				end

				if Icon then
					function selfs:SetIcon(a)
						local _Icon = Raw.Parent.AssetFrame.asset
						_Icon.Image = Library:Asset(a)
					end
				end

				function selfs:ChangeValue(value)
					Value = value
					OnChanged(value)
					ElementSignal:Fire(value)
				end

				return selfs
			end

			function Class:Button(new)
				local Title = new.Title
				local Desc = new.Desc or nil
				local Icon = new.Icon or nil
				local IconSize = new.IconSize or 40
				local Raw = Library:Row(ScrollingPAGE_1, Title, Desc, 0.9, Icon, IconSize)
				local Callback = new.Call or function() return end

				local Button = Instance.new("Frame")
				local Asset_1 = Instance.new("ImageLabel")
				local Buttons = Library:Button(Raw.Parent)

				Button.Name = "Button"
				Button.Parent = Raw
				Button.AnchorPoint = Vector2.new(0.5, 0.5)
				Button.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Button.BackgroundTransparency = 1
				Button.BorderColor3 = Color3.fromRGB(0,0,0)
				Button.BorderSizePixel = 0
				Button.Position = UDim2.new(0.5, 0,0.5, 0)
				Button.Size = UDim2.new(1, 0,1, 0)

				Asset_1.Name = "Asset"
				Asset_1.Parent = Button
				Asset_1.AnchorPoint = Vector2.new(1, 0.5)
				Asset_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Asset_1.BackgroundTransparency = 1
				Asset_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Asset_1.BorderSizePixel = 0
				Asset_1.Position = UDim2.new(1, 0,0.5, 0)
				Asset_1.Size = UDim2.new(0, 20,0, 20)
				Asset_1.Image = "rbxassetid://123094555145509"
				Asset_1.ImageTransparency = 0.5

				Buttons.MouseButton1Click:Connect(function()
					for _, v in pairs(Main_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end

					Library:Tween({
						v = Asset_1,
						t = 0.15,
						s = "Linear",
						d = "Out",
						g = {ImageTransparency = 0}
					}):Play()

					delay(0.15, function()
						Library:Tween({
							v = Asset_1,
							t = 0.2,
							s = "Linear",
							d = "Out",
							g = {ImageTransparency = 0.5}
						}):Play()
					end)

					Library:Effect(Buttons, Raw)

					Callback()
				end)

				local Titles = Raw.Text.Title
				local selfs = {}

				function selfs:SetTitle(a)
					Titles.Text = a
				end

				if Desc then
					local Descs = Raw.Text.Desc
					function selfs:SetDesc(a)
						Descs.Text = a
					end
				end

				if Icon then
					function selfs:SetIcon(a)
						local _Icon = Raw.Parent.AssetFrame.asset
						_Icon.Image = Library:Asset(a)
					end
				end

				function selfs:Fire()
					Callback()
				end

				return selfs
			end

			function Class:Textfield(new)
				local Title = new.Title
				local Desc = new.Desc or nil
				local Icon = new.Icon or nil
				local IconSize = new.IconSize or 40
				local Value = new.Value or "..."
				local Raw = Library:Row(ScrollingPAGE_1, Title, Desc, 0.55, Icon, IconSize)
				local Callback = new.Call or function() return end

				local Box = Instance.new("Frame")
				local Grey_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIStroke_1 = Instance.new("UIStroke")
				local TextBox_1 = Instance.new("TextBox")
				local AssetIcon_1 = Instance.new("ImageLabel")
				local UIListLayout_1 = Instance.new("UIListLayout")

				Box.Name = "Box"
				Box.Parent = Raw
				Box.AnchorPoint = Vector2.new(0.5, 0.5)
				Box.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Box.BackgroundTransparency = 1
				Box.BorderColor3 = Color3.fromRGB(0,0,0)
				Box.BorderSizePixel = 0
				Box.Position = UDim2.new(0.5, 0,0.5, 0)
				Box.Size = UDim2.new(1, 0,1, 0)

				Grey_1.Name = "Grey"
				Grey_1.Parent = Box
				Grey_1.AnchorPoint = Vector2.new(1, 0.5)
				Grey_1.BackgroundColor3 = Color3.fromRGB(31,30,30)
				Grey_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Grey_1.BorderSizePixel = 0
				Grey_1.Position = UDim2.new(1, 0,0.5, 0)
				Grey_1.Size = UDim2.new(0, 150,0, 20)

				UICorner_1.Parent = Grey_1
				UICorner_1.CornerRadius = UDim.new(0,5)

				UIStroke_1.Parent = Grey_1
				UIStroke_1.Color = Color3.fromRGB(55,56,58)
				UIStroke_1.Thickness = 1

				TextBox_1.Parent = Grey_1
				TextBox_1.Active = true
				TextBox_1.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.BackgroundTransparency = 1
				TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextBox_1.BorderSizePixel = 0
				TextBox_1.CursorPosition = -1
				TextBox_1.Position = UDim2.new(0.5, 0,0.5, 0)
				TextBox_1.Size = UDim2.new(0.85, 0,1, 0)
				TextBox_1.Font = Enum.Font.GothamSemibold
				TextBox_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextBox_1.PlaceholderText = "..."
				TextBox_1.Text = tostring(Value)
				TextBox_1.TextColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.TextSize = 11
				TextBox_1.TextTransparency = 0.5
				TextBox_1.TextXAlignment = Enum.TextXAlignment.Left

				AssetIcon_1.Name = "AssetIcon"
				AssetIcon_1.Parent = Grey_1
				AssetIcon_1.AnchorPoint = Vector2.new(1, 0.5)
				AssetIcon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				AssetIcon_1.BackgroundTransparency = 1
				AssetIcon_1.BorderColor3 = Color3.fromRGB(0,0,0)
				AssetIcon_1.BorderSizePixel = 0
				AssetIcon_1.Position = UDim2.new(1, 0,0.5, 0)
				AssetIcon_1.Size = UDim2.new(0, 10,0, 10)
				AssetIcon_1.Image = "rbxassetid://98429152551708"
				AssetIcon_1.ImageTransparency = 0.5
				AssetIcon_1.LayoutOrder = 5

				UIListLayout_1.Parent = Grey_1
				UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

				TextBox_1.Focused:Connect(function()
					TextBox_1.TextTruncate = Enum.TextTruncate.None
					Library:Tween({
						v = TextBox_1,
						t = 0.1,
						s = "Linear",
						d = "Out",
						g = {TextTransparency = 0}
					}):Play()
				end)

				TextBox_1.FocusLost:Connect(function()
					Value = TextBox_1.Text
					Callback(Value)
					TextBox_1.TextTruncate = Enum.TextTruncate.AtEnd
					Library:Tween({
						v = TextBox_1,
						t = 0.1,
						s = "Linear",
						d = "Out",
						g = {TextTransparency = 0.5}
					}):Play()
				end)

				local Titles = Raw.Text.Title
				local selfs = {}

				function selfs:SetTitle(a)
					Titles.Text = a
				end

				if Desc then
					local Descs = Raw.Text.Desc

					function selfs:SetDesc(a)
						Descs.Text = a
					end
				end

				if Icon then
					function selfs:SetIcon(a)
						local _Icon = Raw.Parent.AssetFrame.asset
						_Icon.Image = Library:Asset(a)
					end
				end

				function selfs:ChangeValue(value)
					TextBox_1.Text = value
					Value = TextBox_1.Text
					Callback(Value)
				end

				return selfs
			end

			function Class:Dropdown(new)
				local Title = new.Title or "Dropdown"
				local Icon = new.Icon or nil
				local List = new.List or {}
				local IconSize = new.IconSize or 40
				local Value = new.Value or "N/A"
				local Primary = new.Type or "Single" -- Icon, Double, Single
				local Advance = new.Advance or {
					['Select'] = "Selected",
					['Not Select'] = "Not Select",
					['Clear'] = "Clear",
					['Select All'] = "All",
					['Search'] = "Search ..."
				}
				local Multi = new.Multi or (typeof(Value) == "table" and true)
				local Raw = Library:Row(ScrollingPAGE_1, Title, "N/A", 0.9, Icon, IconSize)
				local Call = new.Call or function() return end

				local ElementSignal = {
					['OnValueChanged'] = Signal.new(),
					['OnRefresh'] = Signal.new()
				}

				local asset = Instance.new("ImageLabel") do
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
					asset.ImageTransparency = 0.5
				end

				local Buttons = Library:Button(Raw.Parent)
				local AddDropdown = Instance.new("Frame")
				local UIPadding_1 = Instance.new("UIPadding")
				local HeadOption = Instance.new("Frame")

				AddDropdown.Name = "AddDropdown"
				AddDropdown.Parent = Page_1
				AddDropdown.BackgroundColor3 = Color3.fromRGB(255,255,255)
				AddDropdown.BackgroundTransparency = 1
				AddDropdown.BorderColor3 = Color3.fromRGB(0,0,0)
				AddDropdown.BorderSizePixel = 0
				AddDropdown.Size = UDim2.new(1, 0,1, 0)
				AddDropdown.Visible = false

				UIPadding_1.Parent = AddDropdown
				UIPadding_1.PaddingBottom = UDim.new(0,10)
				UIPadding_1.PaddingLeft = UDim.new(0,10)
				UIPadding_1.PaddingRight = UDim.new(0,10)
				UIPadding_1.PaddingTop = UDim.new(0,10)

				HeadOption.Name = "HeadOption"
				HeadOption.Parent = AddDropdown
				HeadOption.BackgroundColor3 = Color3.fromRGB(255,255,255)
				HeadOption.BackgroundTransparency = 1
				HeadOption.BorderColor3 = Color3.fromRGB(0,0,0)
				HeadOption.BorderSizePixel = 0
				HeadOption.Size = UDim2.new(1, 0,0, 60)

				local PageFrame = Instance.new("Frame")
				local PageTitle_1 = Instance.new("Frame")
				local UIListLayout_1 = Instance.new("UIListLayout")
				local Title_1 = Instance.new("TextLabel")
				local Desc_1 = Instance.new("TextLabel")

				PageFrame.Name = "PageFrame"
				PageFrame.Parent = HeadOption
				PageFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
				PageFrame.BackgroundTransparency = 1
				PageFrame.BorderColor3 = Color3.fromRGB(0,0,0)
				PageFrame.BorderSizePixel = 0
				PageFrame.Size = UDim2.new(1, 0,0, 60)

				PageTitle_1.Name = "PageTitle"
				PageTitle_1.Parent = PageFrame
				PageTitle_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				PageTitle_1.BackgroundTransparency = 1
				PageTitle_1.BorderColor3 = Color3.fromRGB(0,0,0)
				PageTitle_1.BorderSizePixel = 0
				PageTitle_1.Size = UDim2.new(1, 0,0, 25)

				UIListLayout_1.Parent = PageTitle_1
				UIListLayout_1.Padding = UDim.new(0,4)
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

				Title_1.Name = "Title"
				Title_1.Parent = PageTitle_1
				Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Title_1.BackgroundTransparency = 1
				Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Title_1.BorderSizePixel = 0
				Title_1.Size = UDim2.new(0.699999988, 0,0, 11)
				Title_1.Font = Enum.Font.GothamSemibold
				Title_1.Text = Title
				Title_1.TextColor3 = Color3.fromRGB(255,255,255)
				Title_1.TextSize = 14
				Title_1.TextStrokeColor3 = Color3.fromRGB(255,255,255)
				Title_1.TextTruncate = Enum.TextTruncate.AtEnd
				Title_1.TextXAlignment = Enum.TextXAlignment.Left

				Desc_1.Name = "Desc"
				Desc_1.Parent = PageTitle_1
				Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Desc_1.BackgroundTransparency = 1
				Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Desc_1.BorderSizePixel = 0
				Desc_1.Position = UDim2.new(0, 0,0.439999998, 0)
				Desc_1.Size = UDim2.new(0.699999988, 0,0, 10)
				Desc_1.Font = Enum.Font.GothamMedium
				Desc_1.Text = "N/A"
				Desc_1.TextColor3 = Color3.fromRGB(255,255,255)
				Desc_1.TextSize = 11
				Desc_1.TextTransparency = 0.5
				Desc_1.TextTruncate = Enum.TextTruncate.AtEnd
				Desc_1.TextXAlignment = Enum.TextXAlignment.Left

				local TextData = {
					['OnRaw'] = Raw.Text.Desc,
					['OnDropdown'] = Desc_1
				}

				local function UpdateText()
					if typeof(Value) == 'table' then
						TextData.OnRaw.Text = table.concat(Value, ", ")
						TextData.OnDropdown.Text = table.concat(Value, ", ")
					else
						TextData.OnRaw.Text = Value
						TextData.OnDropdown.Text = Value
					end
				end

				local function SetDesc(a)
					TextData.OnRaw.Text = a
					TextData.OnDropdown.Text = a
				end

				UpdateText()

				local OptionFrame = Instance.new("Frame")
				local UIPadding_1 = Instance.new("UIPadding")
				local UIListLayout_1 = Instance.new("UIListLayout")

				OptionFrame.Name = "OptionFrame"
				OptionFrame.Parent = HeadOption
				OptionFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
				OptionFrame.BackgroundTransparency = 1
				OptionFrame.BorderColor3 = Color3.fromRGB(0,0,0)
				OptionFrame.BorderSizePixel = 0
				OptionFrame.Size = UDim2.new(1, 0,0, 60)

				UIPadding_1.Parent = OptionFrame
				UIPadding_1.PaddingTop = UDim.new(0,35)

				UIListLayout_1.Parent = OptionFrame
				UIListLayout_1.Padding = UDim.new(0,5)
				UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder

				local Box = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIStroke_1 = Instance.new("UIStroke")
				local UIListLayout_1 = Instance.new("UIListLayout")
				local UIPadding_1 = Instance.new("UIPadding")
				local SearchAsset_1 = Instance.new("ImageLabel")
				local Search_1 = Instance.new("TextBox")

				Box.Name = "Box"
				Box.Parent = OptionFrame
				Box.BackgroundColor3 = Color3.fromRGB(46,46,48)
				Box.BorderColor3 = Color3.fromRGB(0,0,0)
				Box.BorderSizePixel = 0
				Box.Size = UDim2.new(0, 150,0, 25)

				UICorner_1.Parent = Box
				UICorner_1.CornerRadius = UDim.new(0,5)

				UIStroke_1.Parent = Box
				UIStroke_1.Color = Color3.fromRGB(87,87,91)
				UIStroke_1.Thickness = 0.75

				UIListLayout_1.Parent = Box
				UIListLayout_1.Padding = UDim.new(0,5)
				UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

				UIPadding_1.Parent = Box
				UIPadding_1.PaddingLeft = UDim.new(0,5)
				UIPadding_1.PaddingRight = UDim.new(0,30)

				SearchAsset_1.Name = "SearchAsset"
				SearchAsset_1.Parent = Box
				SearchAsset_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				SearchAsset_1.BackgroundTransparency = 1
				SearchAsset_1.BorderColor3 = Color3.fromRGB(0,0,0)
				SearchAsset_1.BorderSizePixel = 0
				SearchAsset_1.Size = UDim2.new(0, 15,0, 15)
				SearchAsset_1.Image = "rbxassetid://125928820284709"
				SearchAsset_1.ImageTransparency = 0.5

				Search_1.Name = "Search"
				Search_1.Parent = Box
				Search_1.Active = true
				Search_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Search_1.BackgroundTransparency = 1
				Search_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Search_1.BorderSizePixel = 0
				Search_1.Size = UDim2.new(1, 0,1, 0)
				Search_1.Font = Enum.Font.GothamSemibold
				Search_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				Search_1.PlaceholderText = Advance['Search']
				Search_1.Text = ""
				Search_1.TextColor3 = Color3.fromRGB(255,255,255)
				Search_1.TextSize = 12
				Search_1.TextTransparency = 0.5
				Search_1.TextXAlignment = Enum.TextXAlignment.Left

				local Refresh = Instance.new("Frame")
				local ClickRefresh = Library:Button(Refresh)
				local UICorner_1 = Instance.new("UICorner")
				local asset_1 = Instance.new("ImageLabel")

				Refresh.Name = "Refresh"
				Refresh.Parent = OptionFrame
				Refresh.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Refresh.BorderColor3 = Color3.fromRGB(0,0,0)
				Refresh.BorderSizePixel = 0
				Refresh.Size = UDim2.new(0, 25,0, 25)

				UICorner_1.Parent = Refresh
				UICorner_1.CornerRadius = UDim.new(1,0)

				asset_1.Name = "asset"
				asset_1.Parent = Refresh
				asset_1.AnchorPoint = Vector2.new(0.5, 0.5)
				asset_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				asset_1.BackgroundTransparency = 1
				asset_1.BorderColor3 = Color3.fromRGB(0,0,0)
				asset_1.BorderSizePixel = 0
				asset_1.Position = UDim2.new(0.5, 0,0.5, 0)
				asset_1.Size = UDim2.new(0.600000024, 0,0.600000024, 0)
				asset_1.Image = "rbxassetid://97804057623763"
				asset_1.ImageColor3 = Color3.fromRGB(0,0,0)

				local Clear = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local ClearText_1 = Instance.new("TextLabel")
				local ClickClear = Library:Button(Clear)

				Clear.Name = "Clear"
				Clear.Parent = OptionFrame
				Clear.BackgroundColor3 = Color3.fromRGB(254,93,86)
				Clear.BorderColor3 = Color3.fromRGB(0,0,0)
				Clear.BorderSizePixel = 0
				Clear.Size = UDim2.new(0, 60,0, 25)

				UICorner_1.Parent = Clear
				UICorner_1.CornerRadius = UDim.new(1,0)

				ClearText_1.Name = "ClearText"
				ClearText_1.Parent = Clear
				ClearText_1.AnchorPoint = Vector2.new(0.5, 0.5)
				ClearText_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ClearText_1.BackgroundTransparency = 1
				ClearText_1.BorderColor3 = Color3.fromRGB(0,0,0)
				ClearText_1.BorderSizePixel = 0
				ClearText_1.Position = UDim2.new(0.5, 0,0.5, 0)
				ClearText_1.Size = UDim2.new(1, 0,1, 0)
				ClearText_1.Font = Enum.Font.GothamSemibold
				ClearText_1.Text = Advance['Clear']
				ClearText_1.TextSize = 13

				local BackFrame = Instance.new("Frame")
				local UIPadding_1 = Instance.new("UIPadding")
				local Back_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local LeaveIcon_1 = Instance.new("ImageLabel")
				local ClickBack = Library:Button(Back_1)

				BackFrame.Name = "BackFrame"
				BackFrame.Parent = HeadOption
				BackFrame.BackgroundColor3 = Color3.fromRGB(255,255,255)
				BackFrame.BackgroundTransparency = 1
				BackFrame.BorderColor3 = Color3.fromRGB(0,0,0)
				BackFrame.BorderSizePixel = 0
				BackFrame.Size = UDim2.new(1, 0,0, 60)

				UIPadding_1.Parent = BackFrame
				UIPadding_1.PaddingRight = UDim.new(0,5)

				Back_1.Name = "Back"
				Back_1.Parent = BackFrame
				Back_1.AnchorPoint = Vector2.new(1, 0.5)
				Back_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Back_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Back_1.BorderSizePixel = 0
				Back_1.Position = UDim2.new(1, 0,0.5, 0)
				Back_1.Size = UDim2.new(0, 45,0, 45)

				UICorner_1.Parent = Back_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				LeaveIcon_1.Name = "LeaveIcon"
				LeaveIcon_1.Parent = Back_1
				LeaveIcon_1.AnchorPoint = Vector2.new(0.5, 0.5)
				LeaveIcon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				LeaveIcon_1.BackgroundTransparency = 1
				LeaveIcon_1.BorderColor3 = Color3.fromRGB(0,0,0)
				LeaveIcon_1.BorderSizePixel = 0
				LeaveIcon_1.Position = UDim2.new(0.5, 0,0.5, 0)
				LeaveIcon_1.Size = UDim2.new(0.699999988, 0,0.699999988, 0)
				LeaveIcon_1.Image = "rbxassetid://80831702831757"
				LeaveIcon_1.ImageColor3 = Color3.fromRGB(31,31,31)

				local function OnBack()
					for _, v in pairs(Page_1:GetChildren()) do
						if v.Name == 'AddPage' or v.Name == 'AddDropdown' then
							v.Visible = false
						end
					end

					AddPage.Visible = true
					UIPageLayout_1:JumpTo(AddPage)
				end

				local function OnLanding()
					for _, v in pairs(Page_1:GetChildren()) do
						if v.Name == 'AddPage' or v.Name == 'AddDropdown' then
							v.Visible = false
						end
					end

					AddDropdown.Visible = true
					UIPageLayout_1:JumpTo(AddDropdown)
				end

				local All = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local AllText_1 = Instance.new("TextLabel")
				local ClickAll = Library:Button(All)

				All.Name = "All"
				All.Parent = OptionFrame
				All.BackgroundColor3 = Color3.fromRGB(255,255,255)
				All.BorderColor3 = Color3.fromRGB(0,0,0)
				All.BorderSizePixel = 0
				All.Size = UDim2.new(0, 75,0, 25)

				UICorner_1.Parent = All
				UICorner_1.CornerRadius = UDim.new(1,0)

				AllText_1.Name = "AllText"
				AllText_1.Parent = All
				AllText_1.AnchorPoint = Vector2.new(0.5, 0.5)
				AllText_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				AllText_1.BackgroundTransparency = 1
				AllText_1.BorderColor3 = Color3.fromRGB(0,0,0)
				AllText_1.BorderSizePixel = 0
				AllText_1.Position = UDim2.new(0.5, 0,0.5, 0)
				AllText_1.Size = UDim2.new(1, 0,1, 0)
				AllText_1.Font = Enum.Font.GothamSemibold
				AllText_1.Text = Advance['Select All']
				AllText_1.TextSize = 13
				AllText_1.TextWrapped = true

				ClickBack.MouseButton1Click:Connect(OnBack)
				Buttons.MouseButton1Click:Connect(OnLanding)

				local Scrolling_RE = Instance.new("Frame")
				local UIPadding_1 = Instance.new("UIPadding")

				Scrolling_RE.Name = "Scrolling_RE"
				Scrolling_RE.Parent = AddDropdown
				Scrolling_RE.AnchorPoint = Vector2.new(0.5, 0.5)
				Scrolling_RE.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Scrolling_RE.BackgroundTransparency = 1
				Scrolling_RE.BorderColor3 = Color3.fromRGB(0,0,0)
				Scrolling_RE.BorderSizePixel = 0
				Scrolling_RE.Position = UDim2.new(0.5, 0,0.5, 0)
				Scrolling_RE.Size = UDim2.new(1, 0,1, 0)

				UIPadding_1.Parent = Scrolling_RE
				UIPadding_1.PaddingTop = UDim.new(0,70)

				local DropdownScrolling = Instance.new("ScrollingFrame")
				local UIListLayout_1 = Instance.new("UIListLayout")
				local UIPadding_1 = Instance.new("UIPadding")

				DropdownScrolling.Name = "DropdownScrolling"
				DropdownScrolling.Parent = Scrolling_RE
				DropdownScrolling.AnchorPoint = Vector2.new(0.5, 0.5)
				DropdownScrolling.BackgroundColor3 = Color3.fromRGB(255,255,255)
				DropdownScrolling.BackgroundTransparency = 1
				DropdownScrolling.BorderColor3 = Color3.fromRGB(0,0,0)
				DropdownScrolling.BorderSizePixel = 0
				DropdownScrolling.Position = UDim2.new(0.5, 0,0.5, 0)
				DropdownScrolling.Size = UDim2.new(1, 0,1, 0)
				DropdownScrolling.ClipsDescendants = true
				DropdownScrolling.AutomaticCanvasSize = Enum.AutomaticSize.None
				DropdownScrolling.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
				DropdownScrolling.CanvasPosition = Vector2.new(0, 0)
				DropdownScrolling.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
				DropdownScrolling.HorizontalScrollBarInset = Enum.ScrollBarInset.None
				DropdownScrolling.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				DropdownScrolling.ScrollBarImageTransparency = 1
				DropdownScrolling.ScrollBarThickness = 0
				DropdownScrolling.ScrollingDirection = Enum.ScrollingDirection.XY
				DropdownScrolling.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
				DropdownScrolling.VerticalScrollBarInset = Enum.ScrollBarInset.None
				DropdownScrolling.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

				UIListLayout_1.Parent = DropdownScrolling
				UIPadding_1.Parent = DropdownScrolling

				UIPadding_1.PaddingBottom = UDim.new(0,1)
				UIPadding_1.PaddingLeft = UDim.new(0,1)
				UIPadding_1.PaddingRight = UDim.new(0,1)
				UIPadding_1.PaddingTop = UDim.new(0,1)

				UIListLayout_1.Padding = UDim.new(0,5)

				Search_1.Changed:Connect(function()
					local SearchT = string.lower(Search_1.Text)
					for i, v in pairs(DropdownScrolling:GetChildren()) do
						if v:IsA("Frame") then
							local labelText = string.lower(v.PaddingFrame.Text.Title.Text)
							if string.find(labelText, SearchT, 1, true) then
								v.Visible = true
							else
								v.Visible = false
							end
						end
					end
				end)

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

				local itemslist = {}

				if Primary == 'Single' then
					UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
				elseif Primary == 'Double' then
					UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
					UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
					UIListLayout_1.Wraps = true
				elseif Primary == 'Icon' then
					UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
					UIListLayout_1.FillDirection = Enum.FillDirection.Horizontal
					UIListLayout_1.Wraps = true
				end

				local selectedItem

				function itemslist:Clear(a)
					local function shouldClear(v)
						if a == nil then
							return true
						elseif type(a) == "string" then
							return v.PaddingFrame.Text.Title.Text == a
						elseif type(a) == "table" then
							for _, name in ipairs(a) do
								if v.PaddingFrame.Text.Title.Text == name then
									return true
								end
							end
						end

						return false
					end

					for _, v in ipairs(DropdownScrolling:GetChildren()) do
						if v:IsA("Frame") and shouldClear(v) then
							if selectedItem and v.PaddingFrame.Text.Title.Text == selectedItem then
								selectedItem = nil
								SetDesc('N/A')
							end

							v:Destroy()
						end
					end

					if selectedItem == a or TextData.OnRaw.Text == a then
						selectedItem = nil
						SetDesc('N/A')
					end

					if a == nil then
						selectedItem = nil
						SetDesc('N/A')
					end
				end

				local selectedValues = {}

				function itemslist:AddList(tables)
					local Title
					local Icon

					if typeof(tables) == 'string' then
						Title = tables
						Icon = nil
					else
						Title = tables.Title or "Unknow"
						Icon = tables.Icon or nil
					end

					local Rows = Instance.new("Frame")
					local UICorner_1 = Instance.new("UICorner")
					local UIStroke_1 = Instance.new("UIStroke")
					local PaddingFrame_1 = Instance.new("Frame")
					local UIPadding_1 = Instance.new("UIPadding")
					local Text_1 = Instance.new("Frame")
					local Title_1 = Instance.new("TextLabel")
					local UIListLayout_1 = Instance.new("UIListLayout")
					local Desc_1 = Instance.new("TextLabel")
					local SelectEffect_1 = Instance.new("ImageLabel")
					local UICorner_2 = Instance.new("UICorner")

					Rows.Name = "Rows"
					Rows.Parent = DropdownScrolling
					Rows.BackgroundColor3 = Color3.fromRGB(37,37,38)
					Rows.BorderColor3 = Color3.fromRGB(0,0,0)
					Rows.BorderSizePixel = 0

					UICorner_1.Parent = Rows
					UICorner_1.CornerRadius = UDim.new(0,5)

					UIStroke_1.Parent = Rows
					UIStroke_1.Color = Color3.fromRGB(55,56,58)
					UIStroke_1.Thickness = 0.75

					PaddingFrame_1.Name = "PaddingFrame"
					PaddingFrame_1.Parent = Rows
					PaddingFrame_1.AnchorPoint = Vector2.new(0.5, 0.5)
					PaddingFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					PaddingFrame_1.BackgroundTransparency = 1
					PaddingFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
					PaddingFrame_1.BorderSizePixel = 0
					PaddingFrame_1.Position = UDim2.new(0.5, 0,0.5, 0)
					PaddingFrame_1.Size = UDim2.new(1, 0,1, 0)

					UIPadding_1.Parent = PaddingFrame_1
					UIPadding_1.PaddingBottom = UDim.new(0,10)
					UIPadding_1.PaddingRight = UDim.new(0,12)
					UIPadding_1.PaddingTop = UDim.new(0,10)

					Text_1.Name = "Text"
					Text_1.Parent = PaddingFrame_1
					Text_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Text_1.BackgroundTransparency = 1
					Text_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Text_1.BorderSizePixel = 0
					Text_1.Size = UDim2.new(1, 0,1, 0)

					Title_1.Name = "Title"
					Title_1.Parent = Text_1
					Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Title_1.BackgroundTransparency = 1
					Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Title_1.BorderSizePixel = 0
					Title_1.LayoutOrder = -1
					Title_1.Size = UDim2.new(1, 0,0, 14)
					Title_1.Font = Enum.Font.GothamMedium
					Title_1.RichText = true
					Title_1.Text = Title
					Title_1.TextColor3 = Color3.fromRGB(255,255,255)
					Title_1.TextSize = 16
					Title_1.TextTransparency = 0.5
					Title_1.TextXAlignment = Enum.TextXAlignment.Left

					UIListLayout_1.Parent = Text_1
					UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
					UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

					Desc_1.Name = "Desc"
					Desc_1.Parent = Text_1
					Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Desc_1.BackgroundTransparency = 1
					Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Desc_1.BorderSizePixel = 0
					Desc_1.LayoutOrder = -1
					Desc_1.Size = UDim2.new(1, 0,0, 14)
					Desc_1.Font = Enum.Font.GothamMedium
					Desc_1.RichText = true
					Desc_1.Text = Advance['Not Select']
					Desc_1.TextColor3 = Color3.fromRGB(255,255,255)
					Desc_1.TextSize = 12
					Desc_1.TextTransparency = 0.75
					Desc_1.TextXAlignment = Enum.TextXAlignment.Left

					SelectEffect_1.Name = "SelectEffect"
					SelectEffect_1.Parent = Rows
					SelectEffect_1.AnchorPoint = Vector2.new(0.5, 0.5)
					SelectEffect_1.BackgroundColor3 = Color3.fromRGB(5,120,200)
					SelectEffect_1.BackgroundTransparency = 1
					SelectEffect_1.BorderColor3 = Color3.fromRGB(0,0,0)
					SelectEffect_1.BorderSizePixel = 0
					SelectEffect_1.Position = UDim2.new(0.5, 0,0.5, 0)
					SelectEffect_1.Size = UDim2.new(1, 0,1, 0)
					SelectEffect_1.Image = "rbxassetid://97537830944199"
					SelectEffect_1.ImageColor3 = Color3.fromRGB(5,120,200)
					SelectEffect_1.ImageTransparency = 1

					UICorner_2.Parent = SelectEffect_1
					UICorner_2.CornerRadius = UDim.new(0,5)

					local AssetFrame_1 = Instance.new("Frame")
					local asset_1 = Instance.new("ImageLabel")
					local UIPadding_2 = Instance.new("UIPadding")

					AssetFrame_1.Name = "AssetFrame"
					AssetFrame_1.Parent = Rows
					AssetFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					AssetFrame_1.BackgroundTransparency = 1
					AssetFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
					AssetFrame_1.BorderSizePixel = 0
					AssetFrame_1.Size = UDim2.new(1, 0,1, 0)
					AssetFrame_1.Visible = false

					asset_1.Name = "asset"
					asset_1.Parent = AssetFrame_1
					asset_1.AnchorPoint = Vector2.new(0, 0.5)
					asset_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					asset_1.BackgroundTransparency = 1
					asset_1.BorderColor3 = Color3.fromRGB(0,0,0)
					asset_1.BorderSizePixel = 0
					asset_1.Position = UDim2.new(0, 0,0.5, 0)
					asset_1.Size = UDim2.new(0, 40,0, 40)
					asset_1.ImageTransparency = 0.5

					UIPadding_2.Parent = AssetFrame_1
					UIPadding_2.PaddingLeft = UDim.new(0,5)

					if Icon then
						asset_1.Image = Library:Asset(Icon)
						AssetFrame_1.Visible = true
						UIPadding_1.PaddingLeft = UDim.new(0,50)
					else
						AssetFrame_1.Visible = false
						UIPadding_1.PaddingLeft = UDim.new(0,12)
					end

					if Primary == 'Double' then
						Rows.Size = UDim2.new(0.49, 0,0, 50)
					elseif Primary == 'Single' then
						Rows.Size = UDim2.new(1, 0,0, 50)
					elseif Primary == 'Icon' then
						UIPadding_2.PaddingLeft = UDim.new(0, 0)
						Rows.Size = UDim2.new(0, 103, 0, 103)
						AssetFrame_1.Size = UDim2.new(1,0,1,0)
						asset_1.Size = UDim2.new(0.8, 0, 0.8, 0)
						PaddingFrame_1.Visible = false
						asset_1.AnchorPoint = Vector2.new(0.5, 0.5)
						asset_1.Position = UDim2.new(0.5, 0, 0.5, 0)
					end

					local ClickRows = Library:Button(Rows)

					local function Changed(v)
						if v then
							Library:Tween({
								v = Title_1,
								t = 0.3,
								s = "Exponential",
								d = "Out",
								g = {TextTransparency = 0}
							}):Play()
							Library:Tween({
								v = Desc_1,
								t = 0.3,
								s = "Exponential",
								d = "Out",
								g = {TextTransparency = 0}
							}):Play()
							Desc_1.TextColor3 = Color3.fromRGB(85, 170, 255)
							Library:Tween({
								v = SelectEffect_1,
								t = 0.3,
								s = "Exponential",
								d = "Out",
								g = {ImageTransparency = 0.5}
							}):Play()

							UIStroke_1.Color = Color3.fromRGB(0, 170, 255)

							if Icon then
								Library:Tween({
									v = asset_1,
									t = 0.3,
									s = "Exponential",
									d = "Out",
									g = {ImageTransparency = 0}
								}):Play()
							end

							Desc_1.Text = Advance['Select']
						else
							Library:Tween({
								v = Title_1,
								t = 0.3,
								s = "Exponential",
								d = "Out",
								g = {TextTransparency = 0.5}
							}):Play()
							Desc_1.TextColor3 = Color3.fromRGB(255, 255, 255)
							Library:Tween({
								v = Desc_1,
								t = 0.3,
								s = "Exponential",
								d = "Out",
								g = {TextTransparency = 0.75}
							}):Play()
							Library:Tween({
								v = SelectEffect_1,
								t = 0.3,
								s = "Exponential",
								d = "Out",
								g = {ImageTransparency = 1}
							}):Play()

							UIStroke_1.Color = Color3.fromRGB(55, 56, 58)

							if Icon then
								Library:Tween({
									v = asset_1,
									t = 0.3,
									s = "Exponential",
									d = "Out",
									g = {ImageTransparency = 0.5}
								}):Play()
							end

							Desc_1.Text = Advance['Not Select']
						end
					end

					local function OnSelected()
						if Multi then
							if selectedValues[Title] then
								selectedValues[Title] = nil
								Changed(false)
							else
								selectedValues[Title] = true
								Changed(true)
							end

							local selectedList = {}

							for i, v in pairs(selectedValues) do
								table.insert(selectedList, i)
							end

							if #selectedList > 0 then
								table.sort(selectedList)
								Value = selectedList
								UpdateText()
							else
								SetDesc('N/A')
							end

							pcall(Call, selectedList)
							ElementSignal.OnValueChanged:Fire(selectedList)
						else
							for i,v in pairs(DropdownScrolling:GetChildren()) do
								if v:IsA("Frame") then
									Library:Tween({
										v = v.PaddingFrame.Text.Title,
										t = 0.3,
										s = "Exponential",
										d = "Out",
										g = {TextTransparency = 0.5}
									}):Play()
									v.PaddingFrame.Text.Desc.TextColor3 = Color3.fromRGB(255, 255, 255)
									Library:Tween({
										v = v.PaddingFrame.Text.Desc,
										t = 0.3,
										s = "Exponential",
										d = "Out",
										g = {TextTransparency = 0.75}
									}):Play()
									Library:Tween({
										v = v.SelectEffect,
										t = 0.3,
										s = "Exponential",
										d = "Out",
										g = {ImageTransparency = 1}
									}):Play()

									v.UIStroke.Color = Color3.fromRGB(55, 56, 58)

									if v.AssetFrame.Visible then
										Library:Tween({
											v = v.AssetFrame.asset,
											t = 0.3,
											s = "Exponential",
											d = "Out",
											g = {ImageTransparency = 0.5}
										}):Play()
									end

									v.PaddingFrame.Text.Desc.Text = "Not Select"
								end
							end

							Changed(true)
							Value = Title
							UpdateText()
							pcall(Call, Value)
							ElementSignal.OnValueChanged:Fire(Value)
						end
					end

					delay(0,function()
						if Multi then
							if isValueInTable(Title, Value) then
								selectedValues[Title] = true

								Changed(true)

								local selectedList = {}

								for Title, v in pairs(selectedValues) do
									table.insert(selectedList, Title)
								end

								if #selectedList > 0 then
									UpdateText()
								else
									SetDesc('N/A')
								end

								pcall(Call, selectedList)
								ElementSignal.OnValueChanged:Fire(selectedList)
							end
						else
							if Title == Value then
								Value = Title
								Changed(true)
								UpdateText()
								pcall(Call, Value)
								ElementSignal.OnValueChanged:Fire(Value)
							end
						end
					end)

					ClickRows.MouseButton1Click:Connect(OnSelected)
				end

				if Multi then
					Clear.Visible = true
					All.Visible = true
				else
					Clear.Visible = false
					All.Visible = false
				end

				if Multi then
					ClickClear.MouseButton1Click:Connect(function()
						table.clear(selectedValues)

						for _, v in ipairs(DropdownScrolling:GetChildren()) do
							if v:IsA("Frame") then
								local TextFrame = v:FindFirstChild("PaddingFrame") and v.PaddingFrame:FindFirstChild("Text")
								if not TextFrame then continue end

								local TitleLabel = TextFrame:FindFirstChild("Title")
								local DescLabel = TextFrame:FindFirstChild("Desc")
								local SelectEffect = v:FindFirstChild("SelectEffect")
								local Stroke = v:FindFirstChildOfClass("UIStroke")
								local assetFrame = v:FindFirstChild("AssetFrame")

								if TitleLabel then
									Library:Tween({
										v = TitleLabel, t = 0.3, s = "Exponential", d = "Out",
										g = { TextTransparency = 0.5 }
									}):Play()
								end

								if DescLabel then
									DescLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
									Library:Tween({
										v = DescLabel, t = 0.3, s = "Exponential", d = "Out",
										g = { TextTransparency = 0.75 }
									}):Play()
									DescLabel.Text = Advance['Not Select']
								end

								if SelectEffect then
									Library:Tween({
										v = SelectEffect, t = 0.3, s = "Exponential", d = "Out",
										g = { ImageTransparency = 1 }
									}):Play()
								end

								if Stroke then
									Stroke.Color = Color3.fromRGB(55, 56, 58)
								end

								if assetFrame and assetFrame.Visible then
									local asset = assetFrame:FindFirstChild("asset")
									if asset then
										Library:Tween({
											v = asset, t = 0.3, s = "Exponential", d = "Out",
											g = { ImageTransparency = 0.5 }
										}):Play()
									end
								end
							end
						end

						Value = {}
						UpdateText()
						SetDesc("N/A")
						pcall(Call, Value)
					end)

					ClickAll.MouseButton1Click:Connect(function()
						table.clear(selectedValues)

						for _, v in ipairs(DropdownScrolling:GetChildren()) do
							if v:IsA("Frame") then
								local TextFrame = v:FindFirstChild("PaddingFrame") and v.PaddingFrame:FindFirstChild("Text")
								if not TextFrame then continue end

								local TitleLabel = TextFrame:FindFirstChild("Title")
								local DescLabel = TextFrame:FindFirstChild("Desc")
								local SelectEffect = v:FindFirstChild("SelectEffect")
								local Stroke = v:FindFirstChildOfClass("UIStroke")
								local assetFrame = v:FindFirstChild("AssetFrame")

								local titleName = TitleLabel and TitleLabel.Text or nil
								if titleName then
									selectedValues[titleName] = true
								end

								if TitleLabel then
									Library:Tween({
										v = TitleLabel, t = 0.3, s = "Exponential", d = "Out",
										g = { TextTransparency = 0 }
									}):Play()
								end

								if DescLabel then
									DescLabel.TextColor3 = Color3.fromRGB(85, 170, 255)
									Library:Tween({
										v = DescLabel, t = 0.3, s = "Exponential", d = "Out",
										g = { TextTransparency = 0 }
									}):Play()
									DescLabel.Text = Advance['Select']
								end

								if SelectEffect then
									Library:Tween({
										v = SelectEffect, t = 0.3, s = "Exponential", d = "Out",
										g = { ImageTransparency = 0.5 }
									}):Play()
								end

								if Stroke then
									Stroke.Color = Color3.fromRGB(0, 170, 255)
								end

								if assetFrame and assetFrame.Visible then
									local asset = assetFrame:FindFirstChild("asset")
									if asset then
										Library:Tween({
											v = asset, t = 0.3, s = "Exponential", d = "Out",
											g = { ImageTransparency = 0 }
										}):Play()
									end
								end
							end
						end

						local selectedList = {}
						for name in pairs(selectedValues) do
							table.insert(selectedList, name)
						end

						Value = selectedList
						selectedValues = selectedList
						UpdateText()
						pcall(Call, Value)
						ElementSignal.OnValueChanged:Fire(selectedList)
					end)
				end


				ClickRefresh.MouseButton1Click:Connect(function()
					itemslist:Clear()

					if Multi then
						selectedValues = {}
						Value = selectedValues
					else
						UpdateText()
						SetDesc('N/A')
						Value = Title
					end

					ElementSignal.OnRefresh:Fire(itemslist)
				end)

				for _, name in ipairs(List) do
					itemslist:AddList(name)
				end

				itemslist.OnValueChanged = ElementSignal.OnValueChanged
				itemslist.OnRefresh = ElementSignal.OnRefresh

				local Titles = Raw.Text.Title
				local selfs = {}

				function selfs:SetTitle(a)
					Titles.Text = a
				end

				if Icon then
					function selfs:SetIcon(a)
						local _Icon = Raw.Parent.AssetFrame.asset
						_Icon.Image = Library:Asset(a)
					end
				end

				UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					DropdownScrolling.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 15)
				end)

				return itemslist
			end

			function Class:Slider(new)
				local Title = new.Title
				local Desc = new.Desc or nil
				local Value = new.Value or ""
				local Min = new.Min or 1
				local Max = new.Max or 10
				local IconSize = new.IconSize or 40
				local Rounding = new.Rounding or 0
				local Icon = new.Icon or nil
				local Raw = Library:Row(ScrollingPAGE_1, Title, Desc, 0.475, Icon, IconSize)
				local Callback = new.Call or function() return end

				local selfs = {}
				local ElementSignal = Signal.new()
				selfs.OnValueChanged = ElementSignal

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
				local Slide = Library:Button(Raw.Parent)

				Slide.AnchorPoint = Vector2.new(1, 0)
				Slide.Position = UDim2.new(1, 0, 0, 0)
				Slide.Size = UDim2.new(0.5, 0, 1, 0)

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
				Color_1.BackgroundColor3 = Color3.fromRGB(5,120,200)
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
					for _, v in pairs(Main_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end

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
					ElementSignal:Fire(value)
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
					ElementSignal:Fire(value)
				end)

				local dragging = false

				Slide.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						ScrollingPAGE_1.ScrollingEnabled = false
						move(input)
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						move(input)
					end
				end)

				UserInputService.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						if dragging then
							dragging = false
							ScrollingPAGE_1.ScrollingEnabled = true
						end
					end
				end)

				local Titles = Raw.Text.Title

				function selfs:SetTitle(a)
					Titles.Text = a
				end

				if Desc then
					local Descs = Raw.Text.Desc

					function selfs:SetDesc(a)
						Descs.Text = a
					end
				end

				if Icon then
					function selfs:SetIcon(a)
						local _Icon = Raw.Parent.AssetFrame.asset

						_Icon.Image = Library:Asset(a)
					end
				end

				function selfs:ChangeValue(value)
					Value = value
					updateSlider(Value)
					ElementSignal:Fire(value)
				end

				return selfs
			end

			function Class:Banner(new)
				local Banner = new.Banner or "rbxassetid://130155603088446"
				local SizeY = new.Size or 200

				local Rows = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local UIStroke_1 = Instance.new("UIStroke")
				local Banner_1 = Instance.new("ImageLabel")
				local UIPadding_1 = Instance.new("UIPadding")

				Rows.Name = "Rows"
				Rows.Parent = ScrollingPAGE_1
				Rows.AutomaticSize = Enum.AutomaticSize.Y
				Rows.BackgroundColor3 = Color3.fromRGB(37,37,38)
				Rows.BorderColor3 = Color3.fromRGB(0,0,0)
				Rows.BorderSizePixel = 0
				Rows.Size = UDim2.new(1, 0,0, 50)

				UICorner_1.Parent = Rows
				UICorner_1.CornerRadius = UDim.new(0,5)

				UIStroke_1.Parent = Rows
				UIStroke_1.Color = Color3.fromRGB(55,56,58)
				UIStroke_1.Thickness = 0.75

				Banner_1.Name = "Banner"
				Banner_1.Parent = Rows
				Banner_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Banner_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Banner_1.BorderSizePixel = 0
				Banner_1.Size = UDim2.new(1, 0,0, SizeY)
				Banner_1.Image = Library:Asset(Banner)
				Banner_1.ScaleType = Enum.ScaleType.Crop

				UIPadding_1.Parent = Rows
				UIPadding_1.PaddingBottom = UDim.new(0,10)
				UIPadding_1.PaddingLeft = UDim.new(0,10)
				UIPadding_1.PaddingRight = UDim.new(0,10)
				UIPadding_1.PaddingTop = UDim.new(0,10)
			end

			ScrollingPAGE_1.CanvasPosition = Vector2.new(0, 0)

			return Class
		end

		function Element:Select()
			for _, v in pairs(Page_1:GetChildren()) do
				if v.Name == 'AddPage' then
					v.Visible = false
				end
			end

			AddPage.Visible = true
			UIPageLayout_1:JumpTo(AddPage)
		end

		return Element
	end

	return Tabs
end

return Library
