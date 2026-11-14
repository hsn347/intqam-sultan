local gametop = gModuleMgr.getObject("gametop")
local luxuryRebateCtrl = gametop.playertop_:getModule("luxuryRebateCtrl")
local scrollNode = include("scrollNode")
local luxuryRebateActivitySingle = class("luxuryRebateActivitySingle", function(target)
	if target == nil then
		return SoraDCreateBasePanel("luxuryRebateActivitySingle")
	end
	return target
end)
local luxuryRebateDef = include("luxuryRebateDef")
local DAY_STATUES = luxuryRebateDef.DAY_STATUES
function luxuryRebateActivitySingle:ctor()
	self.txtAwardValue = SoraDGetChildByName(self, "Text_award_value")
	self.btnGo = SoraDGetChildByName(self, "Button_go")
	self.txtGo = SoraDGetChildByName(self, "Text_go")
	self.txtComplete = SoraDGetChildByName(self, "Text_complete")
	self.txtEnd = SoraDGetChildByName(self, "Text_end")
	self.txtUnOpen = SoraDGetChildByName(self, "Text_unopen")
	self.nodeDo = SoraDGetChildByName(self, "Node_do")
	self.nodeComplete = SoraDGetChildByName(self, "Node_complete")
	self.nodeEnd = SoraDGetChildByName(self, "Node_end")
	_UPVALUE4_, self.nodeUnOpen = SoraDGetChildByName(self, "Node_unopen"), SoraDGetChildByName(self, "Node_unopen")
	self.nodeArray, SoraDGetChildByName(self, "Node_unopen")[1] = SoraDGetChildByName(self, "Node_unopen"), self.nodeDo
	self.nodeArray, SoraDGetChildByName(self, "Node_unopen")[2] = SoraDGetChildByName(self, "Node_unopen"), self.nodeComplete
	self.nodeArray, SoraDGetChildByName(self, "Node_unopen")[3] = SoraDGetChildByName(self, "Node_unopen"), self.nodeEnd
	self.nodeArray, SoraDGetChildByName(self, "Node_unopen")[4] = SoraDGetChildByName(self, "Node_unopen"), self.nodeUnOpen
	self.nodeItemGod = SoraDGetExtendChildFromCCSByName(self, "CCS_luxuryRebateActivityItemSingle_god")
	self.nodeItemNormal = SoraDGetExtendChildFromCCSByName(self, "CCS_luxuryRebateActivityItemSingle_normal")
	self.btnGo:setSwallowTouches(false)
	self.btnGo = scrollNode.new(self.btnGo)
	self.btnGo:addTouchEventListener(handler(self, self.onClickGo))
end
function luxuryRebateActivitySingle:initData(data, otherData)
	self.btnGo:setScroll(otherData.scroll)
	self.cfg = data
	self.otherData = otherData
	self:initView()
end
function luxuryRebateActivitySingle:initView()
	self.daystatue = luxuryRebateCtrl:getLuxuryDayStatus(self.cfg)
	self:initItemView()
	self:initBtnStatus()
end
function luxuryRebateActivitySingle:initItemView()
	self.nodeItemGod:initNormalItem(self.cfg.awardGod, self.otherData)
	self.nodeItemNormal:initNormalItem(self.cfg.awardNormal, self.otherData)
	do
		local statue = luxuryRebateCtrl:getLuxuryAwardStatus(self.cfg, true)
		self.nodeItemGod:setItemStatus(statue, self.daystatue)
	end
	do
		local statue = luxuryRebateCtrl:getLuxuryAwardStatus(self.cfg)
		self.nodeItemNormal:setItemStatus(statue, self.daystatue)
	end
end
local MAX_WIDTH = 150
function luxuryRebateActivitySingle:initBtnStatus()
	local statue = self.daystatue
	SoraDSetNodeArrayVisible(self.nodeArray, false)
	if DAY_STATUES.DAY_STATUES_NORMAL == statue then
		self.nodeDo:setVisible(true)
		self.txtGo:setString(i18n("common_text_477"))
	elseif DAY_STATUES.DAY_STATUES_DONE == statue then
		self.nodeComplete:setVisible(true)
		self.txtComplete:setString(i18n("common_text_2601"))
		DAY_STATUES = i18n("common_text_2601")
		i18n("common_text_2601")[1] = 10
		_G.SoraDAlignNodeArrayOnCenterX(0, self.nodeComplete:getChildren(), SoraDFIsRA(), i18n("common_text_2601"))
	elseif DAY_STATUES.DAY_STATUES_END == statue then
		self.nodeEnd:setVisible(true)
		self.txtEnd:setString(i18n("Anchor_text_21"))
	elseif DAY_STATUES.DAY_STATUES_UNOPEN == statue then
		self.nodeUnOpen:setVisible(true)
		self.txtUnOpen:setString(i18n("common_text_699"))
		SoraDGetAutoHeightLabel(self.txtUnOpen, 140)
	end
	local recharge = luxuryRebateCtrl:getLuxuryRecharge(self.cfg)
	local strRecharge = recharge .. "/$" .. self.cfg.recharge
	self.txtAwardValue:setString(strRecharge)
	local width = self.txtAwardValue:getContentSize().width
	if width > MAX_WIDTH then
		local scale = MAX_WIDTH / width
		self.txtAwardValue:setScale(scale)
	else
		self.txtAwardValue:setScale(1.0)
	end
end
function luxuryRebateActivitySingle:onClickGo(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		if GLOBAL_GAME_RECHARGE_MODE then
			uiManager:show("rechargeView")
		else
			SoraDCreatePanel("rechargeView"):show()
		end
	end
end
return luxuryRebateActivitySingle
