local petraRareTreasureActivity = class("petraRareTreasureActivity", function(target)
	if target == nil then
		target = SoraDCreateBasePanel("petraRareTreasureActivity")
	end
	local royalSummonsTab = include("royalSummonsTab")
	target = royalSummonsTab.new(target)
	return target
end)
_ENV = "petraRareTreasureActivity"
;("petraRareTreasureActivity").MAIN_VIEW_TYPE_MAIN = 1
local ("petraRareTreasureActivity").MAIN_VIEW_TYPE_SHOP, MAIN_VIEW_TYPE = 2, "petraRareTreasureActivity"
function petraRareTreasureActivity:ctor()
	self.isHideCurrentSceneView = true
	self.title = SoraDGetExtendChildFromCCSByName(self, "CCS_commonFramTitle_title")
	self.title:setTitle(i18n("activity_name_20"))
	self.btnHelp = SoraDGetChildByName(self, "Button_help")
	self.nodeTop = SoraDGetChildByName(self, "Top_Node")
	_ENV, self.btnShop = SoraDGetChildByName(self, "Button_Shop"), SoraDGetChildByName(self, "Button_Shop")
	_ENV = "Button_Shop"
	;("Button_Shop").title = "Button_Main"
	SoraDGetChildByName(self, "Button_Shop")[MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_MAIN], ("Button_Shop").titleText = "Button_Shop", "petra_title_01"
	_ENV = "Button_Shop"
	;("Button_Shop").title = "Button_Shop"
	SoraDGetChildByName(self, "Button_Shop")[MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP], ("Button_Shop").titleText = "Button_Shop", "petra_title_02"
	local tableData = SoraDGetChildByName(self, "Button_Shop")
	self:initTabData(tableData)
	self:initShowBtn(MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_MAIN)
	self.btnHelp:addTouchEventListener(handler(self, self.onClickHelp))
end
function petraRareTreasureActivity:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_EVENTCENTER_COMMONEVENT_REFRESH", handler(self, self.judgeClose))
	SoraDAddMessage(self, "MESSAGE_SERVER_PETRA_RARE_TREASURE_SHOP_GUIDE", handler(self, self.checkShowFinger))
end
function petraRareTreasureActivity:createPanel(showViewType)
	local panel
	if showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_MAIN then
		panel = SoraDCreatePanelByFixName("petraRareTreasureMainView")
		panel:setPosition(SoraDFPoint(0, 810, 0))
		panel:addTo(self.nodeTop, -1)
		panel:init()
	elseif showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP then
		panel = SoraDCreatePanelByFixName("petraRareTreasureShopView")
		panel:setPosition(SoraDFPoint(0, 820, 0))
		panel:addTo(self.nodeTop, -3)
		panel:init()
	end
	return panel
end
function petraRareTreasureActivity:onClickHelp(sender, event)
	if event == ccui.TouchEventType.ended then
		SoraDPlaySound()
		SoraDShowHelpMsgTip(i18n("petra_text_01"))
	end
end
function petraRareTreasureActivity:judgeClose()
	if not _G.clientEventMgr.judgeIsOpen(gActivityTimeActivityID.PETRA_RARE_TREASURE) then
		self:removeFromParent()
	end
end
function petraRareTreasureActivity:initShowBtn_post()
	if self.showViewType == MAIN_VIEW_TYPE.MAIN_VIEW_TYPE_SHOP and self.hasGuideView then
		local spriteHand = SoraDGetChildByName(self, "animationFinger")
		if spriteHand then
			spriteHand:stopAllActions()
			spriteHand:removeFromParent()
			self.hasGuideView = false
		end
	end
end
function petraRareTreasureActivity:checkShowFinger()
	if self.guide then
		return
	end
	_ENV = nil
	;(nil).byUID = true
	if not SoraDConfigGet("Game:petraRareTreasureActivity:Guide~bool", nil) then
		_ENV = nil
		;(nil).byUID = true
		SoraDConfigSet("Game:petraRareTreasureActivity:Guide~bool", true, nil)
		self:openGuide()
	else
		self.guide = true
	end
end
function petraRareTreasureActivity:openGuide()
	if self.guide then
		return
	end
	self.guide = true
	self.hasGuideView = true
	self:showFinger()
end
function petraRareTreasureActivity:showFinger()
	local pos = cc.p(160, 32)
	pos = SoraDCoverToPoint(self.btnShop, pos, self)
	local spriteHand = SoraDFingerAction(false, false, 10)
	spriteHand:setPosition(pos)
	spriteHand:setName("animationFinger")
	spriteHand:addTo(self, 99)
end
return petraRareTreasureActivity
