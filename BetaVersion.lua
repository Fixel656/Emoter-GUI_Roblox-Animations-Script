--[[Script by Fixel, based on Energize GUI by illremember
DO NOT COPY AND CLAIM AS YOUR OWN, if you are using some of the script for your own, 
credit is highly appreciated!]]

local ScriptVersion = 5.991
local IsBetaBuild = true
local LatestVersion = nil
local LatestBetaVersion = nil

local Player = game.Players.LocalPlayer
local IsInStudio = game:GetService("RunService"):IsStudio()
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ContextActionService = game:GetService("ContextActionService")

local ConnectedToGithub = true
local GuiActive = true
local GuiEmoter = nil
local FileErrors = false --A value that shows if there's any error while loading animation files. If true, there will be a notification to warn user
local AnimationHandler = "Animate"
local LoadingState = "nil"

--Settings & Stats
local LastUsedVersion = ScriptVersion
local LastCheckedBeta = 0.0
local LaunchedTimes = 0
local TotalTimeUsed = 0 --Unused for now, i'm not even sure i can make this feature working right
local ChkValues = {NewBetaNotice = false}

local AnimPreviewEnabled = true
local DebugInfoEnabled = false
local AnalyticsEnabled = true
local LoadAnimationsOnRestart = true
local LoadAllAnimationsOnRestart = false
local TopMost = false
local LaunchBetaBuild = false
local SpecCategoryOnLaunch = true

local ToolAnimHighPriorEnabled = true
local ToolIdleAnimHighPriorEnabled = false
local ToolActionAnimHighPriorEnabled = true
local AnimSwitchModeEnabled = true
local AnimSwitchModeRunIdleExceptionEnabled = true
local BundleAnimSwitchModeEnabled = true
local AnimSmoothFadeEnabled = true
local HigherPriorityEnabled = false

local IdleTypeEnabled = true
local RunningTypeEnabled = true
local RunningTypeStopStandingEnabled = true
local RunningTypeCharSpeedEnabled = true
local RunningTypeMinSpeedEnabled = true
local RunningTypeStopJumpingEnabled = true
local RunningTypeStopClimbingEnabled = true

local Theme = "LightPurple"
local UIGradientEnabled = true
local UICornerEnabled = true
local XSize = 460
local YSize = 285
local DragDelay = 0.1

local LoadGithubSGAEnabled = true
local LoadGithubCustomAnimsEnabled = true
local LoadLocalSGAEnabled = true
local LoadLocalCustomAnimsEnabled = true

local HotkeysEnabled = true
local DoubleHotkey = Instance.new("StringValue")
local EmoteWheelHotkey = Instance.new("StringValue")
local SearchHotkey = Instance.new("StringValue")
local CloseHotkey = Instance.new("StringValue")
local SitHotkey = Instance.new("StringValue")
local SwitchAnimHotkey = Instance.new("StringValue")
local AnimFadeHotkey = Instance.new("StringValue")
local SettingsHotkey = Instance.new("StringValue")
local StopAnimsHotkey = Instance.new("StringValue")
local ResetCharHotkey = Instance.new("StringValue")

CloseHotkey.Value = "T"
SettingsHotkey.Value = "Y"
SearchHotkey.Value = "DoubleH"
SitHotkey.Value = "J"
SwitchAnimHotkey.Value = "V"
StopAnimsHotkey.Value = "N"
AnimFadeHotkey.Value = "B"
ResetCharHotkey.Value = "DoubleR"

DoubleHotkey.Value = "LeftControl" --A secondary key for activating a DoubleHotkey
EmoteWheelHotkey.Value = "Comma" --Not affected by "Hotkeys Enabled" setting

local NotificationsSystem
local function CreateNotificationsFrame()
	if IsInStudio then
		if game.Players.LocalPlayer.PlayerGui:FindFirstChild("EmoterNotificationSystem") then NotificationsSystem = game.Players.LocalPlayer.PlayerGui:FindFirstChild("EmoterNotificationSystem") return end
	else
		if game.CoreGui:FindFirstChild("EmoterNotificationSystem") then NotificationsSystem = game.CoreGui:FindFirstChild("EmoterNotificationSystem") return end
	end

	local NotificationsGui = Instance.new("ScreenGui")
	NotificationsGui.Name = "EmoterNotificationSystem"
	if IsInStudio then
		NotificationsGui.Parent = game.Players.LocalPlayer.PlayerGui
	else
		NotificationsGui.Parent = game.CoreGui
	end

	local NotificationsFrame = Instance.new("Frame")
	NotificationsFrame.Parent = NotificationsGui
	NotificationsFrame.Name = "Notifications"
	NotificationsFrame.AnchorPoint = Vector2.new(1, 1)
	NotificationsFrame.Size = UDim2.new(0, 300, 0, 1000)
	NotificationsFrame.BackgroundTransparency = 1
	NotificationsFrame.Position = UDim2.new(1, -10, 1, -56)

	local UIListLayout2 = Instance.new("UIListLayout")
	UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.Padding = UDim.new(0, 8)
	UIListLayout2.Parent = NotificationsFrame

	local UIScale = Instance.new("UIScale")
	UIScale.Scale = 0.95
	UIScale.Parent = NotificationsFrame

	NotificationsSystem = NotificationsGui
end
CreateNotificationsFrame()

