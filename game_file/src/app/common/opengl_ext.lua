if not gl then
	return
end
function gl.createVAO()
	local _ENV, retTable
	retTable.buffer_id = gl._createVAO()
	return retTable
end
function gl.deleteVAO(buffer)
	local buffer_id = 0
	if "number" == type(buffer) then
		buffer_id = buffer
	elseif "table" == type(buffer) then
		buffer_id = buffer.buffer_id
	end
	gl._deleteVAO(buffer_id)
end
function gl.bindVAO(buffer)
	local buffer_id = 0
	if "number" == type(buffer) then
		buffer_id = buffer
	elseif "table" == type(buffer) then
		buffer_id = buffer.buffer_id
	end
	if gl._bindVAO then
		gl._bindVAO(buffer_id)
	end
end
function gl.isVAOSupported()
	if not gl._isVAOSupported then
		return false
	end
	return gl._isVAOSupported()
end
