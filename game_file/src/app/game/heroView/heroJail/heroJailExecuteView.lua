local gametop = gModuleMgr.getObject("gametop")
local backpackCtrl = gametop.playertop_:getModule("backpackCtrl")
local constantRead = include("constantRead")
local heroJailExecuteView = class("heroJailExecuteView", function()
	return SoraDCreateTouchPanel("heroJailExecuteView")
end)
function heroJailExecuteView:ctor()
	self.isShare = nil
	self.Button_yes = SoraDGetChildByName(self, "Button_yes")
	self.Text_msg = SoraDGetChildByName(self, "Text_msg")
	self.Text_msg:setString(i18n("killHero_sure_desc"))
	self.CheckBox_share_world = SoraDGetChildByName(self, "CheckBox_share_world")
	self.CheckBox_share_kingdom = SoraDGetChildByName(self, "CheckBox_share_kingdom")
	self.Text_share_world = SoraDGetChildByName(self, "Text_share_world")
	self.Text_share_kingdom = SoraDGetChildByName(self, "Text_share_kingdom")
	self.Text_confirm = SoraDGetChildByName(self, "Text_confirm")
	self.Text_name = SoraDGetChildByName(self, "Text_name")
	self.Node_gold = SoraDGetChildByName(self, "Node_gold")
	self.Text_gold = SoraDGetChildByName(self, "Text_gold")
	self.iconHorn = SoraDGetChildByName(self, "icon")
	self.Text_name:setString(i18n("killHero_title"))
	self.CheckBox_share_world:addEventListener(handler(self, self.btnShareWorldClick))
	self.CheckBox_share_world:setSelected(false)
	self.CheckBox_share_kingdom:addEventListener(handler(self, self.btnShareKingdomClick))
	self.CheckBox_share_kingdom:setSelected(false)
	self.Button_yes:setTitleText(i18n("common_text_204"))
	self.Button_yes:addTouchEventListener(handler(self, self.onBtnYesClick))
	self.Text_share_world:setString(i18n("common_text_1486"))
	self.Text_share_kingdom:setString(i18n("killHero_shareToAnnouncement_name"))
	self.Text_confirm:setString(i18n("common_text_204"))
	self.worldShareCost = constantRead.getConstValue("HERO_KILL_SHARE_KINGDOMCHAT_GOLD")
	self.kingdomShareCost = constantRead.getConstValue("HERO_KILL_SHARE_ANNOUNCEMENT_GOLD")
	print("skdlfjsdlkjfsldkjf", self.worldShareCost, self.kingdomShareCost)
	self:updateBtnState()
end
function heroJailExecuteView:setShareVisible(ret)
	self.CheckBox_share_world:setVisible(ret or false)
	self.CheckBox_share_kingdom:setVisible(ret or false)
end
function heroJailExecuteView:setHandle(handle)
	self.handle = handle
end
function heroJailExecuteView:btnShareWorldClick(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self.isShare = 1
		self.CheckBox_share_kingdom:setSelected(false)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		self.isShare = nil
	end
	self:updateBtnState()
end
function heroJailExecuteView:btnShareKingdomClick(button, event)
	if event == ccui.CheckBoxEventType.selected then
		SoraDPlaySound()
		self.isShare = 2
		self.CheckBox_share_world:setSelected(false)
	elseif event == ccui.CheckBoxEventType.unselected then
		SoraDPlaySound()
		self.isShare = nil
	end
	self:updateBtnState()
end
function heroJailExecuteView:updateBtnState()
	self.Node_gold:setVisible(self.isShare == 1 or self.isShare == 2)
	self.Text_confirm:setVisible(self.isShare == 1 or self.isShare == 2)
	self.Button_yes:setTitleText(self.isShare == nil and i18n("common_text_204") or "")
	local hornCount = backpackCtrl:getItemCount(502001)
	self.iconHorn:loadTexture("icon_small_gold.png", ccui.TextureResType.plistType)
	if self.isShare == 1 then
		self.Text_gold:setString(self.worldShareCost)
	elseif self.isShare == 2 then
		if 0 < hornCount then
			self.iconHorn:loadTexture("5020.png", ccui.TextureResType.plistType)
			self.Text_gold:setString(1)
		else
			self.Text_gold:setString(self.kingdomShareCost)
		end
	end
	SoraDToCenter(self.Node_gold)
end
function heroJailExecuteView:onBtnYesClick(button, event)
	if event == ccui.TouchEventType.ended then
		if self.handle then
			self.handle(self.isShare)
		end
		self:removeFromParent()
	end
end
return heroJailExecuteView
