local Config = {
	Text = "Moon Hub Exploit Beyond Limits",
	TextColor = Color3.fromRGB(255, 255, 255),
	TextStrokeColor = Color3.fromRGB(0, 0, 0),
	TextStrokeThickness = 2,
	BackgroundTransparency = 0.5,
	BackgroundColor = Color3.fromRGB(15, 15, 15),
	PanelColor = Color3.fromRGB(30, 30, 30),
	PanelTransparency = 0.2,
	AccentColor = Color3.fromRGB(100, 150, 255),
	SpinnerImage = "rbxassetid://5997493433",
	SpinnerSpeed = 2,
	ProgressBarHeight = 8,
	ProgressBarWidth = 250,
	CornerRadius = UDim.new(0, 12),
	Font = Enum.Font.GothamBold,
	TextSize = 28,
	FadeOutDuration = 0.5,
}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ContentProvider = game:GetService("ContentProvider")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MoonHubLoading"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local background = Instance.new("Frame")
background.Name = "Background"
background.Size = UDim2.fromScale(1, 1)
background.BackgroundColor3 = Config.BackgroundColor
background.BackgroundTransparency = Config.BackgroundTransparency
background.BorderSizePixel = 0
background.Parent = screenGui

local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.fromScale(0.5, 0.5)
panel.Size = UDim2.fromOffset(400, 200)
panel.BackgroundColor3 = Config.PanelColor
panel.BackgroundTransparency = Config.PanelTransparency
panel.BorderSizePixel = 0
panel.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = Config.CornerRadius
corner.Parent = panel

local spinner = Instance.new("ImageLabel")
spinner.Name = "Spinner"
spinner.AnchorPoint = Vector2.new(0.5, 0)
spinner.Position = UDim2.fromScale(0.5, 0.25)
spinner.Size = UDim2.fromOffset(50, 50)
spinner.BackgroundTransparency = 1
spinner.Image = Config.SpinnerImage
spinner.ImageColor3 = Config.AccentColor
spinner.Parent = panel

local title = Instance.new("TextLabel")
title.Name = "Title"
title.AnchorPoint = Vector2.new(0.5, 0.5)
title.Position = UDim2.fromScale(0.5, 0.55)
title.Size = UDim2.fromOffset(300, 40)
title.BackgroundTransparency = 1
title.Text = Config.Text
title.TextColor3 = Config.TextColor
title.Font = Config.Font
title.TextSize = Config.TextSize
title.TextStrokeTransparency = 0
title.TextStrokeColor3 = Config.TextStrokeColor
title.TextScaled = true
title.Parent = panel

local progressBackground = Instance.new("Frame")
progressBackground.Name = "ProgressBackground"
progressBackground.AnchorPoint = Vector2.new(0.5, 0)
progressBackground.Position = UDim2.fromScale(0.5, 0.75)
progressBackground.Size = UDim2.fromOffset(Config.ProgressBarWidth, Config.ProgressBarHeight)
progressBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
progressBackground.BackgroundTransparency = 0.3
progressBackground.BorderSizePixel = 0
progressBackground.Parent = panel

local progressCorner = Instance.new("UICorner")
progressCorner.CornerRadius = UDim.new(0, Config.ProgressBarHeight / 2)
progressCorner.Parent = progressBackground

local progressFill = Instance.new("Frame")
progressFill.Name = "ProgressFill"
progressFill.Size = UDim2.fromScale(0, 1)
progressFill.BackgroundColor3 = Config.AccentColor
progressFill.BackgroundTransparency = 0
progressFill.BorderSizePixel = 0
progressFill.Parent = progressBackground

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, Config.ProgressBarHeight / 2)
fillCorner.Parent = progressFill

local function rotateSpinner()
	local startTime = tick()
	RunService.RenderStepped:Connect(function()
		local elapsed = tick() - startTime
		spinner.Rotation = (elapsed * 360 * Config.SpinnerSpeed) % 360
	end)
end

rotateSpinner()

local initialQueueSize
local queueSizeUpdated = false
local loadingCompleted = false

