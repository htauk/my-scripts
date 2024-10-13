--[[
	yuh uhh htauk here please dont steal my script without crediting it hurt my feeling :(
]]
local function ChangeBooth(text, id)
    local args = {
        [1] = "Update",
        [2] = {
            ["DescriptionText"] = text,
            ["ImageId"] = id,
        },
    }
    game:GetService("ReplicatedStorage").CustomiseBooth:FireServer(unpack(args))
end

-- Define the request method, using either Synapse or Fluxus, or a compatible executor's request function
local request = http_request or request or (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request)

-- Base URL for Yahoo Finance
local baseUrl = "https://finance.yahoo.com/quote/"

-- Function to extract the span value using regex
local function extractSpanValue(html, symbol)
    -- Define the regex pattern to match the <span> element inside the <fin-streamer>
    local pattern = '<fin%-streamer.-data%-symbol="' .. symbol .. '".-<span>([%d%.]+)</span>'

    -- Search for the match using string.match
    local value = string.match(html, pattern)

    -- If a value was found, return it
    if value then
        return value
    else
        return "No match found"
    end
end


local function getWebsiteHtml(symbol)
    local url = baseUrl .. symbol .. "/"
    

    if request then
        local response = request({
            Url = url,
            Method = "GET"
        })
        
  
        if response and response.StatusCode == 200 then
            print("HTML content fetched successfully.")
            

            local spanValue = extractSpanValue(response.Body, symbol)
            

            ChangeBooth("The current price for "..symbol.."is "..spanValue.."1", "115332018")
        else
            print("Failed to fetch HTML. Status code:", response.StatusCode)
        end
    end
end

-- Call the function to get the website's HTML and extract the <span> value using the defined symbol
while true do
    getWebsiteHtml(_G.symbol)
    wait(120)
end
