function SubStringUTF8(str, startIndex, endIndex)
	if startIndex < 0 then
		startIndex = SubStringGetTotalIndex(str) + startIndex + 1
	end
	if endIndex ~= nil and endIndex < 0 then
		endIndex = SubStringGetTotalIndex(str) + endIndex + 1
	end
	if endIndex == nil then
		return string.sub(str, SubStringGetTrueIndex(str, startIndex))
	else
		return string.sub(str, SubStringGetTrueIndex(str, startIndex), SubStringGetTrueIndex(str, endIndex + 1) - 1)
	end
end
function SubStringGetTotalIndex(str)
	local curIndex = 0
	local i = 1
	local lastCount = 1
	repeat
		lastCount = SubStringGetByteCount(str, i)
		i = i + lastCount
		curIndex = curIndex + 1
	until lastCount == 0
	return curIndex - 1
end
function SubStringGetTrueIndex(str, index)
	local curIndex = 0
	local i = 1
	local lastCount = 1
	repeat
		lastCount = SubStringGetByteCount(str, i)
		i = i + lastCount
		curIndex = curIndex + 1
	until index <= curIndex
	return i - lastCount
end
function SubStringGetByteCount(str, index)
	local curByte = string.byte(str, index)
	local byteCount = 1
	if curByte == nil then
		byteCount = 0
	elseif 0 < curByte and curByte <= 127 then
		byteCount = 1
	elseif 192 <= curByte and curByte <= 223 then
		byteCount = 2
	elseif 224 <= curByte and curByte <= 239 then
		byteCount = 3
	elseif 240 <= curByte and curByte <= 247 then
		byteCount = 4
	elseif 248 <= curByte and curByte <= 251 then
		byteCount = 5
	elseif 252 <= curByte then
		byteCount = 6
	end
	return byteCount
end
function RemoveStringSpecial(text)
	local first = 0
	local init = 0
	for _ = 1, 10 do
		first, init = string.find(text, [=[
[
]]=], init + 1)
		if not first then
			break
		end
	end
	if init then
		text = string.gsub(text, "[\n|\r]", "")
	end
	text = string.gsub(text, " ", "")
	return text
end
