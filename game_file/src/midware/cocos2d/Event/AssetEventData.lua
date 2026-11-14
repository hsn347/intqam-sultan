local AssetEventData = class("AssetEventData")
function AssetEventData:create()
	return self.new()
end
function AssetEventData:getEventCode()
	return 0
end
function AssetEventData:getAssetId()
	return 0
end
function AssetEventData:getPercent()
	return 0
end
return AssetEventData
