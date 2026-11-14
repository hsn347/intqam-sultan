function import_poco(moduleName, currentModuleName)
	local currentModuleNameParts
	local moduleFullName = moduleName
	local offset = 1
	while true do
		if string.byte(moduleName, offset) ~= 46 then
			moduleFullName = string.sub(moduleName, offset)
			if currentModuleNameParts and 0 < #currentModuleNameParts then
				moduleFullName = table.concat(currentModuleNameParts, ".") .. "." .. moduleFullName
			end
			break
		end
		offset = offset + 1
		if not currentModuleNameParts then
			if not currentModuleName then
				local n, v = debug.getlocal(3, 1)
				currentModuleName = v
			end
			currentModuleNameParts = string.split(currentModuleName, ".")
		end
		table.remove(currentModuleNameParts, #currentModuleNameParts)
	end
	return require(moduleFullName)
end
local cc = _G.cc or require("cc")
local mime
xpcall(function()
end, function()
end)
local IScreen = import_poco(".sdk.IScreen")
local b64encode
if mime ~= nil then
	b64encode = mime.b64
else
	b64encode = import_poco(".support.base64").enc
end
local _ENV, screen = import_poco(".support.base64"), import_poco(".support.base64")
screen.__index = screen
setmetatable(screen, IScreen)
local director = cc.Director:getInstance()
local winSize = director:getWinSize()
local frameSize = director:getOpenGLView():getFrameSize()
function screen:getPortSize()
	_UPVALUE2_ = nil
	;(nil)[1] = frameSize.width
	;(nil)[2] = frameSize.height
	return nil
end
function screen:getScreen(width)
	local designRes = winSize
	local filename = "screenshot.png"
	local screenshotScaleFactor = width / designRes.width
	local scene = director:getRunningScene()
	return function(cb)
		cc.utils:captureScreen(function(succeed, outputFile)
			if succeed then
				print("截图成功：" .. outputFile)
				local f = io.open(outputFile, "rb")
				if not f then
					print("截图文件不存在 2333")
				end
				local screendata = f:read("*all")
				screendata = b64encode(screendata)
				cb = screendata
				screendata[1] = screendata
				screendata[2] = "png"
				cb(screendata)
				f:close()
				print("done!")
			else
				print("截图失败")
			end
		end, filename)
	end
end
return screen
