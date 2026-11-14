local resDesRead = include("resDesRead")
local cityCtrl = SoraDGetCtrl("cityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Button_tab = fgui.extension_class(fgui.GButton, baseComponent)
fgui.register_extension("ui://resourceBuy/Button_tab", Button_tab)
function Button_tab:onInit()
	self:addClickListener(handler(self, self.onBtnClick))
	self.fields.title:fixPos()
	self.fields.spRes:fixPos()
end
function Button_tab:onShow()
end
function Button_tab:initData(rid, needResList)
	self.rid = rid
	local resCount = math.floor(cityCtrl:getResCount(self.rid) or 0)
	local resStr = SoraDConvertNumberWithUnit(resCount)
	self.fields.title:setString(resStr)
	self.fields.spRes:setSpriteFrame(resDesRead.getIcon(self.rid))
	if needResList then
		if needResList[self.rid] then
			if resCount < needResList[self.rid].rescount then
				self.fields.title:setColor(cc.c3b(224, 43, 43))
			else
				self.fields.title:setColor(self:isSelected() and cc.c3b(255, 251, 213) or cc.c3b(144, 132, 97))
			end
		elseif 0 < resCount then
			self.fields.title:setColor(self:isSelected() and cc.c3b(255, 251, 213) or cc.c3b(144, 132, 97))
		else
			self.fields.title:setColor(cc.c3b(224, 43, 43))
		end
	elseif 0 < resCount then
		self.fields.title:setColor(self:isSelected() and cc.c3b(255, 251, 213) or cc.c3b(144, 132, 97))
	else
		self.fields.title:setColor(cc.c3b(224, 43, 43))
	end
end
function Button_tab:onBtnClick()
	_ENV = nil
	;(nil).msg = "MESSAGE_RESBUY_TAB_BACK"
	;(nil).rid = self.rid
	SoraDSendMessage(nil)
end
return Button_tab
