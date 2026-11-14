local iceWolfCastleCtrl = SoraDGetCtrl("iceWolfCastleCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_rankInfo = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://IceGragonCastle/Com_rankInfo", Com_rankInfo)
function Com_rankInfo:onInit()
	_ENV = "common_text_1720"
	;("common_text_1720").u = "true"
	self.fields.text_Detail:setString(SoraDWrapHtmlTagByStyle(i18n("common_text_1720"), "common_text_1720"))
	self.fields.text_Detail:addClickListener(handler(self, self.onClickText))
end
function Com_rankInfo:initData(type)
	self.type = type
	self.fields.text_Title:setString(i18n(type == 1 and "snowwolf_text_06" or "ice_dragon_03"))
	self:updateRankInfo()
end
function Com_rankInfo:updateRankInfo()
	local num = 0
	local rank = 0
	if self.type == 1 then
		num = iceWolfCastleCtrl:getGiveNum()
		rank = iceWolfCastleCtrl:getGiveRank()
	else
		num = iceWolfCastleCtrl:getShiningNum()
		rank = iceWolfCastleCtrl:getShiningRank()
	end
	self.fields.text_Num:setString(string.formatnumberthousands(num))
	if rank <= 0 or 100 < rank then
		self.fields.text_Rank:setString(i18n("common_text_827"))
	else
		iceWolfCastleCtrl = i18n("common_text_827")
		i18n("common_text_827").rank = rank
		self.fields.text_Rank:setString(i18n("common_text_825", i18n("common_text_827")))
	end
end
function Com_rankInfo:onShow()
end
function Com_rankInfo:onClickText(content)
	SoraDPlaySound()
	_ENV = nil
	;(nil).type = self.type
	uiManager:show("iceGragonCastleRank", nil)
end
return Com_rankInfo
