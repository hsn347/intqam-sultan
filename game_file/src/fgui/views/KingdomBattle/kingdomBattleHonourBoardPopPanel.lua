local kingdomCtrl = SoraDGetCtrl("kingdomCtrl")
local baseFguiPanel = require("fgui.base.baseFguiPanel")
local kingdomBattleHonourBoardPopPanel = class("kingdomBattleHonourBoardPopPanel", baseFguiPanel)
function kingdomBattleHonourBoardPopPanel:ctor(...)
	self.super.ctor(self, ...)
	print("kingdomBattleHonourBoardPopPanel:ctor", self.viewName)
end
function kingdomBattleHonourBoardPopPanel:getPackageList()
	if not self._packageList then
		self._packageList, _UPVALUE0_ = self._packageList, self._packageList
	end
	return self._packageList
end
function kingdomBattleHonourBoardPopPanel:onInit()
	print("=======kingdomBattleHonourBoardPopPanel:onInit")
	self.fields.Panel_bg:setString(i18n("common_text_4658"))
	self.fields.Button_sure:setString(i18n("common_text_204"))
	self.fields.Button_sure:addClickListener(handler(self, self.onClickClose))
end
function kingdomBattleHonourBoardPopPanel:onShow()
	print("=======kingdomBattleHonourBoardPopPanel:onShow")
	if not self.proxy.param or not self.proxy.param.data then
		local _ENV, data = self.proxy.param.data, self.proxy.param.data
	end
	self.fields.Text_time:setString(os.date("%x", data.time))
	self:initComKingdom(self.fields.Com_kingdomL, data.sk, 1)
	self:initComKingdom(self.fields.Com_kingdomR, data.tk, 2)
end
function kingdomBattleHonourBoardPopPanel:initComKingdom(Com_kingdom, data, index)
	local fields = fguiHelper.get_fields(Com_kingdom)
	local controllers = fguiHelper.get_controllers(Com_kingdom)
	fields.Image_city:setURL(kingdomCtrl:getKindomPalaceModelIcon(data.kid))
	fields.Text_name:setString(data.kname)
	_ENV = data.kname
	data.kname.num = string.formatnumberthousands(data.score)
	local scoreStr = i18n("common_text_2556", data.kname)
	fields.Text_score:setString(scoreStr)
	local isWin = data.result == 1
	controllers.c_win:setSelectedIndex(isWin and 0 or 1)
	controllers.c_dir:setSelectedIndex(index == 1 and 0 or 1)
end
return kingdomBattleHonourBoardPopPanel
