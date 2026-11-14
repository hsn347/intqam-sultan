pyramidData, _ENV = nil, nil
pyramidData.isOneKey = false
function pyramidData:cleanAll()
	self.isOneKey = false
end
function pyramidData:getIsOneKey()
	return self.isOneKey
end
function pyramidData:setIsOneKey(value)
	self.isOneKey = value
end
return pyramidData
