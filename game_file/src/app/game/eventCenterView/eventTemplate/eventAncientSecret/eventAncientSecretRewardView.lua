local gametop = gModuleMgr.getObject("gametop")
local ancientTreasureCtrl = gametop.playertop_:getModule("ancientTreasureCtrl")
local eventAncientSecretRewardView = class("eventAncientSecretRewardView", function(target)
	if target == nil then
		return SoraDCreateTouchPanel("eventAncientSecretRewardView")
	end
	return target
end)
function eventAncientSecretRewardView:ctor()
	self.isInit = false
	self.tag = 1
	SoraDGetAllChildFromWidget(self, self)
	self.ccs_bg = SoraDGetExtendChildFromCCSByName(self, "CCS_commonPopBox_bg")
	self.ccs_bg:setTitleName(i18n("AncienTreasure_text_56"))
	self.ScrollView_list = include("commonAutoScrollList").new(self.ScrollView_list)
	self.ScrollView_list:setSingleCCS("eventAncientSecretRewardSingle")
	self.Text_none:setVisible(false)
	self.ccs_tab = SoraDGetExtendChildFromCCSByName(self, "CCS_commonTabBtnEX_tab")
	self.ccs_tab:setContentSize(cc.size(534, 56))
	self.ccs_tab:setChoosePng("btn_secondarybtn_long_01.png")
	self.ccs_tab:setUnChoosePng("btn_secondarybtn_long_02.png")
	ancientTreasureCtrl:sendReqInitDataMsg()
end
function eventAncientSecretRewardView:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_ANCIENT_TREASURE_UPDATE", handler(self, self.initData))
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
end
function eventAncientSecretRewardView:judgeClose()
	if not clientEventMgr.judgeIsOpen(gActivityTimeActivityID.ANCIENT_TREASURE_ACTIVITY) then
		self:removeFromParent()
	end
end
function eventAncientSecretRewardView:initData(target, data)
	if not self.isInit then
		_ENV = nil
		_ENV, _ENV, (nil).tabNum = nil, nil, 2
		;(nil).title = i18n("AncienTreasure_text_57")
		_ENV, (nil)[1], (nil).handle = nil, nil, handler(self, self.onTagClick)
		;(nil).title = i18n("AncienTreasure_text_58")
		;(nil).tabsetArray, (nil)[2], (nil).handle = nil, nil, handler(self, self.onTagClick)
		self.ccs_tab:initView(nil)
		self.isInit = true
	else
		self:onTagClick(self.tag)
	end
end
function eventAncientSecretRewardView:onTagClick(tag)
	self.tag = tag
	local ancientTreasureCtrl, dataList
	self.Text_none:setVisible(false)
	if tag == 1 then
		dataList = ancientTreasureCtrl:getATUnExploreList()
		if not next(dataList) then
			self.Text_none:setVisible(true)
			self.Text_none:setString(i18n("AncienTreasure_text_63"))
		end
	else
		dataList = ancientTreasureCtrl:getATExploredList()
		if not next(dataList) then
			self.Text_none:setVisible(true)
			self.Text_none:setString(i18n("AncienTreasure_text_64"))
		end
	end
	ancientTreasureCtrl = i18n("AncienTreasure_text_64")
	i18n("AncienTreasure_text_64").view = self
	self.ScrollView_list:updateScrollView(cc.size(536, 150), dataList, 1, i18n("AncienTreasure_text_64"))
end
return eventAncientSecretRewardView
