local itemDesRead = include("itemDesRead")
local equipDesRead = include("equipDesRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local StorageBoxResolveSingle = class("storageBoxResolveSingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("storageBoxResolveSingle")
	end
	return target
end)
function StorageBoxResolveSingle:ctor()
	self.tableSingleData, _ENV = nil, nil
	self.materialSingle = SoraDGetExtendChildFromCCSByName(self, "CCS_materialSingle_single")
	self.labelNum = SoraDGetChildByName(self, "Text_num")
	self.labelName = SoraDGetChildByName(self, "Text_name")
end
function StorageBoxResolveSingle:initData(mData)
	self.tableSingleData = mData
	self.labelName:setString(itemDesRead.getName(self.tableSingleData.id))
	local quality = backpackltCtrl:getItemQuality(self.tableSingleData.id)
	self.labelName:setColor(equipDesRead.getAttrColor(quality))
	self.labelNum:setString("+" .. self.tableSingleData.count)
	self.materialSingle:initData(self.tableSingleData.id)
end
return StorageBoxResolveSingle
