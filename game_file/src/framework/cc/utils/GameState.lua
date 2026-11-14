local _ENV, GameState
GameState.ERROR_INVALID_FILE_CONTENTS = -1
GameState.ERROR_HASH_MISS_MATCH = -2
GameState.ERROR_STATE_FILE_NOT_FOUND = -3
local crypto = require(cc.PACKAGE_NAME .. ".crypto")
local json = require(cc.PACKAGE_NAME .. ".json")
local encodeSign = "=QP="
local stateFilename = "state.txt"
local eventListener, secretKey
local isEncodedContents_ = function(contents)
	return string.sub(contents, 1, string.len(encodeSign)) == encodeSign
end
local encode_ = function(values)
	local s = json.encode(values)
	local hash = crypto.md5(s .. secretKey)
	json = secretKey
	secretKey.h = hash
	secretKey.s = s
	local contents = json.encode(secretKey)
	return encodeSign .. contents
end
local decode_ = function(fileContents)
	local contents = string.sub(fileContents, string.len(encodeSign) + 1)
	local j = json.decode(contents)
	if type(j) ~= "table" then
		printError("GameState.decode_() - invalid contents")
		_ENV = printError
		printError.errorCode = GameState.ERROR_INVALID_FILE_CONTENTS
		return printError
	end
	local hash, s = j.h, j.s
	local testHash = crypto.md5(s .. secretKey)
	if testHash ~= hash then
		printError("GameState.decode_() - hash miss match")
		_ENV = printError
		printError.errorCode = GameState.ERROR_HASH_MISS_MATCH
		return printError
	end
	local values = json.decode(s)
	if type(values) ~= "table" then
		printError("GameState.decode_() - invalid state data")
		_ENV = printError
		printError.errorCode = GameState.ERROR_INVALID_FILE_CONTENTS
		return printError
	end
	_ENV = printError
	printError.values = values
	return printError
end
function GameState.init(eventListener_, stateFilename_, secretKey_)
	if type(eventListener_) ~= "function" then
		printError("GameState.init() - invalid eventListener")
		return false
	end
	eventListener_ = {}
	if type(stateFilename_) == "string" then
		stateFilename_ = {}
	end
	if type(secretKey_) == "string" then
		secretKey_ = {}
	end
	_ENV = secretKey_
	secretKey_.name = "init"
	secretKey_.filename = GameState.getGameStatePath()
	secretKey_.encode = type(secretKey) == "string"
	eventListener(secretKey_)
	return true
end
function GameState.load()
	local filename = GameState.getGameStatePath()
	if not io.exists(filename) then
		printInfo("GameState.load() - file \"%s\" not found", filename)
		GameState = "GameState.load() - file \"%s\" not found"
		;("GameState.load() - file \"%s\" not found").name = "load"
		;("GameState.load() - file \"%s\" not found").errorCode = GameState.ERROR_STATE_FILE_NOT_FOUND
		return eventListener("GameState.load() - file \"%s\" not found")
	end
	local contents = io.readfile(filename)
	printInfo("GameState.load() - get values from \"%s\"", filename)
	local values
	local encode = false
	if secretKey and isEncodedContents_(contents) then
		local d = decode_(contents)
		if d.errorCode then
			GameState = nil
			;(nil).name = "load"
			;(nil).errorCode = d.errorCode
			return eventListener(nil)
		end
		values = d.values
		encode = true
	else
		values = json.decode(contents)
		if type(values) ~= "table" then
			printError("GameState.load() - invalid data")
			GameState = "GameState.load() - invalid data"
			;("GameState.load() - invalid data").name = "load"
			;("GameState.load() - invalid data").errorCode = GameState.ERROR_INVALID_FILE_CONTENTS
			return eventListener("GameState.load() - invalid data")
		end
	end
	GameState = "GameState.load() - invalid data"
	;("GameState.load() - invalid data").name = "load"
	;("GameState.load() - invalid data").values = values
	;("GameState.load() - invalid data").encode = encode
	;("GameState.load() - invalid data").time = os.time()
	return eventListener("GameState.load() - invalid data")
end
function GameState.save(newValues)
	eventListener = nil
	;(nil).name = "save"
	;(nil).values = newValues
	;(nil).encode = type(secretKey) == "string"
	local values = eventListener(nil)
	if type(values) ~= "table" then
		printError("GameState.save() - listener return invalid data")
		return false
	end
	local filename = GameState.getGameStatePath()
	local ret = false
	if secretKey then
		ret = io.writefile(filename, encode_(values))
	else
		local s = json.encode(values)
		if type(s) == "string" then
			ret = io.writefile(filename, s)
		end
	end
	printInfo("GameState.save() - update file \"%s\"", filename)
	return ret
end
function GameState.getGameStatePath()
	return string.gsub(device.writablePath, "[\\\\/]+$", "") .. device.directorySeparator .. stateFilename
end
if not cc then
	_ENV = cc
end
cc = cc
if not cc.utils then
	_ENV = cc.utils
end
cc.utils = cc.utils
cc.utils.State = GameState
return GameState
