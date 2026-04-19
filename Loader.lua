-- Replace 'YourUsername' and 'YourRepo' with your actual GitHub details!
local BaseURL = "https://raw.githubusercontent.com/YourUsername/YourRepo/main/"

local function Load(file)
    local code = game:HttpGet(BaseURL .. file)
    loadstring(code)()
end

print("Loading Nidavellir...")
Load("Data.lua")      -- Loads the IDs first
Load("Functions.lua") -- Loads the logic second
Load("UI.lua")        -- Loads the GUI last
print("Success!")