function Notify(data)
	task.spawn(function()
		local NotificationsFrame = NotificationsSystem.Notifications
		local Closed = false

		-- Notification Object Creation
		local Notification = Instance.new("Frame")
		Notification.Name = data.Title or 'Notification'
		Notification.Size = UDim2.new(1, 0, 0, 800)
		Notification.BackgroundTransparency = 1
		Notification.Parent = NotificationsFrame
		Notification.LayoutOrder = #NotificationsFrame:GetChildren() - 2
		Notification.Visible = false

		local Main = Instance.new("Frame")
		Main.Name = "Main"
		Main.Size = UDim2.new(1, 0, 1, -28)
		Main.BackgroundTransparency = 0.45
		Main.BorderSizePixel = 0
		Main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
		Main.Parent = Notification

		local UICorner = Instance.new("UICorner")
		UICorner.CornerRadius = UDim.new(0, 5)
		UICorner.Parent = Main
		local UIStroke = Instance.new("UIStroke")
		UIStroke.Color = Color3.fromRGB(240, 240, 240)
		UIStroke.Transparency = 0.9
		UIStroke.Parent = Main

		local Icon = Instance.new("ImageLabel")
		Icon.Name = "Icon"
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.Size = UDim2.new(0, 40, 0, 40)
		Icon.BackgroundTransparency = 1
		Icon.Position = UDim2.new(0, 10, 0.5, 0)
		Icon.Image = ""
		Icon.Parent = Main

		local Title = Instance.new("TextLabel")
		Title.Name = "Title"
		Title.ZIndex = 105
		Title.Size = UDim2.new(1, -69, 0, 16)
		Title.BackgroundTransparency = 1
		Title.Position = UDim2.new(0, 60, 0, 12)
		Title.TextTruncate = Enum.TextTruncate.SplitWord
		Title.TextSize = 17
		Title.RichText = true
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextWrapped = true
		Title.Font = Enum.Font.Roboto
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.Parent = Main
		local TitleUIPadding = Instance.new("UIPadding")
		TitleUIPadding.Parent = Title

		local Description = Instance.new("TextLabel")
		Description.Name = "Description"
		Description.ZIndex = 105
		Description.Size = UDim2.new(1, -69, 1, -40)
		Description.BackgroundTransparency = 1
		Description.Position = UDim2.new(0, 60, 0, 34)
		Description.TextSize = 15
		Description.RichText = true
		Description.TextColor3 = Color3.fromRGB(255, 255, 255)
		Description.TextYAlignment = Enum.TextYAlignment.Top
		Description.TextWrapped = true
		Description.Font = Enum.Font.Roboto
		Description.TextTransparency = 0.15
		Description.TextXAlignment = Enum.TextXAlignment.Left
		Description.Parent = Main

		local Close = Instance.new("TextButton")
		Close.Name = "Close"
		Close.ZIndex = 125
		Close.AnchorPoint = Vector2.new(1, 0)
		Close.Size = UDim2.new(0, 20, 0, 20)
		Close.BackgroundTransparency = 1
		Close.Position = UDim2.new(1, -3, 0, 3)
		Close.TextColor3 = Color3.fromRGB(255, 255, 255)
		Close.Text = "X"
		Close.Font = Enum.Font.FredokaOne
		Close.TextTransparency = 0.3
		Close.TextScaled = true
		Close.Parent = Main

		local Buttons = Instance.new("Frame")
		Buttons.Name = "Buttons"
		Buttons.AnchorPoint = Vector2.new(0, 1)
		Buttons.Size = UDim2.new(1, 0, 0, 25)
		Buttons.BackgroundTransparency = 1
		Buttons.Position = UDim2.new(0, 0, 1, -1)
		Buttons.Parent = Notification

		local Choice1 = Instance.new("TextButton")
		Choice1.Name = "Choice1"
		Choice1.Size = UDim2.new(0.5, -1, 1, 0)
		Choice1.BackgroundTransparency = 0.45
		Choice1.BorderSizePixel = 0
		Choice1.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Choice1.TextSize = 14
		Choice1.RichText = true
		Choice1.TextColor3 = Color3.fromRGB(255, 255, 255)
		Choice1.Font = Enum.Font.Roboto
		Choice1.Parent = Buttons

		local UICorner1 = Instance.new("UICorner")
		UICorner1.CornerRadius = UDim.new(0, 5)
		UICorner1.TopRightRadius = UDim.new(0, 0)
		UICorner1.BottomRightRadius = UDim.new(0, 0)
		UICorner1.Parent = Choice1

		local UIStroke1 = Instance.new("UIStroke")
		UIStroke1.Color = Color3.fromRGB(255, 255, 255)
		UIStroke1.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke1.Transparency = 0.9
		UIStroke1.Parent = Choice1

		local Choice2 = Instance.new("TextButton")
		Choice2.Name = "Choice2"
		Choice2.AnchorPoint = Vector2.new(1, 0)
		Choice2.Size = UDim2.new(0.5, -1, 1, 0)
		Choice2.BackgroundTransparency = 0.45
		Choice2.Position = UDim2.new(1, 0, 0, 0)
		Choice2.BorderSizePixel = 0
		Choice2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Choice2.TextSize = 14
		Choice2.RichText = true
		Choice2.TextColor3 = Color3.fromRGB(255, 255, 255)
		Choice2.Font = Enum.Font.Roboto
		Choice2.Parent = Buttons

		local UICorner2 = Instance.new("UICorner")
		UICorner2.CornerRadius = UDim.new(0, 5)
		UICorner2.TopLeftRadius = UDim.new(0, 0)
		UICorner2.BottomLeftRadius = UDim.new(0, 0)
		UICorner2.Parent = Choice2
		local UIStroke2 = Instance.new("UIStroke")
		UIStroke2.Color = Color3.fromRGB(255, 255, 255)
		UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke2.Transparency = 0.9
		UIStroke2.Parent = Choice2
		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.HorizontalFlex = Enum.UIFlexAlignment.Fill
		UIListLayout.Padding = UDim.new(0, 2)
		UIListLayout.Parent = Buttons
		local UIListLayout1 = Instance.new("UIListLayout")
		UIListLayout1.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout1.VerticalAlignment = Enum.VerticalAlignment.Bottom
		UIListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout1.Padding = UDim.new(0, 2)
		UIListLayout1.Parent = Notification

		-- Set Data
		local Main = Notification.Main
		Title.Text = "<b>"..data.Title.."</b>" or "<b>Title</b>"
		Description.Text = data.Text or "Сontent"
		Close.Visible = false

		-- Set Ui values
		Main.BackgroundTransparency = 1
		Title.TextTransparency = 1
		Description.TextTransparency = 1
		Main.UIStroke.Transparency = 1
		Icon.ImageTransparency = 1
		Icon.BackgroundTransparency = 1
		Buttons.Choice1.BackgroundTransparency = 1
		Buttons.Choice1.TextTransparency = 1
		Buttons.Choice2.BackgroundTransparency = 1
		Buttons.Choice2.TextTransparency = 1
		Buttons.Choice1.UIStroke.Transparency = 1
		Buttons.Choice2.UIStroke.Transparency = 1
		task.wait()

		local OrderChange
		OrderChange = NotificationsFrame.ChildRemoved:Connect(function()
			Notification.LayoutOrder = Notification.LayoutOrder - 1
		end)

		local function CloseWindow()
			Closed = true
			Notification.Interactable = false
			game:GetService("TweenService"):Create(Close, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			game:GetService("TweenService"):Create(Main.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			game:GetService("TweenService"):Create(Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			task.wait(0.05)
			game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 1}):Play()
			task.wait(0.05)
			game:GetService("TweenService"):Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			game:GetService("TweenService"):Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()

			game:GetService("TweenService"):Create(Buttons.Choice1, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			game:GetService("TweenService"):Create(Buttons.Choice2, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 1}):Play()
			game:GetService("TweenService"):Create(Buttons.Choice1, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			game:GetService("TweenService"):Create(Buttons.Choice2, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 1}):Play()
			game:GetService("TweenService"):Create(Buttons.Choice1.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			game:GetService("TweenService"):Create(Buttons.Choice2.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 1}):Play()
			task.wait(0.15)
			game:GetService("TweenService"):Create(Buttons, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 0)}):Play()
			game:GetService("TweenService"):Create(Notification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, -NotificationsFrame:FindFirstChild("UIListLayout").Padding.Offset)}):Play()
			task.wait(0.6)

			Notification.Visible = false
			OrderChange:Disconnect()
			Notification:Destroy()
		end

		if data.Image then
			Icon.Image = "rbxassetid://" .. data.Image
		else
			Icon.Visible = false
			Title.Size = UDim2.new(1, -22,0, 16)
			Title.Position = UDim2.new(0, 12,0, 12)
			Title.TextXAlignment = Enum.TextXAlignment.Center
			Description.Size = UDim2.new(1, -22,1, -40)
			Description.Position = UDim2.new(0, 12,0, 34)
			Description.TextXAlignment = Enum.TextXAlignment.Center
		end
		if data.Sound then
			local Sound = Instance.new("Sound", Notification)
			Sound.SoundId = "rbxassetid://" .. data.Sound
			Sound.Volume = 0.5
			Sound:Play()
		end
		if data.Choice1Text or data.Choice2Text then
			if data.Choice1Text then
				Buttons.Choice1.Text = data.Choice1Text
				Buttons.Choice1.MouseButton1Click:Connect(function()
					CloseWindow()
					data.Choice1Function()
				end)
			end
			if data.Choice2Text then
				Buttons.Choice2.Text = data.Choice2Text
				Buttons.Choice2.MouseButton1Click:Connect(function()
					CloseWindow()
					data.Choice2Function()
				end)
			else
				Buttons.Choice2.Visible = false
				Buttons.Choice1.UICorner.BottomRightRadius = UDim.new(0,5)
				Buttons.Choice1.UICorner.TopRightRadius = UDim.new(0,5)
			end
		else
			Buttons.Visible = false
			Buttons.Size = UDim2.new(1, 0, 0, -2)
			Main.Size = UDim2.new(1, 0, 1, 0)
		end

		Notification.Visible = true

		Main.MouseEnter:Connect(function()
			Title.Size = Title.Size - UDim2.new(0, 11, 0, 0)
			if not data.Image then
				Title.UIPadding.PaddingLeft = UDim.new(0, 11)
			end
			Close.Visible = true
		end)
		Main.MouseLeave:Connect(function()
			Title.Size = Title.Size + UDim2.new(0, 11, 0, 0)
			if not data.Image then
				Title.UIPadding.PaddingLeft = UDim.new(0, 0)
			end
			Close.Visible = false
		end)
		Close.MouseButton1Click:Connect(function()
			CloseWindow()
		end)

		-- Calculate textbounds and set initial values
		local bounds = {Title.TextBounds.Y, Description.TextBounds.Y, Buttons.Size.Y.Offset + 2}
		Notification.Size = UDim2.new(1, 0, 0, -NotificationsFrame:FindFirstChild("UIListLayout").Padding.Offset)
		Buttons.Size = UDim2.new(1, 0, 0, 0)
		--Popup
		game:GetService("TweenService"):Create(Notification, TweenInfo.new(0.6, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, math.max(bounds[1] + bounds[2] + bounds[3] + 31, 60))}):Play()
		game:GetService("TweenService"):Create(Buttons, TweenInfo.new(0.7, Enum.EasingStyle.Exponential), {Size = UDim2.new(1, 0, 0, 25)}):Play()
		task.wait(0.05)
		game:GetService("TweenService"):Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.35}):Play()
		game:GetService("TweenService"):Create(Title, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		task.wait(0.05)
		game:GetService("TweenService"):Create(Icon, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {ImageTransparency = 0}):Play()
		task.wait(0.05)
		game:GetService("TweenService"):Create(Description, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		game:GetService("TweenService"):Create(Main.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.9}):Play()
		game:GetService("TweenService"):Create(Close, TweenInfo.new(0.3, Enum.EasingStyle.Exponential), {TextTransparency = 0.3}):Play()

		game:GetService("TweenService"):Create(Buttons.Choice1, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.35}):Play()
		game:GetService("TweenService"):Create(Buttons.Choice2, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {BackgroundTransparency = 0.35}):Play()
		game:GetService("TweenService"):Create(Buttons.Choice1, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		game:GetService("TweenService"):Create(Buttons.Choice2, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {TextTransparency = 0}):Play()
		game:GetService("TweenService"):Create(Buttons.Choice1.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.9}):Play()
		game:GetService("TweenService"):Create(Buttons.Choice2.UIStroke, TweenInfo.new(0.4, Enum.EasingStyle.Exponential), {Transparency = 0.9}):Play()

		if data.Title == "Loading data..." then --Case for loading notification
			while wait() do
				if LoadingState == "Loaded" or LoadingState == "LaunchingBeta" then
					CloseWindow()
					return
				end
			end
		end

		if data.Time ~= false then
			local AutoWaitTime = math.min(math.max((#Description.Text * 0.05) + 2.5, 3), 10)
			task.wait(data.Time or AutoWaitTime)
		else
			while not Closed do
				if Closed then return end
				wait(1)
			end
		end

		if Closed then return end
		CloseWindow()
	end)
end

Notify({Title = "Loading data...", Text = "Please wait for Emoter to load...", Time = 3})

print("Getting Emoter Metadata...")
LoadingState = "Preloading"
if AnalyticsEnabled and not IsInStudio then task.spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/Documentations%20%26%20Changelogs/CountHandler.lua",true))() end) end
-- P.S. This CountHandler made to see how many people are using this script and does NOT collect any other data. BUT if you let AnalyticsEnabled setting enabled you will get rid of one bug where specific settings couldn't load on first script execution
if not IsInStudio then
	local MetadataSuccess, MetadataContent = pcall(function()
		return game:HttpGet("https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/Metadata.json")
	end)
	if not MetadataSuccess or MetadataContent == "404: Not Found" then
		if DebugInfoEnabled then warn("[AdditionalAnims File]: An error ocurred while trying to connect to GitHub and get metadata") end
		ConnectedToGithub = false
	else
		local MetadataSuccess2, MetadataData = pcall(function()
			return HttpService:JSONDecode(MetadataContent)
		end)
		LatestVersion = MetadataData["LatestVersion"]
		LatestBetaVersion = MetadataData["LatestBetaVersion"]
	end
end

--Loading & Saving
LoadingState = "Loading Settings"
local IsDefaultSettings = true
local ConfigFile = "EmoterData/EmoterConfig.json"
local function LoadData()
	if not IsInStudio then
		local success, files = pcall(listfiles, "EmoterData") --A test made to avoid an error when listfiles() isn't working in first time

		local targetNumber = tostring(game.GameId)
		local folderPath = "EmoterData/SpecificSettings"
		local fileFound = false
		local success, files = pcall(listfiles, folderPath)
		if success then
			for _, filePath in ipairs(files) do
				local fileName = filePath:match("[^/\\]+$") or filePath
				local extractedNumber = fileName:match("(%d+)")

				if extractedNumber then
					if extractedNumber == targetNumber then
						fileFound = true
						ConfigFile = filePath
						IsDefaultSettings = false
						print("Found settings specifically for this game, loading...")
						break
					end
				end
			end
		end

		if isfile("EmoterData/Stats_DoNotDelete") then
			local rawData = readfile("EmoterData/Stats_DoNotDelete")
			local DecodedSettings = HttpService:JSONDecode(rawData)

			LastUsedVersion = tonumber(DecodedSettings.ConfLastUsedVersion)
			LastCheckedBeta = tonumber(DecodedSettings.ConfLastCheckedBeta)
			LaunchedTimes = tonumber(DecodedSettings.ConfLaunchedTimes)
			TotalTimeUsed = tonumber(DecodedSettings.ConfTotalTimeUsed)
			ChkValues = DecodedSettings.ConfChkValues
		elseif isfile("EmoterData/EmoterConfig.json") then --Leave here for compatibility with old versions
			local rawData = readfile("EmoterData/EmoterConfig.json")
			local DecodedSettings = HttpService:JSONDecode(rawData)
			if DecodedSettings.ConfLastUsedVersion then LastUsedVersion = tonumber(DecodedSettings.ConfLastUsedVersion) else LastUsedVersion = 5.5 end
			if DecodedSettings.ConfLaunchedTimes then LaunchedTimes = tonumber(DecodedSettings.ConfLaunchedTimes) end
			if DecodedSettings.ConfTotalTimeUsed then TotalTimeUsed = tonumber(DecodedSettings.ConfTotalTimeUsed) end
		end

		if isfile(ConfigFile) then
			local rawData = readfile(ConfigFile)
			local DecodedSettings = HttpService:JSONDecode(rawData)

			AnimPreviewEnabled = DecodedSettings.ConfAnimPreviewEnabled
			DebugInfoEnabled = DecodedSettings.ConfDebugInfoEnabled
			AnalyticsEnabled = DecodedSettings.ConfAnalyticsEnabled
			LoadAnimationsOnRestart = DecodedSettings.ConfLoadAnimationsOnRestart
			LoadAllAnimationsOnRestart = DecodedSettings.ConfLoadAllAnimationsOnRestart
			TopMost = DecodedSettings.ConfTopMost
			if DecodedSettings.ConfDragDelay then DragDelay = DecodedSettings.ConfDragDelay end
			if DecodedSettings.ConfLaunchBetaBuild then LaunchBetaBuild = DecodedSettings.ConfLaunchBetaBuild end
			SpecCategoryOnLaunch = DecodedSettings.ConfSpecCategoryOnLaunch

			ToolIdleAnimHighPriorEnabled = DecodedSettings.ConfToolIdleAnimHighPriorEnabled
			ToolActionAnimHighPriorEnabled = DecodedSettings.ConfToolActionAnimHighPriorEnabled
			AnimSwitchModeEnabled = DecodedSettings.ConfAnimSwitchModeEnabled
			AnimSwitchModeRunIdleExceptionEnabled = DecodedSettings.ConfAnimSwitchModeRunIdleExceptionEnabled
			BundleAnimSwitchModeEnabled = DecodedSettings.ConfBundleAnimSwitchModeEnabled
			AnimSmoothFadeEnabled = DecodedSettings.ConfAnimSmoothFadeEnabled
			HigherPriorityEnabled = DecodedSettings.ConfHigherPriorityEnabled

			IdleTypeEnabled = DecodedSettings.ConfIdleTypeEnabled
			RunningTypeEnabled = DecodedSettings.ConfRunningTypeEnabled
			RunningTypeStopStandingEnabled = DecodedSettings.ConfRunningTypeStopStandingEnabled
			RunningTypeCharSpeedEnabled = DecodedSettings.ConfRunningTypeCharSpeedEnabled
			RunningTypeMinSpeedEnabled = DecodedSettings.ConfRunningTypeMinSpeedEnabled
			RunningTypeStopJumpingEnabled = DecodedSettings.ConfRunningTypeStopJumpingEnabled
			RunningTypeStopClimbingEnabled = DecodedSettings.ConfRunningTypeStopClimbingEnabled

			Theme = DecodedSettings.ConfTheme
			UIGradientEnabled = DecodedSettings.ConfUIGradientEnabled
			UICornerEnabled = DecodedSettings.ConfUICornerEnabled
			XSize = DecodedSettings.ConfXSize
			YSize = DecodedSettings.ConfYSize

			LoadGithubSGAEnabled = DecodedSettings.ConfLoadGithubSGAEnabled
			LoadGithubCustomAnimsEnabled = DecodedSettings.ConfLoadGithubCustomAnimsEnabled
			LoadLocalSGAEnabled = DecodedSettings.ConfLoadLocalSGAEnabled
			LoadLocalCustomAnimsEnabled = DecodedSettings.ConfLoadLocalCustomAnimsEnabled

			HotkeysEnabled = DecodedSettings.ConfHotkeysEnabled
			if DecodedSettings.ConfDoubleHotkey then DoubleHotkey.Value = tostring(DecodedSettings.ConfDoubleHotkey) end
			if DecodedSettings.ConfEmoteWheelHotkey then EmoteWheelHotkey.Value = tostring(DecodedSettings.ConfEmoteWheelHotkey) end
			if DecodedSettings.ConfCloseHotkey then CloseHotkey.Value = tostring(DecodedSettings.ConfCloseHotkey) end
			if DecodedSettings.ConfSettingsHotkey then SettingsHotkey.Value = tostring(DecodedSettings.ConfSettingsHotkey) end
			if DecodedSettings.ConfSearchHotkey then SearchHotkey.Value = tostring(DecodedSettings.ConfSearchHotkey) end
			if DecodedSettings.ConfSitHotkey then SitHotkey.Value = tostring(DecodedSettings.ConfSitHotkey) end
			if DecodedSettings.ConfSwitchAnimHotkey then SwitchAnimHotkey.Value = tostring(DecodedSettings.ConfSwitchAnimHotkey) end
			if DecodedSettings.ConfAnimFadeHotkey then AnimFadeHotkey.Value = tostring(DecodedSettings.ConfAnimFadeHotkey) end
			if DecodedSettings.ConfStopAnimsHotkey then StopAnimsHotkey.Value = tostring(DecodedSettings.ConfStopAnimsHotkey) end
			if DecodedSettings.ConfResetCharHotkey then ResetCharHotkey.Value = tostring(DecodedSettings.ConfResetCharHotkey) end
		end
	end
end
local LoadDataOk, result = pcall(function()
	return LoadData()
end)
if not LoadDataOk then
	Notify({Title = "FATAL ERROR!", Text = "An error occured while <b>"..LoadingState.."</b>. Check Dev Console for more info <b>(F9)</b>", Time = 5})
	LoadingState = "Loaded"
	warn("[FATAL ERROR]: "..result)
end

if ConnectedToGithub and LaunchBetaBuild and not IsBetaBuild and LatestBetaVersion > LatestVersion then
	warn("LaunchBetaBuild setting enabled and Beta version is higher than stable version, Launching Beta build...")
	LoadingState = "LaunchingBeta"
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/BetaVersion.lua",true))()
	return
end	

local function SaveData(Type)
	local SettingsToSave = {
		ConfAnimPreviewEnabled = AnimPreviewEnabled,
		ConfDebugInfoEnabled = DebugInfoEnabled,
		ConfAnalyticsEnabled = AnalyticsEnabled,
		ConfLoadAnimationsOnRestart = LoadAnimationsOnRestart,
		ConfLoadAllAnimationsOnRestart = LoadAllAnimationsOnRestart,
		ConfTopMost = TopMost,
		ConfLaunchBetaBuild = LaunchBetaBuild,
		ConfSpecCategoryOnLaunch = SpecCategoryOnLaunch,

		ConfToolIdleAnimHighPriorEnabled = ToolIdleAnimHighPriorEnabled,
		ConfToolActionAnimHighPriorEnabled = ToolActionAnimHighPriorEnabled,
		ConfAnimSwitchModeEnabled = AnimSwitchModeEnabled,
		ConfAnimSwitchModeRunIdleExceptionEnabled = AnimSwitchModeRunIdleExceptionEnabled,
		ConfBundleAnimSwitchModeEnabled = BundleAnimSwitchModeEnabled,
		ConfAnimSmoothFadeEnabled = AnimSmoothFadeEnabled,
		ConfHigherPriorityEnabled = HigherPriorityEnabled,

		ConfIdleTypeEnabled = IdleTypeEnabled,
		ConfRunningTypeEnabled = RunningTypeEnabled,
		ConfRunningTypeStopStandingEnabled = RunningTypeStopStandingEnabled,
		ConfRunningTypeCharSpeedEnabled = RunningTypeCharSpeedEnabled,
		ConfRunningTypeMinSpeedEnabled = RunningTypeMinSpeedEnabled,
		ConfRunningTypeStopJumpingEnabled = RunningTypeStopJumpingEnabled,
		ConfRunningTypeStopClimbingEnabled = RunningTypeStopClimbingEnabled,

		ConfTheme = Theme,
		ConfUIGradientEnabled = UIGradientEnabled,
		ConfUICornerEnabled = UICornerEnabled,
		ConfXSize = XSize,
		ConfYSize = YSize,
		ConfDragDelay = DragDelay,

		ConfLoadGithubSGAEnabled = LoadGithubSGAEnabled,
		ConfLoadGithubCustomAnimsEnabled = LoadGithubCustomAnimsEnabled,
		ConfLoadLocalSGAEnabled = LoadLocalSGAEnabled,
		ConfLoadLocalCustomAnimsEnabled = LoadLocalCustomAnimsEnabled,

		ConfHotkeysEnabled = HotkeysEnabled,
		ConfDoubleHotkey = DoubleHotkey.Value,
		ConfEmoteWheelHotkey = EmoteWheelHotkey.Value,
		ConfCloseHotkey = CloseHotkey.Value,
		ConfSettingsHotkey = SettingsHotkey.Value,
		ConfSearchHotkey = SearchHotkey.Value,
		ConfSitHotkey = SitHotkey.Value,
		ConfSwitchAnimHotkey = SwitchAnimHotkey.Value,
		ConfAnimFadeHotkey = AnimFadeHotkey.Value,
		ConfStopAnimsHotkey = StopAnimsHotkey.Value,
		ConfResetCharHotkey = ResetCharHotkey.Value
	}
	local SettingsJSON = HttpService:JSONEncode(SettingsToSave)

	if Type == "Default" then
		writefile("EmoterData/EmoterConfig.json", SettingsJSON)
		Notify({Title = "Saved settings", Text = "Succesfully saved settings!", Time = 3})
	elseif Type == "Specific" then
		local targetNumber = tostring(game.GameId)
		local folderPath = "EmoterData/SpecificSettings"
		local fileFound = false

		local success, files = pcall(listfiles, folderPath)
		if not success then
			makefolder(folderPath)
			success, files = pcall(listfiles, folderPath)
		end
		for _, filePath in ipairs(files) do
			local fileName = filePath:match("[^/\\]+$") or filePath
			local extractedNumber = fileName:match("(%d+)")

			if extractedNumber then
				if extractedNumber == targetNumber then
					fileFound = true
					ConfigFile = filePath
					print("Found settings specifically for this game, saving...")
					break
				end
			end
		end
		if not fileFound then
			ConfigFile = "EmoterData/SpecificSettings/"..targetNumber.." (".. game:GetService("MarketplaceService"):GetProductInfoAsync(game.PlaceId).Name ..").json"
		end

		writefile(ConfigFile, SettingsJSON)
		Notify({Title = "Saved settings", Text = "Succesfully saved settings for specific game!", Time = 3})
	elseif Type == "Update" then
		local DecodedData
		if isfile("EmoterData/Stats_DoNotDelete") then
			local rawData = readfile("EmoterData/Stats_DoNotDelete")
			DecodedData = HttpService:JSONDecode(rawData)
		else
			DecodedData = {}
		end

		if not IsBetaBuild then
			DecodedData.ConfLastUsedVersion = ScriptVersion
		else
			DecodedData.ConfLastUsedVersion = 5.57
		end
		DecodedData.ConfLastCheckedBeta = LatestBetaVersion or LastCheckedBeta
		DecodedData.ConfLaunchedTimes = LaunchedTimes + 1
		DecodedData.ConfTotalTimeUsed = TotalTimeUsed
		DecodedData.ConfChkValues = ChkValues 

		local UpdatedData = HttpService:JSONEncode(DecodedData)
		writefile("EmoterData/Stats_DoNotDelete", UpdatedData)
	end
end

local BgColor = Color3.fromRGB(137, 165, 255)
local ScrollBgColor = Color3.fromRGB(240, 255, 255)
local UiButColor = Color3.new(0, 0, 0) -- Color of GUI's buttons and Texts
local TextBgColor = Color3.fromRGB(255, 255, 255)
local ButtonCol = Color3.fromRGB(192, 191, 211) -- R6 Button Color
local ButtonSelectCol = Color3.fromRGB(255, 255, 255) -- R6 Button lighter color (idk how to make it just darker BgColor yet)

--On-restart and other Values
local FirstLaunch = true
local GuiPos = nil
local SettingsPos = nil
local ScrollingFramePos = nil
local ScrollingFrameSpecificPos = nil
local GuiClosed = false
local OptionsOpened = false
local SettingsOpened = false
local CurrentSection = "Default"
local PriorityAltPressed = false
local RunAltPressed = false
local IdleAltPressed = false
local IsDragging = false

local PrevAnimSpeedValue = ""
local SearchOpened = false
local PrevSearchText = ""
local CustomAnimOpened = false
local PrevCustomAnimId = ""

local RestartAnimations = {}
local EmoteWheelEmotes = {Emote1 = nil, Emote2 = nil, Emote3 = nil, Emote4 = nil, Emote5 = nil, Emote6 = nil, Emote7 = nil, Emote8 = nil}


--GUI stuff and tables (Moved most of locales here because of that stupid 200 locales limit in a single function)
local DefaultAnimsNameList local ToolIdleAnimsList local ToolActionAnimsList local Emoter local MainFrame 
local ViewportFrame local SideFrame local SideFrameTitle local OpenGUI local SFDestroyGUI
local GuiTopFrame local DestroyGUI local CloseGUI local Title local GuiBottomFrame
local SpeedFrame local CurAnimInfoTitle local OptionsButton 
local DefaultScrollingFrame local ScrollingFrameR6 local ScrollingFrameR15 local ScrollingFrameSpecific local ScrollingFrameBundles local ScrollingFramesList
local OptionsFrame local StopAnimsEvent local SwitchBundleAnimsEvent local PauseAnimsButton local PauseAnimsOption local StopDefAnimsButton
local PauseAnimateButton local SitButton local ReversePlayButton local EmoteWheelButton local SearchFrame
local SearchButton local SearchBox local BackButton local CustomAnimFrame local CustomAnimButton
local IdBox local CustomAnimBackButton local AddTempAnimButton
local DefaultSection local SpecGameSection local BundlesSection
local EmoteWheel local EmoteWheelText local Emote1 local Emote2 local Emote3 local Emote4 local Emote5 local Emote6 local Emote7 local Emote8
local SettingsFrame local GuiName local AutorText local VersionText
local SGSNotification local DataNotification
local SettingsStuff local DragDelayOption local DragOptionText local DelayNumBox
local ThemeOption local ThemeOptionText local PurpleThemeColor local OrangeThemeColor local YellowThemeColor local BlackThemeColor
local HotkeysEditOption local HotkeysFrame local HotkeysStuff local HotkeyFrameName
local MoreButtonsFrame local SaveSettingsButton
local LaunchIdDetectorButton local ResetButton local GithubLinkButton

warn("--- Script by Fixel, based on Energize GUI by illremember. Do not copy and do not claim as your own! ---")
print("Script version: "..ScriptVersion)
print("Game Id: "..game.GameId)
local function CreateGui()
	print("Loading Emoter GUI...")

	local SpeedNum = 0 --Value, adding to default speed of animation
	local AnimInfo = Instance.new("StringValue")
	local AddedDataInfo = Instance.new("StringValue")
	local NegativeNumber = 1
	local DefaultWalkSpeed = 16
	local SFHideTimeCount = 0
	local Humanoid = nil
	local Character = nil
	local Pose = "Stepping"
	local IsJumping = false
	local Landed = true
	local ClonedChar = nil
	local RigType = nil
	local GuiLoaded = false
	local GuiRestarted = false

	local function WaitForChar()
		while wait() do 
			if Player.Character:FindFirstChild("Humanoid") and Player.Character:FindFirstChild("HumanoidRootPart") then
				Character = Player.Character or Player.CharacterAdded:Wait()
				Humanoid = Character:FindFirstChild("Humanoid")
				return
			end
		end
	end
	WaitForChar()

	local function onStateChanged(_oldState, newState)
		if not GuiActive or GuiRestarted then return end
		if newState.Name ~= "Running" then
			Pose = newState.Name
		else
			Pose = "Stepping"
		end
		--print(Pose)
		if newState == Enum.HumanoidStateType.Jumping then
			IsJumping = true
		elseif newState ~= Enum.HumanoidStateType.Jumping and newState ~= Enum.HumanoidStateType.Freefall then
			if IsJumping then
				IsJumping = false
			end
		end
		if newState.Name == "Landed" then
			Landed = true
		elseif newState.Name == "Freefall" then
			Landed = false
		end
	end
	Humanoid.StateChanged:Connect(onStateChanged)

	if (Player.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
		RigType = "R15"
		DefaultScrollingFrame = ScrollingFrameR15
	elseif (Player.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R6) then
		RigType = "R6"
		DefaultWalkSpeed = 14.5
		DefaultScrollingFrame = ScrollingFrameR6
	else
		RigType = "R15"
	end

	DefaultAnimsNameList = {"Animation1", "Animation2", "Animation3", "ClimbAnim", "FallAnim", "JumpAnim", "RunAnim", "SitAnim", "ToolNoneAnim", "WalkAnim", "CheerAnim", "LaughAnim", "PointAnim", "Swim", "SwimIdle", "ToolLungeAnim", "ToolSlashAnim", "WaveAnim"}
	ToolIdleAnimsList = {"ToolNoneAnim", "507768375", "182393478"}
	ToolActionAnimsList = {"ToolLungeAnim", "ToolSlashAnim", "522638767", "522635514", "129967390", "129967478"}

	Emoter = Instance.new("ScreenGui") --The actual GUI
	MainFrame = Instance.new("Frame") --All of the stuff on the main frame
	local MFUIScale = Instance.new("UIScale", MainFrame)
	ViewportFrame = Instance.new("ViewportFrame") --Frame with animation preview

	SideFrame = Instance.new("CanvasGroup") --Visible when GUI is closed
	local SFUIScale = Instance.new("UIScale", SideFrame)
	SideFrameTitle = Instance.new("TextLabel")
	OpenGUI = Instance.new("ImageButton")
	SFDestroyGUI = Instance.new("TextButton")

	GuiTopFrame = Instance.new("Frame") --Top of the main frame
	DestroyGUI = Instance.new("TextButton")
	CloseGUI = Instance.new("ImageButton")
	Title = Instance.new("TextLabel")

	GuiBottomFrame = Instance.new("Frame") --Bottom of the main frame
	SpeedFrame = Instance.new("Frame") -- Frame of Speed Changer
	CurAnimInfoTitle = Instance.new("TextLabel")
	OptionsButton = Instance.new("ImageButton")

	ScrollingFrameR6 = Instance.new("ScrollingFrame") --Scrolling frame of R6 animations
	ScrollingFrameR15 = Instance.new("ScrollingFrame") --Scrolling frame of R15 animations
	ScrollingFrameSpecific = Instance.new("ScrollingFrame") --Scrolling frame of specific game animations
	ScrollingFrameBundles = Instance.new("ScrollingFrame") --Scrolling frame of animation bundles
	ScrollingFramesList = {
		ScrollingFrameR6,
		ScrollingFrameR15,
		ScrollingFrameSpecific,
		ScrollingFrameBundles
	}

	OptionsFrame = Instance.new("Frame") --Frame of additional options
	StopAnimsEvent = Instance.new("BindableEvent") --Event to stop animations when disabling StopDefaultAnims option
	SwitchBundleAnimsEvent = Instance.new("BindableEvent") --StopAnimsEvent but for Bundles
	PauseAnimsButton = Instance.new("ImageButton")
	PauseAnimsOption = false
	StopDefAnimsButton = Instance.new("ImageButton")
	PauseAnimateButton = Instance.new("ImageButton")
	SitButton = Instance.new("ImageButton")
	ReversePlayButton = Instance.new("ImageButton")
	EmoteWheelButton = Instance.new("ImageButton")

	SearchFrame = Instance.new("Frame") --Frame for searching anims
	SearchButton = Instance.new("ImageButton")
	SearchBox = Instance.new("TextBox")
	BackButton = Instance.new("ImageButton")

	CustomAnimFrame = Instance.new("Frame") --Frame for adding anims by it's Id
	CustomAnimButton = Instance.new("ImageButton")
	IdBox = Instance.new("TextBox")
	CustomAnimBackButton = Instance.new("ImageButton")
	AddTempAnimButton = Instance.new("ImageButton")

	DefaultSection = Instance.new("TextButton") --Sections in case when you have specific game anims
	SpecGameSection = Instance.new("TextButton")
	BundlesSection = Instance.new("TextButton")

	EmoteWheel = Instance.new("Frame") --Emote wheel 
	EmoteWheelText = Instance.new("TextLabel")
	Emote1 = Instance.new("TextButton")
	Emote2 = Instance.new("TextButton")
	Emote3 = Instance.new("TextButton")
	Emote4 = Instance.new("TextButton")
	Emote5 = Instance.new("TextButton")
	Emote6 = Instance.new("TextButton")
	Emote7 = Instance.new("TextButton")
	Emote8 = Instance.new("TextButton")

	SettingsFrame = Instance.new("Frame") --Settings
	GuiName = Instance.new("TextLabel")
	AutorText = Instance.new("TextLabel")
	VersionText = Instance.new("TextLabel")
	local WarningText = Instance.new("TextLabel")
	SGSNotification = Instance.new("ImageButton")
	DataNotification = Instance.new("ImageButton")
	SettingsStuff = Instance.new("ScrollingFrame")
	DragDelayOption = Instance.new("Frame")
	DragOptionText = Instance.new("TextLabel")
	DelayNumBox = Instance.new("TextBox")
	ThemeOption = Instance.new("Frame")
	ThemeOptionText = Instance.new("TextLabel")
	PurpleThemeColor = Instance.new("TextButton")
	OrangeThemeColor = Instance.new("TextButton")
	YellowThemeColor = Instance.new("TextButton")
	BlackThemeColor = Instance.new("TextButton")
	HotkeysEditOption = Instance.new("TextButton")
	HotkeysFrame = Instance.new("Frame")
	HotkeysStuff = Instance.new("ScrollingFrame")
	HotkeyFrameName = Instance.new("TextLabel")
	MoreButtonsFrame = Instance.new("Frame")
	SaveSettingsButton = Instance.new("ImageButton")
	LaunchIdDetectorButton = Instance.new("ImageButton")
	ResetButton = Instance.new("ImageButton")
	GithubLinkButton = Instance.new("ImageButton")

	if Theme == "LightOrange" then
		BgColor = Color3.fromRGB(255, 171, 35)
		ScrollBgColor = Color3.fromRGB(240, 255, 255)
		UiButColor = Color3.new(0, 0, 0)
		TextBgColor = Color3.fromRGB(255, 255, 255)
		ButtonCol = Color3.fromRGB(192, 191, 211)
		ButtonSelectCol = Color3.fromRGB(255, 255, 255)
	elseif Theme == "LightPurple" then
		BgColor = Color3.fromRGB(137, 165, 255)
		ScrollBgColor = Color3.fromRGB(240, 255, 255)
		UiButColor = Color3.new(0, 0, 0)
		TextBgColor = Color3.fromRGB(255, 255, 255)
		ButtonCol = Color3.fromRGB(192, 191, 211)
		ButtonSelectCol = Color3.fromRGB(255, 255, 255)
	elseif Theme == "LightYellow" then
		BgColor = Color3.fromRGB(255, 250, 112)
		ScrollBgColor = Color3.fromRGB(240, 255, 255)
		UiButColor = Color3.new(0, 0, 0)
		TextBgColor = Color3.fromRGB(255, 255, 255)
		ButtonCol = Color3.fromRGB(192, 191, 211)
		ButtonSelectCol = Color3.fromRGB(255, 255, 255)
	elseif Theme == "Black" then
		BgColor = Color3.fromRGB(65, 65, 65)
		ScrollBgColor = Color3.fromRGB(20, 20, 20)
		UiButColor = Color3.new(1, 1, 1)
		TextBgColor = Color3.fromRGB(13, 13, 13)
		ButtonCol = Color3.fromRGB(65, 65, 65)
		ButtonSelectCol = Color3.fromRGB(129, 129, 129)
	end

	if RigType == "R15" then
		EmoteWheelEmotes.Emote1 = "R15Wave"
		EmoteWheelEmotes.Emote2 = "R15FortniteDance"
		EmoteWheelEmotes.Emote3 = "R15GangnamStyle"
		EmoteWheelEmotes.Emote4 = "R15RussianKick"
		EmoteWheelEmotes.Emote5 = "R15Rambunctious"
		EmoteWheelEmotes.Emote6 = "BundleMiniAll"
		EmoteWheelEmotes.Emote7 = "R15Helicopter"
		EmoteWheelEmotes.Emote8 = "R15TakeTheL"
	else
		EmoteWheelEmotes.Emote1 = "R6Dance1"
		EmoteWheelEmotes.Emote2 = "R6Dance2"
		EmoteWheelEmotes.Emote3 = "R6Dance3"
		EmoteWheelEmotes.Emote4 = "R6MovingDance"
		EmoteWheelEmotes.Emote5 = "R6Bang"
		EmoteWheelEmotes.Emote6 = "R6SpinDance"
		EmoteWheelEmotes.Emote7 = "R6FloatSit"
		EmoteWheelEmotes.Emote8 = "R6Spinner"
	end

	local function AddVPF()
		ViewportFrame.Parent = MainFrame
		ViewportFrame.Visible = false
		ViewportFrame.AnchorPoint = Vector2.new(0, 0.5)
		ViewportFrame.BackgroundTransparency = 1
		ViewportFrame.Size = UDim2.new(0, 225, 0, 285)
		ViewportFrame.Position = UDim2.new(1, 10, 0.5, 0)
		ViewportFrame.BackgroundColor3 = Color3.fromRGB(166, 174, 175)
		ViewportFrame.Ambient = Color3.fromRGB(175, 175, 175)
		ViewportFrame.LightColor = Color3.fromRGB(208, 208, 208)
		local UICorner = Instance.new("UICorner")
		UICorner.Parent = ViewportFrame
		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = ViewportFrame
		UIStroke.Thickness = 5
		UIStroke.BorderStrokePosition = Enum.BorderStrokePosition.Outer

		local WaitText = Instance.new("TextLabel")
		WaitText.Parent = ViewportFrame
		WaitText.AnchorPoint = Vector2.new(0.5, 0.5)
		WaitText.Size = UDim2.new(1, -10, 1, -10)
		WaitText.Position = UDim2.new(0.5, 0, 0.5, 0)
		WaitText.BorderSizePixel = 0
		WaitText.BackgroundColor3 = Color3.fromRGB(166, 174, 175)
		WaitText.TextSize = 30
		WaitText.Text = "Please wait for character to load"
		WaitText.TextWrapped = true

		local WorldModel = Instance.new("WorldModel")
		WorldModel.Parent = ViewportFrame
		local VPFcam = Instance.new("Camera"); VPFcam.Parent = ViewportFrame
		VPFcam.CameraType = Enum.CameraType.Scriptable

		local targetPosition = nil
		targetPosition = Vector3.new(4.6, 0.2, 12)
		if RigType == "R15" then
			targetPosition = Vector3.new(4.6, 0.2, 12) -- if R15
		else
			targetPosition = Vector3.new(4.6, -1, 12)
		end

		task.spawn(function()
			while wait() do
				if Player.Character then
					break
				end
			end
			wait(0.5)

			local targetRotation = CFrame.Angles(0, math.rad(20), 0)
			VPFcam.CFrame = CFrame.new(targetPosition) * targetRotation
			ViewportFrame.CurrentCamera = VPFcam
			VPFcam.FieldOfView = 37
			Character.Archivable = true
			ClonedChar = Character:Clone()
			ClonedChar.Name = "VPFCharacter"
			ClonedChar.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			ClonedChar.Parent = WorldModel
			if ClonedChar:FindFirstChild(AnimationHandler) then
				ClonedChar:FindFirstChild(AnimationHandler):Destroy()
			end
			if ClonedChar:FindFirstChildOfClass("Tool") then
				ClonedChar:FindFirstChildOfClass("Tool"):Destroy()
			end
			ClonedChar:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0,0,-0.4), Vector3.new(0,0,7)))
			WaitText.Visible = false
		end)
	end
	--Moved AddVPF() function to end of the function for character to have more time to load	

	local function AddHoverText(Object, Text, Hotkey)
		local TextLabel = nil
		Object.MouseEnter:connect(function()
			if IsDragging then return end
			TextLabel = Instance.new("TextLabel")
			TextLabel.Parent = Emoter
			TextLabel.Visible = false
			TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			TextLabel.BackgroundTransparency = 1
			TextLabel.AutomaticSize = Enum.AutomaticSize.XY
			TextLabel.Size = UDim2.new(0, 5, 0, 17)
			TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
			TextLabel.TextTransparency = 1
			TextLabel.TextSize = 17
			TextLabel.TextWrapped = true
			TextLabel.Font = Enum.Font.SourceSans
			TextLabel.TextXAlignment = Enum.TextXAlignment.Left
			TextLabel.RichText = true

			if Text.Value then
				TextLabel.Text = Text.Value
			elseif Hotkey ~= nil and Hotkey.Value ~= "" then
				if Hotkey.Value:find("Double") then
					TextLabel.Text = Text.." ["..DoubleHotkey.Value.." + "..Hotkey.Value:gsub("Double", "").."]"
				else
					TextLabel.Text = Text.." ["..Hotkey.Value.."]"
				end
			else
				TextLabel.Text = Text
			end

			local UIPadding = Instance.new("UIPadding")
			UIPadding.PaddingLeft = UDim.new(0, 2)
			UIPadding.PaddingRight = UDim.new(0, 2)
			UIPadding.PaddingBottom = UDim.new(0, 2)
			UIPadding.Parent = TextLabel

			local UISizeConstraint = Instance.new("UISizeConstraint")
			UISizeConstraint.Parent = TextLabel
			UISizeConstraint.MaxSize = Vector2.new(400, 3000)

			local UserInputService = game:GetService("UserInputService")
			local mouse = Player:GetMouse()
			TextLabel.Position = UDim2.new(0, mouse.X, 0, mouse.Y + 85)
			TextLabel.Visible = true
			game.TweenService:Create(TextLabel, TweenInfo.new(.06), {BackgroundTransparency = 0}):Play()
			game.TweenService:Create(TextLabel, TweenInfo.new(.06), {TextTransparency = 0}):Play()
			mouse.Move:connect(function()
				TextLabel.Position = UDim2.new(0, mouse.X, 0, mouse.Y + 85)
			end)
			-- Add hover text
		end)
		Object.MouseLeave:connect(function()
			if TextLabel == nil then return end
			game.TweenService:Create(TextLabel, TweenInfo.new(.06), {BackgroundTransparency = 1}):Play()
			game.TweenService:Create(TextLabel, TweenInfo.new(.06), {TextTransparency = 1}):Play()
			wait(.06)
			TextLabel:Destroy()
			-- Destroy hover text
		end)
	end

	local function CreateDivideFrame(Title, LayoutOrder, Type)
		local HasButton = false
		if Type == "Spec" then
			for _, v in pairs(ScrollingFrameSpecific:GetChildren()) do
				if v:IsA("TextButton") then
					if v.LayoutOrder == LayoutOrder + 1 then
						HasButton = true
						break
					end
				end		
			end
		else
			HasButton = true
		end
		if not HasButton then return end

		local DivideFrame = Instance.new("Frame")
		local Line = Instance.new("Frame")
		local TextLabel = Instance.new("TextLabel")

		DivideFrame.Name = "DivideFrame"
		DivideFrame.Size = UDim2.new(0.98, 0, 0, 18)
		DivideFrame.BackgroundTransparency = 1
		DivideFrame.LayoutOrder = LayoutOrder

		Line.Name = "Line"
		Line.AnchorPoint = Vector2.new(0, 0.5)
		Line.Size = UDim2.new(1, 0, 0, 3)
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.Position = UDim2.new(0, 0, 0.5, 0)
		Line.BorderSizePixel = 0
		Line.BackgroundColor3 = UiButColor
		Line.Parent = DivideFrame

		TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
		TextLabel.AutomaticSize = Enum.AutomaticSize.X
		TextLabel.Size = UDim2.new(0, 0, 0, 25)
		TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextLabel.BorderSizePixel = 0
		TextLabel.BackgroundColor3 = ScrollBgColor
		TextLabel.TextSize = 25
		TextLabel.TextColor3 = UiButColor
		TextLabel.Text = Title
		TextLabel.Font = Enum.Font.SourceSansBold
		TextLabel.Parent = DivideFrame

		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.PaddingRight = UDim.new(0, 10)
		UIPadding.Parent = TextLabel

		if Type == "Settings" then
			DivideFrame.Size = UDim2.new(0.98, 0, 0, 15)
			Line.Size = UDim2.new(1, 0, 0, 2)
			TextLabel.Size = UDim2.new(0, 50, 0, 20)
			TextLabel.TextSize = 17
		elseif Type == "Bundle" then
			DivideFrame.Name = Title.."DivideFrame"
			UIPadding.PaddingLeft = UDim.new(0, 0)
			TextLabel.AnchorPoint = Vector2.new(0, 0.5)
			TextLabel.Position = UDim2.new(0, 0, 0.5, 0)
		end

		if Type == "R6" then
			DivideFrame.Parent = ScrollingFrameR6
		elseif Type == "R15" then
			DivideFrame.Parent = ScrollingFrameR15
		elseif Type == "Spec" then
			DivideFrame.Parent = ScrollingFrameSpecific
		elseif Type == "Settings" then
			DivideFrame.Parent = SettingsStuff
		elseif Type == "Bundle" then
			DivideFrame.Parent = ScrollingFrameBundles
		end
	end

	local PlayingEmoteData = {}
	local function UpdateAnimInfo()
		local TextTable = {}

		for _, item in ipairs(PlayingEmoteData) do
			table.insert(TextTable, item.Name .. ": " .. tostring(item.Speed) .. ", " .. item.Priotity)
		end

		AnimInfo.Value = table.concat(TextTable, "\n")
		if AnimInfo.Value == "" then
			CurAnimInfoTitle.Visible = false
		else
			CurAnimInfoTitle.Visible = true
		end
	end
	local function AddEmoteInfo(EmoteName, SpeedValue, PriorityValue)
		for index, item in ipairs(PlayingEmoteData) do
			if item.Name == EmoteName then
				table.remove(PlayingEmoteData, index)
				break
			end
		end

		table.insert(PlayingEmoteData, 1, {Name = EmoteName, Speed = SpeedValue, Priotity = PriorityValue})
		UpdateAnimInfo()
	end
	local function RemoveEmoteInfo(EmoteName)
		for index, item in ipairs(PlayingEmoteData) do
			if item.Name == EmoteName then
				table.remove(PlayingEmoteData, index)
				break
			end
		end
		UpdateAnimInfo()
	end

	local function AddAnimation(Button, ID, FadeTime, Speed, Type, LoopedVal, NeedPause) -- The MAIN function
		local Frame
		if Button.Parent.Name == "ScrollingFrame" then Frame = "R6"
		elseif Button.Parent.Name == "ScrollingFrameR15" then Frame = "R15"
		elseif Button.Parent.Name == "ScrollingFrameSpecific" then Frame = "Spec"
		end

		local AnimSpeed = nil
		local PauseAnimsOption = false
		local SwitchModeFactor = false
		local IsMoving = false
		local IsPlaying = false
		local RunningType = false
		local IdleType = false
		local AnimACTIVE = false

		Button:SetAttribute("Looped", LoopedVal)
		if not LoopedVal then
			AddHoverText(Button, "Click RMB to loop")
		end

		if Type:find("Running") then
			RunningType = true
		elseif Type:find("Idle") then
			IdleType = true
		end

		local Humanoid = Player.Character:WaitForChild("Humanoid")
		local Anim = Instance.new("Animation")
		Anim.Name = "AAnimation"
		Anim.AnimationId = "rbxassetid://"..ID
		local track = Humanoid:WaitForChild("Animator"):LoadAnimation(Anim)

		local AnimLoaded = true
		task.spawn(function()
			while wait(0.1) do
				if game:GetService("ContentProvider"):GetAssetFetchStatus(Anim.AnimationId) == Enum.AssetFetchStatus.Success then
					return
				elseif game:GetService("ContentProvider"):GetAssetFetchStatus(Anim.AnimationId) == Enum.AssetFetchStatus.Failure then
					AnimLoaded = false
					warn("Error with animation: ".. ID)
					Button.UIStroke.Thickness = 2
					Button.UIStroke.Color = Color3.new(0.945098, 0, 0)
					AddHoverText(Button, "Couldn't load this animation by it's Id. Please type right Id and make sure this animation is working in this game")
					return
				end
			end
		end)

		local CurLooped = Button:GetAttribute("Looped")
		if CurLooped then
			track.Looped = true
		else
			track.Looped = false
		end

		if Type:find("PriorLow") then
			track.Priority = Enum.AnimationPriority.Action3
		elseif Type:find("PriorHigh") then
			track.Priority = Enum.AnimationPriority.Action4
		end		

		Button.Destroying:Connect(function()
			if not GuiLoaded then
				track:Destroy()
				Anim:Destroy()
				Humanoid = nil
				track = nil
			end
		end)

		local function StartAnim()
			if DebugInfoEnabled then print(Button.Name.." - Id: "..string.match(track.Animation.AnimationId, "%d+")..", AnimLength: "..track.Length..", AnimSpeed: "..track.Speed..", AnimType: "..Type..", Looped: "..tostring(track.Looped)) end

			if RunAltPressed then
				if Type:find("Running") then
					RunningType = false
				else
					RunningType = true
				end
			else
				if Type:find("Running") then
					RunningType = true
				end
			end
			if IdleAltPressed then
				if Type:find("Idle") then
					IdleType = false
				else
					IdleType = true
				end
			else
				if Type:find("Idle") then
					IdleType = true
				end
			end

			if AnimSwitchModeEnabled then
				if not (((RunningType and RunningTypeEnabled) or (IdleType and IdleTypeEnabled)) and AnimSwitchModeRunIdleExceptionEnabled) then
					SwitchModeFactor = true
					StopAnimsEvent:Fire()
					AnimACTIVE = true
				end
			end

			local CurLooped = Button:GetAttribute("Looped")
			if CurLooped then
				track.Looped = true
			else
				track.Looped = false
			end

			local AnimWeight = 1
			if HigherPriorityEnabled then
				if Type:find("PriorHigh") then
					AnimWeight = 20000
				elseif Type:find("PriorLow") then
					track.Priority = Enum.AnimationPriority.Action4
					AnimWeight = 10000
				end
			end

			if PriorityAltPressed then
				if Type:find("PriorLow") then
					track.Priority = Enum.AnimationPriority.Action4
					if HigherPriorityEnabled then
						AnimWeight = 20000
					end
				elseif Type:find("PriorHigh") then
					track.Priority = Enum.AnimationPriority.Action3
					if HigherPriorityEnabled then
						track.Priority = Enum.AnimationPriority.Action4
						AnimWeight = 10000
					end
				end
			end

			AnimSpeed = Speed + SpeedNum
			ViewportFrame.Visible = false
			Button.BackgroundColor3 = ButtonSelectCol
			Button.UIStroke.Thickness = 2
			AddEmoteInfo(Button.Name, Speed + SpeedNum, track.Priority.Name)

			if RunningType and RunningTypeEnabled then
				Button.UIStroke.Color = Color3.new(0, 0.898039, 0.478431)
			elseif IdleType and IdleTypeEnabled then
				Button.UIStroke.Color = Color3.new(0.741176, 0, 0.890196)
			elseif Type:find("Pause") then
				Button.UIStroke.Color = Color3.new(0.835294, 0.85098, 0)
			else
				if track.Looped == true then
					Button.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
				else
					Button.UIStroke.Color = Color3.new(0.972549, 0.670588, 0.0627451)
				end
			end

			if RunningType and RunningTypeEnabled and RunningTypeStopStandingEnabled and not IsMoving then return end
			if IdleType and IdleTypeEnabled and IsMoving then return end

			if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
				track:Play(FadeTime, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
			else
				track:Play(0, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
			end
			IsPlaying = true

			if PauseAnimsOption then
				track:AdjustSpeed(0)
			end

			if Type:find("Pause") then
				local Number = tonumber(string.match(Type, "Pause([%d%.]+)")) or 1
				local PauseTask = task.spawn(function()
					track.Looped = true
					while wait() do
						if track.TimePosition >= Number then
							track:AdjustSpeed(0)
							track.TimePosition = Number
							if DebugInfoEnabled then print("Paused at "..track.TimePosition) end
							AnimSpeed = 0
							return
						end
					end
				end)
				while wait() do
					if not AnimACTIVE then
						task.cancel(PauseTask)
						return
					end
				end
			end
		end
		local function StopAnim(Reason)
			if not Type:find("Running") then
				RunningType = false
			end
			if not Type:find("Idle") then
				IdleType = false
			end

			if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
				track:Stop(FadeTime)
			else
				track:Stop(0)
				track:Stop()
			end
			IsPlaying = false

			if (Reason == "Destroy") then track = nil return end

			if Type:find("PriorLow") then
				track.Priority = Enum.AnimationPriority.Action3
			elseif Type:find("PriorHigh") then
				track.Priority = Enum.AnimationPriority.Action4
			end	

			Button.BackgroundColor3 = ButtonCol
			Button.UIStroke.Thickness = 1
			Button.UIStroke.Color = Color3.new(0, 0, 0)
			RemoveEmoteInfo(Button.Name)
		end
		local function SuspendAnim(TransitionTime)
			if TransitionTime == nil then
				TransitionTime = FadeTime
			end
			if IsPlaying then
				if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
					track:Stop(TransitionTime)
				else
					track:Stop(0)
					track:Stop()
				end
				IsPlaying = false
			end
		end

		Button.MouseButton1Click:connect(function()
			if not AnimLoaded then return end
			AnimACTIVE = not AnimACTIVE
			if AnimACTIVE then
				StartAnim()
			else
				StopAnim()
			end
		end)
		Button.MouseButton2Click:connect(function()
			if not AnimLoaded then return end
			local CurLooped = Button:GetAttribute("Looped")
			if not CurLooped then
				AnimACTIVE = not AnimACTIVE
				if AnimACTIVE then
					StartAnim()
					track.Looped = true
					Button.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
				else
					StopAnim()
				end
			end
		end)

		PauseAnimsButton.MouseButton1Click:Connect(function()
			PauseAnimsOption = not PauseAnimsOption
			if PauseAnimsOption then
				if AnimACTIVE then
					track:AdjustSpeed(0)
					if DebugInfoEnabled and AnimACTIVE then print("Paused at:"..track.TimePosition) end
				end
			else
				if AnimACTIVE then
					track:AdjustSpeed((Speed + SpeedNum) * NegativeNumber)
				end
			end
		end)

		Button.Changed:connect(function()
			if GuiRestarted or not GuiActive or not AnimLoaded then return end
			if Button.BackgroundColor3 == ButtonCol and AnimACTIVE then
				AnimACTIVE = false
				StopAnim()
			elseif Button.BackgroundColor3 == ButtonSelectCol and not AnimACTIVE then
				AnimACTIVE = true
				StartAnim()
			end
		end)

		track.Ended:connect(function()
			if (RunningType and RunningTypeEnabled) or (IdleType and IdleTypeEnabled) then return end
			AnimACTIVE = false
			Button.BackgroundColor3 = ButtonCol
			Button.UIStroke.Thickness = 1
			Button.UIStroke.Color = Color3.new(0, 0, 0)
			RemoveEmoteInfo(Button.Name)
		end)

		StopAnimsEvent.Event:Connect(function(Reason)
			if not (Reason == "Reset/Destroy" or Reason == "Forced") and AnimSwitchModeRunIdleExceptionEnabled and ((RunningType and RunningTypeEnabled) or (IdleType and IdleTypeEnabled)) then return end
			if not AnimACTIVE or not AnimLoaded then return end

			if (Reason == "Reset/Destroy") and (LoadAnimationsOnRestart or LoadAllAnimationsOnRestart) then
				local Name = Button.Name
				if ((Type:find("Running") and RunningTypeEnabled) or (Type:find("Idle") and IdleTypeEnabled)) and LoadAnimationsOnRestart then
					if AnimACTIVE then
						table.insert(RestartAnimations, Frame..Name)
					end
				elseif LoadAllAnimationsOnRestart then
					if AnimACTIVE then
						table.insert(RestartAnimations, Frame..Name)
					end
				end
			end

			if SwitchModeFactor then 
				SwitchModeFactor = false	
				return 
			end

			AnimACTIVE = false
			if Reason == "Forced" then
				PauseAnimsOption = false
			end
			if (Reason == "Reset/Destroy") then
				StopAnim("Destroy")
			else
				StopAnim()
			end
		end)

		local MinWalkSpeedStr = string.match(Type, "Running([%d%.]+)")
		local MinWalkSpeed = tonumber(MinWalkSpeedStr) or 0.5
		local MAXWalkSpeedStr = string.match(Type, "Until([%d%.]+)")
		local MAXWalkSpeed = tonumber(MAXWalkSpeedStr) or math.huge
		if not RunningTypeMinSpeedEnabled then
			MinWalkSpeed = 0.5
		end
		if tonumber(MinWalkSpeedStr) ~= nil then AddHoverText(Button, "Minimal WalkSpeed to play:"..MinWalkSpeed) end
		if tonumber(MAXWalkSpeedStr) ~= nil then AddHoverText(Button, "Maximum WalkSpeed to play:"..MAXWalkSpeed) end

		local RunningConnection
		local IdleConnection
		local JumpingConnection
		local FallingConnection
		local SwimmingConnection
		local ClimbingConnection
		local SeatedConnection
		local PlatformStandingConnection
		local FallingDownConnection
		local GettingUpConnection

		RunningConnection = Humanoid.Running:Connect(function(currentSpeed)
			if not RunningType then return end
			if GuiActive and not GuiRestarted then
				if currentSpeed > 0.5 then
					IsMoving = true
				else
					IsMoving = false
				end
			else
				RunningConnection:Disconnect() return
			end

			if AnimACTIVE and RunningTypeEnabled then
				if RunningTypeMinSpeedEnabled == false then
					MinWalkSpeed = 0.5
				end
				if currentSpeed > 0.5 and currentSpeed >= MinWalkSpeed and currentSpeed < MAXWalkSpeed then
					local AnimWeight = 1
					if HigherPriorityEnabled then
						if Type:find("PriorHigh") then
							AnimWeight = 250
						elseif Type:find("PriorLow") then
							track.Priority = Enum.AnimationPriority.Action4
							AnimWeight = 100
						end
					end

					if not IsPlaying then
						if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
							track:Play(FadeTime, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
						else
							track:Play(0, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
						end
						IsPlaying = true
					end

					if RigType == "R6" then
						currentSpeed /= Humanoid.Parent:GetScale()
					end

					local characterRelativeSpeed = currentSpeed / DefaultWalkSpeed
					if not RunningTypeStopStandingEnabled then
						characterRelativeSpeed = Humanoid.WalkSpeed / DefaultWalkSpeed
					end

					local finalAnimationSpeed = characterRelativeSpeed * (Speed + SpeedNum) * NegativeNumber
					if RunningTypeCharSpeedEnabled then
						track:AdjustSpeed(finalAnimationSpeed)
					end
				else
					if RunningTypeStopStandingEnabled then
						SuspendAnim()
					end
				end
			else
				if RunningTypeEnabled then
					SuspendAnim()
				end
			end
		end)

		IdleConnection = Humanoid.Running:Connect(function(currentSpeed)
			if not IdleType then return end
			if GuiActive and not GuiRestarted then
				if currentSpeed > 0.5 then
					IsMoving = true
				else
					IsMoving = false
				end
			else
				IdleConnection:Disconnect()
			end

			if AnimACTIVE and IdleTypeEnabled then
				if currentSpeed > 0.5 then
					if IsPlaying then
						SuspendAnim()
					end
				else
					if IsPlaying == false then
						local AnimWeight = 1
						if HigherPriorityEnabled then
							if Type:find("PriorHigh") then
								AnimWeight = 250
							elseif Type:find("PriorLow") then
								track.Priority = Enum.AnimationPriority.Action4
								AnimWeight = 100
							end
						end

						if not IsPlaying then
							if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
								track:Play(FadeTime, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
							else
								track:Play(0, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
							end
							IsPlaying = true
						end

						IsPlaying = true
					end
				end
			else
				if IdleTypeEnabled then
					SuspendAnim()
				end
			end
		end)

		JumpingConnection = Humanoid.Jumping:Connect(function()
			if not GuiActive or GuiRestarted then JumpingConnection:Disconnect() return end
			if (RunningType and RunningTypeEnabled and (RunningTypeStopJumpingEnabled and not Type:find("OnJump"))) or (IdleTypeEnabled and IdleType) then
				SuspendAnim(0.1)
			end
		end)
		FallingConnection = Humanoid.FreeFalling:Connect(function()
			if not GuiActive or GuiRestarted then FallingConnection:Disconnect() return end
			if (RunningType and RunningTypeEnabled and (RunningTypeStopJumpingEnabled and not Type:find("OnJump"))) or (IdleTypeEnabled and IdleType) then
				SuspendAnim(0.2)
			end
		end)
		SwimmingConnection = Humanoid.Swimming:Connect(function()
			if not GuiActive or GuiRestarted then SwimmingConnection:Disconnect() return end
			if (RunningTypeEnabled and RunningType) or (IdleTypeEnabled and IdleType) then
				SuspendAnim(0.4)
			end
		end)
		ClimbingConnection = Humanoid.Climbing:Connect(function()
			if not GuiActive or GuiRestarted then ClimbingConnection:Disconnect() return end
			if (RunningTypeEnabled and RunningType and RunningTypeStopClimbingEnabled) or (IdleTypeEnabled and IdleType) then
				SuspendAnim(0.1)
			end
		end)
		SeatedConnection = Humanoid.Seated:Connect(function()
			if not GuiActive or GuiRestarted then SeatedConnection:Disconnect() return end
			if (RunningTypeEnabled and RunningType) or (IdleTypeEnabled and IdleType) then
				SuspendAnim(0.5)
			end
		end)
		PlatformStandingConnection = Humanoid.PlatformStanding:Connect(function()
			if not GuiActive or GuiRestarted then PlatformStandingConnection:Disconnect() return end
			if (RunningTypeEnabled and RunningType) or (IdleTypeEnabled and IdleType) then
				SuspendAnim()
			end
		end)
		FallingDownConnection = Humanoid.FallingDown:Connect(function()
			if not GuiActive or GuiRestarted then FallingDownConnection:Disconnect() return end
			if (RunningTypeEnabled and RunningType) or (IdleTypeEnabled and IdleType) then
				SuspendAnim()
			end
		end)
		GettingUpConnection = Humanoid.GettingUp:Connect(function()
			if not GuiActive or GuiRestarted then GettingUpConnection:Disconnect() return end
			if (RunningTypeEnabled and RunningType) or (IdleTypeEnabled and IdleType) then
				SuspendAnim()
			end
		end)

		if not AnimLoaded then
			RunningConnection:Disconnect()
			IdleConnection:Disconnect()
			JumpingConnection:Disconnect()
			FallingConnection:Disconnect()
			SwimmingConnection:Disconnect()
			ClimbingConnection:Disconnect()
			SeatedConnection:Disconnect()
			PlatformStandingConnection:Disconnect()
			FallingDownConnection:Disconnect()
			GettingUpConnection:Disconnect()
		end

		for index, RestartedAnim in ipairs(RestartAnimations) do
			local prefix, suffix
			if string.match(RestartedAnim, "^R15") then
				prefix, suffix = string.match(RestartedAnim, "^(R15)(.+)$")
			elseif string.match(RestartedAnim, "^Spec") then
				prefix, suffix = string.match(RestartedAnim, "^(Spec)(.+)$")
			elseif string.match(RestartedAnim, "^R6") then
				prefix, suffix = string.match(RestartedAnim, "^(R6)(.+)$")
			end

			if prefix == Frame and suffix == Button.Name then
				task.spawn(function()
					Button:WaitForChild("UIStroke")
					if Button ~= nil and AnimLoaded then
						AnimACTIVE = true
						StartAnim()
					end
				end)
			end
		end

		local VPFtrack = nil
		if ViewportFrame.WorldModel:FindFirstChildOfClass("Model") then
			VPFtrack = ClonedChar:WaitForChild("Humanoid"):LoadAnimation(Anim)
		end
		ViewportFrame.WorldModel.ChildAdded:Connect(function(Child)
			if Child:IsA("Model") then
				VPFtrack = ClonedChar:WaitForChild("Humanoid"):LoadAnimation(Anim)
			end
		end)
		local VPFActive = false
		Button.MouseEnter:connect(function()
			if not AnimLoaded or IsDragging then return end
			if AnimPreviewEnabled and not AnimACTIVE then
				if Type:find("Running") and RunningTypeEnabled then
					ViewportFrame.UIStroke.Color = Color3.new(0, 0.898039, 0.478431)
				elseif Type:find("Idle") and IdleTypeEnabled then
					ViewportFrame.UIStroke.Color = Color3.new(0.741176, 0, 0.890196)
				elseif Type:find("Pause") then
					ViewportFrame.UIStroke.Color = Color3.new(0.835294, 0.85098, 0)
				else
					if LoopedVal == true then
						ViewportFrame.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
					else
						ViewportFrame.UIStroke.Color = Color3.new(0.972549, 0.670588, 0.0627451)
					end
				end

				if not VPFtrack then
					ViewportFrame.Visible = true
					game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 0}):Play()
					return 
				end
				VPFActive = true
				VPFtrack.Looped = true
				VPFtrack:Play(0, 1, (Speed + SpeedNum) * NegativeNumber)
				ViewportFrame.Visible = true
				game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 0}):Play()

				if Type:find("Pause") then
					local NumberStr = string.match(Type, "Pause([%d%.]+)")
					local Number = tonumber(NumberStr) or 1

					local PauseTask = task.spawn(function()
						wait(Number)
						VPFtrack:AdjustSpeed(0)
					end)
					while wait() do
						if not VPFActive then
							task.cancel(PauseTask)
							return
						end
					end
				end
			end
		end)
		Button.MouseLeave:connect(function()
			if AnimPreviewEnabled then
				VPFActive = false
				game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 1}):Play()
				ViewportFrame.Visible = false
				if not VPFtrack then return end
				VPFtrack:Stop()
			end
		end)
	end

	local function CreateAnim(Object, Name, Text, Frame, LayoutPos, ID, FadeTime, Speed, Type, LoopedVal, NeedPause)
		local Button = Object
		Button.Name = Name
		local Destroyed = false

		if Frame == "R6" then
			if ScrollingFrameR6:FindFirstChild(Name) then 
				ScrollingFrameR6:FindFirstChild(Name):Destroy()
				--print("Found copy of anim: "..Name)
			end
			Button.Parent = ScrollingFrameR6
		elseif Frame == "R15" then
			if ScrollingFrameR15:FindFirstChild(Name) then 
				ScrollingFrameR15:FindFirstChild(Name):Destroy()
				--print("Found copy of anim: "..Name)
			end
			Button.Parent = ScrollingFrameR15
		elseif Frame == "Spec" then
			if ScrollingFrameSpecific:FindFirstChild(Name) then 
				ScrollingFrameSpecific:FindFirstChild(Name):Destroy()
				--print("Found copy of anim: "..Name)
			end
			Button.Parent = ScrollingFrameSpecific
		end

		Button.BackgroundColor3 = ButtonCol
		Button.FontFace.Weight = Enum.FontWeight.Bold
		Button.Size = UDim2.new(0, 104, 0, 30)
		Button.TextColor3 = UiButColor
		Button.RichText = true
		Button.Font = Enum.Font.Roboto
		Button.Text = "<b>" .. Text .. "</b>"
		Button.TextScaled = true
		Button.LayoutOrder = LayoutPos

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Button
		UIStroke.Thickness = 1
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		if UICornerEnabled then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = Button
			UICorner.CornerRadius = UDim.new(0, 3)
		end
		if UIGradientEnabled then
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Parent = Button
			UIGradient.Color = ColorSequence.new(Color3.fromRGB(207, 207, 207), Color3.fromRGB(255, 255, 255))
			UIGradient.Rotation = -90
		end

		local ButtonPadding = Instance.new("UIPadding")
		ButtonPadding.Parent = Button
		ButtonPadding.PaddingLeft = UDim.new(0, 2)
		ButtonPadding.PaddingRight = UDim.new(0, 2)

		Button.Destroying:Connect(function()
			Destroyed = true
		end)

		task.spawn(function()
			while not GuiLoaded do
				wait()
			end
			if not Destroyed then
				AddAnimation(Object, ID, FadeTime, Speed, Type, LoopedVal, NeedPause)
			end
		end)
	end

	local function CreateBundle(Name, Title, Type)
		local Active = false
		if (Type == "R6" and RigType ~= "R6") or (Type == "R15" and RigType ~= "R15") then return end
		CreateDivideFrame(Title, 0, "Bundle")

		if ScrollingFrameBundles:FindFirstChild(Name.."All") then 
			ScrollingFrameBundles:FindFirstChild(Name.."All"):Destroy()
			ScrollingFrameBundles:FindFirstChild(Title.."DivideFrame"):Destroy()
			for _, v in pairs(ScrollingFrameBundles:GetChildren()) do
				if v:IsA("TextButton") and v:GetAttribute("Bundle") == Name then
					v:Destroy()
				end
			end
			--print("Found copy of Bundle: "..Name)
		end

		local EquipAllButton = Instance.new("ImageButton")
		EquipAllButton.Name = Name.."All"
		EquipAllButton.Parent = ScrollingFrameBundles
		EquipAllButton.BackgroundColor3 = ButtonCol
		EquipAllButton.Size = UDim2.new(0, 27, 0, 27)
		EquipAllButton:SetAttribute("BundleTitle", Title)
		AddHoverText(EquipAllButton, "Equip All animations")

		local Image = Instance.new("ImageLabel")
		Image.Parent = EquipAllButton
		Image.Size = UDim2.new(1, 0, 1, 0)
		Image.BackgroundTransparency = 1
		Image.Image = "rbxassetid://78382947508749"
		Image.ImageColor3 = UiButColor

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = EquipAllButton
		UIStroke.Thickness = 1
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		if UICornerEnabled then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = EquipAllButton
			UICorner.CornerRadius = UDim.new(0, 3)
		end
		if UIGradientEnabled then
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Parent = EquipAllButton
			UIGradient.Color = ColorSequence.new(Color3.fromRGB(207, 207, 207), Color3.fromRGB(255, 255, 255))
			UIGradient.Rotation = -90
		end
		local ButtonPadding = Instance.new("UIPadding")
		ButtonPadding.Parent = EquipAllButton
		ButtonPadding.PaddingLeft = UDim.new(0, 3)
		ButtonPadding.PaddingRight = UDim.new(0, 3)
		ButtonPadding.PaddingTop = UDim.new(0, 3)
		ButtonPadding.PaddingBottom = UDim.new(0, 3)

		EquipAllButton.MouseButton1Click:Connect(function()
			Active = not Active
			if Active then
				EquipAllButton.BackgroundColor3 = ButtonSelectCol
				EquipAllButton.UIStroke.Thickness = 3
				EquipAllButton.UIStroke.Color = Color3.new(0, 0, 1)

				for i,v in pairs(ScrollingFrameBundles:GetChildren()) do
					if v:IsA("TextButton") and v:GetAttribute("Bundle") == Name then
						v.BackgroundColor3 = ButtonSelectCol
					elseif v:isA("TextButton") and v:GetAttribute("Bundle") ~= Name and BundleAnimSwitchModeEnabled then
						v.BackgroundColor3 = ButtonCol
					end
				end
			else
				EquipAllButton.BackgroundColor3 = ButtonCol
				EquipAllButton.UIStroke.Thickness = 1
				EquipAllButton.UIStroke.Color = Color3.new(0, 0, 0)

				for i,v in pairs(ScrollingFrameBundles:GetChildren()) do
					if v:IsA("TextButton") and v:GetAttribute("Bundle") == Name then
						v.BackgroundColor3 = ButtonCol
					end
				end
			end
		end)

		EquipAllButton.Changed:connect(function()
			if GuiRestarted or not GuiActive or not GuiLoaded then return end
			if EquipAllButton.BackgroundColor3 == ButtonCol and Active then
				EquipAllButton.BackgroundColor3 = ButtonCol
				EquipAllButton.UIStroke.Thickness = 1
				EquipAllButton.UIStroke.Color = Color3.new(0, 0, 0)

				for i,v in pairs(ScrollingFrameBundles:GetChildren()) do
					if v:IsA("TextButton") and v:GetAttribute("Bundle") == Name then
						v.BackgroundColor3 = ButtonCol
					end
				end
			elseif EquipAllButton.BackgroundColor3 == ButtonSelectCol and not Active then
				EquipAllButton.BackgroundColor3 = ButtonSelectCol
				EquipAllButton.UIStroke.Thickness = 3
				EquipAllButton.UIStroke.Color = Color3.new(0, 0, 1)

				for i,v in pairs(ScrollingFrameBundles:GetChildren()) do
					if v:IsA("TextButton") and v:GetAttribute("Bundle") == Name then
						v.BackgroundColor3 = ButtonSelectCol
					end
				end
			end
		end)

		local function DetectActiveState(child) --A function to detect when EquipAll button need to be active if all anims was equipped manualy
			if EquipAllButton.Parent == nil then return end
			if not child:IsA("TextButton") then return end
			child.Changed:Connect(function(property)
				if child:GetAttribute("Bundle") == Name then
					if Active and child.BackgroundColor3 == ButtonCol then
						Active = false
						EquipAllButton.BackgroundColor3 = ButtonCol
						EquipAllButton.UIStroke.Thickness = 1
						EquipAllButton.UIStroke.Color = Color3.new(0, 0, 0)
					elseif not Active then
						local AllSelected = true
						for i,v in pairs(ScrollingFrameBundles:GetChildren()) do
							if v:IsA("TextButton") and v:GetAttribute("Bundle") == Name then
								if v.BackgroundColor3 == ButtonCol then
									AllSelected = false
									break
								end
							end
						end
						if AllSelected and property == "BackgroundColor3" then
							Active = true
							EquipAllButton.BackgroundColor3 = ButtonSelectCol
							EquipAllButton.UIStroke.Thickness = 3
							EquipAllButton.UIStroke.Color = Color3.new(0, 0, 1)
						end
					end
				end
			end)
		end
		ScrollingFrameBundles.ChildAdded:Connect(DetectActiveState)
	end

	local function AddBundleAnimation(BundleName, Button, ID, FadeTime, Speed, Type, LoopedVal) -- The Bundle animation function
		local AnimACTIVE = false
		local AnimSpeed = nil
		local PauseAnimsOption = false
		local SwitchModeFactor = false
		local BundleSwitchModeFactor = false
		local IsRunning = false
		local IsPlaying = false
		local AltTask
		local AnimWeight = 1

		local RunningType = false
		local IdleType = false
		local IdleAltType = false --Probably gonna chage it to having both Id's in one function
		local SwimmingType = false
		local SwimIdleType = false
		local ClimbingType = false
		local JumpingType = false
		local FallingType = false

		local MinWalkSpeedStr = string.match(Type, "Running([%d%.]+)")
		local MinWalkSpeed = tonumber(MinWalkSpeedStr) or 0.5
		local MAXWalkSpeedStr = string.match(Type, "Until([%d%.]+)")
		local MAXWalkSpeed = tonumber(MAXWalkSpeedStr) or math.huge
		if not RunningTypeMinSpeedEnabled then
			MinWalkSpeed = 0.5
		end

		local HoverText = ""
		if tonumber(MinWalkSpeedStr) ~= nil then HoverText = HoverText.."Minimal WalkSpeed to play:"..MinWalkSpeed.."  " end
		if tonumber(MAXWalkSpeedStr) ~= nil then HoverText = HoverText.."Maximum WalkSpeed to play:"..MAXWalkSpeed.."  " end
		if Type:find("OnJump") then HoverText = HoverText.."(This Animation is playing while jumping)" end
		AddHoverText(Button, HoverText)

		local JumpAnimDuration = 0.3 --It was 0.31 for R15, but i decided to change it to have same as R6
		local FallTransitionTime = 0.2
		local ClimbScale = 5
		local IdleRandomMax = 10
		local IdleAltRandomNum = 1
		if RigType == "R6" or BundleName == "DefaultR6" then --This BundleName condition is made exclusively for classic R6 bundle made for R15 Rig
			FallTransitionTime = 0.3
			ClimbScale = 12
		end

		local SwitchType = ""
		if Type:find("Running") or Button.Name:find("Run") or Button.Name:find("Walk") then
			RunningType = true
			SwitchType = "Run"
		elseif (Type:find("Idle") or Button.Name == "Idle") and not Button.Name:find("IdleAlt") then
			IdleType = true
			SwitchType = "Idle"
		elseif Type:find("IdleAlt") or Button.Name:find("IdleAlt") then
			IdleAltType = true
		elseif (Type:find("Swimming") or Button.Name:find("Swim")) and not Button.Name:find("SwimIdle") then
			SwimmingType = true
			SwitchType = "Swim"
		elseif Type:find("SwimIdle") or Button.Name:find("SwimIdle") then
			SwimIdleType = true
			SwitchType = "SwimIdle"
		elseif Type:find("Climbing") or Button.Name:find("Climb") then
			ClimbingType = true
			SwitchType = "Climb"
		elseif Type:find("Jumping") or Button.Name:find("Jump") then
			JumpingType = true
			SwitchType = "Jump"
		elseif Type:find("Falling") or Button.Name:find("Fall") then
			FallingType = true
			SwitchType = "Fall"
		end

		local IDTable = nil
		if type(ID) == "table" then
			IDTable = ID
			ID = ID[1]
		end

		local Humanoid = Player.Character:WaitForChild("Humanoid")
		local Anim = Instance.new("Animation")
		Anim.Name = "ABAnimation"
		Anim.AnimationId = "rbxassetid://"..ID
		local track = nil

		local AnimLoaded = true
		task.spawn(function() --Check if asset is available
			while wait(0.1) do
				if game:GetService("ContentProvider"):GetAssetFetchStatus(Anim.AnimationId) == Enum.AssetFetchStatus.Success then
					return
				elseif game:GetService("ContentProvider"):GetAssetFetchStatus(Anim.AnimationId) == Enum.AssetFetchStatus.Failure then
					AnimLoaded = false
					warn("Error with animation: ".. ID)
					Button.UIStroke.Thickness = 2
					Button.UIStroke.Color = Color3.new(0.945098, 0, 0)
					AddHoverText(Button, "Couldn't load this animation by it's Id. Please type right Id and make sure this animation is working in this game")
					return
				end
			end
		end)
		local function SetAnimTrack()
			if IdleType and type(IDTable) == "table" then
				local Roll = math.random(1, IdleRandomMax)
				if Roll <= IdleAltRandomNum then
					ID = IDTable[2]
				else
					ID = IDTable[1]
				end
				Anim.AnimationId = "rbxassetid://"..ID
			end
			if not track or track == nil then
				track = Humanoid:WaitForChild("Animator"):LoadAnimation(Anim)
			end

			Button:SetAttribute("Looped", LoopedVal)
			local CurLooped = Button:GetAttribute("Looped")
			if not CurLooped then
				track.Looped = false
			elseif CurLooped then
				track.Looped = true
			end

			if HigherPriorityEnabled then
				if Type:find("PriorHigh") then
					AnimWeight = 250
				elseif Type:find("PriorLow") then
					track.Priority = Enum.AnimationPriority.Action4
					AnimWeight = 100
				end
			else
				AnimWeight = 1
				if Type:find("PriorHigh") then
					track.Priority = Enum.AnimationPriority.Action4

				elseif Type:find("PriorLow") then
					track.Priority = Enum.AnimationPriority.Action3
				end
			end	
		end
		SetAnimTrack()

		Button.Destroying:Connect(function()
			if not GuiLoaded then
				Anim:Destroy()
				Humanoid = nil
				track = nil
			end
		end)

		local function PlayAnim(TransitionTime)
			if IsPlaying then return end
			if track == nil then
				SetAnimTrack()	
			end
			if TransitionTime == nil then TransitionTime = FadeTime end

			if HigherPriorityEnabled then
				if Type:find("PriorHigh") then
					AnimWeight = 250
				elseif Type:find("PriorLow") then
					track.Priority = Enum.AnimationPriority.Action4
					AnimWeight = 100
				end
			else
				AnimWeight = 1
				if Type:find("PriorHigh") then
					track.Priority = Enum.AnimationPriority.Action4

				elseif Type:find("PriorLow") then
					track.Priority = Enum.AnimationPriority.Action3
				end
			end

			if not IsPlaying and AnimACTIVE then
				if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
					track:Play(TransitionTime, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
				else
					track:Play(0, AnimWeight, (Speed + SpeedNum) * NegativeNumber)
				end
				IsPlaying = true
				if PauseAnimsOption then
					track:AdjustSpeed(0)
				end

				if IdleType and type(IDTable) == "table" then
					if AltTask ~= nil then AltTask:Disconnect() end
					AltTask = track.KeyframeReached:Connect(function(FrameName)
						if (FrameName == "End") then
							if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
								track:Stop(0.15)
							else
								track:Stop(0)
								track:Stop()
							end
							track:Destroy()
							track = nil
							IsPlaying = false
							if RigType == "R15" then
								PlayAnim(0.15)
							else
								PlayAnim(0)
							end
						end
					end)
				end
			end
		end
		local function SuspendAnim(TransitionTime)
			if not IsPlaying then return end
			if track == nil then return end
			if not TransitionTime or TransitionTime == nil then TransitionTime = FadeTime end

			if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
				track:Stop(TransitionTime)
			else
				track:Stop(0)
				track:Stop()
			end
			track:Destroy()
			track = nil
			IsPlaying = false
		end
		local function AdjustAnimSpeed(CurrentSpeed)
			if track == nil then return end
			if PauseAnimsOption then return end
			local FinalAnimationSpeed

			if RigType == "R6" then
				CurrentSpeed /= Humanoid.Parent:GetScale()
				FinalAnimationSpeed = CurrentSpeed * (Speed + SpeedNum) * NegativeNumber
			elseif RigType == "R15" then
				local function getHeightScale()
					if Humanoid then
						if not Humanoid.AutomaticScalingEnabled then return Humanoid.Parent:GetScale() end

						local AnimationSpeedDampening = Humanoid.Parent:FindFirstChild("Animate").ScaleDampeningPercent.Value or 1 --If found Default AnimHandler script
						local scale = 1 + (Humanoid.HipHeight - 2) * AnimationSpeedDampening / 2 -- 2 is the default Humanoid.HipHeight taken from Default AnimHandler script
						return scale
					end
					return Humanoid.Parent:GetScale()
				end

				local function rootMotionCompensation(speed)
					local speedScaled = speed * 1.25
					if ClimbingType or SwimmingType then
						speedScaled = speed
					end
					local heightScale = getHeightScale()
					local ResultSpeed = speedScaled / heightScale
					return ResultSpeed
				end
				local MoveSpeed = rootMotionCompensation(CurrentSpeed)
				FinalAnimationSpeed = MoveSpeed * (Speed + SpeedNum) * NegativeNumber
			end

			if RunningType and RunningTypeCharSpeedEnabled then
				track:AdjustSpeed(FinalAnimationSpeed)
			elseif not RunningType then
				track:AdjustSpeed(FinalAnimationSpeed)
			end
		end

		local function StartAnim()
			if DebugInfoEnabled then print(BundleName.." - "..Button.Name.." - Id: "..string.match(track.Animation.AnimationId, "%d+")..", AnimLength: "..track.Length..", AnimSpeed: "..track.Speed..", AnimType: "..Type..", Looped: "..tostring(track.Looped)) end
			if track == nil then
				SetAnimTrack()
			end

			if RunAltPressed then
				if Type:find("Running") or Button.Name:find("Run") or Button.Name:find("Walk") then
					RunningType = false
				else
					if not SwimmingType or SwimIdleType or JumpingType or FallingType then
						RunningType = true
					end
				end
			end
			if IdleAltPressed then
				if (Type:find("Idle") or Button.Name == "Idle") and not Button.Name:find("IdleAlt") then
					IdleType = false
				else
					if not SwimmingType or JumpingType or FallingType or ClimbingType then
						IdleType = true
					end
				end
			end

			if BundleAnimSwitchModeEnabled then
				BundleSwitchModeFactor = true
				SwitchBundleAnimsEvent:Fire(BundleName, SwitchType, string.match(Button.Name, BundleName.."(%S+)"))
			end

			--[[if PriorityAltPressed then
				--Not sure if i'm going to process this for bundle
			end]]

			AnimSpeed = Speed + SpeedNum
			ViewportFrame.Visible = false
			Button.BackgroundColor3 = ButtonSelectCol
			Button.UIStroke.Thickness = 2
			AddEmoteInfo(BundleName.." - "..Button.Name, Speed + SpeedNum, track.Priority.Name)

			if ((RunningType and RunningTypeEnabled) or SwimmingType or ClimbingType) then
				Button.UIStroke.Color = Color3.new(0, 0.807843, 0.027451)
			elseif ((IdleType and IdleTypeEnabled) or IdleAltType or SwimIdleType) then
				Button.UIStroke.Color = Color3.new(0.607843, 0, 0.847059)
			elseif JumpingType or FallingType then
				Button.UIStroke.Color = Color3.new(0.87451, 0.776471, 0.231373)
			else
				Button.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
			end

			if (RunningType and RunningTypeEnabled and RunningTypeStopStandingEnabled and (not IsRunning or Pose ~= "Stepping")) then return end
			if (IdleType and IdleTypeEnabled and (IsRunning or Pose ~= "Stepping")) then return end
			if JumpingType or FallingType or (SwimmingType and Pose ~= "Swimming") or (SwimIdleType and Pose ~= "Swimming") or (ClimbingType and Pose ~= "Climbing") then return end

			local SpeedFromRootPart = Character.HumanoidRootPart.AssemblyLinearVelocity.Magnitude
			if RunningType or IdleType or SwimmingType or ClimbingType then
				if RunningType then
					if RunningTypeEnabled and (SpeedFromRootPart > 0.5 and SpeedFromRootPart >= MinWalkSpeed and SpeedFromRootPart < MAXWalkSpeed) then
						PlayAnim()
					elseif not RunningTypeEnabled then
						PlayAnim()
					end
				else
					PlayAnim()
				end
				if RunningType and RunningTypeEnabled then
					AdjustAnimSpeed(SpeedFromRootPart/DefaultWalkSpeed)
				elseif SwimmingType then
					AdjustAnimSpeed(SpeedFromRootPart/10)
				elseif ClimbingType then
					AdjustAnimSpeed(SpeedFromRootPart/5)
				end
			end
		end
		local function StopAnim(Reason)
			if track == nil then
				track = Humanoid:WaitForChild("Animator"):LoadAnimation(Anim)
			end
			if (Type:find("Running") or Button.Name:find("Run") or Button.Name:find("Walk")) then
				RunningType = true
			else
				RunningType = false
			end
			if (Type:find("Idle") or Button.Name == "Idle") and not Button.Name:find("IdleAlt") then
				IdleType = true
			else
				IdleType = false
			end

			if AnimSmoothFadeEnabled and not HigherPriorityEnabled then
				track:Stop(FadeTime)
			else
				track:Stop(0)
				track:Stop()
			end
			IsPlaying = false

			if (Reason == "Destroy") then track = nil return end

			if Type:find("PriorLow") then
				track.Priority = Enum.AnimationPriority.Action3
			elseif Type:find("PriorHigh") then
				track.Priority = Enum.AnimationPriority.Action4
			end	

			Button.BackgroundColor3 = ButtonCol
			Button.UIStroke.Thickness = 1
			Button.UIStroke.Color = Color3.new(0, 0, 0)
			RemoveEmoteInfo(BundleName.." - "..Button.Name)
		end

		Button.MouseButton1Click:connect(function()
			if not AnimLoaded then return end
			AnimACTIVE = not AnimACTIVE
			if AnimACTIVE then
				StartAnim()
			else
				StopAnim()
			end
		end)

		PauseAnimsButton.MouseButton1Click:Connect(function()
			PauseAnimsOption = not PauseAnimsOption
			if PauseAnimsOption then
				if AnimACTIVE then
					track:AdjustSpeed(0)
					if DebugInfoEnabled and AnimACTIVE then print("Paused at:"..track.TimePosition) end
				end
			else
				if AnimACTIVE then
					track:AdjustSpeed((Speed + SpeedNum) * NegativeNumber)
				end
			end
		end)

		Button.Changed:connect(function()
			if GuiRestarted or not GuiActive or not AnimLoaded then return end
			if Button.BackgroundColor3 == ButtonCol and AnimACTIVE then
				AnimACTIVE = false
				StopAnim()
			elseif Button.BackgroundColor3 == ButtonSelectCol and not AnimACTIVE then
				AnimACTIVE = true
				StartAnim()
			end
		end)

		StopAnimsEvent.Event:Connect(function(Reason)
			if not (Reason == "Reset/Destroy" or Reason == "Forced") and AnimSwitchModeRunIdleExceptionEnabled then return end
			if not AnimACTIVE or not AnimLoaded then return end

			if (Reason == "Reset/Destroy") and (LoadAnimationsOnRestart or LoadAllAnimationsOnRestart) then
				if AnimACTIVE then
					table.insert(RestartAnimations, "Bundles"..BundleName.."."..Button.Name)
				end
			end

			if SwitchModeFactor then 
				SwitchModeFactor = false	
				return 
			end

			AnimACTIVE = false
			if Reason == "Forced" then
				PauseAnimsOption = false
			end
			if (Reason == "Reset/Destroy") then
				StopAnim("Destroy")
			else
				StopAnim()
			end
		end)
		SwitchBundleAnimsEvent.Event:Connect(function(Bundle, Type, AnimName)
			if not AnimACTIVE or not AnimLoaded then return end
			if BundleSwitchModeFactor then 
				BundleSwitchModeFactor = false	
				return 
			end

			if Bundle ~= BundleName and ((Type == "Run" and RunningType and AnimName == string.match(Button.Name, BundleName.."(%S+)")) or (Type == "Idle" and IdleType) or (Type == "Swim" and SwimmingType) or (Type == "SwimIdle" and SwimIdleType) or (Type == "Climb" and ClimbingType) or (Type == "Jump" and JumpingType) or (Type == "Fall" and FallingType)) then
				AnimACTIVE = false
				StopAnim()
			end
		end)

		local RunningConnection
		local IdleConnection
		local SwimmingConnection
		local JumpingConnection
		local FallingConnection
		local ClimbingConnection

		RunningConnection = Humanoid.Running:Connect(function(CurrentSpeed)
			if not GuiActive or GuiRestarted then
				RunningConnection:Disconnect()
				return
			end
			if CurrentSpeed > 0.5 then
				IsRunning = true
			else
				IsRunning = false
			end
			if (FallingType or JumpingType or SwimmingType or SwimIdleType or ClimbingType) and IsPlaying then
				if RigType == "R6" then
					SuspendAnim(0.1) return
				end
				SuspendAnim(0.19) return
			end
			if not AnimACTIVE or not RunningType then return end

			if RunningTypeEnabled then
				if not RunningTypeMinSpeedEnabled then
					MinWalkSpeed = 0.5
				end
				if CurrentSpeed > 0.5 and CurrentSpeed >= MinWalkSpeed and CurrentSpeed < MAXWalkSpeed then
					PlayAnim(FadeTime)

					track:AdjustWeight(AnimWeight, FadeTime)
					AdjustAnimSpeed(CurrentSpeed/DefaultWalkSpeed)
				elseif CurrentSpeed > 0.5 and not HigherPriorityEnabled then
					PlayAnim(FadeTime)

					AdjustAnimSpeed(CurrentSpeed/DefaultWalkSpeed)
					track:AdjustWeight(0.0001, FadeTime)
				else
					if RunningTypeStopStandingEnabled then
						SuspendAnim(FadeTime)
					end
				end
			else
				track:AdjustSpeed((Speed + SpeedNum) * NegativeNumber)
				track:AdjustWeight(AnimWeight)
				Button.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
			end
		end)
		IdleConnection = Humanoid.Running:Connect(function(currentSpeed)
			if not GuiActive or GuiRestarted then
				IdleConnection:Disconnect()
				return
			end
			if not AnimACTIVE or not IdleType then return end

			if IdleTypeEnabled then
				if currentSpeed > 0.5 then
					SuspendAnim(FadeTime)
				else
					PlayAnim(FadeTime)
				end
			else
				track:AdjustSpeed((Speed + SpeedNum) * NegativeNumber)
				track:AdjustWeight(AnimWeight)
				Button.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
			end
		end)
		JumpingConnection = Humanoid.Jumping:Connect(function()
			if not GuiActive or GuiRestarted then
				JumpingConnection:Disconnect()
				return
			end
			if not AnimACTIVE then return end
			if (RunningType and RunningTypeEnabled and (RunningTypeStopJumpingEnabled and not Type:find("OnJump"))) or (IdleTypeEnabled and IdleType) or SwimmingType or SwimIdleType or ClimbingType then
				SuspendAnim(0.1)
			end

			if JumpingType or (RunningType and RunningTypeEnabled and (not RunningTypeStopJumpingEnabled or Type:find("OnJump"))) then
				PlayAnim(0.1)
				if Type:find("NoFall") or (RunningType and RunningTypeEnabled and (not RunningTypeStopJumpingEnabled or Type:find("OnJump"))) then track.Looped = true return end

				local FastPause = task.spawn(function()
					track.Looped = true
					while wait() do
						if not IsJumping or not IsPlaying then return end
						if track.TimePosition >= JumpAnimDuration then
							track:AdjustSpeed(0)
							track.TimePosition = JumpAnimDuration
							return
						end
					end
				end)
				wait(JumpAnimDuration)
				if IsJumping then
					SuspendAnim(FallTransitionTime)
				end
			end

			if FallingType and not IsPlaying then
				local FallTask = task.spawn(function()
					wait(JumpAnimDuration)
					if IsJumping then
						PlayAnim(FallTransitionTime)
					end
				end)
				while wait(0.01) do
					if not IsJumping then
						task.cancel(FallTask)
						return
					end
				end
			end
		end)
		FallingConnection = Humanoid.FreeFalling:Connect(function()
			if not GuiActive or GuiRestarted then
				FallingConnection:Disconnect()
				return
			end
			if not AnimACTIVE then return end
			if (IsPlaying and RunningTypeEnabled and (RunningTypeStopJumpingEnabled and not Type:find("OnJump")) and RunningType and Landed) or (IsPlaying and IdleTypeEnabled and IdleType) or SwimmingType or SwimIdleType or ClimbingType then
				SuspendAnim(FallTransitionTime)
			end

			if (FallingType or (RunningType and RunningTypeEnabled and (not RunningTypeStopJumpingEnabled or Type:find("OnJump")))) and not IsJumping then
				PlayAnim(FallTransitionTime)
			end
		end)
		SwimmingConnection = Humanoid.Swimming:Connect(function(SwimSpeed)
			if not GuiActive or GuiRestarted then
				SwimmingConnection:Disconnect()
				return
			end
			if not AnimACTIVE then return end
			if (IsPlaying and RunningTypeEnabled and RunningType) or (IsPlaying and IdleTypeEnabled and IdleType) or JumpingType or FallingType or ClimbingType then
				SuspendAnim(0.4)
			end

			if SwimSpeed > 1.00 then
				if SwimmingType then
					PlayAnim(0.4)
					AdjustAnimSpeed(SwimSpeed/10)
				elseif SwimIdleType then
					SuspendAnim(0.4)
				end
			else
				if SwimmingType then
					SuspendAnim(0.4)
				elseif SwimIdleType then
					PlayAnim(0.4)
				end
			end
		end)
		ClimbingConnection = Humanoid.Climbing:Connect(function(ClimbSpeed)
			if not GuiActive or GuiRestarted then
				ClimbingConnection:Disconnect()
				return
			end
			if not AnimACTIVE then return end
			if (IsPlaying and RunningTypeEnabled and RunningTypeStopClimbingEnabled and RunningType) or (IsPlaying and IdleTypeEnabled and IdleType) or JumpingType or FallingType or SwimmingType or SwimIdleType then
				SuspendAnim()
			end

			if ClimbingType then
				PlayAnim(0.1)
				AdjustAnimSpeed(ClimbSpeed/ClimbScale)
			end
		end)

		Humanoid.Seated:Connect(function()
			if not AnimACTIVE then return end
			SuspendAnim(0.5)
		end)
		Humanoid.PlatformStanding:Connect(function()
			if not AnimACTIVE then return end
			SuspendAnim()
		end)
		Humanoid.FallingDown:Connect(function()
			if not AnimACTIVE then return end
			SuspendAnim()
		end)
		Humanoid.GettingUp:Connect(function()
			if not AnimACTIVE then return end
			SuspendAnim()
		end)

		if not AnimLoaded then
			RunningConnection:Disconnect()
			IdleConnection:Disconnect()
			JumpingConnection:Disconnect()
			FallingConnection:Disconnect()
			SwimmingConnection:Disconnect()
			ClimbingConnection:Disconnect()
		end

		for index, RestartedAnim in ipairs(RestartAnimations) do
			local prefix, suffix
			if string.match(RestartedAnim, "^Bundles") then
				prefix, suffix = string.match(RestartedAnim, "^(Bundles)(.+)$")
			end

			if prefix == "Bundles" and suffix == BundleName.."."..Button.Name then
				task.spawn(function()
					Button:WaitForChild("UIStroke")
					if Button ~= nil and AnimLoaded then
						AnimACTIVE = true
						StartAnim()
					end
				end)
			end
		end

		local VPFtrack = nil
		if ViewportFrame.WorldModel:FindFirstChildOfClass("Model") then
			VPFtrack = ClonedChar:WaitForChild("Humanoid"):LoadAnimation(Anim)
		end
		ViewportFrame.WorldModel.ChildAdded:Connect(function(Child)
			if Child:IsA("Model") then
				VPFtrack = ClonedChar:WaitForChild("Humanoid"):LoadAnimation(Anim)
			end
		end)
		local VPFActive = false
		Button.MouseEnter:connect(function()
			if not AnimLoaded or IsDragging then return end
			if AnimPreviewEnabled and not AnimACTIVE then	
				if ((RunningType and RunningTypeEnabled) or SwimmingType or ClimbingType) then
					ViewportFrame.UIStroke.Color = Color3.new(0, 0.807843, 0.027451)
				elseif ((IdleType and IdleTypeEnabled) or IdleAltType or SwimIdleType) then
					ViewportFrame.UIStroke.Color = Color3.new(0.607843, 0, 0.847059)
				elseif JumpingType or FallingType then
					ViewportFrame.UIStroke.Color = Color3.new(0.890196, 0.866667, 0.239216)
				else
					ViewportFrame.UIStroke.Color = Color3.new(0.0392157, 0.501961, 1)
				end

				if not VPFtrack then
					ViewportFrame.Visible = true
					game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 0}):Play()
					return 
				end
				VPFActive = true
				VPFtrack.Looped = true
				VPFtrack:Play(0, 1, (Speed + SpeedNum) * NegativeNumber)
				ViewportFrame.Visible = true
				game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 0}):Play()
			end
		end)
		Button.MouseLeave:connect(function()
			if AnimPreviewEnabled then
				VPFActive = false
				game.TweenService:Create(ViewportFrame, TweenInfo.new(.1), {BackgroundTransparency = 1}):Play()
				ViewportFrame.Visible = false
				if not VPFtrack then return end
				VPFtrack:Stop()
			end
		end)
	end

	local function CreateBundleAnim(BundleName, Name, Text, ID, FadeTime, Speed, Type, LoopedVal)
		if not ScrollingFrameBundles:FindFirstChild(BundleName.."All") then return end
		local Button = Instance.new("TextButton")
		Button.Name = BundleName..Name
		local Destroyed = false

		if ScrollingFrameBundles:FindFirstChild(Button.Name) then 
			ScrollingFrameBundles:FindFirstChild(Button.Name):Destroy()
			--print("Found copy of anim: "..Name)
		end
		Button.Parent = ScrollingFrameBundles

		Button.BackgroundColor3 = ButtonCol
		Button.FontFace.Weight = Enum.FontWeight.Bold
		Button.Size = UDim2.new(0, 35, 0, 27)
		Button.AutomaticSize = Enum.AutomaticSize.X
		Button.TextColor3 = UiButColor
		Button.RichText = true
		Button.Font = Enum.Font.Roboto
		Button.Text = "<b>" .. Text .. "</b>"
		Button.TextScaled = true
		Button:SetAttribute("Bundle", BundleName)

		local UIStroke = Instance.new("UIStroke")
		UIStroke.Parent = Button
		UIStroke.Thickness = 1
		UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		if UICornerEnabled then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = Button
			UICorner.CornerRadius = UDim.new(0, 3)
		end
		if UIGradientEnabled then
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Parent = Button
			UIGradient.Color = ColorSequence.new(Color3.fromRGB(207, 207, 207), Color3.fromRGB(255, 255, 255))
			UIGradient.Rotation = -90
		end

		local ButtonPadding = Instance.new("UIPadding")
		ButtonPadding.Parent = Button
		ButtonPadding.PaddingLeft = UDim.new(0, 5)
		ButtonPadding.PaddingRight = UDim.new(0, 6)

		Button.Destroying:Connect(function()
			Destroyed = true
		end)

		task.spawn(function()
			while not GuiLoaded do
				wait()
			end
			if not Destroyed then
				AddBundleAnimation(BundleName, Button, ID, FadeTime, Speed, Type, LoopedVal)
			end
		end)
	end


	local function AddSetting(Setting, Title, Text, LayoutOrder)
		local OptionButton = Instance.new("TextButton")
		OptionButton.Name = Title
		OptionButton.Size = UDim2.new(1, 0, 0, 25)
		OptionButton.BackgroundTransparency = 1
		OptionButton.LayoutOrder = LayoutOrder
		OptionButton.Position = UDim2.new(0, 0, 0.1558714, 0)
		OptionButton.TextTransparency = 1
		OptionButton.Parent = SettingsStuff

		local CheckImage = Instance.new("ImageLabel")
		CheckImage.Name = "CheckImage"
		CheckImage.AnchorPoint = Vector2.new(0, 0.5)
		CheckImage.Size = UDim2.new(0, 15, 0, 15)
		CheckImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
		CheckImage.Position = UDim2.new(0, 0, 0.5, 0)
		CheckImage.BorderSizePixel = 1
		CheckImage.BackgroundColor3 = TextBgColor
		CheckImage.Image = "rbxassetid://130396712201457"
		CheckImage.ImageColor3 = UiButColor
		CheckImage.Parent = OptionButton
		if Setting == true then
			CheckImage.Image = "rbxassetid://130396712201457"
		else
			CheckImage.Image = ""
		end

		local UIListLayout = Instance.new("UIListLayout")
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout.Parent = OptionButton

		local TextLabel = Instance.new("TextLabel")
		TextLabel.Size = UDim2.new(0.9500334, -10, 0, 25)
		TextLabel.BackgroundTransparency = 1
		TextLabel.Position = UDim2.new(0.115608, 0, 0, 0)
		TextLabel.TextColor3 = UiButColor
		TextLabel.TextSize = 14
		TextLabel.Text = Text
		TextLabel.Font = Enum.Font.SourceSans
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.Parent = OptionButton

		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingBottom = UDim.new(0, 2)
		UIPadding.Parent = TextLabel
	end

	local function AddHotkey(Hotkey, FrameName, Text, Function)
		local IsDoubleKey = false
		local Key = Hotkey.Value:gsub("Double", "")

		if Hotkey.Value:find("Double") then 
			IsDoubleKey = true 
		end

		local function FunctionHotkey(ActionName, InputState, InputObject)
			if InputState.Name ~= "Begin" then return end
			if Hotkey.Value:find("Double") then
				if not UserInputService:IsKeyDown(Enum.KeyCode[DoubleHotkey.Value]) then return Enum.ContextActionResult.Pass end
			end	

			Function()

			if Hotkey.Value:find("Double") then
				return Enum.ContextActionResult.Sink
			end
			return Enum.ContextActionResult.Pass
		end
		local function BindHotkey()
			if FrameName == "DoubleHotkey" then return end
			ContextActionService:UnbindAction("Emoter"..FrameName)
			ContextActionService:BindAction("Emoter"..FrameName, FunctionHotkey, false, Enum.KeyCode[Key])
		end

		if not GuiActive or GuiRestarted or not HotkeysEnabled then
			ContextActionService:UnbindAction("Emoter"..FrameName)
			return
		end
		BindHotkey()

		if HotkeysStuff:FindFirstChild(FrameName) then return end

		local HotkeyFrame = Instance.new("Frame")
		local HotkeyText = Instance.new("TextLabel")
		local RebindButton = Instance.new("TextButton")
		local DoubleButton = Instance.new("TextButton")

		HotkeyFrame.Name = FrameName
		HotkeyFrame.Size = UDim2.new(1, 0, 0, 25)
		HotkeyFrame.BackgroundTransparency = 1
		HotkeyFrame.Parent = HotkeysStuff

		HotkeyText.Size = UDim2.new(0, 135, 0, 25)
		HotkeyText.BackgroundTransparency = 1
		HotkeyText.TextColor3 = UiButColor
		HotkeyText.TextSize = 14
		HotkeyText.Text = Text
		HotkeyText.TextWrapped = true
		HotkeyText.Font = Enum.Font.SourceSans
		HotkeyText.TextXAlignment = Enum.TextXAlignment.Left
		HotkeyText.Parent = HotkeyFrame
		local UIPadding = Instance.new("UIPadding")
		UIPadding.PaddingBottom = UDim.new(0, 2)
		UIPadding.Parent = HotkeyText

		RebindButton.AnchorPoint = Vector2.new(1, 0.5)
		RebindButton.Size = UDim2.new(0, 43, 0, 21)
		RebindButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		RebindButton.Position = UDim2.new(1, 0, 0.5, 0)
		RebindButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		RebindButton.TextColor3 = Color3.new(0, 0, 0)
		RebindButton.TextSize = 14
		RebindButton.Text = Key or "..."
		RebindButton.Font = Enum.Font.SourceSans
		RebindButton.Parent = HotkeyFrame

		DoubleButton.Parent = HotkeyFrame
		DoubleButton.Name = "DoubleButton"
		DoubleButton.AnchorPoint = Vector2.new(1, 0.5)
		DoubleButton.Size = UDim2.new(0, 15, 0, 15)
		DoubleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DoubleButton.Position = UDim2.new(1, -48, 0.5, 0)
		DoubleButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DoubleButton.TextSize = 22
		DoubleButton.TextColor3 = Color3.fromRGB(129, 129, 129)
		DoubleButton.Text = "+"
		DoubleButton.TextWrapped = true
		DoubleButton.Font = Enum.Font.SourceSansBold
		if IsDoubleKey then
			DoubleButton.BorderSizePixel = 2
			DoubleButton.BorderColor3 = Color3.fromRGB(0, 174, 255)
			DoubleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
		end
		AddHoverText(DoubleButton, "Activate Double Hotkey")

		if FrameName == "DoubleHotkey" then
			RebindButton.Size = UDim2.new(0, 65, 0, 21)
			DoubleButton:Destroy() 
		elseif FrameName == "EmoteWheelHotkey" then
			local SeparateFrame = Instance.new("Frame")
			SeparateFrame.Size = UDim2.new(1, 0, 0, 10)
			SeparateFrame.BackgroundTransparency = 1
			SeparateFrame.Parent = HotkeysStuff
		end

		local isListening = false
		RebindButton.MouseButton1Click:Connect(function()
			if isListening then return end

			isListening = true
			RebindButton.Text = "..."
		end)

		DoubleButton.MouseButton1Click:Connect(function()
			if isListening then return end
			IsDoubleKey = not IsDoubleKey
			if Key ~= "" then
				if IsDoubleKey then
					DoubleButton.BorderColor3 = Color3.fromRGB(0, 174, 255)
					DoubleButton.BorderSizePixel = 2
					DoubleButton.TextColor3 = Color3.fromRGB(0, 0, 0)
					Hotkey.Value = "Double"..Key
					BindHotkey()
				else
					DoubleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
					DoubleButton.BorderSizePixel = 1
					DoubleButton.TextColor3 = Color3.fromRGB(129, 129, 129)
					Hotkey.Value = Key
					BindHotkey()
				end
			end
			if DebugInfoEnabled then print(Hotkey.Value) end
		end)

		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed or not GuiActive or GuiRestarted then return end 

			if isListening then
				if input.UserInputType == Enum.UserInputType.Keyboard then
					if input.KeyCode.Name == "Backspace" or input.KeyCode.Name == "Enter" then
						Hotkey.Value = ""
						Key = ""
						isListening = false
						RebindButton.Text = ""
						DoubleButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
						DoubleButton.BorderSizePixel = 1
						DoubleButton.TextColor3 = Color3.fromRGB(129, 129, 129)
						ContextActionService:UnbindAction("Emoter"..FrameName)
						if DebugInfoEnabled then print("Unbinded") end
						return
					end
					Key = tostring(input.KeyCode.Name)
					if IsDoubleKey then
						Hotkey.Value = "Double"..tostring(input.KeyCode.Name)
					else
						Hotkey.Value = tostring(input.KeyCode.Name)
					end
					isListening = false
					RebindButton.Text = Key
					BindHotkey()
					if DebugInfoEnabled then print(Hotkey.Value) end
				end
				return
			end
		end)
	end

	local function DraggingFunction(Trigger, Frame) --System originally made by Real_IceyDev (@lceyDex) and modernized by me
		local DragToggle = nil
		local DragStart = nil
		local StartPos = nil

		local function updateInput(Input)
			local Delta = Input - DragStart
			local position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
			game:GetService('TweenService'):Create(Frame, TweenInfo.new(DragDelay), {Position = position}):Play()
		end
		Trigger.DragStart:Connect(function(input)
			IsDragging = true
			DragToggle = true
			DragStart = input
			StartPos = Frame.Position
		end)
		Trigger.DragEnd:Connect(function()
			IsDragging = false
			DragToggle = false
		end)
		Trigger.DragContinue:Connect(function(input)
			if DragToggle then
				updateInput(input)
			end
		end)
	end

	-- Creating Objects
	LoadingState = "Building Gui"

	Emoter.Name = "Emoter"
	Emoter.ResetOnSpawn = false
	Emoter.IgnoreGuiInset = true
	Emoter.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	if IsInStudio then --Made this as i test script mostly in Studio
		Emoter.Parent = game.Players.LocalPlayer.PlayerGui
		Emoter.DisplayOrder = 100
	else
		Emoter.Parent = game.CoreGui
		if TopMost then
			Emoter.DisplayOrder = 100
		else
			Emoter.DisplayOrder = -1
		end
	end
	if not IsInStudio then
		Emoter.Enabled = false
	end

	-- SideFrame
	SideFrame.Name = "SideFrame"
	SideFrame.Parent = Emoter
	SideFrame.Active = true
	SideFrame.BackgroundColor3 = BgColor
	SideFrame.Size = UDim2.new(0, 215, 0, 28)
	SideFrame.Visible = false
	SideFrame.Position = UDim2.new(0, 10, 0, 10)

	local UIDragDetectorSideFrame = Instance.new("UIDragDetector")
	UIDragDetectorSideFrame.Parent = SideFrame
	UIDragDetectorSideFrame.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
	UIDragDetectorSideFrame.ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
	DraggingFunction(UIDragDetectorSideFrame, SideFrame)

	SideFrameTitle.Name = "SideFrameTitle"
	SideFrameTitle.Parent = SideFrame
	SideFrameTitle.AnchorPoint = Vector2.new(0.5, 0.5)
	SideFrameTitle.BackgroundTransparency = 1
	SideFrameTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
	SideFrameTitle.Size = UDim2.new(0, 0, 0, 28)
	SideFrameTitle.Font = Enum.Font.SourceSansBold
	SideFrameTitle.TextColor3 = Color3.new(1, 1, 1)
	SideFrameTitle.Text = "Emote GUI"
	SideFrameTitle.TextSize = 22
	SideFrameTitle.TextStrokeTransparency = 0

	SFDestroyGUI.Name = "SFDestroyGUI"
	SFDestroyGUI.Parent = SideFrame
	SFDestroyGUI.AnchorPoint = Vector2.new(1, 0.5)
	SFDestroyGUI.BorderSizePixel = 0
	SFDestroyGUI.Position = UDim2.new(1, 0, 0.5, 0)
	SFDestroyGUI.Size = UDim2.new(0, 28, 0, 28)
	SFDestroyGUI.BackgroundColor3 = BgColor
	SFDestroyGUI.Font = Enum.Font.FredokaOne
	SFDestroyGUI.Text = "X"
	SFDestroyGUI.TextColor3 = UiButColor
	SFDestroyGUI.TextSize = 34
	SFDestroyGUI.TextScaled = true
	AddHoverText(SFDestroyGUI, "Delete GUI")

	OpenGUI.Name = "OpenGUI"
	OpenGUI.Parent = SideFrame
	OpenGUI.AnchorPoint = Vector2.new(0, 0.5)
	OpenGUI.BorderSizePixel = 0
	OpenGUI.BackgroundColor3 = BgColor
	OpenGUI.Position = UDim2.new(0, 0, 0.5, 0)
	OpenGUI.Size = UDim2.new(0, 28, 0, 28)
	OpenGUI.Image = "rbxassetid://101249930107274"
	OpenGUI.ImageColor3 = UiButColor
	AddHoverText(OpenGUI, "Open/Close GUI", CloseHotkey)


	-- MainFrame
	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Emoter
	MainFrame.Active = true
	MainFrame.BackgroundColor3 = BgColor
	MainFrame.BackgroundTransparency = 1
	MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
	MainFrame.Position = UDim2.new(0, 10, 0, 70)

	-- GuiTopFrame
	GuiTopFrame.Name = "GuiTopFrame"
	GuiTopFrame.Parent = MainFrame
	GuiTopFrame.BackgroundColor3 = BgColor
	GuiTopFrame.BorderColor3 = Color3.new(0.243137, 0.243137, 0.243137)
	GuiTopFrame.Size = UDim2.new(1, 0, 0, 32)

	DestroyGUI.Name = "DestroyGUI"
	DestroyGUI.Parent = GuiTopFrame
	DestroyGUI.AnchorPoint = Vector2.new(1, 0.5)
	DestroyGUI.BorderSizePixel = 0
	DestroyGUI.BackgroundColor3 = BgColor
	DestroyGUI.Position = UDim2.new(1, 0, 0.5, 0)
	DestroyGUI.Size = UDim2.new(0, 32, 0, 32)
	DestroyGUI.Font = Enum.Font.FredokaOne
	DestroyGUI.Text = "X"
	DestroyGUI.TextColor3 = UiButColor
	DestroyGUI.TextSize = 34
	DestroyGUI.TextWrapped = true
	AddHoverText(DestroyGUI, "Delete GUI")

	CloseGUI.Name = "CloseGUI"
	CloseGUI.Parent = GuiTopFrame
	CloseGUI.AnchorPoint = Vector2.new(0, 0.5)
	CloseGUI.BackgroundColor3 = BgColor
	CloseGUI.BorderSizePixel = 0
	CloseGUI.Position = UDim2.new(0, 0, 0.5, 0)
	CloseGUI.Size = UDim2.new(0, 32, 0, 32)
	CloseGUI.Image = "rbxassetid://105612912027138"
	CloseGUI.ImageColor3 = UiButColor
	AddHoverText(CloseGUI, "Open/Close GUI", CloseHotkey)

	local SettingsButton = Instance.new("ImageButton")
	SettingsButton.Parent = GuiTopFrame
	SettingsButton.Name = "SettingsButton"
	SettingsButton.BorderSizePixel = 0
	SettingsButton.AnchorPoint = Vector2.new(1, 0.5)
	SettingsButton.Size = UDim2.new(0, 32, 0, 32)
	SettingsButton.Position = UDim2.new(1, -32, 0.5, 0)
	SettingsButton.BackgroundColor3 = BgColor
	SettingsButton.ImageColor3 = UiButColor
	SettingsButton.Image = "rbxassetid://129555881355020"
	AddHoverText(SettingsButton, "Settings", SettingsHotkey)

	Title.Name = "Title"
	Title.Parent = GuiTopFrame
	Title.AnchorPoint = Vector2.new(0.5, 0.5)
	Title.Position = UDim2.new(0.5, 0, 0.5, 0)
	Title.BackgroundColor3 = Color3.new(1, 1, 1)
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(0, 0, 0, 31)
	Title.Text = "Emoter GUI"
	Title.Font = Enum.Font.SourceSansBold
	Title.TextColor3 = Color3.new(1, 1, 1)
	Title.TextSize = 24
	Title.TextStrokeTransparency = 0
	Title.TextWrapped = false

	local UIDragDetectorGuiTopFrame = Instance.new("UIDragDetector")
	UIDragDetectorGuiTopFrame.Parent = GuiTopFrame
	UIDragDetectorGuiTopFrame.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
	UIDragDetectorGuiTopFrame.ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
	DraggingFunction(UIDragDetectorGuiTopFrame, MainFrame)

	-- GuiBottomFrame
	GuiBottomFrame.Name = "GuiBottomFrame"
	GuiBottomFrame.Parent = MainFrame
	GuiBottomFrame.AnchorPoint = Vector2.new(0, 1)
	GuiBottomFrame.Size = UDim2.new(1, 0, 0, 35)
	GuiBottomFrame.Position = UDim2.new(0, 0, 1, 1)
	GuiBottomFrame.Active = true
	GuiBottomFrame.BackgroundColor3 = BgColor

	SpeedFrame.Name = "SpeedFrame"
	SpeedFrame.Parent = GuiBottomFrame
	SpeedFrame.Size = UDim2.new(0.5, 0, 0, 35)
	SpeedFrame.BackgroundTransparency = 1
	SpeedFrame.Active = true

	local SFLayout = Instance.new("UIGridLayout")
	SFLayout.Name = "UIGridLayout"
	SFLayout.Parent = SpeedFrame
	SFLayout.FillDirection = Enum.FillDirection.Vertical
	SFLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFLayout.CellSize = UDim2.new(0, 90, 0, 28)
	SFLayout.VerticalAlignment = Enum.VerticalAlignment.Center

	OptionsButton.Parent = GuiBottomFrame
	OptionsButton.Name = "OptionsButton"
	OptionsButton.AnchorPoint = Vector2.new(0.5, 0.5)
	OptionsButton.Size = UDim2.new(0, 35, 0, 35)
	OptionsButton.Position = UDim2.new(0.5, 0, 0.5, 0)
	OptionsButton.BorderSizePixel = 0
	OptionsButton.BackgroundColor3 = BgColor
	OptionsButton.ImageColor3 = UiButColor
	OptionsButton.Image = "rbxassetid://80468028389803"
	AddHoverText(OptionsButton, "Options")

	local SpeedValue = Instance.new("TextBox")
	SpeedValue.Parent = SpeedFrame
	SpeedValue.Name = "SpeedValue"
	SpeedValue.ClearTextOnFocus = false
	SpeedValue.AnchorPoint = Vector2.new(0.5, 0)
	SpeedValue.Size = UDim2.new(0, 100, 0, 40)
	SpeedValue.LayoutOrder = 2
	SpeedValue.Position = UDim2.new(0.5, 0, 0, 0)
	SpeedValue.BackgroundColor3 = TextBgColor
	SpeedValue.TextColor3 = UiButColor
	SpeedValue.Text = ""
	SpeedValue.PlaceholderText = "0 = Default"
	SpeedValue.Font = Enum.Font.SourceSans
	SpeedValue.TextScaled = true
	AddHoverText(SpeedValue, "Enter a number to add speed")

	local ValueText = Instance.new("TextLabel")
	ValueText.Name = "ValueText"
	ValueText.Parent = SpeedFrame
	ValueText.Size = UDim2.new(0, 200, 0, 50)
	ValueText.BackgroundTransparency = 1
	ValueText.TextStrokeTransparency = 0
	ValueText.TextColor3 = Color3.fromRGB(255, 255, 255)
	ValueText.Text = "Add Speed"
	ValueText.Font = Enum.Font.SourceSansBold
	ValueText.TextScaled = true

	CurAnimInfoTitle.Name = "CurAnimInfoTitle"
	CurAnimInfoTitle.AnchorPoint = Vector2.new(1, 0)
	CurAnimInfoTitle.Size = UDim2.new(0, 0, 0, 35)
	CurAnimInfoTitle.AutomaticSize = Enum.AutomaticSize.X
	CurAnimInfoTitle.BackgroundTransparency = 1
	CurAnimInfoTitle.Position = UDim2.new(1, 0, 0, 0)
	CurAnimInfoTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
	CurAnimInfoTitle.Text = "[info]"
	CurAnimInfoTitle.TextXAlignment = Enum.TextXAlignment.Right
	CurAnimInfoTitle.TextWrapped = true
	CurAnimInfoTitle.Font = Enum.Font.SourceSansBold
	CurAnimInfoTitle.TextScaled = true
	CurAnimInfoTitle.TextStrokeTransparency = 0
	CurAnimInfoTitle.Visible = false
	CurAnimInfoTitle.Parent = GuiBottomFrame
	AddHoverText(CurAnimInfoTitle, AnimInfo)


	--Scrolling Frames
	ScrollingFrameR6.Parent = MainFrame
	ScrollingFrameR6.BackgroundColor3 = ScrollBgColor
	ScrollingFrameR6.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrameR6.ScrollBarImageColor3 = UiButColor
	ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
	ScrollingFrameR6.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	ScrollingFrameR6.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrameR6.ScrollBarThickness = 10

	local SF6UIListLayout = Instance.new("UIListLayout")
	SF6UIListLayout.Parent = ScrollingFrameR6
	SF6UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	SF6UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SF6UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SF6UIListLayout.Wraps = true
	SF6UIListLayout.Padding = UDim.new(0, 7)

	ScrollingFrameR15.Name = "ScrollingFrameR15"
	ScrollingFrameR15.Parent = MainFrame
	ScrollingFrameR15.BackgroundColor3 = ScrollBgColor
	ScrollingFrameR15.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrameR15.ScrollBarImageColor3 = UiButColor
	ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
	ScrollingFrameR15.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	ScrollingFrameR15.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrameR15.Visible = false
	ScrollingFrameR15.ScrollBarThickness = 10

	local SF15UIListLayout = Instance.new("UIListLayout")
	SF15UIListLayout.Parent = ScrollingFrameR15
	SF15UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	SF15UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SF15UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SF15UIListLayout.Wraps = true
	SF15UIListLayout.Padding = UDim.new(0, 7)

	ScrollingFrameSpecific.Name = "ScrollingFrameSpecific"
	ScrollingFrameSpecific.Parent = MainFrame
	ScrollingFrameSpecific.BackgroundColor3 = ScrollBgColor
	ScrollingFrameSpecific.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrameSpecific.ScrollBarImageColor3 = UiButColor
	ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	ScrollingFrameSpecific.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	ScrollingFrameSpecific.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrameSpecific.Visible = false
	ScrollingFrameSpecific.ScrollBarThickness = 10

	local SFSpecListLayout = Instance.new("UIListLayout")
	SFSpecListLayout.Parent = ScrollingFrameSpecific
	SFSpecListLayout.FillDirection = Enum.FillDirection.Horizontal
	SFSpecListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	SFSpecListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFSpecListLayout.Wraps = true
	SFSpecListLayout.Padding = UDim.new(0, 7)

	ScrollingFrameBundles.Parent = MainFrame
	ScrollingFrameBundles.Name = "ScrollingFrameBundles"
	ScrollingFrameBundles.Visible = false
	ScrollingFrameBundles.Size = UDim2.new(1, 0, 1, -69)
	ScrollingFrameBundles.Position = UDim2.new(0, 0, 0, 34)
	ScrollingFrameBundles.BackgroundColor3 = ScrollBgColor
	ScrollingFrameBundles.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrameBundles.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	ScrollingFrameBundles.ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrameBundles.ScrollBarThickness = 10

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Wraps = true
	UIListLayout.Padding = UDim.new(0, 7)
	UIListLayout.Parent = ScrollingFrameBundles


	--Options Frame
	OptionsFrame.Parent = MainFrame
	OptionsFrame.Name = "OptionsFrame"
	OptionsFrame.AnchorPoint = Vector2.new(0.5, 0)
	OptionsFrame.Size = UDim2.new(0, 266, 0, 46)
	OptionsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OptionsFrame.Visible = false
	OptionsFrame.Position = UDim2.new(0.5, 0, 1, -43)
	OptionsFrame.BorderSizePixel = 0
	OptionsFrame.BackgroundColor3 = ScrollBgColor
	OptionsFrame.ZIndex = -1

	local OFUIGridLayout = Instance.new("UIGridLayout")
	OFUIGridLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	OFUIGridLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	OFUIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
	OFUIGridLayout.CellSize = UDim2.new(0, 40, 0, 40)
	OFUIGridLayout.CellPadding = UDim2.new(0, 4, 0, 4)
	OFUIGridLayout.Parent = OptionsFrame

	PauseAnimsButton.Name = "PauseAnimsButton"
	PauseAnimsButton.Size = UDim2.new(0, 100, 0, 100)
	PauseAnimsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PauseAnimsButton.BorderSizePixel = 0
	PauseAnimsButton.BackgroundColor3 = ButtonCol
	PauseAnimsButton.Image = "rbxassetid://103681828169035"
	PauseAnimsButton.Parent = OptionsFrame
	PauseAnimsButton.ZIndex = 0
	AddHoverText(PauseAnimsButton, "Pause animations (May contain bugs!)")

	StopDefAnimsButton.Name = "StopDefAnimsButton"
	StopDefAnimsButton.Size = UDim2.new(0, 100, 0, 100)
	StopDefAnimsButton.BorderSizePixel = 0
	StopDefAnimsButton.BackgroundColor3 = ButtonCol
	StopDefAnimsButton.Image = "rbxassetid://116957047917442"
	StopDefAnimsButton.Parent = OptionsFrame
	StopDefAnimsButton.ZIndex = 0
	if not Player.Character:FindFirstChild(AnimationHandler) then
		StopDefAnimsButton.ImageTransparency = 0.5
		StopDefAnimsButton.Interactable = false
		AddHoverText(StopDefAnimsButton, "This feature isn't supported on this game. Check Wiki for more info")
	else
		AddHoverText(StopDefAnimsButton, "Stop Default Anims. May not work on some games")
	end

	PauseAnimateButton.Name = "PauseAnimateButton"
	PauseAnimateButton.Size = UDim2.new(0, 100, 0, 100)
	PauseAnimateButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PauseAnimateButton.BorderSizePixel = 0
	PauseAnimateButton.BackgroundColor3 = ButtonCol
	PauseAnimateButton.Image = "rbxassetid://109849420482663"
	PauseAnimateButton.Parent = OptionsFrame
	PauseAnimateButton.ZIndex = 0
	if not Player.Character:FindFirstChild(AnimationHandler) then
		PauseAnimateButton.ImageTransparency = 0.5
		PauseAnimateButton.Interactable = false
		AddHoverText(PauseAnimateButton, "This feature isn't supported on this game. Check Wiki for more info")
	else
		AddHoverText(PauseAnimateButton, "Pause Default Animate Script (will look like you're lagging)")
	end

	ReversePlayButton.Parent = OptionsFrame
	ReversePlayButton.Name = "ReversePlayButton"
	ReversePlayButton.ZIndex = 0
	ReversePlayButton.Size = UDim2.new(0, 100, 0, 100)
	ReversePlayButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ReversePlayButton.BorderSizePixel = 0
	ReversePlayButton.BackgroundColor3 = ButtonCol
	ReversePlayButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	ReversePlayButton.Image = "rbxassetid://131026391298968"
	AddHoverText(ReversePlayButton, "Reverse Animation")

	SitButton.Name = "SitButton"
	SitButton.Size = UDim2.new(0, 100, 0, 100)
	SitButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SitButton.BorderSizePixel = 0
	SitButton.BackgroundColor3 = ButtonCol
	SitButton.Image = "rbxassetid://94572819761865"
	SitButton.ImageColor3 = Color3.fromRGB(255, 255, 255)
	SitButton.Parent = OptionsFrame
	SitButton.ZIndex = 0
	AddHoverText(SitButton, "Ragdoll-like falling with sit animation", SitHotkey)

	EmoteWheelButton.Parent = OptionsFrame
	EmoteWheelButton.Name = "EmoteWheelButton"
	EmoteWheelButton.ZIndex = 0
	EmoteWheelButton.Size = UDim2.new(0, 100, 0, 100)
	EmoteWheelButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	EmoteWheelButton.BorderSizePixel = 0
	EmoteWheelButton.BackgroundColor3 = ButtonCol
	EmoteWheelButton.ImageColor3 = UiButColor
	EmoteWheelButton.Image = "rbxassetid://104869367027493"
	EmoteWheelButton.ScaleType = Enum.ScaleType.Crop
	AddHoverText(EmoteWheelButton, "Show Emote wheel", EmoteWheelHotkey)


	--Search Box
	SearchFrame.Parent = MainFrame
	SearchFrame.Name = "SearchFrame"
	SearchFrame.ZIndex = 0
	SearchFrame.AnchorPoint = Vector2.new(1, 0)
	SearchFrame.Size = UDim2.new(0, 164, 0, 35)
	SearchFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchFrame.Position = UDim2.new(1, 31, 0, 34)
	SearchFrame.BorderSizePixel = 0
	SearchFrame.BackgroundColor3 = BgColor

	SearchButton.Name = "SearchButton"
	SearchButton.ZIndex = 0
	SearchButton.AnchorPoint = Vector2.new(1, 0)
	SearchButton.Size = UDim2.new(0, 30, 1, 0)
	SearchButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SearchButton.LayoutOrder = 2
	SearchButton.Position = UDim2.new(1, 0, 0.075, 0)
	SearchButton.BorderSizePixel = 0
	SearchButton.BackgroundColor3 = BgColor
	SearchButton.ScaleType = Enum.ScaleType.Fit
	SearchButton.Image = "rbxassetid://118685771787843"
	SearchButton.ImageColor3 = UiButColor
	SearchButton.Parent = SearchFrame
	AddHoverText(SearchButton, "Search", SearchHotkey)

	SearchBox.Name = "SearchBox"
	SearchBox.ZIndex = 0
	SearchBox.Visible = false
	SearchBox.AnchorPoint = Vector2.new(0.5, 0)
	SearchBox.Size = UDim2.new(0, 139, 0, 29)
	SearchBox.LayoutOrder = 1
	SearchBox.Position = UDim2.new(0.469697, 0, 0.075, 0)
	SearchBox.BackgroundColor3 = TextBgColor
	SearchBox.TextColor3 = UiButColor
	SearchBox.PlaceholderText = "Search..."
	SearchBox.Text = ""
	SearchBox.Font = Enum.Font.SourceSans
	SearchBox.ClearTextOnFocus = false
	SearchBox.TextScaled = true
	SearchBox.TextXAlignment = Enum.TextXAlignment.Left
	SearchBox.Parent = SearchFrame

	BackButton.Name = "BackButton"
	BackButton.ZIndex = 0
	BackButton.Visible = false
	BackButton.AnchorPoint = Vector2.new(1, 0)
	BackButton.Size = UDim2.new(0, 19, 1, 0)
	BackButton.BorderSizePixel = 0
	BackButton.LayoutOrder = 0
	BackButton.Position = UDim2.new(1, 0, 0, 0)
	BackButton.BackgroundColor3 = BgColor
	BackButton.ScaleType = Enum.ScaleType.Crop
	BackButton.Image = "rbxassetid://2418687610"
	BackButton.ImageColor3 = UiButColor
	BackButton.Parent = SearchFrame
	AddHoverText(BackButton, "Hide")

	local SFUIListLayout = Instance.new("UIListLayout")
	SFUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	SFUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	SFUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	SFUIListLayout.Padding = UDim.new(0, 1)
	SFUIListLayout.Parent = SearchFrame


	--CustomAnimFrame
	CustomAnimFrame.Parent = MainFrame
	CustomAnimFrame.Name = "CustomAnimFrame"
	CustomAnimFrame.ZIndex = 0
	CustomAnimFrame.AnchorPoint = Vector2.new(1, 0)
	CustomAnimFrame.Size = UDim2.new(0, 194, 0, 35)
	CustomAnimFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CustomAnimFrame.Position = UDim2.new(1, 31, 0, 73)
	CustomAnimFrame.BorderSizePixel = 0
	CustomAnimFrame.BackgroundColor3 = BgColor

	CustomAnimButton.Name = "CustomAnimButton"
	CustomAnimButton.ZIndex = 0
	CustomAnimButton.Visible = true
	CustomAnimButton.AnchorPoint = Vector2.new(1, 0)
	CustomAnimButton.Size = UDim2.new(0, 30, 1, 0)
	CustomAnimButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	CustomAnimButton.LayoutOrder = 2
	CustomAnimButton.BorderSizePixel = 0
	CustomAnimButton.BackgroundColor3 = BgColor
	CustomAnimButton.ScaleType = Enum.ScaleType.Fit
	CustomAnimButton.Image = "rbxassetid://119465590963527"
	CustomAnimButton.ImageColor3 = UiButColor
	CustomAnimButton.Parent = CustomAnimFrame
	AddHoverText(CustomAnimButton, "Add a temporary animation with Id (Adds to Default section and disappears after reset)")

	IdBox.Name = "IdBox"
	IdBox.ZIndex = 0
	IdBox.Visible = false
	IdBox.AnchorPoint = Vector2.new(0.5, 0)
	IdBox.Size = UDim2.new(0, 139, 0, 29)
	IdBox.LayoutOrder = 1
	IdBox.BackgroundColor3 = TextBgColor
	IdBox.TextWrapped = true
	IdBox.TextColor3 = UiButColor
	IdBox.PlaceholderText = "Enter Id..."
	IdBox.Text = ""
	IdBox.CursorPosition = -1
	IdBox.Font = Enum.Font.SourceSans
	IdBox.TextXAlignment = Enum.TextXAlignment.Left
	IdBox.ClearTextOnFocus = false
	IdBox.TextScaled = true
	IdBox.Parent = CustomAnimFrame

	CustomAnimBackButton.Name = "CustomAnimBackButton"
	CustomAnimBackButton.ZIndex = 0
	CustomAnimBackButton.Visible = false
	CustomAnimBackButton.AnchorPoint = Vector2.new(1, 0)
	CustomAnimBackButton.Size = UDim2.new(0, 19, 1, 0)
	CustomAnimBackButton.BorderSizePixel = 0
	CustomAnimBackButton.BackgroundColor3 = BgColor
	CustomAnimBackButton.ScaleType = Enum.ScaleType.Crop
	CustomAnimBackButton.ImageColor3 = UiButColor
	CustomAnimBackButton.Image = "rbxassetid://2418687610"
	CustomAnimBackButton.Parent = CustomAnimFrame
	AddHoverText(CustomAnimBackButton, "Hide")

	local CAFUIListLayout = Instance.new("UIListLayout")
	CAFUIListLayout.FillDirection = Enum.FillDirection.Horizontal
	CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	CAFUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	CAFUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	CAFUIListLayout.Padding = UDim.new(0, 1)
	CAFUIListLayout.Parent = CustomAnimFrame

	AddTempAnimButton.Name = "PlayAnimButton"
	AddTempAnimButton.ZIndex = 0
	AddTempAnimButton.Visible = false
	AddTempAnimButton.AnchorPoint = Vector2.new(1, 0)
	AddTempAnimButton.Size = UDim2.new(0, 32, 1, 0)
	AddTempAnimButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	AddTempAnimButton.LayoutOrder = 3
	AddTempAnimButton.Position = UDim2.new(1, 0, 0, 0)
	AddTempAnimButton.BorderSizePixel = 0
	AddTempAnimButton.BackgroundColor3 = ButtonCol
	AddTempAnimButton.ScaleType = Enum.ScaleType.Fit
	AddTempAnimButton.ImageColor3 = UiButColor
	AddTempAnimButton.Image = "rbxassetid://15081504003"
	AddTempAnimButton.Parent = CustomAnimFrame
	AddHoverText(AddTempAnimButton, "Add animation (On start of animations frame)")


	--Choose ScrollingFrame Buttons
	local SectionsFrame = Instance.new("Frame")
	SectionsFrame.Parent = MainFrame
	SectionsFrame.Name = "SectionsFrame"
	SectionsFrame.ZIndex = 0
	SectionsFrame.Size = UDim2.new(0, 95, 0, 77)
	SectionsFrame.BackgroundTransparency = 1
	SectionsFrame.Position = UDim2.new(1, -2, 1, -112)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.Wraps = true
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)
	UIListLayout.Parent = SectionsFrame


	DefaultSection.Name = "DefaultSection"
	DefaultSection.ZIndex = 0
	DefaultSection.Size = UDim2.new(0, 80, 0, 23)
	DefaultSection.LayoutOrder = 1
	DefaultSection.BorderSizePixel = 0
	DefaultSection.BackgroundColor3 = BgColor
	DefaultSection.TextSize = 22
	DefaultSection.RichText = true
	DefaultSection.TextColor3 = UiButColor
	DefaultSection.Text = "<b>General</b>"
	DefaultSection.Font = Enum.Font.Roboto
	DefaultSection.TextXAlignment = Enum.TextXAlignment.Left
	DefaultSection.Parent = SectionsFrame
	DefaultSection.Font = Enum.Font.Roboto
	DefaultSection.TextXAlignment = Enum.TextXAlignment.Left
	AddHoverText(DefaultSection, "General Animations")
	local DSUIStroke = Instance.new("UIStroke", DefaultSection)
	DSUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	DSUIStroke.Thickness = 2

	SpecGameSection.Name = "SpecGameSection"
	SpecGameSection.ZIndex = 0
	SpecGameSection.Size = UDim2.new(0, 64, 0, 23)
	SpecGameSection.LayoutOrder = 2
	SpecGameSection.BorderSizePixel = 0
	SpecGameSection.BackgroundColor3 = BgColor
	SpecGameSection.TextSize = 22
	SpecGameSection.RichText = true
	SpecGameSection.TextColor3 = UiButColor
	SpecGameSection.Text = "<b>Game</b>"
	SpecGameSection.Font = Enum.Font.Roboto
	SpecGameSection.TextXAlignment = Enum.TextXAlignment.Left
	SpecGameSection.Parent = SectionsFrame
	local SGSUIStroke = Instance.new("UIStroke", SpecGameSection)
	SGSUIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	SGSUIStroke.Thickness = 2

	BundlesSection.Name = "BundlesSection"
	BundlesSection.ZIndex = 0
	BundlesSection.Size = UDim2.new(0, 83, 0, 23)
	BundlesSection.LayoutOrder = 3
	BundlesSection.BorderSizePixel = 0
	BundlesSection.BackgroundColor3 = BgColor
	BundlesSection.TextSize = 22
	BundlesSection.RichText = true
	BundlesSection.TextColor3 = UiButColor
	BundlesSection.Text = "<b>Bundles</b>"
	BundlesSection.Font = Enum.Font.Roboto
	BundlesSection.TextXAlignment = Enum.TextXAlignment.Left
	BundlesSection.Parent = SectionsFrame


	--EmoteWheel
	EmoteWheel.Parent = Emoter
	EmoteWheel.Name = "EmoteWheel"
	EmoteWheel.AnchorPoint = Vector2.new(0.5, 0.5)
	EmoteWheel.Size = UDim2.new(0, 380, 0, 380)
	EmoteWheel.BackgroundTransparency = 1
	EmoteWheel.Position = UDim2.new(0.5, 0, 0.5, 0)
	EmoteWheel.Visible = false
	local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
	UIAspectRatioConstraint.Parent = EmoteWheel

	local ShadowFrame = Instance.new("Frame")
	ShadowFrame.Parent = EmoteWheel
	ShadowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ShadowFrame.Size = UDim2.new(1, 0, 1, 0)
	ShadowFrame.Position = UDim2.new(0.5,0,0.5,0)
	ShadowFrame.BackgroundTransparency = 1
	ShadowFrame.ZIndex = 100

	local UICorner = Instance.new("UICorner")
	UICorner.Parent = ShadowFrame
	UICorner.CornerRadius = UDim.new(1, 0)

	local OutUIShadow = Instance.new("UIShadow")
	OutUIShadow.Parent = ShadowFrame
	OutUIShadow.BlurRadius = UDim.new(0, 15)
	OutUIShadow.Transparency = 0.35
	OutUIShadow.Spread = UDim2.new(0.19, 0, 0.19, 0)
	OutUIShadow.ZIndex = 100
	local InUIShadow = Instance.new("UIShadow")
	InUIShadow.Parent = ShadowFrame
	InUIShadow.BlurRadius = UDim.new(0, 15)
	InUIShadow.Transparency = 0.35
	InUIShadow.Spread = UDim2.new(-0.4, 0, -0.4, 0)
	InUIShadow.ZIndex = 100

	EmoteWheelText.Parent = EmoteWheel
	EmoteWheelText.Name = "Text"
	EmoteWheelText.AnchorPoint = Vector2.new(0.5, 0.5)
	EmoteWheelText.Size = UDim2.new(0.5, 0, 0.1, 0)
	EmoteWheelText.BackgroundTransparency = 1
	EmoteWheelText.Position = UDim2.new(0.5, 0, 0.5, 0)
	EmoteWheelText.TextStrokeTransparency = 0
	EmoteWheelText.TextSize = 14
	EmoteWheelText.TextColor3 = Color3.fromRGB(255, 255, 255)
	EmoteWheelText.RichText = true
	EmoteWheelText.Font = Enum.Font.Roboto
	EmoteWheelText.Text = "<b>Select an Emote</b>"
	EmoteWheelText.TextScaled = true
	EmoteWheelText.ZIndex = 100

	Emote1.Name = "Emote1"
	Emote1.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote1.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote1.Position = UDim2.new(0.5, 0, 0.09, 0)
	Emote1.BackgroundColor3 = ButtonCol
	Emote1.TextColor3 = UiButColor
	Emote1.Font = Enum.Font.SourceSansBold
	Emote1.TextScaled = true
	Emote1.ZIndex = 100
	Emote1.Parent = EmoteWheel

	Emote2.Name = "Emote2"
	Emote2.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote2.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote2.Position = UDim2.new(0.8, 0, 0.2, 0)
	Emote2.BackgroundColor3 = ButtonCol
	Emote2.TextColor3 = UiButColor
	Emote2.Font = Enum.Font.SourceSansBold
	Emote2.TextScaled = true
	Emote2.ZIndex = 100
	Emote2.Parent = EmoteWheel

	Emote3.Name = "Emote3"
	Emote3.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote3.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote3.Position = UDim2.new(0.91, 0, 0.5, 0)
	Emote3.BackgroundColor3 = ButtonCol
	Emote3.TextColor3 = UiButColor
	Emote3.Font = Enum.Font.SourceSansBold
	Emote3.TextScaled = true
	Emote3.ZIndex = 100
	Emote3.Parent = EmoteWheel

	Emote4.Name = "Emote4"
	Emote4.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote4.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote4.Position = UDim2.new(0.8, 0, 0.8, 0)
	Emote4.BackgroundColor3 = ButtonCol
	Emote4.TextColor3 = UiButColor
	Emote4.Font = Enum.Font.SourceSansBold
	Emote4.TextScaled = true
	Emote4.ZIndex = 100
	Emote4.Parent = EmoteWheel

	Emote5.Name = "Emote5"
	Emote5.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote5.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote5.Position = UDim2.new(0.5, 0, 0.91, 0)
	Emote5.BackgroundColor3 = ButtonCol
	Emote5.TextColor3 = UiButColor
	Emote5.Font = Enum.Font.SourceSansBold
	Emote5.TextScaled = true
	Emote5.ZIndex = 100
	Emote5.Parent = EmoteWheel

	Emote6.Name = "Emote6"
	Emote6.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote6.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote6.Position = UDim2.new(0.2, 0, 0.8, 0)
	Emote6.BackgroundColor3 = ButtonCol
	Emote6.TextColor3 = UiButColor
	Emote6.Font = Enum.Font.SourceSansBold
	Emote6.TextScaled = true
	Emote6.ZIndex = 100
	Emote6.Parent = EmoteWheel

	Emote7.Name = "Emote7"
	Emote7.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote7.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote7.Position = UDim2.new(0.09, 0, 0.5, 0)
	Emote7.BackgroundColor3 = ButtonCol
	Emote7.TextColor3 = UiButColor
	Emote7.Font = Enum.Font.SourceSansBold
	Emote7.TextScaled = true
	Emote7.ZIndex = 100
	Emote7.Parent = EmoteWheel

	Emote8.Name = "Emote8"
	Emote8.AnchorPoint = Vector2.new(0.5, 0.5)
	Emote8.Size = UDim2.new(0.23, 0, 0.23, 0)
	Emote8.Position = UDim2.new(0.2, 0, 0.2, 0)
	Emote8.BackgroundColor3 = ButtonCol
	Emote8.TextColor3 = UiButColor
	Emote8.Font = Enum.Font.SourceSansBold
	Emote8.TextScaled = true
	Emote8.ZIndex = 100
	Emote8.Parent = EmoteWheel


	--SettingsFrame
	CreateDivideFrame("Animation", 1, "Settings")
	CreateDivideFrame("Running & Idle", 2, "Settings")
	CreateDivideFrame("Style", 3, "Settings")
	CreateDivideFrame("Hotkeys", 4, "Settings")
	CreateDivideFrame("Data", 5, "Settings")

	SettingsFrame.Parent = Emoter
	SettingsFrame.Name = "SettingsFrame"
	SettingsFrame.AnchorPoint = Vector2.new(0.5, 0)
	SettingsFrame.Size = UDim2.new(0, 220, 0, 286)
	SettingsFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SettingsFrame.Position = MainFrame.Position + UDim2.new(-1, 0, 0, 0)
	SettingsFrame.BorderSizePixel = 0
	SettingsFrame.BackgroundColor3 = ScrollBgColor
	SettingsFrame.Visible = false

	local UIShadow = Instance.new("UIShadow")
	UIShadow.BlurRadius = UDim.new(0, 20)
	UIShadow.Transparency = 0.5
	UIShadow.Parent = SettingsFrame

	local UIDragDetectorSettings = Instance.new("UIDragDetector")
	UIDragDetectorSettings.Parent = SettingsFrame
	UIDragDetectorSettings.DragStyle = Enum.UIDragDetectorDragStyle.Scriptable
	UIDragDetectorSettings.ResponseStyle = Enum.UIDragDetectorResponseStyle.CustomOffset
	DraggingFunction(UIDragDetectorSettings, SettingsFrame)

	SGSNotification.Parent = SettingsFrame
	SGSNotification.Name = "SGSNotification"
	SGSNotification.AutoButtonColor = false
	SGSNotification.Size = UDim2.new(0, 20, 0, 20)
	SGSNotification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SGSNotification.BackgroundTransparency = 1
	SGSNotification.Position = UDim2.new(0, 2, 0, 28)
	SGSNotification.BorderSizePixel = 0
	SGSNotification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SGSNotification.Image = "rbxassetid://76962094933629"
	AddHoverText(SGSNotification, "The settings was loaded from file for only <b>this</b> game (click RMB to delete this file)")
	if IsDefaultSettings then
		SGSNotification.Visible = false
	end

	DataNotification.Parent = SettingsFrame
	DataNotification.Visible = false
	DataNotification.Name = "AddedDataNotification"
	DataNotification.AutoButtonColor = false
	DataNotification.Size = UDim2.new(0, 25, 0, 25)
	DataNotification.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DataNotification.BackgroundTransparency = 1
	DataNotification.Position = UDim2.new(0, 0, 0, 1)
	DataNotification.BorderSizePixel = 0
	DataNotification.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DataNotification.Image = "rbxassetid://85975257618857"
	AddHoverText(DataNotification, AddedDataInfo)

	GuiName.Name = "Name"
	GuiName.AnchorPoint = Vector2.new(0.5, 0)
	GuiName.Size = UDim2.new(0, 0, 0, 25)
	GuiName.BackgroundTransparency = 1
	GuiName.Position = UDim2.new(0.5, 0, 0, 5)
	GuiName.TextSize = 25
	GuiName.Text = "Emoter GUI"
	GuiName.Font = Enum.Font.Highway
	GuiName.TextColor3 = UiButColor
	GuiName.Parent = SettingsFrame
	if IsBetaBuild then
		GuiName.Text = "Emoter BETA"
	end

	AutorText.Name = "AutorText"
	AutorText.AnchorPoint = Vector2.new(0.5, 0)
	AutorText.Size = UDim2.new(0, 0, -0.025, 25)
	AutorText.LayoutOrder = 1
	AutorText.BackgroundTransparency = 1
	AutorText.Position = UDim2.new(0.5, 0, 0, 27)
	AutorText.TextSize = 17
	AutorText.Text = "by Fixel"
	AutorText.Font = Enum.Font.SourceSans
	AutorText.TextColor3 = UiButColor
	AutorText.Parent = SettingsFrame

	VersionText.Parent = SettingsFrame
	VersionText.Name = "VersionText"
	VersionText.AnchorPoint = Vector2.new(1, 0)
	VersionText.Size = UDim2.new(0.2124352, 0, -0.025, 25)
	VersionText.LayoutOrder = 1
	VersionText.BackgroundTransparency = 1
	VersionText.Position = UDim2.new(1, -2, 0, 0)
	VersionText.TextSize = 14
	VersionText.Text = "V"..ScriptVersion
	VersionText.TextColor3 = Color3.fromRGB(147, 147, 147)
	VersionText.TextWrapped = true
	VersionText.Font = Enum.Font.SourceSans
	VersionText.TextXAlignment = Enum.TextXAlignment.Right
	VersionText.TextYAlignment = Enum.TextYAlignment.Top

	WarningText.Parent = SettingsFrame
	WarningText.Name = "WarningText"
	WarningText.Visible = false
	WarningText.AnchorPoint = Vector2.new(0.5, 0)
	WarningText.Size = UDim2.new(0, 220, 0, 35)
	WarningText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WarningText.BackgroundTransparency = 1
	WarningText.Position = UDim2.new(0.5, 0, 1, 5)
	WarningText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)
	WarningText.TextStrokeTransparency = 0
	WarningText.TextSize = 14
	WarningText.RichText = true
	WarningText.TextColor3 = Color3.fromRGB(0, 0, 0)
	WarningText.Text = "Do you want to save settings to main file while having specific settings? (Click again to proceed)"
	WarningText.TextWrapped = true
	WarningText.Font = Enum.Font.SourceSans

	local UIStroke = Instance.new("UIStroke")
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Thickness = 2
	UIStroke.Parent = WarningText

	SettingsStuff.Name = "SettingsStuff"
	SettingsStuff.Size = UDim2.new(1, 0, 0.648, 0)
	SettingsStuff.BackgroundTransparency = 1
	SettingsStuff.Position = UDim2.new(0, 0, 0.18, 0)
	SettingsStuff.ScrollBarImageColor3 = UiButColor
	SettingsStuff.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	SettingsStuff.AutomaticCanvasSize = Enum.AutomaticSize.Y
	SettingsStuff.ScrollBarThickness = 3
	SettingsStuff.Parent = SettingsFrame

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = SettingsStuff

	ThemeOption.Name = "ThemeOption"
	ThemeOption.Size = UDim2.new(1, 0, 0, 25)
	ThemeOption.LayoutOrder = 3
	ThemeOption.BackgroundTransparency = 1
	ThemeOption.Parent = SettingsStuff

	local UIListLayout5 = Instance.new("UIListLayout")
	UIListLayout5.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout5.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout5.Padding = UDim.new(0, 5)
	UIListLayout5.Parent = ThemeOption

	ThemeOptionText.Name = "ThemeOptionText"
	ThemeOptionText.Size = UDim2.new(0, 124, 0, 25)
	ThemeOptionText.BackgroundTransparency = 1
	ThemeOptionText.TextSize = 14
	ThemeOptionText.TextColor3 = UiButColor
	ThemeOptionText.Text = "Theme"
	ThemeOptionText.Font = Enum.Font.SourceSans
	ThemeOptionText.TextXAlignment = Enum.TextXAlignment.Left
	ThemeOptionText.Parent = ThemeOption

	PurpleThemeColor.Name = "PurpleThemeColor"
	PurpleThemeColor.Size = UDim2.new(0, 15, 0, 15)
	PurpleThemeColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
	PurpleThemeColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PurpleThemeColor.Text = ""
	PurpleThemeColor.Parent = ThemeOption
	AddHoverText(PurpleThemeColor, "Light theme with purple parts")

	local PurpleGradient = Instance.new("UIGradient")
	PurpleGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(137, 165, 255)), ColorSequenceKeypoint.new(0.4342561, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
	PurpleGradient.Rotation = 90
	PurpleGradient.Parent = PurpleThemeColor

	OrangeThemeColor.Name = "OrangeThemeColor"
	OrangeThemeColor.Size = UDim2.new(0, 15, 0, 15)
	OrangeThemeColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
	OrangeThemeColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	OrangeThemeColor.Text = ""
	OrangeThemeColor.Parent = ThemeOption
	AddHoverText(OrangeThemeColor, "Light theme with orange parts")

	local OrangeGradient = Instance.new("UIGradient")
	OrangeGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 171, 35)), ColorSequenceKeypoint.new(0.4342561, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
	OrangeGradient.Rotation = 90
	OrangeGradient.Parent = OrangeThemeColor

	YellowThemeColor.Name = "YellowThemeColor"
	YellowThemeColor.Size = UDim2.new(0, 15, 0, 15)
	YellowThemeColor.BorderColor3 = Color3.fromRGB(0, 0, 0)
	YellowThemeColor.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	YellowThemeColor.Text = ""
	YellowThemeColor.Parent = ThemeOption
	AddHoverText(YellowThemeColor, "Light theme with yellow parts")

	local YellowGradient = Instance.new("UIGradient")
	YellowGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 250, 112)), ColorSequenceKeypoint.new(0.4342561, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))})
	YellowGradient.Rotation = 90
	YellowGradient.Parent = YellowThemeColor

	BlackThemeColor.Name = "BlackThemeColor"
	BlackThemeColor.Size = UDim2.new(0, 15, 0, 15)
	BlackThemeColor.LayoutOrder = 1
	BlackThemeColor.BorderColor3 = UiButColor
	BlackThemeColor.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
	BlackThemeColor.Text = ""
	BlackThemeColor.Parent = ThemeOption
	AddHoverText(BlackThemeColor, "Black theme")

	local YSizeOption = Instance.new("Frame")
	YSizeOption.Parent = SettingsStuff
	YSizeOption.Name = "YSizeOptionOption"
	YSizeOption.Size = UDim2.new(1, 0, 0, 25)
	YSizeOption.LayoutOrder = 3
	YSizeOption.BackgroundTransparency = 1

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.Parent = YSizeOption

	local YSizeOptionText = Instance.new("TextLabel")
	YSizeOptionText.Name = "YSizeOptionText"
	YSizeOptionText.Size = UDim2.new(0, 94, 0, 25)
	YSizeOptionText.BackgroundTransparency = 1
	YSizeOptionText.TextSize = 14
	YSizeOptionText.TextColor3 = UiButColor
	YSizeOptionText.Text = "Vertical size"
	YSizeOptionText.Font = Enum.Font.SourceSans
	YSizeOptionText.TextXAlignment = Enum.TextXAlignment.Left
	YSizeOptionText.Parent = YSizeOption

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingBottom = UDim.new(0, 2)
	UIPadding.Parent = YSizeOptionText

	local X05YSixe = Instance.new("TextButton")
	X05YSixe.Name = "X05YSixe"
	X05YSixe.Size = UDim2.new(0, 25, 0, 15)
	X05YSixe.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X05YSixe.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X05YSixe.Text = "0.5x"
	X05YSixe.Parent = YSizeOption

	local X1YSize = Instance.new("TextButton")
	X1YSize.Name = "X1YSize"
	X1YSize.Size = UDim2.new(0, 20, 0, 15)
	X1YSize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X1YSize.Position = UDim2.new(0.5861111, 0, 0.2, 0)
	X1YSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X1YSize.Text = "1x"
	X1YSize.Parent = YSizeOption

	local X15YSize = Instance.new("TextButton")
	X15YSize.Name = "X15YSize"
	X15YSize.Size = UDim2.new(0, 25, 0, 15)
	X15YSize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X15YSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X15YSize.Text = "1.5x"
	X15YSize.Parent = YSizeOption

	local X2YSize = Instance.new("TextButton")
	X2YSize.Name = "X2YSize"
	X2YSize.Size = UDim2.new(0, 20, 0, 15)
	X2YSize.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X2YSize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X2YSize.Text = "2x"
	X2YSize.Parent = YSizeOption

	local XSizeOption = Instance.new("Frame")
	XSizeOption.Parent = SettingsStuff
	XSizeOption.Name = "XSizeOption"
	XSizeOption.Size = UDim2.new(1, 0, 0, 25)
	XSizeOption.LayoutOrder = 3
	XSizeOption.BackgroundTransparency = 1

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.Parent = XSizeOption

	local XSizeOptionText = Instance.new("TextLabel")
	XSizeOptionText.Name = "XSizeOptionText"
	XSizeOptionText.Size = UDim2.new(0, 104, 0, 25)
	XSizeOptionText.BackgroundTransparency = 1
	XSizeOptionText.TextSize = 14
	XSizeOptionText.TextColor3 = UiButColor
	XSizeOptionText.Text = "Horizontal size"
	XSizeOptionText.Font = Enum.Font.SourceSans
	XSizeOptionText.TextXAlignment = Enum.TextXAlignment.Left
	XSizeOptionText.Parent = XSizeOption

	local UIPadding = Instance.new("UIPadding")
	UIPadding.PaddingBottom = UDim.new(0, 2)
	UIPadding.Parent = XSizeOptionText

	local X2Size = Instance.new("TextButton")
	X2Size.Name = "X2Sixe"
	X2Size.Size = UDim2.new(0, 20, 0, 15)
	X2Size.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X2Size.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X2Size.Text = "2x"
	X2Size.Parent = XSizeOption

	local X3Size = Instance.new("TextButton")
	X3Size.Name = "X3Size"
	X3Size.Size = UDim2.new(0, 20, 0, 15)
	X3Size.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X3Size.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X3Size.Text = "3x"
	X3Size.Parent = XSizeOption

	local X4Size = Instance.new("TextButton")
	X4Size.Name = "X4Size"
	X4Size.Size = UDim2.new(0, 20, 0, 15)
	X4Size.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X4Size.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X4Size.Text = "4x"
	X4Size.Parent = XSizeOption

	local X5Size = Instance.new("TextButton")
	X5Size.Name = "X5Size"
	X5Size.Size = UDim2.new(0, 20, 0, 15)
	X5Size.BorderColor3 = Color3.fromRGB(0, 0, 0)
	X5Size.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	X5Size.Text = "5x"
	X5Size.Parent = XSizeOption

	AddSetting(AnimPreviewEnabled, "PreviewOption", "Enable Animation Preview", 0)
	AddSetting(DebugInfoEnabled, "DebugInfoOption", "Show Debug information", 0)
	AddSetting(AnalyticsEnabled, "AnalyticsOption", "Enable analytics (hover for info)", 0)
	AddSetting(LoadAnimationsOnRestart, "LoadAnimationsOnRestartOption", "Play Movement anims on reset", 0)
	AddSetting(LoadAllAnimationsOnRestart, "LoadAllAnimationsOnRestartOption", "Play ALL animations on reset", 0)
	AddSetting(TopMost, "TopMostOption", "Top most", 0)
	AddSetting(LaunchBetaBuild, "LaunchBetaBuildOption", "Open Beta Build on launch*", 0)
	AddSetting(SpecCategoryOnLaunch, "SpecCategoryOnLaunchOption", "Show Specific category on launch", 0)

	AddSetting(ToolIdleAnimHighPriorEnabled, "ToolIdlePriorityOption", "High priority on ToolIdle anims", 1)
	AddSetting(ToolActionAnimHighPriorEnabled, "ToolActionPriorityOption", "High priority on ToolAction anims", 1)
	AddSetting(AnimSwitchModeEnabled, "SwitchOption", "Animations Switch mode", 1)
	AddSetting(AnimSwitchModeRunIdleExceptionEnabled, "SwitchRunIdleExceptionOption", "Exception for Movement anims", 1)
	AddSetting(BundleAnimSwitchModeEnabled, "BundleSwitchOption", "Bundle Animations Switch mode", 1)
	AddSetting(AnimSmoothFadeEnabled, "AnimFadeOption", "Enable Animation's FadeTime", 1)
	AddSetting(HigherPriorityEnabled, "HigherPriorityOption", "Animations Higher priority", 1)

	AddSetting(IdleTypeEnabled, "IdleTypeOption", "Enable 'Idle' type", 2)
	AddSetting(RunningTypeEnabled, "RunningTypeOption", "Enable 'Running' type", 2)
	AddSetting(RunningTypeStopStandingEnabled, "RunningTypeStopStandingOption", "Stop Running animation while not running", 2)
	AddSetting(RunningTypeCharSpeedEnabled, "RunningTypeCharSpeedOption", "AnimSpeed depends on character's", 2)
	AddSetting(RunningTypeMinSpeedEnabled, "RunningTypeMinSpeedOption", "Enable 'MinimumSpeed' value", 2)
	AddSetting(RunningTypeStopJumpingEnabled, "RunningTypeStopJumpingOption", "Stop animation while jumping", 2)
	AddSetting(RunningTypeStopClimbingEnabled, "RunningTypeStopClimbingOption", "Stop animation while climbing", 2)

	AddSetting(UICornerEnabled, "UICornerOption", "Enable UICorners", 3)
	AddSetting(UIGradientEnabled, "UIGradientOption", "Enable UIGradients", 3)
	AddSetting(HotkeysEnabled, "HotkeysOption", "Enable Hotkeys", 4)

	AddSetting(LoadGithubCustomAnimsEnabled, "LoadGithubCustomAnimOption", "Load AdditionalAnims from Github", 5)
	AddSetting(LoadLocalCustomAnimsEnabled, "LoadLocalCustomAnimOption", "Load AdditionalAnims from local", 5)
	AddSetting(LoadGithubSGAEnabled, "LoadGithubSGAOption", "Load SpecificGameAnims from Github", 5)
	AddSetting(LoadLocalSGAEnabled, "LoadLocalSGAOption", "Load SpecificGameAnims from local", 5)

	DragDelayOption.Parent = SettingsStuff
	DragDelayOption.LayoutOrder = 3
	DragDelayOption.Name = "DragDelayOption"
	DragDelayOption.Size = UDim2.new(1, 0, 0, 25)
	DragDelayOption.BackgroundTransparency = 1
	AddHoverText(DragDelayOption, "Number of drag smoothness. Еhe higher the number the smoother and slower GUI element will move. If at 0, it will move without smooth")

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)
	UIListLayout.Parent = DragDelayOption

	DragOptionText.Name = "DragOptionText"
	DragOptionText.Size = UDim2.new(0, 164, 0, 25)
	DragOptionText.BackgroundTransparency = 1
	DragOptionText.TextSize = 14
	DragOptionText.TextColor3 = UiButColor
	DragOptionText.Text = "Drag Smoothness"
	DragOptionText.Font = Enum.Font.SourceSans
	DragOptionText.TextXAlignment = Enum.TextXAlignment.Left
	DragOptionText.Parent = DragDelayOption

	DelayNumBox.Size = UDim2.new(0, 35, 0, 20)
	DelayNumBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
	DelayNumBox.BackgroundColor3 = TextBgColor
	DelayNumBox.TextSize = 14
	DelayNumBox.TextColor3 = UiButColor
	DelayNumBox.ClearTextOnFocus = false
	DelayNumBox.Text = DragDelay
	DelayNumBox.PlaceholderText = "0"
	DelayNumBox.CursorPosition = -1
	DelayNumBox.Font = Enum.Font.SourceSans
	DelayNumBox.Parent = DragDelayOption

	HotkeysEditOption.Name = "HotkeysEditOption"
	HotkeysEditOption.Size = UDim2.new(0.55, 0, 0, 20)
	HotkeysEditOption.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HotkeysEditOption.LayoutOrder = 4
	HotkeysEditOption.Position = UDim2.new(0, 0, 0.1558714, 0)
	HotkeysEditOption.BorderSizePixel = 0
	HotkeysEditOption.BackgroundColor3 = ButtonCol
	HotkeysEditOption.TextColor3 = UiButColor
	HotkeysEditOption.TextSize = 14
	HotkeysEditOption.Text = "Edit Hotkeys..."
	HotkeysEditOption.Font = Enum.Font.SourceSans
	HotkeysEditOption.Parent = SettingsStuff

	local UIListLayout7 = Instance.new("UIListLayout")
	UIListLayout7.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout7.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout7.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout7.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout7.Padding = UDim.new(0, 5)
	UIListLayout7.Parent = HotkeysEditOption

	HotkeysFrame.Name = "HotkeysFrame"
	HotkeysFrame.AnchorPoint = Vector2.new(0, 0.5)
	HotkeysFrame.Size = UDim2.new(0, 220, 0, 138)
	HotkeysFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HotkeysFrame.Position = UDim2.new(1, 10, 0.76, 0)
	HotkeysFrame.BorderSizePixel = 0
	HotkeysFrame.BackgroundColor3 = ScrollBgColor
	HotkeysFrame.Visible = false
	HotkeysFrame.Parent = SettingsFrame

	HotkeysStuff.Name = "HotkeysStuff"
	HotkeysStuff.Size = UDim2.new(1, 0, 0.845, 0)
	HotkeysStuff.BackgroundTransparency = 1
	HotkeysStuff.Position = UDim2.new(0, 0, 0.155, 0)
	HotkeysStuff.ScrollBarImageColor3 = UiButColor
	HotkeysStuff.CanvasSize = UDim2.new(0, 0, 0.5, 10)
	HotkeysStuff.AutomaticCanvasSize = Enum.AutomaticSize.Y
	HotkeysStuff.HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar
	HotkeysStuff.ScrollBarThickness = 3
	HotkeysStuff.Parent = HotkeysFrame

	local UIListLayout8 = Instance.new("UIListLayout")
	UIListLayout8.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout8.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout8.Parent = HotkeysStuff

	HotkeyFrameName.Name = "Name"
	HotkeyFrameName.Size = UDim2.new(1, 0, -0.043, 25)
	HotkeyFrameName.BackgroundTransparency = 1
	HotkeyFrameName.Position = UDim2.new(0, 0, 0.018, 0)
	HotkeyFrameName.TextColor3 = UiButColor
	HotkeyFrameName.TextSize = 14
	HotkeyFrameName.Text = "Hotkeys"
	HotkeyFrameName.TextWrapped = true
	HotkeyFrameName.Font = Enum.Font.Highway
	HotkeyFrameName.TextScaled = true
	HotkeyFrameName.Parent = HotkeysFrame

	MoreButtonsFrame.Parent = SettingsFrame
	MoreButtonsFrame.Name = "MoreButtonsFrame"
	MoreButtonsFrame.Interactable = true
	MoreButtonsFrame.AnchorPoint = Vector2.new(0, 1)
	MoreButtonsFrame.Size = UDim2.new(1, 0, 0, 50)
	MoreButtonsFrame.BackgroundTransparency = 1
	MoreButtonsFrame.Position = UDim2.new(0, 0, 1, 0)

	local UIListLayout = Instance.new("UIListLayout")
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 22)
	UIListLayout.Parent = MoreButtonsFrame

	SaveSettingsButton.Name = "SaveSettingsButton"
	SaveSettingsButton.Size = UDim2.new(0, 35, 0, 35)
	SaveSettingsButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
	SaveSettingsButton.Position = UDim2.new(0.0518135, 0, 0.845614, 0)
	SaveSettingsButton.BorderSizePixel = 0
	SaveSettingsButton.BackgroundColor3 = ButtonCol
	SaveSettingsButton.Image = "rbxassetid://11768914234"
	SaveSettingsButton.ImageColor3 = UiButColor
	SaveSettingsButton.Parent = MoreButtonsFrame
	AddHoverText(SaveSettingsButton, "Save settings. RMB will save settings for <b>only</b> this game")

	LaunchIdDetectorButton.Name = "LaunchIdDetectorButton"
	LaunchIdDetectorButton.Size = UDim2.new(0, 35, 0, 35)
	LaunchIdDetectorButton.Position = UDim2.new(0.4093264, 0, 0.845614, 0)
	LaunchIdDetectorButton.BackgroundColor3 = ButtonCol
	LaunchIdDetectorButton.ImageColor3 = UiButColor
	LaunchIdDetectorButton.Image = "rbxassetid://88751076321975"
	LaunchIdDetectorButton.Parent = MoreButtonsFrame
	AddHoverText(LaunchIdDetectorButton, "Launch IdDetector Script")

	ResetButton.Parent = MoreButtonsFrame
	ResetButton.Name = "ResetButton"
	ResetButton.Size = UDim2.new(0, 35, 0, 35)
	ResetButton.Position = UDim2.new(0.2487047, 0, 0.8561404, 0)
	ResetButton.BackgroundColor3 = ButtonCol
	ResetButton.Image = "rbxassetid://84090157888894"
	ResetButton.ImageColor3 = UiButColor
	AddHoverText(ResetButton, "Reset Gui")

	GithubLinkButton.Name = "GithubLinkButton"
	GithubLinkButton.Size = UDim2.new(0, 35, 0, 35)
	GithubLinkButton.Position = UDim2.new(0.7720207, 0, 0.845614, 0)
	GithubLinkButton.BackgroundColor3 = ButtonCol
	GithubLinkButton.Image = "rbxassetid://133448000957069"
	GithubLinkButton.ImageColor3 = UiButColor
	GithubLinkButton.Parent = MoreButtonsFrame
	AddHoverText(GithubLinkButton, "Get the Github for Tutorials and more Info! (Copy Link)")


	--Functions
	--Hotkey Functions
	LoadingState = "Loading Hotkeys"

	local function CloseGuiFunction()
		if MainFrame.Visible == true then
			SideFrame.Position = MainFrame.Position
		else
			MainFrame.Position = SideFrame.Position
		end
		MainFrame.Visible = not MainFrame.Visible
		SideFrame.Visible = not SideFrame.Visible
		if MainFrame.Visible == false then
			MFUIScale.Scale = 0.8
			game.TweenService:Create(SFUIScale, TweenInfo.new(.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Scale = 1}):Play()
		else
			game.TweenService:Create(MFUIScale, TweenInfo.new(.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Scale = 1}):Play()
			SFUIScale.Scale = 1.2
		end

		SFHideTimeCount = 0
		SideFrame.GroupTransparency = 0
		SideFrame.UIStroke.Transparency = 0
	end

	local function OpenSettingsFunction()
		SettingsFrame.Visible = not SettingsFrame.Visible
	end

	local SearchButtonClick = true
	local function OpenSearchFunction()
		if MainFrame.Visible == true then
			SearchBox:CaptureFocus()
			if SearchBox.Visible == false then
				SearchButtonClick = false
				SearchButton.Visible = false
				BackButton.Visible = true
				SearchBox.Visible = true
				SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
				game.TweenService:Create(SearchFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 164, 0.119, 0)}):Play()
				wait(.3)
				SearchButtonClick = true
			end
		end
	end
	local SwitchOptionButton = SettingsStuff.SwitchOption
	local function SwitchAnimsFunction()
		AnimSwitchModeEnabled = not AnimSwitchModeEnabled
		if AnimSwitchModeEnabled then
			SwitchOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			SwitchOptionButton.CheckImage.Image = ""
		end
	end
	local AnimFadeOptionButton = SettingsStuff.AnimFadeOption
	local function AnimSmoothFadeFunction()
		AnimSmoothFadeEnabled = not AnimSmoothFadeEnabled
		if AnimSmoothFadeEnabled then
			AnimFadeOptionButton.CheckImage.Image = "rbxassetid://130396712201457"
		else
			AnimFadeOptionButton.CheckImage.Image = ""
		end
	end
	local function StopAnimsFunction()
		StopAnimsEvent:Fire("Forced")
	end
	local function OpenEmoteWheelFunction()
		EmoteWheel.Visible = not EmoteWheel.Visible
	end
	local function SitFunction()
		if Humanoid.Sit == false then
			Humanoid.Sit = true
		else
			Humanoid.Sit = false
		end
	end
	local function ResetFunction()
		Player.Character.Humanoid.Health = 0
	end

	local function BindHotkeys(Reason)
		AddHotkey(DoubleHotkey, "DoubleHotkey", "Key for Double Hotkey")
		if Reason ~= "EnableHotkeys" then
			AddHotkey(EmoteWheelHotkey, "EmoteWheelHotkey", "Open Emote Wheel*", OpenEmoteWheelFunction)
		end
		AddHotkey(SearchHotkey, "SearchHotkey", "Search", OpenSearchFunction)
		AddHotkey(CloseHotkey, "CloseHotkey", "Close/Open Gui", CloseGuiFunction)
		AddHotkey(SitHotkey, "SitHotkey", "Ragdoll-like falling", SitFunction)
		AddHotkey(SettingsHotkey, "SettingsHotkey", "Open Settings", OpenSettingsFunction)
		AddHotkey(SwitchAnimHotkey, "SwitchAnimHotkey", "Switch Anim Setting", SwitchAnimsFunction)
		AddHotkey(AnimFadeHotkey, "AnimFadeHotkey", "Animation Fade Setting", AnimSmoothFadeFunction)
		AddHotkey(StopAnimsHotkey, "StopAnimsHotkey", "Stop all Animations", StopAnimsFunction)
		AddHotkey(ResetCharHotkey, "ResetCharHotkey", "Reset character", ResetFunction)
	end
	BindHotkeys()
	AddHoverText(HotkeysStuff:FindFirstChild("DoubleHotkey").TextLabel, "A secondary key needed for activating a Double Hotkey")
	AddHoverText(HotkeysStuff:FindFirstChild("EmoteWheelHotkey").TextLabel, "WARNING! This Hotkey is NOT affected by EnableHotkeys setting. To disable it you can press Backspace to unbind")

	-- Buttons and other functions
	LoadingState = "Loading Functions"
	local function DestroyGuiFunction()
		GuiActive = false
		BindHotkeys()
		StopAnimsEvent:Fire("Reset/Destroy")
		SettingsFrame.Visible = false
		EmoteWheel.Visible = false
		game.TweenService:Create(MFUIScale, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Scale = 0}):Play()
		game.TweenService:Create(SFUIScale, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Scale = 0}):Play()
		wait(.3)
		Emoter:Destroy()
	end
	DestroyGUI.MouseButton1Click:connect(DestroyGuiFunction)
	SFDestroyGUI.MouseButton1Click:connect(DestroyGuiFunction)

	OpenGUI.MouseButton1Click:connect(function()
		CloseGuiFunction()
	end)
	CloseGUI.MouseButton1Click:connect(function()
		CloseGuiFunction()
	end)
	SettingsButton.MouseButton1Click:Connect(function()
		OpenSettingsFunction()
	end)

	if RigType == "R15" then
		ScrollingFrameR6.Visible = false
		ScrollingFrameR15.Visible = true
		Title.Text = "Emoter GUI (R15)"
		SideFrameTitle.Text = "Emoter GUI (R15)"
	else
		ScrollingFrameR6.Visible = true
		ScrollingFrameR15.Visible = false
		Title.Text = "Emoter GUI (R6)"
		SideFrameTitle.Text = "Emoter GUI (R6)"
	end

	task.spawn(function() --Making SideFrame half-transparent after 7 seconds
		while GuiActive and not GuiRestarted do
			SFHideTimeCount = SFHideTimeCount + 1
			if SFHideTimeCount == 7 and SideFrame.Visible == true then
				SideFrame.GroupTransparency = 0.5
				SideFrame.UIStroke.Transparency = 0.5
			end
			wait(1)
		end
	end)
	SideFrame.MouseMoved:Connect(function()
		SFHideTimeCount = 0
		SideFrame.GroupTransparency = 0
		SideFrame.UIStroke.Transparency = 0
	end)

	SpeedValue:GetPropertyChangedSignal("Text"):Connect(function()
		SpeedNum = SpeedValue.Text 
		if SpeedValue.Text == "" then
			SpeedNum = 0
		end
	end)

	local OptionsButtonClick = true
	OptionsButton.MouseButton1Click:Connect(function()
		if OptionsButtonClick then
			if not OptionsFrame.Visible then
				OptionsButtonClick = false
				OptionsFrame.Visible = true
				game.TweenService:Create(OptionsFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 1, 7)}):Play()
				wait(.3)
				OptionsButtonClick = true
			else
				OptionsButtonClick = false
				game.TweenService:Create(OptionsFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(0.5, 0, 1, -43)}):Play()
				wait(.2)
				OptionsFrame.Visible = false
				OptionsButtonClick = true
			end
		end
	end)

	local function ToolAnimPriorityCheck()
		if ToolAnimHighPriorEnabled then
			local playingTracks = Player.Character:WaitForChild("Humanoid"):GetPlayingAnimationTracks()
			local anyTrue = false
			for _, ScrollFrame in ipairs(ScrollingFramesList) do
				for _, item in ipairs(ScrollFrame:GetChildren()) do
					if item:IsA("TextButton") and item.BackgroundColor3 == ButtonSelectCol then
						anyTrue = true
						break
					end
				end
			end

			if PauseAnimsOption then
				for _, animtrack in ipairs(playingTracks) do
					if animtrack.Name ~= "AAnimation" then
						animtrack:AdjustSpeed(0)
					end
				end
			end

			if anyTrue then
				for _, animtrack in ipairs(playingTracks) do
					local animationObject = animtrack.Animation
					local IdNumberString = string.match(animationObject.AnimationId, "%d+") 

					if (table.find(ToolIdleAnimsList, animtrack.Name) or table.find(ToolIdleAnimsList, IdNumberString)) and animtrack.Name ~= "AAnimation" and ToolIdleAnimHighPriorEnabled then
						animtrack.Priority = Enum.AnimationPriority.Action4
						if HigherPriorityEnabled then
							animtrack:AdjustWeight(30000)
						end
					elseif (table.find(ToolActionAnimsList, animtrack.Name) or table.find(ToolActionAnimsList, IdNumberString)) and animtrack.Name ~= "AAnimation" and ToolActionAnimHighPriorEnabled then
						animtrack.Priority = Enum.AnimationPriority.Action4
						animtrack:AdjustWeight(10000)
						if HigherPriorityEnabled then
							animtrack:AdjustWeight(40000)
						else
							animtrack:AdjustWeight(10000)
						end
					end
				end
			else
				for _, animtrack in ipairs(playingTracks) do
					local animationObject = animtrack.Animation
					local IdNumberString = string.match(animationObject.AnimationId, "%d+") 

					if (table.find(ToolIdleAnimsList, animtrack.Name) or table.find(ToolIdleAnimsList, IdNumberString)) and animtrack.Name ~= "AAnimation" then
						animtrack.Priority = Enum.AnimationPriority.Idle
						animtrack:AdjustWeight(1)
					elseif (table.find(ToolActionAnimsList, animtrack.Name) or table.find(ToolActionAnimsList, IdNumberString)) and animtrack.Name ~= "AAnimation" then
						animtrack.Priority = Enum.AnimationPriority.Action
						animtrack:AdjustWeight(1)
					end
				end
			end
		end
	end
	local function PauseAnimation()
		if PauseAnimsOption then
			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			for _, animtrack in ipairs(playingTracks) do
				if animtrack.Name ~= "AAnimation" then
					animtrack:AdjustSpeed(0)
				end
			end
		end
	end

	Player.Character:WaitForChild("Humanoid").AnimationPlayed:Connect(function()
		if GuiActive and not GuiRestarted then
			ToolAnimPriorityCheck()
			PauseAnimation()
		end
	end)


	--Searchbox
	SearchButton.MouseButton1Click:Connect(function()
		if SearchButtonClick then
			SearchButtonClick = false
			SearchButton.Visible = false
			BackButton.Visible = true
			SearchBox.Visible = true
			SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			game.TweenService:Create(SearchFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 164, 0, 34)}):Play()
			wait(.3)
			SearchButtonClick = true
		end
	end)
	BackButton.MouseButton1Click:Connect(function()
		if SearchButtonClick then
			SearchButtonClick = false
			game.TweenService:Create(SearchFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1, 31, 0, 34)}):Play()
			wait(.2)
			SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			SearchButton.Visible = true
			BackButton.Visible = false
			SearchBox.Visible = false
			SearchButtonClick = true
		end
	end)

	if SearchOpened then
		SearchButton.Visible = false
		BackButton.Visible = true
		SearchBox.Visible = true
		SFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		SearchFrame.Position = UDim2.new(1, 164, 0, 34)
	end

	SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
		for _, ScrollFrame in ipairs(ScrollingFramesList) do
			for _, Button in ipairs(ScrollFrame:GetDescendants()) do
				if Button:IsA("TextButton") and string.find(Button.Text:lower(), SearchBox.Text) then
					Button.Visible = true
				elseif Button:IsA("TextButton") and not string.find(Button.Text, SearchBox.Text) then
					Button.Visible = false
				elseif Button.Name == "DivideFrame" then
					Button.Visible = false
				end
				if SearchBox.Text == "" then
					if Button:IsA("TextButton") then
						Button.Visible = true
					elseif Button.Name == "DivideFrame"  then
						Button.Visible = true
					end

				end
			end
		end
	end)


	--Custom Anim Search
	local CustomAnimButtonClick = true
	CustomAnimButton.MouseButton1Click:Connect(function()
		if CustomAnimButtonClick == true then
			CustomAnimButtonClick = false
			CustomAnimButton.Visible = false
			CustomAnimBackButton.Visible = true
			IdBox.Visible = true
			AddTempAnimButton.Visible = true
			CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
			game.TweenService:Create(CustomAnimFrame, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(1, 194, 0, 73)}):Play()
			wait(.3)
			CustomAnimButtonClick = true
		end
	end)
	CustomAnimBackButton.MouseButton1Click:Connect(function()
		if CustomAnimButtonClick == true then
			CustomAnimButtonClick = false
			game.TweenService:Create(CustomAnimFrame, TweenInfo.new(.2, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(1, 31, 0, 73)}):Play()
			wait(.2)
			CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			CustomAnimButton.Visible = true
			CustomAnimBackButton.Visible = false
			IdBox.Visible = false
			AddTempAnimButton.Visible = false
			CustomAnimButtonClick = true
		end
	end)

	AddTempAnimButton.MouseButton1Click:Connect(function()
		if IdBox.Text == "" or string.match(IdBox.Text, "%a") then
			Notify({Title = "Error", Text = "Anim Id is empty or has letters", Time = 3})
			return end

		local SameResult = false

		for _, Frame in ipairs(ScrollingFramesList) do
			for i, Result in ipairs(Frame:GetDescendants()) do
				if Result:IsA("TextButton") and Result.Name == IdBox.Text then
					SameResult = true
					Notify({Title = "Error", Text = "There's already Anim with this Id", Time = 3})
					break
				end
			end
		end

		if not SameResult then
			local Anim = Instance.new("TextButton")
			if RigType == "R6" then
				CreateAnim(Anim, IdBox.Text, IdBox.Text, "R6", 0, IdBox.Text, .1, 1, "PriorLow", false)
			else
				CreateAnim(Anim, IdBox.Text, IdBox.Text, "R15", 0, IdBox.Text, .1, 1, "PriorLow", false)
			end
			local UiStroke = Instance.new("UIStroke")
			UiStroke.Parent = Anim
			UiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		end

	end)

	if CustomAnimOpened then
		CustomAnimButton.Visible = false
		CustomAnimBackButton.Visible = true
		IdBox.Visible = true
		AddTempAnimButton.Visible = true
		CAFUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		CustomAnimFrame.Position = UDim2.new(1, 194, 0, 73)
	end


	--Choose Section Buttons
	DefaultSection.MouseButton1Click:Connect(function()
		CurrentSection = "Default"
		ScrollingFrameSpecific.Visible = false
		ScrollingFrameBundles.Visible = false
		DefaultSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		SpecGameSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
		BundlesSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
		if RigType == "R6" then
			ScrollingFrameR6.Visible = true
			ScrollingFrameR15.Visible = false
		else
			ScrollingFrameR6.Visible = false
			ScrollingFrameR15.Visible = true
		end
	end)
	SpecGameSection.MouseButton1Click:Connect(function()
		CurrentSection = "Specific"
		SpecGameSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		DefaultSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
		BundlesSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
		ScrollingFrameSpecific.Visible = true
		ScrollingFrameBundles.Visible = false
		ScrollingFrameR6.Visible = false
		ScrollingFrameR15.Visible = false
	end)
	BundlesSection.MouseButton1Click:Connect(function()
		CurrentSection = "Bundles"
		SpecGameSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
		DefaultSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
		BundlesSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		ScrollingFrameSpecific.Visible = false
		ScrollingFrameBundles.Visible = true
		ScrollingFrameR6.Visible = false
		ScrollingFrameR15.Visible = false
	end)


	--Option Buttons
	PauseAnimsButton.MouseButton1Click:Connect(function()
		PauseAnimsOption = not PauseAnimsOption
		if PauseAnimsOption then
			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			for _, animtrack in ipairs(playingTracks) do
				if animtrack.Name ~= "AAnimation" then
					animtrack:AdjustSpeed(0)
				end
			end
			PauseAnimsButton.BackgroundColor3 = ButtonSelectCol
		else
			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			for _, animtrack in ipairs(playingTracks) do
				if animtrack.Name ~= "AAnimation" then
					animtrack:AdjustSpeed(1) -- always playing at speed 1
				end
			end
			PauseAnimsButton.BackgroundColor3 = ButtonCol
		end
	end)

	PauseAnimateButton.MouseButton1Click:Connect(function()
		local AnimateScript = Player.Character:FindFirstChild(AnimationHandler)
		if AnimateScript.Disabled == false then
			AnimateScript.Disabled = true
			PauseAnimateButton.BackgroundColor3 = ButtonSelectCol
		else
			StopAnimsEvent:Fire("Forced")
			AnimateScript.Disabled = false
			PauseAnimateButton.BackgroundColor3 = ButtonCol
			PauseAnimsOption = false
			PauseAnimsButton.BackgroundColor3 = ButtonCol
		end
	end)

	local StopDefAnimsOption = false
	StopDefAnimsButton.MouseButton1Click:Connect(function()
		StopDefAnimsOption = not StopDefAnimsOption
		if StopDefAnimsOption then

			local playingTracks = Player.Character.Humanoid:GetPlayingAnimationTracks()
			Player.Character.Animate.Disabled = true

			for _, animtrack in ipairs(playingTracks) do
				if table.find(DefaultAnimsNameList, animtrack.Name) then
					animtrack:Stop()
				end
			end
			StopDefAnimsButton.BackgroundColor3 = ButtonSelectCol

			PauseAnimateButton.BackgroundColor3 = ButtonCol
			PauseAnimateButton.ImageTransparency = 0.5
			PauseAnimateButton.Interactable = false
		else
			StopAnimsEvent:Fire("Forced")
			Player.Character.Animate.Disabled = false
			StopDefAnimsButton.BackgroundColor3 = ButtonCol

			PauseAnimsOption = false
			PauseAnimsButton.BackgroundColor3 = ButtonCol
			PauseAnimateButton.BackgroundColor3 = ButtonCol
			PauseAnimateButton.ImageTransparency = 0
			PauseAnimateButton.Interactable = true
		end
	end)

	local AnimReversed = false
	ReversePlayButton.MouseButton1Click:Connect(function()
		AnimReversed = not AnimReversed
		if AnimReversed then
			NegativeNumber = -1
			ReversePlayButton.BackgroundColor3 = ButtonSelectCol
		else
			NegativeNumber = 1
			ReversePlayButton.BackgroundColor3 = ButtonCol
		end
	end)
	EmoteWheelButton.MouseButton1Click:Connect(function()
		EmoteWheel.Visible = true
	end)

	SitButton.MouseButton1Click:Connect(function()
		SitFunction()
	end)


	--Settings buttons
	LoadingState = "Loading Settings"
	local CheckmarkIcon = "rbxassetid://130396712201457"

	SGSNotification.MouseButton2Click:Connect(function()
		delfile(ConfigFile)
		Notify({Title = "Deleted", Text = "Deleted specific game settings file", Time = 3})
	end)

	DelayNumBox:GetPropertyChangedSignal("Text"):Connect(function()
		DragDelay = tonumber(DelayNumBox.Text)
		if DelayNumBox.Text == "" then
			DragDelay = 0
		end
	end)
	local PreviewOptionButton = SettingsStuff.PreviewOption
	PreviewOptionButton.MouseButton1Click:Connect(function()
		AnimPreviewEnabled = not AnimPreviewEnabled
		if AnimPreviewEnabled then
			PreviewOptionButton.CheckImage.Image = CheckmarkIcon
		else
			ViewportFrame.Visible = false
			PreviewOptionButton.CheckImage.Image = ""
		end
	end)
	local DebugInfoButton = SettingsStuff.DebugInfoOption
	AddHoverText(DebugInfoButton, "Show debug information in Developer console (Animation data and other things)")
	DebugInfoButton.MouseButton1Click:Connect(function()
		DebugInfoEnabled = not DebugInfoEnabled
		if DebugInfoEnabled then
			DebugInfoButton.CheckImage.Image = CheckmarkIcon
		else
			DebugInfoButton.CheckImage.Image = ""
		end
	end)
	local AnalyticsButton = SettingsStuff.AnalyticsOption
	AddHoverText(AnalyticsButton, "<b>DISCLAIMER</b>: these analytics are made only to see NUMBER of people using my script. I don't save or even share any personal data, UserId, Username and any other data. <b>IF</b> you let AnalyticsEnabled setting enabled you will get rid of one bug where specific settings couldn't load on first script execution")
	AnalyticsButton.MouseButton1Click:Connect(function()
		AnalyticsEnabled = not AnalyticsEnabled
		if AnalyticsEnabled then
			AnalyticsButton.CheckImage.Image = CheckmarkIcon
		else
			AnalyticsButton.CheckImage.Image = ""
		end
	end)
	local LoadAnimationsOnRestartButton = SettingsStuff.LoadAnimationsOnRestartOption
	AddHoverText(LoadAnimationsOnRestartButton, "Automatically plays any Movement animations (like Idle, Running, Jumping, etc.) you played before restarting GUI or your character reappearing")
	LoadAnimationsOnRestartButton.MouseButton1Click:Connect(function()
		LoadAnimationsOnRestart = not LoadAnimationsOnRestart
		if LoadAnimationsOnRestart then
			LoadAnimationsOnRestartButton.CheckImage.Image = CheckmarkIcon
		else
			LoadAnimationsOnRestartButton.CheckImage.Image = ""
		end
	end)
	local LoadAllAnimationsOnRestartButton = SettingsStuff.LoadAllAnimationsOnRestartOption
	AddHoverText(LoadAllAnimationsOnRestartButton, "Automatically plays ALL animations you played before restarting GUI or your character reappearing")
	LoadAllAnimationsOnRestartButton.MouseButton1Click:Connect(function()
		LoadAllAnimationsOnRestart = not LoadAllAnimationsOnRestart
		if LoadAllAnimationsOnRestart then
			LoadAllAnimationsOnRestartButton.CheckImage.Image = CheckmarkIcon
		else
			LoadAllAnimationsOnRestartButton.CheckImage.Image = ""
		end
	end)
	local TopMostButton = SettingsStuff.TopMostOption
	AddHoverText(TopMostButton, "When enabled, GUI will stay on top of <b>ALL</b> other windows and GUIs")
	TopMostButton.MouseButton1Click:Connect(function()
		TopMost = not TopMost
		if TopMost then
			Emoter.DisplayOrder = 100
			TopMostButton.CheckImage.Image = CheckmarkIcon
		else
			Emoter.DisplayOrder = -1
			TopMostButton.CheckImage.Image = ""
		end
	end)
	local LaunchBetaBuildButton = SettingsStuff.LaunchBetaBuildOption
	AddHoverText(LaunchBetaBuildButton, "Launch Beta Version of Emoter GUI instead of stable version. <b>WARNING!</b> It is highly reccomended to backup any settings and other data from your <b>workspace/EmoterData</b> folder located on your device before using beta version!\nP.S.: Beta version won't launch if stable one is higher")
	LaunchBetaBuildButton.MouseButton1Click:Connect(function()
		LaunchBetaBuild = not LaunchBetaBuild
		Notify({Title = "Changed BETA setting", Text = "Please, Destroy Emoter and Launch it again from your executor to change version"})
		if LaunchBetaBuild then
			LaunchBetaBuildButton.CheckImage.Image = CheckmarkIcon
		else
			LaunchBetaBuildButton.CheckImage.Image = ""
		end
	end)
	local SpecCategoryOnLaunchButton = SettingsStuff.SpecCategoryOnLaunchOption
	AddHoverText(SpecCategoryOnLaunchButton, "Every time you launch script, it will open Specific Game Animations category (if available)")
	SpecCategoryOnLaunchButton.MouseButton1Click:Connect(function()
		SpecCategoryOnLaunch = not SpecCategoryOnLaunch
		if SpecCategoryOnLaunch then
			SpecCategoryOnLaunchButton.CheckImage.Image = CheckmarkIcon
		else
			SpecCategoryOnLaunchButton.CheckImage.Image = ""
		end
	end)

	if ToolIdleAnimHighPriorEnabled or ToolActionAnimHighPriorEnabled then
		ToolAnimHighPriorEnabled = true
	else
		ToolAnimHighPriorEnabled = false
	end

	local ToolIdleAnimPriorityButton = SettingsStuff.ToolIdlePriorityOption
	AddHoverText(ToolIdleAnimPriorityButton, "Makes tool <b>Idle</b> animations play even when your animations are playing (like white list). Doesn't work for ALL games and need to be configured. More information in my <b>Github</b>")
	ToolIdleAnimPriorityButton.MouseButton1Click:Connect(function()
		ToolIdleAnimHighPriorEnabled = not ToolIdleAnimHighPriorEnabled
		if ToolIdleAnimHighPriorEnabled or ToolActionAnimHighPriorEnabled then
			ToolAnimHighPriorEnabled = true
		else
			ToolAnimHighPriorEnabled = false
		end

		if ToolIdleAnimHighPriorEnabled then
			ToolIdleAnimPriorityButton.CheckImage.Image = CheckmarkIcon
		else
			ToolIdleAnimPriorityButton.CheckImage.Image = ""
		end
		ToolAnimPriorityCheck()
	end)
	local ToolActionAnimPriorityButton = SettingsStuff.ToolActionPriorityOption
	AddHoverText(ToolActionAnimPriorityButton, "Makes tool <b>Action</b> or other <b>Action</b> animations play even when your animations are playing (like white list). Doesn't work for ALL games and need to be configured. More information in my <b>Github</b>")
	ToolActionAnimPriorityButton.MouseButton1Click:Connect(function()
		ToolActionAnimHighPriorEnabled = not ToolActionAnimHighPriorEnabled
		if ToolActionAnimHighPriorEnabled or ToolIdleAnimHighPriorEnabled then
			ToolAnimHighPriorEnabled = true
		else
			ToolAnimHighPriorEnabled = false
		end

		if ToolActionAnimHighPriorEnabled then
			ToolActionAnimPriorityButton.CheckImage.Image = CheckmarkIcon
		else
			ToolActionAnimPriorityButton.CheckImage.Image = ""
		end
		ToolAnimPriorityCheck()
	end)

	AddHoverText(SwitchOptionButton, "<b>Switching</b> animations instead of <b>layering</b>", SwitchAnimHotkey)
	SwitchOptionButton.MouseButton1Click:Connect(function()
		AnimSwitchModeEnabled = not AnimSwitchModeEnabled
		if AnimSwitchModeEnabled then
			SwitchOptionButton.CheckImage.Image = CheckmarkIcon
		else
			SwitchOptionButton.CheckImage.Image = ""
		end
	end)

	local SwitchRunIdleExceptionOptionButton = SettingsStuff.SwitchRunIdleExceptionOption
	AddHoverText(SwitchRunIdleExceptionOptionButton, "Make an exception of Switch mode for Movement animations")
	SwitchRunIdleExceptionOptionButton.MouseButton1Click:Connect(function()
		AnimSwitchModeRunIdleExceptionEnabled = not AnimSwitchModeRunIdleExceptionEnabled
		if AnimSwitchModeRunIdleExceptionEnabled then
			SwitchRunIdleExceptionOptionButton.CheckImage.Image = CheckmarkIcon
		else
			SwitchRunIdleExceptionOptionButton.CheckImage.Image = ""
		end
	end)

	local BundleSwitchOptionButton = SettingsStuff.BundleSwitchOption
	AddHoverText(BundleSwitchOptionButton, "<b>Switching</b> between Bundle animations of the same type (and name if it's Running type) instead of <b>layering</b>. If you press EquippAll button of other bundle while using another, it will stop ALL animations of other bundle")
	BundleSwitchOptionButton.MouseButton1Click:Connect(function()
		BundleAnimSwitchModeEnabled = not BundleAnimSwitchModeEnabled
		if BundleAnimSwitchModeEnabled then
			BundleSwitchOptionButton.CheckImage.Image = CheckmarkIcon
		else
			BundleSwitchOptionButton.CheckImage.Image = ""
		end
	end)

	AddHoverText(AnimFadeOptionButton, "Enables <b>FadeTime</b> (or better called <b>Transition</b>) of animation. If disabled, animations will play instantly", AnimFadeHotkey)
	AnimFadeOptionButton.MouseButton1Click:Connect(function()
		if HigherPriorityEnabled then return end
		AnimSmoothFadeEnabled = not AnimSmoothFadeEnabled
		if AnimSmoothFadeEnabled then
			AnimFadeOptionButton.CheckImage.Image = CheckmarkIcon
		else
			AnimFadeOptionButton.CheckImage.Image = ""
		end
	end)
	if HigherPriorityEnabled then
		AnimFadeOptionButton.TextLabel.TextTransparency = 0.5
		if Theme ~= "Black" then AnimFadeOptionButton.CheckImage.BorderColor3 = Color3.fromRGB(140, 140, 140) end
		AnimFadeOptionButton.CheckImage.Image = ""
	end

	local HigherPriorityOptionButton = SettingsStuff.HigherPriorityOption
	AddHoverText(HigherPriorityOptionButton, "Makes animations priority <b>higher</b>. This is made for games, where developers are making some or all of their animations with <b>Action4</b> priority (the highest one). Highly <b>not recommended</b> to use if not needed, as it uses high AnimWeight to overwrite animations, Which makes animations play not very good and breaks it's transition, especially if you play more than 1 animation. <b>When enabled</b>, FadeTime setting is disabled by default")
	HigherPriorityOptionButton.MouseButton1Click:Connect(function()
		HigherPriorityEnabled = not HigherPriorityEnabled
		if HigherPriorityEnabled then
			HigherPriorityOptionButton.CheckImage.Image = CheckmarkIcon
			AnimFadeOptionButton.TextLabel.TextTransparency = 0.5
			if Theme ~= "Black" then AnimFadeOptionButton.CheckImage.BorderColor3 = Color3.fromRGB(140, 140, 140) end
			AnimFadeOptionButton.CheckImage.Image = ""
		else
			HigherPriorityOptionButton.CheckImage.Image = ""
			AnimFadeOptionButton.TextLabel.TextTransparency = 0
			AnimFadeOptionButton.CheckImage.BorderColor3 = Color3.fromRGB(0, 0, 0)
			if AnimSmoothFadeEnabled then
				AnimFadeOptionButton.CheckImage.Image = CheckmarkIcon
			end
		end
	end)

	local IdleTypeOptionButton = SettingsStuff.IdleTypeOption
	AddHoverText(IdleTypeOptionButton, "Enables 'Idle' function of most of <b>idle-like</b> animations. With this function animation is playing only when your character isn't moving")
	IdleTypeOptionButton.MouseButton1Click:Connect(function()
		IdleTypeEnabled = not IdleTypeEnabled
		if IdleTypeEnabled then
			IdleTypeOptionButton.CheckImage.Image = CheckmarkIcon
		else
			IdleTypeOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeOptionButton = SettingsStuff.RunningTypeOption
	AddHoverText(RunningTypeOptionButton, "Enables 'Running' function of most of <b>running-like</b> animations. With this function animation speed is changing depending on the character's speed, and the animations themselves stop when your character stops")
	RunningTypeOptionButton.MouseButton1Click:Connect(function()
		RunningTypeEnabled = not RunningTypeEnabled
		if RunningTypeEnabled then
			RunningTypeOptionButton.CheckImage.Image = CheckmarkIcon
		else
			RunningTypeOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeStopStandingOptionButton = SettingsStuff.RunningTypeStopStandingOption
	AddHoverText(RunningTypeStopStandingOptionButton, "Stop 'Running' animation when your character is <b>not moving (standing)</b> and play it again when your character is running")
	RunningTypeStopStandingOptionButton.MouseButton1Click:Connect(function()
		RunningTypeStopStandingEnabled = not RunningTypeStopStandingEnabled
		if RunningTypeStopStandingEnabled then
			RunningTypeStopStandingOptionButton.CheckImage.Image = CheckmarkIcon
		else
			RunningTypeStopStandingOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeStopJumpingOptionButton = SettingsStuff.RunningTypeStopJumpingOption
	AddHoverText(RunningTypeStopJumpingOptionButton, "Stop 'Running' animation when your character is <b>jumping</b>")
	RunningTypeStopJumpingOptionButton.MouseButton1Click:Connect(function()
		RunningTypeStopJumpingEnabled = not RunningTypeStopJumpingEnabled
		if RunningTypeStopJumpingEnabled then
			RunningTypeStopJumpingOptionButton.CheckImage.Image = CheckmarkIcon
		else
			RunningTypeStopJumpingOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeStopClimbingOptionButton = SettingsStuff.RunningTypeStopClimbingOption
	AddHoverText(RunningTypeStopClimbingOptionButton, "Stop 'Running' animation when your character is <b>climbing</b>")
	RunningTypeStopClimbingOptionButton.MouseButton1Click:Connect(function()
		RunningTypeStopClimbingEnabled = not RunningTypeStopClimbingEnabled
		if RunningTypeStopClimbingEnabled then
			RunningTypeStopClimbingOptionButton.CheckImage.Image = CheckmarkIcon
		else
			RunningTypeStopClimbingOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeCharSpeedOptionButton = SettingsStuff.RunningTypeCharSpeedOption
	AddHoverText(RunningTypeCharSpeedOptionButton, "Change 'Running' animation speed depending on your character's speed")
	RunningTypeCharSpeedOptionButton.MouseButton1Click:Connect(function()
		RunningTypeCharSpeedEnabled = not RunningTypeCharSpeedEnabled
		if RunningTypeCharSpeedEnabled then
			RunningTypeCharSpeedOptionButton.CheckImage.Image = CheckmarkIcon
		else
			RunningTypeCharSpeedOptionButton.CheckImage.Image = ""
		end
	end)

	local RunningTypeMinSpeedOption = SettingsStuff.RunningTypeMinSpeedOption
	AddHoverText(RunningTypeMinSpeedOption, "Some animations uses Value for 'Running' type, like some <b>sprinting</b> animations. This Value is minimum WalkSpeed of your character needed for animation to play it. If your character's WalkSpeed is less than this minimum, animation won't play")
	RunningTypeMinSpeedOption.MouseButton1Click:Connect(function()
		RunningTypeMinSpeedEnabled = not RunningTypeMinSpeedEnabled
		if RunningTypeMinSpeedEnabled then
			RunningTypeMinSpeedOption.CheckImage.Image = CheckmarkIcon
		else
			RunningTypeMinSpeedOption.CheckImage.Image = ""
		end
	end)

	HotkeysEditOption.MouseButton1Click:Connect(function()
		HotkeysFrame.Visible = not HotkeysFrame.Visible
	end)

	PurpleThemeColor.MouseButton1Click:Connect(function()
		Theme = "LightPurple"
		Notify({Title = "Changed theme", Text = "Changed theme to <b>Light Purple</b>, please restart GUI to apply", Time = 3})
	end)
	OrangeThemeColor.MouseButton1Click:Connect(function()
		Theme = "LightOrange"
		Notify({Title = "Changed theme", Text = "Changed theme to <b>Light Orange</b>, please restart GUI to apply", Time = 3})
	end)
	YellowThemeColor.MouseButton1Click:Connect(function()
		Theme = "LightYellow"
		Notify({Title = "Changed theme", Text = "Changed theme to <b>Light Yellow</b>, please restart GUI to apply", Time = 3})
	end)
	BlackThemeColor.MouseButton1Click:Connect(function()
		Theme = "Black"
		Notify({Title = "Changed theme", Text = "Changed theme to <b>Black</b>, please restart GUI to apply", Time = 3})
	end)

	local UICornerOptionButton = SettingsStuff.UICornerOption
	AddHoverText(UICornerOptionButton, "Enables rounded corners in GUI")
	UICornerOptionButton.MouseButton1Click:Connect(function()
		UICornerEnabled = not UICornerEnabled
		if UICornerEnabled then
			UICornerOptionButton.CheckImage.Image = CheckmarkIcon
		else
			UICornerOptionButton.CheckImage.Image = ""
		end
	end)

	local UIGradientOptionButton = SettingsStuff.UIGradientOption
	AddHoverText(UIGradientOptionButton, "Enables gradient in GUI")
	UIGradientOptionButton.MouseButton1Click:Connect(function()
		UIGradientEnabled = not UIGradientEnabled
		if UIGradientEnabledtrue then
			UIGradientOptionButton.CheckImage.Image = CheckmarkIcon
		else
			UIGradientOptionButton.CheckImage.Image = ""
		end
	end)

	X05YSixe.MouseButton1Click:Connect(function()
		YSize = 209
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	end)
	X1YSize.MouseButton1Click:Connect(function()
		YSize = 285
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	end)
	X15YSize.MouseButton1Click:Connect(function()
		YSize = 450
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	end)
	X2YSize.MouseButton1Click:Connect(function()
		YSize = 660
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)
	end)

	X2Size.MouseButton1Click:Connect(function()
		XSize = 240
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)

		ValueText.Visible = false
		if RigType == "R15" then
			Title.Text = "Emoter R15"
		else
			Title.Text = "Emoter R6"
		end
	end)
	X3Size.MouseButton1Click:Connect(function()
		XSize = 350
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)

		ValueText.Visible = false
		if RigType == "R15" then
			Title.Text = "Emoter GUI (R15)"
		else
			Title.Text = "Emoter GUI (R6)"
		end
	end)
	X4Size.MouseButton1Click:Connect(function()
		XSize = 460
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)

		ValueText.Visible = true
		if RigType == "R15" then
			Title.Text = "Emoter GUI (R15)"
		else
			Title.Text = "Emoter GUI (R6)"
		end
	end)
	X5Size.MouseButton1Click:Connect(function()
		XSize = 571
		MainFrame.Size = UDim2.new(0, XSize, 0, YSize)
		ScrollingFrameR6.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameR15.Size = UDim2.new(1, 0, 1, -69)
		ScrollingFrameSpecific.Size = UDim2.new(1, 0, 1, -69)

		ValueText.Visible = true
		if RigType == "R15" then
			Title.Text = "Emoter GUI (R15)"
		else
			Title.Text = "Emoter GUI (R6)"
		end
	end)

	local HotkeysOptionButton = SettingsStuff.HotkeysOption
	AddHoverText(HotkeysEditOption, "Enables hotkeys. you can use this setting to reload hotkeys if they aren't working")
	HotkeysOptionButton.MouseButton1Click:Connect(function()
		HotkeysEnabled = not HotkeysEnabled
		if HotkeysEnabled then
			BindHotkeys()
			HotkeysOptionButton.CheckImage.Image = CheckmarkIcon
		else
			BindHotkeys("EnableHotkeys")
			HotkeysOptionButton.CheckImage.Image = ""
		end
	end)

	local LoadGithubSGAOptionButton = SettingsStuff.LoadGithubSGAOption
	AddHoverText(LoadGithubSGAOptionButton, "Enables loading SGA (SpecificGameAnims) from Github")
	LoadGithubSGAOptionButton.MouseButton1Click:Connect(function()
		LoadGithubSGAEnabled = not LoadGithubSGAEnabled
		if LoadGithubSGAEnabled then
			LoadGithubSGAOptionButton.CheckImage.Image = CheckmarkIcon
		else
			LoadGithubSGAOptionButton.CheckImage.Image = ""
		end
	end)

	local LoadGithubCustomAnimOptionButton = SettingsStuff.LoadGithubCustomAnimOption
	AddHoverText(LoadGithubCustomAnimOptionButton, "Enables loading additional animations from Github")
	LoadGithubCustomAnimOptionButton.MouseButton1Click:Connect(function()
		LoadGithubCustomAnimsEnabled = not LoadGithubCustomAnimsEnabled
		if LoadGithubCustomAnimsEnabled then
			LoadGithubCustomAnimOptionButton.CheckImage.Image = CheckmarkIcon
		else
			LoadGithubCustomAnimOptionButton.CheckImage.Image = ""
		end
	end)

	local LoadLocalSGAOptionButton = SettingsStuff.LoadLocalSGAOption
	AddHoverText(LoadLocalSGAOptionButton, "Enables loading SGA (SpecificGameAnims) from your local files. More information in my <b>Github</b>")
	LoadLocalSGAOptionButton.MouseButton1Click:Connect(function()
		LoadLocalSGAEnabled = not LoadLocalSGAEnabled
		if LoadLocalSGAEnabled then
			LoadLocalSGAOptionButton.CheckImage.Image = CheckmarkIcon
		else
			LoadLocalSGAOptionButton.CheckImage.Image = ""
		end
	end)

	local LoadLocalCustomAnimOptionButton = SettingsStuff.LoadLocalCustomAnimOption
	AddHoverText(LoadLocalCustomAnimOptionButton, "Enables loading additional animations from your local files. More information in my <b>Github</b>")
	LoadLocalCustomAnimOptionButton.MouseButton1Click:Connect(function()
		LoadLocalCustomAnimsEnabled = not LoadLocalCustomAnimsEnabled
		if LoadLocalCustomAnimsEnabled then
			LoadLocalCustomAnimOptionButton.CheckImage.Image = CheckmarkIcon
		else
			LoadLocalCustomAnimOptionButton.CheckImage.Image = ""
		end
	end)

	local WarningDelay = false
	SaveSettingsButton.MouseButton1Click:Connect(function()
		if ConfigFile == "EmoterData/EmoterConfig.json" then
			SaveData("Default")
		else
			if not WarningDelay then
				task.spawn(function()
					WarningDelay = true
					WarningText.Visible = true
					task.wait(7)
					game.TweenService:Create(WarningText, TweenInfo.new(.5, Enum.EasingStyle.Linear), {TextTransparency = 1}):Play()
					game.TweenService:Create(WarningText.UIStroke, TweenInfo.new(.5, Enum.EasingStyle.Linear), {Transparency = 1}):Play()
					wait(.5)
					WarningText.Visible = false
					WarningText.TextTransparency = 0
					WarningText.UIStroke.Transparency = 0
					WarningDelay = false
				end)
			else
				SaveData("Default")
			end
		end
		--SaveData("Default")
	end)
	SaveSettingsButton.MouseButton2Click:Connect(function()
		SaveData("Specific")
	end)

	LaunchIdDetectorButton.MouseButton1Click:Connect(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/AnimationIdDetector.lua",true))()
	end)

	ResetButton.MouseButton1Click:Connect(function()
		Notify({Title = "Restarting", Text = "Restarting Gui...", Time = 3})
		table.clear(RestartAnimations)
		StopAnimsEvent:Fire("Reset/Destroy")
		SettingsFrame.Visible = false
		GuiRestarted = true
		BindHotkeys()
		OnRestart()
	end)

	GithubLinkButton.MouseButton1Click:Connect(function()
		setclipboard("https://github.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/tree/main")
		Notify({Title = "Copied", Text = "Copied link to your clipboard!", Time = 3})
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if not GuiActive or GuiRestarted then return end

		--EmoteWheelClosing
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if EmoteWheel.Visible then
				local mousePos = UserInputService:GetMouseLocation()
				local guiObjects = Player.PlayerGui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y - 60)
				if not IsInStudio then
					guiObjects = game.CoreGui:GetGuiObjectsAtPosition(mousePos.X, mousePos.Y - 60)
				end

				local clickedInside = false
				for _, obj in ipairs(guiObjects) do
					if obj:IsDescendantOf(EmoteWheel) or obj == EmoteWheel then
						clickedInside = true
						break
					end
				end

				if not clickedInside then
					wait()
					EmoteWheel.Visible = false
				end
			end
		end
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if not GuiActive or GuiRestarted then return end

		if input.KeyCode == Enum.KeyCode.LeftAlt then
			PriorityAltPressed = true
		end
		if input.KeyCode == Enum.KeyCode.RightAlt then
			RunAltPressed = true
		end
		if input.KeyCode == Enum.KeyCode.RightControl then
			IdleAltPressed = true
		end
	end) 
	UserInputService.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.LeftAlt then
			PriorityAltPressed = false
		end
		if input.KeyCode == Enum.KeyCode.RightAlt then
			RunAltPressed = false
		end
		if input.KeyCode == Enum.KeyCode.RightControl then
			IdleAltPressed = false
		end
	end)

	-- EMOTES

	--[[Functions Template
	local Button = Instance.new("TextButton")
	CreateAnim(Button, "ButtonName", "ButtonText", "SFrameType (R6, R15 or Spec)", LayoutOrder, "AnimId", FadeTime, AnimSpeed, "PriorityPauseRunningIdle", Looped(true/false))
	]]
	LoadingState = "Adding Emotes from script"
	print(LoadingState)
	--DivideFrames
	CreateDivideFrame("Dances", 1, "R6")
	CreateDivideFrame("Actions", 2, "R6")
	CreateDivideFrame("Idles & Walks", 3, "R6")
	CreateDivideFrame("Weird", 4, "R6")
	CreateDivideFrame("Attack", 5, "R6")

	CreateDivideFrame("Dances", 1, "R15")
	CreateDivideFrame("Actions", 2, "R15")
	CreateDivideFrame("Walk & Run", 3, "R15")
	CreateDivideFrame("Poses & Idles", 4, "R15")
	CreateDivideFrame("Weird", 5, "R15")
	CreateDivideFrame("Attack", 6, "R15")


	-- R6 Emotes
	local function R6Anims()
		CreateAnim(Instance.new("TextButton"), "Dance1", "Dance 1", "R6", 1, "182491037", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Dance2", "Dance 2", "R6", 1, "182436842", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Dance3", "Dance 3", "R6", 1, "182491368", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "MoonDance", "Moon Dance", "R6", 1, "45834924", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "SpinDance", "Spin Dance", "R6", 1, "429730430", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "JumpingJacks", "Jumping Jacks", "R6", 1, "429681631", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Bang", "Bang", "R6", 1, "148840371", .1, 3, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "MovingDance", "Moving Dance", "R6", 1, "429703734", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "GoofyDance", "Goofy Dance", "R6", 1, "27789359", .1, 0.8, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "WeirdDance", "Weird Dance", "R6", 1, "28488254", .1, 0.8, "PriorLow", true)

		CreateAnim(Instance.new("TextButton"), "Laugh", "Laugh", "R6", 2, "129423131", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Cheer", "Cheer", "R6", 2, "129423030", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Point", "Point", "R6", 2, "128853357", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Wave", "Wave", "R6", 2, "128777973", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Dab", "Dab", "R6", 2, "248263260", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "ToolHandle", "Tool Handle", "R6", 2, "125750867", .1, 1, "PriorHigh", true)

		CreateAnim(Instance.new("TextButton"), "Crouch", "Crouch", "R6", 3, "182724289", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Faint", "Faint", "R6", 3, "181526230", .1, 1, "PriorHigh", true)
		CreateAnim(Instance.new("TextButton"), "FloorCrawl", "Floor Crawl", "R6", 3, "282574440", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Levitate", "Levitate", "R6", 3, "313762630", .1, 1, "PriorHigh", true)
		CreateAnim(Instance.new("TextButton"), "DinoWalk", "Dino Walk", "R6", 3, "204328711", .1, 1.5, "PriorLowRunning", true)
		CreateAnim(Instance.new("TextButton"), "Climb", "Climb Walk", "R6", 3, "125750800", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Scared", "Scared", "R6", 3, "180612465", .1, 0.3, "PriorLowPause", true)
		CreateAnim(Instance.new("TextButton"), "FloatingHead", "Floating Head", "R6", 3, "121572214", .1, 1, "PriorHigh", true)
		CreateAnim(Instance.new("TextButton"), "FloatSit", "Float Sit", "R6", 3, "179224234", .5, 1, "PriorLow", true)

		CreateAnim(Instance.new("TextButton"), "Spinner", "Spinner", "R6", 4, "188632011", .1, 2, "PriorHigh", true)
		CreateAnim(Instance.new("TextButton"), "StrangePos", "Strange Position", "R6", 4, "248336459", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "HeadThrow", "Head Throw", "R6", 4, "35154961", .1, 1, "PriorHigh", false)
		CreateAnim(Instance.new("TextButton"), "ArmTurbine", "Arm Turbine", "R6", 4, "259438880", .1, 3, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "BarrelRoll", "Barrel Roll", "R6", 4, "136801964", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "MegaInsane", "Mega Insane", "R6", 4, "184574340", .1, 40, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "WeirdMove", "Weird Move", "R6", 4, "215384594", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "CloneIllusion", "Clone Illusion", "R6", 4, "215384594", .1, 1e10, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Insane", "Insane", "R6", 4, "33796059", .1, 1e8, "PriorLow", true)

		CreateAnim(Instance.new("TextButton"), "FullSwing", "Full Swing", "R6", 5, "218504594", .1, 1, "PriorHigh", false)
		CreateAnim(Instance.new("TextButton"), "NunchakSlash", "Nunchak Slash", "R6", 5, "204292303", .1, 1.5, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "FullPunch", "Full Punch", "R6", 5, "204062532", .1, 1.5, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "SwordSpin", "Sword Spin", "R6", 5, "186934910", .1, 0.8, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Punches", "Punches", "R6", 5, "126753849", .1, 2, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "HeroJump", "Hero Jump", "R6", 5, "184574340", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "DoubleSlash", "Double Slash", "R6", 5, "35978879", .1, 2, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "SwordSwing", "Sword Swing", "R6", 5, "32659699", .1, 1, "PriorLow", false)

		CreateBundle("Classic", "Classic", "R6")
		CreateBundleAnim("Classic", "Run", "Run", "180426354", .1, 1, "PriorLowRunning", true)
		CreateBundleAnim("Classic", "Idle", "Idle", {"180435571", "180435792"}, .1, 1, "PriorLowIdle", true)
		CreateBundleAnim("Classic", "Jump", "Jump", "125750702", .1, 1, "PriorLow", false)
		CreateBundleAnim("Classic", "Fall", "Fall", "180436148", .1, 1, "PriorLow", true)
		CreateBundleAnim("Classic", "Swim", "Swim", "180426354", .1, 1, "PriorLow", true)
		CreateBundleAnim("Classic", "SwimIdle", "SwimIdle", "180426354", .1, 1, "PriorLow", true)
		CreateBundleAnim("Classic", "Climb", "Climb", "180436334", .1, 1, "PriorLow", true)
	end

	--R15 Emotes
	local function R15Anims()
		CreateAnim(Instance.new("TextButton"), "Dance1", "Dance 1", "R15", 1, "507771955", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Dance2", "Dance 2", "R15", 1, "507776720", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Dance3", "Dance 3", "R15", 1, "507777451", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "FlossDance", "Floss Dance", "R15", 1, "10714340543", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Monkey", "Monkey", "R15", 1, "10714388352", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "IWantMoneyDance", "I Want Money", "R15", 1, "115781688996859", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "FortniteDance", "Fortnite Dance", "R15", 1, "88455578674030", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "GangnamStyle", "Gangnam Style", "R15", 1, "129764254213842", .1, 0.9, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "RussianKick", "Russian Kick", "R15", 1, "70653974473742", .1, 1, "PriorLow", true, "70653974473742", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "MannrobicsDance", "Mannrobics Dance", "R15", 1, "73932117454031", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "PennywiseDance", "Pennywise Dance", "R15", 1, "138755180984581", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "BreakDance", "Break Dance", "R15", 1, "10214311282", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Rambunctious", "Rambunctious", "R15", 1, "129991743366120", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "NightmailDance", "Nightmail Dance", "R15", 1, "103655955630769", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "TennaArmDance", "Tenna Arm Dance", "R15", 1, "140315159513795", .1, 1.1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "TennaSwingDance", "Tenna Swing Dance", "R15", 1, "77984841414450", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "TakeTheL", "Take The L", "R15", 1, "78870781032132", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "JumpJacks", "Jump Jacks", "R15", 1, "10714375667", .1, 1, "PriorLow", true)

		CreateAnim(Instance.new("TextButton"), "Wave", "Wave", "R15", 2, "10714359093", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "HighWave", "HighWave", "R15", 2, "10714362852", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "AwkwardWave", "Awkward Wave", "R15", 2, "86074172929360", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Point", "Point", "R15", 2, "10714395441", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Beckon", "Beckon", "R15", 2, "10713984554", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Happy", "Happy", "R15", 2, "10714352626", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Cheer", "Cheer", "R15", 2, "507770677", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Celebrate", "Celebrate", "R15", 2, "10714016223", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Salute", "Salute", "R15", 2, "10714389988", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Shrug", "Shrug", "R15", 2, "10714374484", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Thinking", "Thinking", "R15", 2, "123167401858016", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Confused", "Confused", "R15", 2, "4940561610", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Agree", "Agree", "R15", 2, "10713954623", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Disagree", "Disagree", "R15", 2, "10714065135", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "DolphinBang", "Dolphin Bang", "R15", 2, "10714068222", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Twirl", "Twirl", "R15", 2, "10714293450", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "HeroLanding", "Hero Landing", "R15", 2, "10714360164", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Shy", "Shy", "R15", 2, "10714369325", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Coward", "Coward", "R15", 2, "4940563117", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Dizzy", "Dizzy", "R15", 2, "10714066964", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "PushUp", "Push Ups", "R15", 2, "80326183054599", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Bodybuilder", "Bodybuilder", "R15", 2, "10713990381", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Laugh", "Laugh", "R15", 2, "507770818", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "BigLaugh", "Big Laugh", "R15", 2, "98974619620224", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Bored", "Bored", "R15", 2, "10713992055", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Applaud", "Applaud", "R15", 2, "10713966026", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "FakeDeath", "FakeDeath", "R15", 2, "88130117312312", .1, 1, "PriorLowPause", true)

		CreateAnim(Instance.new("TextButton"), "Tank", "Tank", "R15", 3, "115951523870527", .5, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "RaceCar", "Race Car", "R15", 3, "72382226286301", .5, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Helicopter", "Helicopter", "R15", 3, "76510079095692", .5, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "CarDriving", "Car Driving", "R15", 3, "132471972345518", .5, 0.5, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Crawl", "Crawl", "R15", 3, "106501741606953", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "BigBadWolf", "Big Bad Wolf", "R15", 3, "84490859002106", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "MedusaWalk", "Medusa Walk", "R15", 3, "131663132818596", .19, 1.5, "PriorLowRunning", true)
		CreateAnim(Instance.new("TextButton"), "ShadowRun", "Shadow Running", "R15", 3, "82598234841035", .19, 0.8, "PriorLowRunning", true)
		CreateAnim(Instance.new("TextButton"), "AdidasRun", "Adidas Running", "R15", 3, "18537384940", .19, 1, "PriorLowRunning", true)

		CreateAnim(Instance.new("TextButton"), "VibeIdle", "Vibe Idle", "R15", 4, "99638411514722", .19, 1, "PriorLowIdle", true)
		CreateAnim(Instance.new("TextButton"), "FloatingHeadSitting", "Floating Head Sit", "R15", 4, "111681053387222", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "FloatChillSit", "Float Chill Sit", "R15", 4, "110211186840347", .1, 0.5, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "TPose", "T Pose", "R15", 4, "121655148084031", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "CrouchR15", "Crouch", "R15", 4, "97517127273301", .3, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Sitting", "Sitting", "R15", 4, "94763556845023", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "MM2Sit", "MM2 Sit", "R15", 4, "130577643309726", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Box", "Box", "R15", 4, "73753845465382", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Sleeping", "Sleeping", "R15", 4, "121641415206650", .5, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "HeadJuggle", "Head Juggle", "R15", 4, "136767849845319", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "FloatingOnClouds", "Floating On Clouds", "R15", 4, "77840765435893", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "SitAnim", "Sit Anim", "R15", 4, "507768133", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "ToolHandle", "Tool Handle", "R15", 4, "507768375", .1, 1, "PriorHigh", true)
		CreateAnim(Instance.new("TextButton"), "FightingIdle", "Fighting Idle", "R15", 4, "105947156749343", .19, 1, "PriorLowIdle", true)

		CreateAnim(Instance.new("TextButton"), "JumpingSpider", "Jumping Spider", "R15", 5, "139310328821985", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "InsaneDog", "Insane Dog", "R15", 5, "96435804447949", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "WormAnim", "Worm Fly", "R15", 5, "135990691658209", .3, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Orbit", "Orbit", "R15", 5, "108359356964182", .5, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Hanging", "Hanging", "R15", 5, "125662782523118", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "LaggyWalkTroll", "Laggy Walk Troll", "R15", 5, "119199812452698", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "InchWorm", "Inch Worm", "R15", 5, "119096405600200", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "GoofyWiggle", "Goofy Wiggle", "R15", 5, "74917195706355", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Tornado", "Tornado", "R15", 5, "135373056067761", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "AdminFly", "Admin Fly", "R15", 5, "85063861261432", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "ObbyHead", "Little Obbyist", "R15", 5, "115569573258316", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "Insane", "Insane", "R15", 5, "93087898023268", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "GoofyFLY", "Goofy FLY", "R15", 5, "118417760427139", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "BodyPhone", "Body Phone", "R15", 5, "73390669780316", .1, 0.8, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Spin", "Spin", "R15", 5, "110792133024438", .1, 1, "PriorHigh", true)
		CreateAnim(Instance.new("TextButton"), "HyperSpin", "Hyper Spin", "R15", 5, "125165371323590", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "SpinAround", "SpinAround", "R15", 5, "91004858616595", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "FloatingSpace", "Floating Space", "R15", 5, "71209604118044", .1, 1, "PriorLow", true)
		CreateAnim(Instance.new("TextButton"), "FloatingSpace2", "Floating Space 2", "R15", 5, "70394064781064", .1, 0.5, "PriorLow", true)

		CreateAnim(Instance.new("TextButton"), "DaHoodStomp", "DaHood Stomp", "R15", 6, "92249489340640", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "QuadPunch", "Quad Punch", "R15", 6, "139643944264511", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "TennaKick", "TennaKick", "R15", 6, "118139885865308", .1, 1, "PriorLow", false)
		CreateAnim(Instance.new("TextButton"), "Dropkick", "Dropkick", "R15", 6, "133566007754001", .1, 1, "PriorLow", false)
		
		CreateBundle("Default", "Default", "R15")
		CreateBundleAnim("Default", "Run", "Run", "913376220", .19, 1, "PriorLowRunning8", true)
		CreateBundleAnim("Default", "Walk", "Walk", "913402848", .19, 1, "PriorLowRunningUntil8", true)
		CreateBundleAnim("Default", "Idle", "Idle", {"507766388", "507766666"}, .19, 1, "PriorLowIdle", true)
		CreateBundleAnim("Default", "Jump", "Jump", "507765000", .19, 1, "PriorLow", false)
		CreateBundleAnim("Default", "Fall", "Fall", "507767968", .19, 1, "PriorLow", true)
		CreateBundleAnim("Default", "Swim", "Swim", "913384386", .19, 1, "PriorLow", true)
		CreateBundleAnim("Default", "SwimIdle", "SwimIdle", "913389285", .19, 1, "PriorLow", true)
		CreateBundleAnim("Default", "Climb", "Climb", "507765644", .19, 1, "PriorLow", true)
		CreateBundle("Mini", "Mini", "R15")
		CreateBundleAnim("Mini", "Run", "Run", "85887415033585", .19, 1.3, "PriorLowRunning", true)
		CreateBundleAnim("Mini", "Idle", "Idle", "82127055873357", .19, 1, "PriorLowIdle", true)
		CreateBundleAnim("Mini", "Jump", "Jump", "111496551036697", .19, 1, "PriorLow", false)
		CreateBundleAnim("Mini", "Fall", "Fall", "91811573105058", .19, 1, "PriorLow", true)
		CreateBundleAnim("Mini", "Swim", "Swim", "90464317950429", .19, 1, "PriorLow", true)
		CreateBundleAnim("Mini", "SwimIdle", "SwimIdle", "115629502594733", .19, 1, "PriorLow", true)
		CreateBundleAnim("Mini", "Climb", "Climb", "124321607827473", .19, 1, "PriorLow", true)
		CreateBundle("Tall", "Tall", "R15")
		CreateBundleAnim("Tall", "Run", "Run", "95499288912180", .19, 0.9, "PriorLowRunning17", true)
		CreateBundleAnim("Tall", "Walk", "Walk", "134010853417610", .19, 1.6, "PriorLowRunningUntil17", true)
		CreateBundleAnim("Tall", "Idle", "Idle", {"130473379657056", "115304761687015"}, .19, 1, "PriorLowIdle", true)
		CreateBundleAnim("Tall", "Jump", "Jump", "74772997744432", .19, 1, "PriorLow", false)
		CreateBundleAnim("Tall", "Fall", "Fall", "117145620246256", .19, 1, "PriorLow", true)
		CreateBundleAnim("Tall", "Swim", "Swim", "126086109642848", .19, 1, "PriorLow", true)
		CreateBundleAnim("Tall", "SwimIdle", "SwimIdle", "109553829779181", .19, 1, "PriorLow", true)
		CreateBundleAnim("Tall", "Climb", "Climb", "112214163024573", .19, 1, "PriorLow", true)
		CreateBundle("Happy", "Happy Tail Wag", "R15")
		CreateBundleAnim("Happy", "Run", "Run", "136336776520965", .19, 1, "PriorLowRunning8", true)
		CreateBundleAnim("Happy", "Walk", "Walk", "124771611518572", .19, 1, "PriorLowRunningUntil8", true)
		CreateBundleAnim("Happy", "Idle", "Idle", "88212525150688", .1, 1, "PriorLowIdle", true)
		CreateBundleAnim("Happy", "Jump", "Jump", "80837560162394", .19, 1, "PriorLow", false)
		CreateBundleAnim("Happy", "Fall", "Fall", "104594903909683", .19, 1, "PriorLow", true)
		CreateBundleAnim("Happy", "Swim", "Swim", "98596828035441", .19, 1, "PriorLow", true)
		CreateBundleAnim("Happy", "SwimIdle", "SwimIdle", "122148537348434", .19, 1, "PriorLow", true)
		CreateBundleAnim("Happy", "Climb", "Climb", "112630540408116", .19, 1, "PriorLow", true)
		CreateBundle("Floating", "Floating", "R15")
		CreateBundleAnim("Floating", "Run", "Run", "98995968630900", .19, 1, "PriorLowRunning8", true)
		CreateBundleAnim("Floating", "Walk", "Walk", "108135901135188", .19, 1, "PriorLowRunningUntil8", true)
		CreateBundleAnim("Floating", "Idle", "Idle", {"90055248227279", "82272775657361"}, .19, 1, "PriorLowIdle", true)
		CreateBundleAnim("Floating", "Jump", "Jump", "125213572908017", .19, 1, "PriorLow", false)
		CreateBundleAnim("Floating", "Fall", "Fall", "134497092294613", .19, 1, "PriorLow", true)
		CreateBundleAnim("Floating", "Swim", "Swim", "125540451466157", .19, 1, "PriorLow", true)
		CreateBundleAnim("Floating", "SwimIdle", "SwimIdle", "138061557595923", .19, 1, "PriorLow", true)
		CreateBundleAnim("Floating", "Climb", "Climb", "85018922133648", .19, 1, "PriorLow", true)
		CreateBundle("Swimming", "Swimming", "R15")
		CreateBundleAnim("Swimming", "Run", "Run", "88052970430286", .19, 1, "PriorLowRunning", true)
		CreateBundleAnim("Swimming", "Idle", "Idle", "129986136445851", .19, 1, "PriorLowIdle", true)
		CreateBundleAnim("Swimming", "Jump", "Jump", "128882758336556", .19, 1, "PriorLow", false)
		CreateBundleAnim("Swimming", "Fall", "Fall", "110656234493892", .19, 1, "PriorLow", true)
		CreateBundleAnim("Swimming", "Swim", "Swim", "134496748747625", .19, 1, "PriorLow", true)
		CreateBundleAnim("Swimming", "SwimIdle", "SwimIdle", "127000018504760", .19, 1, "PriorLow", true)
		CreateBundleAnim("Swimming", "Climb", "Climb", "106565864572994", .19, 1, "PriorLow", true)
		CreateBundle("DefaultR6", "Classic R6", "R15")
		CreateBundleAnim("DefaultR6", "Run", "Run", "88923549940250", .1, 1, "PriorLowRunning", true)
		CreateBundleAnim("DefaultR6", "Idle", "Idle", {"130392105157572", "127809880138049"}, .1, 1, "PriorLowIdle", true)
		CreateBundleAnim("DefaultR6", "Jump", "Jump", "104431031478990", .1, 1, "PriorLow", false)
		CreateBundleAnim("DefaultR6", "Fall", "Fall", "120544331479174", .1, 1, "PriorLow", true)
		CreateBundleAnim("DefaultR6", "Swim", "Swim", "95810055818410", .1, 1, "PriorLow", true)
		CreateBundleAnim("DefaultR6", "SwimIdle", "SwimIdle", "110399731107585", .1, 1, "PriorLow", true)
		CreateBundleAnim("DefaultR6", "Climb", "Climb", "114865095826475", .1, 1.35, "PriorLow", true)
		CreateBundle("Minecraft", "Minecraft", "R15")--Not complete (Find another Swim Animation)
		CreateBundleAnim("Minecraft", "Run", "Run", "86028285109536", .19, 0.92, "PriorLowRunningOnJump", true)
		--CreateBundleAnim("Minecraft", "Walk", "Walk", "73935678087300", .19, 1, "PriorLowRunningUntil8OnJump", true)
		CreateBundleAnim("Minecraft", "Idle", "Idle", "105514975554898", .19, 1, "PriorLowIdle", true)
		CreateBundleAnim("Minecraft", "Swim", "Swim", "72103407662583", .19, 0.7, "PriorLow", true)
		CreateBundleAnim("Minecraft", "SwimIdle", "SwimIdle", "86028285109536", .19, 0.9, "PriorLow", true)
		CreateBundleAnim("Minecraft", "Climb", "Climb", "119233460706851", .19, 1, "PriorLow", true)
		CreateBundle("Wheel", "Wheel", "R15")--Not complete
		CreateBundleAnim("Wheel", "Run", "Run", "116700088132671", .19, 0.7, "PriorLowRunningOnJump", true)
		CreateBundleAnim("Wheel", "Idle", "Idle", "116700088132671", .19, 0, "PriorLowIdle", true)
		CreateBundleAnim("Wheel", "Climb", "Climb", "116700088132671", .19, 0.4, "PriorLow", true)
		CreateBundle("GtaVMale", "GTA V", "R15")
		CreateBundleAnim("GtaVMale", "Run", "Run", "76558538119762", .19, 0.85, "PriorLowRunning8", true)
		CreateBundleAnim("GtaVMale", "Walk", "Walk", "87036951683974", .19, 2, "PriorLowRunningUntil8", true)
		CreateBundleAnim("GtaVMale", "Idle", "Idle", {"100073202083731", "80647773920860"}, .19, 1, "PriorLowIdle", true)
		CreateBundleAnim("GtaVMale", "Jump", "Jump", "123814879688543", .19, 1, "PriorLow", false)
		CreateBundleAnim("GtaVMale", "Fall", "Fall", "74602952362298", .19, 1, "PriorLow", true)
		CreateBundleAnim("GtaVMale", "Swim", "Swim", "77244611274505", .19, 1, "PriorLow", true)
		CreateBundleAnim("GtaVMale", "SwimIdle", "SwimIdle", "132806499543756", .19, 1, "PriorLow", true)
		CreateBundleAnim("GtaVMale", "Climb", "Climb", "92579715281174", .19, 1, "PriorLow", true)
		CreateBundle("GlowMotion", "Glow Motion", "R15")
		CreateBundleAnim("GlowMotion", "Run", "Run", "101925097435036", .19, 0.9, "PriorLowRunning8", true)
		CreateBundleAnim("GlowMotion", "Walk", "Walk", "85809016093530", .19, 2, "PriorLowRunningUntil8", true)
		CreateBundleAnim("GlowMotion", "Idle", "Idle", {"137764781910579", "96439737641086"}, .19, 1, "PriorLowIdle", true)
		CreateBundleAnim("GlowMotion", "Jump", "Jump", "74159004634379", .19, 1, "PriorLow", false)
		CreateBundleAnim("GlowMotion", "Fall", "Fall", "98070939608691", .19, 1, "PriorLow", true)
		CreateBundleAnim("GlowMotion", "Swim", "Swim", "83003487432457", .19, 1, "PriorLow", true)
		CreateBundleAnim("GlowMotion", "SwimIdle", "SwimIdle", "112946194103503", .19, 1, "PriorLow", true)
		CreateBundleAnim("GlowMotion", "Climb", "Climb", "108236155509584", .19, 1, "PriorLow", true)
	end

	if RigType == "R6" then
		R6Anims()
	else
		R15Anims()
	end

	local CAOutput = "<b>CustomAnims:</b>\n"
	local GSGAOutput = "<b>GameSpecificAnims from Github</b>"
	local LSGAOutput = "<b>GameSpecificAnims from local file</b>"
	local function AddDataOperation()
		AddedDataInfo.Value = "<b>ADDED DATA FROM FILES:</b>\n\n"

		local function AdditionalAnimsOperation()
			if DebugInfoEnabled then print("[AdditionalAnims File]: Adding animations from AdditionalAnims file in Github") end
			local finalUrl = "https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/SpecificGameAnimations/AdditionalAnimations"
			local success, fileContent = pcall(function()
				return game:HttpGet(finalUrl)
			end)
			if not success or not fileContent or fileContent == "404: Not Found" then
				if DebugInfoEnabled then warn("[AdditionalAnims File]: AdditionalAnims file wasn't found") end
				return 
			end
			local success2, data = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)
			if not success2 or not data then
				warn("[AdditionalAnims File]: Error in JSON structure in AdditionalAnims file")
				FileErrors = true
				return
			end

			for categoryName, animationsList in pairs(data) do
				if categoryName == "CustomEmotes" and #data["CustomEmotes"] ~= 0 then
					if DebugInfoEnabled then print("[AdditionalAnims File]: Extracting Animations") end
					for _, info in ipairs(animationsList) do
						local danceButton = Instance.new("TextButton")
						CreateAnim(danceButton, info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9])
					end
				elseif categoryName == "CustomBundles" and #data["CustomBundles"] ~= 0 then
					if DebugInfoEnabled then print("[AdditionalAnims File]: Extracting Animations") end
					for index, bundle in ipairs(data.CustomBundles) do
						local bundleInfo = bundle.BundleData
						CreateBundle(bundleInfo[1], bundleInfo[2], bundleInfo[3])
						for _, info in ipairs(bundle.BundleAnims) do
							CreateBundleAnim(info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8])
						end
					end
				elseif categoryName == "DefaultAnims" and #data["DefaultAnims"] ~= 0 then
					if DebugInfoEnabled then print("[AdditionalAnims File]: Adding Default animations")end
					for _, id in ipairs(data["DefaultAnims"]) do
						if not table.find(DefaultAnimsNameList, id) then
							table.insert(DefaultAnimsNameList, tostring(id))
						end
					end
				end
			end
			print("[AdditionalAnims File]: Loaded Data!")
		end

		local function CustomAnimsOperation()
			if DebugInfoEnabled then print("[CustomAnims File]: Searching CustomAnims file") end
			local success, fileContent = pcall(function()
				return readfile("EmoterData/CustomAnims.json")
			end)
			if not success or not fileContent then 
				if DebugInfoEnabled then warn("[CustomAnims File]: CustomAnims file wasn't found") end
				return 
			end
			local success2, data = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)
			if not success2 or not data then
				warn("[CustomAnims File]: Error in JSON structure in CustomAnims file")
				FileErrors = true
				return
			end

			for categoryName, animationsList in pairs(data) do
				if categoryName == "CustomEmotes" and #data["CustomEmotes"] ~= 0 then
					if DebugInfoEnabled then print("[CustomAnims File]: Extracting Animations") end
					CAOutput = CAOutput.."CustomEmotes\n"
					for _, info in ipairs(animationsList) do
						local danceButton = Instance.new("TextButton")
						CreateAnim(danceButton, info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9])
					end
				elseif categoryName == "CustomBundles" and #data["CustomBundles"] ~= 0 then
					if DebugInfoEnabled then print("[CustomAnims File]: Extracting Animations") end
					CAOutput = CAOutput.."CustomBundles\n"
					for index, bundle in ipairs(data.CustomBundles) do
						local bundleInfo = bundle.BundleData
						CreateBundle(bundleInfo[1], bundleInfo[2], bundleInfo[3])
						for _, info in ipairs(bundle.BundleAnims) do
							CreateBundleAnim(info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8])
						end
					end
				elseif categoryName == "DefaultAnims" and #data["DefaultAnims"] ~= 0 then
					if DebugInfoEnabled then print("[CustomAnims File]: Adding Default animations") end
					CAOutput = CAOutput.."DefaultAnims\n"
					for _, id in ipairs(data["DefaultAnims"]) do
						if not table.find(DefaultAnimsNameList, id) then
							table.insert(DefaultAnimsNameList, tostring(id))
						end
					end
				elseif categoryName == "ToolActionAnims" and #data["ToolActionAnims"] ~= 0 then
					if DebugInfoEnabled then print("[CustomAnims File]: Adding ToolAction Animations") end
					CAOutput = CAOutput.."ToolActionAnims\n"
					for _, id in ipairs(data["ToolActionAnims"]) do
						if not table.find(ToolActionAnimsList, id) then
							table.insert(ToolActionAnimsList, tostring(id))
						end
					end
				elseif categoryName == "ToolIdleAnims" and #data["ToolIdleAnims"] ~= 0 then
					if DebugInfoEnabled then print("[CustomAnims File]: Adding ToolIdle Animations") end
					CAOutput = CAOutput.."ToolIdleAnims\n"
					for _, id in ipairs(data["ToolIdleAnims"]) do
						if not table.find(ToolIdleAnimsList, id) then
							table.insert(ToolIdleAnimsList, tostring(id))
						end
					end
				end
				if categoryName == "R6EmoteWheelEmotes" and RigType == "R6" and next(data.R6EmoteWheelEmotes) ~= nil then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Adding EmoteWhell Data") end
					CAOutput = CAOutput.."EmoteWheelEmotes\n"
					local info = data["R6EmoteWheelEmotes"]
					if info.Emote1 then EmoteWheelEmotes.Emote1 = info.Emote1 end
					if info.Emote2 then EmoteWheelEmotes.Emote2 = info.Emote2 end
					if info.Emote3 then EmoteWheelEmotes.Emote3 = info.Emote3 end
					if info.Emote4 then EmoteWheelEmotes.Emote4 = info.Emote4 end
					if info.Emote5 then EmoteWheelEmotes.Emote5 = info.Emote5 end
					if info.Emote6 then EmoteWheelEmotes.Emote6 = info.Emote6 end
					if info.Emote7 then EmoteWheelEmotes.Emote7 = info.Emote7 end
					if info.Emote8 then EmoteWheelEmotes.Emote8 = info.Emote8 end
				elseif categoryName == "R15EmoteWheelEmotes" and RigType == "R15" and next(data.R15EmoteWheelEmotes) ~= nil then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Adding EmoteWhell Data") end
					CAOutput = CAOutput.."EmoteWheelEmotes\n"
					local info = data["R15EmoteWheelEmotes"]
					if info.Emote1 then EmoteWheelEmotes.Emote1 = info.Emote1 end
					if info.Emote2 then EmoteWheelEmotes.Emote2 = info.Emote2 end
					if info.Emote3 then EmoteWheelEmotes.Emote3 = info.Emote3 end
					if info.Emote4 then EmoteWheelEmotes.Emote4 = info.Emote4 end
					if info.Emote5 then EmoteWheelEmotes.Emote5 = info.Emote5 end
					if info.Emote6 then EmoteWheelEmotes.Emote6 = info.Emote6 end
					if info.Emote7 then EmoteWheelEmotes.Emote7 = info.Emote7 end
					if info.Emote8 then EmoteWheelEmotes.Emote8 = info.Emote8 end
				end
			end
			print("[CustomAnims File]: Loaded Data!")
			if CAOutput ~= "<b>CustomAnims:</b> " then
				AddedDataInfo.Value = AddedDataInfo.Value..CAOutput.."\n"
			end
		end

		local function GithubSpecGameAnimsOperation()
			if DebugInfoEnabled then print("[SpecGameAnims Github]: Searching Anims file in Github for game ".. game.GameId) end

			local baseUrl = "https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/SpecificGameAnimations/"
			local finalUrl = baseUrl .. tostring(game.GameId)
			local success, fileContent = pcall(function()
				return game:HttpGet(finalUrl)
			end)
			if not success or not fileContent or fileContent == "404: Not Found" then
				if DebugInfoEnabled then warn("[SpecGameAnims Github]: No file in Github for this game") end
				return
			end
			local success2, data = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)
			if not success2 or not data then
				warn("[SpecGameAnims Github]: Error in JSON structure in file")
				FileErrors = true
				return
			end

			if data.AdditionalData and data.AdditionalData.Version then
				GSGAOutput = GSGAOutput.." (<b>V "..data["AdditionalData"].Version..")</b>:\n"
			else
				GSGAOutput = GSGAOutput..":\n"
			end
			for categoryName, animationsList in pairs(data) do
				if categoryName == "CustomEmotes" and #data["CustomEmotes"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims Github]: Extracting Animations") end
					GSGAOutput = GSGAOutput.."CustomEmotes\n"
					for _, info in ipairs(animationsList) do
						local danceButton = Instance.new("TextButton")
						CreateAnim(danceButton, info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9])
					end
				elseif categoryName == "CustomBundles" and #data["CustomBundles"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims Github]: Extracting Animations") end
					GSGAOutput = GSGAOutput.."CustomBundles\n"
					for index, bundle in ipairs(data.CustomBundles) do
						local bundleInfo = bundle.BundleData
						CreateBundle(bundleInfo[1], bundleInfo[2], bundleInfo[3])
						for _, info in ipairs(bundle.BundleAnims) do
							CreateBundleAnim(info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8])
						end
					end
				elseif categoryName == "DefaultAnims" and #data["DefaultAnims"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims Github]: Adding Default animations") end
					GSGAOutput = GSGAOutput.."DefaultAnims\n"
					for _, id in ipairs(data["DefaultAnims"]) do
						if not table.find(DefaultAnimsNameList, id) then
							table.insert(DefaultAnimsNameList, tostring(id))
						end
					end
				elseif categoryName == "ToolActionAnims" and #data["ToolActionAnims"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims Github]: Adding ToolAction Animations") end
					GSGAOutput = GSGAOutput.."ToolActionAnims\n"
					for _, id in ipairs(data["ToolActionAnims"]) do
						if not table.find(ToolActionAnimsList, id) then
							table.insert(ToolActionAnimsList, tostring(id))
						end
					end
				elseif categoryName == "ToolIdleAnims" and #data["ToolIdleAnims"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims Github]: Adding ToolIdle Animations") end
					GSGAOutput = GSGAOutput.."ToolIdleAnims\n"
					for _, id in ipairs(data["ToolIdleAnims"]) do
						if not table.find(ToolIdleAnimsList, id) then
							table.insert(ToolIdleAnimsList, tostring(id))
						end
					end
				elseif categoryName == "EmoteWheelEmotes" and next(data.EmoteWheelEmotes) ~= nil then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Adding EmoteWhell Data") end
					GSGAOutput = GSGAOutput.."EmoteWheelEmotes\n"
					local info = data["EmoteWheelEmotes"]
					if info.Emote1 then EmoteWheelEmotes.Emote1 = info.Emote1 end
					if info.Emote2 then EmoteWheelEmotes.Emote2 = info.Emote2 end
					if info.Emote3 then EmoteWheelEmotes.Emote3 = info.Emote3 end
					if info.Emote4 then EmoteWheelEmotes.Emote4 = info.Emote4 end
					if info.Emote5 then EmoteWheelEmotes.Emote5 = info.Emote5 end
					if info.Emote6 then EmoteWheelEmotes.Emote6 = info.Emote6 end
					if info.Emote7 then EmoteWheelEmotes.Emote7 = info.Emote7 end
					if info.Emote8 then EmoteWheelEmotes.Emote8 = info.Emote8 end
				end
				if categoryName == "AdditionalData" and next(data.AdditionalData) ~= nil then
					GSGAOutput = GSGAOutput.."AdditionalData\n"
					if data["AdditionalData"].DefaultWalkSpeed then
						DefaultWalkSpeed = data["AdditionalData"].DefaultWalkSpeed
						if DebugInfoEnabled then print("Chaged DefaultWalkSpeed to "..DefaultWalkSpeed) end
					elseif data["AdditionalData"].AnimationHandlerName then
						AnimationHandler = data["AdditionalData"].AnimationHandlerName
					end
				end
			end
			print("[SpecGameAnims Github]: Loaded Data!")
			if GSGAOutput ~= "<b>GameSpecificAnims from Github:</b> " then
				AddedDataInfo.Value = AddedDataInfo.Value..GSGAOutput.."\n"
			end
		end

		local function FileSpecGameAnimsOperation()
			if DebugInfoEnabled then print("[SpecGameAnims File]: Searching Specific GameAnims file") end
			local targetNumber = tostring(game.GameId)
			local folderPath = "EmoterData/SpecificAnims"
			local targetFilePath = nil
			local fileFound = false

			local success, files = pcall(listfiles, folderPath)
			if not success then
				if DebugInfoEnabled then warn("[SpecGameAnims File]: Your exploit doesn't support function listfiles() or folder id empty") end
				return
			end
			for _, filePath in ipairs(files) do
				local fileName = filePath:match("[^/\\]+$") or filePath
				local extractedNumber = fileName:match("(%d+)")

				if extractedNumber then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Found file: " .. fileName .. " | Extracted number: " .. extractedNumber) end
					if extractedNumber == targetNumber then
						if DebugInfoEnabled then print("[SpecGameAnims File]: Found file: " .. filePath) end
						fileFound = true
						targetFilePath = filePath
						break
					end
				end
			end
			if not fileFound then
				if DebugInfoEnabled then warn("[SpecGameAnims File]: File with number " .. targetNumber .. "hasn't found in files") end
				return
			end
			local success2, fileContent = pcall(function()
				return readfile(targetFilePath)
			end)
			if not success2 or not fileContent then
				if DebugInfoEnabled then warn("[SpecGameAnims File]: Couldn't read file") end
				FileErrors = true
				return
			end
			local success3, data = pcall(function()
				return HttpService:JSONDecode(fileContent)
			end)
			if not success3 or not data then
				warn("[SpecGameAnims File]: Error in JSON structure in file")
				FileErrors = true
				return
			end

			if data.AdditionalData and data.AdditionalData["Version"] then
				LSGAOutput = LSGAOutput.." <b>(V: "..data["AdditionalData"].Version..")</b>:\n"
			else
				LSGAOutput = LSGAOutput..":\n"
			end

			for categoryName, animationsList in pairs(data) do
				if categoryName == "CustomEmotes" and #data["CustomEmotes"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Extracting Animations") end
					LSGAOutput = LSGAOutput.."CustomEmotes\n"
					for _, info in ipairs(animationsList) do
						local danceButton = Instance.new("TextButton")
						CreateAnim(danceButton, info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8], info[9])
					end
				elseif categoryName == "CustomBundles" and #data["CustomBundles"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Extracting Animations") end
					LSGAOutput = LSGAOutput.."CustomBundles\n"
					for index, bundle in ipairs(data.CustomBundles) do
						local bundleInfo = bundle.BundleData
						CreateBundle(bundleInfo[1], bundleInfo[2], bundleInfo[3])
						for _, info in ipairs(bundle.BundleAnims) do
							CreateBundleAnim(info[1], info[2], info[3], info[4], info[5], info[6], info[7], info[8])
						end
					end
				elseif categoryName == "DefaultAnims" and #data["DefaultAnims"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Adding Default animations") end
					LSGAOutput = LSGAOutput.."DefaultAnims\n"
					for _, id in ipairs(data["DefaultAnims"]) do
						if not table.find(DefaultAnimsNameList, id) then
							table.insert(DefaultAnimsNameList, tostring(id))
						end
					end
				elseif categoryName == "ToolActionAnims" and #data["ToolActionAnims"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Adding ToolAction Animations") end
					LSGAOutput = LSGAOutput.."ToolActionAnims\n"
					for _, id in ipairs(data["ToolActionAnims"]) do
						if not table.find(ToolActionAnimsList, id) then
							table.insert(ToolActionAnimsList, tostring(id))
						end
					end
				elseif categoryName == "ToolIdleAnims" and #data["ToolIdleAnims"] ~= 0 then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Adding ToolIdle Animations") end
					LSGAOutput = LSGAOutput.."ToolIdleAnims\n"
					for _, id in ipairs(data["ToolIdleAnims"]) do
						if not table.find(ToolIdleAnimsList, id) then
							table.insert(ToolIdleAnimsList, tostring(id))
						end
					end
				elseif categoryName == "EmoteWheelEmotes" and next(data.EmoteWheelEmotes) ~= nil then
					if DebugInfoEnabled then print("[SpecGameAnims File]: Adding EmoteWhell Data") end
					LSGAOutput = LSGAOutput.."EmoteWheelEmotes\n"
					local info = data["EmoteWheelEmotes"]
					EmoteWheelEmotes.Emote1 = info.Emote1
					if info.Emote2 then EmoteWheelEmotes.Emote2 = info.Emote2 end
					if info.Emote3 then EmoteWheelEmotes.Emote3 = info.Emote3 end
					if info.Emote4 then EmoteWheelEmotes.Emote4 = info.Emote4 end
					if info.Emote5 then EmoteWheelEmotes.Emote5 = info.Emote5 end
					if info.Emote6 then EmoteWheelEmotes.Emote6 = info.Emote6 end
					if info.Emote7 then EmoteWheelEmotes.Emote7 = info.Emote7 end
					if info.Emote8 then EmoteWheelEmotes.Emote8 = info.Emote8 end
				end
				if categoryName == "AdditionalData" and next(data.AdditionalData) ~= nil then
					LSGAOutput = LSGAOutput.."AdditionalData\n"
					if data["AdditionalData"].DefaultWalkSpeed then
						DefaultWalkSpeed = data["AdditionalData"].DefaultWalkSpeed
						if DebugInfoEnabled then print("Chaged DefaultWalkSpeed to "..DefaultWalkSpeed) end
					elseif data["AdditionalData"].AnimationHandlerName then
						AnimationHandler = data["AdditionalData"].AnimationHandlerName
					end
				end
			end
			print("[SpecGameAnims File]: Loaded data!")
			if LSGAOutput ~= "<b>GameSpecificAnims from local file:</b> " then
				AddedDataInfo.Value = AddedDataInfo.Value..LSGAOutput
			end
		end

		if LoadGithubCustomAnimsEnabled then
			LoadingState = "Adding data from Github Additional Anims file"
			AdditionalAnimsOperation()
		end
		if LoadLocalCustomAnimsEnabled then
			LoadingState = "Adding data from local Custom Anims file"
			CustomAnimsOperation()
		end
		if LoadGithubSGAEnabled then
			LoadingState = "Adding data from Github SGA file"
			GithubSpecGameAnimsOperation()
		end
		if LoadLocalSGAEnabled then
			LoadingState = "Adding data from local SGA file"
			FileSpecGameAnimsOperation()
		end

		if AddedDataInfo.Value ~= "<b>ADDED DATA FROM FILES:</b>\n\n" then
			DataNotification.Visible = true
		end
	end

	if not IsInStudio then
		LoadingState = "Adding data from Files"
		print(LoadingState)
		AddDataOperation()
	end
	if DebugInfoEnabled then
		for index, id in ipairs(ToolActionAnimsList) do
			print("Position: " .. index .. " | Id: " .. id)
		end
	end

	CreateDivideFrame("Dances", 0, "Spec")
	CreateDivideFrame("Actions", 1, "Spec")
	CreateDivideFrame("Walk & Run", 2, "Spec")
	CreateDivideFrame("Poses & Idles", 3, "Spec")
	CreateDivideFrame("Weird", 4, "Spec")
	CreateDivideFrame("Attack", 5, "Spec")

	if not ScrollingFrameSpecific:FindFirstChildOfClass("TextButton") then --Making A tip for when there's no SGA in Specific section and other function
		if CurrentSection == "Specific" then CurrentSection = "Default" end
		if LoadLocalSGAEnabled or LoadGithubSGAEnabled then
			local Tip = SpecGameSection:Clone()
			Tip.Name = "Tip"
			Tip.Parent = SectionsFrame
			Tip.Size = UDim2.new(0, 23, 0, 23)
			Tip.Position = UDim2.new(1, 5, 0, 0)
			Tip.BackgroundTransparency = 0.3
			Tip.Text = "<b>?</b>"
			Tip.TextScaled = true
			Tip.AutoButtonColor = false
			Tip.TextXAlignment = Enum.TextXAlignment.Center
			Tip.UIStroke:Destroy()
			local Corner = Instance.new("UICorner", Tip)
			Corner.CornerRadius = UDim.new(1,0)
			AddHoverText(Tip, "Haven't found any animations for this specific game. \nWant to add it yourself? Check out <b>Emoter's Github</b> page!")
		end

		SpecGameSection.Interactable = false
		SpecGameSection.TextTransparency = 0.5
	else
		AddHoverText(SpecGameSection, "Specific game Animations")
		if SpecCategoryOnLaunch and FirstLaunch then
			CurrentSection = "Specific"
			SpecGameSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
			DefaultSection.UIStroke.Color = Color3.fromRGB(0, 0, 0)
			ScrollingFrameSpecific.Visible = true
			ScrollingFrameR6.Visible = false
			ScrollingFrameR15.Visible = false
		end
	end


	--Emote wheel
	LoadingState = "Setting up Emote wheel"
	local function EmoteWheelButton(Button, AnimButtonName, KeyCode, ActionName)
		local NumLabel = Instance.new("TextLabel")
		NumLabel.Parent = Button
		NumLabel.Size = UDim2.new(1, 0, 1, 0)
		NumLabel.BackgroundTransparency = 1
		NumLabel.TextColor3 = UiButColor
		NumLabel.Text = string.match(ActionName, "%d+")
		NumLabel.Font = Enum.Font.Roboto
		NumLabel.TextTransparency = 0.87
		NumLabel.TextScaled = true
		NumLabel.ZIndex = 100

		local prefix, suffix
		if string.match(AnimButtonName, "^R15") then
			prefix, suffix = string.match(AnimButtonName, "^(R15)(.+)$")
		elseif string.match(AnimButtonName, "^Spec") then
			prefix, suffix = string.match(AnimButtonName, "^(Spec)(.+)$")
		elseif string.match(AnimButtonName, "^R6") then
			prefix, suffix = string.match(AnimButtonName, "^(R6)(.+)$")
		elseif string.match(AnimButtonName, "^Bundle") then
			prefix, suffix = string.match(AnimButtonName, "^(Bundle)(.+)$")
		end

		local AnimButton
		if prefix == "R15" then
			AnimButton = ScrollingFrameR15:FindFirstChild(suffix) or ScrollingFrameR15:FindFirstChild("Dance1")
		elseif prefix == "R6" then
			AnimButton = ScrollingFrameR6:FindFirstChild(suffix) or ScrollingFrameR6:FindFirstChild("Dance1")
		elseif prefix == "Spec" then
			AnimButton = ScrollingFrameSpecific:FindFirstChild(suffix) or DefaultScrollingFrame:FindFirstChild("Dance1")
		elseif prefix == "Bundle" then
			AnimButton = ScrollingFrameBundles:FindFirstChild(suffix) or DefaultScrollingFrame:FindFirstChild("Dance1")
		end

		if prefix == "Bundle" then
			if AnimButton:IsA("ImageButton") then
				Button.Text = tostring(AnimButton:GetAttribute("BundleTitle")).." Bundle"
			else
				Button.Text = tostring(AnimButton:GetAttribute("Bundle")).." "..string.gsub(AnimButton.Text, "<[^>]+>", "")
			end
		else
			Button.Text = string.gsub(AnimButton.Text, "<[^>]+>", "")
		end

		local AnimActive = false
		Button.MouseButton1Click:connect(function()
			EmoteWheel.Visible = false
			AnimActive = not AnimActive
			if AnimActive then
				AnimButton.BackgroundColor3 = ButtonSelectCol
			else
				AnimButton.BackgroundColor3 = ButtonCol
			end
		end)

		AnimButton.Changed:Connect(function()
			if AnimButton.BackgroundColor3 == ButtonSelectCol then
				Button.BackgroundColor3 = ButtonSelectCol
				AnimActive = true
			else
				Button.BackgroundColor3 = ButtonCol
				AnimActive = false
			end
		end)

		local function onKeyPress(actionName, inputState, inputObject)
			if inputState == Enum.UserInputState.Begin then
				EmoteWheel.Visible = false
				AnimActive = not AnimActive
				if AnimActive then
					AnimButton.BackgroundColor3 = ButtonSelectCol
				else
					AnimButton.BackgroundColor3 = ButtonCol
				end
			end
			return Enum.ContextActionResult.Sink
		end

		local function updateInputHandling()
			if EmoteWheel.Visible then
				ContextActionService:BindAction(ActionName, onKeyPress, false, KeyCode)
			else
				ContextActionService:UnbindAction(ActionName)
			end
		end

		updateInputHandling()
		EmoteWheel:GetPropertyChangedSignal("Visible"):Connect(updateInputHandling)
	end
	EmoteWheelButton(Emote1, EmoteWheelEmotes.Emote1, Enum.KeyCode.One, "InterceptKey1")
	EmoteWheelButton(Emote2, EmoteWheelEmotes.Emote2, Enum.KeyCode.Two, "InterceptKey2")
	EmoteWheelButton(Emote3, EmoteWheelEmotes.Emote3, Enum.KeyCode.Three, "InterceptKey3")
	EmoteWheelButton(Emote4, EmoteWheelEmotes.Emote4, Enum.KeyCode.Four, "InterceptKey4")
	EmoteWheelButton(Emote5, EmoteWheelEmotes.Emote5, Enum.KeyCode.Five, "InterceptKey5")
	EmoteWheelButton(Emote6, EmoteWheelEmotes.Emote6, Enum.KeyCode.Six, "InterceptKey6")
	EmoteWheelButton(Emote7, EmoteWheelEmotes.Emote7, Enum.KeyCode.Seven, "InterceptKey7")
	EmoteWheelButton(Emote8, EmoteWheelEmotes.Emote8, Enum.KeyCode.Eight, "InterceptKey8")


	-- UI Decorations
	local UiCornerParts = {"BundlesSection", "SpecGameSection", "DefaultSection", "Emote1", "Emote2", "Emote3", "Emote4", "Emote5", "Emote6", "Emote7", "Emote8", "ResetButton", "CustomAnimFrame", "PlayAnimButton", "CustomAnimButton", "HotkeysEditOption", "SaveSettingsButton", "LaunchIdDetectorButton", "GithubLinkButton", "HotkeysFrame", "SettingsFrame", "GuiTopFrame", "CloseGUI", "DestroyGUI", "GuiBottomFrame", "SpeedValue", "SideFrame", "ViewportFrame", "OptionsFrame", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton", "EmoteWheelButton", "ReversePlayButton", "SearchFrame", "SearchButton"}
	local UiStrokeParts = {"BundlesSection", "ScrollingFrameBundles", "Emote1", "Emote2", "Emote3", "Emote4", "Emote5", "Emote6", "Emote7", "Emote8", "CustomAnimFrame", "HotkeysFrame", "SettingsFrame", "GuiTopFrame", "GuiBottomFrame", "SideFrame", "ScrollingFrame", "ScrollingFrameR15", "ScrollingFrameSpecific", "OptionsFrame", "SearchFrame"}
	local UiStroke1Parts = {"ResetButton", "PlayAnimButton", "IdBox", "HotkeysEditOption", "SaveSettingsButton", "LaunchIdDetectorButton", "GithubLinkButton", "SpeedValue", "SearchBox", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton", "EmoteWheelButton", "ReversePlayButton"}
	local UiGradientParts = {"BundlesSection", "SpecGameSection", "DefaultSection", "Emote1", "Emote2", "Emote3", "Emote4", "Emote5", "Emote6", "Emote7", "Emote8", "CustomAnimBackButton", "BackButton", "CustomAnimFrame", "PlayAnimButton", "CustomAnimButton", "SettingsButton", "GuiTopFrame", "GuiBottomFrame", "SideFrame", "SettingsButton", "DestroyGUI", "CloseGUI", "OptionsButton", "PauseAnimsButton", "StopDefAnimsButton", "PauseAnimateButton", "SitButton", "EmoteWheelButton", "ReversePlayButton", "SearchFrame", "SearchButton", "BackButton"}

	LoadingState = "Decorating Gui"
	for _, UiPart in ipairs(Emoter:GetDescendants()) do
		if table.find(UiCornerParts, UiPart.Name) and UICornerEnabled then
			local UICorner = Instance.new("UICorner")
			UICorner.Parent = UiPart
			UICorner.CornerRadius = UDim.new(0, 5)
			if UiPart.Name == "GuiTopFrame" then
				UICorner.BottomRightRadius = UDim.new(0, 0)
				UICorner.BottomLeftRadius = UDim.new(0, 0)
			elseif UiPart.Name == "GuiBottomFrame" then
				UICorner.TopLeftRadius = UDim.new(0, 0)
				UICorner.TopRightRadius = UDim.new(0, 0)
			elseif UiPart.Parent == EmoteWheel then
				UICorner.CornerRadius = UDim.new(0, 20)
			elseif UiPart.Name == "DestroyGUI" then
				UICorner.CornerRadius = UDim.new(0, 0)
				UICorner.TopRightRadius = UDim.new(0, 5)
			elseif UiPart.Name == "CloseGUI" then
				UICorner.CornerRadius = UDim.new(0, 0)
				UICorner.TopLeftRadius = UDim.new(0, 5)
			end

		end

		if table.find(UiStrokeParts, UiPart.Name) or table.find(UiStroke1Parts, UiPart.Name) then
			local UIStroke = Instance.new("UIStroke")
			UIStroke.Parent = UiPart
			UIStroke.Thickness = 2
			UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			if table.find(UiStroke1Parts, UiPart.Name) then
				UIStroke.Thickness = 1
			end
		end

		if table.find(UiGradientParts, UiPart.Name) and UIGradientEnabled then
			local UIGradient = Instance.new("UIGradient")
			UIGradient.Parent = UiPart
			UIGradient.Color = ColorSequence.new(Color3.fromRGB(207, 207, 207), Color3.fromRGB(255, 255, 255))
			UIGradient.Rotation = -90
		end
	end

	local function AddUiPadding(Part, left, right, top, bottom)
		for _, UiPart in ipairs(Emoter:GetDescendants()) do
			if UiPart.Name == Part then
				local UIPadding = Instance.new("UIPadding")
				UIPadding.PaddingLeft = UDim.new(0, left)
				UIPadding.PaddingRight = UDim.new(0, right)
				UIPadding.PaddingTop = UDim.new(0, top)
				UIPadding.PaddingBottom = UDim.new(0, bottom)
				UIPadding.Parent = UiPart
			end
		end
	end

	AddUiPadding("GuiBottomFrame",5,5)
	AddUiPadding("SpeedValue",2,2)
	AddUiPadding("CurAnimInfoTitle",0,0,1,5)
	AddUiPadding("ScrollingFrame",5,16,5,6)
	AddUiPadding("ScrollingFrameR15",5,16,5,6)
	AddUiPadding("ScrollingFrameSpecific",5,16,5,6)
	AddUiPadding("ScrollingFrameBundles",6,16,5,6)
	AddUiPadding("SearchBox",2,2)
	AddUiPadding("SettingsStuff",5,8,3,5)
	AddUiPadding("SwitchRunIdleExceptionOption", 20)
	AddUiPadding("ThemeOptionText",0,0,0,2)
	AddUiPadding("DragOptionText",0,0,0,2)
	AddUiPadding("HotkeysEditOption",0,0,0,2)
	AddUiPadding("HotkeysStuff",10,10,5,5)
	AddUiPadding("SearchFrame",2)
	AddUiPadding("IdBox",2,2)
	AddUiPadding("CustomAnimFrame",2)
	AddUiPadding("DefaultSection",7)
	AddUiPadding("SpecGameSection",7)
	AddUiPadding("BundlesSection",7)
	AddUiPadding("Emote1",3,3,3,3)
	AddUiPadding("Emote2",3,3,3,3)
	AddUiPadding("Emote3",3,3,3,3)
	AddUiPadding("Emote4",3,3,3,3)
	AddUiPadding("Emote5",3,3,3,3)
	AddUiPadding("Emote6",3,3,3,3)
	AddUiPadding("Emote7",3,3,3,3)
	AddUiPadding("Emote8",3,3,3,3)


	--OnRestart things
	LoadingState = "Restoring before-restart states"
	Emoter.Enabled = false
	AddVPF()

	if GuiPos ~= nil then
		SideFrame.Position = GuiPos
	end
	if GuiPos ~= nil then
		MainFrame.Position = GuiPos
	end
	if GuiClosed then
		SideFrame.Visible = true
		MainFrame.Visible = false
		MFUIScale.Scale = 0.8
	else
		SFUIScale.Scale = 1.2
	end
	if OptionsOpened then
		OptionsFrame.Visible = true
		OptionsFrame.Position = UDim2.new(0.5, 0, 1, 7)
	end
	if SettingsOpened then
		SettingsFrame.Visible = true
	end
	if CurrentSection == "Default" then
		DefaultSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		if RigType == "R15" then
			ScrollingFrameR15.Visible = true
		else
			ScrollingFrameR6.Visible = true
		end
		ScrollingFrameSpecific.Visible = false
		ScrollingFrameBundles.Visible = false
	elseif CurrentSection == "Specific" then
		SpecGameSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		ScrollingFrameR15.Visible = false
		ScrollingFrameR6.Visible = false
		ScrollingFrameSpecific.Visible = true
		ScrollingFrameBundles.Visible = false
	elseif CurrentSection == "Bundles" then
		BundlesSection.UIStroke.Color = Color3.fromRGB(255, 255, 255)
		ScrollingFrameR15.Visible = false
		ScrollingFrameR6.Visible = false
		ScrollingFrameSpecific.Visible = false
		ScrollingFrameBundles.Visible = true
	end

	if ScrollingFramePos ~= nil then
		ScrollingFrameR6.CanvasPosition = ScrollingFramePos
		ScrollingFrameR15.CanvasPosition = ScrollingFramePos
	end
	if ScrollingFrameSpecificPos ~= nil then
		ScrollingFrameSpecific.CanvasPosition = ScrollingFrameSpecificPos
	end
	SearchBox.Text = PrevSearchText
	IdBox.Text = PrevCustomAnimId
	SpeedValue.Text = PrevAnimSpeedValue
	if XSize < 460 then
		ValueText.Visible = false
		if XSize < 350 then
			if RigType == "R15" then
				Title.Text = "Emoter R15"
			else
				Title.Text = "Emoter R6"
			end
		end
	end
	if FirstLaunch then
		MFUIScale.Scale = 0
		game.TweenService:Create(MFUIScale, TweenInfo.new(.3, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Scale = 1}):Play()
	end
	Emoter.Enabled = true

	SettingsFrame.Visible = true --Made this so HotkeysFrame will be scrollable even if you scroll SettingsFrame before opening HotkeysFrame. Idk why it happens
	HotkeysFrame.Visible = true
	wait()
	SettingsFrame.Visible = false
	HotkeysFrame.Visible = false
	if SettingsPos ~= nil then
		SettingsFrame.Position = SettingsPos
	else
		SettingsFrame.Position = MainFrame.Position + UDim2.new(0, 590, 0, 0)
	end

	GuiEmoter = Emoter
	GuiLoaded = true
	FirstLaunch = false

	local RestartPlayer
	RestartPlayer = Player.CharacterAdded:Connect(function()
		if not GuiActive or GuiRestarted then
			RestartPlayer:Disconnect()
		end
		if GuiActive and not GuiRestarted and Player.Character:WaitForChild("Humanoid") then
			table.clear(RestartAnimations)
			StopAnimsEvent:Fire("Reset/Destroy")
			GuiRestarted = true
			BindHotkeys()
			OnRestart()
			RestartPlayer:Disconnect()
		end
		GuiRestarted = true
	end)

	LoadingState = "Loaded"
	print("Script loaded!")
end

function OnRestart()
	warn("--- Restarting Emoter GUI... ---")
	if MainFrame.Visible == true then
		GuiClosed = false
		GuiPos = GuiEmoter.MainFrame.Position
	elseif SideFrame.Visible == true then
		GuiClosed = true
		GuiPos = GuiEmoter.SideFrame.Position
	end
	if SettingsFrame.Visible == true then
		SettingsOpened = true
	else
		SettingsOpened = false
	end
	SettingsPos = GuiEmoter.SettingsFrame.Position
	if (game:GetService"Players".LocalPlayer.Character:WaitForChild("Humanoid").RigType == Enum.HumanoidRigType.R15) then
		ScrollingFramePos = ScrollingFrameR15.CanvasPosition
	else
		ScrollingFramePos = ScrollingFrameR6.CanvasPosition
	end
	ScrollingFrameSpecificPos = ScrollingFrameSpecific.CanvasPosition
	if OptionsFrame.Visible == true then
		OptionsOpened = true
	else
		OptionsOpened = false
	end
	--[[if ScrollingFrameR15.Visible or ScrollingFrameR6.Visible then
		CurrentSection = "Default"
	elseif ScrollingFrameSpecific.Visible then
		CurrentSection = "Specific"
	elseif ScrollingFrameBundles.Visible then
		CurrentSection = "Bundles"
	end]]

	if SearchBox.Visible == true then
		SearchOpened = true
	else
		SearchOpened = false
	end
	if IdBox.Visible == true then
		CustomAnimOpened = true
	else
		CustomAnimOpened = false
	end
	PrevAnimSpeedValue = SpeedFrame.SpeedValue.Text
	PrevSearchText = SearchBox.Text
	PrevCustomAnimId = IdBox.Text

	GuiEmoter:Destroy()

	local function Create()
		local CreateGuiOk, result = pcall(function()
			return CreateGui()
		end)
		if not CreateGuiOk then
			if Emoter and not IsInStudio then
				Emoter:Destroy()
			end
			Notify({Title = "FATAL ERROR!", Text = "An error occured while <b>"..LoadingState.."</b>. Check Dev Console for more info <b>(F9)</b>.\nWould you like to try again?", Time = 15,
				Choice1Text = "Launch GUI again", 
				Choice1Function = function()
					if GuiEmoter then GuiEmoter:Destroy() end
					Create()
				end, 
			})
			warn("[FATAL ERROR]: "..result)
		end
	end
	Create()

	if DebugInfoEnabled then
		for index, id in ipairs(RestartAnimations) do
			print("Restored: "..id)
		end
	end
end

--Launching the whole thing and handling on-launch notifications
local CreateGuiOk, result = pcall(function()
	return CreateGui()
end)
if not CreateGuiOk then
	if Emoter and not IsInStudio then
		Emoter:Destroy()
	end
	Notify({Title = "FATAL ERROR!", Text = "An error occured while <b>"..LoadingState.."</b>. Check Dev Console for more info <b>(F9)</b>", Time = 5})
	LoadingState = "Loaded"
	warn("[FATAL ERROR]: "..result)
else
	if not IsBetaBuild then
		Notify({Title = "Welcome to Emoter Gui!", Text = "Script succesfully loaded!", Image = 87633233506740, Time = 5})
	else
		Notify({Title = "Welcome to Emoter BETA!", Text = "Script succesfully loaded!", Image = 87633233506740, Time = 5})
		Notify({Title = "Thank you for joining BETA Test!", Text = "This version may be unstable and can have critical bugs. If you encounter any bug, <b>PLEASE</b> feel free to report it in <b>Issues</b> section of my Github project! You can always disable Beta test in settings"})
	end
	if LastUsedVersion < ScriptVersion and not IsBetaBuild then
		--ChkValues.NewBetaNotice = false
		Notify({Title = "Emoter updated!", Text = "Emoter has updated! ("..LastUsedVersion.." -> "..ScriptVersion..")\nWould you like to check Changelog in my Github to see what changes were made?", Choice1Text = "Check Changelog (link)", 
			Choice1Function = function() 
				setclipboard("https://github.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/blob/main/Documentations%20%26%20Changelogs/Emoter%20Changelog.md")
				Notify({Title = "Copied", Text = "Copied link to your clipboard!", Time = 3})
			end, 
			Image = 5832745500, Time = 5})
	end

	if not IsInStudio then
		if ConnectedToGithub then
			if LatestVersion > ScriptVersion and not IsBetaBuild then
				Notify({Title = "Outdated version!", Text = "You are using an outdated version of Emoter GUI. Please check my Github to get newer version (link in settings)", Time = 5})
			end
			if LastCheckedBeta < LatestBetaVersion and LatestVersion < LatestBetaVersion and not IsBetaBuild then
				Notify({Title = "A new BETA Version has come out!", Text = "Would you like to check it out? You can always do it by enabling BETA Test in settings", Choice1Text = "Open BETA Version", Choice1Function = function()
					StopAnimsEvent:Fire("Reset/Destroy")
					Emoter:Destroy()
					loadstring(game:HttpGet("https://raw.githubusercontent.com/Fixel656/Emoter-GUI_Roblox-Animations-Script/refs/heads/main/BetaVersion.lua",true))()
				end, Time = false})
			end
			if LatestVersion > ScriptVersion and IsBetaBuild then
				Notify({Title = "Outdated BETA!", Text = "Emoter's Stable version is now newer than Beta version. Please use loadstring given in Emoter's Github page", Time = 5})
			end
		end
		if FileErrors then
			Notify({Title = "File warning!", Text = "There were some issues while loading Animation Data from files. Check Dev Console for more info <b>(F9)</b>", Image = 103279993881362, Time = 5})
		end
	end
end
if not IsInStudio then
	SaveData("Update")
end
