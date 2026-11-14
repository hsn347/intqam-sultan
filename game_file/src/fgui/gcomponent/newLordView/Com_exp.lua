local backpackltCtrl = gModuleMgr.sharedMgr("backpackltCtrl")
local backpackCtrl = SoraDGetCtrl("backpackCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_exp = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://newLordView/Com_exp", Com_exp)
function Com_exp:onInit()
	self.fields.bar:setMax(100)
	self.fields.Button_addExp:addClickListener(handler(self, self.onBtnClick))
	self.fields.Button_max:addClickListener(handler(self, self.onBtnMaxClick))
	self.fields.Button_max:setVisible(false)
	self:fixChildrenPos()
	self.fields.bar:setScaleX(SoraDFIsRA() and -1 or 1)
end
function Com_exp:onShow()
end
function Com_exp:initData(maxValue, curValue)
	self.maxValue = maxValue
	self.curValue = curValue
	self.fields.bar:setValue(curValue * 100 / maxValue)
	_ENV = nil
	;(nil).var1 = curValue
	;(nil).var2 = maxValue
	self.fields.title:setString(i18n("%{var1}/%{var2}", nil))
end
function Com_exp:setFull(isNextMaxLv)
	self.fields.bar:setValue(100)
	self.fields.title:setString("MAX")
	self.fields.Button_max:setVisible(isNextMaxLv)
	self.fields.Button_addExp:setVisible(not isNextMaxLv)
end
function Com_exp:updateAddBtn(isSelf)
	local isHaveItem = false
	local resList = backpackltCtrl:getItemArray(gItemType.LORD_EXP)
	for i, v in ipairs(resList) do
		if backpackCtrl:getItemCount(v) > 0 then
			isHaveItem = true
			break
		end
	end
	if isSelf and self.maxValue ~= self.curValue and isHaveItem then
		self.fields.Button_addExp:setVisible(true)
	else
		self.fields.Button_addExp:setVisible(false)
	end
end
function Com_exp:onBtnClick()
	SoraDPlaySound()
	_ENV = nil
	;(nil).enum = 1
	uiManager:show("lordEXPHPBuyView", nil)
end
function Com_exp:onBtnMaxClick()
	SoraDPlaySound()
	SoraDShowMsgTip(i18n("common_text_4604"))
end
return Com_exp
