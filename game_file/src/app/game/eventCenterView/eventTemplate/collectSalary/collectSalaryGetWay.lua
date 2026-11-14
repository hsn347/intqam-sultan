local itemDesRead = include("itemDesRead")
local jumpDesRead = include("jumpDesRead")
local collectSalaryGetWay = class("collectSalaryGetWay", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("collectSalaryGetWay")
	end
	return target
end)
local itemId = 826501
function collectSalaryGetWay:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox")
	self.ccs_bg:setTitleName(i18n("common_text_4342"))
	self.singleNode = SoraDGetChildByName(self, "Node_Single")
	self.scroll = SoraDGetChildByName(self, "ScrollView")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCreate(handler(self, self.createSingleNode))
	self.scroll:setSingleRefresh(handler(self, self.refreshSingleNode))
	local data = itemDesRead.getOutput(itemId)
	local _ENV, infoData = itemId, itemId
	for i, v in ipairs(data) do
		local tmp = jumpDesRead.getCfg(v)
		table.insert(infoData, tmp)
	end
	self.scroll:updateScrollView(cc.size(533, 130), infoData, 1)
end
function collectSalaryGetWay:createSingleNode()
	local single = self.singleNode:clone()
	return single
end
function collectSalaryGetWay:refreshSingleNode(target, data, otherData)
	local button = SoraDGetChildByName(target, "Button_Go")
	local textName = SoraDGetChildByName(target, "Text_WayName")
	local icon = SoraDGetChildByName(target, "Image_Icon")
	dump(data, "data=--collectSalaryGetWay", 10)
	textName:setString(i18n(data.des))
	SoraDGetAutoHeightLabel(textName, 200)
	button:setTitleText(i18n("common_text_477"))
	icon:loadTexture(data.icon, ccui.TextureResType.plistType)
	button:setTag(data.sourceid)
	if data.sourceid == 29 then
		icon:setScale(0.85)
	end
	button:addTouchEventListener(handler(self, self.btnClickJump))
end
function collectSalaryGetWay:btnClickJump(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local sourceId = button:getTag()
		if SoraDJumpBySourceId(sourceId) then
			self:closePanel()
		end
	end
end
return collectSalaryGetWay
