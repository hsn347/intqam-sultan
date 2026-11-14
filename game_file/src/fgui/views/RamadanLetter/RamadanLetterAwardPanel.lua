local baseFguiPanel = require("fgui.base.baseFguiPanel")
local RamadanLetterAwardPanel = class("RamadanLetterAwardPanel", baseFguiPanel)
local ramadanLetterCtrl = SoraDGetCtrl("ramadanLetterCtrl")
local ramadanLetterRead = include("ramadanLetterRead")
function RamadanLetterAwardPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
	print("RamadanLetterAwardPanel:ctor", self.viewName)
end
function RamadanLetterAwardPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function RamadanLetterAwardPanel:onInit()
	print("=======RamadanLetterAwardPanel:onInit")
	self.isAddToPopManager = true
	if not self.proxy.param then
		_ENV = self.proxy.param
	end
	self.param = self.proxy.param
	self.showAction = self.param.showAction
	self.cfg = ramadanLetterRead.getLetterCfg(self.param.chapter)
	_ENV = nil
	;(nil).item = self.param.chapter
	self.fields.Text_Title:setString(i18n("ramadan_letter_01", nil))
	self.fields.Scroll_award:setItemRenderer(handler(self, self.onItemRenderer))
	self.fields.button_reward:addClickEventListener(handler(self, self.onClickSure))
	self.fields.button_open_letter:addClickEventListener(handler(self, self.onClickOpenLetter))
	self.fields.button_letter:addClickEventListener(handler(self, self.onClickLetter))
end
function RamadanLetterAwardPanel:onShow()
	print("=======RamadanLetterAwardPanel:onShow")
	self.isHaveReward = ramadanLetterCtrl:getIsHaveReward(self.param.chapter)
	self.isCanGetReward = ramadanLetterCtrl:getCurChapter() >= self.param.chapter
	self.controllers.c2:setSelectedIndex(self.showAction and 1 or 0)
	if self.showAction then
		self.fields.Usm_2:setCompleteCallback(handler(self, self.showActionEnd))
		self.fields.Usm_2:setVisible(true)
		self.fields.Usm_2:setEffectPath("xfjr.usm", false)
	else
		self:showReward()
	end
end
function RamadanLetterAwardPanel:onHide()
	print("=======RamadanLetterAwardPanel:onHide")
end
function RamadanLetterAwardPanel:onDispose()
	print("=======RamadanLetterAwardPanel:onDispose")
end
function RamadanLetterAwardPanel:showReward()
	self.controllers.c2:setSelectedIndex(0)
	_UPVALUE2_ = 0
	;(0)[1] = "id"
	;(0)[2] = "count"
	self.awards = serviceFunctions.tableFormat(self.cfg.gift, 0)
	self.fields.Scroll_award:setNumItems(#self.awards)
	if self.isHaveReward and self.isCanGetReward then
		self.fields.Text_Status:setVisible(false)
		self.fields.button_reward:setVisible(true)
		self.fields.button_reward:setTitle(i18n("common_text_204"))
	else
		_ENV = i18n("common_text_204")
		i18n("common_text_204").item = self.param.chapter
		self.fields.Text_Title:setString(i18n("ramadan_letter_05", i18n("common_text_204")))
		self.fields.button_reward:setVisible(false)
		self.fields.Text_Status:setVisible(true)
		if not self.isCanGetReward then
			self.fields.Text_Status:setString(i18n("ramadan_letter_06"))
		else
			self.fields.Text_Status:setString(i18n("common_text_1892"))
		end
	end
end
function RamadanLetterAwardPanel:showActionEnd()
	self.fields.Usm_1:setVisible(true)
	self.fields.Usm_1.effect:setOpacity(0)
	self.fields.Usm_1.effect:runAction(cca.fadeIn(0.2))
	self.fields.button_open_letter:setVisible(true)
	self.controllers.c2:setSelectedIndex(1)
end
function RamadanLetterAwardPanel:onItemRenderer(index, object)
	object:initData(self.awards[index + 1].id, self.awards[index + 1].count)
end
function RamadanLetterAwardPanel:onClickSure()
	SoraDPlaySound()
	if self.isHaveReward and self.isCanGetReward then
		ramadanLetterCtrl:sendReceiveMsg(self.cfg.chapter)
	end
	if self.showAction then
		_ENV = nil
		;(nil).cfg = self.cfg
		uiManager:show("RamadanLettetDetail", nil)
	end
	self:close()
end
function RamadanLetterAwardPanel:onClickOpenLetter()
	self.fields.Usm_1:setVisible(false)
	self.fields.Usm_2:setCompleteCallback(function()
		self.fields.black_bg:runAction(ffa.seq(ffa.fadeOut(0.1)))
		self.controllers.c2:setSelectedIndex(2)
		local text_detials = fguiHelper.get_fields(self.fields.letter_details).text_detials
		self = ffa.seq(ffa.fadeOut(0.1))
		ffa.seq(ffa.fadeOut(0.1)).item = self.cfg.chapter
		fguiHelper.get_fields(self.fields.letter_details).Text_title:setString(i18n("ramadan_letter_02", ffa.seq(ffa.fadeOut(0.1))))
		text_detials:setString(i18n(self.cfg.letter))
		text_detials:setAlpha(0)
		self.fields.button_letter:setVisible(false)
		text_detials:runAction(ffa.seq(ffa.fadeIn(0.1), ffa.callFunc(function()
			self.fields.button_letter:setVisible(true)
		end)))
	end)
	self.fields.Usm_2:setVisible(true)
	self.fields.Usm_2:setEffectPath("xftc.usm", false)
end
function RamadanLetterAwardPanel:onClickLetter()
	if self.isHaveReward then
		self.fields.Usm_2:setVisible(false)
		self:showReward()
	else
		_ENV = nil
		;(nil).cfg = self.cfg
		uiManager:show("RamadanLettetDetail", nil)
		self:close()
	end
end
return RamadanLetterAwardPanel
