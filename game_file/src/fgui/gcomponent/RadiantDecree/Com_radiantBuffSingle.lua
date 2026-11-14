local cityltCtrl = include("cityltCtrl")
local buildLogic = include("buildLogic")
local buffltCtrl = gModuleMgr.sharedMgr("buffltCtrl")
local buffDesRead = include("buffDesRead")
local baseComponent = require("fgui.base.baseComponent")
local Com_radiantBuffSingle = fgui.extension_class(fgui.GComponent, baseComponent)
fgui.register_extension("ui://RadiantDecree/Com_radiantBuffSingle", Com_radiantBuffSingle)
local radiantDecreeCtrl = SoraDGetCtrl("radiantDecreeCtrl")
function Com_radiantBuffSingle:onInit()
	self.fields.Text_1:fixPos()
	self.fields.Text_2:fixPos()
	self.fields.Text_3:fixPos()
	self.fields.Text_4:fixPos()
	self.fields.Text_5:fixPos()
end
function Com_radiantBuffSingle:onShow()
end
function Com_radiantBuffSingle:initData(lvMin, lvMax, buffID, index, isStatue)
	self.curLv = SoraDGetBuildStarLv()
	local effectType = buffltCtrl:getEffectType(buffID)
	self.controllers.c2:setSelectedIndex(0)
	self.controllers.c1:setSelectedIndex(index % 2)
	local strText1 = string.format("%s-%s", self:getLvStr(lvMin), self:getLvStr(lvMax))
	if isStatue then
		local info = cityltCtrl.getQualityByStarLv(lvMax)
		local quality = info.quality or 1
		strText1 = cityltCtrl.getStatueBraveQualityName(quality)
	end
	self.fields.Text_1:setString(strText1)
	if self.fields.Text_1:getSize().height >= 56 then
		self.fields.Text_1:setAutoSize(fgui.AutoSizeType.SHRINK)
		self.fields.Text_1:setSize(cc.size(137, 56))
	end
	local buffNum1 = buffID[1] and buffltCtrl:getEffect(buffID[1]) or 0
	local buffNum2 = buffID[2] and buffltCtrl:getEffect(buffID[2]) or 0
	local buffNum3 = buffID[3] and buffltCtrl:getEffect(buffID[3]) or 0
	local buffNum4 = buffID[4] and buffltCtrl:getEffect(buffID[4]) or 0
	self.fields.Text_2:setString(buffDesRead.getTitleValueWithValue(effectType, buffNum1 and buffNum1 or 0, true))
	self.fields.Text_3:setString(buffDesRead.getTitleValueWithValue(effectType, buffNum2 and buffNum2 or 0, true))
	self.fields.Text_4:setString(buffDesRead.getTitleValueWithValue(effectType, buffNum3 and buffNum3 or 0, true))
	self.fields.Text_5:setString(buffDesRead.getTitleValueWithValue(effectType, buffNum4 and buffNum4 or 0, true))
end
function Com_radiantBuffSingle:setCurLvState(flag)
	self.controllers.c2:setSelectedIndex(flag and 1 or 0)
end
function Com_radiantBuffSingle:getLvStr(lv)
	return lv .. ""
end
return Com_radiantBuffSingle
