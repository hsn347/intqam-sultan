local buildLogic = include("buildLogic")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local buffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://WiseTutor/buffSingle", buffSingle)
function buffSingle:onInit()
	self.fields.Text_1:fixPos()
	self.fields.Text_2:fixPos()
	self.fields.Text_3:fixPos()
end
function buffSingle:onShow()
end
function buffSingle:initData(lvMin, lvMax, buffID, index)
	self.curLv = SoraDGetCastleLv()
	local effectType = buffltCtrl:getEffectType(buffID)
	self.controllers.c2:setSelectedIndex(lvMin <= self.curLv and lvMax >= self.curLv and 0 or 1)
	self.controllers.c1:setSelectedIndex(index % 2)
	local strText1 = string.format("%s-%s", self:getLvStr(lvMin), self:getLvStr(lvMax))
	self.fields.Text_1:setString(strText1)
	if self.fields.Text_1:getSize().height >= 56 then
		self.fields.Text_1:setAutoSize(fgui.AutoSizeType.SHRINK)
		self.fields.Text_1:setSize(cc.size(137, 56))
	end
	local buffNum1 = buffltCtrl:getEffect(buffID[1])
	local buffNum2 = buffltCtrl:getEffect(buffID[2])
	self.fields.Text_2:setString(buffDesRead.getTitleValueWithValue(effectType, buffNum1, true))
	self.fields.Text_3:setString(buffDesRead.getTitleValueWithValue(effectType, buffNum2, true))
end
function buffSingle:getLvStr(lv)
	local isWarLv, warLv, percent = buildLogic.isBuildWarLv(lv)
	if isWarLv then
		if percent == 0 then
			if warLv == 0 then
				return lv
			else
				buildLogic = nil
				;(nil).lv = warLv
				strTip = i18n("common_text_1948", nil)
			end
		else
			buildLogic = nil
			;(nil).lv = warLv .. "(" .. percent * 100 .. "%)"
			strTip = i18n("common_text_1948", nil)
		end
	else
		strTip = lv
	end
	return strTip
end
return buffSingle