local function updateProgress()
	if loadingCompleted then
		progressFill.Size = UDim2.fromScale(1, 1)
		return
	end
	local currentQueue = ContentProvider.RequestQueueSize
	if not queueSizeUpdated then
		initialQueueSize = currentQueue
		queueSizeUpdated = true
	end
	if initialQueueSize and initialQueueSize > 0 then
		local fraction = math.clamp(1 - (currentQueue / initialQueueSize), 0, 1)
		progressFill.Size = UDim2.fromScale(fraction, 1)
	else
		progressFill.Size = UDim2.fromScale(0, 1)
	end
end

local function onAssetLoaded(assetId, status)
	updateProgress()
end

ContentProvider.AssetFetchFinished:Connect(onAssetLoaded)

RunService.Heartbeat:Connect(function()
	if not queueSizeUpdated then
		updateProgress()
	end
end)

local function finishLoading()
	loadingCompleted = true
	updateProgress()
	local tweenInfo = TweenInfo.new(Config.FadeOutDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local goals = {
		BackgroundTransparency = 1,
	}
	local panelGoals = {
		BackgroundTransparency = 1,
	}
	local spinnerGoals = {
		ImageTransparency = 1,
	}
	local titleGoals = {
		TextTransparency = 1,
		TextStrokeTransparency = 1,
	}
	local progressBgGoals = {
		BackgroundTransparency = 1,
	}
	local progressFillGoals = {
		BackgroundTransparency = 1,
	}

	local fadeTweenBg = TweenService:Create(background, tweenInfo, goals)
	local fadeTweenPanel = TweenService:Create(panel, tweenInfo, panelGoals)
	local fadeTweenSpinner = TweenService:Create(spinner, tweenInfo, spinnerGoals)
	local fadeTweenTitle = TweenService:Create(title, tweenInfo, titleGoals)
	local fadeTweenProgressBg = TweenService:Create(progressBackground, tweenInfo, progressBgGoals)
	local fadeTweenProgressFill = TweenService:Create(progressFill, tweenInfo, progressFillGoals)

	fadeTweenBg:Play()
	fadeTweenPanel:Play()
	fadeTweenSpinner:Play()
	fadeTweenTitle:Play()
	fadeTweenProgressBg:Play()
	fadeTweenProgressFill:Play()

	fadeTweenBg.Completed:Wait()
	screenGui:Destroy()
end

local checkLoaded
checkLoaded = RunService.Heartbeat:Connect(function()
	if game:IsLoaded() and ContentProvider.RequestQueueSize == 0 and not loadingCompleted then
		checkLoaded:Disconnect()
		finishLoading()
	end
end)

if game:IsLoaded() and ContentProvider.RequestQueueSize == 0 then
	checkLoaded:Disconnect()
	finishLoading()
end

local players = game:GetService("Players")
local player = players.LocalPlayer
local user = player.Name
local display = player.DisplayName

local info = {
    ['Username'] = user,
    ['Nickname'] = display,
    ['lvl'] = player:WaitForChild("Data"):WaitForChild("Level").Value,
    ['beli'] = player:WaitForChild("Data"):WaitForChild("Beli").Value,
    ['race'] = player:WaitForChild("Data"):WaitForChild("Race").Value,
    ['statsref'] = player:WaitForChild("Data"):WaitForChild("StatRefunds").Value,
    ['exp'] = player:WaitForChild("Data"):WaitForChild("Exp").Value,
    ['frags'] = player:WaitForChild("Data"):WaitForChild("Fragments").Value,
    ['DefenseStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Defense"):WaitForChild("Level").Value,
    ['MeleStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Melee"):WaitForChild('Level').Value,
    ['GunStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild('Gun'):WaitForChild('Level').Value,
    ['SwordStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild('Sword'):WaitForChild('Level').Value,
    ['FruitStats'] = player:WaitForChild("Data"):WaitForChild("Stats"):WaitForChild("Demon Fruit"):WaitForChild('Level').Value
}

print(info) -- dont change

local eFolder = game.Workspace:WaitForChild("Enemies")

local admins={
    [1] = 'zioles' or 'rip_zioles',
    [2] = 'Uzoth',
    [3] = 'EnyuZee',
    owners = {
     [1] = 'rip_indra' or 'indra',
     [2] = 'mygame43'
    }
}

local indraIslandCFrame = "-26738.748, 7.49961281, 406.11734, 0.245676473, -4.41590089e-08, 0.969351888, 5.56688136e-08, 1, 3.14462589e-08, -0.969351888, 4.62370622e-08, 0.245676473"
