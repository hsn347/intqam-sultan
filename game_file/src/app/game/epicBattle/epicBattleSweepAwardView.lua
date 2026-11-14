local gametop = gModuleMgr.getObject("gametop")
local activityShowCtrl = gametop.playertop_:getModule("activityShowCtrl")
local epicWarltCtrl = include("epicWarltCtrl")
local publicRead = include("publicRead")
local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local epicBattleSweepAwardView = class("epicBattleSweepAwardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("epicBattleSweepAwardView")
	end
	return target
end)
function epicBattleSweepAwardView:ctor()
	self.data, _ENV, self.scaleActTarget = SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node"), SoraDGetChildByName(self, "Center_Node")
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("epicbattle_btn_01"))
	self.Image_level = SoraDGetChildByName(self, "Image_level")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Text_costAction = SoraDGetChildByName(self, "Text_costAction")
	self.scroll = SoraDGetChildByName(self, "ScrollView_item")
	self.Button_ok = SoraDGetChildByName(self, "Button_ok")
	self.Button_ok:setTitleText(i18n("common_text_204"))
	self.Button_ok:addTouchEventListener(handler(self, self.btnOKClick))
end
function epicBattleSweepAwardView:initData(data, reward, times)
	self.data = data
	dump()
	self.Image_level:loadTexture(epicWarltCtrl.getChapterBg(self.data.chapter), ccui.TextureResType.plistType)
	_ENV = nil
	;(nil).firstnum = self.data.chapter
	;(nil).nextnum = self.data.index
	self.Text_name:setString(i18n("epicbattle_text_05", nil) .. "   " .. self.data.name)
	local sweepAction = SWEEP_COST_ACTION * (times or 1)
	self.Text_costAction:setString(i18n("epicbattle_text_09") .. sweepAction)
	self.awardData = reward
	local scrollH = math.max(self.scroll:getContentSize().height, 100 * math.ceil(#self.awardData / 5))
	self.scroll:setInnerContainerSize(cc.size(self.scroll:getContentSize().width, scrollH))
	local multiple = activityShowCtrl:getEpicCommandMultiple()
	for k, v in ipairs(self.awardData) do
		local line = math.ceil(k / 5)
		local row = k % 5 == 0 and 5 or k % 5
		local itemAward = include("commonItemAward").new()
		itemAward:setScale(0.8)
		itemAward:setOwnView(self)
		itemAward:initData(v.id, v.count)
		if backpackltCtrl:getItemType(v.id) == gItemType.LEADER_POINT and 1 < multiple then
			itemAward:setUpVisible(true)
		end
		itemAward:setBaseScale(1.0)
		itemAward:setPosition(50 + (row - 1) * 100, scrollH - line * 100 + 50)
		itemAward:addTo(self.scroll)
	end
end
function epicBattleSweepAwardView:btnOKClick(button, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self:close(button, event)
	end
end
function epicBattleSweepAwardView:onExitPanel()
	SoraDMailGainItems(self.awardData, true)
end
return epicBattleSweepAwardView
