local divineBeastCtrl = SoraDGetCtrl("divineBeastCtrl")
local divineBeastRead = include("divineBeastRead")
local baseComponent = require("fgui.base.baseComponent")
local heroSelectDivinebeast = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://CommonNew/heroSelectDivinebeast", heroSelectDivinebeast)
function heroSelectDivinebeast:onInit()
	self.divineID = 0
	self.stars, _ENV, self.myMode = gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner, gHeroSelectBannerStyle.inner
	self.fields.Text_divinebeast:setString(i18n("Divine_beast_text_02"))
	self.fields.text_inWar:setString(i18n("formation_hero_notInCity_name"))
	self.fields.Button_remove:setVisible(false)
	self.fields.Button_remove:addClickListener(handler(self, self.btnRemoveClick))
	self:addClickListener(handler(self, self.btnAddCallBack))
	self.fields.Text_db_lv:fixPos()
	self.fields.Button_remove:fixPos()
	self.fields.star:fixPos()
	self.fields.starLv:fixPos()
end
function heroSelectDivinebeast:registerEvent()
	SoraDAddMessage(self, "MESSAGE_SERVER_DIVINEBEAST_SELECT", handler(self, self.selectBack))
end
function heroSelectDivinebeast:onShow()
end
function heroSelectDivinebeast:selectBack(target, data)
	self.divineID = data.divineID or 0
	self:updateView()
end
function heroSelectDivinebeast:getDivineBeastInfo()
	_UPVALUE1_ = nil
	;(nil)[1] = self.divineID
	return nil
end
function heroSelectDivinebeast:refreshPanel(data, mode)
	self.divineID = data[1] and data[1] or 0
	self.myMode = mode
	self:updateView()
end
function heroSelectDivinebeast:updateView()
	local isInWar = false
	if self.divineID > 0 then
		self.controllers.c1:setSelectedIndex(1)
		self.divineBeastData = divineBeastCtrl:getBeastData(self.divineID)
		if not self.divineBeastData then
			return
		end
		isInWar = (self.myMode == gHeroSelectBannerStyle.defend or self.myMode == gHeroSelectBannerStyle.dispatch) and (self.divineBeastData.state == DIVINE_BEAST_STATE.ATTACK or self.divineBeastData.state == DIVINE_BEAST_STATE.ATTACK_DEFEND)
		divineBeastCtrl = nil
		;(nil).num = self.divineBeastData.stepLv or 0
		self.fields.Text_db_lv:setString(i18n("Divine_beast_text_66", nil))
		self.fields.Sprite_divinebeast:setSpriteFrame(divineBeastRead.getIcon(self.divineID))
		local starLv = self.divineBeastData.starLv or 0
		self.fields.starLv:setString("" .. starLv)
	else
		self.controllers.c1:setSelectedIndex(0)
	end
	self.controllers.c2:setSelectedIndex(isInWar and 1 or 0)
end
function heroSelectDivinebeast:btnAddCallBack()
	SoraDPlaySound()
	_ENV = nil
	;(nil).divineID = self.divineID
	;(nil).mode = self.myMode
	uiManager:show("MythicalCreaturesDispatch", nil)
end
function heroSelectDivinebeast:btnRemoveClick()
	SoraDPlaySound()
	self.divineID = 0
	_ENV = nil
	;(nil).msg = "MESSAGE_SERVER_DIVINEBEAST_SELECT"
	;(nil).divineID = 0
	SoraDSendMessage(nil)
end
return heroSelectDivinebeast
