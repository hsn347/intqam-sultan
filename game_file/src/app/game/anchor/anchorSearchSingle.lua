local anchorSearchSingle = class("anchorSearchSingle", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("anchorSearchSingle")
	end
	return target
end)
function anchorSearchSingle:ctor()
	self.nodeScore = SoraDGetExtendChildFromCCSByName(self, "CCS_anchorSearchBase_title")
	self.btnDetail = SoraDGetChildByName(self, "Button_detail")
	self.btnLook = SoraDGetChildByName(self, "Button_look")
	self.btnDetail:addTouchEventListener(handler(self, self.onClickDetail))
	self.btnLook:addTouchEventListener(handler(self, self.onClickLook))
	self.btnDetail:setTitleText(i18n("common_text_059"))
	self.spAccurateSearch = SoraDGetChildByName(self, "Sprite_Accurate_Search")
end
function anchorSearchSingle:initData(data, otherData)
	self.data = data
	self.nodeScore:updateAnchorData(data)
	self.spAccurateSearch:setVisible(data.isAccurateSearch)
end
function anchorSearchSingle:onClickDetail(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local panel = SoraDCreatePanel("anchorTeamInfo")
		panel:initView(self.data)
		panel:show()
	end
end
function anchorSearchSingle:onClickLook(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		local mapID = self.data.mapId
		if mapID and 0 < mapID then
			local anchorUtil = include("anchorUtil")
			anchorUtil.selectWatchMap(mapID)
		end
	end
end
return anchorSearchSingle
