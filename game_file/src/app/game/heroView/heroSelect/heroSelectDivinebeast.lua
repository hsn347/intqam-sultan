local gametop = gModuleMgr.getObject("gametop")
local godArmsCtrl = gametop.playertop_:getModule("godArmsCtrl")
local equipDesRead = include("equipDesRead")
local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local divineBeastRead = include("divineBeastRead")
local heroSelectDivinebeast = class("heroSelectDivinebeast", function(target)
	if target == nil then
		return SoraDCreateBasePanel("heroSelectDivinebeast")
	end
	return target
end)
function heroSelectDivinebeast:ctor()
	self.divineID = 0
	self.myMode = gHeroSelectBannerStyle.inner
	self.speireIcon = SoraDGetChildByName(self, "Sprite_divinebeast")
	self.btnAdd = SoraDGetChildByName(self, "Button_add")
	self.spAdd = SoraDGetChildByName(self, "Sprite_add")
	self.txtStepLv = SoraDGetChildByName(self, "Text_db_lv")
	self.txtStarLv = SoraDGetChildByName(self, "Text_star_lv")
	self.btnRemove = SoraDGetChildByName(self, "Button_remove")
	self.btnRemove:addTouchEventListener(handler(self, self.btnRemoveClick))
	self.btnAdd:addTouchEventListener(handler(self, self.btnAddCallBack))
	self.starBg = SoraDGetChildByName(self, "frame_dbname_bg")
	self.txtDes = SoraDGetChildByName(self, "Text_divinebeast")
	self.txtDes:setString(i18n("Divine_beast_text_02"))
	self.spInWarBg = SoraDGetChildByName(self, "frame_lmrfd_hszz")
	self.spInWarBg:setVisible(false)
	self.txtInWar = SoraDGetChildByName(self, "text_inWar")
	self.txtInWar:setVisible(false)
	self.txtInWar:setString(i18n("formation_hero_notInCity_name"))
	self.Image_shadow = SoraDGetChildByName(self, "Image_shadow")
	self.Image_shadow:setVisible(false)
	self.star = SoraDGetChildByName(self, "Sprite_star")
end
function heroSelectDivinebeast:onMessageListener()
	SoraDAddMessage(self, "MESSAGE_SERVER_DIVINEBEAST_SELECT", handler(self, self.selectBack))
end
function heroSelectDivinebeast:selectBack(target, data)
	self.divineID = data.divineID or 0
	_UPVALUE2_ = nil
	;(nil)[1] = self.divineID
	;(nil)[2] = data
	dump(nil, "heroSelectDivinebeast:selectBack")
	self:updateView()
end
function heroSelectDivinebeast:getDivineBeastInfo()
	_UPVALUE1_ = nil
	;(nil)[1] = self.divineID
	return nil
end
function heroSelectDivinebeast:refreshPanel(data, mode)
	dump(data, "self.divineID ")
	self.divineID = data[1] and data[1] or 0
	self.myMode = mode
	dump(self.divineID, "heroSelectDivinebeast:refreshPanel ")
	self:updateView()
end
function heroSelectDivinebeast:updateView(...)
	local isInWar = false
	if self.divineID > 0 then
		self.divineBeastData = divineBeastCtrl:getBeastData(self.divineID)
		isInWar = (self.myMode == gHeroSelectBannerStyle.defend or self.myMode == gHeroSelectBannerStyle.dispatch) and (self.divineBeastData.state == DIVINE_BEAST_STATE.ATTACK or self.divineBeastData.state == DIVINE_BEAST_STATE.ATTACK_DEFEND)
		self.spAdd:setVisible(false)
		self.btnRemove:setVisible(true)
		self.txtStepLv:setVisible(true)
		self.txtStarLv:setVisible(true)
		self.star:setVisible(true)
		divineBeastCtrl = nil
		;(nil).num = self.divineBeastData.stepLv or 0
		self.txtStepLv:setString(i18n("Divine_beast_text_66", nil))
		self.txtStarLv:setString("" .. self.divineBeastData.starLv or 0)
		self.speireIcon:setSpriteFrame(divineBeastRead.getIcon(self.divineID))
		self.speireIcon:setVisible(true)
		self.txtDes:setVisible(false)
	else
		self.spAdd:setVisible(true)
		self.btnRemove:setVisible(false)
		self.speireIcon:setVisible(false)
		self.txtStepLv:setVisible(false)
		self.txtStarLv:setVisible(false)
		self.star:setVisible(false)
		self.txtDes:setVisible(true)
	end
	self.spInWarBg:setVisible(isInWar)
	self.txtInWar:setVisible(isInWar)
	self.Image_shadow:setVisible(isInWar)
end
function heroSelectDivinebeast:btnAddCallBack(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		_ENV = nil
		;(nil).divineID = self.divineID
		;(nil).mode = self.myMode
		uiManager:show("MythicalCreaturesDispatch", nil)
	end
end
function heroSelectDivinebeast:btnRemoveClick(button, type)
	if type == ccui.TouchEventType.ended then
		SoraDPlaySound()
		self.divineID = 0
		_ENV = nil
		;(nil).msg = "MESSAGE_SERVER_DIVINEBEAST_SELECT"
		;(nil).divineID = 0
		SoraDSendMessage(nil)
	end
end
return heroSelectDivinebeast
