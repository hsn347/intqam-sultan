local gametop = gModuleMgr.getObject("gametop")
local romeActivityCtrl = gametop.playertop_:getModule("romeActivityCtrl")
local baseComponent = require("fgui.base.baseComponent")
local Com_level = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RomanSoulNew/Com_level", Com_level)
function Com_level:onInit()
	self.fields.Usm_duipai_1_up:setBlendFunc(gl.ONE, gl.ONE)
	self.fields.Usm_duipai_bottom:setBlendFunc(gl.ONE, gl.ONE)
	self:addClickListener(handler(self, self.onClickLevel))
	self.fields.Usm_duipai_bottom:setPrepareCallback(function()
		local effect = self.fields.Usm_duipai_bottom:getCriSprite()
		effect:setOpacity(0)
		effect:runAction(cca.fadeIn(0.3))
		self.fields.Usm_duipai_bottom:getCriSprite():start()
	end)
	self.fields.Usm_duipai_1_up:setPrepareCallback(function()
		local effect = self.fields.Usm_duipai_1_up:getCriSprite()
		effect:setOpacity(0)
		effect:runAction(cca.fadeIn(0.3))
		self.fields.Usm_duipai_1_up:getCriSprite():start()
	end)
end
function Com_level:initData(index, lvData)
	self.level = index
	self:setDiffEffect()
	_ENV = nil
	;(nil).level = index
	self.fields.Text_level:setString(i18n("common_text_1229", nil))
	local num1 = SoraDConvertNumberWithUnit(lvData[1].needPoint)
	local num2 = SoraDConvertNumberWithUnit(lvData[table.nums(lvData)].needPoint)
	local str = string.format("%s-%s", num1, num2)
	self.fields.Text_needPoint:setString(str)
	self.fields.num:setURL("frame_llzh_nandu" .. index .. ".png")
	_ENV = self.fields.num.setURL
	self.fields.num.setURL.level = index
	self.data, self.fields.num.setURL.itemList = self.fields.num.setURL, lvData
	if index == 10 then
		self.fields.Usm_duipai_1_up:setScale(1.2)
		self.fields.Usm_duipai_bottom:setScale(1.2)
	end
end
function Com_level:onClickLevel()
	_ENV = nil
	local (nil).itemData, param = self.data, nil
	uiManager:show("RomanLevelReward", param):setOwnerKey(self)
end
function Com_level:onClickChallenge()
	_ENV = nil
	local (nil).itemData, param = self.data, nil
	uiManager:show("RomanLevelReward", param):setOwnerKey(self)
end
function Com_level:showEffect()
	self.fields.Text_level:setColor(cc.c3b(140, 130, 89, 1))
	self.fields.Text_needPoint:setColor(cc.c3b(255, 243, 146))
	self.fields.Usm_duipai_1_up:setVisible(true)
	self.fields.Usm_duipai_bottom:setVisible(true)
end
function Com_level:setDiffEffect()
	if self.level ~= romeActivityCtrl.level then
		return
	end
	if gAllianceRomeActivityState.RUNNING ~= romeActivityCtrl.state and gAllianceRomeActivityState.FINISH ~= romeActivityCtrl.state then
		return
	end
	local index = romeActivityCtrl.level - 1
	if 0 <= index and index <= 9 then
		self:showEffect()
	end
end
function Com_level:onShow()
end
return Com_level
