local publicRead = include("publicRead")
local armyChangeRead = include("armyChangeRead")
local basePanel = require("fgui.base.baseFguiPanel")
local chosseGemItemPanel = class("chosseGemItemPanel", basePanel)
function chosseGemItemPanel:ctor(...)
	self.super.ctor(self, ...)
	self.debug = true
end
function chosseGemItemPanel:getPackageList()
	if not self._packageList then
		_UPVALUE4_ = self._packageList
		self._packageList, self._packageList[1] = self._packageList, "TroopsChange"
		self._packageList, self._packageList[2] = self._packageList, "CommonNew"
		self._packageList, self._packageList[3] = self._packageList, "CommonUI0"
		self._packageList, self._packageList[4] = self._packageList, "CommonUI1"
	end
	return self._packageList
end
function chosseGemItemPanel:onInit()
	self.fields.Panel_bg:setTitle(i18n("armyExchange_text_028"))
	self.fields.text_Tip:setString(i18n("armyExchange_text_029"))
	self.fields.scroll:setItemRenderer(handler(self, self.onItemRenderer))
end
function chosseGemItemPanel:onShow()
	self.itemsChoose = armyChangeRead.getStoneExchangeInfo(self.param.index).cost2
	self.fields.scroll:setNumItems(#self.itemsChoose)
end
function chosseGemItemPanel:onItemRenderer(index, object)
	object:initData(index + 1, self.itemsChoose[index + 1])
	object:setHandle(handler(self, self.chooseBack))
end
function chosseGemItemPanel:chooseBack(index)
	SoraDPlaySound()
	_ENV = nil
	;(nil).name = publicRead.getName(self.itemsChoose[index].id)
	;(nil).num = self.itemsChoose[index].count
	SoraDShowMsgBox(i18n("armyExchange_text_030", nil), i18n("common_text_204"), nil, function(callBack)
		if callBack == MSGBOX_CALLBACK_YES then
			SoraDPlaySound()
			if self.param.handler then
				self.param.handler(index)
			end
			self:close()
		end
	end)
end
return chosseGemItemPanel
