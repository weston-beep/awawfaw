-- Aimbot feature (test)
print("✅ Aimbot feature loaded successfully!")

-- Create a simple label in the Aimbot tab to prove it works
local frame = script.Parent  -- this is the tab frame
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(1, -10, 0, 40)
label.Position = UDim2.new(0, 5, 0, 5)
label.BackgroundTransparency = 1
label.Text = "Aimbot loaded!"
label.TextColor3 = Color3.new(0,1,0)
label.Font = "GothamBold"
label.TextSize = 18
