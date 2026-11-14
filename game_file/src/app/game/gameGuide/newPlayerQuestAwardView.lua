local mainUIDef = include("mainUIDef")
local newPlayerQuestAwardView = class("newPlayerQuestAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("newPlayerQuestAwardView")
	end
	return target
end)
function newPlayerQuestAwardView:ctor()
	self.scaleActTarget = SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.imgDownBg = SoraDGetChildByName(self, "Image_1")
	self.txtTip = SoraDGetChildByName(self, "text_tip")
	self.ccs_bg:setTitleName(i18n("hero_title_02"))
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.scroll = include("commonAutoScrollList").new(self.scroll)
	self.scroll:setSingleCCS("commonRankAwardSingle")
	self.Cur_Flag = SoraDGetChildByName(self, "Cur_Flag")
	local text_node = display.newNode()
	text_node:setGroupID(mainUIDef.uiGroupID.group_award_item, true)
	text_node:addTo(self.scroll:getParent(), 12)
	self.scroll:setScrollMoveFun(handler(self, self.scrollMove))
end
function newPlayerQuestAwardView:setTitle(str)
	self.ccs_bg:setTitleName(str or i18n("hero_title_02"))
end
function newPlayerQuestAwardView:setDownTip(str)
	self.imgDownBg:setVisible(true)
	self.txtTip:setString(str or i18n("donate_text_16"))
	self.txtTip:setFontSize(18)
	SoraDSetTextWidthHeight(self.txtTip, cc.size(500, 50))
	self.scroll:setContentSize(cc.size(536, 500))
	self.scroll:setPositionY(self.scroll:getPositionY() + 36)
end
function newPlayerQuestAwardView:initData(data, otherData)
	local singleSize = otherData and otherData.singleSize or cc.size(536, 80)
	_ENV = nil
	;(nil).scroll = self.scroll
	;(nil).view = self
	;(nil).singleSize = singleSize
	;(nil).param = otherData
	self.scroll:updateScrollView(singleSize, data, 1, nil)
	self:setSelectIndex(otherData and otherData.curIdx)
end
function newPlayerQuestAwardView:setSelectIndex(index)
	if index ~= nil and self.Cur_Flag then
		local curChildData = self.scroll.tableSingle[index]
		if curChildData and curChildData.pos and curChildData.pos.y then
			self.Cur_Flag:setLocalZOrder(100)
			self.Cur_Flag:setVisible(true)
			self.Cur_Flag:setContentSize(cc.size(574, 112))
			self.Cur_Flag:setPositionY(curChildData.pos.y + 41)
			local child = self.Cur_Flag:getChildren()[1]
			child:setGroupID(mainUIDef.uiGroupID.group_award_item)
			child:setGroupAuto(true)
			child:setVisible(true)
		end
	else
		self.Cur_Flag:setVisible(false)
	end
end
function newPlayerQuestAwardView:scrollMove()
	if not self.Cur_Flag or not self.Cur_Flag:isVisible() then
		return
	end
	local child = self.Cur_Flag:getChildren()[1]
	local childPos = self.Cur_Flag:convertToWorldSpace(cc.p(child:getPosition()))
	childPos = self.scroll:convertToNodeSpace(childPos)
	if childPos.y >= self.scroll:getContentSize().height + 10 or childPos.y < 20 then
		child:setVisible(false)
	else
		child:setVisible(true)
	end
end
return newPlayerQuestAwardView
